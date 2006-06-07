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
  WaveletLevel *level; // Array
  
  // Defines all possible mote states
  enum {
    S_IDLE = 0,
    S_STARTUP,
    S_START_DATASET,
    S_READING_SENSORS,
    S_UPDATING,
    S_PREDICTING,
    S_CALCULATING,
    S_PREDICTED,
    S_UPDATED,
    S_SKIPLEVEL,
    S_DONE,
    S_OFFLINE,
    S_ERROR
  };
    
  /*** Internal Functions ***/
  task void runState();
  static void readSensors();
  static void nextWaveletLevel();
  static void sendResultsToBase();
  static void sendValuesToNeighbors();
  static void calcNewValues();
  
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
        dataSet = 1;
        // Build coeff reception
        call State.forceState(S_START_DATASET);
        post runState();
        break; }
      case S_START_DATASET: {
        dataSet++;
        dbg(DBG_USR1, "DS: %i, Starting data set...", dataSet);
        call State.forceState(S_READING_SENSORS);
        post runState();
        break; }
      case S_READING_SENSORS: {
        dbg(DBG_USR1, "DS: %i, Reading sensors...", dataSet);
        readSensors();
        // Execute first level state (PREDICTING, UPDATING, or DONE)
        call State.forceState(wtData[curLevel].wt[0].state);
        post runState();
        break; }
      case S_UPDATING: {
        dbg(DBG_USR1, "Update: DS: %i, L: %i, Sending values to predict nodes...",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        waitingFor = wtData[curLevel].numMotes;
        dbg(DBG_USR1, "Update: DS: %i, L: %i, Waiting to hear from predict nodes...",
            dataSet, curLevel + 1);
        break; }
      case S_PREDICTING: {
        waitingFor = wtData[curLevel].numMotes;
        dbg(DBG_USR1, "Predict: DS: %i, L: %i, Waiting to hear from update nodes...",
            dataSet, curLevel + 1);
        break; }  
    /*  case S_CALCULATING: {
        dbg(DBG_USR1, "Calc: DS: %i, L: %i, Calculating new values...",
            dataSet, curLevel);
        calcNewValues();
        break; } */
      case S_PREDICTED: {
        dbg(DBG_USR1, "Predict: DS: %i, L: %i, Sending values to update nodes...",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR1, "Predict: DS: %i, L: %i, Level done!", dataSet, curLevel + 1);
        nextWaveletLevel();
        post runState();
        break; }
      case S_UPDATED: {
        dbg(DBG_USR1, "Update: DS: %i, L: %i, Level done!", dataSet, curLevel + 1);
        nextWaveletLevel();
        post runState();
        break; }
      case S_DONE: {
        dbg(DBG_USR1, "Done: DS: %i, Sending final values to base...", dataSet);
        sendResultsToBase(); 
        break; }
    }
  }
  
  static void readSensors() {
    RawData newVals = call SensorData.readSensors();
    uint8_t i;
    for (i = 0; i < WT_SENSORS; i++)
      wtData[0].wt[0].value[i] = newVals.value[i];
  }
  
  static void nextWaveletLevel() {
    uint8_t i, newState;
    (curLevel == WT_LEVELS) ? newState = S_DONE : (newState = wtData[curLevel].wt[0].state);
    if (newState != S_DONE)
      curLevel++;
    call State.forceState(newState);
  }
  
  static void sendResultsToBase() {
    msgData msg;
    uint8_t i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = WAVELETDATA;
    msg.data.wavelet.state = S_DONE;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wavelet.value[i] = wtData[curLevel].wt[0].value[i];
    call Message.send(msg);
  }
  
  static void sendValuesToNeighbors() {
    msgData msg;
    uint8_t mote, i;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.type = WAVELETDATA;
    msg.data.wavelet.state = call State.getState();
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wavelet.value[i] = wtData[curLevel].wt[0].value[i];
    for (mote = 1; mote < wtData[curLevel].numMotes; mote++) {
      dbg(DBG_USR1, "Update: DS: %i, L: %i, Sending values to predict node %i...",
          dataSet, curLevel + 1, msg.dest);
      call Message.send(msg);
    }
  }
  
  /**
   * Calculates new data values by updating or predicting depending on the
   * sign of the coefficients.  Predict nodes subtract and update nodes add.
   */
  static void calcNewValues() {
    uint8_t mote, sensor;
    dbg(DBG_USR1, "Calc: DS: %i, L: %i, Calculating new values...",
        dataSet, curLevel + 1);
    for (mote = 1; mote < wtData[curLevel].numMotes; mote++) {
      for (sensor = 0; sensor < WT_SENSORS; sensor++)
        wtData[curLevel].wt[0].value[sensor] += wtData[curLevel].wt[mote].value[sensor];
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
      case S_UPDATING: {
        if (result == FAIL)
          dbg(DBG_USR1, "Update: DS: %i, L: %i, Sending values to predict motes failed!",
              dataSet, curLevel + 1);
        break; }
      case S_DONE: {
        if (result == SUCCESS) {
          dbg(DBG_USR1, "Done: DS: %i, Sending final values to base successful", dataSet);
          call State.toIdle();
        } else {
          dbg(DBG_USR1, "Done: DS: %i, Sending final values to base failed!", dataSet);
        } break; }
    }
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event result_t Message.receive(msgData msg) {
    uint8_t mote, curState, rcvState, newState;
    if (msg.type == WAVELETDATA) { // Ignore other message types
      switch (call State.getState()) {
        case S_PREDICTING: {
          if (msg.data.wavelet.state == S_UPDATING) {
            for (mote = 1; mote < wtData[curLevel].numMotes; mote++) {
              if (wtData[curLevel].neighbors[mote] == msg.src)
                break;
            }
            if (mote < wtData[curLevel].numMotes) {
              dbg(DBG_USR1, "Predict: DS: %i, L: %i, Got values from update mote %i",
                  dataSet, curLevel + 1, mote);
              wtData[curLevel].wt[mote] = msg.data.wavelet;
              if (--waitingFor == 0) {
                calcNewValues();
                call State.forceState(S_PREDICTED);
                post runState();
              }             
            } else {
              dbg(DBG_USR1, "Predict: DS: %i, L: %i, BAD NEIGHBOR! Got values from update mote %i",
                  dataSet, curLevel + 1, mote);
            }
          }
          break; }
        case S_UPDATING: {
          if (msg.data.wavelet.state == S_PREDICTED) {
            for (mote = 1; mote < wtData[curLevel].numMotes; mote++) {
              if (wtData[curLevel].neighbors[mote] == msg.src)
                break;
            }
            if (mote < wtData[curLevel].numMotes) {
              dbg(DBG_USR1, "Update: DS: %i, L: %i, Got values from predict mote %i",
                  dataSet, curLevel + 1, mote);
              wtData[curLevel].wt[mote] = msg.data.wavelet;
              if (--waitingFor == 0) {
                calcNewValues();
                call State.forceState(S_UPDATED);
                post runState();
              }             
            } else {
              dbg(DBG_USR1, "Update: DS: %i, L: %i, BAD NEIGHBOR! Got values from predict mote %i",
                  dataSet, curLevel + 1, mote);
            }
          }
          break; }
      }
    }
    return SUCCESS;
  }
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t Timeout.fired() {return SUCCESS;}
  
  /**
   * The signal generated by the timer when it fires.
   */
  event result_t NewSet.fired() {return SUCCESS;}
}
