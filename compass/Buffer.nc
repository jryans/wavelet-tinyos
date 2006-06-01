/**
 * Transfers messages between the I/O components and the Transceiver
 * @author Ryan Stinnett
 */

includes IOPack;

interface Buffer {
	/**
	 * Adds a new pack to the Buffer's queue
	 */
	command result_t send(IOPack pack);
	
	/**
	 * Transmission of the pack has completed
	 */
	event result_t sendDone(result_t result);
	
	/**
	 * Receive is signaled when a new pack arrives
	 */
	event result_t receive(IOPack pack);
}
