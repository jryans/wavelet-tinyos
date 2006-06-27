/**
 * Requests multi-packet data from the sink.
 * @author Ryan Stinnett
 */
 
includes BigPack;
 
interface BigPackClient {
  /**
   * Each module that listens to the requestDone event should call this method
   * during startup to ensure that no pointers are freed until all modules are
   * done with them.
   */
  command void registerListener();
  
  /**
   * Requests big pack data of a certain type.  If another request is already being
   * processed, this will return FAIL and do nothing.  Otherwise, it returns SUCCESS
   * and begins the request.
   */
  command result_t request();
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  event void requestDone(int8_t *mainBlock, result_t result);
  
  /**
   * When an application is done with the data, it must call free.
   */
  command void free();
}
