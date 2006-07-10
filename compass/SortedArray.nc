/**
 * Provides applications access to sorted arrays stored on
 * the mote's flash space.
 * @author Ryan Stinnett
 */
 
interface SortedArray {
  
  /**
   * Gets the value stored at index.
   */
  command result_t read(uint16_t index);
  event void readDone(uint8_t *data, result_t result);
  
  /**
   * Stores a value at the end of the array.
   */
  command result_t add(uint8_t *value);
  
  /**
   * Returns the number of elements in the array.
   */
  command uint16_t size();
  
  /**
   * Sets the number of bytes per element.
   */
  command void setElemSize(uint8_t numBytes);
  
  /**
   * Sorts the values stored in the array.
   */
  command result_t sort();
  event void sortDone(result_t result);
  
  /**
   * Removes all data stored in the array.
   */
  //command result_t clear();
  
}