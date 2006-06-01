// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Responds to commands received through the transceiver for this mote
 * @author The Moters
 * @author Ryan Stinnett
 */

configuration MoteCommandC {
  uses interface Message;
}
implementation {
  components MoteCommandM, LedsC, Main;

  Message = MoteCommandM;
  Main.StdControl -> MoteCommandM;
  MoteCommandM.Leds -> LedsC;
}
