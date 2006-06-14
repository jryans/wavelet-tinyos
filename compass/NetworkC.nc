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
  components Main, BroadcastM, UnicastM, RouterSimM, 
             TransceiverC, CC2420RadioC;
  
  Main.StdControl -> TransceiverC;
  
  /*** Broadcast ***/
  Main.StdControl -> BroadcastM;
  BroadcastM.IO -> TransceiverC.Transceiver[AM_BROADCASTPACK];
  Message = BroadcastM;
  
  /*** Unicast ***/
  Main.StdControl -> UnicastM;
  UnicastM.IO -> TransceiverC.Transceiver[AM_UNICASTPACK];
  UnicastM.Router -> RouterSimM;
  Message = UnicastM;
  
  /*** Routing ***/
  Main.StdControl -> RouterSimM;
  RouterSimM.IO -> TransceiverC.Transceiver[AM_ROUTER];
  Router = RouterSimM;
  
  /*** CC2420 ***/
  UnicastM.TransControl -> CC2420RadioC.StdControl;
  UnicastM.MacControl -> CC2420RadioC;
  UnicastM.CC2420Control -> CC2420RadioC;
}
