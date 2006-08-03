/**
 * Top level configuration for testing different components.
 * @author Ryan Stinnett
 */

includes BigPack;

configuration TestC {}
implementation {
  components Main, 
//             DelugeC, 
//             NetworkC,
             TimerC, 
//             BigPackM,
//             ConfigTestM,
//             StatsC,
//             ArrayTestM,
//             RandomLFSR,
//             StatsArrayM,
             MoteOptionsC;
//             WaveletM, 
//             LedsC;
//             StateC, 
//             SampleM, 
//            SensorControlC;
#ifdef BEEP
  components BeepC;
#endif

  /*** MoteOptions: applies mote-wide options ***/
  //ConfigTestM.MoteOptions -> MoteOptionsC;

  /*** ConfigTest: requests wavelet config on start ***/
  //Main.StdControl -> ConfigTestM;
  
  /*** ArrayTest: verifys operation of sorted arrays ***/
  Main.StdControl -> StatsArrayM;
  //ArrayTestM.Random -> RandomLFSR;
  ArrayTestM.StatsArray  -> StatsArrayM.StatsArray[1];
  
  /*** Stats: sends packet and app stats when requested ***/
  //MoteOptionsC.Stats -> StatsC;
            
  /*** Sample: tests sensor and messaging components ***/
  //Main.StdControl -> SampleM;
  //SampleM.Timer -> TimerC.Timer[unique("Timer")];
  //SampleM.Message -> NetworkC;
  //SampleM.SensorData -> SensorControlC;

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  ArrayTestM.Message -> NetworkC;
  //MoteOptionsC.Message -> NetworkC;
  //WaveletM.Message -> NetworkC;
  //WaveletM.Router -> NetworkC;
  BigPackM.Message -> NetworkC;
  //ConfigTestM.Message -> NetworkC;
  StatsC.Message -> NetworkC;
  
  /*** SensorControl: reads various sensor values ***/
  //WaveletM.SensorData -> SensorControlC.SensorData[unique("SensorData")];
  StatsC.SensorData -> SensorControlC.SensorData[unique("SensorData")];
  
  /*** State: state machine library ***/
  //Main.StdControl -> StateC;
  //WaveletM.State -> StateC.State[unique("State")];
  
  /*** BigPack: receives multi-packet data ***/
  Main.StdControl -> BigPackM;
  //WaveletM.BigPackClient -> BigPackM.BigPackClient[BP_WAVELETCONF];
  StatsC.WaveletPack -> BigPackM.BigPackClient[BP_WAVELETCONF];
  StatsC.StatsPack -> BigPackM.BigPackServer[BP_STATS];
#ifdef BEEP
  //BigPackM.Beep -> BeepC;
#endif
  
  /*** Wavelet: main wavelet application ***/
  //Main.StdControl -> WaveletM;
  //WaveletM.Leds -> LedsC;
  //WaveletM.SensorData -> SensorControlC;
  
  /*** Timer: enforces time-based control ***/
  Main.StdControl -> TimerC;
  //ArrayTestM.Timer -> TimerC.Timer[unique("Timer")];
  //ConfigTestM.Timer -> TimerC.Timer[unique("Timer")];
  BigPackM.MsgRepeat -> TimerC.Timer[unique("Timer")];
  //WaveletM.DataSet -> TimerC.Timer[unique("Timer")];
  //WaveletM.StateTimer -> TimerC.Timer[unique("Timer")];
}
