/**
 * Constucts a large, sortable array on top of the Blackbook
 * interface to the mote's flash space.
 * @author Ryan Stinnett
 */

module SortedArrayM {
  uses {
    interface AllocationReq[uint8_t id];
    interface WriteData[uint8_t id];
    interface LogData[uint8_t id];
    interface ReadData[uint8_t id];
    interface StdControl as ByteControl;
  }
  provides {
    interface SortedArray[uint8_t id];
    interface StdControl;
  }
}

implementation {
  
  enum {
    BLOCK_SIZE = 128
  };
  
  enum {
    SAC_IDLE,
    SAC_READ,
    SAC_ADD,
    SAC_SORT,
    SAC_CLEAR
  };
  
  enum {
    SAI_IDLE,
    SAI_INIT,
    SAI_LOG,
    SAI_READ,
    SAI_WRITE,
    SAI_ERASE,
    SAI_ERROR
  };
  
  typedef struct {
    uint8_t elemSize;
    uint16_t numElems;
    uint8_t iState;
    uint8_t cState;
    int8_t curBlock;
    int8_t newBlock;
    uint8_t *block;
    uint8_t *temp;
    bool blkDirty;
    uint16_t curArrIdx;
    uint8_t curBlkIdx;
  } saInfo;
  
  uint8_t numArrays = uniqueCount("SortedArray");
  saInfo sa[numArrays];
  
  /*** Internal Functions ***/
  
  result_t beginOp(uint8_t id);
  void finishOp(uint8_t id, result_t result);
  bool inCurBlock(uint8_t id);
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    int i;
    call ByteControl.init();
    for (i = 0; i < numArrays; i++) {
      sa[i].elemSize = 0;
      sa[i].numElems = 0;    
      sa[i].iState = SAI_INIT;
      sa[i].cState = SAC_IDLE;
      sa[i].curBlock = -1;
      sa[i].newBlock = -1;      
      sa[i].block = NULL;
      sa[i].temp = NULL;
      sa[i].blkDirty = FALSE;
      sa[i].curArrIdx = 0;
      sa[i].curBlkIdx = 0;
      beginOp(i);
    }
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call ByteControl.start();
    for (i = 0; i < numArrays; i++)
      beginOp(i);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call ByteControl.stop();
    return SUCCESS;
  }
  
  /*** Internal Functions ***/
  
  result_t beginOp(uint8_t id) {
    saInfo *s = &sa[id];
    switch (s->iState) {
    case SAI_INIT: {
      dbg(DBG_USR1, "SortedArray: Allocating array #%i\n", id);
      finishOp(id, call AllocationReq[id].request(20480));
      break; }
    case SAI_ERASE: {
      dbg(DBG_USR1, "SortedArray: Erasing array #%i\n", id);
      if (call LogData[id].erase() == FAIL) {
        dbg(DBG_USR2, "SortedArray: Call to erase array #%i failed!\n", id);
        finishOp(id, FAIL);
        return FAIL;
      } 
      break; }
    case SAI_LOG: {
      dbg(DBG_USR1, "SortedArray: Adding new data to array #%i\n", id);
      if (call LogData.append(s->temp, s->elemSize) == FAIL) {
        dbg(DBG_USR2, "SortedArray: Call to add new data to array #%i failed!\n", id);
        finishOp(id, FAIL);
        return FAIL;
      }
      break; }
    case SAI_WRITE: {
      if (inCurBlock(id)) {
        dbg(DBG_USR1, "SortedArray: Location found in current block of array #%i\n", id);
        s->iState = SAI_READ;
        finishOp(id, SUCCESS);
      } else {
        if (s->blkDirty) {
          dbg(DBG_USR1, "SortedArray: Writing out dirty block #%i for array #%i\n", 
              s->curBlock, id);
          if (call WriteData.write[id](s->curBlock * BLOCK_SIZE, block, BLOCK_SIZE) == FAIL) {
            dbg(DBG_USR2, "SortedArray: Call to write dirty block #%i for array #%i failed!\n", 
                s->curBlock, id);
            finishOp(id, FAIL);
            return FAIL;
          }
        } else {
          s->iState = SAI_READ;
          return beginOp(id);                    
        }
      }
      break; }
    case SAI_READ: {
      dbg(DBG_USR1, "SortedArray: Reading in new block #%i for array #%i\n", s->newBlock, id);
      if (call ReadData.read[id](s->newBlock * BLOCK_SIZE, block, BLOCK_SIZE) == FAIL) {
        dbg(DBG_USR2, "SortedArray: Call to read new block #%i for array #%i failed!\n", 
            s->newBlock, id);
        finishOp(id, FAIL);
        return FAIL;
      }
      break; }
    }
    return SUCCESS;
  }
  
  void finishOp(uint8_t id, result_t result) {
    saInfo *s = &sa[id];
    switch (s->iState) {
    case SAI_INIT: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Array #%i allocation complete\n", id);
        s->iState = SAI_ERASE;
      } else {
        dbg(DBG_USR2, "SortedArray: Array #%i allocation failed!\n", id);     
        s->iState = SAI_ERROR;   
      }
      break; }
    case SAI_ERASE: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Erasing array #%i complete\n", id);
        s->iState = SAI_IDLE;
      } else {        
        dbg(DBG_USR2, "SortedArray: Erasing array #%i failed!\n", id);
        s->iState = SAI_ERROR;
      }
      break; }
    case SAI_LOG: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Adding new data to array #%i complete\n", id);
        s->iState = SAI_IDLE;
        if (s->cState == SAC_ADD)
          s->cState == SAC_IDLE;
      } else {
        dbg(DBG_USR2, "SortedArray: Adding new data to array #%i failed!\n", id);
        s->iState = SAI_ERROR;
      }
      break; }
    case SAI_READ: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Location ready for use in array #%i\n", id);
        s->curBlock = s->newBlock;
        s->temp = &block[curBlkIdx];
        s->iState = SAI_IDLE;
        if (s->cState == SAC_READ) {
          s->cState = SAC_IDLE;
          signal SortedArray.readDone[id](temp, SUCCESS);
        }
      } else {       
        dbg(DBG_USR2, "SortedArray: Read for new block #%i in array #%i failed!\n",
            s->newBlock, id);        
        s->iState = SAI_ERROR; 
      }
      break; }
    case SAI_WRITE: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Write for dirty block #%i in array #%i complete\n", 
            s->curBlock, id);
        s->blkDirty = FALSE;
        s->iState = SAI_READ;
        beginOp(id);
      } else {       
        dbg(DBG_USR2, "SortedArray: Write for dirty block #%i in array #%i failed!\n", 
            s->curBlock, id);        
        s->iState = SAI_ERROR; 
      }
      break; }
    }
  }
  
  bool inCurBlock(uint8_t id) {
    uint16_t bOffset;
    int8_t bNum;
    saInfo *s = &sa[id];
    bOffset = s->curArrIdx * s->elemSize;
    bNum = bOffset / BLOCK_SIZE;
    curBlkIdx = bOffset % BLOCK_SIZE;
    s->newBlock = bNum;
    return (s->curBlock == bNum);
  }
  
  /*** SortedArray ***/
  
  /**
   * Gets the value stored at index.
   */
  command result_t SortedArray.read[uint8_t id](uint16_t index) {
    saInfo *s = &sa[id];    
    if (s->cState != SAC_IDLE || s->iState != SAI_IDLE || index > s->numElems)
      return FAIL;
    s->cState = SAC_READ;
    s->iState = SAI_WRITE;
    s->curArrIdx = index;
    return beginOp(id);
  }
  
  /**
   * Stores a value at the end of the array.
   */
  command result_t SortedArray.add[uint8_t id](uint8_t *value) {
    saInfo *s = &sa[id];
    if (s->cState != SAC_IDLE || s->iState != SAI_IDLE)
      return FAIL;
    s->cState = SAC_ADD;
    s->iState = SAI_LOG;
    s->temp = value;
    return beginOp(id);
  }
  
  /**
   * Sets the number of bytes per element.
   */
  command void SortedArray.setElemSize[uint8_t id](uint8_t numBytes) {
    elemSize[id] = numBytes;
  }
  
  /**
   * Returns the number of elements in the array.
   */
  command uint16_t SortedArray.size[uint8_t id]() {
    return numElems[id];
  }
  
  /**
   * Sorts the values stored in the array.
   */
  command result_t SortedArray.sort[uint8_t id]() {
    // Start sorting
  }
  
  /**
   * Removes all data stored in the array.
   */
  //command result_t SortedArray.clear[uint8_t id]() {}
  
  /**
   * Report erase completion.
   * @param success FAIL if erase failed, in which case appends are not allowed.
   * @return Ignored.
   */
  event result_t LogData.eraseDone[uint8_t id](result_t success) {
    finishOp(id, success);
    return SUCCESS;
  }
  
  /**
   * Report append completion.
   * @param data Address of data written
   * @param numBytesWrite Number of bytes written
   * @param success SUCCESS if write was successful, FAIL otherwise
   * @return Ignored.
   */
  event result_t LogData.appendDone[uint8_t id](uint8_t* data, uint32_t numBytes, result_t success) {
    finishOp(id, success);
    return SUCCESS;
  }
  
  /**
   * Signal write completion
   * @param data Address of data written
   * @param numBytesWrite Number of bytes written
   * @param success SUCCESS if write was successful, FAIL otherwise
   * @return Ignored.
   */
  event result_t WriteData.writeDone[uint8_t id](uint8_t *data, uint32_t numBytesWrite, result_t success) {
    finishOp(id, success);
    return SUCCESS;
  }
  
  /**
   * Signal read completion
   * @param data Address where read data was placed
   * @param numBytesRead Number of bytes read
   * @param success SUCCESS if read was successful, FAIL otherwise
   * @return Ignored.
   */
  event result_t ReadData.readDone[uint8_t id](uint8_t* buffer, uint32_t numBytesRead, result_t success) {
    finishOp(id, success);
    return SUCCESS;
  }
}