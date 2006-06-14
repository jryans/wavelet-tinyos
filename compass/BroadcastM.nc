/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
 
/**
 * Original code and concept
 * @author Philip Buonadonna
 */
 
/**
 * I converted the TinyOS library Bcast to a version that makes use of the
 * Transceiver library and makes use of its queue abilities, rather than
 * implementing another one of its own.
 * @author Ryan Stinnett
 */

includes AM;
includes IOPack;

module BroadcastM {
  provides {
    interface StdControl;
    interface Message;
  }
  uses interface Transceiver as IO;
}

implementation {
  
  #if 0
  typedef uint8_t bPack;
  #endif

  int16_t bcastSeqno;
  TOS_MsgPtr tmpPtr;
  uint8_t len = sizeof(bPack);

  /***********************************************************************
   * Initialization 
   ***********************************************************************/

  void initialize() {
    bcastSeqno = 0;
  }

  /***********************************************************************
   * Internal functions
   ***********************************************************************/

  bool newBcast(int16_t proposed) {
    /*	This handles sequence space wrap-around. Overlow/Underflow makes
     * the result below correct ( -, 0, + ) for any a, b in the sequence
     * space. Results:	result	implies
     *			  - 	 a < b
     *			  0 	 a = b
     *			  + 	 a > b
     */
    if ((proposed - bcastSeqno) > 0) {
      bcastSeqno++;
      return TRUE;
    } else {
      return FALSE;
    }
  }

  /* Each unique broadcast wave is signaled to application and
   * rebroadcast once.
   */
  void FwdBcast(bPack *pRcvMsg, uint8_t repeatsLeft) {
    bPack *pFwdMsg;
    if ((tmpPtr = call IO.requestWrite()) != NULL) { // Gets a new TOS_MsgPtr
      pFwdMsg = (bPack *)tmpPtr->data;
    } else {
      dbg(DBG_USR1, "Bcast: Couldn't get a new TOS_MsgPtr! (seqno 0x%x)\n", pRcvMsg->seqno);
      return;
    }
    memcpy(pFwdMsg,pRcvMsg,len);  
    dbg(DBG_USR1, "Bcast: FwdMsg (seqno 0x%x) sending, %i repeats left...\n", 
        pFwdMsg->seqno, repeatsLeft);
    call IO.sendRadio(TOS_BCAST_ADDR, len); 
    if (repeatsLeft > 0)
      FwdBcast(pFwdMsg, repeatsLeft - 1);
  }
  
  /**
   * All received messages come here, since the medium is unimportant.
   */
  TOS_MsgPtr receive(TOS_MsgPtr pMsg) {
    bPack *pBCMsg = (bPack *)pMsg->data;
    dbg(DBG_USR1, "Bcast: Msg rcvd, seq 0x%02x\n", pBCMsg->seqno);
    if (newBcast(pBCMsg->seqno)) {
      FwdBcast(pBCMsg, BCAST_REPEATS);
      if (TOS_LOCAL_ADDRESS != 0)
        signal Message.receive(pBCMsg->data);
    }
    return pMsg;
  }

  /***********************************************************************
   * Commands and events
   ***********************************************************************/

  command result_t StdControl.init() {
    initialize();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  /**
   * Sends message data to the network
   * TODO: Can't initiate broadcasts on a mote yet.
   */
  command result_t Message.send(msgData msg) {
    if (msg.dest == TOS_BCAST_ADDR)
      return FAIL;
    return SUCCESS;
  }
  
  /**
   * A message was sent over radio.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t IO.radioSendDone(TOS_MsgPtr m, result_t result) {
    bPack *pBCMsg = (bPack *)m->data;
    if (result == SUCCESS) {  
      dbg(DBG_USR1, "Bcast: FwdMsg (seqno 0x%x) succeeded\n", pBCMsg->seqno);
    } else {
      dbg(DBG_USR1, "Bcast: FwdMsg (seqno 0x%x) failed!\n", pBCMsg->seqno);
    }
    return SUCCESS;
  }
  
  /**
   * A message was sent over UART.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t IO.uartSendDone(TOS_MsgPtr m, result_t result) {
    return SUCCESS; // Broadcasts aren't sent via the UART  
  }
  
  /**
   * Received a message over the radio
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr IO.receiveRadio(TOS_MsgPtr m) {
    return receive(m);	
  }
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr IO.receiveUart(TOS_MsgPtr m) {
    return receive(m);	
  }
}



