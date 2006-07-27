/**
 * Simplest implementation of routing.  Uses a static routing table which is hard-coded
 * at compile time.
 * @author Ryan Stinnett
 */
 
includes IOPack;
 
module RouterStaticM {
  provides {
    interface StdControl;
    interface Router; 
  }
  uses {
    interface Message;
    interface Transceiver as IO;
  }
}
implementation {
  
#if 0
  typedef char RouterData;
#endif
  
  uint8_t curState; // Holds the current state of the router.
  
  int16_t cleanTable[11][11] =
    /* Exp. Optimal Single Retry Table */
    { { -1, 1, 1, 1, 4, 7, 7, 7, 7, 7, 4 } ,
      { 0, -1, 2, 2, 4, 4, 7, 7, 4, 4, 10 } ,
      { 1, 1, -1, 3, 4, 5, 7, 7, 5, 5, 1 } ,
      { 2, 2, 2, -1, 2, 2, 2, 2, 2, 2, 2 } ,
      { 0, 1, 1, 1, -1, 7, 7, 7, 7, 7, 1 } ,
      { 7, 7, 2, 2, 7, -1, 6, 7, 8, 9, 7 } ,
      { 7, 7, 7, 7, 5, 5, -1, 7, 8, 8, 5 } ,
      { 0, 1, 2, 2, 4, 5, 6, -1, 8, 8, 1 } ,
      { 5, 6, 6, 6, 5, 5, 6, 6, -1, 9, 5 } ,
      { 5, 5, 5, 5, 5, 5, 8, 5, 8, -1, 5 } ,
      { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1 } };
      
  /*{ { -1, 1, 1, 1, 4, 4, 4 } ,
      { 0, -1, 2, 2, 4, 5, 5 } ,
      { 1, 1, -1, 3, 1, 1, 1 } ,
      { 2, 2, 2, -1, 2, 2, 2 } ,
      { 0, 1, 1, 1, -1, 5, 5 } ,
      { 4, 1, 1, 1, 4, -1, 6 } ,
      { 5, 5, 5, 5, 5, 5, -1 } };*/
  
  /*{ { -1, 1, 2, 3, 1, 2, 1, 2, 3 } ,
      { 0, -1, 2, 2, 4, 2, 4, 4, 2 } ,
      { 0, 1, -1, 3, 4, 5, 4, 5, 5 } ,
      { 0, 2, 2, -1, 2, 5, 5, 5, 5 } ,
      { 1, 1, 2, 2, -1, 7, 6, 7, 7 } ,
      { 3, 2, 2, 3, 7, -1, 7, 7, 8 } ,
      { 4, 4, 4, 4, 4, 7, -1, 7, 7 } ,
      { 5, 4, 5, 5, 4, 5, 6, -1, 8 } ,
      { 5, 5, 5, 5, 7, 5, 7, 7, -1 } };*/
      
  bool moteEnable[11] = { TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE };
  
  command result_t StdControl.init() {
    curState = RO_READY;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  /**
   * Reports the current state of the routing layer.  RO_INIT means the layer is
   * starting up and determining the initial routing table.  RO_READY means it
   * has a usable routing table.
   */
  command uint8_t Router.getStatus() {
    return curState;
  }

  /**
   * Gives the address of the next hop for a given destination.
   */
  command uint16_t Router.getNextAddr(msgData *msg) {
    uint16_t dest = msg->dest;
    if (dest == NET_UART_ADDR)
      dest = 0;
    if ((msg->type == WAVELETDATA && !moteEnable[dest]) ||
        cleanTable[TOS_LOCAL_ADDRESS][dest] == -1)
      return NET_BAD_ROUTE;
    return cleanTable[TOS_LOCAL_ADDRESS][dest];
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
  event void Message.receive(msgData msg) {
    if (msg.type == ROUTERDATA) {
      RouterData *r = &msg.data.rData;
      dbg(DBG_USR1, "Router: Setting mote %i's link to %i\n", r->mote, r->enable);
      moteEnable[r->mote] = r->enable;
    }
  }

  /*** Not needed in RouterStaticM ***/
  event result_t IO.radioSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }

  event result_t IO.uartSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }

  event TOS_MsgPtr IO.receiveRadio(TOS_MsgPtr m) {
    return m;
  }

  event TOS_MsgPtr IO.receiveUart(TOS_MsgPtr m) {
    return m;
  }
}
