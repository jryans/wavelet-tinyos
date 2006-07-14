/**
 * Computes various statistics on a data stream without
 * storing the data itself.
 * @author Ryan Stinnett
 */
 
interface StatsArray {
  
  command void newData(float newVal);
  
  command float min();
  
  command float max();
  
  command float mean();
  
  command float median();
  
}
