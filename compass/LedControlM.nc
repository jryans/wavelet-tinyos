// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application implements the functionality of its configuration.  It sends data 
 * from the Message type to the Leds.  We use this for debugging and demos.
 **/

includes MessageData;

module LedControlM {
  uses interface Leds;

  provides interface MessageOut as LedData;
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
	    // For raw and wavelet data, display the 3 LSBs
	    uint16_t intVal;
	    msg.type == RAWDATA ? (intVal = msg.data.raw.value[0]) 
	    					: (intVal = msg.data.wavelet.value[0]);
	    call Leds.set((uint8_t)(intVal & 0x7));
    }
    
    post outputDone();

    return SUCCESS;
  }
}

