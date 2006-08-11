// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Manages the motes to perform a wavelet transform on incoming sensor data.
 * Uses the State library to manage graceful state transitions.
 * @author The Moters
 * @author Ryan Stinnett
 */

includes MessageData;
includes Sensors;

module WaveletM {
  uses {
    /*** I/O and Hardware ***/
    interface Message;
    interface Router;
    interface Leds;
    interface SensorData;
#ifdef BEEP
    interface Beep;
#endif
    interface Stats;
    
    /*** State Management ***/
    interface State;
    interface Timer as DataSet;
    interface Timer as StateTimer;
    interface Timer as DelayResults;
#ifdef RAW
    interface Timer as DelayRaw;
#endif
    interface Random;
    
    /*** Wavelet Config ***/
    interface BigPackClient;
  }
  provides interface StdControl;
}
implementation { 
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char WaveletLevel;
  typedef char ExtWaveletConf;
  typedef char ExtWaveletLevel;
  typedef char ExtWaveletNeighbor;
#endif
  
  /*** Variables and Constants ***/ 
  uint8_t curLevel; // The current wavelet transform level
  uint8_t dataSet; // Identifies the current data set number
  
  uint8_t numLevels; // Total number of wavelet levels
  WaveletLevel *level; // Array of WaveletLevels
  bool wlAlloc;
  
  /*** Compression ***/
  bool predicted; // True if mote predicts
  uint8_t matchingBand; // Index of first band that this mote's values are above
  uint8_t numBands; // Number of bands in the following array
  float compTarget[WT_MAX_BANDS]; // Array of compression target values for each band
  
#ifdef RAW
  float rawVals[WT_SENSORS];
#endif

  /*** Transform Options ***/
  uint32_t dataSetTime; // Length of time between data sets
  uint8_t transformType; // One of various transform types
  uint8_t resultType; // Controls data sent back to base
  uint8_t timeDomainLength; // Number of data points collected for TD transform
  
  /*** State Management ***/
  // Defines all possible mote states
  enum {
    S_IDLE = 0,
    S_STARTUP = 1,
    S_START_DATASET = 2,
    S_READING_SENSORS = 3,
    S_UPDATING = 4,
    S_PREDICTING = 5,
    S_CACHE = 6,
    S_PREDICTED = 7,
    S_UPDATED = 8,
    S_SKIPLEVEL = 9,
    S_TRANSMIT = 10,
    S_OFFLINE = 11,
    S_ERROR = 12,
    S_RAW = 13
  };
  
  uint8_t nextState;
  bool forceNextState;

#ifdef RAW  
  msgData raw;
#endif
  msgData res;
    
  /*** Functions Declarations ***/
  task void runState();
  void levelDone();
  void sendResultsToBase();
#ifdef RAW
  void sendRawToBase();
#endif
  void sendValuesToNeighbors();
  void calcNewValues();
  void delayState();
  void moveToTransmit();
  void clearNeighborState();
  void checkData();
  void waveletFree();
  void sendDelayedMsg();
  
  /*** State Management ***/
  
  /**
   * This is the heart of the wavelet algorithm's state management.
   * Whenever the state is changed, this task is posted to run whatever
   * functions that state requires.
   */
  task void runState() {
    switch (call State.getState()) {
      case S_STARTUP: { // Retrieve wavelet config data
        call Leds.redOn();
        waveletFree();
        call BigPackClient.request();
        break; }
      case S_START_DATASET: {
        call DataSet.start(TIMER_ONE_SHOT, dataSetTime);
        delayState();
        call Leds.redOff();
        call Leds.yellowOn();
        curLevel = 0;
        dataSet++;
        clearNeighborState();
        dbg(DBG_USR2, "DS: %i, Starting data set...\n", dataSet);
        // If a message is received while reading the sensors,
        // temperature values will be way off.  Using state delays
        // on both sides of the sensor reading work around this.
        call State.toIdle();
        break; }
      case S_READING_SENSORS: {
        delayState();
        dbg(DBG_USR2, "DS: %i, Reading sensors...\n", dataSet);
        call SensorData.readSensors();
        break; }
      case S_UPDATING: {
        delayState();
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Waiting to hear from predict nodes...\n",
            dataSet, curLevel + 1);
        break; }
      case S_PREDICTING: {
        delayState();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Waiting to hear from update nodes...\n",
            dataSet, curLevel + 1);
        break; }  
      case S_PREDICTED: {
        delayState();
        calcNewValues();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Sending values to update nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        checkData();
        levelDone();
        call State.toIdle();
        break; }
      case S_UPDATED: {
        delayState();
        calcNewValues();
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        checkData();
        levelDone();
        call State.toIdle();
        break; }
      case S_TRANSMIT: {
        delayState();
#ifdef RAW
        if (resultType & WS_RT_RAW) {
          dbg(DBG_USR2, "Diag: DS: %i, Sending raw values to base...\n", dataSet);
          sendRawToBase();
        }
#endif   
        call Leds.redOn();
        dbg(DBG_USR2, "Done: DS: %i, Sending final values to base...\n", dataSet);
        sendResultsToBase();
        sendDelayedMsg();
        call State.toIdle();
        break; }
      case S_SKIPLEVEL: {
        delayState();
        dbg(DBG_USR2, "Skip: DS: %i, L: %i, Nothing to do, level done!\n", dataSet, curLevel + 1);
        levelDone();
        call State.toIdle();
        break; }
      case S_OFFLINE: {
        dbg(DBG_USR2, "Wavelet: Offline\n");
        dataSet = 0;        
        call Leds.redOff();
        call Leds.yellowOff();
        call State.toIdle();
        break; }
    }
  }
  
  void waveletFree() {
    // If there is config data, free it
    if (wlAlloc) {
      uint8_t l;
      for (l = 0; l < numLevels; l++)
        free(level[l].nb);
      free(level);
      wlAlloc = FALSE;
    }
  }
  
  /**
   * Calculates the delay until the next state change
   * should occur and sets a timer to make it so.
   */
  void delayState() {
    uint32_t delay;
    // Defaults to request instead of force
    forceNextState = FALSE; 
    switch (call State.getState()) {
    case S_START_DATASET: {
      nextState = S_READING_SENSORS;
      delay = 1500;
      break; }  
    case S_READING_SENSORS: {
      nextState = level[curLevel].nb[0].state;
      (nextState == S_UPDATING) ? (delay = 1000)
                                : (delay = 500);
      break; }
    case S_UPDATING: {
      nextState = S_UPDATED;
      forceNextState = TRUE;
      delay = 2000;
      break; }
    case S_PREDICTING: {
      nextState = S_PREDICTED;
      forceNextState = TRUE;
      delay = 1500;
      break; }
    case S_PREDICTED: {
      nextState = S_IDLE;
      delay = 500;
      break; }
    case S_UPDATED: {
      (curLevel + 1 == numLevels) 
        ? (nextState = S_IDLE)
        : (nextState = level[curLevel + 1].nb[0].state);
      if (nextState == S_UPDATING) {
        delay = 1000;
      } else {
        delay = 500;
      }
      break; }
    case S_SKIPLEVEL: {
      (curLevel + 1 == numLevels) 
        ? (nextState = S_IDLE)
        : (nextState = level[curLevel + 1].nb[0].state);
      if (nextState == S_UPDATING) {
        delay = 3500;
      } else if (nextState == S_IDLE) {
        delay = 2500;
      } else {
        delay = 3000;
      }
      break; }
    case S_TRANSMIT: {
      if (resultType & WS_RT_COMP) {
        nextState = S_IDLE;
        delay = numBands * WT_BAND_TIME;
      } else {
        nextState = S_START_DATASET;
        delay = WT_SLOT_STAGE_TIME;
      }
      break; }
    }
    call StateTimer.start(TIMER_ONE_SHOT, delay);
  }
  
  /*** Helper Functions ***/
  
  /**
   * If this mote is not done, then it advances to the next wavelet 
   * level and copies the calculated values to the next level. If it
   * is done and compression is enabled, it find which band matches
   * its values.
   * Called during S_UPDATED, S_PREDICTED, and S_SKIPLEVEL.
   */ 
  void levelDone() {
    uint8_t i;
    if (nextState != S_IDLE) { // More levels to go
      for (i = 0; i < WT_SENSORS; i++) // Carry data over to next level
        level[curLevel + 1].nb[0].value[i] = level[curLevel].nb[0].value[i];
      curLevel++;
    } else { // Data set complete
      if (resultType & WS_RT_COMP) {
        if (predicted) { 
          // Predicted values are assigned a band based on target values
          for (i = 0; i < numBands; i++) {
            if (level[curLevel].nb[0].value[0] >= compTarget[i])
              break;
          }
          matchingBand = i;
        } else {
          // Scaling values are always transmitted
          matchingBand = 0;
        }  
      }
    }
  }
  
  /**
   * Once this mote has finished a data set, its results are packaged
   * up and sent to the computer.
   * Called during S_DONE.
   */
  void sendResultsToBase() {
    msgData msg;
    uint8_t i;
    msg.dest = NET_UART_ADDR;
    msg.type = WAVELETDATA;
    msg.data.wData.dataSet = dataSet;
    msg.data.wData.level = curLevel;
    msg.data.wData.state = S_TRANSMIT;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = level[curLevel].nb[0].value[i];
    res = msg;
  }
  
