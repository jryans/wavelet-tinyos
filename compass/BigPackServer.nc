/**
 * Responds to multi-packet data requests from the sink.
 * @author Ryan Stinnett
 */
 
includes BigPack;
 
interface BigPackServer {
  
  /**
   * A helper function used when a module is building a big pack
   * in response to the buildPack event.  This allocates internal
   * BigPackM data structures for the given number of blocks and
   * pointers and returns pointers to these in a BigPackEnvelope.
   */
  command BigPackEnvelope *createEnvelope(uint8_t numBlocks, uint8_t numPtrs);
  
  /**
   * When the mote receives a big pack data request from the sink,
   * this event is signaled triggering the application to assemble
   * the requested data.
   */
  event result_t buildPack();
  
}
