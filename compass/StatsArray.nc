/**
 * Computes various statistics on a data stream without
 * storing the data itself.
 * @author Ryan Stinnett
 */
 
interface StatsArray {
  
  command void newData(int16_t newVal);
  
  command int16_t min();
  
  command int16_t max();
  
  command float mean();
  
  command float median();
  
}
