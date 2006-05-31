// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application sends data from the MessageOut type to the Leds.  We use this for debugging and 
 * demos.
 **/


configuration SubsystemC {
}
implementation
{
  components LedControlM, LedsC, Main, UARTControlC, DelugeC;

  Main.StdControl -> DelugeC;
  LedControlM.LedData -> UARTControlC.In;
  Main.StdControl -> LedControlM;
  LedControlM.Leds -> LedsC;
}
