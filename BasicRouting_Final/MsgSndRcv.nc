// $Id: IntToRfm.nc,v 1.2 2003/10/07 21:46:18 idgay Exp $

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
 * This application sends data from the SensorMsg type to the Rfm Output Stack or the UART port, using the
 * Transceiver code.  It also receives messages from the Rfm Input Stack.  It may be used for single or 
 * mulit-hop communications.
 **/

includes CPUMsg;
includes SensorMsg;

configuration MsgSndRcv
{
  provides 
  {
    interface SensorOutput as SensorIn;
    interface SensorOutput as UARTIn;
    interface StdControl;
  }
  uses
  {
    interface SensorOutput as SensorOut;
  }
}
implementation
{
  components SensorToUARTM, SensorToRfmM, RfmToSensorM, TransceiverC;

  UARTIn = SensorToUARTM;
  StdControl = SensorToUARTM;
  
  SensorIn = SensorToRfmM;
  SensorOut = RfmToSensorM;
  
  SensorToUARTM.SubControl->SensorToRfmM.StdControl;
  SensorToUARTM.SubControl-> RfmToSensorM.StdControl;
  SensorToUARTM.SubControl -> TransceiverC;
  SensorToUARTM.ResetCounterMsg -> TransceiverC.Transceiver[AM_CPURESETMSG];
  SensorToUARTM.DataMsg -> TransceiverC.Transceiver[AM_CPUMSG];
  
  SensorToRfmM.Send -> TransceiverC.Transceiver[AM_SENSORMSG];
  RfmToSensorM.ReceiveSensorMsg -> TransceiverC.Transceiver[AM_SENSORMSG];  
}

