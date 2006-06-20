/**
 * Links NetworkStats to the packets passing through the mote.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
configuration NetworkStatsC {
  uses interface Message;
}
implementation {
  components NetworkStatsM, TransceiverC;
  
  NetworkStatsM.Snoop -> TransceiverC.Transceiver[AM_UNICASTPACK];
  Message = NetworkStatsM;
}
