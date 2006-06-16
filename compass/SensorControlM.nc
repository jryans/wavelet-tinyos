// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application takes data readings from various sensors,
 * caches their values, and sends out the most recent set of data when requested.
 * IMPORTANT: Temp and Light must start and stop with each request. If
 * they are not stopped, the radio will not be able to receive.
 * TODO: Need to wait for a settling time after starting a sensor?
 * @author The Moters
 * @author Ryan Stinnett
 */
 
includes Sensors;
includes RawData;

module SensorControlM {
  provides {
  	interface StdControl;
    interface SensorData;
  }
  uses {
    interface ADC as TempADC;
    interface ADC as LightADC;
    interface ADC as VoltADC;
    interface StdControl as TempControl;
    interface StdControl as LightControl;
    interface StdControl as VoltControl;
    interface Timer;
  }
}

implementation {
  uint8_t sensToGo;
  RawData curData;
  task void readData();
  task void dataDone();
  
  command result_t StdControl.init() {
    if (TOS_LOCAL_ADDRESS != 0) {
      call TempControl.init();
      call LightControl.init();
      call VoltControl.init();
    }
    return SUCCESS;
  }

  command result_t StdControl.start() {
    if (TOS_LOCAL_ADDRESS != 0)
      call VoltControl.start();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    if (TOS_LOCAL_ADDRESS != 0) {
      call TempControl.stop();
      call LightControl.stop();
      call VoltControl.stop();
    }
    return SUCCESS;
  }
 
  /**
   * Each time an application requests new measurements, this task
   * is posted to start the dormant sensors and read their values.
   */
  task void readData() {
    call TempControl.start();
    call LightControl.start();
    call TempADC.getData();
    call LightADC.getData();
    call VoltADC.getData();
  }
  
  /**
   * Requests new data from the sensor system.
   */
  command void SensorData.readSensors() {
  	call Leds.redOn();
  	atomic { sensToGo = NUM_SENSORS; }
  	post readData();
    }
  
  /**
   * When the last sensor finished sampling, it posts this task
   * which pass the new data up to applications.
   */
  task void dataDone() {
    call TempControl.stop();
    call LightControl.stop();
    dbg(DBG_USR1, "Values read from sensors: Light = %i, Temp = %i, Volt = %i\n",
        curData.value[LIGHT], curData.value[TEMP], curData.value[VOLT]);
    call Leds.redOff();
    atomic { signal SensorData.readDone(curData); }
  }

  async event result_t TempADC.dataReady(uint16_t data)
  {
    atomic {
      curData.value[TEMP] = data;
      if (--sensToGo == 0)
        post dataDone();
    }
    return SUCCESS;
  }
 
  async event result_t LightADC.dataReady(uint16_t data)
  {
    atomic {
      curData.value[LIGHT] = data; 
      if (--sensToGo == 0)
        post dataDone();
    }
    return SUCCESS;
  }

  async event result_t VoltADC.dataReady(uint16_t data)
  {
    atomic {
      curData.value[VOLT] = data; 
      if (--sensToGo == 0)
        post dataDone();
    }
    return SUCCESS;
  }
}
