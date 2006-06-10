/**
 * Even less intelligent than RouterStaticM and useful for simulations,
 * this Router module always returns the destination as the next hop.
 * @author Ryan Stinnett
 */
 
includes IOPack;
 
module RouterSimM {
  provides {
    interface StdControl;
    interface Router; 
  }
  uses interface Transceiver as IO;
}
implementation {
  uint8_t curState; // Holds the current state of the router.
  
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
    return dest;
  }

  /*** Not needed in RouterSimM ***/
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
