/**
 * Simple interface for unencapsulated incoming messages
 */

includes MessageData;

interface BareMessageIn
{
	/**
	 * receive is signaled when a new message arrives with the type mType
	 */
	event result_t receive(MessageData msg, uint8_t mType);
}