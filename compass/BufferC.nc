// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This buffer sends and receives IOPacks with the Transceiver, while preventing
 * from becoming congested.
 * @author The Moters
 * @author Ryan Stinnett
 */
 
includes IOPack;

configuration BufferC {
  provides interface Buffer;
}
implementation
{
  components BufferM, TransceiverC, Main;

  Buffer = BufferM;
  Main.StdControl -> TransceiverC;
  BufferM.IO -> TransceiverC.Transceiver[TR_COMPASS];
}
