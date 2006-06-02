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
  components Main, BroadcastM, UnicastM, StaticRouterM, TransceiverC;
  
  Main.StdControl -> TransceiverC;
  
  /*** Broadcast ***/
  Main.StdControl -> BroadcastM;
  BroadcastM.IO -> TransceiverC.Transceiver[TR_BROAD];
  Message = BroadcastM;
  
  /*** Unicast ***/
  UnicastM.IO -> TransceiverC.Transceiver[TR_UNI];
  UnicastM.Router -> StaticRouterM;
  Message = UnicastM;
  
  /*** Routing ***/
  Main.StdControl -> StaticRouterM;
  StaticRouterM.IO -> TransceiverC.Transceiver[TR_ROUTE];
  Router = StaticRouterM;
}
