/**
 * Uses the sounder to make beeps of various kinds.  Useful for
 * debugging on the mote.
 * @author Ryan Stinnett
 */
 
interface Beep{
  
  /**
   * Plays a given number of beeps, with a given delay between each.
   */
  command void play(uint8_t numBeeps, uint32_t delay);
  
}
