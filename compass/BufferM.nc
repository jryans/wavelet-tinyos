// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This buffer sends and receives IOPacks with the Transceiver, while preventing
 * from becoming congested.
 * @author The Moters
 * @author Ryan Stinnett
 */

// ONLY SUPPORTS UART RIGHT NOW

includes MessageData;

module BufferM {
  uses interface Transceiver as IO;
  provides interface Buffer;
}

implementation
{
  #if 0
  typedef uint8_t IOPack;
  #endif
  
  IOPack data[2]; // A two elements queue for outgoing messages.  Expand this?
  uint8_t freeData = 0;
  TOS_MsgPtr message;
  
  void attemptSend(uint8_t packNum, uint8_t retries); // make into a task!
  
  command result_t Buffer.send(IOPack pack) 
  {
	// Check that message is for the sink and that we are connected to it
	if (mDest == SINK && TOS_LOCAL_ADDRESS == 0) 
	{
		atomic
		{
			data[freeData] = pack;
			attemptSend(freeData, UART_RETRIES);
			freeData ^= 0x1;
		}
		return SUCCESS;
	}
	return FAIL;
  }

  void attemptSend(uint8_t packNum, uint8_t retries) 
  {
    if (retries <= 0)
    {
    	dbg(DBG_USR1, "Unable to send message to UART!\n");
    	return;
    }
    
    if ( (message = call UART.requestWrite()) != NULL ) 
    {
      IOPack *pack = (IOPack *)message->data;
      pack = &data[packNum];
    } else {
      dbg(DBG_USR1, "Unable to allocate message to UART!\n");
      attemptSend(packNum, retries--);
    }

    if (call UART.sendUart(sizeof(IOPack)) == FAIL)
      attemptSend(packNum, retries--);
  }

  /**
   * Signaled when the previous packet has been sent.
   * Notifies the application the message was sent.
   * @return Always returns SUCCESS.
   */
  event result_t IO.uartSendDone(TOS_MsgPtr sent, result_t result) 
  {
  	signal Buffer.sendDone(result);
    return SUCCESS;
  }
  
  // TODO
  event result_t IO.radioSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  // TODO
  event TOS_MsgPtr IO.receiveRadio(TOS_MsgPtr m)
  {
    return m;
  }
  
  /**
   * A message was received over the UART.
   * Passes the message on to the application.
   * @return Returns the TOS_MsgPtr for reuse.
   */
  event TOS_MsgPtr IO.receiveUart(TOS_MsgPtr m)
  {
  	IOPack *pack = (IOPack *)m->data;
  	dbg(DBG_USR1, "UART Receive: type %i action %i", pack->type, pack->data.moteCmd.cmd);
  	signal Buffer.receive(*pack);
    return m;
  }
}
