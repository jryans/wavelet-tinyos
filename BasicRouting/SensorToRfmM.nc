// $Id: IntToRfmM.nc,v 1.3 2004/11/29 19:18:48 idgay Exp $

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
 * Authors:  Jason Hill, David Gay, Philip Levis, Nelson Lee
 * Date last modified:  6/25/02
 *
 */

/**
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 * @author Nelson Lee
 */


// This begins the section modified by The Moters (Fall 2005 - Spring 2006)

/**
 * This application implements the functionality of its configuration.  It sends data 
 * from the SensorMsg type to the Rfm Stack.  It may be used for single or mulit-hop 
 * communications.
 **/

includes SensorMsg;

module SensorToRfmM 
{
  uses {
    interface StdControl as SubControl;
    interface Transceiver as Send;
  }
  provides {
    interface SensorOutput;
    interface StdControl;
  }
}
implementation
{
  bool pending;
  TOS_Msg data;
  
  TOS_MsgPtr tosPtr;   
  SensorMsg *message; 
  
  result_t newMessage();
 

  command result_t StdControl.init() 
  {
    pending = FALSE;
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

  
  command result_t SensorOutput.output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                       uint16_t hops, uint16_t msg_type) 
  {    
    uint16_t LCV = 0;
    
    if(newMessage()) {

      for(LCV; LCV < 5; LCV++)
        message->val[LCV] = measurements[LCV];
      
      message->next_addr = next_addr;
      message->dest_addr = dest_addr;
      message->src = source;
      message->hops = hops;
      message->msg_type = msg_type;
      
      if (call Send.sendRadio(next_addr, sizeof(SensorMsg)))
        return SUCCESS;
 
    }

    return FAIL;
  }

  event result_t Send.radioSendDone(TOS_MsgPtr msg, result_t success)
  {
    return SUCCESS;
  }
  
   event TOS_MsgPtr Send.receiveUart(TOS_MsgPtr m)
  {
    return m;
  }
  
  event result_t Send.uartSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event TOS_MsgPtr Send.receiveRadio(TOS_MsgPtr m)
  {
    return m;
  }
     
  result_t newMessage() {
    if((tosPtr = call Send.requestWrite()) != NULL) {
      message = (SensorMsg *) tosPtr->data;
      return SUCCESS;
    }
    return FAIL;
  }
    
}




