/**
 * Requests and rebuilds multi-packet data structures.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
module NewBigPackM {
  uses {
    interface Message;
    interface Timer as MsgRepeat;
#ifdef BEEP
    interface Beep;
#endif
  }
  provides {
    interface WaveletConfig;
  }
}
implementation {
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char ExtWaveletLevel;
  typedef char NewWaveletConf;
  typedef char BigPackBlock;
  typedef char BigPackPtr;
#endif

  /*** Variables and Function Prototypes ***/
  
  uint8_t numPacks;
  uint8_t curPackNum;
  uint8_t numBytes;
  int8_t *bigData;
  bool bdAlloc = FALSE;
  
  int8_t *mainBlock;
  
  BigPackBlock *block;
  uint8_t numBlocks;
  bool bpbAlloc = FALSE;
  
  BigPackPtr *ptr;
  uint8_t numPtrs;
  bool bppAlloc = FALSE;
  
  bool activeRequest = FALSE; // True if a request is in progress
  msgData repeatMsg; // Message to repeat
  
  result_t allocTemp();
  void freeTemp();
  void requestData(uint8_t type);
  void sendAck(msgData msg);
  void repeatSend(msgData msg, uint16_t bms);
  
  /*** Timers ***/
  
  /**
   * Helper function for repeating a message until we get a response
   */ 
  void repeatSend(msgData msg, uint16_t bms) {
    repeatMsg = msg;
    call Message.send(msg);
    call MsgRepeat.start(TIMER_REPEAT, bms);
  }
  
  /**
   * Sends the saved message again
   */
  event result_t MsgRepeat.fired() {
    call Message.send(repeatMsg);
    return SUCCESS;
  }  
  
  /*** WaveletConfig ***/
  
  /**
   * Requests wavelet configuration data, such as our
   * neighbors and their coefficients.
   */
  command result_t WaveletConfig.getConfig() {
//    msgData msg;
//    msg.src = TOS_LOCAL_ADDRESS;
//    msg.dest = 0;
//    msg.type = WAVELETCONFHEADER;
//    msg.data.wConfHeader.numLevels = 0;
//    dbg(DBG_USR2, "BigPack: Requesting wavelet config...\n");
//    repeatSend(msg, 5000);
    requestData(WAVELETCONF);
    return SUCCESS;
  }
  
  void requestData(uint8_t type) {
    if (!activeRequest) {
      msgData msg;
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.type = BIGPACKHEADER;
      msg.data.bpHeader.requestType = type;
      activeRequest = TRUE;
      repeatSend(msg, 5000);
    }
  }
  
  /*** Internal Helpers ***/
  
  /**
   * Sends standard ACK by returning the message that was sent
   */
  void sendAck(msgData msg) {
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    //repeatSend(msg, 3000); 
    call Message.send(msg);
  }
  
  /**
   * Allocates temporary data used to rebuild an incoming
   * struct.
   */
  result_t allocTemp() {
    uint16_t bpbSize = numBlocks * sizeof(BigPackBlock);
    uint16_t bppSize = numPtrs * sizeof(BigPackPtr);
    if ((bigData = malloc(numBytes - bpbSize - bppSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
      return FAIL;
    } 
    bdAlloc = TRUE;
    if ((block = malloc(bpbSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate block!\n");
      return FAIL;
    } 
    bpbAlloc = TRUE;
    if ((ptr = malloc(bppSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate ptr!\n");
      return FAIL;
    } 
    bppAlloc = TRUE;
    return SUCCESS;
  }
  
  /**
   * Free the temp data.
   */ 
  void freeTemp() {
    if (bdAlloc) {
      free(bigData);
      bdAlloc = FALSE;
    }
    if (bpbAlloc) {
      free(block);
      bpbAlloc = FALSE;
    }
    if (bppAlloc) {
      free(ptr);
      bppAlloc = FALSE;
    }
  }
   
  /*** Other Commands and Events ***/
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result) {
    switch (msg.type) {
      case WAVELETCONFHEADER: {
        if (result == FAIL) {
          dbg(DBG_USR2, "BigPack: Wavelet config request failed!\n");
        }
        break; }
    }
    return SUCCESS;
  }
  
  void rebuildBlocks() {
    int8_t *blockAddr[numBlocks];
    uint16_t start;
    uint8_t b, i;
    int8_t **tmp;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate and fill each block
    for (b = 0; b < numBlocks; b++) {
      start = block[b].start;
      dbg(DBG_USR2, "BigPack: Block #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Start:  %i\n", start);
      dbg(DBG_USR2, "BigPack:   Length: %i\n", block[b].length);
      if ((blockAddr[b] = malloc(block[b].length)) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block %i!\n", b);
        return;
      }
      dbg(DBG_USR2, "BigPack:   Addr:  %p\n", (void *)blockAddr[b]);
      dbg(DBG_USR2, "BigPack:   Bytes\n");
      for (i = 0; i < block[b].length; i++) {
        blockAddr[b][i] = bigData[start + i];
        dbg(DBG_USR2, "BigPack:     Byte %i: %i\n", i + 1, blockAddr[b][i]);
      }
    }
    // Main block is the last block
    mainBlock = blockAddr[b - 1];
    // Recreate each pointer needed
    for (b = 0; b < numPtrs; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block: %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block:    %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      dbg(DBG_USR2, "BigPack:   Source Addr:   %p\n", (void *)blockAddr[ptr[b].addrOfBlock]);
      tmp = &blockAddr[ptr[b].destBlock][ptr[b].destOffset];
      *tmp = blockAddr[ptr[b].addrOfBlock];
      dbg(DBG_USR2, "BigPack:   Ptr Value:     %p\n", (void *)*tmp);
    }
    // Free temp data
    freeTemp();
  }
  
  void displayData() {
    uint8_t i, l;
    NewWaveletConf *bob = (NewWaveletConf *) mainBlock;
    ExtWaveletLevel *lvl = bob->level;
    dbg(DBG_USR2, "BigPack: Wavelet Config Test\n");
    for (l = 0; l < bob->numLevels; l++) {
      dbg(DBG_USR2, "BigPack: Level #%i\n", l + 1);
      for (i = 0; i < lvl[l].nbCount; i++) {
        dbg(DBG_USR2, "BigPack:   Neighbor #%i\n", i + 1);
        dbg(DBG_USR2, "BigPack:     ID:    %i\n", lvl[l].nb[i].id);
        dbg(DBG_USR2, "BigPack:     State: %i\n", lvl[l].nb[i].state);
        dbg(DBG_USR2, "BigPack:     Coeff: %f\n", lvl[l].nb[i].coeff);
      }
    }
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    if (!activeRequest)
      return;
    switch (msg.type) {
    case BIGPACKHEADER: {
      if (!bdAlloc && !bpbAlloc && !bppAlloc) {
        // Turn off message repeat
        call MsgRepeat.stop();
        // Store header data
        numPacks = msg.data.bpHeader.packTotal;
        numBytes = msg.data.bpHeader.byteTotal;
        numBlocks = msg.data.bpHeader.numBlocks;
        numPtrs = msg.data.bpHeader.numPtrs;
        dbg(DBG_USR2, "BigPack: Rcvd BP header (0/%i)\n", numPacks);
        // Allocate temporary arrays
        if (allocTemp() == FAIL) return;
        curPackNum = 0;
        // Send an ACK
        sendAck(msg);
      }
      break; }
    case BIGPACKDATA: {
      if (curPackNum == msg.data.bpData.curPack) {
        uint8_t i;
        int16_t base_offset, blk_offset, ptr_offset, data_offset, stopAt;
        // Byte level access to block and data
        int8_t *tmpBlk = (int8_t *)block; 
        int8_t *tmpPtr = (int8_t *)ptr;
        // Turn off message repeat
        call MsgRepeat.stop();
        dbg(DBG_USR2, "BigPack: Rcvd BP data (%i/%i)\n", curPackNum + 1, numPacks);
        // Calculate offsets
        base_offset = curPackNum * BP_DATA_LEN;
        (++curPackNum == numPacks) ? (stopAt = numBytes - base_offset)
                                   : (stopAt = BP_DATA_LEN);
        // Store pack data
        for (i = 0; i < stopAt; i++) {
          blk_offset = base_offset + i;
          ptr_offset = blk_offset - numBlocks * sizeof(BigPackBlock);
          data_offset = ptr_offset - numPtrs * sizeof(BigPackPtr);
          if (data_offset >= 0) { // Byte is data
            bigData[data_offset] = msg.data.bpData.data[i];
          } else if (ptr_offset >= 0) { // Byte is pointer data
            tmpPtr[ptr_offset] = msg.data.bpData.data[i];
          } else { // Byte is block data
            tmpBlk[blk_offset] = msg.data.bpData.data[i];
          }
        }
        if (curPackNum == numPacks) { 
          rebuildBlocks();
          dbg(DBG_USR2, "BigPack: BP data complete\n");
          displayData(); // Done!
          //signal WaveletConfig.configDone(pLevel, numLevels, SUCCESS);
          activeRequest = FALSE;
        }
        // Send an ACK
        sendAck(msg);
      }
      break; }
    }   
  }
}
