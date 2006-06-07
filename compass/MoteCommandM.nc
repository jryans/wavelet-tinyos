// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Responds to commands received through the transceiver for this mote
 * @author The Moters
 * @author Ryan Stinnett
 */

includes MessageData;

module MoteCommandM {
  uses {
  	interface Leds;
    interface Message;
  }
  provides interface StdControl;
}
implementation {
  command result_t StdControl.init() {
    call Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  #if 0
  typedef uint8_t msgData;
  #endif
    
  event result_t Message.receive(msgData msg) {
    switch (msg.type) {
      case RAWDATA:
      case WAVELETDATA: {
        uint16_t intVal;
        dbg(DBG_USR1, "Received a message at LED: type %i action %i", msg.type, msg.data.moteCmd.cmd);
	    // For raw and wavelet data, display the 3 LSBs
	    msg.type == RAWDATA ? (intVal = msg.data.raw.value[0]) 
	    					: (intVal = msg.data.wData.value[0]);
	    call Leds.set((uint8_t)(intVal & 0x7));
	    break;
	  }
	  case MOTECOMMAND: {
	    dbg(DBG_USR1, "Received a message at LED: type %i action %i", msg.type, msg.data.moteCmd.cmd);
	  	switch (msg.data.moteCmd.cmd) {
	  	  case YELLOW_LED_ON: {
	  	  	call Leds.yellowOn();
	  	  	break;
	  	  }
	  	  case YELLOW_LED_OFF: {
	  	  	call Leds.yellowOff();
	  	  	break;
	  	  }
	  	  case GREEN_LED_ON: {
	  	  	call Leds.greenOn();
	  	  	break;
	  	  }
	  	  case GREEN_LED_OFF: {
	  	  	call Leds.greenOff();
	  	  	break;
	  	  }
	  	}
	  	break;
	  }	
    } 
    return SUCCESS;
  }
  
  /**
   * sendDone is signaled when the send has completed
   * TODO: Responding to commands not yet implemented
   */
  event result_t Message.sendDone(msgData msg, result_t result) {
    return SUCCESS;
  }
}
