/**
 * Links together the networking system components and presents them as a
 * simple, tidy package to applications.
 * @author Ryan Stinnett
 */

includes IOPack;

configuration NetworkC {
  provides interface Message;
}
implementation {
  // Broadcast and Unicast
  components Main, BroadcastM, TransceiverC;
  
  Main.StdControl -> TransceiverC;
  
  /*** Broadcast ***/
  Main.StdControl -> BroadcastM;
  BroadcastM.IO -> TransceiverC.Transceiver[TR_BROAD];
  Message = BroadcastM;
}
