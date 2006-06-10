// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Manages the motes to perform a wavelet transform on incoming sensor data.
 * Uses the State library to manage graceful state transitions.
 * @author The Moters
 * @author Ryan Stinnett
 */

includes MessageData;
includes Sensors;

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
    
    /*** Wavelet Config ***/
    interface WaveletConfig;
  }
  provides interface StdControl;
}
implementation
{ 
  #if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char WaveletLevel;
  #endif
  
  /*** Variables and Constants ***/ 
  uint8_t curLevel; // The current wavelet transform level
  uint8_t dataSet; // Identifies the current data set number
  uint8_t waitingFor; // Number of motes we are waiting on
  
  uint8_t numLevels; // Total number of wavelet levels
  WaveletLevel *level; // Array of WaveletLevels
  
  // Defines all possible mote states
  enum {
    S_IDLE = 0,
    S_STARTUP = 1,
    S_START_DATASET = 2,
    S_READING_SENSORS = 3,
    S_UPDATING = 4,
    S_PREDICTING = 5,
    S_CALCULATING = 6,
    S_PREDICTED = 7,
    S_UPDATED = 8,
    S_SKIPLEVEL = 9,
    S_DONE = 10,
    S_OFFLINE = 11,
    S_ERROR = 12
  };
    
  /*** Internal Functions ***/
  task void runState();
  void readSensors();
  void nextWaveletLevel();
  void sendResultsToBase();
  void sendValuesToNeighbors();
  void calcNewValues();
  
  /**
   * This is the heart of the wavelet algorithm's state management.
   * Whenever the state is changed, this task is posted to run whatever
   * functions that state requires.
   */
  task void runState() {
    switch (call State.getState()) {
      case S_STARTUP: { // Retrieve wavelet config data
        curLevel = 0;
        dataSet = 0;
        call WaveletConfig.getConfig();
        break; }
      case S_START_DATASET: {
        dataSet++;
        dbg(DBG_USR2, "DS: %i, Starting data set...\n", dataSet);
        call State.forceState(S_READING_SENSORS);
        post runState();
        break; }
      case S_READING_SENSORS: {
        dbg(DBG_USR2, "DS: %i, Reading sensors...\n", dataSet);
        readSensors();
        // Execute first level state (PREDICTING, UPDATING, or DONE)
        call State.forceState(level[curLevel].nb[0].data.state);
        post runState();
        break; }
      case S_UPDATING: {
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        waitingFor = level[curLevel].nbCount;
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Waiting to hear from predict nodes...\n",
            dataSet, curLevel + 1);
        break; }
      case S_PREDICTING: {
        waitingFor = level[curLevel].nbCount;
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Waiting to hear from update nodes...\n",
            dataSet, curLevel + 1);
        break; }  
    /*  case S_CALCULATING: {
        dbg(DBG_USR2, "Calc: DS: %i, L: %i, Calculating new values...\n",
            dataSet, curLevel);
        calcNewValues();
        break; } */
      case S_PREDICTED: {
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Sending values to update nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        nextWaveletLevel();
        post runState();
        break; }
      case S_UPDATED: {
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        nextWaveletLevel();
        post runState();
        break; }
      case S_DONE: {
        dbg(DBG_USR2, "Done: DS: %i, Sending final values to base...\n", dataSet);
        sendResultsToBase(); 
        break; }
    }
  }
  
  void readSensors() {
    RawData newVals = call SensorData.readSensors();
    uint8_t i;
    for (i = 0; i < WT_SENSORS; i++)
      level[0].nb[0].data.value[i] = newVals.value[i];
  }
  
  void nextWaveletLevel() {
    uint8_t i, newState;
    (curLevel == numLevels) ? newState = S_DONE : 
                              (newState = level[curLevel].nb[0].data.state);
    if (newState != S_DONE)
      curLevel++;
    call State.forceState(newState);
  }
  
  void sendResultsToBase() {
    msgData msg;
    uint8_t i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = WAVELETDATA;
    msg.data.wData.state = S_DONE;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = level[curLevel].nb[0].data.value[i];
    call Message.send(msg);
  }
  
  void sendValuesToNeighbors() {
    msgData msg;
    uint8_t mote, i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.type = WAVELETDATA;
    msg.data.wData.state = call State.getState();
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = level[curLevel].nb[0].data.value[i];
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      msg.dest = level[curLevel].nb[mote].info.id;
      if (call State.getState() == S_UPDATING) { // U nodes sending scaling values
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict node %i...\n",
            dataSet, curLevel + 1, msg.dest);
      } else { // P nodes sending update values
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Sending values to update node %i...\n",
            dataSet, curLevel + 1, msg.dest);
      }
      call Message.send(msg);
    }
  }
  
  /**
   * Calculates new data values by updating or predicting depending on the
   * sign of the coefficients.  Predict nodes subtract and update nodes add.
   */
  void calcNewValues() {
    uint8_t mote, sensor;
    dbg(DBG_USR2, "Calc: DS: %i, L: %i, Calculating new values...\n",
        dataSet, curLevel + 1);
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      for (sensor = 0; sensor < WT_SENSORS; sensor++)
        level[curLevel].nb[0].data.value[sensor] += level[curLevel].nb[mote].data.value[sensor];
    }
  }

  /*** Commands and Events ***/
  
  command result_t StdControl.init() 
  {
    return SUCCESS;
  }
  
  command result_t StdControl.start() 
  {
    if (TOS_LOCAL_ADDRESS == 0) {
      call State.forceState(S_OFFLINE);
    } else {
      call NewSet.start(TIMER_ONE_SHOT, 10000);
    }
//    post runState();
    return SUCCESS;
  }
  
  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
  
  event result_t WaveletConfig.configDone(WaveletLevel *configData,
                                          uint8_t lvlCount, result_t result) {
    if (result == SUCCESS) {
      level = configData;
      numLevels = lvlCount;
      call State.forceState(S_START_DATASET);
      post runState();
    }
    return SUCCESS; 
  }
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result) {
    switch (call State.getState()) {
      case S_UPDATING: {
        if (result == FAIL)
          dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict motes failed!\n",
              dataSet, curLevel + 1);
        break; }
      case S_DONE: {
        if (result == SUCCESS) {
          dbg(DBG_USR2, "Done: DS: %i, Sending final values to base successful\n", dataSet);
          call State.toIdle();
        } else {
          dbg(DBG_USR2, "Done: DS: %i, Sending final values to base failed!\n", dataSet);
        } break; }
    }
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    uint8_t mote, curState, rcvState, newState;
    if (msg.type == WAVELETDATA) { // Ignore other message types
      switch (call State.getState()) {
        case S_PREDICTING: {
          if (msg.data.wData.state == S_UPDATING) {
            for (mote = 1; mote < level[curLevel].nbCount; mote++) {
              if (level[curLevel].nb[mote].info.id == msg.src)
                break;
            }
            if (mote < level[curLevel].nbCount) {
              dbg(DBG_USR2, "Predict: DS: %i, L: %i, Got values from update mote %i\n",
                  dataSet, curLevel + 1, mote);
              level[curLevel].nb[mote].data = msg.data.wData;
              if (--waitingFor == 0) {
                calcNewValues();
                call State.forceState(S_PREDICTED);
                post runState();
              }             
            } else {
              dbg(DBG_USR2, "Predict: DS: %i, L: %i, BAD NEIGHBOR! Got values from update mote %i\n",
                  dataSet, curLevel + 1, mote);
            }
          }
          break; }
        case S_UPDATING: {
          if (msg.data.wData.state == S_PREDICTED) {
            for (mote = 1; mote < level[curLevel].nbCount; mote++) {
              if (level[curLevel].nb[mote].info.id == msg.src)
                break;
            }
            if (mote < level[curLevel].nbCount) {
              dbg(DBG_USR2, "Update: DS: %i, L: %i, Got values from predict mote %i\n",
                  dataSet, curLevel + 1, mote);
              level[curLevel].nb[mote].data = msg.data.wData;
              if (--waitingFor == 0) {
                calcNewValues();
                call State.forceState(S_UPDATED);
                post runState();
              }             
            } else {
              dbg(DBG_USR2, "Update: DS: %i, L: %i, BAD NEIGHBOR! Got values from predict mote %i\n",
                  dataSet, curLevel + 1, mote);
            }
          }
          break; }
      }
    }
  }
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t Timeout.fired() {return SUCCESS;}
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t NewSet.fired() {
    call State.forceState(S_STARTUP);
    post runState();
    return SUCCESS;
  }
}
