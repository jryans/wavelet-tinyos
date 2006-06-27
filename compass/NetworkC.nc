/**
 * Links together the networking system components and presents them as a
 * simple, tidy package to applications.
 * @author Ryan Stinnett
 */

includes IOPack;

configuration NetworkC {
  provides {
    interface Message;
    interface Router;
  }
}
implementation {
  components Main, BroadcastM, UnicastM, RouterStaticM, 
             TransceiverC, LedsC, TimerC;
#ifdef BEEP
  components BeepC;
#endif
#ifdef PLATFORM_MICAZ
  components CC2420RadioC;
#endif
  
  /*** Services ***/
  Main.StdControl -> TransceiverC;
  Main.StdControl -> TimerC;
  
  /*** Broadcast ***/
  BroadcastM.IO -> TransceiverC.Transceiver[AM_BROADCASTPACK];
  BroadcastM.Leds -> LedsC;
  BroadcastM.Repeat -> TimerC.Timer[unique("Timer")];
#ifdef BEEP
  BroadcastM.Beep -> BeepC;
#endif
  Message = BroadcastM;
  
  /*** Unicast ***/
  Main.StdControl -> UnicastM;
  UnicastM.IO -> TransceiverC.Transceiver[AM_UNICASTPACK];
  UnicastM.Router -> RouterStaticM;
  UnicastM.Leds -> LedsC;
#ifdef BEEP
  UnicastM.Beep -> BeepC;
#endif
  Message = UnicastM;
  
  /*** Routing ***/
  Main.StdControl -> RouterStaticM;
  RouterStaticM.IO -> TransceiverC.Transceiver[AM_ROUTER];
  Router = RouterStaticM;
  
#ifdef PLATFORM_MICAZ
  /*** CC2420 ***/
  UnicastM.TransControl -> CC2420RadioC.StdControl;
  UnicastM.MacControl -> CC2420RadioC;
  UnicastM.CC2420Control -> CC2420RadioC;
#endif
}
