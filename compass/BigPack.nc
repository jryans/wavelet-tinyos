/**
 * Requests multi-packet data.
 * @author Ryan Stinnett
 */
 
interface BigPack {
  /**
   * Requests big pack data of a certain type.  If another request is already being
   * processed, this will return FAIL and do nothing.  Otherwise, it returns SUCCESS
   * and begins the request.
   */
  command result_t request(uint8_t type);
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  event void requestDone(int8_t *mainBlock, result_t result);
  
  /**
   * When an application is done with the data, it must call free.
   */
  command void free(int8_t *mainBlock);
}
