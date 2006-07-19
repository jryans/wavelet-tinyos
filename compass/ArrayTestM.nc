/**
 * Tries to send packets as fast as possible.
 * @author Ryan Stinnett
 */
 
includes MessageData;

module ArrayTestM {
  uses {
    interface StatsArray;
    interface Message;
  }
}
implementation {
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    return SUCCESS;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    if (msg.type == WAVELETDATA) {
      if (msg.data.wData.value[0] > 0) {
        call StatsArray.newData(msg.data.wData.value[0]);
#ifdef PLATFORM_PC                 
      } else {       
        float val = call StatsArray.min();
        dbg(DBG_USR2, "ArrayTest: Min: %f\n", val);
        val = call StatsArray.max();
        dbg(DBG_USR2, "ArrayTest: Max: %f\n", val);
        val = call StatsArray.mean();
        dbg(DBG_USR2, "ArrayTest: Mean: %f\n", val);
        val = call StatsArray.median();
        dbg(DBG_USR2, "ArrayTest: Median: %f\n", val);
#endif
      }
    }
  }
 
}
