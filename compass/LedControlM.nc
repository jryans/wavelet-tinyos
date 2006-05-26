// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application implements the functionality of its configuration.  It sends data 
 * from the BareMessage type to the Leds.  We use this for debugging and demos.
 **/

includes MessageData;

module LedControlM {
  uses interface Leds;

  provides interface BareMessageOut as LedData;
  provides interface StdControl;
}
implementation
{
  command result_t StdControl.init()
  {
    call Leds.init();
    call Leds.redOff();
    call Leds.yellowOff();
    call Leds.greenOff();
    return SUCCESS;
  }

  command result_t StdControl.start() 
  {
    return SUCCESS;
  }

  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
  

  task void outputDone()
  {
    signal LedData.sendDone(SUCCESS);
  }

  
  command result_t LedData.send(struct MessageData msg, int8_t mDest)
  {
    if (msg.type == RAWDATA || msg.type == WAVELETDATA)
    {
	    uint16_t intVal;
	    msg.type == RAWDATA ? (intVal = msg.data.raw.value[0]) 
	    					: (intVal = msg.data.wavelet.value[0]);
	    
	    if (intVal & 1) 
	      call Leds.redOn();
	    else 
	      call Leds.redOff();
	    
	    if (intVal & 2) 
	      call Leds.greenOn();
	    else 
	      call Leds.greenOff();
	    
	    if (intVal & 4) 
	      call Leds.yellowOn();
	    else 
	      call Leds.yellowOff();
    }
    
    post outputDone();

    return SUCCESS;
  }
}

