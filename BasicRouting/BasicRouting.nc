// $Id: RfmToLeds.nc,v 1.3 2003/10/07 21:44:59 idgay Exp $

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


// This begins the section modified by The Moters (Fall 2005 - Spring 2006)
/**
 * BasicRouting.nc
 * 
 * This application is the main configuration for our sensor network.  It can take input data from a 
 * variety of sources (Rfm, Sense, Cnt, etc), process that data using COMPASS algorithms, and send it out to 
 * several other sources (Rfm, Leds, UART, etc)
 **/



includes SensorMsg;
includes SimpleCmdMsg;

configuration BasicRouting {
}

implementation {
  components Main, BasicRoutingM, SensorToLeds, SenseToSensor, 
    TimerC, PhotoTemp, UARTComm as Comm, TransceiverC, MsgSndRcv, Voltage;
  
  Main.StdControl -> BasicRoutingM.StdControl;
  Main.StdControl -> SensorToLeds.StdControl;
  Main.StdControl -> MsgSndRcv.StdControl;
  Main.StdControl -> SenseToSensor.StdControl;
  Main.StdControl -> TransceiverC;
  Main.StdControl -> TimerC;
  
  /* For use with the light and temperature sensors */
  SenseToSensor.Timer -> TimerC.Timer[unique("Timer")];
  SenseToSensor.LightOutput -> BasicRoutingM.LightIn;  
  SenseToSensor.TempOutput -> BasicRoutingM.TempIn;  
  SenseToSensor.LightADC-> PhotoTemp.ExternalPhotoADC;
  SenseToSensor.TempADC-> PhotoTemp.ExternalTempADC;
  SenseToSensor.LightControl -> PhotoTemp.PhotoStdControl;
  SenseToSensor.TempControl -> PhotoTemp.TempStdControl; 
  
  MsgSndRcv.SensorOut -> BasicRoutingM.RadioIn;  
  
  BasicRoutingM.SensorTimer -> SenseToSensor.SensorTimer;  
  BasicRoutingM.RadioOut -> MsgSndRcv.SensorIn;
  BasicRoutingM.LedOut -> SensorToLeds.SensorOutput;
  BasicRoutingM.UARTOut -> MsgSndRcv.UARTIn;
  BasicRoutingM.Transceiver -> TransceiverC.Transceiver[AM_SIMPLECMDMSG];
  
  /* For use with the battery measurement */
  BasicRoutingM.VoltageControl->Voltage.StdControl;
  BasicRoutingM.VoltageADC->Voltage.ADC;
}