/**
 * Tests the sensor and messaging components.
 * @author Ryan Stinnett 
 */

includes Sensors;
includes MessageData;

module SampleM {
  uses {
    interface SensorData;
    interface Timer;
    interface Message;
  }
  provides interface StdControl;
}

implementation {

  /*** StdControl ***/
  
  command result_t StdControl.init() {
    return SUCCESS; 
  }

  command result_t StdControl.start() {
    if (TOS_LOCAL_ADDRESS != 0)
      call Timer.start(TIMER_REPEAT, 1000);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    if (TOS_LOCAL_ADDRESS != 0)
      call Timer.stop();
    return SUCCESS;
  }
  
  /*** Commands and Events ***/
  
  event result_t Timer.fired() {
    call SensorData.readSensors();
    return SUCCESS;
  }
    
  event void SensorData.readDone(RawData data) {
    msgData msg;
    uint8_t i;
    msg.dest = NET_UART_ADDR;
    msg.type = WAVELETDATA;
    msg.data.wData.state = 13;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = data.value[i];
    call Message.send(msg);
  }
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result) {
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {}
}
