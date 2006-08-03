/**
 * Tries to send packets as fast as possible.
 * @author Ryan Stinnett
 */
 
includes MessageData;

module ConfigTestM {
  uses {
    interface Message;
    interface Timer;
    interface MoteOptions;
  }
  provides interface StdControl;
}
implementation {
  
  //bool go = FALSE;
 
  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }
  
  event result_t Timer.fired() {
    msgData msg;
    msg.dest = 2;
    msg.type = 20;
    //while (go) {
    call Message.send(msg);// }
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
   
  event void MoteOptions.diag(bool state) {
    if (state) {
      //go = TRUE;
      //call Timer.start(TIMER_ONE_SHOT, 100);
      call Timer.start(TIMER_REPEAT, 5);
    } else {
      //go = FALSE;
      call Timer.stop();
    }
  }
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {}
 
}
