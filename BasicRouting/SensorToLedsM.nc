// $Id: IntToLedsM.nc,v 1.2 2003/10/07 21:46:17 idgay Exp $

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
 * from the SensorMsg type to the Leds.  We use this for debugging and demos.
 **/

module SensorToLedsM {
  uses interface Leds;

  provides interface SensorOutput;
  provides interface StdControl;
}
implementation
{
  command result_t StdControl.init()
  {
    call Leds.init();
    call Leds.redOff();
    call Leds.yellowOff();
    call Leds.greenOff();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  

  task void outputDone()
  {
    signal SensorOutput.outputComplete(1);
  }

  
  command result_t SensorOutput.output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                          uint16_t hops, uint16_t msg_type)
  {
    // The red LED is for the least significant bit, and the yellow LED is for the most significant bit
    
    uint16_t intVal = measurements[0];
    if (intVal & 1) 
      call Leds.redOn();
    else 
      call Leds.redOff();
    
    if (intVal & 2) 
      call Leds.greenOn();
    else 
      call Leds.greenOff();
    
    if (intVal & 4) 
      call Leds.yellowOn();
    else 
      call Leds.yellowOff();
    
    post outputDone();

    return SUCCESS;
  }
}

