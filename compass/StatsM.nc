/**
 * Transfers various details about the mote's network packets and
 * applications to the computer on request.
 * TODO: Try to eliminate reporting on ourselves in wavelet stats.
 * @author Ryan Stinnett
 */
 
includes MessageType;
includes Sensors;
includes Ping;
includes BigPack;

module StatsM {
  uses {
    interface Transceiver as Snoop[uint8_t type];
    interface ProtoStats[uint8_t type];
    interface SrcReceiveMsg[uint8_t type];
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
  typedef char MoteStats;
  typedef char StatsReport;
  typedef char ExtWaveletConf;
  typedef char ExtWaveletLevel;
  typedef char StatsWT;
  typedef char StatsWTL;
  typedef char StatsWTNB;
  typedef char WaveletData;
  typedef char BigPackEnvelope;
#endif
  
  MoteStats data;
  bool wtAlloc;
  
  bool statsBP = FALSE;

  bool checkMsg(uint8_t type, TOS_MsgPtr m);
  bool checkProtoMsg(uint8_t type, TOS_MsgPtr m);
  void waveletFree();
  result_t populatePack();
  void clearStats();
  
  // Stats: reports sent by applications and erase support
  
  /**
   * Submits a new report.
   */
  command void Stats.file(StatsReport report) {
    switch (report.type) {
    case WT_CACHE: {
      CacheReport *c = &report.data.cache;
      data.wavelet.level[c->level].nb[c->index].cacheHits++;
      break; }
    }
  }
  
  /**
   * Clears current stats data.
   */
  command void Stats.clear() {
    clearStats();
  }
  
  // Snoop: pretends to be Transceiver so it can listen to packets
  
  /**
   * Stores details for each packet sent.
   */
  event result_t Snoop.radioSendDone[uint8_t type](TOS_MsgPtr m, result_t result) {
    if (m->addr != TOS_BCAST_ADDR) {
      if (!checkProtoMsg(type, m))
        return SUCCESS;
      data.pSent++;
      if (m->ack == 1)
        data.pAcked++;
    }
    return SUCCESS;
  }
  
  /**
   * Stats doesn't track UART packets.
   */
  event result_t Snoop.uartSendDone[uint8_t type](TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * Stores details for each packet received.
   */
  event TOS_MsgPtr Snoop.receiveRadio[uint8_t type](TOS_MsgPtr m) {
    if (m->addr != TOS_BCAST_ADDR) {
#ifdef PLATFORM_MICAZ
      int16_t rssi;
#endif
      if (!checkProtoMsg(type, m))
        return m;
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
  event TOS_MsgPtr Snoop.receiveUart[uint8_t type](TOS_MsgPtr m) {
    return m;
  }
  
  // ProtoStats: listens to events from the routing protocol subsystems
  
  event result_t ProtoStats.sendDone[uint8_t type](TOS_MsgPtr msg, result_t result, uint8_t attemptNum) {
    if (checkMsg(type, msg)) {
      data.mSent++;
      if (result == SUCCESS)
        data.mDelivered++;
      data.mRetriesSum += attemptNum;
      if (type == AM_WAVELETDATA) {
        WaveletData *wd = (WaveletData *)msg->data;
        if (wd->level < data.wavelet.numLevels) {
          uint8_t i;
          StatsWTL *level = &data.wavelet.level[wd->level];
          for (i = 0; i < level->nbCount; i++) {
            if (msg->addr == level->nb[i].id)
              break;
          }
          if (i < level->nbCount)
            level->nb[i].retries += attemptNum;
        }
      }
    }
    return SUCCESS;
  }
  
  event TOS_MsgPtr SrcReceiveMsg.receive[uint8_t type](uint16_t src, TOS_MsgPtr m) {
    if (checkMsg(type, m))
      data.mRcvd++;
    return m;
  }
  
  // BigPack: sends and receives multi-packet data
  
  /**
   * Stores wavelet node configuration to packets sent for each
   * neighbor separately.
   */
  event void WaveletPack.requestDone(void *mainBlock, result_t result) {
    if (result == SUCCESS) {
      uint8_t l, i;
      ExtWaveletConf *conf = (ExtWaveletConf *) mainBlock;
      ExtWaveletLevel **lvl = conf->level;
      StatsWT *w = &data.wavelet;
      waveletFree();
      dbg(DBG_USR1, "Stats: Big Pack Config Test\n");
      w->numLevels = conf->numLevels;
      if ((w->level = malloc(w->numLevels * sizeof(StatsWTL))) == NULL) {
        dbg(DBG_USR1, "Stats: Couldn't allocate wavelet.level!\n");
        return;
      } 
      for (l = 0; l < w->numLevels; l++) {
        dbg(DBG_USR1, "Stats: Level #%i\n", l + 1);
        w->level[l].nbCount = lvl[l]->nbCount;
        if ((w->level[l].nb = malloc(w->level[l].nbCount * sizeof(StatsWTNB))) == NULL) {
          dbg(DBG_USR1, "Stats: Couldn't allocate nb for wavelet.level #%i!\n", l + 1);
          return;
        } 
        for (i = 0; i < w->level[l].nbCount; i++) {
          dbg(DBG_USR1, "Stats:   Neighbor #%i\n", i + 1);
          (i != 0) ? (w->level[l].nb[i].id = lvl[l]->nb[i].id)
                   : (w->level[l].nb[i].id = 0);
          dbg(DBG_USR1, "Stats:     ID:    %i\n", w->level[l].nb[i].id);
          w->level[l].nb[i].retries = 0;
          w->level[l].nb[i].cacheHits = 0;
        }
      }
      wtAlloc = TRUE; 
    }
    call WaveletPack.free();
  }
  
  /**
   * Begins assembling the requested pack by reading a new
   * voltage value.  When this completes, the pack itself
   * will actually be assembled.
   */
  event void StatsPack.buildPack() {
    // Update voltage value
    call SensorData.readSensors();
  }
  
  // SensorData: reads current voltage
  
  /**
   * Once a new voltage value has been read in, the rest of the
   * stats data is gathered and the pack is built.
   */
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
  
  // Internal Functions
  
  /**
   * Fills in all the data structure descriptors needed by
   * the BigPack protocol.
   */
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
  
  /**
   * Deallocates the wavelet configuration data.
   */
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
  
  /**
   * Clears all stats data.
   */
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
    data.mDelivered = 0; // Messages sent and successfully delivered (2)
    data.mRetriesSum = 0; // Sum of retries over all messages (2)
  }
  
  /**
   * Filters out some message types from being counted in stats data.
   * Returns TRUE if the message should be counted and FALSE if not.
   */
  bool checkMsg(uint8_t type, TOS_MsgPtr m) {
    switch (type) {
    case AM_BIGPACKHEADER: {
      BigPackHeader *bph = (BigPackHeader *)m->data;
      if (bph->requestType == BP_STATS) {
        statsBP = TRUE;
      } else {
        statsBP = FALSE;
      }
      return !statsBP;
      break; }
    case AM_BIGPACKDATA: {
      return !statsBP;
      break; }
    case AM_MOTEOPTIONS: {
      return FALSE;
      break; }
    case AM_PWRCONTROL: {
      return FALSE;
      break; }
    }
    return TRUE;
  }
  
  bool checkProtoMsg(uint8_t type, TOS_MsgPtr m) {
    // Copy message so we don't interfere with other receivers
    TOS_Msg mNoHeader;
    TOS_MsgPtr mnh = &mNoHeader;
    memcpy(mnh, m, sizeof(TOS_Msg));
    // Remove header
    if (call ProtoStats.removeHeader[type](mnh) == FAIL)
      return FALSE;
    // Check this new message
    return checkMsg(type, mnh);    
  }
  
  // StdControl
  
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
