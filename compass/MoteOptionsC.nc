/**
 * Applies various settings for this mote.
 * @author Ryan Stinnett
 */

configuration MoteOptionsC {
  uses {
    interface Message;
    interface Stats;
  }
  provides interface MoteOptions;
}
implementation {
  components MoteOptionsM, Main, TimerC, HPLPowerManagementM, LedsC, TransceiverC;
#ifdef PLATFORM_MICAZ
  components CC2420RadioC;
  MoteOptionsM.TransControl -> TransceiverC;
  //MoteOptionsM.TransControl -> CC2420RadioC;
  MoteOptionsM.MacControl -> CC2420RadioC;
  MoteOptionsM.CC2420Control -> CC2420RadioC;
#endif

  Main.StdControl -> TimerC;
  MoteOptionsM.Wake -> TimerC.Timer[unique("Timer")];
  MoteOptionsM.Sleep -> TimerC.Timer[unique("Timer")];
  MoteOptionsM.Leds -> LedsC;
  MoteOptionsM.PM -> HPLPowerManagementM;
  
  Stats = MoteOptionsM;
  MoteOptions = MoteOptionsM;
  Message = MoteOptionsM;
  Main.StdControl -> MoteOptionsM;
}
