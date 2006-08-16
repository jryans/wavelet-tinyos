// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Manages the motes to perform a wavelet transform on incoming sensor data.
 * Uses the State library to manage graceful state transitions.
 * @author The Moters
 * @author Ryan Stinnett
 */

includes MessageData;
includes Sensors;
includes Wavelet;

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
    interface Timer as TransmitTimer;
    interface Timer as SampleTimer;
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
  uint8_t curTime; // Index in time that the current sample will fill
  uint8_t nextTime; // Index in time that the next sample will fill
  
  uint8_t numLevels; // Total number of wavelet levels
  WaveletLevel *level; // Array of WaveletLevels
  bool wlAlloc; // TRUE is level has been allocated, else FALSE.
  
  /*** Compression ***/
  bool predicted; // True if mote predicts
  uint8_t matchingBand; // Index of first band that this mote's values are above
  uint8_t numBands; // Number of bands in the following array
  float compTarget[WT_MAX_BANDS]; // Array of compression target values for each band
  
#ifdef RAW
  float rawVals[WT_SENSORS];
#endif

  /*** Transform Options ***/
  uint32_t sampleTime; // Length of time between samples
  uint8_t transformType; // One of various transform types
  uint8_t resultType; // Controls data sent back to base
  uint8_t timeDomainLength; // Number of data points collected for TD transform
  
  /*** State Management ***/
  uint8_t nextState;
  bool forceNextState;
  bool sampleTimerRunning;

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
  void delayNextState();
  void clearNeighborState();
  void checkData();
  void waveletFree();
  void sendDelayedMsg();
  uint32_t getTransmitTime();
  
  /*** State Management ***/
  
  /**
   * This is the heart of the wavelet algorithm's state management.
   * Whenever the state is changed, this task is posted to run whatever
   * functions that state requires.
   */
  task void runState() {
    delayNextState();
    switch (call State.getState()) {
      case WS_CONFIGURE: { // Retrieve wavelet config data
        call Leds.redOn();
        waveletFree();
        call BigPackClient.request();
        break; }
      case WS_CLEAR_SENSORS: {
        if (!sampleTimerRunning) {
          call SampleTimer.start(TIMER_REPEAT, sampleTime);
          sampleTimerRunning = TRUE;
        }
        call State.toIdle();
        break; }
      case WS_READING_SENSORS: {
        dbg(DBG_USR2, "Wavelet: DS: %i, Reading sensor data for sample %i...\n", dataSet + 1, curTime);
        call SensorData.readSensors();
        curTime = nextTime;
        break; }
      case WS_START_DATASET: {
        call TransmitTimer.start(TIMER_ONE_SHOT, 
             sampleTime - WT_COLLECT_SAMPLE_TIME - getTransmitTime());
        call Leds.redOff();
        call Leds.yellowOn();
        curLevel = 0;
        dataSet++;
        clearNeighborState();
        dbg(DBG_USR2, "Wavelet: DS: %i, Starting data set...\n", dataSet);
        // If a message is received while reading the sensors,
        // temperature values will be way off.  Using state delays
        // on both sides of the sensor reading work around this.
        call State.toIdle();
        break; }      
      case WS_UPDATING: {
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Waiting to hear from predict nodes...\n",
            dataSet, curLevel + 1);
        break; }
      case WS_PREDICTING: {
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Waiting to hear from update nodes...\n",
            dataSet, curLevel + 1);
        break; }  
      case WS_PREDICTED: {
        calcNewValues();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Sending values to update nodes...\n",
            dataSet, curLevel + 1);
        sendValuesToNeighbors();
        dbg(DBG_USR2, "Predict: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        checkData();
        levelDone();
        call State.toIdle();
        break; }
      case WS_UPDATED: {
        calcNewValues();
        dbg(DBG_USR2, "Update: DS: %i, L: %i, Level done!\n", dataSet, curLevel + 1);
        checkData();
        levelDone();
        call State.toIdle();
        break; }
      case WS_TRANSMIT: {
#ifdef RAW
        if (resultType & WC_RT_RAW) {
          dbg(DBG_USR1, "Transmit: DS: %i, Sending raw values to base...\n", dataSet);
          sendRawToBase();
        }
#endif   
        call Leds.redOn();
        dbg(DBG_USR1, "Transmit: DS: %i, Sending final values to base...\n", dataSet);
        sendResultsToBase();
        sendDelayedMsg();
        call State.toIdle();
        break; }
      case WS_SKIPLEVEL: {
        dbg(DBG_USR2, "Skip: DS: %i, L: %i, Nothing to do, level done!\n", dataSet, curLevel + 1);
        levelDone();
        call State.toIdle();
        break; }
      case WS_OFFLINE: {
        dbg(DBG_USR2, "Wavelet: Offline\n");
        call SampleTimer.stop();
        sampleTimerRunning = FALSE;
        call TransmitTimer.stop();
        call StateTimer.stop();
        call DelayResults.stop();
#ifdef RAW        
        call DelayRaw.stop();
#endif
        dataSet = 0;
        curTime = 0;       
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
  void delayNextState() {
    uint32_t delay = 0;
    // Defaults to request instead of force
    forceNextState = FALSE; 
    switch (call State.getState()) {
    case WS_CLEAR_SENSORS: {
      nextState = WS_READING_SENSORS;
      delay = WSD_CS_TO_RS;
      nextTime = (curTime + 1) % timeDomainLength;
      break; }
    case WS_READING_SENSORS: {
      if (nextTime) {
        nextState = WS_IDLE;
        dbg(DBG_USR2, "Wavelet: Unimplemented time domain in use!\n");
      } else { 
        nextState = WS_START_DATASET;
      }
      delay = WSD_RS_TO_ANY;
      break; }
    case WS_START_DATASET: {
      nextState = level[0].nb[0].state;
      (nextState == WS_UPDATING) ? (delay = WSD_SDS_TO_UING)
                                : (delay = WSD_SDS_TO_OTHER);
      break; }    
    case WS_UPDATING: {
      nextState = WS_UPDATED;
      forceNextState = TRUE;
      delay = WSD_UING_TO_UED;
      break; }
    case WS_PREDICTING: {
      nextState = WS_PREDICTED;
      forceNextState = TRUE;
      delay = WSD_PING_TO_PED;
      break; }
    case WS_PREDICTED: {
      nextState = WS_IDLE;
      delay = WSD_PED_TO_IDLE;
      break; }
    case WS_UPDATED: {
      (curLevel + 1 == numLevels) 
        ? (nextState = WS_IDLE)
        : (nextState = level[curLevel + 1].nb[0].state);
      if (nextState == WS_UPDATING) {
        delay = WSD_UED_TO_UING;
      } else {
        delay = WSD_UED_TO_OTHER;
      }
      break; }
    case WS_SKIPLEVEL: {
      (curLevel + 1 == numLevels) 
        ? (nextState = WS_IDLE)
        : (nextState = level[curLevel + 1].nb[0].state);
      if (nextState == WS_UPDATING) {
        delay = WSD_SKIP_TO_UING;
      } else if (nextState == WS_IDLE) {
        delay = WSD_SKIP_TO_IDLE;
      } else {
        delay = WSD_SKIP_TO_OTHER;
      }
      break; }
    }
    if (delay)
      call StateTimer.start(TIMER_ONE_SHOT, delay);
  }
  
  /*** Helper Functions ***/
  
  /**
   * If this mote is not done, then it advances to the next wavelet 
   * level and copies the calculated values to the next level. If it
   * is done and compression is enabled, it find which band matches
   * its values.
   * Called during WS_UPDATED, WS_PREDICTED, and WS_SKIPLEVEL.
   */ 
  void levelDone() {
    uint8_t i;
    if (nextState != WS_IDLE) { // More levels to go
      for (i = 0; i < WT_SENSORS; i++) // Carry data over to next level
        level[curLevel + 1].nb[0].value[i] = level[curLevel].nb[0].value[i];
      curLevel++;
    } else { // Data set complete
      if (resultType & WC_RT_COMP) {
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
   * Called during WS_TRANSMIT.
   */
  void sendResultsToBase() {
    msgData msg;
    uint8_t i;
    msg.dest = NET_UART_ADDR;
    msg.type = WAVELETDATA;
    msg.data.wData.dataSet = dataSet;
    msg.data.wData.level = curLevel;
    msg.data.wData.state = WS_TRANSMIT;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = level[curLevel].nb[0].value[i];
    res = msg;
  }
#ifdef RAW

  /**
   * Once this mote has finished a data set, its raw values are packaged
   * up and sent to the computer.  Only used for testing.
   * Called during WS_TRANSMIT.
   */  
  void sendRawToBase() {
    msgData msg;
    uint8_t i;
    msg.dest = NET_UART_ADDR;
    msg.type = WAVELETDATA;
    msg.data.wData.dataSet = dataSet;
    msg.data.wData.level = curLevel;
    msg.data.wData.state = WS_RAW;
    for (i = 0; i < WT_SENSORS; i++)
      msg.data.wData.value[i] = rawVals[i];
    raw = msg;
  }
#endif
  
  /**
   * For each level where a mote is not skipped or already done,
   * it will be in one of two states:
   * 1. WS_UPDATING: Sends scaling values to predict motes and waits
   * 2. WS_PREDICTED: Sends its newly calculated predict values
   * Called during WS_UPDATED and WS_PREDICTED.
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
      if (call State.getState() == WS_UPDATING) { // U nodes sending scaling values
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
   * 1. WS_PREDICTED: Subtracts each neighbor's value multiplied by the coefficient for 
   * that neighbor from this mote's value.
   * 1. WS_UPDATED: Adds each neighbor's value multiplied by the coefficient for 
   * that neighbor to this mote's value.
   * Called during WS_PREDICTED and WS_UPDATED.
   */
  void calcNewValues() {
    uint8_t mote, sensor;
    float sign;
    dbg(DBG_USR2, "Calc: DS: %i, L: %i, Calculating new values...\n",
        dataSet, curLevel + 1);
    (call State.getState() == WS_PREDICTED) ? (sign = -1) : (sign = 1);
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
   * Called during WS_START_DATASET.
   */
  void clearNeighborState() {
    uint8_t lvl, mote;
    for (lvl = 0; lvl < numLevels; lvl++) {
      for (mote = 1; mote < level[lvl].nbCount; mote++) {
        level[lvl].nb[mote].state = WS_START_DATASET;
      }
    }
  }
  
  /**
   * Reports any cache hits to Stats by checking if each neighbor's
   * state is still the initial state or was changed, indicatng that
   * new data was received.
   * Called during WS_CACHE.
   */
  void checkData() {
    uint8_t mote;
    StatsReport report;
    for (mote = 1; mote < level[curLevel].nbCount; mote++) {
      if (level[curLevel].nb[mote].state == WS_START_DATASET) {
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
    if (resultType & WC_RT_RAW) {
      // Raw values (if enabled) sent in the first band
      uint8_t rawSlot = call Random.rand() & (WT_SLOTS - 1);
      uint32_t rawDelay = rawSlot * WT_SLOT_TIME;
      dbg(DBG_USR2, "Transmit: Raw:     band 0, slot %i, %i bms\n", rawSlot, rawDelay);
      call DelayRaw.start(TIMER_ONE_SHOT, rawDelay);
    }
#endif
    if (resultType & WC_RT_COMP) {
      if (matchingBand == numBands) {
        dbg(DBG_USR2, "Transmit: Results don't match any bands!\n");
        return;
      }
      delay += matchingBand * WT_BAND_TIME;
      dbg(DBG_USR2, "Transmit: Results: band %i, slot %i, %i bms\n", matchingBand, slot, delay);
      call DelayResults.start(TIMER_ONE_SHOT, delay);
    } else {
      dbg(DBG_USR2, "Transmit: Results: band 0, slot %i, %i bms\n", slot, delay);
      call DelayResults.start(TIMER_ONE_SHOT, delay);
    }
  }
  
  uint32_t getTransmitTime() {
    if (resultType & WC_RT_COMP) {        
      return WT_BAND_TIME * numBands;
    }      
    return WT_SLOT_STAGE_TIME;
  }

  /*** Commands and Events ***/
  
  command result_t StdControl.init() {
    wlAlloc = FALSE;
    call Random.init();
    return SUCCESS;
  }
  
  command result_t StdControl.start() {
    call BigPackClient.registerListener();
    call State.forceState(WS_OFFLINE);
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
        if (!predicted && level[l].nb[0].state == WS_PREDICTING)
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
        case WS_UPDATING: {
          if (result == FAIL)
            dbg(DBG_USR2, "Update: DS: %i, L: %i, Sending values to predict motes failed!\n",
                dataSet, curLevel + 1);
          break; }
        case WS_DONE: {
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
      case WS_PREDICTING: {
        if (msg.data.wData.state == WS_UPDATING) {
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
      case WS_UPDATING: {
        if (msg.data.wData.state == WS_PREDICTED) {
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
    case WAVELETCONTROL: {
      WaveletControl *wc = &msg.data.wCntl;
      WaveletOpt *wo = &msg.data.wCntl.data.opt;
      if (TOS_LOCAL_ADDRESS == 0)
        return;
      if (wc->mask & WC_TRANSFORMTYPE) {
        dbg(DBG_USR2, "Wavelet: Setting transform type to %i\n", wo->transformType);
        transformType = wo->transformType;
        if (transformType == WC_TT_2DRWAGNER)
          timeDomainLength = 1;
      }
      if (wc->mask & WC_RESULTTYPE) {
        dbg(DBG_USR2, "Wavelet: Setting result type to %i\n", wo->resultType);
        resultType = wo->resultType;
      }
      if (wc->mask & WC_TIMEDOMAINLENGTH) {
        dbg(DBG_USR2, "Wavelet: Setting time domain length to %i\n", wo->timeDomainLength);
        timeDomainLength = wo->timeDomainLength;
      }
      if (wc->mask & WC_SAMPLETIME) {
        dbg(DBG_USR2, "Wavelet: Setting sample time to %i\n", wo->sampleTime);
        sampleTime = wo->sampleTime;
      }
      if (wc->mask & WC_COMPTARGET) {
        WaveletComp *wComp = &msg.data.wCntl.data.comp;
        dbg(DBG_USR2, "Wavelet: Storing compression band target array\n");
        numBands = wComp->numBands;
        memcpy(compTarget, wComp->compTarget, sizeof(compTarget));
      }
      if (wc->mask & WC_CMD) {
        int8_t state = -1;
        bool force = FALSE;
        // Ignore start command if we don't have the sample time
        if (wc->cmd == WC_START_TRANSFORM && sampleTime == 0)
          break;
        switch (wc->cmd) {
        case WC_CONFIGURE: {
          state = WS_CONFIGURE;
          break; } 
        case WC_START_TRANSFORM: {
          state = WS_CLEAR_SENSORS;
          break; } 
        case WC_STOP_TRANSFORM: {
          state = WS_OFFLINE;
          force = TRUE;
          break; } 
        case WC_STOP_DATASET: {
          state = WS_IDLE;
          call DelayResults.stop();
#ifdef RAW
          call DelayRaw.stop();
#endif       
          break; } 
        }
        // Ignore unsupported commands
        if (state == -1)
          break;
        if (call State.requestState(state) == FAIL) {
          if (force) {
            call State.forceState(state);
            dbg(DBG_USR1, "Wavelet: Forced to state %i\n", state);          
          } else {      
            dbg(DBG_USR2, "Wavelet: Failed to process command %i, still in state %i!\n", 
                wc->cmd, call State.getState());
          }
        } else { 
          dbg(DBG_USR1, "Wavelet: Moved to state %i\n", state);     
        }
        dbg(DBG_USR1, "Wavelet: Processed command %i successfully\n", wc->cmd);
        post runState();
      }
      break; }
    }
  }
  
  /*** Timers ***/
  
  /**
   * Enforces a synchronized transmit time by moving to the transmit
   * stage when the timer fires.
   */
  event result_t TransmitTimer.fired() {
    if (call State.requestState(WS_TRANSMIT) == FAIL) {
      dbg(DBG_USR2, "Wavelet: Data set %i did not finish in time!\n", dataSet);
#ifdef BEEP
      call Beep.play(1, 250);
#endif
    } else {
      post runState();
    }
    return SUCCESS;
  }
  
  /**
   * Fires periodically to collect data samples.  After all
   * samples needed for a full time domain set have been collected,
   * the 2D spatial transform will be started.  Even if the time
   * domain transform is not activated, that is just the same as
   * as a time domain set of length 1.
   */
  event result_t SampleTimer.fired() {
    if (call State.requestState(WS_CLEAR_SENSORS) == FAIL) {
      dbg(DBG_USR2, "Wavelet: Moving to collect sample %i failed!\n", curTime);
#ifdef BEEP
      call Beep.play(1, 250);
#endif
    } else {
      post runState();
    }
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
        dbg(DBG_USR2, "Wavelet: Failed to move to state %i, still in state %i!\n", 
            nextState, call State.getState());
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
    dbg(DBG_USR2, "Transmit: Results sent!\n");
    return SUCCESS;
  }
#ifdef RAW

  event result_t DelayRaw.fired() {   
    call Message.send(raw);   
    dbg(DBG_USR2, "Transmit: Raw sent!\n");
    return SUCCESS;
  }
#endif
}
