/**
 * Top level configuration for testing different components.
 * @author Ryan Stinnett
 */

configuration TestC {}
implementation {
  components Main, 
             DelugeC, 
             NetworkC,
             TimerC, 
//             BigPackM,
             ConfigTestM,
//             MoteCommandC,
//             WaveletM, 
             LedsC,
//             StateC, 
//             SampleM, 
//             SensorControlC;
             NewBigPackM;
#ifdef BEEP
  components BeepC;
#endif

  /*** ConfigTest: requests wavelet config on start ***/
  Main.StdControl -> ConfigTestM;
  ConfigTestM.WaveletConfig -> NewBigPackM;
  ConfigTestM.Timer -> TimerC.Timer[unique("Timer")];
             
  /*** Sample: tests sensor and messaging components ***/
  //Main.StdControl -> SampleM;
  //SampleM.Timer -> TimerC.Timer[unique("Timer")];
  //SampleM.Message -> NetworkC;
  //SampleM.SensorData -> SensorControlC;

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  //MoteCommandC.Message -> NetworkC;
  //WaveletM.Message -> NetworkC;
  //WaveletM.Router -> NetworkC;
  NewBigPackM.Message -> NetworkC;
  
  /*** State: state machine library ***/
  //Main.StdControl -> StateC;
  //WaveletM.State -> StateC.State[unique("State")];
  
  /*** BigPack: receives multi-packet data ***/
  Main.StdControl -> NewBigPackM;
  //WaveletM.WaveletConfig -> BigPackM;
#ifdef BEEP
  NewBigPackM.Beep -> BeepC;
#endif
  
  /*** Wavelet: main wavelet application ***/
  //Main.StdControl -> WaveletM;
  //WaveletM.Leds -> LedsC;
  //WaveletM.SensorData -> SensorControlC;
  
  /*** Timer: enforces time-based control ***/
  Main.StdControl -> TimerC;
  NewBigPackM.MsgRepeat -> TimerC.Timer[unique("Timer")];
  //WaveletM.DataSet -> TimerC.Timer[unique("Timer")];
  //WaveletM.StateTimer -> TimerC.Timer[unique("Timer")];
}
