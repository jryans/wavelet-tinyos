// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This modules sends and receives data over the UART connection
 * with the computer.
 **/

includes MessageData;

module UARTControlM 
{
  uses {  
    interface Transceiver as UART;
  }
  provides {
    interface MessageOut as Out;
    interface MessageIn as In;
  }
}

implementation
{
  struct MessageData data[2]; // A two elements queue for outgoing messages.  Expand this?
  uint8_t freeData = 0;
  TOS_MsgPtr *message;
  
  command result_t Out.send(struct MessageData msg, int8_t mDest) 
  {
	// Check that message is for the sink and that we are connected to it
	if (mDest == SINK && TOS_LOCAL_ADDRESS == 0) 
	{
		atomic
		{
			data[freeData] = msg;
			post attemptSend(freeData, UART_RETRIES);
			freeData ^= 0x1;
		}
		return SUCCESS;
	}
	return FAIL;
  }

  task void attemptSend(uint8_t msgNum, uint8_t retries) 
  {
    if (retries <= 0)
    {
    	dbg(DBG_USR1, "Unable to send message to UART!\n");
    	return;
    }
    
    if ( (message = call DataMsg.requestWrite()) != NULL ) 
    {
      struct MessageData *msg = (struct MessageData *)message->data;
      msg = &data[msgNum];
    } else {
      dbg(DBG_USR1, "Unable to allocate message to UART!\n");
      post attemptSend(msgNum, retries--);
    }

    if (call DataMsg.sendUart(sizeof(struct MessageData)) == FAIL)
      post attemptSend(msgNum, retries--);
  }

  /**
   * Signaled when the previous packet has been sent.
   * Notifies the application the message was sent.
   * @return Always returns SUCCESS.
   */
  event result_t UART.uartSendDone(TOS_MsgPtr sent, result_t result) 
  {
  	signal Out.sendDone(result);
    return SUCCESS;
  }
  
  event result_t UART.radioSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event TOS_MsgPtr UART.receiveRadio(TOS_MsgPtr m)
  {
    return m;
  }
  
  /**
   * A message was received over the UART.
   * Passes the message on to the application.
   * @return Returns the TOS_MsgPtr for reuse.
   */
  event TOS_MsgPtr UART.receiveUart(TOS_MsgPtr m)
  {
  	struct MessageData *msg = (struct MessageData *)m->data;
  	signal In.receive(msg);
    return m;
  }
}
