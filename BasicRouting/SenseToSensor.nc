// $Id: SenseToInt.nc,v 1.2 2003/10/07 21:46:18 idgay Exp $

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
 * This application takes data readings from the sensor (light and temperature) to store on a mote.
 **/

module SenseToSensor
{
  provides 
  {
    interface StdControl;
    interface Timer as SensorTimer;
  }
  
  uses
  {
    interface StdControl as TempControl;
    interface StdControl as LightControl;
    interface ADC as TempADC;
    interface ADC as LightADC;
    interface Timer;
    interface SensorOutput as TempOutput;
    interface SensorOutput as LightOutput;
  }
}

implementation
{
 uint16_t curr_temp;
 uint16_t curr_light;
 uint8_t lsb_data;
 uint8_t msb_data;
 uint16_t counter = 0;

 command result_t StdControl.init()
 {
  call TempControl.init();
  call LightControl.init();
  
  return SUCCESS;
 }

 command result_t StdControl.start()
 {
   // the timer will filre ever 100 ms
  call Timer.start(TIMER_REPEAT, 100);

  return SUCCESS;
 }

 command result_t StdControl.stop()
 {
   call Timer.stop();
   
   return SUCCESS;
 }

 task void tempTask()
 {
   uint16_t tCopy[5] = {0,0,0,0,0};
   tCopy[0] = curr_temp;
   call TempOutput.output(tCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG); 
 }

 task void lightTask()
 {
   uint16_t lCopy[5] = {0,0,0,0,0};
   lCopy[0] = curr_light;
   call LightOutput.output(lCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG); 
 }
 
 event result_t Timer.fired()
 {  
   // every minute we get the temperature data (one minute has passed when our 100 ms timer has fired 60 times)
   if(counter < 599)
    {
      counter = counter + 1;
    }
    else
    {
      if(TOS_LOCAL_ADDRESS != 0)
      {
        call TempADC.getData();
      }
      counter = 0;
    }
    signal SensorTimer.fired();
   
  return SUCCESS;
 }

 async event result_t TempADC.dataReady(uint16_t data)
 {
  atomic
  {
   lsb_data = (uint8_t) data;
   msb_data = (uint8_t) (data >> 8);
   curr_temp = data;
  }
  
  // we can't have the light and temperature sensors going at the same time, so once we're
  // done with temperature, start light
  call TempControl.stop();
  call LightADC.getData();
  post tempTask();
  
  return SUCCESS;
 }
 
 async event result_t LightADC.dataReady(uint16_t data)
 {
  atomic
  {
   lsb_data = (uint8_t) data;
   msb_data = (uint8_t) (data >> 8);
   curr_light = data;
  }
  call LightControl.stop();
  post lightTask();
  
  return SUCCESS;
 }

 event result_t TempOutput.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
 
 event result_t LightOutput.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
  
// Functions to deal with new Timer  
  command result_t SensorTimer.start(char type, uint32_t interval) 
  {
    return call Timer.start(type, interval);
  }
  command result_t SensorTimer.stop() {
    return call Timer.stop();
  }
 
}

 