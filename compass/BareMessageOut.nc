/**
 * Simple interface for unencapsulated outgoing messages
 */

includes MessageData;

interface BareMessageOut
{
	/**
	 * Sends message data of the type mType to destination mDest
	 */
	command result_t send(MessageData msg, uint8_t mType, int8_t mDest);
	
	/**
	 * sendDone is signaled when the send has completed
	 */
	event result_t sendDone(result_t result);
}