// $Id: IntMsg.h,v 1.3 2004/05/30 00:32:15 jpolastre Exp $

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
/* SensorMsg is the message type for SensorToRfm/RfmToSensor. */

typedef struct SensorMsg {
  uint16_t val[5];          // all of the data is stored in this 5-element array
  uint16_t next_addr;       // the hex address of the next mote for this message to be sent to
                            // (it will either be the same as dest_addr or a hop on the way to the destination)  
  uint16_t dest_addr;       // the hex address of the mote that is this message's final destination
  uint16_t src;             // the hex address of the mote that originated this message (source)  
  uint16_t hops;            // the number of hops that have occurred for the msg to get from the source mote to this mote
  uint16_t msg_type;        // denotes whether this is a wavelet message or just a sensor message
} SensorMsg;

enum {
  AM_SENSORMSG = 4
};

enum {
  WAVELET_MSG = 0x0003,
  SENSOR_MSG = 0x0004
};
