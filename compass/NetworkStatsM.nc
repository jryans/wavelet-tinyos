/**
 * Transfers various details about the mote's network packets to the
 * computer on request.
 * @author Ryan Stinnett
 */
 
includes MessageData;

module NetworkStatsM {
  uses {
    interface Transceiver as Snoop;
    interface Message;
  }
}
implementation {
  
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char NetworkStats;
#endif
  
  NetworkStats data;
  
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
    if (msg.src == 0 && msg.type == NETWORKSTATS) {
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.data.stats = data;
      call Message.send(msg);
    } 
  }
    
}
