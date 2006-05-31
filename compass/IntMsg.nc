/**
 * Simple interface for internal messaging betweeen components.
 * Components post messages to the Postmaster and it notifies them
 * when new messages arrive.
 */

includes MessageData;

interface IntMsg
{
	/**
	 * Requests a new message from the Postmaster's queue.
	 * @return Returns a msgEntry if there is a free message available, else NULL.
	 */
	command msgEntry newMsg();
	
	/**
	 * Posts a message to the Postmaster for delivery to other components.
	 */
	command void postMsg(msgEntry msg);
	
	/**
	 * Signaled by the Postmaster when all notified components have 
	 * finished processing the message.
	 * @param aggrResult Contains the rcombined result_t from each component
	 */
	event void postDone(msgEntry msg, result_t aggrResult);
	
	/**
	 * Signaled by the Postmaster a there is a new message for a component.
	 */
	event void notify(msgEntry msg);
	
	/**
	 * Informs the Postmaster that a component is done processing a message.
	 * @param myResult The result_t from the notified component.
	 */
	command void notifyDone(msgEntry msg, result_t myResult);
}
