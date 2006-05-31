/**
 * Simple interface for unencapsulated outgoing messages
 */

includes MessageData;

interface MessageOut
{
	/**
	 * Sends message data to destination mDest
	 */
	command result_t send(struct MessageData msg, int8_t mDest);
	
	/**
	 * sendDone is signaled when the send has completed
	 */
	event result_t sendDone(result_t result);
}
