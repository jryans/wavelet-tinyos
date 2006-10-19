/**
 * Requests and rebuilds multi-packet data structures.  Can act as both
 * a client that receives data from the sink, and as a server that sends
 * data to the sink.
 * @author Ryan Stinnett
 */
 
includes BigPack;
includes MessageType;
 
module BigPackM {
  uses {
    interface CreateMsg as MakeHeader;
    interface CreateMsg as MakeData;
    interface SendMsg as SendHeader;
    interface SendMsg as SendData;
    interface SrcReceiveMsg as RcvHeader;
    interface SrcReceiveMsg as RcvData;
    interface Timer as Timeout;
#ifdef BEEP
    interface Beep;
#endif
  }
  provides {
    interface BigPackServer[uint8_t chan];
    interface BigPackClient[uint8_t chan];
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

  // Internal Variables
  
  uint8_t numPacks;
  int8_t curPackNum;
  uint8_t numBytes;
  uint8_t *bigData;
  bool bdAlloc = FALSE;
  
  BigPackBlock *block;
  uint8_t numBlocks[BP_MAX_REQUESTS];
  bool bpbAlloc = FALSE;
  
  BigPackPtr *ptr;
  uint8_t numPtrs;
  bool bppAlloc = FALSE;
  
  uint8_t curChan;
  // TRUE if a request is in progress, else FALSE.
  bool activeRequest;
  
  uint8_t **blockAddr[BP_MAX_REQUESTS];
  void *mainBlock[BP_MAX_REQUESTS];
  uint8_t refs[BP_MAX_REQUESTS];
  uint8_t numListeners[BP_MAX_REQUESTS];
  
  uint8_t transState;
  
  // Function Prototypes
  
  result_t allocInc();
  void freeInc();
  result_t allocEnv();
  void freeEnv();
  void freeOut();
  void requestData(uint8_t type);
  void sendAckHeader(TOS_MsgPtr m);
  void sendAckData(TOS_MsgPtr m);
  void rebuildBlocks();
  result_t newRequest(uint8_t type);
  void decomposeStruct();
  void sendNextPack();
  
  // Outgoing only
  BigPackEnvelope env;
  
  uint16_t sendDest;
  TOS_MsgPtr sendPtr;
  
  // Timers
  
  /**
   * Sends a message and activates a timeout timer that if fired
   * will cancel the current BigPack data session.  Thus, whenever
   * a response is received, the timer must explicitly be disabled
   * to keep the session alive.
   */ 
  task void timeoutSendHeader() {
    call SendHeader.send(sendDest, sizeof(BigPackHeader), sendPtr);
    call Timeout.start(TIMER_ONE_SHOT, BP_TIMEOUT);
  }
  
  /**
   * Sends a message and activates a timeout timer that if fired
   * will cancel the current BigPack data session.  Thus, whenever
   * a response is received, the timer must explicitly be disabled
   * to keep the session alive.
   */ 
  task void timeoutSendData() {
    call SendData.send(sendDest, sizeof(BigPackData), sendPtr);
    call Timeout.start(TIMER_ONE_SHOT, BP_TIMEOUT);
  }
  
  /**
   * Cancels the current BigPack data session once the timeout timer
   * has fired.
   */
  event result_t Timeout.fired() {
    if (activeRequest) {
      dbg(DBG_USR2, "BigPack: Timeout reached\n");
      if (transState == BP_RECEIVING) {
        freeInc();
        mainBlock[curChan] = NULL;
      } else if (transState == BP_SENDING) {
        freeOut();
      } 
      activeRequest = FALSE;
    }
    return SUCCESS;
  }  
  
  // StdControl
  
  command result_t StdControl.init() 
  {
    uint8_t i;
    for (i = 0; i < BP_MAX_REQUESTS; i++) {
      mainBlock[i] = NULL;
      numListeners[i] = 0;
      refs[i] = 0;
    }
    activeRequest = FALSE;
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
  
  // BigPackClient
  
  /**
   * Each module that listens to the requestDone event should call this method
   * during startup to ensure that no pointers are freed until all modules are
   * done with them.
   */
  command void BigPackClient.registerListener[uint8_t chan]() {
    numListeners[chan]++;
  }
  
  /**
   * Requests big pack data of a certain type.  If another request is already being
   * processed, this will return FAIL and do nothing.  Otherwise, it returns SUCCESS
   * and begins the request.
   */
  command result_t BigPackClient.request[uint8_t chan]() {
    if (chan >= BP_MAX_REQUESTS || activeRequest)
      return FAIL;
    if (mainBlock[chan] == NULL) {
      BigPackHeader *bph;
      sendPtr = call MakeHeader.create();
      sendDest = NET_UART_ADDR;
      bph = (BigPackHeader *)sendPtr->data;
      curChan = chan;
      mainBlock[chan] = (void *) 1122; // Just so it's not NULL
      bph->requestType = chan;
      bph->packTotal = 0;
      activeRequest = TRUE;
      transState = BP_RECEIVING;
      post timeoutSendHeader();
    } else {
      return FAIL;
    }
    return SUCCESS;
  }
  
  /**
   * When an application is done with the data, it must call free so that internal
   * structures can be deallocated.
   */
  command void BigPackClient.free[uint8_t chan]() {
    uint8_t b;
    // Ensure this is a valid type
    if (chan >= BP_MAX_REQUESTS || mainBlock[chan] == NULL)
      return; 
    // If found, then decrement refs
    refs[chan]--;
    // If refs == 0, then free the memory
    if (refs[chan] == 0) {
      for (b = 0; b < numBlocks[chan]; b++)
        free(blockAddr[chan][b]);
      free(blockAddr[chan]);
      mainBlock[chan] = NULL;
    }
  }
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  default event void BigPackClient.requestDone[uint8_t chan](void *mb, result_t result) {}
  
  // BigPackServer
  
  /**
   * When the mote receives a big pack data request from the sink,
   * this event is signaled triggering the application to assemble
   * the requested data.
   */
  default event void BigPackServer.buildPack[uint8_t chan]() {
    call BigPackServer.packBuilt[chan](FAIL);
  }
  
  /**
   * A helper function used when a module is building a big pack
   * in response to the buildPack event.  This allocates internal
   * BigPackM data structures for the given number of blocks and
   * pointers and returns pointers to these in a BigPackEnvelope.
   */
  command BigPackEnvelope *BigPackServer.createEnvelope[uint8_t chan](uint8_t numB, uint8_t numP) {
    numBlocks[curChan] = numB;
    numPtrs = numP;
    if (allocEnv() == FAIL)
      return NULL;
    env.block = block;
    env.ptr = ptr;
    env.blockAddr = blockAddr[curChan];
    return &env;
  }
  
  /**
   * Once the new pack is complete, the application calls this command
   * to start transmission of the data.
   */
  command void BigPackServer.packBuilt[uint8_t chan](result_t result) {
    if (result == SUCCESS) {
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
  }
  
  // Internal Helpers
  
  /**
   * Sends the next packet to continue the data session.
   */
  void sendNextPack() {
    if (curPackNum < numPacks) {
      sendDest = NET_UART_ADDR;
      if (curPackNum == -1) {
        BigPackHeader *bph;
        sendPtr = call MakeHeader.create();
        bph = (BigPackHeader *)sendPtr->data;
		bph->requestType = curChan;
		bph->packTotal = numPacks;
		bph->byteTotal = numBytes;
		bph->numBlocks = numBlocks[curChan];
		bph->numPtrs = numPtrs;
		dbg(DBG_USR2, "Sent BP header (0/%i) to sink\n", numPacks);
		post timeoutSendHeader();
	  } else {
	    BigPackData *bpd;
	    uint16_t firstByte = curPackNum * BP_DATA_LEN;
		uint8_t length = BP_DATA_LEN;
		sendPtr = call MakeData.create();
		bpd = (BigPackData *)sendPtr->data;
		if ((firstByte + length) > numBytes)
		  length = numBytes - firstByte;
		bpd->curPack = curPackNum;
		memcpy(bpd->data, &bigData[firstByte], length);
		dbg(DBG_USR2, "Sent BP data (%i/%i) to sink\n", curPackNum + 1, numPacks);
		post timeoutSendData();
	  }
	}
  }
  
  /**
   * Sends standard ACK by returning the header message that was sent
   */
  void sendAckHeader(TOS_MsgPtr m) {
    sendPtr = call MakeHeader.createCopy(m);
    sendDest = NET_UART_ADDR;
    post timeoutSendHeader();
  }
  
  /**
   * Sends standard ACK by returning the data message that was sent
   */
  void sendAckData(TOS_MsgPtr m) {
    sendPtr = call MakeData.createCopy(m);
    sendDest = NET_UART_ADDR;
    post timeoutSendData();
  }
  
  /**
   * Allocates temporary data used to rebuild an incoming
   * struct.
   */
  result_t allocInc() {
    uint16_t bpbSize = numBlocks[curChan] * sizeof(BigPackBlock);
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
   * Free the incoming temporary data.
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
  
  /**
   * Allocates temporary data used to describe an outgoing struct.
   */
  result_t allocEnv() {
    uint16_t bpbSize = numBlocks[curChan] * sizeof(BigPackBlock);
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
    if ((blockAddr[curChan] = malloc(numBlocks[curChan] * sizeof(int8_t *))) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate block address array for request %i!\n", 
          curChan + 1);
      return FAIL;
    }
    mainBlock[curChan] = (int8_t *) 1122; // Just so it's not NULL
    return SUCCESS;
  }
  
  /**
   * Free the outgoing temporary data.
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
    if (mainBlock[curChan] != NULL) {
      free(blockAddr[curChan]);
      mainBlock[curChan] = NULL;
    }
  }
  
  /**
   * Free the outgoing data stream.
   */ 
  void freeOut() {
    if (bdAlloc) {
      free(bigData);
      bdAlloc = FALSE;
    }
  }
  
  /**
   * Rebuild data structures from an incoming data stream.
   */
  void rebuildBlocks() {
    uint16_t start;
    uint8_t b, i;
    uint8_t **tmp, **bStore;
    dbg(DBG_USR2, "BigPack: Blocks and Pointers\n");
    // Allocate block address space
    if ((blockAddr[curChan] = malloc(numBlocks[curChan] * sizeof(int8_t *))) == NULL) {
        dbg(DBG_USR2, "BigPack: Couldn't allocate block address array for request %i!\n", 
            curChan + 1);
        return;
    }
    bStore = blockAddr[curChan];
    // Allocate and fill each block
    for (b = 0; b < numBlocks[curChan]; b++) {
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
    mainBlock[curChan] = (void *)bStore[b - 1];
    // Recreate each pointer needed
    for (b = 0; b < numPtrs; b++) {
      dbg(DBG_USR2, "BigPack: Pointer #%i\n", b + 1);
      dbg(DBG_USR2, "BigPack:   Addr of Block: %i\n", ptr[b].addrOfBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Block:    %i\n", ptr[b].destBlock + 1);
      dbg(DBG_USR2, "BigPack:   Dest Offset:   %i\n", ptr[b].destOffset);
      tmp = (uint8_t **)&bStore[ptr[b].destBlock][ptr[b].destOffset];
      if (ptr[b].blockArray) {
        dbg(DBG_USR2, "BigPack:   Block Array:   Yes\n");
        *tmp = (uint8_t *)&bStore[ptr[b].addrOfBlock];
      } else {
        dbg(DBG_USR2, "BigPack:   Block Array:   No\n");
        *tmp = bStore[ptr[b].addrOfBlock];
      }
      dbg(DBG_USR2, "BigPack:   Ptr Value:     %p\n", (void *)*tmp);
    }
    // Free incoming data
    freeInc();
    // Store numbers of refs to this data
    refs[curChan] = numListeners[curChan];
  }
  
  /**
   * Break down structures into a data stream that can be
   * sent away.
   */
  void decomposeStruct() {
    uint16_t start;
    uint8_t b, i;
    uint8_t **bStore, *tmp;
    dbg(DBG_USR2, "BigPack: Decomposition\n");
    // Count total bytes and set block start
    numBytes = 0;
    for (b = 0; b < numBlocks[curChan]; b++) {
      block[b].start = numBytes;
      numBytes += block[b].length;
    }
    numBytes += numBlocks[curChan] * sizeof(BigPackBlock);
    numBytes += numPtrs * sizeof(BigPackPtr);
    // Allocate bigData to hold blocks, pointers, and data
    if ((bigData = malloc(numBytes)) == NULL) {
      dbg(DBG_USR2, "BigPack: Couldn't allocate bigData!\n");
      return;
    } 
    bdAlloc = TRUE;
    // Put blocks and pointers into bigData
    start = 0;
    for (b = 0; b < numBlocks[curChan]; b++) {
      tmp = (uint8_t *)&block[b];
      for (i = 0; i < sizeof(BigPackBlock); i++)
        bigData[start + i] = tmp[i];
      start += sizeof(BigPackBlock);
    }
    for (b = 0; b < numPtrs; b++) {
      tmp = (uint8_t *)&ptr[b];
      for (i = 0; i < sizeof(BigPackPtr); i++)
        bigData[start + i] = tmp[i];
      start += sizeof(BigPackPtr);
    }
    // Put data stream into bigData
    bStore = blockAddr[curChan];
    for (b = 0; b < numBlocks[curChan]; b++) {
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
      if (ptr[b].blockArray) {
        dbg(DBG_USR2, "BigPack:   Block Array:   Yes\n");
      } else {
        dbg(DBG_USR2, "BigPack:   Block Array:   No\n");
      }
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
  
  // Other Commands and Events
  
  event result_t SendHeader.sendDone(TOS_MsgPtr msg, result_t success) {
    /* if (result == FAIL) {
          dbg(DBG_USR2, "BigPack: BP header request failed!\n");
        } */
    return SUCCESS;
  }
  
  event result_t SendData.sendDone(TOS_MsgPtr msg, result_t success) {
    return SUCCESS;
  }
   
  event TOS_MsgPtr RcvHeader.receive(uint16_t src, TOS_MsgPtr m) {
    BigPackHeader *h = (BigPackHeader *)m->data;
    if (!bdAlloc && !bpbAlloc && !bppAlloc && transState == BP_RECEIVING &&
        activeRequest && h->packTotal != 0 && h->requestType == curChan) {
      // Received a new header in response to our request
      // Turn off timeout check
      call Timeout.stop();
      // Store header data
      numPacks = h->packTotal;
      numBytes = h->byteTotal;
      numBlocks[curChan] = h->numBlocks;
      numPtrs = h->numPtrs;
      dbg(DBG_USR2, "BigPack: Rcvd BP header (0/%i)\n", numPacks);
      // Allocate temporary arrays
      if (allocInc() == FAIL) return m;
      curPackNum = 0;
      // Send an ACK
      sendAckHeader(m);
    } else if (!bdAlloc && !bpbAlloc && !bppAlloc && 
               !activeRequest && h->packTotal == 0) {
      // Received a new big pack request
      if (h->requestType >= BP_MAX_REQUESTS || activeRequest ||
          mainBlock[h->requestType] != NULL) 
        return m;
      dbg(DBG_USR2, "Got BP header request from the sink\n");
      // Set status varibles
      curChan = h->requestType;
      activeRequest = TRUE;
      transState = BP_SENDING;
      // Tell the application to create a new big data pack
      signal BigPackServer.buildPack[h->requestType]();
    } else if (activeRequest && h->packTotal == numPacks && 
               transState == BP_SENDING && h->requestType == curChan) {
      // Turn off timeout check
      call Timeout.stop();
      // Received a BP header ACK
      dbg(DBG_USR2, "Got BP header ack from the sink\n");
      curPackNum++;
      sendNextPack();
    }
    return m;
  }
      
  event TOS_MsgPtr RcvData.receive(uint16_t src, TOS_MsgPtr m) {
    BigPackData *d = (BigPackData *)m->data;
    if (curPackNum == d->curPack && activeRequest && transState == BP_RECEIVING) {
      uint8_t i;
      int16_t base_offset, blk_offset, ptr_offset, data_offset, stopAt;
      // Byte level access to block and data
      uint8_t *tmpBlk = (uint8_t *)block; 
      uint8_t *tmpPtr = (uint8_t *)ptr;
      // Turn off timeout check
      call Timeout.stop();
      dbg(DBG_USR2, "BigPack: Rcvd BP data (%i/%i)\n", curPackNum + 1, numPacks);
      // Calculate offsets
      base_offset = curPackNum * BP_DATA_LEN;
      (++curPackNum == numPacks) ? (stopAt = numBytes - base_offset)
                                 : (stopAt = BP_DATA_LEN);
      // Store pack data
      for (i = 0; i < stopAt; i++) {
        blk_offset = base_offset + i;
        ptr_offset = blk_offset - numBlocks[curChan] * sizeof(BigPackBlock);
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
        signal BigPackClient.requestDone[curChan](mainBlock[curChan], SUCCESS);
        activeRequest = FALSE;
      }
      // Send an ACK
      sendAckData(m);
    } else if (curPackNum == d->curPack && activeRequest && transState == BP_SENDING) {
      // Turn off timeout check
      call Timeout.stop();
      // Received a BP data ACK
      dbg(DBG_USR2, "Got BP data ack from the sink\n");
      if (++curPackNum < numPacks) {
        sendNextPack();
      } else {
        freeOut();
        activeRequest = FALSE;
      }
    }
    return m;
  }
}
