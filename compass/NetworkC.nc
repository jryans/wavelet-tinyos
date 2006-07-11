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
  components Main, BroadcastM, UnicastM, RouterC, 
             TransceiverC, LedsC, TimerC;
#ifdef BEEP
  components BeepC;
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
  UnicastM.IO -> TransceiverC.Transceiver[AM_UNICASTPACK];
  UnicastM.Router -> RouterC;
  UnicastM.Leds -> LedsC;
#ifdef BEEP
  UnicastM.Beep -> BeepC;
#endif
  Message = UnicastM;
  
  /*** Routing ***/
  Router = RouterC;
}
