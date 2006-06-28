/**
 * Requests and rebuilds multi-packet data structures.
 * @author Ryan Stinnett
 */
 
includes MessageData;
 
module BigPackM {
  uses {
    interface Message;
    interface Timer as MsgRepeat;
#ifdef BEEP
    interface Beep;
#endif
  }
  provides {
    interface BigPackServer[uint8_t type];
    interface BigPackClient[uint8_t type];
    interface StdControl;
  }
}
implementation {
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char BigPackBlock;
  typedef char BigPackPtr;
  typedef char BigPackEnvelope;
#endif

  /*** Variables and Function Prototypes ***/
  
  uint8_t numPacks;
  int8_t curPackNum;
  uint8_t numBytes;
  int8_t *bigData;
  bool bdAlloc = FALSE;
  
  BigPackBlock *block;
  uint8_t numBlocks[BP_MAX_REQUESTS];
  bool bpbAlloc = FALSE;
  
  BigPackPtr *ptr;
  uint8_t numPtrs;
  bool bppAlloc = FALSE;
  
  uint8_t curType;
  bool activeRequest = FALSE; // True if a request is in progress
  msgData repeatMsg; // Message to repeat
  
  int8_t **blockAddr[BP_MAX_REQUESTS];
  int8_t *mainBlock[BP_MAX_REQUESTS];
  uint8_t refs[BP_MAX_REQUESTS];
  uint8_t numListeners[BP_MAX_REQUESTS];
  
  uint8_t transState;
  
  result_t allocInc();
  void freeInc();
  result_t allocEnv();
  void freeEnv();
  void requestData(uint8_t type);
  void sendAck(msgData msg);
  void repeatSend(msgData msg, uint16_t bms);
  void rebuildBlocks();
  result_t newRequest(uint8_t type);
  
  /*** Outgoing ***/
  BigPackEnvelope env;
  
  /*** Timers ***/
  
  /**
   * Helper function for repeating a message until we get a response
   */ 
  void repeatSend(msgData msg, uint16_t bms) {
    repeatMsg = msg;
    call Message.send(msg);
    call MsgRepeat.start(TIMER_REPEAT, bms);
  }
  
  /**
   * Sends the saved message again
   */
  event result_t MsgRepeat.fired() {
    call Message.send(repeatMsg);
    return SUCCESS;
  }  
  
  /*** StdControl ***/
  
  command result_t StdControl.init() 
  {
    uint8_t i;
    for (i = 0; i < BP_MAX_REQUESTS; i++) {
      mainBlock[i] = NULL;
      numListeners[i] = 0;
      refs[i] = 0;
    }
    return SUCCESS;
  }
  
  command result_t StdControl.start() 
  {
    return SUCCESS;
  }
  
  command result_t StdControl.stop() 
  {
    return SUCCESS;
  }
  
  /*** BigPackClient ***/
  
  /**
   * Each module that listens to the requestDone event should call this method
   * during startup to ensure that no pointers are freed until all modules are
   * done with them.
   */
  command void BigPackClient.registerListener[uint8_t type]() {
    numListeners[type]++;
  }
  
  /**
   * Requests big pack data of a certain type.  If another request is already being
   * processed, this will return FAIL and do nothing.  Otherwise, it returns SUCCESS
   * and begins the request.
   */
  command result_t BigPackClient.request[uint8_t type]() {
    if (type >= BP_MAX_REQUESTS || activeRequest)
      return FAIL;
    if (mainBlock[type] == NULL) {
      msgData msg;
      curType = type;
      mainBlock[type] = (int8_t *) 1122; // Just so it's not NULL
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      msg.type = BIGPACKHEADER;
      msg.data.bpHeader.requestType = type;
      msg.data.bpHeader.packTotal = 0;
      activeRequest = TRUE;
      transState = BP_RECEIVING;
      repeatSend(msg, 5000);
    } else {
      return FAIL;
    }
    return SUCCESS;
  }
  
  /**
   * When an application is done with the data, it must call free.
   */
  command void BigPackClient.free[uint8_t type]() {
    uint8_t b;
    // Ensure this is a valid type
    if (type >= BP_MAX_REQUESTS || mainBlock[type] == NULL)
      return; 
    // If found, then decrement refs
    refs[type]--;
    // If refs == 0, then free the memory
    if (refs[type] == 0) {
      for (b = 0; b < numBlocks[type]; b++)
        free(blockAddr[type][b]);
      free(blockAddr[type]);
      mainBlock[type] = NULL;
    }
  }
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  default event void BigPackClient.requestDone[uint8_t type](int8_t *mb, result_t result) {}
  
  /*** BigPackServer ***/
  
  /**
   * When the mote receives a big pack data request from the sink,
   * this event is signaled triggering the application to assemble
   * the requested data.
   */
  default event result_t BigPackServer.buildPack[uint8_t type]() {
    return FAIL;
  }
  
  /**
   * A helper function used when a module is building a big pack
   * in response to the buildPack event.  This allocates internal
   * BigPackM data structures for the given number of blocks and
   * pointers and returns pointers to these in a BigPackEnvelope.
   */
  command BigPackEnvelope *BigPackServer.createEnvelope[uint8_t type](uint8_t numB, uint8_t numP) {
    numBlocks[curType] = numB;
    numPtrs = numP;
    if (allocEnv() == FAIL)
      return NULL;
    env.block = block;
    env.ptr = ptr;
    env.blockAddr = blockAddr[curType];
    return &env;
  }
  
  /*** Internal Helpers ***/
  
  void sendNextPack() {
    if (curPackNum < numPacks) {
      msgData msg;
      msg.src = TOS_LOCAL_ADDRESS;
      msg.dest = 0;
      if (curPackNum == -1) {
		msg.type = BIGPACKHEADER;
		msg.data.bpHeader.requestType = curType;
		msg.data.bpHeader.packTotal = numPacks;
		msg.data.bpHeader.byteTotal = numBytes;
		msg.data.bpHeader.numBlocks = numBlocks[curType];
		msg.data.bpHeader.numPtrs = numPtrs;
		dbg(DBG_USR2, "Sent BP header (0/%i) to sink\n", numPacks);
	  } else {
	    uint8_t i;
	    uint16_t firstByte = curPackNum * BP_DATA_LEN;
		uint8_t length = BP_DATA_LEN;
		if ((firstByte + length) > numBytes)
		  length = numBytes - firstByte;
		msg.type = BIGPACKDATA;
		msg.data.bpData.curPack = curPackNum;
		for (i = 0; i < length; i++)
		  msg.data.bpData.data[i] = bigData[firstByte + i];
		dbg(DBG_USR2, "Sent BP data (%i/%i) to sink\n", curPackNum + 1, numPacks);
	  }
	  call Message.send(msg);
	}
  }
  
  /**
   * Sends standard ACK by returning the message that was sent
   */
  void sendAck(msgData msg) {
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    //repeatSend(msg, 3000); 
    call Message.send(msg);
  }
  
  /**
   * Allocates temporary data used to rebuild an incoming
   * struct.
   */
  result_t allocInc() {
    uint16_t bpbSize = numBlocks[curType] * sizeof(BigPackBlock);
    uint16_t bppSize = numPtrs * sizeof(BigPackPtr);
    if ((bigData = malloc(numBytes - bpbSize - bppSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
      return FAIL;
    } 
    bdAlloc = TRUE;
    if ((block = malloc(bpbSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate block!\n");
      return FAIL;
    } 
    bpbAlloc = TRUE;
    if ((ptr = malloc(bppSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate ptr!\n");
      return FAIL;
    } 
    bppAlloc = TRUE;
    return SUCCESS;
  }
  
  /**
   * Free the incoming temp data.
   */ 
  void freeInc() {
    if (bdAlloc) {
      free(bigData);
      bdAlloc = FALSE;
    }
    if (bpbAlloc) {
      free(block);
      bpbAlloc = FALSE;
    }
    if (bppAlloc) {
      free(ptr);
      bppAlloc = FALSE;
    }
  }
  
  result_t allocEnv() {
    uint16_t bpbSize = numBlocks[curType] * sizeof(BigPackBlock);
    uint16_t bppSize = numPtrs * sizeof(BigPackPtr);
    if ((block = malloc(bpbSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate block!\n");
      return FAIL;
    } 
    bpbAlloc = TRUE;
    if ((ptr = malloc(bppSize)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate ptr!\n");
      return FAIL;
    } 
    bppAlloc = TRUE;
    if ((blockAddr[curType] = malloc(numBlocks[curType] * sizeof(int8_t *))) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate block address array for request %i!\n", 
          curType + 1);
      return FAIL;
    }
    mainBlock[curType] = (int8_t *) 1122; // Just so it's not NULL
    return SUCCESS;
  }
  
  /**
   * Free the outgoing temp data.
   */ 
  void freeEnv() {
    if (bpbAlloc) {
      free(block);
      bpbAlloc = FALSE;
    }
    if (bppAlloc) {
      free(ptr);
      bppAlloc = FALSE;
    }
    if (mainBlock[curType] != NULL) {
      free(blockAddr[curType]);
      mainBlock[curType] = NULL;
    }
  }
  
  /**
   * Free outgoing data stream.
   */ 
  void freeOut() {
    if (bdAlloc) {
      free(bigData);
      bdAlloc = FALSE;
    }
  }
   
  /*** Other Commands and Events ***/
  
  /**
   * sendDone is signaled when the send has completed
   */
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    switch (msg.type) {
      case BIGPACKHEADER: {
        if (result == FAIL) {
          dbg(DBG_USR2, "BigPack: BP header request failed!\n");
        }
        break; }
    }
    return SUCCESS;
  }
  
  void rebuildBlocks() {
    uint16_t start;
    uint8_t b, i;
    int8_t **tmp, **bStore;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate block address space
    if ((blockAddr[curType] = malloc(numBlocks[curType] * sizeof(int8_t *))) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block address array for request %i!\n", 
            curType + 1);
        return;
    }
    bStore = blockAddr[curType];
    // Allocate and fill each block
    for (b = 0; b < numBlocks[curType]; b++) {
      start = block[b].start;
      dbg(DBG_USR2, "BigPack: Block #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Start:  %i\n", start);
      dbg(DBG_USR2, "BigPack:   Length: %i\n", block[b].length);
      if ((bStore[b] = malloc(block[b].length)) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block %i!\n", b);
        return;
      }
      dbg(DBG_USR2, "BigPack:   Addr:  %p\n", (void *)bStore[b]);
      dbg(DBG_USR2, "BigPack:   Bytes\n");
      for (i = 0; i < block[b].length; i++) {
        bStore[b][i] = bigData[start + i];
        dbg(DBG_USR2, "BigPack:     Byte %i: %i\n", i + 1, bStore[b][i]);
      }
    }
    // Main block is the last block
    mainBlock[curType] = bStore[b - 1];
    // Recreate each pointer needed
    for (b = 0; b < numPtrs; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block: %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block:    %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      tmp = &bStore[ptr[b].destBlock][ptr[b].destOffset];
      if (ptr[b].blockArray) {
        dbg(DBG_USR2, "BigPack:   Block Array:   Yes\n");
        *tmp = &bStore[ptr[b].addrOfBlock];
      } else {
        dbg(DBG_USR2, "BigPack:   Block Array:   No\n");
        *tmp = bStore[ptr[b].addrOfBlock];
      }
      dbg(DBG_USR2, "BigPack:   Ptr Value:     %p\n", (void *)*tmp);
    }
    // Free incoming data
    freeInc();
    // Store numbers of refs to this data
    refs[curType] = numListeners[curType];
  }
  
  void decomposeStruct() {
    uint16_t start;
    uint8_t b, i;
    int8_t **bStore, *tmp;
    dbg(DBG_USR2, "BigPack: Decomposition\n");
    // Count total bytes and set block start
    numBytes = 0;
    for (b = 0; b < numBlocks[curType]; b++) {
      block[b].start = numBytes;
      numBytes += block[b].length;
    }
    numBytes += numBlocks[curType] * sizeof(BigPackBlock);
    numBytes += numPtrs * sizeof(BigPackPtr);
    // Allocate bigData to hold blocks, pointers, and data
    if ((bigData = malloc(numBytes)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
      return;
    } 
    bdAlloc = TRUE;
    // Put blocks and pointers into bigData
    start = 0;
    for (b = 0; b < numBlocks[curType]; b++) {
      tmp = &block[b];
      for (i = 0; i < sizeof(BigPackBlock); i++)
        bigData[start + i] = tmp[i];
      start += sizeof(BigPackBlock);
    }
    for (b = 0; b < numPtrs; b++) {
      tmp = &ptr[b];
      for (i = 0; i < sizeof(BigPackPtr); i++)
        bigData[start + i] = tmp[i];
      start += sizeof(BigPackPtr);
    }
    // Put data stream into bigData
    bStore = blockAddr[curType];
    for (b = 0; b < numBlocks[curType]; b++) {
      dbg(DBG_USR2, "BigPack: Block #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Start:  %i\n", block[b].start);
      dbg(DBG_USR2, "BigPack:   Length: %i\n", block[b].length);
      dbg(DBG_USR2, "BigPack:   Addr:  %p\n", (void *)bStore[b]);
      dbg(DBG_USR2, "BigPack:   Bytes\n");
      for (i = 0; i < block[b].length; i++) {
        dbg(DBG_USR2, "BigPack:     Byte %i: %i\n", i + 1, bStore[b][i]);
        bigData[start + block[b].start + i] = bStore[b][i];
      }
    }
    // Print out pointers for debugging
    for (b = 0; b < numPtrs; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block: %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block:    %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      (ptr[b].blockArray) ? dbg(DBG_USR2, "BigPack:   Block Array:   Yes\n")
                          : dbg(DBG_USR2, "BigPack:   Block Array:   No\n");
    }
    // Free envelope data
    freeEnv();
    // Print out data stream for debugging
    dbg(DBG_USR2, "BigPack: Data Stream\n");
    for (i = 0; i < numBytes; i++)
      dbg(DBG_USR2, "BigPack:   Byte %i: %i\n", i + 1, bigData[i]);
    // Calculate number of packs to transmit
    numPacks = numBytes / BP_DATA_LEN;
    if ((numBytes % BP_DATA_LEN) > 0)
      numPacks++;
  }
    
  /**
   * Receive is signaled when a new message arrives
   */
  event void Message.receive(msgData msg) {
    switch (msg.type) {
    case BIGPACKHEADER: {
      BigPackHeader *h = &msg.data.bpHeader;
      if (!bdAlloc && !bpbAlloc && !bppAlloc && transState == BP_RECEIVING &&
          activeRequest && h->packTotal != 0 && h->requestType == curType) {
        // Received a new header in response to our request
        // Turn off message repeat
        call MsgRepeat.stop();
        // Store header data
        numPacks = h->packTotal;
        numBytes = h->byteTotal;
        numBlocks[curType] = h->numBlocks;
        numPtrs = h->numPtrs;
        dbg(DBG_USR2, "BigPack: Rcvd BP header (0/%i)\n", numPacks);
        // Allocate temporary arrays
        if (allocInc() == FAIL) return;
        curPackNum = 0;
        // Send an ACK
        sendAck(msg);
      } else if (!bdAlloc && !bpbAlloc && !bppAlloc && 
                 !activeRequest && h->packTotal == 0) {
        // Received a new big pack request
        if (h->requestType >= BP_MAX_REQUESTS || activeRequest ||
            mainBlock[h->requestType] != NULL) 
          return;
        dbg(DBG_USR2, "Got BP header request from the sink\n");
        // Set status varibles
        curType = h->requestType;
        activeRequest = TRUE;
        transState = BP_SENDING;
        if (signal BigPackServer.buildPack[h->requestType]() == SUCCESS) {
          // Break up the struct
          decomposeStruct();
          // Set curPackNum to -1 (to transmit header first)
          curPackNum = -1;
          // Start sending packs
          sendNextPack();
        } else {
          freeEnv();
          activeRequest = FALSE;
        }
      } else if (activeRequest && h->packTotal == numPacks && 
                 transState == BP_SENDING && h->requestType == curType) {
        // Received a BP header ACK
        dbg(DBG_USR2, "Got BP header ack from the sink\n");
        curPackNum++;
        sendNextPack();
      }
      break; }
    case BIGPACKDATA: {
      BigPackData *d = &msg.data.bpData;
      if (curPackNum == d->curPack && activeRequest && transState == BP_RECEIVING) {
        uint8_t i;
        int16_t base_offset, blk_offset, ptr_offset, data_offset, stopAt;
        // Byte level access to block and data
        int8_t *tmpBlk = (int8_t *)block; 
        int8_t *tmpPtr = (int8_t *)ptr;
        // Turn off message repeat
        call MsgRepeat.stop();
        dbg(DBG_USR2, "BigPack: Rcvd BP data (%i/%i)\n", curPackNum + 1, numPacks);
        // Calculate offsets
        base_offset = curPackNum * BP_DATA_LEN;
        (++curPackNum == numPacks) ? (stopAt = numBytes - base_offset)
                                   : (stopAt = BP_DATA_LEN);
        // Store pack data
        for (i = 0; i < stopAt; i++) {
          blk_offset = base_offset + i;
          ptr_offset = blk_offset - numBlocks[curType] * sizeof(BigPackBlock);
          data_offset = ptr_offset - numPtrs * sizeof(BigPackPtr);
          if (data_offset >= 0) { // Byte is data
            bigData[data_offset] = d->data[i];
          } else if (ptr_offset >= 0) { // Byte is pointer data
            tmpPtr[ptr_offset] = d->data[i];
          } else { // Byte is block data
            tmpBlk[blk_offset] = d->data[i];
          }
        }
        if (curPackNum == numPacks) { 
          rebuildBlocks();
          dbg(DBG_USR2, "BigPack: BP data complete\n");
          signal BigPackClient.requestDone[curType](mainBlock[curType], SUCCESS);
          activeRequest = FALSE;
        }
        // Send an ACK
        sendAck(msg);
      } else if (curPackNum == d->curPack && activeRequest && transState == BP_SENDING) {
        // Received a BP data ACK
        dbg(DBG_USR2, "Got BP data ack from the sink\n");
        if (++curPackNum < numPacks) {
          sendNextPack();
        } else {
          freeOut();
          activeRequest = FALSE;
        }
      }
      break; }
    }   
  }
}
