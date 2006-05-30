// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application takes data readings from various sensors,
 * caches their values, and sends out the most recent set of data.
 */
 
includes Sensors;
includes MessageData;

module SensorControlM
{
  provides 
  {
  	interface StdControl;
    interface BareMessageIn as SensorData;
  }
  
  uses
  {
    interface ADC as TempADC;
    interface ADC as LightADC;
    interface ADC as VoltADC;
    interface StdControl as TempControl;
    interface StdControl as LightControl;
    interface StdControl as VoltControl;
    interface Timer;
  }
}

implementation
{
  uint16_t last_val[NUM_SENSORS];
  
  command result_t StdControl.init()
  {
    if (TOS_LOCAL_ADDRESS != 0)
    {
      call TempControl.init();
      call LightControl.init();
      call VoltControl.init();
    }
  
    return SUCCESS;
  }

  command result_t StdControl.start()
  {
    if (TOS_LOCAL_ADDRESS != 0)
    {
      call TempControl.start();
      call LightControl.start();
      call VoltControl.start();
  
      call Timer.start(TIMER_REPEAT, SAMPLE_TIME);
    }

    return SUCCESS;
  }

  command result_t StdControl.stop()
  {
    if (TOS_LOCAL_ADDRESS != 0)
    {
      call Timer.stop();
    
      call TempControl.stop();
      call LightControl.stop();
      call VoltControl.stop();
    }
    
    return SUCCESS;
  }
 
  /**
   * Each time the timer fires, the most recent set of data is sent off
   * immediately and then a new set of values is read to the cache. This
   * means that the samples will be delayed by SAMPLE_TIME ms.
   */
  event result_t Timer.fired()
  {  
    struct MessageData msg;
    uint8_t i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = TOS_LOCAL_ADDRESS;
    for (i = 0; i <= NUM_SENSORS - 1; i++)
      msg.raw.value[i] = last_val[i];
    dbg(DBG_USR1, "Values read from sensors: Light = %i, Temp = %i, Volt = %i\n",
        (int)last_val[LIGHT], (int)last_val[TEMP], (int)last_val[VOLT]);
    signal SensorData.receive(msg);
    TempADC.getData();
    LightADC.getData();
    VoltADC.getData();
   
    return SUCCESS;
  }

  async event result_t TempADC.dataReady(uint16_t data)
  {
    last_val[TEMP] = data;
    return SUCCESS;
  }
 
  async event result_t LightADC.dataReady(uint16_t data)
  {
    last_val[LIGHT] = data; 
    return SUCCESS;
  }

  async event result_t VoltADC.dataReady(uint16_t data)
  {
    last_val[VOLT] = data; 
    return SUCCESS;
  }
}

 