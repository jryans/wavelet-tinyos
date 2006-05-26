// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * Connects internal UART controls to the UART interface provided by
 * the Transceiver module.
 **/
 
includes MessageData;

configuration UARTControlC
{
  provides interface BareMessageOut as Out;
  provides interface BareMessageIn as In;
}
implementation
{
  components UARTControlM, TransceiverC, Main;

  Out = UARTControlM;
  In = UARTControlM;
  Main.StdControl -> TransceiverC[UART];
  UARTControlM.Transceiver -> TransceiverC[UART];
}
