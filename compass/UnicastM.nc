/**
 * Sends and receives unicast packets via the UART and the Radio.  Requires a
 * routing component that can fill in details of how to get from on mote to
 * another.  Supports retrying failed radio messages.
 * @author Ryan Stinnett
 */

includes AM;
includes IOPack;

module UnicastM {
  provides {
    interface Message;
    interface StdControl;
  }
  uses {
    interface StdControl as TransControl;
    interface CC2420Control;
    interface MacControl;
    interface Transceiver as IO;
    interface Router;
  }
}

implementation {
  #if 0
  typedef uint8_t uPack;
  #endif

  TOS_MsgPtr tmpPtr;
  uint8_t len = sizeof(uPack);

  /***********************************************************************
   * Internal functions
   ***********************************************************************/

  result_t newMsg() {
    if ((tmpPtr = call IO.requestWrite()) == NULL) // Gets a new TOS_MsgPtr
      return FAIL;
    return SUCCESS;
  }
  
  /**
   * Forwards packets destined for the UART
   */
  void fwdUart(uPack *pRcvPack) {
    uPack *pFwdPack;
    if (newMsg() == SUCCESS) { 
      pFwdPack = (uPack *)tmpPtr->data;
    } else {
      dbg(DBG_USR1, "Ucast: Couldn't get a new TOS_MsgPtr!\n");
      return;
    }
    memcpy(pFwdPack,pRcvPack,len);  
    dbg(DBG_USR1, "Ucast: Mote: Base, Src: %i, fwding to UART...\n", pFwdPack->data.src);
    call IO.sendUart(len); 
  }
  
  /**
   * Forwards packets for a different mote to their next hop
   */
  void fwdNextHop(uPack *pRcvPack, uint8_t retries) {
    uPack *pFwdPack;
    int16_t nextHop;
    if (newMsg() == SUCCESS) { 
      pFwdPack = (uPack *)tmpPtr->data;
    } else {
      dbg(DBG_USR1, "Ucast: Couldn't get a new TOS_MsgPtr!\n");
      return;
    }
    memcpy(pFwdPack,pRcvPack,len);
    //pFwdPack->hops++;
    pFwdPack->retriesLeft = retries;
    nextHop = call Router.getNextAddr(pFwdPack->data.dest);
    dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, fwding to %i, %i retries left...\n", 
        TOS_LOCAL_ADDRESS, pFwdPack->data.src, pFwdPack->data.dest, nextHop, retries);
    if (call IO.sendRadio(nextHop, len) == FAIL)
      dbg(DBG_USR2, "Ucast: sendRadio failed!");
  }
  
  /**
   * Delivers incoming radio messages.
   */
  TOS_MsgPtr deliver(TOS_MsgPtr pMsg) {
    uPack *pPack =(uPack *)pMsg->data;
    if (pPack->data.dest == TOS_LOCAL_ADDRESS) { // This packet is for us
      if (TOS_LOCAL_ADDRESS == 0) { // We are the UART bridge, forward to UART
        fwdUart(pPack);
      } else { // We are a normal mote, send data on to applications
        dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, rcvd\n", TOS_LOCAL_ADDRESS,
            pPack->data.src, pPack->data.dest);
        signal Message.receive(pPack->data);
      }
    } else { // This message is not for us, forward it on.
      fwdNextHop(pPack, RADIO_RETRIES);
    }
    return pMsg;
  }

  /***********************************************************************
   * Commands and events
   ***********************************************************************/

  command result_t StdControl.init() {
    call TransControl.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call TransControl.start();
    call CC2420Control.SetRFPower(31);
    call MacControl.enableAck();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call TransControl.stop();
    return SUCCESS;
  }
  
  /**
   * Builds a unicast pack from an input message and sends it on its way.
   */
  command result_t Message.send(msgData msg) {
    uPack newPack;
    if (msg.dest == TOS_BCAST_ADDR)
      return SUCCESS; // Ignore broadcase packets
    if (msg.dest == TOS_LOCAL_ADDRESS)
      return FAIL; // Don't send messages to yourself!
    if (call Router.getStatus() != RO_READY)
      return FAIL; // Router isn't ready, this should be checked before sending
    newPack.data = msg;
    fwdNextHop(&newPack, RADIO_RETRIES); // Send the message
    return SUCCESS;
  }
  
  /**
   * A message was sent over radio.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t IO.radioSendDone(TOS_MsgPtr m, result_t result) {
    uPack *pPack = (uPack *)m->data;
    uint8_t tmpRetries;
    if (result == SUCCESS) {  
      dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, fwd to %i succeeded\n", 
          TOS_LOCAL_ADDRESS, pPack->data.src, pPack->data.dest, m->addr);
      if (pPack->data.src == TOS_LOCAL_ADDRESS)
        signal Message.sendDone(pPack->data, SUCCESS);
    } else {
      tmpRetries = pPack->retriesLeft;
      if (tmpRetries > 0) {
        fwdNextHop(pPack, tmpRetries - 1);
      } else {
        dbg(DBG_USR2, "Ucast: Mote: %i, Src: %i, Dest: %i, fwd to %i failed!\n", 
          TOS_LOCAL_ADDRESS, pPack->data.src, pPack->data.dest, m->addr);
        if (pPack->data.src == TOS_LOCAL_ADDRESS)
          signal Message.sendDone(pPack->data, FAIL);
      }
    }
    return SUCCESS;
  }
  
  /**
   * A message was sent over UART.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t IO.uartSendDone(TOS_MsgPtr m, result_t result) {
    uPack *pPack = (uPack *)m->data;
    if (result == SUCCESS) {  
      dbg(DBG_USR1, "Ucast: Mote: Base, Src: %i, fwd to UART succeeded\n", pPack->data.src);
    } else {
      dbg(DBG_USR1, "Ucast: Mote: Base, Src: %i, fwd to UART failed!\n", pPack->data.src);
    }
    return SUCCESS;
  }
  
  /**
   * Received a message over the radio
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr IO.receiveRadio(TOS_MsgPtr m) {
    return deliver(m);	
  }
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr IO.receiveUart(TOS_MsgPtr m) {
    uPack *pPack = (uPack *)m->data;
    fwdNextHop(pPack, RADIO_RETRIES); // Forward the message via the radio
    return m;	
  }
}



