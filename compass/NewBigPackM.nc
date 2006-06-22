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
  
  int8_t *mainBlock;
  BigPackBlock block[2];
  BigPackPtr ptr[1];
  
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
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = BIGPACKHEADER;
    msg.data.bpHeader.requestType = type;
    repeatSend(msg, 5000);
  }
  
  /*** Internal Helpers ***/
  
  /**
   * Sends standard ACK by returning the message that was sent
   */
  void sendAck(msgData msg) {
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    repeatSend(msg, 3000); 
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
    uint16_t offset = 0;
    uint8_t b, i;
    int8_t **tmp;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate and fill each block
    for (b = 0; b < 2; b++) {
      dbg(DBG_USR2, "BigPack: Block #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Length: %i\n", block[b].length);
      if ((blockAddr[b] = malloc(block[b].length)) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block %i!\n", b);
        return;
      }
      dbg(DBG_USR2, "BigPack:   Addr:  %p\n", (void *)blockAddr[b]);
      dbg(DBG_USR2, "BigPack:   Bytes\n");
      for (i = 0; i < block[b].length; i++) {
        blockAddr[b][i] = bigData[offset + i];
        dbg(DBG_USR2, "BigPack:     Byte %i: %i\n", i + 1, blockAddr[b][i]);
      }
      offset += block[b].length;
    }
    // Recreate each pointer needed
    for (b = 0; b < 1; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block : %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block    : %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset   : %i\n", ptr[b].destOffset);
      dbg(DBG_USR2, "BigPack:   Source Addr   : %p\n", (void *)blockAddr[ptr[b].addrOfBlock]);
      tmp = &blockAddr[ptr[b].destBlock][ptr[b].destOffset];
      *tmp = blockAddr[ptr[b].addrOfBlock];
      dbg(DBG_USR2, "BigPack:   Ptr Value     : %p\n", (void *)*tmp);
    }
    mainBlock = blockAddr[0];
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
    WaveletConfData *conf;
    switch (msg.type) {
    case BIGPACKHEADER: {
      // Turn off message repeat
      call MsgRepeat.stop();
      // Store header data
      dbg(DBG_USR2, "BigPack: Rcvd bigPack header\n");
      numPacks = msg.data.bpHeader.packTotal;
      numBytes = msg.data.bpHeader.byteTotal;
      if ((bigData = malloc(numBytes)) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
        return;
      } 
      curPackNum = 0;
      // Store block and pointer info
      block[0] = msg.data.bpHeader.block[0];
      block[1] = msg.data.bpHeader.block[1];
      ptr[0] = msg.data.bpHeader.ptr[0];
      // Send an ACK
      sendAck(msg);
      break; }
    case BIGPACKDATA: {
      if (curPackNum == msg.data.bpData.curPack) {
        uint8_t offset, i;
        // Turn off message repeat
        call MsgRepeat.stop();
        // Store pack data
        offset = curPackNum * BP_DATA_LEN;
        for (i = 0; i < BP_DATA_LEN; i++) {
          bigData[offset + i] = msg.data.bpData.data[i];
        }
        if (++curPackNum == numPacks) {
          rebuildBlocks();
          displayData();
        }
      }
      break; }
    /*  case WAVELETCONFHEADER: {
        // Turn off message repeat        
        call MsgRepeat.stop();
        // Store basic config parameters
        activeRequest = TRUE;
        numLevels = msg.data.wConfHeader.numLevels;
        if ((nbCount = malloc(numLevels * sizeof(uint8_t))) == NULL) {
#ifdef BEEP
          call Beep.play(3, 250);
#endif
          dbg(DBG_USR2, "BigPack: Couldn't allocate nbCount!\n");
          return;
        }
        memcpy(nbCount, msg.data.wConfHeader.nbCount, numLevels * sizeof(uint8_t));
        curLevel = 0;
        curPackNum = 0;
        dbg(DBG_USR2, "BigPack: Rcvd wavelet config header\n");
        if (allocWavelet() == FAIL) {
          dbg(DBG_USR2, "BigPack: Couldn't allocate wavelet config!\n"); 
          return;
        }
        sendAck(msg);
        break; } 
      case WAVELETCONFDATA: {
        if (activeRequest) {
          // Turn off message repeat
          call MsgRepeat.stop();
          // Store new config data
          conf = &msg.data.wConfData;
          if ((curLevel == conf->level) && (curPackNum == conf->packNum)) {
            dbg(DBG_USR2, "BigPack: Rcvd wavelet level %i pack %i\n", 
                conf->level, conf->packNum);
            fillWavelet(conf);
            sendAck(msg);
            if ((curLevel == 0) && (curPackNum == 0)) { // Done!
              call MsgRepeat.stop();
              activeRequest = FALSE;
              dbg(DBG_USR2, "BigPack: Wavelet config complete\n");
              signal WaveletConfig.configDone(pLevel, numLevels, SUCCESS);              
            }
          }
        }
        break; } */
    }   
  }
}
