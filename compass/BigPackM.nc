/**
 * Requests and rebuilds multi-packet data structures.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
module BigPackM {
  uses {
    interface Message;
    interface Timer as MsgRepeat;
#ifdef BEEP
    interface Beep;
#endif
  }
  provides {
    interface BigPack;
    interface StdControl;
  }
}
implementation {
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char BigPackBlock;
  typedef char BigPackPtr;
#endif

  /*** Variables and Function Prototypes ***/
  
  uint8_t numPacks;
  uint8_t curPackNum;
  uint8_t numBytes;
  int8_t *bigData;
  bool bdAlloc = FALSE;
  
  BigPackBlock *block;
  uint8_t numBlocks[BP_MAX_REQUESTS];
  bool bpbAlloc = FALSE;
  
  BigPackPtr *ptr;
  uint8_t numPtrs;
  bool bppAlloc = FALSE;
  
  uint8_t curReqNum;
  bool activeRequest = FALSE; // True if a request is in progress
  msgData repeatMsg; // Message to repeat
  
  int8_t **blockAddr[BP_MAX_REQUESTS];
  int8_t *mainBlock[BP_MAX_REQUESTS];
  
  result_t allocTemp();
  void freeTemp();
  void requestData(uint8_t type);
  void sendAck(msgData msg);
  void repeatSend(msgData msg, uint16_t bms);
  void rebuildBlocks();
  
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
  
  /*** StdControl ***/
  
  command result_t StdControl.init() 
  {
    uint8_t i;
    for (i = 0; i < BP_MAX_REQUESTS; i++)
      mainBlock[i] = NULL;
    return SUCCESS;
  }
  
  command result_t StdControl.start() 
  {
    return SUCCESS;
  }
  
  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
  
  /*** BigPack ***/
  
  /**
   * Requests big pack data of a certain type.  If another request is already being
   * processed, this will return FAIL and do nothing.  Otherwise, it returns SUCCESS
   * and begins the request.
   */
  command result_t BigPack.request(uint8_t type) {
    uint8_t i;
    if (activeRequest)
      return FAIL;
    // Look for an available request slot
    for (i = 0; i < BP_MAX_REQUESTS; i++) {
      if (mainBlock[i] == NULL)
        break;
    }
    if (i < BP_MAX_REQUESTS) {
      msgData msg;
      curReqNum = i;
      mainBlock[i] = (int8_t *) 1122; // Just so it's not NULL
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.type = BIGPACKHEADER;
      msg.data.bpHeader.requestType = type;
      msg.data.bpHeader.packTotal = 0;
      activeRequest = TRUE;
      repeatSend(msg, 5000);
    } else {
      return FAIL;
    }
    return SUCCESS;
  }
  
  /**
   * When an application is done with the data, it must call free.
   */
  command void BigPack.free(int8_t *mb) {
    uint8_t i, b;
    // Find the request to free
    for (i = 0; i < BP_MAX_REQUESTS; i++) {
      if (mainBlock[i] == mb)
        break; 
    }
    // If found, then free the memory
    if (i < BP_MAX_REQUESTS) {
      for (b = 0; b < numBlocks[i]; b++)
        free(blockAddr[i][b]);
      free(blockAddr[i]);
      mainBlock[i] = NULL;
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
    uint16_t bpbSize = numBlocks[curReqNum] * sizeof(BigPackBlock);
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
      case BIGPACKHEADER: {
        if (result == FAIL) {
          dbg(DBG_USR2, "BigPack: BP header request failed!\n");
        }
        break; }
    }
    return SUCCESS;
  }
  
  void rebuildBlocks() {
    uint16_t start;
    uint8_t b, i;
    int8_t **tmp, **bStore;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate block address space
    if ((blockAddr[curReqNum] = malloc(numBlocks[curReqNum] * sizeof(int8_t *))) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block address array for request %i!\n", 
            curReqNum + 1);
        return;
    }
    bStore = blockAddr[curReqNum];
    // Allocate and fill each block
    for (b = 0; b < numBlocks[curReqNum]; b++) {
      start = block[b].start;
      dbg(DBG_USR2, "BigPack: Block #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Start:  %i\n", start);
      dbg(DBG_USR2, "BigPack:   Length: %i\n", block[b].length);
      if ((bStore[b] = malloc(block[b].length)) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block %i!\n", b);
        return;
      }
      dbg(DBG_USR2, "BigPack:   Addr:  %p\n", (void *)bStore[b]);
      dbg(DBG_USR2, "BigPack:   Bytes\n");
      for (i = 0; i < block[b].length; i++) {
        bStore[b][i] = bigData[start + i];
        dbg(DBG_USR2, "BigPack:     Byte %i: %i\n", i + 1, bStore[b][i]);
      }
    }
    // Main block is the last block
    mainBlock[curReqNum] = bStore[b - 1];
    // Recreate each pointer needed
    for (b = 0; b < numPtrs; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block: %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block:    %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      tmp = &bStore[ptr[b].destBlock][ptr[b].destOffset];
      if (ptr[b].blockArray) {
        dbg(DBG_USR2, "BigPack:   Block Array:   Yes\n");
        *tmp = &bStore[ptr[b].addrOfBlock];
      } else {
        dbg(DBG_USR2, "BigPack:   Block Array:   No\n");
        *tmp = bStore[ptr[b].addrOfBlock];
      }
      dbg(DBG_USR2, "BigPack:   Ptr Value:     %p\n", (void *)*tmp);
    }
    // Free temp data
    freeTemp();
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
        numBlocks[curReqNum] = msg.data.bpHeader.numBlocks;
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
          ptr_offset = blk_offset - numBlocks[curReqNum] * sizeof(BigPackBlock);
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
          signal BigPack.requestDone(mainBlock[curReqNum], SUCCESS);
          activeRequest = FALSE;
        }
        // Send an ACK
        sendAck(msg);
      }
      break; }
    }   
  }
}
