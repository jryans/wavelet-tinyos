/**
 * Links together the networking system components and presents them as a
 * simple, tidy package to applications.
 * @author Ryan Stinnett
 */

includes IOPack;

configuration RouterC {
  provides {
    interface Router;
  }
}
implementation {
  components Main, RouterStaticM, 
             TransceiverC, NetworkC;
  
  /*** Routing ***/
  Main.StdControl -> RouterStaticM;
  RouterStaticM.IO -> TransceiverC.Transceiver[AM_ROUTER];
  RouterStaticM.Message -> NetworkC;
  Router = RouterStaticM;
}
