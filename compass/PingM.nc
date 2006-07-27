/**
 * Broadcasts ping messages for diagnostic purposes.
 * @author Ryan Stinnett
 */
 
includes Ping;
includes AM;
includes MessageData;
 
module PingM {
  uses {
    interface Timer;
    interface Transceiver as PingTrans;
    interface Message as PingMsg;
  }
  provides {
    interface PingB;
  }
}
implementation {
  
  bool trans;
  uint16_t numLeft;
  msgData md;
  TOS_MsgPtr tmpPtr;
  
  result_t sendPingTrans(uint16_t pingNum) {
    PingData *msg;
    if ((tmpPtr = call PingTrans.requestWrite()) == NULL)
      return FAIL;
    msg = (PingData *) tmpPtr->data;
    msg->seqNum = pingNum;
    if (call PingTrans.sendRadio(TOS_BCAST_ADDR, sizeof(PingData)) == FAIL)
      return FAIL;
    return SUCCESS;
  }
  
  /*** PingB ***/
  
  command void PingB.send(uint16_t num) {
    numLeft = num;
    trans = TRUE;
    call Timer.start(TIMER_REPEAT, PING_INTERVAL);
  }
  
  command void PingB.sendTo(uint16_t num, uint16_t mDest, uint8_t rRet) {
    numLeft = num;
    md.src = TOS_LOCAL_ADDRESS;
    md.dest = mDest;
    md.type = 20;
    trans = FALSE;
    call Timer.start(TIMER_REPEAT, PING_INTERVAL * rRet);
  }
  
  /*** Timer ***/
  
  event result_t Timer.fired() {
    if (numLeft > 0) {
      if (trans) {
        if (sendPingTrans(numLeft) == FAIL) {
          dbg(DBG_USR2, "Ping: Unable to send message!");
        }
      } else {
        call PingMsg.send(md); 
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
  event result_t PingTrans.radioSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * A message was sent over UART.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t PingTrans.uartSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * Received a message over the radio
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr PingTrans.receiveRadio(TOS_MsgPtr m) {
    return m;
  }
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr PingTrans.receiveUart(TOS_MsgPtr m) {
    return m;
  }
  
  /*** PingMsg ***/
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t PingMsg.sendDone(msgData msg, result_t result, uint8_t retries) {
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void PingMsg.receive(msgData msg) {}
  
}