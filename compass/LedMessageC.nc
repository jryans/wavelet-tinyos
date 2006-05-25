// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application sends data from the BareMessageOut type to the Leds.  We use this for debugging and 
 * demos.
 **/


configuration LedMessageC
{
  provides interface BareMessageOut as LedData;
}
implementation
{
  components LedMessageM, LedsC, Main;

  LedData = LedMessageM;
  Main.StdControl -> LedMessageM;
  LedMessageM.Leds -> LedsC;
}
