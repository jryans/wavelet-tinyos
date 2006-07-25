/**
 * Broadcasts ping messages for diagnostic purposes.
 * @author Ryan Stinnett
 */
 
includes Ping;
includes AM;
 
module PingM {
  uses {
    interface Timer;
    interface Transceiver as Ping;
  }
  provides {
    interface PingB;
  }
}
implementation {
  
  uint16_t numLeft;
  TOS_MsgPtr tmpPtr;
  
  result_t sendPing(uint16_t pingNum) {
    PingMsg *msg;
    if ((tmpPtr = call Ping.requestWrite()) == NULL)
      return FAIL;
    msg = (PingMsg *) tmpPtr->data;
    msg->seqNum = pingNum;
    if (call Ping.sendRadio(TOS_BCAST_ADDR, sizeof(PingMsg)) == FAIL)
      return FAIL;
    return SUCCESS;
  }
  
  /*** PingB ***/
  
  command void PingB.send(uint16_t num) {
    numLeft = num;
    call Timer.start(TIMER_REPEAT, PING_INTERVAL);
  }
  
  /*** Timer ***/
  
  event result_t Timer.fired() {
    if (numLeft > 0) {
      if (sendPing(numLeft) == FAIL) {
        dbg(DBG_USR2, "Ping: Unable to send message!");
      }
      numLeft--;
    } else {
      call Timer.stop();
    }
    return SUCCESS;
  }
  
  /*** PingMsg ***/
  
  /**
   * A message was sent over radio.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t Ping.radioSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * A message was sent over UART.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t Ping.uartSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * Received a message over the radio
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr Ping.receiveRadio(TOS_MsgPtr m) {
    return m;
  }
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr Ping.receiveUart(TOS_MsgPtr m) {
    return m;
  }
  
}
