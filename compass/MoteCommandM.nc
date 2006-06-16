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
    interface Timer;
    interface Beep;
  }
  provides interface StdControl;
}
implementation {
  msgData tMsg;
  
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
  
#if 0 // TinyOS Plugin Workaround
  typedef uint8_t msgData;
#endif
    
  event void Message.receive(msgData msg) {
    switch (msg.type) {
      // Not really useful
//      case RAWDATA:
//      case WAVELETDATA: {
//        uint16_t intVal;
//        dbg(DBG_USR1, "Received a message at LED: type %i action %i\n", msg.type, msg.data.moteCmd.cmd);
//	    // For raw and wavelet data, display the 3 LSBs
//	    msg.type == RAWDATA ? (intVal = msg.data.raw.value[0]) 
//	    					: (intVal = msg.data.wData.value[0]);
//	    call Leds.set((uint8_t)(intVal & 0x7));
//	    break;
//	  }
	case MOTECOMMAND: {
	  dbg(DBG_USR1, "Received a message at LED: type %i action %i\n", msg.type, msg.data.moteCmd.cmd);
	  if (msg.data.moteCmd.cmd < 10)
	    call Timer.start(TIMER_ONE_SHOT, 500);
	  switch (msg.data.moteCmd.cmd) {
	  case YELLOW_LED_ON: {
	  	//call Leds.yellowOn();
	  	break; }
	  case YELLOW_LED_OFF: {
	   	call Leds.yellowOff();
	   	break; }
	  case YELLOW_LED_TOG: {
	   	call Leds.yellowToggle();
	    break; }
	  case GREEN_LED_ON: {
	  	call Leds.greenOn();
	  	break; }
	  case GREEN_LED_OFF: {
	  	call Leds.greenOff();
	  	break; }
	  case GREEN_LED_TOG: {
	  	call Leds.greenToggle();
	  	break; }
	  case RED_LED_ON: {
	  	call Leds.redOn();
	  	break; }
	  case RED_LED_OFF: {
	  	call Leds.redOff();
	  	break; }
	  case RED_LED_TOG: {
	  	call Leds.redToggle();
	  	break; }
	  case BEEP_ON: {
	  	tMsg.src = TOS_LOCAL_ADDRESS;
        tMsg.type = MOTECOMMAND;
	  	tMsg.dest = 2;
	  	tMsg.data.moteCmd.cmd = 7;
	  	call Message.send(tMsg);
	  	break; }
	  case 11: {
	    call Beep.play(2, 250 * TOS_LOCAL_ADDRESS);
	  	break; }
	  }
	  break; }	
    } 
  }
  
  event result_t Timer.fired() {
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.type = MOTECOMMAND;
    switch (TOS_LOCAL_ADDRESS) {
    case 1: {
//      if (call Leds.get() == 7 || call Leds.get() == 0) {
//        call Leds.yellowToggle();
//      }
//      if (call Leds.get() == 4 || call Leds.get() == 3) {
        msg.dest = 2;
        msg.data.moteCmd.cmd = 8;
        call Message.send(msg);
//        msg.dest = 3;
//        msg.data.moteCmd.cmd = 9;
//        call Message.send(msg);
//      }
      break; }
//    case 2: {
//      if (call Leds.get() == 2 || call Leds.get() == 0) {
//        msg.dest = 1;
//        msg.data.moteCmd.cmd = 8;
//        call Message.send(msg);
//      }
//      break; }
//    case 3: {
//      if (call Leds.get() == 1 || call Leds.get() == 0) {
//        msg.dest = 1;
//        msg.data.moteCmd.cmd = 9;
//        call Message.send(msg);
//      }
//      break; }  
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
