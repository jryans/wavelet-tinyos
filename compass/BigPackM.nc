/**
 * Requests and rebuilds multi-packet data structures.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
module BigPackM {
  uses {
    interface Message;
    interface MemAlloc;
  }
  provides {
    interface WaveletConfig;
    interface StdControl;
  }
}
implementation {
  #if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  #endif
  
  bool activeRequest = FALSE; // True if a request is in progress
  uint8_t curLevel;
  uint8_t curMoteIndex;
  uint8_t numLevels;
  
  /*** WaveletConfig ***/
  
  /**
   * Requests wavelet configuration data, such as our
   * neighbors and their coefficients.
   */
  command result_t WaveletConfig.getConfig() {
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = WAVELETCONFIGHEADER;
    dbg(DBG_USR1, "BigPack: Requesting wavelet configuration...");
    return call Message.send(msg);
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
      case WAVELETCONFIGHEADER: {
        if (result == FAIL) {
          dbg(DBG_USR1, "BigPack: Wavelet configuration request failed!");
        }
        break; }
    }
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event result_t Message.receive(msgData msg) {
    switch (msg.type) {
      case WAVELETCONFIGHEADER: {
        activeRequest = TRUE;
        numLevels = msg.data.wConfigHeader.
        break; }
    }   
    return SUCCESS;
  }

  event result_t MemAlloc.allocComplete(HandlePtr param0, result_t param1) {
    return SUCCESS;
  }

  event result_t MemAlloc.reallocComplete(Handle param0, result_t param1) {
    return SUCCESS;
  }

  event result_t MemAlloc.compactComplete() {
    return SUCCESS;
  }

  
}