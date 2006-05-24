// $Id: IntOutput.nc,v 1.2 2003/10/07 21:46:14 idgay Exp $

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
 *
 */

/**
 * Interface to an abstract ouput mechanism for integers. Two examples
 * of providers of this interface are IntToRfm and IntToLeds.
 *
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 * @author Nelson Lee
 */

// This begins the section modified by The Moters (Fall 2005 - Spring 2006)

/**
 * This interface connects the different modules that use the SensorMsg Structure and use the routing
 * table for basic multi-hop operations.
 **/

interface SensorOutput {

  /**
   * Output the given measurements and routing info
   * @return SUCCESS if the value will be output, FAIL otherwise.
   */
  // See the SensorMsg header for an explanation of this values
  command result_t output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                          uint16_t hops, uint16_t msg_type);
  
  /**
   * Signal that the ouput operation has completed; success states
   * whether the operation was successful or not.
   * @return SUCCESS always.
   */
  event result_t outputComplete(result_t success);
}
