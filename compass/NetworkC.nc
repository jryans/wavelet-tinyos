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
    interface StdControl;
    interface StdControl as TransControl;
  }
  uses {
    interface MoteOptions;
  }
}
implementation {
  components BroadcastM, UnicastM, RouterC, 
             TransceiverC, LedsC, TimerC;
#ifdef BEEP
  components BeepC;
#endif
  
  /*** Services ***/
  TransControl = TransceiverC;
  StdControl = TimerC;
  
  /*** Broadcast ***/
  BroadcastM.IO -> TransceiverC.Transceiver[AM_BROADCASTPACK];
  MoteOptions = BroadcastM;
  BroadcastM.Leds -> LedsC;
  BroadcastM.Repeat -> TimerC.Timer[unique("Timer")];
#ifdef BEEP
  BroadcastM.Beep -> BeepC;
#endif
  Message = BroadcastM;
  
  /*** Unicast ***/
  UnicastM.IO -> TransceiverC.Transceiver[AM_UNICASTPACK];
  MoteOptions = UnicastM;
  UnicastM.Router -> RouterC;
  UnicastM.Leds -> LedsC;
#ifdef BEEP
  UnicastM.Beep -> BeepC;
#endif
  Message = UnicastM;
  
  /*** Routing ***/
  Router = RouterC;
}
