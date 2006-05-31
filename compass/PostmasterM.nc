/**
 * The Postmaster shuttles small messages around to various internal components.
 * It allows all components to use a unified format for transferring data
 * between each other.  One queue is shared by all components in the system,
 * so it is important to process the messages quickly!
 */

includes MessageData;

module PostmasterM 
{
  provides interface IntMsg[uint8_t src];
}

implementation
{
  /*** Types, Variables, and Constants ***/
  
  enum {
  	MAX_INTMSGS = 20  // Size of the internal queue
  };
  
  uint8_t freeMsgAt = 0; // Points to the next place in the queue to check for a free message
  uint8_t freeMsgsLeft = MAX_INTMSGS; // Tracks the number of free messages remaining
  uint8_t sendAt = 0; // Points to the next place to check for messages to be sent

  msgEntry msgStore[MAX_INTMSGS];
	
  /*** Function Declarations ***/
  
  msgEntry allocate();
  void deallocate();
  
  /**
   * Requests a new message from the Postmaster's queue.
   * @return Returns a msgEntry if there is a free message available, else NULL.
   */
  command msgEntry IntMsg.newMsg[uint8_t src]() {
    msgEntry newPtr = NULL;
    
    atomic {
      if (freeMsgsLeft > 0) {
        newPtr = allocate();
        newPtr->poster = type;
        newPtr->refs++;
      }
    }
    
    return newPtr;	
  }

  /**
   * Posts a message to the Postmaster for delivery to other components.
   */
  command void IntMsg.postMsg[uint8_t src](msgEntry msg) {
  	uint8_t newRefs = -1;
  	switch (src) {
  	  case PM_UART:
  	}
  }

  /**
   * Informs the Postmaster that a component is done processing a message.
   * @param myResult The result_t from the notified component.
   */
  command void IntMsg.notifyDone[uint8_t src](msgEntry msg, result_t myResult) {}
  
  msgEntry allocate() {
  	do {
  	  if (msgStore[freeMsgAt]->refs == 0)
  	    break;
  	  (freeMsgAt == MAX_INTMSGS - 1) ? freeMsgAt = 0 : freeMsgAt++; 
  	}
  	return msgStore[freeMsgAt];
  }
  
  /*** Defaults ***/
  
  /**
   * Signaled by the Postmaster when all notified components have 
   * finished processing the message.
   * @param aggrResult Contains the rcombined result_t from each component
   */
  default event void IntMsg.postDone[uint8_t src](msgEntry msg, result_t aggrResult) {}

  /**
   * Signaled by the Postmaster a there is a new message for a component.
   */
  default event void IntMsg.notify[uint8_t src](msgEntry msg) {}
}
