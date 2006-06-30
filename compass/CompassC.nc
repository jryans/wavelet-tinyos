/**
 * Top level configuration that links applications to various
 * hardware systems.
 * @author Ryan Stinnett
 */
 
includes BigPack;

configuration CompassC {}
implementation {
  components Main, DelugeC, NetworkC, TimerC, BigPackM,
             WaveletM, LedsC, StateC, SensorControlC, StatsC;
#ifdef BEEP
  components BeepC;
#endif

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  //MoteCommandC.Message -> NetworkC;
  WaveletM.Message -> NetworkC;
  WaveletM.Router -> NetworkC;
  BigPackM.Message -> NetworkC;
  StatsC.Message -> NetworkC;
  
  /*** Stats: sends packet and app stats when requested ***/
  WaveletM.Stats -> StatsC;
  
  /*** State: state machine library ***/
  Main.StdControl -> StateC;
  WaveletM.State -> StateC.State[unique("State")];
  
  /*** BigPack: receives multi-packet data ***/
  Main.StdControl -> BigPackM;
  WaveletM.BigPackClient -> BigPackM.BigPackClient[BP_WAVELETCONF];
  StatsC.WaveletPack -> BigPackM.BigPackClient[BP_WAVELETCONF];
  StatsC.StatsPack -> BigPackM.BigPackServer[BP_STATS];
#ifdef BEEP
  BigPackM.Beep -> BeepC;
#endif

  /*** SensorControl: reads various sensor values ***/
  WaveletM.SensorData -> SensorControlC.SensorData[unique("SensorData")];
  StatsC.SensorData -> SensorControlC.SensorData[unique("SensorData")];
  
  /*** Wavelet: main wavelet application ***/
  Main.StdControl -> WaveletM;
  WaveletM.Leds -> LedsC;
#ifdef BEEP
  WaveletM.Beep -> BeepC;
#endif  
  
  /*** Timer: enforces time-based control ***/
  Main.StdControl -> TimerC;
  BigPackM.MsgRepeat -> TimerC.Timer[unique("Timer")];
  WaveletM.DataSet -> TimerC.Timer[unique("Timer")];
  WaveletM.StateTimer -> TimerC.Timer[unique("Timer")];
}
