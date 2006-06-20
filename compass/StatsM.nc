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
  }
  provides {
    interface Stats;
  }
}
implementation {
  
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char MoteStats;
  typedef char StatsReport;
#endif
  
  MoteStats data;
  uint8_t freeReportAt; // Index of next free report
  
  /*** Stats: reports sent by applications ***/
  command void Stats.file(StatsReport report) {
    uint8_t i;
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
    }
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
   * NetworkStats doesn't track UART packets.
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
   * NetworkStats doesn't track UART packets.
   */
  event TOS_MsgPtr Snoop.receiveUart(TOS_MsgPtr m) {
    return m;
  }
  
  /*** Message: transfers stats when requested and listens to Send commands ***/
  
  event result_t Message.sendDone(msgData msg, result_t result) {
    return SUCCESS;
  }
  
  event void Message.receive(msgData msg) {
    if (msg.src == 0 && msg.type == MOTESTATS) {
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.data.stats = data;
      msg.data.stats.numReps = freeReportAt;
      call Message.send(msg);
    } 
  }
    
}
