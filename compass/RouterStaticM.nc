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
  uses interface Transceiver as IO;
}
implementation {
  uint8_t curState; // Holds the current state of the router.
  
  int16_t routeTable[9][9] =
    { { -1, 1, 2, 3, 1, 2, 1, 2, 3 } ,
      { 0, -1, 2, 2, 4, 2, 4, 4, 2 } ,
      { 0, 1, -1, 3, 4, 5, 4, 5, 5 } ,
      { 0, 2, 2, -1, 2, 5, 5, 5, 5 } ,
      { 1, 1, 2, 2, -1, 7, 6, 7, 7 } ,
      { 3, 2, 2, 3, 7, -1, 7, 7, 8 } ,
      { 4, 4, 4, 4, 4, 7, -1, 7, 7 } ,
      { 5, 4, 5, 5, 4, 5, 6, -1, 8 } ,
      { 5, 5, 5, 5, 7, 5, 7, 7, -1 } };
  
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
  command int16_t Router.getNextAddr(int16_t dest) {
    return routeTable[TOS_LOCAL_ADDRESS][dest];
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
