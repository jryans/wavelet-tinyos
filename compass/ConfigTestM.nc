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
 
  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }
  
  event result_t Timer.fired() {
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 2;
    msg.type = 20;
    call Message.send(msg);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
   
  event void MoteOptions.diag(bool state) {
    if (state) {
      call Timer.start(TIMER_REPEAT, 10);
    } else {
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
