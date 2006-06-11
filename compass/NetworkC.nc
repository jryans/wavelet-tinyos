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
  components Main, BroadcastM, UnicastM, RouterSimM, TransceiverC;
  
  Main.StdControl -> TransceiverC;
  
  /*** Broadcast ***/
  Main.StdControl -> BroadcastM;
  BroadcastM.IO -> TransceiverC.Transceiver[AM_BROADCASTPACK];
  Message = BroadcastM;
  
  /*** Unicast ***/
  UnicastM.IO -> TransceiverC.Transceiver[AM_UNICASTPACK];
  UnicastM.Router -> RouterSimM;
  Message = UnicastM;
  
  /*** Routing ***/
  Main.StdControl -> RouterSimM;
  RouterSimM.IO -> TransceiverC.Transceiver[AM_ROUTER];
  Router = RouterSimM;
}
