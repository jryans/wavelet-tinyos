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
  }
  uses {
    interface Transceiver as IO;
    interface Router;
    interface Leds;
    interface MoteOptions;
#ifdef BEEP
    interface Beep;
#endif
  }
}

implementation {
#if 0 // TinyOS Plugin Workaround
  typedef uint8_t uPack;
#endif

  TOS_MsgPtr tmpPtr;
  uint8_t len = sizeof(uPack);
  
  uint8_t RADIO_RETRIES = 5;

  /*** Internal Functions ***/

  /**
   * Requests a new TOS_MsgPtr.
   */ 
  result_t newMsg() {
    if ((tmpPtr = call IO.requestWrite()) == NULL) {
      return FAIL;
#ifdef BEEP
      call Beep.play(3, 250);
#endif
    }
    return SUCCESS;
  }
  
  /**
   * Forwards packets destined for the UART.
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
   * Forwards packets for a different mote to their next hop.
   */
  void fwdNextHop(uPack *pRcvPack, uint8_t retries) {
    uPack *pFwdPack;
    uint16_t nextHop;
    if (pRcvPack->data.type != 20) {
      nextHop = call Router.getNextAddr(&pRcvPack->data);
    } else {
      nextHop = pRcvPack->data.dest;
    }
    if (nextHop == NET_BAD_ROUTE) {
      dbg(DBG_USR1, "Ucast: Route disabled intentionally or is this mote\n");
      return;
    }
    if (newMsg() == SUCCESS) { 
      pFwdPack = (uPack *)tmpPtr->data;
    } else {
      dbg(DBG_USR1, "Ucast: Couldn't get a new TOS_MsgPtr!\n");
      return;
    }
    memcpy(pFwdPack,pRcvPack,len);
    //pFwdPack->hops++;
    pFwdPack->retriesLeft = retries - 1;
    dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, fwding to %i, %i retries left...\n", 
        TOS_LOCAL_ADDRESS, pFwdPack->data.src, pFwdPack->data.dest, nextHop, retries);
    if (call IO.sendRadio(nextHop, len) == FAIL) {
      dbg(DBG_USR2, "Ucast: sendRadio failed!");
    } else {
      call Leds.greenOn(); 
    }
  }
  
  /**
   * Delivers incoming radio and UART messages.
   */
  TOS_MsgPtr deliver(TOS_MsgPtr pMsg) {
    uPack *pPack =(uPack *)pMsg->data;
    if (pPack->data.dest == TOS_LOCAL_ADDRESS) { // This packet is for us
      // Send data on to applications
      dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, rcvd\n", TOS_LOCAL_ADDRESS,
          pPack->data.src, pPack->data.dest);
      signal Message.receive(pPack->data);
    } else if (pPack->data.dest == NET_UART_ADDR && TOS_LOCAL_ADDRESS == 0) {
      fwdUart(pPack); // From normal motes to the sink
    } else { // This message is not for us, forward it on.
      fwdNextHop(pPack, RADIO_RETRIES);
    }
    return pMsg;
  }

  /*** Commands and Events ***/
  
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
    if (TOS_LOCAL_ADDRESS == 0 && msg.dest == NET_UART_ADDR) {
      fwdUart(&newPack); // From UART bridge to the sink
    } else {
      fwdNextHop(&newPack, RADIO_RETRIES); // Anything else goes on the radio
    }
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
    call Leds.greenOff();
    // Yes, ACKs work *currently*...  Stop checking them!
    //(m->ack == 1) ? (call Leds.yellowOn()) : (call Leds.yellowOff());
    if ((result == SUCCESS) && (m->ack == 1)) {  
      dbg(DBG_USR1, "Ucast: Mote: %i, Src: %i, Dest: %i, fwd to %i succeeded\n", 
          TOS_LOCAL_ADDRESS, pPack->data.src, pPack->data.dest, m->addr);
      if (pPack->data.src == TOS_LOCAL_ADDRESS)
        signal Message.sendDone(pPack->data, SUCCESS, RADIO_RETRIES - pPack->retriesLeft - 1);
    } else {
      // Either we got FAIL or there was no ACK
      tmpRetries = pPack->retriesLeft;
      if (tmpRetries > 0) {
        fwdNextHop(pPack, tmpRetries);
      } else {
#ifdef BEEP
        //call Beep.play(2, 250);
#endif
        dbg(DBG_USR2, "Ucast: Mote: %i, Src: %i, Dest: %i, fwd to %i failed!\n", 
          TOS_LOCAL_ADDRESS, pPack->data.src, pPack->data.dest, m->addr);
        if (pPack->data.src == TOS_LOCAL_ADDRESS)
          signal Message.sendDone(pPack->data, FAIL, RADIO_RETRIES - 1);
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
    call MoteOptions.resetSleep();
    return deliver(m);
  }
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr IO.receiveUart(TOS_MsgPtr m) {
    return deliver(m);	
  }
  
  /**
   * Signaled when an option affecting other applications is received.
   */
  event void MoteOptions.receive(uint8_t optMask, uint8_t optValue) {
    if ((optMask & MO_RADIORETRIES) != 0)
      RADIO_RETRIES = optValue;
  }
}
