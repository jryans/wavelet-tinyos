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

module SensorToUARTM 
{
  uses {
    interface StdControl as SubControl;
    interface Transceiver as DataMsg;
    interface Transceiver as ResetCounterMsg;
  }
  provides {
    interface SensorOutput;
    interface StdControl;
  }
}
implementation
{
  uint8_t packetReadingNumber;
  uint16_t readingNumber;
  TOS_MsgPtr msg[2];
  uint8_t currentMsg;
  uint16_t hop;
  uint16_t src;
  struct CPUMsg *message;
  uint16_t wav_val_light;
  uint16_t wav_val_temp;
  uint16_t voltage;

  result_t newMessage();

  /**
   * Used to initialize this component.
   */
  command result_t StdControl.init() 
  {
    call SubControl.init();
    
    atomic 
    {
      currentMsg = 0;
      packetReadingNumber = 0;
      readingNumber = 0;
    }
    
    dbg(DBG_BOOT, "TALKING MONKEY initialized\n");
    return SUCCESS;
  }

  /**
   * Starts the SensorControl and CommControl components.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.start() 
  {
    call SubControl.start();
    return SUCCESS;
  }

  /**
   * Stops the SensorControl and CommControl components.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.stop() 
  {
    call SubControl.stop();
    return SUCCESS;
  }

  task void dataTask() 
  {
    
    if(newMessage()) 
    {
      message->hops = hop;
      message->sourceMoteID = src;
      message->data[0] = wav_val_light;
      message->data[1] = wav_val_temp;
      // keep this line uncommented to return the battery voltage;
      // or uncomment the two lines below to return the raw light and temperature values instead
      message->data[2] = voltage;
//      message->data[2] = raw_val_light;
//      message->data[3] = raw_val_temp;
     
      
      /* Try to send the packet. Note that this will return
       * failure immediately if the packet could not be queued for
       * transmission.
       */

      if (call DataMsg.sendUart(sizeof(struct CPUMsg))) // TODO - add newMessage code
      {
        atomic 
        {
          currentMsg ^= 0x1;
        }
      }

        return SUCCESS;
      
    }   
  }
  
  /**
   * Signalled when data is ready from the ADC. 
   * @return Always returns SUCCESS.
   */
  command result_t SensorOutput.output(uint16_t /**/  measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                          uint16_t hops, uint16_t msg_type)
   {
    atomic 
    {
        src = source;
        hop = hops;
        wav_val_light = measurements[0];       
        wav_val_temp = measurements[1];    
      // keep this line uncommented to return the battery voltage;
      // or uncomment the two lines below to return the raw light and temperature values instead
        voltage = measurements[2];
//        raw_val_light = measurements[2];
//        raw_val_temp = measurements[3];
        post dataTask();
    }
    
    return SUCCESS;
  }

  /**
   * Signalled when the previous packet has been sent.
   * @return Always returns SUCCESS.
   */
  event result_t DataMsg.uartSendDone(TOS_MsgPtr sent, result_t success) 
  {
    return SUCCESS;
  }


  /**
   * Signalled when the reset message counter AM is received.
   * @return The free TOS_MsgPtr. 
   */
  event TOS_MsgPtr ResetCounterMsg.receiveUart(TOS_MsgPtr m) 
  {
    atomic 
    {
      readingNumber = 0;
    }
    return m;
  }
  
  
  // useless implementations
  
  event result_t DataMsg.radioSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event TOS_MsgPtr DataMsg.receiveRadio(TOS_MsgPtr m)
  {
    return m;
  }
  
  event TOS_MsgPtr DataMsg.receiveUart(TOS_MsgPtr m)
  {
    return m;
  }
  
  
  event result_t ResetCounterMsg.radioSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event result_t ResetCounterMsg.uartSendDone(TOS_MsgPtr m, result_t result)
  {
    return SUCCESS;
  }
  
  event TOS_MsgPtr ResetCounterMsg.receiveRadio(TOS_MsgPtr m)
  {
    return m;
  }

  result_t newMessage() 
  {
    if((msg[currentMsg] = call DataMsg.requestWrite()) != NULL) 
    {
      
      atomic 
      {
        message = (struct CPUMsg *)msg[currentMsg]->data;
        packetReadingNumber = 0;
      }
   
      return SUCCESS;
    }
    return FAIL;
  }
}
