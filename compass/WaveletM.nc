// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Manages the motes to perform a wavelet transform on incoming sensor data.
 * Uses the State library to manage graceful state transitions.
 * @author The Moters
 * @author Ryan Stinnett
 */

includes MessageData;
includes WaveletData;
includes Sensors;
includes AM;

module WaveletM 
{
  uses {
    /*** I/O and Hardware ***/
    interface Message;
    interface Router;
    interface Leds;
    interface SensorData;
    
    /*** State Management ***/
    interface State;
    interface Timer as Timeout;
    interface Timer as NewSet;
  }
  provides interface StdControl;
}
implementation
{ 
  #if 0
  typedef struct MessageData msgData;
  #endif
  
  /*** Variables and Constants ***/ 
  uint8_t curLevel; // The current wavelet transform level
  uint8_t dataSet; // Identifies the current data set number
  uint8_t waitingFor; // Number of motes we are waiting on
  
  /* Each array has one entry for this mote at index 0 and additional entries for our
   * neighbors as determined by Ray's MATLAB code.
   */
  typedef struct {
    uint8_t numMotes; // Number of neighbors at this level
    int16_t neighbors[WT_NEIGHBORS + 1]; // Mote ID
    wtState wt[WT_NEIGHBORS + 1]; // WT value calc'd from raw value and the coeffs
    float coeffs[WT_NEIGHBORS + 1]; // WT coeffs from MATLAB
  } wtLevel;
  
  wtLevel wtData[WT_LEVELS]; // One of the aboves structs used for each WT level
  
  // Defines all possible mote states
  enum {
    S_IDLE = 0,
    S_STARTUP,
    S_READING_SENSORS,
    S_UPDATING,
    S_PREDICTING,
    S_PREDICTED,
    S_UPDATED,
    S_SKIPLEVEL,
    S_DONE,
    S_OFFLINE,
    S_ERROR
  };
    
  /*** Internal Functions ***/
  task void runState();
  result_t checkMoteState(uint8_t state);
  void readSensors();
  
  void startWaveletLevel();
  uint8_t hasReceivedAllValues();  
  void calculateCoefficient(uint16_t numNeighbors, uint16_t addVal);
  void clearTable(uint16_t numNeighbors);

  
  /**
   * This is the heart of the wavelet algorithm's state management.
   * Whenever the state is changed, this task is posted to run whatever
   * functions that state requires.
   */
  task void runState() {
    switch (call State.getState()) {
      // At startup, retrieve parameters and then begin by reading sensors
      case S_STARTUP: {
        curLevel = 0;
        dataSet = 0;
        // Build coeff reception
        call State.toIdle();
        post runState();
        break; }
      case S_IDLE: {
        dataSet++;
        dbg(DBG_USR1, "DS: %i, Starting data set...", dataSet);
        call State.forceState(S_READING_SENSORS);
        post runState();
        break; }
      case S_READING_SENSORS: {
        dbg(DBG_USR1, "DS: %i, Reading sensors...", dataSet);
        readSensors();
        //nextWaveletLevel();
        State.forceState(wtData[curLevel].wt[0].name);
        post runState();
        break; }
      case S_UPDATING: {
        dbg(DBG_USR1, "Update Node: DS: %i, L: %i, Sending values to predict nodes...",
            dataSet, curLevel);
        sendValuesToNeighbors();
        waitingFor = wtData[curLevel].numMotes;
        dbg(DBG_USR1, "Update Node: DS: %i, L: %i, Waiting to hear from predict nodes...",
            dataSet, curLevel);
        break; }
      case S_PREDICTING: {
        waitingFor = wtData[curLevel].numMotes;
        dbg(DBG_USR1, "Predict Node: DS: %i, L: %i, Waiting to hear from update nodes...",
            dataSet, curLevel);
      }  
      case S_PREDICTED: {
        dbg(DBG_USR1, "Predict Node: DS: %i, L: %i, Sending predicts to base...",
            dataSet, curLevel);
        sendResultsToBase(); 
        break; }
    }
  }
  
  void readSensors() {
    RawData newVals = call SensorData.readSensors();
    uint8_t i;
    for (i = 0; i < WT_SENSORS; i++)
      wtData[0].wt[0].value[i] = newVals.value[i];
  }
  
void nextWaveletLevel() {
//    if (predLevel == 0) {
//      call State.forceState(S_PREDICTED);
//      return;
//    }
//    if (predLevel == curLevel) {
//      call State.forceState(S_PREDICTING);
//    } else {
//      call State.forceState(S_UPDATING);
//    }

}
  
  void sendResultsToBase() {
    msgData msg;
    //uint8_t i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = STATE;
    msg.data.state.name = S_PREDICTED;
    msg.data.state.wtData.value = wtData[curLevel].wt[0].value;
    call Message.send(msg);
  }
  
  void sendValuesToNeighbors() {
    msgData msg;
    uint8_t mote;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.type = STATE;
    msg.data.state.name = call State.getState();
    msg.data.state.wtData.value = wtData[curLevel].wt[0].value;
    for (mote = 0; mote < WT_NEIGHBORS; mote++) {
      if ((msg.dest = wtData[curLevel].neighbors[mote]) == -1)
        break;
      dbg(DBG_USR1, "Update Node: DS: %i, L: %i, Sending values to predict node %i...",
          dataSet, curLevel, msg.dest);
      call Message.send(msg);
    }
  }
  
  /*** Commands and Events ***/  
  
  command result_t StdControl.init() 
  {
    return SUCCESS;
  }
  
  command result_t StdControl.start() 
  {
    call State.forceState(S_STARTUP);
    post runState();
    return SUCCESS;
  }
  
  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(result_t result) {
    switch (call State.getState()) {
      case S_PREDICTED: {
        if (result == SUCCESS) {
          dbg(DBG_USR1, "Predict Node: DS: %i, L: %i, Sending predicts to base successful",
              dataSet, curLevel);
          State.toIdle();
        } else {
          dbg(DBG_USR1, "Predict Node: DS: %i, L: %i, Sending predicts to base failed!",
              dataSet, curLevel);
        } break; }

    }
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event result_t Message.receive(msgData msg) {
    switch (call State.getState()) {
      case S_PREDICTING: {
        if (result == SUCCESS) {
          dbg(DBG_USR1, "Sending predict value for data set %i successful", dataSet);
          State.toIdle();
        } else {
          dbg(DBG_USR1, "Sending predict value for data set %i failed!", dataSet);
        } break; }
    }
    return SUCCESS;
  }
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t Timeout.fired() {}
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t NewSet.fired() {}
  
  
/*********************************************************************
 * Helper Functions!!
 *********************************************************************/  
  





 /*
  * Starts one level of the wavelet transform.
  * If the node is a scaling node at this level, it will send the scaling values to its neighbors.
  */
  void startWaveletLevel()
  {
    uint16_t led_display[5] = {0,0,0,0,0};
    uint16_t numNeighbors;
    uint16_t LCV;
    
    if(wav_dec[TOS_LOCAL_ADDRESS] > wavelet_level) //ie we are a scaling node at the current level
    {        
      numNeighbors = local_table[wavelet_level-1][0][0];
      led_display[0] = wav_val[TOS_LOCAL_ADDRESS][0];
      led_display[1] = wav_val[TOS_LOCAL_ADDRESS][1];
      LCV = 0;
      
      for(LCV; LCV < numNeighbors; LCV++)    // send scaling values to this node's neighbors
      {
        uint16_t neighbor = local_table[wavelet_level-1][LCV+1][0]; 
        delaySendMessage(led_display, TOS_LOCAL_ADDRESS, routing_table[TOS_LOCAL_ADDRESS][neighbor], neighbor, wavelet_level, WAVELET_MSG);
      }
      
      // as long as we're not the base node and we're not yet at the maximum wavelet level, increment the wavelet level by one
      if(numNeighbors == 0)
      {
        if(wavelet_level < max_wavelet_level)
        {
          wavelet_level = wavelet_level + 1;
          startWaveletLevel();
        } 
      }
        
      call LedOut.output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
    }   
  }
 
  
 /*
  * Determines whether or not the node has received values back from all of its neighbors on this
  * level of the wavelent transform.  Returns true if it has received all the values.
  */
  uint8_t hasReceivedAllValues()
  {
    uint8_t LCV = 0;
    uint8_t noEmptySpotsFlag = 1;
    
    for(LCV; LCV < local_table[wavelet_level - 1][0][0]; LCV++)
    {
      // loop through the values stored in the local table; if any of them haven't been received yet
      // (indicated by element 3 in the array - stores the flag), then set noEmptySpotsFlag to false
      if(local_table[wavelet_level - 1][LCV+1][3] == 0)
        noEmptySpotsFlag = 0;      
    }
    return noEmptySpotsFlag;
  }
  
  
  /*
   * When a wavelet value is received, find the element in the local table corresponding to this
   * neighbor (source).  Then set element #2 to this wavelet value, and element #3 to 1 for received.
   */
  void addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1)    
  {
    uint16_t lcv = 0;
    for (lcv; lcv < local_table[hops-1][0][0]; lcv++)
    {
      if(local_table[hops-1][lcv+1][0] == source)
      {
        local_table[hops-1][lcv+1][1] = measurements0;
        local_table[hops-1][lcv+1][2] = measurements1;
        local_table[hops-1][lcv+1][3] = 1;
      }     
    }
  }
  
  
  /**
   * Instead of sending a message right away, we add it to the MessagesPending table, with a delay
   * equal to source.
   */
  void delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type)
 {
    uint16_t LCV = 0;
    // Look through the messagesPending array, beginning at the first element, looking for a location that isn't
    // storing a message or that is storing a message that has already been sent, so that we can over-write it 
    // with our new message
    while(MessagesPending[LCV][0] == 1)
    {
       LCV = LCV + 1; 
    }
      
    MessagesPending[LCV][0] = 1;         // A flag to show that the message stored in this spot still needs to be sent
    MessagesPending[LCV][1] = source;    // This stores the amount of delay we want to give
    MessagesPending[LCV][2] = source;  
    MessagesPending[LCV][3] = next_addr;
    MessagesPending[LCV][4] = dest_addr;
    MessagesPending[LCV][5] = hops;
    MessagesPending[LCV][6] = msg_type;
    
    // MessagesPendingData stores the data values corresponding to this particular message
    MessagesPendingData[LCV][0] = measurements[0];
    MessagesPendingData[LCV][1] = measurements[1];
    MessagesPendingData[LCV][2] = measurements[2]; 
    MessagesPendingData[LCV][3] = measurements[3];  
    MessagesPendingData[LCV][4] = measurements[4]; 
  }
  
 
  /*
   * After all of the wavelet or scaling values have been received, loop through
   * all of them, multiply by coefficients, and keep a running total.
   */
  void calculateCoefficient(uint16_t numNeighbors, uint16_t addVal)
  {
    uint16_t LCV = 0;
    for(LCV; LCV < numNeighbors; LCV++)
    {
      double coeff = local_table_coeff[wavelet_level - 1][LCV+1];
      double value0 = local_table[wavelet_level - 1][LCV+1][1];    // get the light value
      double value1 = local_table[wavelet_level - 1][LCV+1][2];    // get the temperature value
      
      // Important Note: The values sent by the radio are all stored as UInt values, but we use doubles
      // when we multiply them by coefficients.  In the conversion from UInt to double, a negative value will 
      // be represented as a large positive number.  (We determine that a value is "large" if greater than 32768,
      // half of the maximum value.)  In order to convert to the correct negative value, subtract 2^16, which is 65536.
      if(value0 > 32768)
        value0 = value0 - 65536;
      if(value1 > 32768)
        value1 = value1 - 65536;
      
      // addVal tells us whether to add or subtract these coefficients
      if(addVal == 0)  // prediction
      {
        wav_val[TOS_LOCAL_ADDRESS][0] = wav_val[TOS_LOCAL_ADDRESS][0] - value0*coeff;  
        wav_val[TOS_LOCAL_ADDRESS][1] = wav_val[TOS_LOCAL_ADDRESS][1] - value1*coeff;  
      }
      else   // updating
      {
        wav_val[TOS_LOCAL_ADDRESS][0] = wav_val[TOS_LOCAL_ADDRESS][0] + value0*coeff;
        wav_val[TOS_LOCAL_ADDRESS][1] = wav_val[TOS_LOCAL_ADDRESS][1] + value1*coeff;  
      }
      }        
  }
  
  
  /*
   * After we've totaled the values multiplied by coefficients that are stored in localTable,
   * clear these values out and set their flags to not-received.
   */
  void clearTable(uint16_t numNeighbors)
  {
    uint16_t LCV = 0;
    for(LCV; LCV < numNeighbors; LCV++)
    {
      local_table[wavelet_level - 1][LCV+1][1] = 0;      
      local_table[wavelet_level - 1][LCV+1][2] = 0;
      local_table[wavelet_level - 1][LCV+1][3] = 0;
    }    
  }
}
