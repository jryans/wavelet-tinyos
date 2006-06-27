/**
 * Transfers various details about the mote's network packets and
 * applications to the computer on request.
 * @author Ryan Stinnett
 */
 
includes MessageData;

module StatsM {
  uses {
    interface Transceiver as Snoop;
    interface Message;
    interface BigPackClient as WaveletPack;
    interface BigPackServer as StatsPack;
  }
  provides {
    interface Stats;
    interface StdControl;
  }
}
implementation {
  
#if 0 // TinyOS Plugin Workaround
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
  uint8_t freeReportAt; // Index of next free report
  void waveletFree();
  
  /*** Stats: reports sent by applications ***/
  command void Stats.file(StatsReport report) {
 /*   uint8_t i;
    bool found = FALSE;
    // Check if report is new
    for (i = 0; i < MAX_STATS_REPORTS; i++) {
      if (data.reports[i].type == report.type) {
        switch (report.type) {
        case WT_CACHE: {
          if (data.reports[i].data.cache.level == report.data.cache.level &&
              data.reports[i].data.cache.mote == report.data.cache.mote)
            found = TRUE;
          break; }
        }
      if (found)
        break;
      }
    }
    if (i < MAX_STATS_REPORTS) { // Found the same report
      data.reports[i].number += report.number;
    } else if (freeReportAt < MAX_STATS_REPORTS) { // Store a new report
       data.reports[freeReportAt] = report;
       freeReportAt++;
    } */
  }
  
  /*** Snoop: pretends to be Transceiver so it can listen to packets ***/
  
  /**
   * Stores details for each packet sent.
   */
  event result_t Snoop.radioSendDone(TOS_MsgPtr m, result_t result) {
    data.sent++;
    if (m->ack == 1)
      data.acked++;
    
    return SUCCESS;
  }
  
  /**
   * Stats doesn't track UART packets.
   */
  event result_t Snoop.uartSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS;
  }
  
  /**
   * Stores details for each packet received.
   */
  event TOS_MsgPtr Snoop.receiveRadio(TOS_MsgPtr m) {
    int16_t rssi = m->strength;
    if (rssi > 127) 
      rssi -= 256;
    data.rssi += rssi;
    data.rcvd++;    
    return m;
  }
  
  /**
   * Stats doesn't track UART packets.
   */
  event TOS_MsgPtr Snoop.receiveUart(TOS_MsgPtr m) {
    return m;
  }
  
  /*** Message: transfers stats when requested and listens to Send commands ***/
  
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
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
    return SUCCESS;
  }
  
  event void Message.receive(msgData msg) {
 /*   if (msg.src == 0 && msg.type == MOTESTATS) {
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.data.stats = data;
      msg.data.stats.numReps = freeReportAt;
      call Message.send(msg);
    } */
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
  
  event result_t StatsPack.buildPack() {
    BigPackEnvelope *env;
    // Find the number of blocks and pointers needed
    uint8_t numBlks, numPtrs, l;
    StatsWT *w = &data.wavelet;
    uint8_t lvls = w->numLevels;
    /* Blocks:
     *   For each StatsWTL: one block for neighbor data, one block for level statics
     *   For the MoteStats: one block for static data */
    numBlks = lvls * 2 + 1;
    /* Pointers:
     *   For each StatsWTL: one pointer to neighbor data
     *   For the MoteStats: one pointer to StatsWT */
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
    // MoteStats
    env->block[l + lvls].length = sizeof(MoteStats);
    env->blockAddr[l + lvls] = (int8_t *) &data;
    env->ptr[l].addrOfBlock = lvls;
    env->ptr[l].destBlock = l;
    env->ptr[l].destOffset = 12;
    env->ptr[l].blockArray = TRUE;
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
  
  /*** StdControl ***/
  command result_t StdControl.init() {
    wtAlloc = FALSE;
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
