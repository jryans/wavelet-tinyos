/**
 * Top level configuration that links applications to various
 * hardware systems.
 * @author Ryan Stinnett
 */

configuration CompassC {}
implementation {
  components Main, DelugeC, NetworkC, MoteCommandC, WaveletM, LedsC,
             SensorControlC, StateC, TimerC, BigPackM;

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  MoteCommandC.Message -> NetworkC;
  WaveletM.Message -> NetworkC;
  WaveletM.Router -> NetworkC;
  BigPackM.Message -> NetworkC;
  
  /*** State: state machine library ***/
  Main.StdControl -> StateC;
  WaveletM.State -> StateC.State[unique("State")];
  
  /*** BigPack: receives multi-packet data ***/
  Main.StdControl -> BigPackM;
  WaveletM.WaveletConfig -> BigPackM;
  
  /*** Wavelet: main wavelet application ***/
  Main.StdControl -> WaveletM;
  WaveletM.Leds -> LedsC;
  WaveletM.SensorData -> SensorControlC;
  
  /*** Timer: enforces time-based control ***/
  BigPackM.MsgRepeat -> TimerC.Timer[unique("Timer")];
  WaveletM.DataSet -> TimerC.Timer[unique("Timer")];
  WaveletM.StateTimer -> TimerC.Timer[unique("Timer")];
}
