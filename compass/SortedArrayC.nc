/**
 * Constucts a large, sortable array on top of the BlockStorage
 * interface to the mote's flash space.
 * @author Ryan Stinnett
 */
 
configuration SortedArrayC {
  provides {
    interface SortedArray[uint8_t id];
  }
}
implementation {
  components Main, BlockStorageC, SortedArrayM;
  
  Main.StdControl -> SortedArrayM;
  SortedArrayM.BlockRead -> BlockStorageC;
  SortedArrayM.BlockWrite -> BlockStorageC;
  SortedArrayM.Mount -> BlockStorageC;
  
  SortedArray = SortedArrayM;
}
