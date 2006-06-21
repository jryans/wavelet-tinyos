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
    interface WaveletConfig;
    interface StdControl;
  }
}
implementation {
  #if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char WaveletLevel;
  typedef char WaveletConfData;
  #endif
  
  bool activeRequest = FALSE; // True if a request is in progress
  uint8_t curLevel;
  uint8_t curPackNum;
  uint8_t numLevels;
  uint8_t *nbCount; // Number of neighbors at each level
  
  WaveletLevel *pLevel; // Array of WaveletLevels
  
  msgData repeatMsg; // Message to repeat
  
  void sendAck(msgData msg);
  result_t allocWavelet();
  void freeWavelet();
  void fillWavelet(WaveletConfData *conf);
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
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = WAVELETCONFHEADER;
    msg.data.wConfHeader.numLevels = 0;
    dbg(DBG_USR2, "BigPack: Requesting wavelet config...\n");
    repeatSend(msg, 5000);
    return SUCCESS;
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
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    WaveletConfData *conf;
    switch (msg.type) {
      case WAVELETCONFHEADER: {
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
        break; }
    }   
  }
}
