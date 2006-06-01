/**
 * Transfers unencapsulated messages between applications and
 * network components.
 * @author Ryan Stinnett
 */

includes MessageData;

interface Message
{
	/**
	 * Sends message data to the network
	 */
	command result_t send(msgData msg);
	
	/**
	 * sendDone is signaled when the send has completed
	 */
	event result_t sendDone(result_t result);
    
    /**
	 * Receive is signaled when a new message arrives
	 */
	event result_t receive(msgData msg);
}
