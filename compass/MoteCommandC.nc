// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Responds to commands received through the transceiver for this mote.
 * Useful for diagnostics and testing, but not for general use.
 * @author The Moters
 * @author Ryan Stinnett
 */

configuration MoteCommandC {
  uses interface Message;
}
implementation {
  components MoteCommandM, LedsC, Main, TimerC, BeepC;
  
  MoteCommandM.Beep -> BeepC;

  Main.StdControl -> TimerC;
  MoteCommandM.Timer -> TimerC.Timer[unique("Timer")];
  
  Message = MoteCommandM;
  Main.StdControl -> MoteCommandM;
  MoteCommandM.Leds -> LedsC;
}
