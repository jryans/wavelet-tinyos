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
    interface StdControl;
  }
}
implementation {
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char WaveletLevel;
  typedef char WaveletConfData;
  typedef char ExtWaveletLevel;
  typedef char BigPackBlock;
  typedef char BigPackPtr;
#endif
  
  bool activeRequest = FALSE; // True if a request is in progress
  uint8_t curLevel;

  uint8_t numLevels;
  uint8_t *nbCount; // Number of neighbors at each level
  
  WaveletLevel *pLevel; // Array of WaveletLevels
  
  
  result_t allocWavelet();
  void freeWavelet();
  void fillWavelet(WaveletConfData *conf);
  void requestData(uint8_t type);
  
  /*** New Stuff ***/
  
  uint8_t numPacks;
  uint8_t curPackNum;
  uint8_t numBytes;
  int8_t *bigData;
  bool bdAlloc = FALSE;
  
  int8_t *mainBlock;
  BigPackBlock block[MAX_BLOCKS];
  BigPackPtr ptr[MAX_PTRS];
  
  msgData repeatMsg; // Message to repeat
  
  void sendAck(msgData msg);
  void repeatSend(msgData msg, uint16_t bms);
  
  /*** Timers ***/
  
  /**
   * Helper function for repeating a message until get a response
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
   * Allocates an empty array of WaveletLevels
   */
  result_t allocWavelet() {
    uint8_t level;
    if ((pLevel = malloc(numLevels * sizeof(WaveletLevel))) == NULL) {
#ifdef BEEP
      call Beep.play(1, 250);
#endif
      return FAIL;
    }
    for (level = 0; level < numLevels; level++) {
      pLevel[level].nbCount = nbCount[level];
      if ((pLevel[level].nb = 
           malloc(nbCount[level] * sizeof(WaveletNeighbor)))
          == NULL) {
#ifdef BEEP
        call Beep.play(2, 250);
#endif
        return FAIL;
    }
    }
    return SUCCESS;
  }
  
  /**
   * Free an array of WaveletLevels.
   */ 
  void freeWavelet() {
    uint8_t level;
    for (level = 0; level < numLevels; level++)
      free(pLevel[level].nb); 
    free(pLevel);
    free(nbCount);
  }
  
  /**
   * Copies the received mote info into our WaveletLevel array and
   * advances curLevel and curPackNum.
   */ 
  void fillWavelet(WaveletConfData *conf) {
    uint8_t mote;
    WaveletNeighbor *pNB;
    for (mote = 0; mote < conf->moteCount; mote++) {
      pNB = &pLevel[curLevel].nb[curPackNum * WT_MOTE_PER_CONFDATA + mote];
      pNB->id = conf->moteConf[mote].id;
      pNB->coeff = conf->moteConf[mote].coeff;
      pNB->state = conf->moteConf[mote].state;
    }
    if (++curPackNum * WT_MOTE_PER_CONFDATA >= nbCount[curLevel]) {
      curPackNum = 0;
      if (++curLevel >= numLevels)
        curLevel = 0; // Done!
    }
  }
   
  /*** Other Commands and Events ***/
  
  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
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
    int8_t *blockAddr[2];
    uint16_t start;
    uint8_t b, i;
    int8_t **tmp;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate and fill each block
    for (b = 0; b < MAX_BLOCKS; b++) {
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
    // Free bigData
    if (bdAlloc) {
      free(bigData);
      bdAlloc = FALSE;
    }
    // Recreate each pointer needed
    for (b = 0; b < MAX_PTRS; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block : %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block    : %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset   : %i\n", ptr[b].destOffset);
      dbg(DBG_USR2, "BigPack:   Source Addr   : %p\n", (void *)blockAddr[ptr[b].addrOfBlock]);
      tmp = &blockAddr[ptr[b].destBlock][ptr[b].destOffset];
      *tmp = blockAddr[ptr[b].addrOfBlock];
      dbg(DBG_USR2, "BigPack:   Ptr Value     : %p\n", (void *)*tmp);
    }
  }
  
  void displayData() {
    uint8_t i;
    ExtWaveletLevel *lvl = (ExtWaveletLevel *) mainBlock;
    dbg(DBG_USR2, "BigPack: Wavelet Level Test\n");
    dbg(DBG_USR2, "BigPack: nbCount = %i\n", lvl->nbCount);
    for (i = 0; i < lvl->nbCount; i++) {
      dbg(DBG_USR2, "BigPack: Neighbor #%i\n", i + 1);
      dbg(DBG_USR2, "BigPack: id = %i, state = %i, coeff = %i\n", lvl->nb[i].id,
          lvl->nb[i].state, lvl->nb[i].coeff);
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
      if (!bdAlloc) {
        uint8_t i;
        // Turn off message repeat
        call MsgRepeat.stop();
        // Store header data
        numPacks = msg.data.bpHeader.packTotal;
        numBytes = msg.data.bpHeader.byteTotal;
        dbg(DBG_USR2, "BigPack: Rcvd BP header (0/%i)\n", numPacks);
        if ((bigData = malloc(numBytes)) == NULL) {
          dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
          return;
        } 
        bdAlloc = TRUE;
        curPackNum = 0;
        // Store block and pointer info
		for (i = 0; i < MAX_BLOCKS; i++) 
	      block[i] = msg.data.bpHeader.block[i];
		for (i = 0; i < MAX_PTRS; i++)
		  ptr[i] = msg.data.bpHeader.ptr[i];
        // Send an ACK
        sendAck(msg);
      }
      break; }
    case BIGPACKDATA: {
      if (curPackNum == msg.data.bpData.curPack) {
        uint8_t offset, i;
        // Turn off message repeat
        call MsgRepeat.stop();
        dbg(DBG_USR2, "BigPack: Rcvd BP data (%i/%i)\n", curPackNum + 1, numPacks);
        // Store pack data
        offset = curPackNum * BP_DATA_LEN;
        if (++curPackNum == numPacks) { 
          // Last pack is shorter than others
          for (i = 0; (offset + i) < numBytes; i++)
            bigData[offset + i] = msg.data.bpData.data[i];
          rebuildBlocks();
          displayData(); // Done!
          // Send data back and go unactive
          //activeRequest = FALSE;
          dbg(DBG_USR2, "BigPack: BP data complete\n");
          signal WaveletConfig.configDone(pLevel, numLevels, SUCCESS);
        } else {
          // All other packs use up the entire data length
          for (i = 0; i < BP_DATA_LEN; i++)
            bigData[offset + i] = msg.data.bpData.data[i];
        }
        // Send an ACK
        sendAck(msg);
      }
      break; }
    }   
  }
}
