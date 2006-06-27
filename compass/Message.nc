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
	event result_t sendDone(msgData msg, result_t result, uint8_t retries);
    
    /**
	 * Receive is signaled when a new message arrives
	 */
	event void receive(msgData msg);
}
