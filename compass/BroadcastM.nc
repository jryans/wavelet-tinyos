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
 * TODO: Remove back-to-back repeats.  Simple idea: save message,
 * repeat a few times with timers.  Use sounder if Tranceiver needs more
 * message slots.
 * From Ray: If you know neighbors, repeat bcasts until neighbors repeat
 * them back to you (prob give up after N tries or M ms)
 * @author Ryan Stinnett
 */

includes AM;
includes IOPack;

module BroadcastM {
  provides {
    interface Message;
  }
  uses {
    interface Transceiver as IO;
    interface Leds;
    interface Timer as Repeat;
    interface MoteOptions;
#ifdef BEEP
    interface Beep;
#endif
  }
}

implementation {
  
#if 0 // TinyOS Plugin Workaround
  typedef uint8_t bPack;
  #endif

  int16_t bcastSeqno = 0;
  TOS_MsgPtr tmpPtr;
  bPack sendData;
  uint8_t curRepsLeft;
  uint8_t len = sizeof(bPack);

  /*** Internal Functions ***/

  /** 
   * This handles sequence space wrap-around. Overlow/Underflow makes
     * the result below correct ( -, 0, + ) for any a, b in the sequence
     * space. Results:	result	implies
     *			  - 	 a < b
     *			  0 	 a = b
     *			  + 	 a > b
     */
  bool newBcast(int16_t proposed) {
    if ((proposed - bcastSeqno) > 0) {
      bcastSeqno++;
      return TRUE;
    } else {
      return FALSE;
    }
  }

  /**
   * Each unique broadcast wave is signaled to applications once, but
   * may be rebroadcast multiple times to ensure reception.
   */
  void fwdBcast() {
    bPack *pFwdMsg;
    if ((tmpPtr = call IO.requestWrite()) != NULL) { // Gets a new TOS_MsgPtr
      pFwdMsg = (bPack *)tmpPtr->data;
    } else {
      // If we're out of free messages, try increasing MAX_TOS_MSGS
#ifdef BEEP
      call Beep.play(3, 250);
#endif
      dbg(DBG_USR1, "Bcast: Couldn't get a new TOS_MsgPtr! (seqno 0x%x)\n", sendData.seqno);
      return;
    }
    curRepsLeft--;
    *pFwdMsg = sendData; 
    dbg(DBG_USR1, "Bcast: FwdMsg (seqno 0x%x) sending, %i repeats left...\n", 
        pFwdMsg->seqno, curRepsLeft);
    call IO.sendRadio(TOS_BCAST_ADDR, len); 
    if (curRepsLeft > 0)
      call Repeat.start(TIMER_ONE_SHOT, BCAST_REP_DELAY);
  }
  
  /**
   * All received messages come here, since the medium is unimportant.
   */
  TOS_MsgPtr receive(TOS_MsgPtr pMsg) {
    bPack *pBCMsg = (bPack *)pMsg->data;
    if (newBcast(pBCMsg->seqno)) {
      dbg(DBG_USR1, "Bcast: Msg rcvd, seq 0x%02x\n", pBCMsg->seqno);
      sendData = *pBCMsg;
      curRepsLeft = BCAST_REPEATS;
      fwdBcast();
      if (TOS_LOCAL_ADDRESS != 0)
        signal Message.receive(pBCMsg->data);
    }
    return pMsg;
  }

  /*** Commands and Events ***/

  /**
   * After a delay of BCAST_REP_DELAY bms, a broadcast message
   * is repeat to ensure neighbors receive it.
   */
  event result_t Repeat.fired() {
    fwdBcast();
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
    call MoteOptions.resetSleep();
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
  
  /**
   * Signaled when an option affecting other applications is received.
   */
  event void MoteOptions.receive(uint8_t optMask, uint8_t optValue) {}
}

