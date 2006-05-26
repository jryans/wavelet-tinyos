// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application takes data readings from the sensor 
 * (light and temperature) to store on a mote.
 */

module SenseToSensor
{
  provides 
  {
    interface StdControl;
    interface Timer as SensorTimer;
  }
  
  uses
  {
    interface StdControl as TempControl;
    interface StdControl as LightControl;
    interface ADC as TempADC;
    interface ADC as LightADC;
    interface Timer;
    interface SensorOutput as TempOutput;
    interface SensorOutput as LightOutput;
  }
}

implementation
{
 uint16_t curr_temp;
 uint16_t curr_light;
 uint8_t lsb_data;
 uint8_t msb_data;
 uint16_t counter = 0;

 command result_t StdControl.init()
 {
  call TempControl.init();
  call LightControl.init();
  
  return SUCCESS;
 }

 command result_t StdControl.start()
 {
   // the timer will filre ever 100 ms
  call Timer.start(TIMER_REPEAT, 100);

  return SUCCESS;
 }

 command result_t StdControl.stop()
 {
   call Timer.stop();
   
   return SUCCESS;
 }

 task void tempTask()
 {
   uint16_t tCopy[5] = {0,0,0,0,0};
   tCopy[0] = curr_temp;
   call TempOutput.output(tCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG); 
 }

 task void lightTask()
 {
   uint16_t lCopy[5] = {0,0,0,0,0};
   lCopy[0] = curr_light;
   call LightOutput.output(lCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG); 
 }
 
 event result_t Timer.fired()
 {  
   // every minute we get the temperature data (one minute has passed when our 100 ms timer has fired 60 times)
   if(counter < 599)
    {
      counter = counter + 1;
    }
    else
    {
      if(TOS_LOCAL_ADDRESS != 0)
      {
        call TempADC.getData();
      }
      counter = 0;
    }
    signal SensorTimer.fired();
   
  return SUCCESS;
 }

 async event result_t TempADC.dataReady(uint16_t data)
 {
  atomic
  {
   lsb_data = (uint8_t) data;
   msb_data = (uint8_t) (data >> 8);
   curr_temp = data;
  }
  
  // we can't have the light and temperature sensors going at the same time, so once we're
  // done with temperature, start light
  call TempControl.stop();
  call LightADC.getData();
  post tempTask();
  
  return SUCCESS;
 }
 
 async event result_t LightADC.dataReady(uint16_t data)
 {
  atomic
  {
   lsb_data = (uint8_t) data;
   msb_data = (uint8_t) (data >> 8);
   curr_light = data;
  }
  call LightControl.stop();
  post lightTask();
  
  return SUCCESS;
 }

 event result_t TempOutput.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
 
 event result_t LightOutput.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
  
// Functions to deal with new Timer  
  command result_t SensorTimer.start(char type, uint32_t interval) 
  {
    return call Timer.start(type, interval);
  }
  command result_t SensorTimer.stop() {
    return call Timer.stop();
  }
 
}

 