#ifdef RAW
  /**
   * Once this mote has finished a data set, its raw values are packaged
   * up and sent to the computer.  Only used for testing.
   * Called during S_DONE.
   */  
  void sendRawToBase() {
    msgData msg;
    uint8_t i;
    msg.dest = NET_UART_ADDR;
    msg.type = WAVELETDATA;
    msg.data.wData.dataSet = dataSet;
    msg.data.wData.level = curLevel;
    msg.data.wData.state = S_RAW;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = rawVals[i];
    raw = msg;
  }
#endif
  
  /**
   * For each level where a mote is not skipped or already done,
   * it will be in one of two states:
   * 1. S_UPDATING: Sends scaling values to predict motes and waits
   * 2. S_PREDICTED: Sends its newly calculated predict values
   * Called during S_UPDATED and S_PREDICTED.
   */ 
  void sendValuesToNeighbors() {
    msgData msg;
    uint8_t mote, i;
    msg.type = WAVELETDATA;
    msg.data.wData.dataSet = dataSet;
    msg.data.wData.level = curLevel;
    msg.data.wData.state = call State.getState();
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = level[curLevel].nb[0].value[i];
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      msg.dest = level[curLevel].nb[mote].id;
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
   * Calculates new data values based on data received from neighbors.
   * The specific algorithm is either:
   * 1. S_PREDICTED: Subtracts each neighbor's value multiplied by the coefficient for 
   * that neighbor from this mote's value.
   * 1. S_UPDATED: Adds each neighbor's value multiplied by the coefficient for 
   * that neighbor to this mote's value.
   * Called during S_PREDICTED and S_UPDATED.
   */
  void calcNewValues() {
    uint8_t mote, sensor;
    float sign;
    dbg(DBG_USR2, "Calc: DS: %i, L: %i, Calculating new values...\n",
        dataSet, curLevel + 1);
    (call State.getState() == S_PREDICTED) ? (sign = -1) : (sign = 1);
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      for (sensor = 0; sensor < WT_SENSORS; sensor++)
        level[curLevel].nb[0].value[sensor] += (sign * level[curLevel].nb[mote].coeff
                                                     * level[curLevel].nb[mote].value[sensor]);
    }
  }
  
  /**
   * The simple caching system currently used tries to track if
   * we have received a value from each neighbor we're supposed to
   * hear from during this level.  This is checked by recording the
   * neighbor's state during when it is received.  At the beginning
   * of a new data set, these states are cleared.
   * Called during S_START_DATASET.
   */
  void clearNeighborState() {
    uint8_t lvl, mote;
    for (lvl = 0; lvl < numLevels; lvl++) {
      for (mote = 1; mote < level[lvl].nbCount; mote++) {
        level[lvl].nb[mote].state = S_START_DATASET;
      }
    }
  }
  
  /**
   * Reports any cache hits to Stats by checking if each neighbor's
   * state is still the initial state or was changed, indicatng that
   * new data was received.
   * Called during S_CACHE.
   */
  void checkData() {
    uint8_t mote;
    StatsReport report;
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      if (level[curLevel].nb[mote].state == S_START_DATASET) {
        report.type = WT_CACHE;
        report.data.cache.level = curLevel;
        report.data.cache.index = mote;
        call Stats.file(report);
      } 
    }
  }
  
  void sendDelayedMsg() {
    uint8_t slot = call Random.rand() & (WT_SLOTS - 1);
    uint32_t delay = slot * WT_SLOT_TIME;
#ifdef RAW
    if (resultType & WS_RT_RAW) {
      // Raw values (if enabled) sent in the first band
      uint8_t rawSlot = call Random.rand() & (WT_SLOTS - 1);
      uint32_t rawDelay = rawSlot * WT_SLOT_TIME;
      dbg(DBG_USR2, "Wavelet: Raw: band 0, slot %i, %i bms\n", rawSlot, rawDelay);
      call DelayRaw.start(TIMER_ONE_SHOT, rawDelay);
    }
#endif
    if (resultType & WS_RT_COMP) {
      if (matchingBand == numBands) {
        dbg(DBG_USR2, "Wavelet: Results don't match any bands!\n");
        return;
      }
      delay += matchingBand * WT_BAND_TIME;
      dbg(DBG_USR2, "Wavelet: Results: band %i, slot %i, %i bms\n", matchingBand, slot, delay);
      call DelayResults.start(TIMER_ONE_SHOT, delay);
    } else {
      dbg(DBG_USR2, "Wavelet: Results: band 0, slot %i, %i bms\n", slot, delay);
      call DelayResults.start(TIMER_ONE_SHOT, delay);
    }
  }

  /*** Commands and Events ***/
  
  command result_t StdControl.init() {
    wlAlloc = FALSE;
    call Random.init();
    return SUCCESS;
  }
  
  command result_t StdControl.start() {
    call BigPackClient.registerListener();
    call State.forceState(S_OFFLINE);
    post runState();
    return SUCCESS;
  }
  
  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  event void SensorData.readDone(float *newVals) {
    uint8_t i;
    for (i = 0; i < WT_SENSORS; i++) {
      level[0].nb[0].value[i] = newVals[i];
#ifdef RAW
      rawVals[i] = newVals[i];
#endif      
    }
    call State.toIdle();
  }
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  event void BigPackClient.requestDone(int8_t *mainBlock, result_t result) {
    if (result == SUCCESS) {
      uint8_t i, l;
      ExtWaveletConf *conf = (ExtWaveletConf *) mainBlock;
      ExtWaveletLevel **lvl = conf->level;
      waveletFree();
      dbg(DBG_USR2, "Wavelet: Big Pack Config Test\n");
      predicted = FALSE;
      numLevels = conf->numLevels;
      if ((level = malloc(numLevels * sizeof(WaveletLevel))) == NULL) {
        dbg(DBG_USR2, "Wavelet: Couldn't allocate level!\n");
        return;
      } 
      for (l = 0; l < numLevels; l++) {
        dbg(DBG_USR2, "Wavelet: Level #%i\n", l + 1);
        level[l].nbCount = lvl[l]->nbCount;
        if ((level[l].nb = malloc(level[l].nbCount * sizeof(WaveletNeighbor))) == NULL) {
          dbg(DBG_USR2, "Wavelet: Couldn't allocate nb for level #%i!\n", l + 1);
          return;
        }
        for (i = 0; i < lvl[l]->nbCount; i++) {
          dbg(DBG_USR2, "Wavelet:   Neighbor #%i\n", i + 1);
          level[l].nb[i].id = lvl[l]->nb[i].id;
          dbg(DBG_USR2, "Wavelet:     ID:    %i\n", level[l].nb[i].id);
          level[l].nb[i].state = lvl[l]->nb[i].state;
          dbg(DBG_USR2, "Wavelet:     State: %i\n", level[l].nb[i].state);
          level[l].nb[i].coeff = lvl[l]->nb[i].coeff;
          dbg(DBG_USR2, "Wavelet:     Coeff: %f\n", level[l].nb[i].coeff);
        }
        if (!predicted && level[l].nb[0].state == S_PREDICTING)
          predicted = TRUE;
      }
      wlAlloc = TRUE;
      call State.toIdle();
    }
    call BigPackClient.free();
  }
  
  /**
   * sendDone is signaled when the send has completed
   * TODO: Could be improved, doesn't respond for all messages.
   */
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    /* if (msg.type == WAVELETDATA) {
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
    } */
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    uint8_t mote, sens;
    switch (msg.type) {
    case WAVELETDATA: {
      if (msg.data.wData.dataSet != dataSet
          || msg.data.wData.level != curLevel)
        return; // Rejects data for the wrong data set or level
      switch (call State.getState()) {
      case S_PREDICTING: {
        if (msg.data.wData.state == S_UPDATING) {
          for (mote = 1; mote < level[curLevel].nbCount; mote++) {
            if (level[curLevel].nb[mote].id == msg.src)
              break;
          }
          if (mote < level[curLevel].nbCount) {
            dbg(DBG_USR2, "Predict: DS: %i, L: %i, Got values from update mote %i\n",
                dataSet, curLevel + 1, msg.src);
            level[curLevel].nb[mote].state = msg.data.wData.state;
            for (sens = 0; sens < WT_SENSORS; sens++)
              level[curLevel].nb[mote].value[sens] = msg.data.wData.value[sens];
          } else {
            dbg(DBG_USR2, "Predict: DS: %i, L: %i, BAD NEIGHBOR! Got values from update mote %i\n",
                dataSet, curLevel + 1, msg.src);
          }
        }
        break; }
      case S_UPDATING: {
        if (msg.data.wData.state == S_PREDICTED) {
          for (mote = 1; mote < level[curLevel].nbCount; mote++) {
            if (level[curLevel].nb[mote].id == msg.src)
              break;
          }
          if (mote < level[curLevel].nbCount) {
            dbg(DBG_USR2, "Update: DS: %i, L: %i, Got values from predict mote %i\n",
                dataSet, curLevel + 1, msg.src);
            level[curLevel].nb[mote].state = msg.data.wData.state;
            for (sens = 0; sens < WT_SENSORS; sens++)
              level[curLevel].nb[mote].value[sens] = msg.data.wData.value[sens];
          } else {
            dbg(DBG_USR2, "Update: DS: %i, L: %i, BAD NEIGHBOR! Got values from predict mote %i\n",
                dataSet, curLevel + 1, msg.src);
          }
        }
        break; }
      }
      break; }
    case WAVELETSTATE: {
      WaveletState *ws = &msg.data.wState;
      WaveletOpt *wo = &msg.data.wState.data.opt;
      if (TOS_LOCAL_ADDRESS == 0)
        return;
      dbg(DBG_USR2, "Wavelet: Rcvd new state data\n");
      if (ws->mask & WS_TRANSFORMTYPE) {
        dbg(DBG_USR2, "Wavelet: Setting transform type to %i\n", wo->transformType);
        transformType = wo->transformType;
      }
      if (ws->mask & WS_RESULTTYPE) {
        dbg(DBG_USR2, "Wavelet: Setting result type to %i\n", wo->resultType);
        resultType = wo->resultType;
      }
      if (ws->mask & WS_TIMEDOMAINLENGTH) {
        dbg(DBG_USR2, "Wavelet: Setting time domain length to %i\n", wo->timeDomainLength);
        timeDomainLength = wo->timeDomainLength;
      }
      if (ws->mask & WS_DATASETTIME) {
        dbg(DBG_USR2, "Wavelet: Setting data set time to %i\n", wo->dataSetTime);
        dataSetTime = wo->dataSetTime;
      }
      if (ws->mask & WS_COMPTARGET) {
        WaveletComp *wc = &msg.data.wState.data.comp;
        dbg(DBG_USR2, "Wavelet: Storing compression band target array\n");
        numBands = wc->numBands;
        memcpy(compTarget, wc->compTarget, sizeof(compTarget));
      }
      if (ws->mask & WS_STATE) {
        // Ignore start command if we don't have the data set time
        if (ws->state == S_START_DATASET && dataSetTime == 0)
          break;
        // Allows stoping and restarting on demand
        call DataSet.stop();
        call StateTimer.stop();
        call DelayResults.stop();
#ifdef RAW        
        call DelayRaw.stop();
#endif        
        call State.forceState(ws->state);
        post runState();        
      }
      break; }
    }
  }
  
  /*** Timers ***/
  
  /**
   * Enforces the dataSetTime interval by moving to the transmit
   * stage when the timer fires.
   */
  event result_t DataSet.fired() {
    moveToTransmit();
    return SUCCESS;
  }
  
  /**
   * Enforces delays between each state change.
   */
  event result_t StateTimer.fired() {
    if (call State.requestState(nextState) == FAIL) {
      if (forceNextState) {
        call State.forceState(nextState);
        dbg(DBG_USR1, "Wavelet: Forced to state %i\n", nextState);
        post runState();
      } else {      
        dbg(DBG_USR2, "Wavelet: Not enough time before moving to state %i!\n", nextState);
#ifdef BEEP
        call Beep.play(1, 250);
#endif
      }
    } else { 
      dbg(DBG_USR1, "Wavelet: Moved to state %i\n", nextState);
      post runState();      
    }
    return SUCCESS;
  }
  
  event result_t DelayResults.fired() {   
    call Message.send(res);
    return SUCCESS;
  }
  
#ifdef RAW
  event result_t DelayRaw.fired() {   
    call Message.send(raw);   
    return SUCCESS;
  }
#endif
  
  /**
   * Moves to the transmit stage.
   */
  void moveToTransmit() {
    if (call State.requestState(S_TRANSMIT) == FAIL) {
      dbg(DBG_USR2, "Wavelet: Data set %i did not finish in time!\n", dataSet);
#ifdef BEEP
      call Beep.play(1, 250);
#endif
    } else {
      post runState();
    }
  }
}
