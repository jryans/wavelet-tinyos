/**
 * Notifies applications of changes to mote-wide options.
 * @author Ryan Stinnett
 */

interface MoteOptions {
  
  /**
   * Signaled when the diagnostic state is changed.
   */
  event void diag(bool state);
  
}
