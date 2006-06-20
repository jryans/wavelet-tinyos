/**
 * Links Stats to the packets passing through the mote and applications
 * running on it.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
configuration StatsC {
  uses interface Message;
  provides interface Stats;
}
implementation {
  components StatsM, TransceiverC;
  
  StatsM.Snoop -> TransceiverC.Transceiver[AM_UNICASTPACK];
  Message = StatsM;
  Stats = StatsM;
}
