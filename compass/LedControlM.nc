// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application implements the functionality of its configuration.  It sends data 
 * from the Message type to the Leds.  We use this for debugging and demos.
 **/

includes MessageData;

module LedControlM {
  uses interface Leds;
  uses interface MessageIn as LedData;
  
  provides interface StdControl;
}
implementation
{
  command result_t StdControl.init()
  {
    call Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start() 
  {
  	dbg(DBG_USR1, "Startup time!");
    return SUCCESS;
  }

  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
    
  event result_t LedData.receive(struct MessageData msg)
  {
  	dbg(DBG_USR1, "Received a message at LED: type %i action %i", msg.type, msg.data.moteCmd.cmd);
    switch (msg.type)
    {
      case RAWDATA:
      case WAVELETDATA:
	    // For raw and wavelet data, display the 3 LSBs
	  {
	  	uint16_t intVal;
	    msg.type == RAWDATA ? (intVal = msg.data.raw.value[0]) 
	    					: (intVal = msg.data.wavelet.value[0]);
	    call Leds.set((uint8_t)(intVal & 0x7));
	    break;
	  }
	  case MOTECOMMAND:
	  {
	  	switch (msg.data.moteCmd.cmd)
	  	{
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
}

