// $Id: RfmToIntM.nc,v 1.2 2003/10/07 21:46:18 idgay Exp $

/*         tab:4
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
/*
 * Authors:  Jason Hill, David Gay, Philip Levis
 * Date last modified:  6/25/02
 *
 */

/**
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 */

// This begins the section modified by The Moters (Fall 2005 - Spring 2006)

/**
 * This application implements the functions desired by its configuration.  It reads a 
 * message (SensorMsg) from the Rfm stack and sends it to the main part of the program using 
 * the SensorOutput Interface.
 **/

includes SensorMsg;

module RfmToSensorM {
  provides interface StdControl;
  uses {
    interface Transceiver as ReceiveSensorMsg;
    interface SensorOutput;
  }
}
implementation {
  
  // Local TOS_Msg structure - new messages will be written here 1/2 the time
  TOS_Msg localTosMsg;
  
  // The pointer to the current received message you're working with
  TOS_MsgPtr receiveMsgPtr;
  

  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  event TOS_MsgPtr ReceiveSensorMsg.receiveRadio(TOS_MsgPtr m) {
    TOS_MsgPtr returnPtr;
    SensorMsg *message = (SensorMsg *)m->data;
    
    /* Perform the pointer swap - you could even add some state machine to make sure you're 
     * not overwritting variables in use:
     */    
    if(m == &localTosMsg) 
    {
      // The received pointer is my local message, do pass back a different pointer than the one we received:
      returnPtr = receiveMsgPtr;
    } 
    else 
    {
      // The received pointer is not my local message, so pass back a pointer to my message:
      returnPtr = &localTosMsg;    
    }
  
    receiveMsgPtr = m; 
    call SensorOutput.output(message->val, message->src, message->next_addr, message->dest_addr, message->hops, message->msg_type);
    return returnPtr;
  }

  event result_t SensorOutput.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
  
  
   event TOS_MsgPtr ReceiveSensorMsg.receiveUart(TOS_MsgPtr m)
  {
    return m;
  }
  
  
  event result_t ReceiveSensorMsg.radioSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event result_t ReceiveSensorMsg.uartSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  

}
