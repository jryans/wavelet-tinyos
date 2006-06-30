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
  components MoteOptionsM, Main;
#ifdef PLATFORM_MICAZ
  components CC2420RadioC;

  MoteOptionsM.TransControl -> CC2420RadioC.StdControl;
  MoteOptionsM.MacControl -> CC2420RadioC;
  MoteOptionsM.CC2420Control -> CC2420RadioC;
#endif
  
  Stats = MoteOptionsM;
  MoteOptions = MoteOptionsM;
  Message = MoteOptionsM;
  Main.StdControl -> MoteOptionsM;
}
