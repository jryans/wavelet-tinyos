/**
 * Constucts a large, sortable array on top of the BlockStorage
 * interface to the mote's flash space.
 * @author Ryan Stinnett
 */

module SortedArrayM {
  uses {
    interface BlockRead[uint8_t id];
    interface BlockWrite[uint8_t id];
    interface Mount[uint8_t id];
  }
  provides {
    interface SortedArray[uint8_t id];
    interface StdControl;
  }
}

implementation {
  
  enum {
    SA_BLOCK_SIZE = 256,
    SA_HEADER_SIZE = 5,
    SA_NEW_ARRAY = -1
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
    SAI_MOUNT,
    SAI_SEEK,
    SAI_ERROR
  };
  
  typedef struct {
    uint8_t volid;
    int8_t curArrNum;
    int8_t targetArrNum;
    uint16_t numBlocks;
    uint8_t elemSize;
    uint16_t numElems;
    uint8_t iState;
    uint8_t cState;
    int8_t curBlockId;
    int8_t nextBlockId;
    uint8_t *block;
    uint8_t *temp;
    bool blkDirty;
    uint16_t curVolIdx;
    uint8_t curBlkIdx;
  } saInfo;
  
  uint8_t numArrays = uniqueCount("StorageManager");
  saInfo sa[uniqueCount("StorageManager")];
  
  /*** Internal Functions ***/
  
  result_t beginOp(uint8_t id);
  void finishOp(uint8_t id, result_t result);
  bool inCurBlock(uint8_t id);
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    int i;
    //call ByteControl.init();
    for (i = 0; i < numArrays; i++) {
      //sa[i].numBlocks = 0;
      sa[i].elemSize = 0;
      sa[i].numElems = 0;    
      sa[i].iState = SAI_INIT;
      sa[i].cState = SAC_IDLE;
      sa[i].curBlockId = -1;
      sa[i].nextBlockId = -1;      
      sa[i].block = NULL;
      sa[i].temp = NULL;
      sa[i].blkDirty = FALSE;
      sa[i].curVolIdx = 0;
      sa[i].curBlkIdx = 0;
      //beginOp(i);
    }
    return SUCCESS;
  }

  command result_t StdControl.start() {
    //call ByteControl.start();
    //for (i = 0; i < numArrays; i++)
    //  beginOp(i);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    //call ByteControl.stop();
    return SUCCESS;
  }
  
  /*** Internal Functions ***/
  
  result_t beginOp(uint8_t id) {
    saInfo *s = &sa[id];
    switch (s->iState) {
  /*  case SAI_INIT: {
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
      break; } */
    case SAI_MOUNT: {
      dbg(DBG_USR1, "SortedArray: Mounting array #%i\n", id);
      if (call Mount[id].mount(s->volid) == FAIL) {
        dbg(DBG_USR2, "SortedArray: Call to mount array #%i failed!\n", id);
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
  /*  case SAI_INIT: {
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
      break; } */   
    case SAI_MOUNT: {
      if (result == SUCCESS) {
        dbg(DBG_USR1, "SortedArray: Mounting array #%i complete\n", id);
        s->iState = SAI_IDLE;
        signal SortedArray.mountDone[id](SUCCESS);
      } else {        
        dbg(DBG_USR2, "SortedArray: Mounting array #%i failed!\n", id);
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
    bOffset = s->curVolIdx * s->elemSize;
    bNum = bOffset / BLOCK_SIZE;
    curBlkIdx = bOffset % BLOCK_SIZE;
    s->newBlock = bNum;
    return (s->curBlock == bNum);
  }
  
  /*** SortedArray ***/
  
  /**
   * Gets the value stored at index.
   */
  command result_t SortedArray.read[uint8_t id](uint16_t idx) {
    saInfo *s = &sa[id];    
    if (s->cState != SAC_IDLE || s->iState != SAI_IDLE || idx > s->numElems)
      return FAIL;
    s->cState = SAC_READ;
    s->iState = SAI_WRITE;
    s->curVolIdx = idx;
    return beginOp(id);
  }
  
  command result_t SortedArray.mount[uint8_t id](uint8_t volid) {
    saInfo *s = &sa[id];    
    if (s->iState != SAI_INIT)
      return FAIL;
    s->iState = SAI_MOUNT;
    s->volid = volid;
    return beginOp(id);
  }
  
  command result_t SortedArray.seek[uint8_t id](int8_t arraynum) {
    saInfo *s = &sa[id];    
    if (s->cState != SAC_IDLE || s->iState != SAI_IDLE)
      return FAIL;
    s->iState = SAI_WRITE;
    s->cState = SAC_SEEK;
    s->targetArrNum = arraynum;
    s->curArrNum = 0;
    s->curVolIdx = 0;
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
  //command result_t SortedArray.sort[uint8_t id]() {
    // Start sorting
  //}
  
  /**
   * Removes all data stored in the array.
   */
  //command result_t SortedArray.clear[uint8_t id]() {}
  

}