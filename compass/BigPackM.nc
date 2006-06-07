/**
 * Requests and rebuilds multi-packet data structures.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
module BigPackM {
  uses {
    interface Message;
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
  
  static void sendAck(msgData msg);
  static result_t allocWavelet();
  static void freeWavelet();
  static void fillWavelet(WaveletConfData *conf);
  
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
    dbg(DBG_USR1, "BigPack: Requesting wavelet config...\n");
    return call Message.send(msg);
  }
  
  /*** Internal Helpers ***/
  
  /**
   * Sends standard ACK by returning the message that was sent
   */
  static void sendAck(msgData msg) {
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    call Message.send(msg); 
  }
  
  /**
   * Allocates an empty array of WaveletLevels
   */
  static result_t allocWavelet() {
    uint8_t level;
    if ((pLevel = malloc(numLevels * sizeof(WaveletLevel))) == NULL)
      return FAIL;
    for (level = 0; level < numLevels; level++) {
      pLevel[level].nbCount = nbCount[level];
      if ((pLevel[level].nb = 
           malloc(nbCount[level] * sizeof(WaveletNeighbor)))
          == NULL)
        return FAIL;
    }
    return SUCCESS;
  }
  
  /**
   * Free an array of WaveletLevels.
   */ 
  static void freeWavelet() {
    uint8_t level;
    for (level = 0; level < numLevels; level++)
      free(pLevel[level].nb); 
    free(pLevel);
  }
  
  /**
   * Copies the received mote info into our WaveletLevel array and
   * advances curLevel and curPackNum.
   */ 
  static void fillWavelet(WaveletConfData *conf) {
    uint8_t mote;
    for (mote = 0; mote < conf->moteCount; mote++)
      memcpy(&pLevel[curLevel].nb[curPackNum * 3 + mote].info, 
             &conf->info[mote], sizeof(MoteInfo));
    if (++curPackNum * 3 >= nbCount[curLevel]) {
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
          dbg(DBG_USR1, "BigPack: Wavelet config request failed!\n");
        }
        break; }
    }
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event result_t Message.receive(msgData msg) {
    WaveletConfData *conf;
    switch (msg.type) {
      case WAVELETCONFHEADER: {
        activeRequest = TRUE;
        numLevels = msg.data.wConfHeader.numLevels;
        // <FREE ME!>
        if ((nbCount = malloc(numLevels * sizeof(uint8_t))) == NULL)
          dbg(DBG_USR1, "BigPack: Couldn't allocate nbCount!\n");
        // </FREE ME!>
        memcpy(nbCount, msg.data.wConfHeader.nbCount, numLevels * sizeof(uint8_t));
        curLevel = 0;
        curPackNum = 0;
        dbg(DBG_USR1, "BigPack: Rcvd wavelet config header\n");
        allocWavelet();
        sendAck(msg);
        break; }
      case WAVELETCONFDATA: {
        if (activeRequest) {
          conf = &msg.data.wConfData;
          if ((curLevel == conf->level) && (curPackNum == conf->packNum)) {
            dbg(DBG_USR1, "BigPack: Rcvd wavelet level %i pack %i\n", 
                conf->level, conf->packNum);
            fillWavelet(conf);
            sendAck(msg);
            if ((curLevel == 0) && (curPackNum == 0)) { // Done!
              activeRequest = FALSE;
              dbg(DBG_USR1, "BigPack: Wavelet config complete\n");
              signal WaveletConfig.configDone(pLevel, numLevels, SUCCESS);              
            }
          }
        }
        break; }
    }   
    return SUCCESS;
  }
}
