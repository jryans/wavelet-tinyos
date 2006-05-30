// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application sends data from the MessageOut type to the Leds.  We use this for debugging and 
 * demos.
 **/


configuration LedControlC
{
  provides interface MessageOut as LedData;
}
implementation
{
  components LedControlM, LedsC, Main;

  LedData = LedControlM;
  Main.StdControl -> LedControlM;
  LedControlM.Leds -> LedsC;
}
