/**
 * Tries to send packets as fast as possible.
 * @author Ryan Stinnett
 */
 
includes MessageData;

module ArrayTestM {
  uses {
    interface Timer;
    interface SortedArray as SA1;
    interface SortedArray as SA2;
    interface Random;
  }
  provides interface StdControl;
}
implementation {
 
  command result_t StdControl.init() {
    call Random.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call SA1.setElemSize(sizeof(uint16_t));
    call SA2.setElemSize(sizeof(uint16_t));
    call Timer.start(TIMER_ONE_SHOT, 5000);
    return SUCCESS;
  }
  
  event result_t Timer.fired() {
    uint16_t r1, r2;
    r1 = call Random.rand();
    call SA1.add(&r1);
    r2 = call Random.rand();
    call SA2.add(&r2);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  event void SA1.readDone(uint8_t *data, result_t result) {
    
  }
  
  event void SA1.sortDone(result_t result) {
    
  }
  
  event void SA2.readDone(uint8_t *data, result_t result) {
    
  }
  
  event void SA2.sortDone(result_t result) {
    
  }
 
}
