/**
 * Applies various settings for this mote.
 * @author Ryan Stinnett
 */

configuration MoteOptionsC {
  uses {
    interface Message;
    interface Stats;
    interface StdControl as TransControl;
    interface StdControl as DelugeControl;
  }
  provides interface MoteOptions;
}
implementation {
  components MoteOptionsM, Main, TimerC, HPLPowerManagementM, LedsC;
#ifdef PLATFORM_MICAZ
  components CC2420RadioC;
  MoteOptionsM.MacControl -> CC2420RadioC;
  MoteOptionsM.CC2420Control -> CC2420RadioC;
#endif

  Main.StdControl -> TimerC;
  MoteOptionsM.Wake -> TimerC.Timer[unique("Timer")];
  MoteOptionsM.Sleep -> TimerC.Timer[unique("Timer")];
  MoteOptionsM.Deluge -> TimerC.Timer[unique("Timer")];
  MoteOptionsM.Leds -> LedsC;
  MoteOptionsM.PM -> HPLPowerManagementM;
  TransControl = MoteOptionsM.TransControl;
  DelugeControl = MoteOptionsM.DelugeControl;
  
  Stats = MoteOptionsM;
  MoteOptions = MoteOptionsM;
  Message = MoteOptionsM;
  Main.StdControl -> MoteOptionsM;
}
