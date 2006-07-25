/**
 * Transfers various details about the mote's network packets and
 * applications to the computer on request.
 * TODO: Try to eliminate reporting on ourselves in wavelet stats.
 * @author Ryan Stinnett
 */
 
includes MessageData;
includes Sensors;
includes Ping;

module StatsM {
  uses {
    interface Transceiver as Snoop[uint8_t id];
    interface Message;
    interface BigPackClient as WaveletPack;
    interface BigPackServer as StatsPack;
    interface SensorData;
    interface StatsArray as RSSI;
    interface StatsArray as LQI;
  }
  provides {
    interface Stats;
    interface StdControl;
  }
}
implementation {
  
#if 0 // TinyOS Plugin Workaround
  typedef char uPack;
  typedef char msgData;
  typedef char MoteStats;
  typedef char StatsReport;
  typedef char ExtWaveletConf;
  typedef char ExtWaveletLevel;
  typedef char StatsWT;
  typedef char StatsWTL;
  typedef char StatsWTNB;
  typedef char BigPackEnvelope;
#endif
  
  MoteStats data;
  bool wtAlloc;
  
  bool statsBP = FALSE;

  bool checkMsg(msgData msg);
  void waveletFree();
  result_t populatePack();
  void clearStats();
  
  /*** Stats: reports sent by applications and erase support ***/
  
  command void Stats.file(StatsReport report) {
    switch (report.type) {
    case WT_CACHE: {
      CacheReport *c = &report.data.cache;
      data.wavelet.level[c->level].nb[c->index].cacheHits++;
      break; }
    }
  }
  
  command void Stats.clear() {
    clearStats();
  }
  
  /*** Snoop: pretends to be Transceiver so it can listen to packets ***/
  
  /**
   * Stores details for each packet sent.
   */
  event result_t Snoop.radioSendDone[uint8_t id](TOS_MsgPtr m, result_t result) {
    if (id == AM_UNICASTPACK || id == AM_PINGMSG) {
      if (id == AM_UNICASTPACK) {
        uPack *pPack = (uPack *)m->data;
        if (!checkMsg(pPack->data))
          return SUCCESS;
      }
      data.pSent++;
      if (m->ack == 1)
        data.pAcked++;
    }
    return SUCCESS;
  }
  
  /**
   * Stats doesn't track UART packets.
   */
  event result_t Snoop.uartSendDone[uint8_t id](TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * Stores details for each packet received.
   */
  event TOS_MsgPtr Snoop.receiveRadio[uint8_t id](TOS_MsgPtr m) {
    if (id == AM_UNICASTPACK || id == AM_PINGMSG) {
#ifdef PLATFORM_MICAZ
      int16_t rssi;
#endif
      if (id == AM_UNICASTPACK) {
        uPack *pPack = (uPack *)m->data;
        if (!checkMsg(pPack->data))
          return m;
      }
#ifdef PLATFORM_MICAZ
      rssi = m->strength;
      if (rssi > 127) 
        rssi -= 256;
      call RSSI.newData(rssi);
      call LQI.newData(m->lqi);
#endif
      data.pRcvd++;
    }
    return m;
  }
  
  /**
   * Stats doesn't track UART packets.
   */
  event TOS_MsgPtr Snoop.receiveUart[uint8_t id](TOS_MsgPtr m) {
    return m;
  }
  
  /*** Message: listens to Message events ***/
  
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    if (checkMsg(msg)) {
      data.mSent++;
      data.mRetriesSum += retries;
      if (msg.type == WAVELETDATA) {
        if (msg.data.wData.level < data.wavelet.numLevels) {
          uint8_t i;
          StatsWTL *level = &data.wavelet.level[msg.data.wData.level];
          for (i = 0; i < level->nbCount; i++) {
            if (msg.dest == level->nb[i].id)
              break;
          }
          if (i < level->nbCount)
            level->nb[i].retries += retries;
        }
      }
    }
    return SUCCESS;
  }
  
  event void Message.receive(msgData msg) {
    if (checkMsg(msg)) {
      data.mRcvd++;
    }
  }
  
  /*** BigPack: sends and receives multi-packet data ***/
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  event void WaveletPack.requestDone(int8_t *mainBlock, result_t result) {
    if (result == SUCCESS) {
      uint8_t l, i;
      ExtWaveletConf *conf = (ExtWaveletConf *) mainBlock;
      ExtWaveletLevel **lvl = conf->level;
      StatsWT *w = &data.wavelet;
      waveletFree();
      dbg(DBG_USR2, "Stats: Big Pack Config Test\n");
      w->numLevels = conf->numLevels;
      if ((w->level = malloc(w->numLevels * sizeof(StatsWTL))) == NULL) {
        dbg(DBG_USR2, "Stats: Couldn't allocate wavelet.level!\n");
        return;
      } 
      for (l = 0; l < w->numLevels; l++) {
        dbg(DBG_USR2, "Stats: Level #%i\n", l + 1);
        w->level[l].nbCount = lvl[l]->nbCount;
        if ((w->level[l].nb = malloc(w->level[l].nbCount * sizeof(StatsWTNB))) == NULL) {
          dbg(DBG_USR2, "Stats: Couldn't allocate nb for wavelet.level #%i!\n", l + 1);
          return;
        } 
        for (i = 0; i < w->level[l].nbCount; i++) {
          dbg(DBG_USR2, "Stats:   Neighbor #%i\n", i + 1);
          w->level[l].nb[i].id = lvl[l]->nb[i].id;
          dbg(DBG_USR2, "Stats:     ID:    %i\n", w->level[l].nb[i].id);
          w->level[l].nb[i].retries = 0;
          w->level[l].nb[i].cacheHits = 0;
        }
      }
      wtAlloc = TRUE; 
    }
    call WaveletPack.free();
  }
  
  event void StatsPack.buildPack() {
    // Update voltage value
    call SensorData.readSensors();
  }
  
  /*** SensorData: reads current voltage ***/
  
  event void SensorData.readDone(float *newVals) {
    data.voltage = newVals[VOLT];
    // Fill in RSSI
    data.rssiMin = (int8_t) call RSSI.min();
    data.rssiMax = (int8_t) call RSSI.max();
    data.rssiMean = call RSSI.mean();
    data.rssiMedian = call RSSI.median();
    // Fill in LQI
    data.lqiMin = (int8_t) call LQI.min();
    data.lqiMax = (int8_t) call LQI.max();
    data.lqiMean = call LQI.mean();
    data.lqiMedian = call LQI.median();
    // Build pack
    call StatsPack.packBuilt(populatePack());
  }
  
  /*** Internal Functions ***/
  
  result_t populatePack() {
    BigPackEnvelope *env;
    // Find the number of blocks and pointers needed
    uint8_t numBlks, numPtrs, l, p;
    StatsWT *w = &data.wavelet;
    uint8_t lvls = w->numLevels;
    if (lvls > 0) {
      /* Blocks:
       *   For each StatsWTL: one block for neighbor data, one block for level statics
       *   For the MoteStats: one block for static data */
      numBlks = lvls * 2 + 1;
      /* Pointers:
       *   For each StatsWTL: one pointer to neighbor data
       *   For the MoteStats: one pointer to StatsWTL array */
      numPtrs = lvls + 1;
      env = call StatsPack.createEnvelope(numBlks, numPtrs);
      if (env == NULL) return FAIL;
      // StatsWTL
      for (l = 0; l < lvls; l++) {
        env->block[l].length = w->level[l].nbCount * sizeof(StatsWTNB);
        env->blockAddr[l] = (int8_t *) w->level[l].nb;
        env->block[l + lvls].length = sizeof(StatsWTL);
        env->blockAddr[l + lvls] = (int8_t *) &w->level[l];
        env->ptr[l].addrOfBlock = l;
        env->ptr[l].destBlock = l + lvls;
        env->ptr[l].destOffset = 1;
        env->ptr[l].blockArray = FALSE;
      }
      p = l;
      l += lvls;
      // MoteStats
      env->block[l].length = sizeof(MoteStats);
      env->blockAddr[l] = (int8_t *) &data;
      env->ptr[p].addrOfBlock = lvls;
      env->ptr[p].destBlock = l;
#ifdef PLATFORM_PC
      env->ptr[p].destOffset = sizeof(MoteStats) - 4;
#else
      env->ptr[p].destOffset = sizeof(MoteStats) - 2;
#endif
      env->ptr[p].blockArray = TRUE;
    } else {
      // Only need a single block for MoteStats
      numBlks = 1;
      numPtrs = 0;
      env = call StatsPack.createEnvelope(numBlks, numPtrs);
      if (env == NULL) return FAIL;
      // MoteStats
      env->block[0].length = sizeof(MoteStats);
      env->blockAddr[0] = (int8_t *) &data;
    }
    return SUCCESS;
  }
  
  void waveletFree() {
    StatsWT *w = &data.wavelet;
    // If there is retry data, free it
    if (wtAlloc) {
      uint8_t l;
      for (l = 0; l < w->numLevels; l++)
        free(w->level[l].nb);
      free(w->level);
      wtAlloc = FALSE;
    }
  }
  
  void clearStats() {
    data.pRcvd = 0; // Packets received (2)
    data.rssiMin = 0; // Min RSSI over all packets (1)
    data.rssiMax = 0; // Max RSSI over all packets (1)
    data.rssiMean = 0; // Mean of RSSI over all packets (4)
    data.rssiMedian = 0; // Median of RSSI over all packets (4)
    call RSSI.clear();
    data.lqiMin = 0; // Min LQI over all packets (1)
    data.lqiMax = 0; // Max LQI over all packets (1)
    data.lqiMean = 0; // Mean of LQI over all packets (4)
    data.lqiMedian = 0; // Median of LQI over all packets (4)
    call LQI.clear();
    data.pSent = 0; // Packets sent (2)
    data.pAcked = 0; // Packets sent and were ACKed (2) 
    data.mRcvd = 0; // Messages received (2)
    data.mSent = 0; // Messages sent (2)
    data.mRetriesSum = 0; // Sum of retries over all messages (2)
  }
  
  bool checkMsg(msgData msg) {
    switch (msg.type) {
    case BIGPACKHEADER: {
      if (msg.data.bpHeader.requestType == BP_STATS) {
        statsBP = TRUE;
      } else {
        statsBP = FALSE;
      }
      return !statsBP;
      break; }
    case BIGPACKDATA: {
      return !statsBP;
      break; }
    case MOTEOPTIONS: {
      return FALSE;
      break; }
    case PWRCONTROL: {
      return FALSE;
      break; }
    }
    return TRUE;
  }
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    // Clear alloc tracker
    wtAlloc = FALSE;
    // Initialize stats data
    clearStats();
    // Clear wavelet.numLevels in case we don't get any
    data.wavelet.numLevels = 0;
    return SUCCESS;
  }
  
  command result_t StdControl.start() {
    call WaveletPack.registerListener();
    return SUCCESS;
  }
  
  command result_t StdControl.stop() {
    return SUCCESS;
  }
    
}
