/**
 * Links Stats to the packets passing through the mote and applications
 * running on it.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
configuration StatsC {
  uses {
    interface Message;
    interface BigPackClient as WaveletPack;
    interface BigPackServer as StatsPack;
    interface SensorData;
  }
  provides interface Stats;
}
implementation {
  components Main, StatsM, TransceiverC;
  
  StatsM.Snoop -> TransceiverC.Transceiver[AM_UNICASTPACK];
  Main.StdControl -> StatsM;
  
  SensorData = StatsM;
  WaveletPack = StatsM;
  StatsPack = StatsM;
  Message = StatsM;
  Stats = StatsM;
}