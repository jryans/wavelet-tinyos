/**
 * Constucts a large, sortable array on top of the Blackbook
 * interface to the mote's flash space.
 * @author Ryan Stinnett
 */
 
configuration SortedArrayC {
  provides {
    interface SortedArray[uint8_t id];
  }
}
implementation {
  components Main, ByteEEPROM, SortedArrayM;
  
  Main.StdControl -> SortedArrayM;
  SortedArrayM.ByteControl -> ByteEEPROM;
  SortedArrayM.AllocationReq -> ByteEEPROM;
  SortedArrayM.WriteData -> ByteEEPROM;
  SortedArrayM.ReadData -> ByteEEPROM;
  SortedArrayM.LogData -> ByteEEPROM;
  
  SortedArray = SortedArrayM;
}
