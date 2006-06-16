/**
 * Translates commands from the Beep interface into start and stop
 * commands to the Sounder.
 * @author Ryan Stinnett
 */
 
module BeepM {
  uses {
    interface Timer;
    interface StdControl as Sounder;
  }
  provides {
    interface StdControl;
    interface Beep;
  }
}

implementation {
  
  enum {
    BEEP_LENGTH = 100
  };
  
  bool playing;
  uint32_t delayLen;
  uint8_t beepsLeft;
  
  task void beepToggle();
  
  /*** Internal Functions and Tasks ***/
  
  task void beepToggle() {
    if (playing) {
      playing = FALSE;
      call Sounder.stop();
      if (beepsLeft > 0)
        call Timer.start(TIMER_ONE_SHOT, delayLen);
    } else {
      beepsLeft--;
      playing = TRUE;
      call Timer.start(TIMER_ONE_SHOT, BEEP_LENGTH);
      call Sounder.start();
    }
  }
  
  /*** Commands and Events ***/
  
  event result_t Timer.fired() {
    post beepToggle();
    return SUCCESS; 
  }
  
  /**
   * Plays a given number of beeps, with a given delay between each.
   */
  command void Beep.play(uint8_t numBeeps, uint32_t delay) {
    delayLen = delay;
    beepsLeft = numBeeps;
    post beepToggle();    
  }
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    call Sounder.init();
    playing = FALSE;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
}
