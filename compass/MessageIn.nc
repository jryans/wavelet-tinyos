/**
 * Simple interface for unencapsulated incoming messages
 */

includes MessageData;

interface MessageIn
{
	/**
	 * receive is signaled when a new message arrives
	 */
	event result_t receive(struct MessageData msg);
}
