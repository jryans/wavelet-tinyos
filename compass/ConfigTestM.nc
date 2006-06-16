/**
 * Requests wavelet config data from BigPackM on startup.
 * @author Ryan Stinnett
 */

module ConfigTestM {
  uses interface WaveletConfig;
  uses interface Timer;
  provides interface StdControl;
}
implementation {
 
  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    if (TOS_LOCAL_ADDRESS != 0)
      call Timer.start(TIMER_ONE_SHOT, 1000);
    return SUCCESS;
  }
  
  event result_t Timer.fired() {
    call WaveletConfig.getConfig();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  event result_t WaveletConfig.configDone(WaveletLevel *configData, uint8_t numLevels, result_t result) {
    return SUCCESS;
  }
}
