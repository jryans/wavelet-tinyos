/**
 * Broadcasts ping messages for diagnostic purposes.
 * @author Ryan Stinnett
 */

interface PingB {
  
  /**
   * Sends a given number of ping messages.
   */
  command void send(uint16_t num);
  
}
