/**
 * Top level configuration that links applications to various
 * hardware systems.
 * @author Ryan Stinnett
 */

configuration CompassC {}
implementation {
  components Main, DelugeC, NetworkC, MoteCommandC, WaveletM, LedsC,
             SensorControlC, StateC, TimerC;

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  MoteCommandC.Message -> NetworkC;
  WaveletM.Message -> NetworkC;
  WaveletM.Router -> NetworkC;
  
  /*** State: state machine library ***/
  Main.StdControl -> StateC;
  WaveletM.State -> StateC.State[unique("State")];
  
  /*** Wavelet: main wavelet application ***/
  Main.StdControl -> WaveletM;
  WaveletM.Leds -> LedsC;
  WaveletM.SensorData -> SensorControlC;
  WaveletM.Timeout -> TimerC.Timer[unique("Timer")];
  WaveletM.NewSet -> TimerC.Timer[unique("Timer")];
}
