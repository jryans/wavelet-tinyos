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
 * This application is the main module for our sensor network.  It will implement the features 
 * that the configuration should perform.  It will be able to take input data from a variety of 
 * sources (Rfm, Sense, Cnt, etc), process that data using COMPASS algorithms, and send it out to 
 * several other sources (Rfm, Leds, UART, etc)
 **/


includes SensorMsg;

module BasicRoutingM 
{
  uses {
    interface SensorOutput as RadioOut;
    interface SensorOutput as LedOut;
    interface SensorOutput as UARTOut;
    interface Transceiver;
    interface Timer as SensorTimer;
    
    interface StdControl as VoltageControl;
    interface ADC as VoltageADC;
  }
  
  provides {
    interface SensorOutput as RadioIn;
    interface SensorOutput as TempIn;     
    interface SensorOutput as LightIn;
    interface ProcessCmd;
    interface StdControl;
  }
}


implementation
{  
  /* The routing table for our 20-node network (21 nodes including the base node #0).  There is one row in the table for each node in the
   * network, and the columns give the node ID of the node that this row's node will need to route through in order to get to this column's 
   * node (gives us next_addr).
   */
  uint16_t routing_table[21][21] = {{-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},{0,-1,2,3,4,4,4,4,8,8,8,8,8,8,4,4,4,4,4,4,4},
    {1,1,-1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},{2,2,2,-1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},{1,1,1,1,-1,5,6,6,1,1,1,1,1,1,6,6,6,6,6,6,6},
    {1,1,1,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},{4,4,4,4,4,4,-1,7,4,4,4,4,4,4,7,7,7,7,7,7,7},{6,6,6,6,6,6,6,-1,6,6,6,6,6,6,14,14,14,14,14,14,14},
    {1,1,1,1,1,1,1,1,-1,9,9,9,9,9,1,1,1,1,1,1,1},{8,8,8,8,8,8,8,8,8,-1,10,11,11,11,8,8,8,8,8,8,8},{9,9,9,9,9,9,9,9,9,9,-1,9,9,9,9,9,9,9,9,9,9},
    {8,8,8,8,8,8,8,8,8,8,8,-1,12,12,8,8,8,8,8,8,8},{11,11,11,11,11,11,11,11,11,11,11,11,-1,13,11,11,11,11,11,11,11},
    {12,12,12,12,12,12,12,12,12,12,12,12,12,-1,12,12,12,12,12,12,12},{7,7,7,7,7,7,7,7,7,7,7,7,7,7,-1,15,15,15,15,15,15},
    {14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,-1,16,16,16,16,16}, {15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,-1,17,17,17,17},
    {16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,-1,18,18,18}, {17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,-1,19,19},
    {18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,-1,20}, {19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,-1}};

  // The routing table for our 13-node network
//  uint16_t routing_table[14][14] = {{-1,1,1,1,1,1,1,1,1,1,1,1,1,1},{0,-1,2,3,4,4,4,4,8,8,8,8,8,8},
//    {1,1,-1,3,1,1,1,1,1,1,1,1,1,1},{2,2,2,-1,2,2,2,2,2,2,2,2,2,2},{1,1,1,1,-1,5,6,6,1,1,1,1,1,1},
//    {1,1,1,1,1,-1,1,1,1,1,1,1,1,1},{4,4,4,4,4,4,-1,7,4,4,4,4,4,4},{6,6,6,6,6,6,6,-1,6,6,6,6,6,6},{1,1,1,1,1,1,1,1,-1,9,9,9,9,9},
//    {8,8,8,8,8,8,8,8,8,-1,10,11,11,11},{9,9,9,9,9,9,9,9,9,9,-1,9,9,9},{8,8,8,8,8,8,8,8,8,8,8,-1,12,12},{11,11,11,11,11,11,11,11,11,11,11,11,-1,13},
//    {12,12,12,12,12,12,12,12,12,12,12,12,12,-1}};

  
  
  
 /* Table of information needed for wavelet transform:
  * 0 - neighbor, 1 - light value, 2 - temp value, 3 - whether or not value received (stored later)
  * number of neighbors for each level is stored in (0,0)
  * 
  * The coeff tables store the coefficient corresponding to each neighbor and to each level in the wavelet transform.
  * These tables are indexed in the same way that the tables before them are (ie, the number of neighbors for each level is stored in (0), the coefficient
  * for the neighbor stored in index 1 of the table is in index 1 of the coefficient table.
  * 
  * Note: These tables are generated by Ray's matlab code and our generation script.
  * Note: Due to memory limitations on the mote, only 5 of these tables can be active at a time (ie, comment the rest out and compile / install on the 
  * motes in shifts).  You will also have to make sure that the corresponding case statements in the assignTable() function are uncommented as well.
  * It would be good to eventually be able to load these tables dynamically (ie, send a mote its table so it only needs to store one).
  * Note: You may have to change the dimension of these tables if you have any more than 3 levels of the wavelet transform or
  * 6 neighbors for any node.  (In the case of adding more neighbors, also change this in the transceiver header file so that we can send more messages.)
  */
  
uint16_t node1[3][7][4] = {{{2,0,0,0},{2,0,0,0},{4,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{2,0,0,0},{3,0,0,0},{6,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{2,0,0,0},{7,0,0,0},{14,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node1_coeff[3][7] = {{2.000000,0.263233,0.263233,0,0,0,0},{2.000000,0.134821,0.231490,0,0,0,0},{2.000000,0.217727,0.154422,0,0,0,0}};

uint16_t node2[3][7][4] = {{{3,0,0,0},{1,0,0,0},{3,0,0,0},{5,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node2_coeff[3][7] = {{3.000000,0.603053,0.450382,-0.053435,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node3[3][7][4] = {{{2,0,0,0},{2,0,0,0},{4,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{6,0,0,0},{1,0,0,0},{5,0,0,0},{9,0,0,0},{7,0,0,0},{12,0,0,0},{14,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node3_coeff[3][7] = {{2.000000,0.150379,0.150379,0,0,0,0},{6.000000,0.512644,0.525789,0.429041,0.019486,-0.205010,-0.281950},{0,0,0,0,0,0,0}};

uint16_t node4[3][7][4] = {{{3,0,0,0},{1,0,0,0},{5,0,0,0},{3,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node4_coeff[3][7] = {{3.000000,0.824427,0.239186,-0.063613,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node5[3][7][4] = {{{2,0,0,0},{2,0,0,0},{4,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{2,0,0,0},{3,0,0,0},{15,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node5_coeff[3][7] = {{2.000000,0.128581,0.128581,0,0,0,0},{2.000000,0.079716,0.123437,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node6[3][7][4] = {{{1,0,0,0},{8,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{9,0,0,0},{7,0,0,0},{1,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node6_coeff[3][7] = {{1.000000,0.299694,0,0,0,0,0},{3.000000,0.451420,0.448430,0.100149,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node7[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{5,0,0,0},{3,0,0,0},{6,0,0,0},{11,0,0,0},{13,0,0,0},{15,0,0,0},{0,0,0,0}},{{3,0,0,0},{12,0,0,0},{1,0,0,0},{16,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node7_coeff[3][7] = {{0,0,0,0,0,0,0},{5.000000,0.067644,0.116146,0.086561,0.186736,0.104744,0},{3.000000,0.369400,0.425588,0.205011,0,0,0}};

uint16_t node8[3][7][4] = {{{3,0,0,0},{6,0,0,0},{9,0,0,0},{11,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node8_coeff[3][7] = {{3.000000,0.684211,0.383459,-0.067669,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node9[3][7][4] = {{{1,0,0,0},{8,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{3,0,0,0},{6,0,0,0},{11,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node9_coeff[3][7] = {{1.000000,0.246177,0,0,0,0,0},{3.000000,0.131286,0.225421,0.168003,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node10[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node10_coeff[3][7] = {{0,0,0,0,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node11[3][7][4] = {{{1,0,0,0},{8,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{12,0,0,0},{9,0,0,0},{7,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node11_coeff[3][7] = {{1.000000,0.165902,0,0,0,0,0},{3.000000,0.650730,0.516600,-0.167331,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node12[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{4,0,0,0},{3,0,0,0},{11,0,0,0},{13,0,0,0},{15,0,0,0},{0,0,0,0},{0,0,0,0}},{{2,0,0,0},{7,0,0,0},{14,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node12_coeff[3][7] = {{0,0,0,0,0,0,0},{4.000000,0.088827,0.113670,0.245216,0.137546,0,0},{2.000000,0.156082,0.110701,0,0,0,0}};

uint16_t node13[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{12,0,0,0},{7,0,0,0},{14,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node13_coeff[3][7] = {{0,0,0,0,0,0,0},{3.000000,0.695652,-0.090737,0.395085,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node14[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{3,0,0,0},{13,0,0,0},{15,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{3,0,0,0},{16,0,0,0},{12,0,0,0},{1,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node14_coeff[3][7] = {{0,0,0,0,0,0,0},{3.000000,0.047976,0.132442,0.074289,0,0,0},{3.000000,0.571754,0.220957,0.207289,0,0,0}};

uint16_t node15[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{6,0,0,0},{14,0,0,0},{16,0,0,0},{7,0,0,0},{18,0,0,0},{12,0,0,0},{5,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node15_coeff[3][7] = {{0,0,0,0,0,0,0},{6.000000,0.172736,0.224356,0.123726,0.277867,0.160834,0.040482},{0,0,0,0,0,0,0}};

uint16_t node16[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{1,0,0,0},{15,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{2,0,0,0},{7,0,0,0},{14,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node16_coeff[3][7] = {{0,0,0,0,0,0,0},{1.000000,0.077290,0,0,0,0,0},{2.000000,0.114427,0.081157,0,0,0,0}};

uint16_t node17[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node17_coeff[3][7] = {{0,0,0,0,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node18[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{1,0,0,0},{15,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node18_coeff[3][7] = {{0,0,0,0,0,0,0},{1.000000,0.080668,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node19[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node19_coeff[3][7] = {{0,0,0,0,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};

uint16_t node20[3][7][4] = {{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}; 
double node20_coeff[3][7] = {{0,0,0,0,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}};
  

// this table tells the level that each mote is predicted in (level 1 happens first, then level 2, etc);
// the motes with a high # (ie, 100) are never predicted; they are terminal scaling nodes
// use Ray's matlab program that generates the wavelet information to get these values
  uint16_t wav_dec[21] = {0,100,1,2,1,100,2,3,1,100,100,2,100,2,3,2,100,100,100,100,100};
  
// stores the current wavelet value for each node for both light and temperature;
// defaults to the node ID but is eventually replaced by the light and temperature measurements
  double wav_val[21][2] = {{0,0},{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{9,9},{10,10},{11,11},{12,12},{13,13},{14,14},{15,15},{16,16},{17,17}, {18,18}, {19,19}, {20,20}};

// this table stores the information for the current node (for each level, stores neighbors, light and temperature
// values, and data received flag); we copy the above table corresponding to the current node and save it in local_table  
  uint16_t local_table[3][7][4];
// this table stores the coefficient information for the current node (for each level and neighbor, stores
// the coefficient needed for the wavelet transform); we copy the above table corresponding to the current node and save it in local_table  
  double local_table_coeff[3][7]; 
  
  // the current wavelet level - always starts at one
  uint8_t wavelet_level = 1;
  // the maximum wavelet level - change this depending on what Ray's matlab program returns
  uint8_t max_wavelet_level = 3;

  // module scoped variables
  TOS_MsgPtr tosPtr;
  SimpleCmdMsg *cmdMsg;
 
// We have to send messages with delays in order to reduce collisions and increase communication reliability ....
// These MessagesPending arrays store information about the messages we still need to send
// 0- Message Still to be Sent (1, anything else means garbage), 1 - Delay, 2 - Source, 3 - Next Address,
// 4 - Destination Address, 5 - Hops, 6 - MsgType
  uint16_t MessagesPending[20][7];  
  uint16_t MessagesPendingData[20][5];
  
  // used during flooding so that we don't keep sending the same messages - stores most recently sent messages at the beginning
  uint16_t MsgsAlreadySent[5] = {0, 0, 0, 0, 0};    
  uint16_t MsgsAlreadySentLength = 5;
  
  // We count how many times the timer has fired (set to fire every 100ms); this lets us take measurements and perform the
  // wavelet transform on arbitrary intervals of several seconds or minutes
  uint16_t CounterTilNextWavelet = 0;
  
  // storing the current values for the light, temperature, and battery measurement readings
  uint16_t CurrentLightVal = 0;
  uint16_t CurrentTempVal = 1;
  uint16_t curr_volt;  
  uint16_t SnapshotLightVal = 0;
  uint16_t SnapshotTempVal = 0;
 
  
 // Function Prototypes - like in C!
  void assignWavTable();
  void arrayAssign(uint16_t assignFrom[3][7][4], uint16_t assignTo[3][7][4]);
  void arrayAssignDouble(double assignFrom[3][7], double assignTo[3][7]);
  result_t newMessage();
  void startWaveletLevel();
  uint8_t hasReceivedAllValues();  
  void addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1);
  void delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type);
  void calculateCoefficient(uint16_t numNeighbors, uint16_t addVal);
  void clearTable(uint16_t numNeighbors);  
  task void voltTask();
  
/*********************************************************************
 * Code for broadcasting commands to all of the motes and for
 * processing the command.
 *********************************************************************/
  event result_t SensorTimer.fired() 
  {
    // Every time the timer fires, look at the messages that are still waiting to be sent and see if any of them
    // have their delay up.  If so, we sned them.
    uint16_t LCV = 0; 
    for (LCV; LCV < 20; LCV++)
    {
      if (MessagesPending[LCV][0] == 1)    // this message still needs to be sent
      {
        MessagesPending[LCV][1] = MessagesPending[LCV][1] - 1;   // subtract one from the delay value its storing
        if(MessagesPending[LCV][1] == 0)   // now send message because the delay is up
        {
          uint16_t display_array[5];
          display_array[0] = MessagesPendingData[LCV][0];
          display_array[1] = MessagesPendingData[LCV][1];          
          display_array[2] = MessagesPendingData[LCV][2];          
          display_array[3] = MessagesPendingData[LCV][3];
          display_array[4] = MessagesPendingData[LCV][4];         
          call RadioOut.output(display_array, MessagesPending[LCV][2], MessagesPending[LCV][3], MessagesPending[LCV][4], MessagesPending[LCV][5], MessagesPending[LCV][6]);
          MessagesPending[LCV][0] = 0;     // don't need to send this message anymore
        }   
      }      
    }
    
    if(TOS_LOCAL_ADDRESS == 0)    // only if this is the base node
    {
      if(CounterTilNextWavelet < 1499)
      {
        CounterTilNextWavelet = CounterTilNextWavelet + 1;
      }
      else if(CounterTilNextWavelet == 1499) // After the timer has fired 1500 times (ie, after 2.5 minutes have passed), start wavelet transform
      {
        CounterTilNextWavelet = CounterTilNextWavelet + 1;
        // equivalent of sending a command
        if(newMessage()) {
          // This AM type has a message allocated and initialized          
          uint16_t LCV = MsgsAlreadySentLength - 1;
          for(LCV; LCV > 0; LCV--)
            // move the first 4 elements in the array to the right one spot (so that the most recently sent messages are stored at the beginning)
            MsgsAlreadySent[LCV] = MsgsAlreadySent[LCV-1];
          
          MsgsAlreadySent[0] = MsgsAlreadySent[0] + 1;
          cmdMsg->seqno = MsgsAlreadySent[0];
          cmdMsg->action = 0x0004;   // we call the 4th command (called "Green-Off" but is our wavelet command case)
          call Transceiver.sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg));   // broadcast this command to everyone
        }        
      }
      else 
      if(CounterTilNextWavelet < 2999)
      {
        CounterTilNextWavelet = CounterTilNextWavelet + 1;
      }
      else    // After the timeer has fired 3000 times (ie, after 5 minutes have passed), have nodes report values
      {
        CounterTilNextWavelet = 0;
        // equivalent of sending a command
        if(newMessage()) {
          // This AM type has a message allocated and initialized          
          uint16_t LCV = MsgsAlreadySentLength - 1;
          for(LCV; LCV > 0; LCV--)
            // move the first 4 elements in the array to the right one spot (so that the most recently sent messages are stored at the beginning)
            MsgsAlreadySent[LCV] = MsgsAlreadySent[LCV-1];
          
          MsgsAlreadySent[0] = MsgsAlreadySent[0] + 1;
          cmdMsg->seqno = MsgsAlreadySent[0];
          cmdMsg->action = 0x0003;   // we call the 3rd command (called "Green-On" but is our wavelet command case)
          call Transceiver.sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg));        // broadcast this command to everyone    
        }
      }
    }
    return SUCCESS;
  }
  
/*
 * This function executes a command that has been called.
 * We use this to execute commands to perform the wavelet transform and to have the motes
 * report their wavelet and raw measurement values.
 */
  command result_t ProcessCmd.execute(TOS_MsgPtr pmsg) 
  {
    uint16_t led_display[5] = {0,0,0,0,0};
    uint16_t next_addr = 0;
    uint16_t dest_addr = 0;
    
    struct SimpleCmdMsg * cmd = (struct SimpleCmdMsg *) pmsg->data;

    // do local packet modifications: update the hop count and packet source
    cmd->hop_count++;
    cmd->source = TOS_LOCAL_ADDRESS;
    
    // Execute the command
    switch (cmd->action) 
    {
      case YELLOW_LED_ON:   // actually does turn the yellow LED on
        led_display[0] = 4;
        call LedOut.output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
        break;
        
      case YELLOW_LED_OFF:  // actually does turn the yellow LED off
        led_display[0] = 0;
        call LedOut.output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
        break;
        
      case GREEN_LED_ON:     // This command takes battery or light and temperature measurements
        // Uncommenting these lines will circumvent the wavelet transform and cause the current light
        // and temperature values to be reported.
//        wav_val[TOS_LOCAL_ADDRESS][0] = CurrentLightVal;
//        wav_val[TOS_LOCAL_ADDRESS][1] = CurrentTempVal;
//        SnapshotLightVal = CurrentLightVal;
//        SnapshotTempVal = CurrentTempVal;
        // Right now we're measuring and reporting battery voltage.
        call VoltageControl.start();
        call VoltageADC.getData();
        
//        dest_addr = 0x0000;  
//        next_addr = routing_table[TOS_LOCAL_ADDRESS][dest_addr];        
//        led_display[0] = wav_val[TOS_LOCAL_ADDRESS][0]; 
//        led_display[1] = wav_val[TOS_LOCAL_ADDRESS][1]; 
//        led_display[2] = SnapshotLightVal;
//        led_display[3] = SnapshotTempVal;              
//        delaySendMessage(led_display, TOS_LOCAL_ADDRESS, next_addr, dest_addr, 0, SENSOR_MSG);
//        call LedOut.output(led_display, TOS_LOCAL_ADDRESS, next_addr, dest_addr, 0, SENSOR_MSG);
        break;
        
      case GREEN_LED_OFF:   // this is actually our wavelet command case       
        wavelet_level = 1;
        // When the first 4 lines are uncommented, we take 10 and 5 times TOS_LOCAL_ADDRESS to be the measurements
        // When the last 4 lines are uncommented, we assign the sensor readings to both wav_val and Snapshot
        // After the trasnform, wav_val has changed to reflect the wavelet values, but Snapshot still contains the raw values
        
//        wav_val[TOS_LOCAL_ADDRESS][0] = TOS_LOCAL_ADDRESS*10; //TODO - change so that this value is set to currentSensorVal
//        wav_val[TOS_LOCAL_ADDRESS][1] = TOS_LOCAL_ADDRESS*5; //TODO - change so that this value is set to currentSensorVal
//        SnapshotLightVal = TOS_LOCAL_ADDRESS*10; //TODO - change so that this value is set to currentSensorVal
//        SnapshotTempVal = TOS_LOCAL_ADDRESS*5; //TODO - change so that this value is set to currentSensorVal
        wav_val[TOS_LOCAL_ADDRESS][0] = CurrentLightVal;
        wav_val[TOS_LOCAL_ADDRESS][1] = CurrentTempVal;
        SnapshotLightVal = CurrentLightVal;
        SnapshotTempVal = CurrentTempVal;
        startWaveletLevel();    // start the wavelet transform
        break;
        
      case WAVELET:     // something weird in this case - don't put other code to be executed in this command
        break;     
    }
    
    signal ProcessCmd.done(pmsg, SUCCESS);    
    return SUCCESS;
  }
  
  
  /** 
   * Called upon completion of command execution.
   * @return Always returns <code>SUCCESS</code>
   **/
  default event result_t ProcessCmd.done(TOS_MsgPtr pmsg, result_t status) 
  {
    return status;
  } 
  
 
  
/*********************************************************************
 * Code for transmitting from the sensor and radio-in to the LEDS and radio-out
 *********************************************************************/  
  /**
   * Function for getting the battery voltage values
   */
  async event result_t VoltageADC.dataReady(uint16_t data)
 {
  atomic
  {
   curr_volt = data;
  }
  call VoltageControl.stop();
  post voltTask();
  
  return SUCCESS;
 }
  
  
  /**
   * This is the key function for the wavelet transform.  This function is called whenever a message is received
   * from the radio, transmitted from another node.  Different actions are performed depending on whether this is a
   * sensor or wavelet message, the final destination node or a hop, the base node or another node, etc.
   */
  command result_t RadioIn.output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type)
  {
    uint16_t display_array[5] = {0,0,0,0,0};
    uint8_t LCV = 0;
    uint16_t numNeighbors = 0;
    
    if(dest_addr == TOS_LOCAL_ADDRESS)  // we are at the final destination
    {
      if(msg_type == SENSOR_MSG) // sensor message
      {
        // a sensor message at the base node means we should send it across the UART to display on the computer
        call UARTOut.output(measurements, source, next_addr, dest_addr, hops, msg_type);  
        call LedOut.output(measurements, source, next_addr, dest_addr, hops,msg_type);
      }
      else     // wavelet message
      {
        if(hops == wavelet_level)   // for wavelet messages, hops stores the wavelet level that this message if for
        {
          if(wav_dec[TOS_LOCAL_ADDRESS] == wavelet_level)    // decimation (prediction) is occurring now
          { 
            // add the light and temperature values stored in this message to this node's table
            addWaveletValueToTable(hops, source, measurements[0], measurements[1]);
            
            if(hasReceivedAllValues() == 1)   // has received all of the scaling values
            {
              numNeighbors = local_table[wavelet_level-1][0][0];
              calculateCoefficient(numNeighbors, 0);   // calculate the new predict value
              clearTable(numNeighbors);
              
             LCV = 0;
              for(LCV; LCV < numNeighbors; LCV++)    // send back the update values to this node's neighbors
              {
                uint16_t neighbor = local_table[wavelet_level-1][LCV+1][0];
                display_array[0] = wav_val[TOS_LOCAL_ADDRESS][0];
                display_array[1] = wav_val[TOS_LOCAL_ADDRESS][1];
                delaySendMessage(display_array, TOS_LOCAL_ADDRESS, routing_table[TOS_LOCAL_ADDRESS][neighbor], neighbor, wavelet_level, WAVELET_MSG);
              }                      
            }
            else  // waiting to receive the rest of the scaling values
            {
            } 
          }
          
          else   // wavelet message, scaling node - getting back updated coefficient
          {
            // add the light and temperature values stored in this message to this node's table
            addWaveletValueToTable(hops, source, measurements[0], measurements[1]);
            
            if(hasReceivedAllValues() == 1)   // has received all of the scaling values
            {
              numNeighbors = local_table[wavelet_level-1][0][0];              
              calculateCoefficient(numNeighbors, 1);   // calculate the new update value
              clearTable(numNeighbors);
              
              // begin next level
              if(wavelet_level < max_wavelet_level)
              {
                wavelet_level = wavelet_level + 1;
                startWaveletLevel();
              }
            }
            else  // waiting to receive the rest of the scaling values
            {
            } 
            
            display_array[0] = wav_val[TOS_LOCAL_ADDRESS][0];
            display_array[1] = wav_val[TOS_LOCAL_ADDRESS][1];         
          }
        }
        else  // this value is for a different wavelet level than the one we're currently on
        {
            addWaveletValueToTable(hops, source, measurements[0], measurements[1]);
            display_array[0] = 7;    // for debugging
            call LedOut.output(display_array, TOS_LOCAL_ADDRESS, 0, 0, 0, msg_type); 
        }
      }
    }
    else   // this is just a hop on the route - continue passing message to the destination
    {
      next_addr = routing_table[TOS_LOCAL_ADDRESS][dest_addr];
      delaySendMessage(measurements, source, next_addr, dest_addr, hops, msg_type);  
    }           
  }
  
  
  command result_t LightIn.output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type)
  {
    CurrentLightVal = measurements[0];

    return SUCCESS;
  }

    command result_t TempIn.output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type)
  {
    CurrentTempVal = measurements[0];

    return SUCCESS;
  }

  
  command result_t StdControl.init() 
  {
    assignWavTable();
    call VoltageControl.init();
    return SUCCESS;
  }
  
  command result_t StdControl.start() 
  {
    return SUCCESS;
  }
  
  command result_t StdControl.stop() 
  {
    call VoltageControl.stop();
    return SUCCESS;
  }
  
  event result_t RadioOut.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
  
  event result_t LedOut.outputComplete(result_t success) 
  {
    return SUCCESS;
  }
  
  event result_t UARTOut.outputComplete(result_t success) 
  {
    return SUCCESS;
  }  
  
  
  
/*********************************************************************
 * Transceiver!!
 *********************************************************************/    
  
  /**
   * A message was sent over radio.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t Transceiver.radioSendDone(TOS_MsgPtr m, result_t result)
  {
        return SUCCESS;  
  }
  
  /**
   * A message was sent over UART.
   * @param m - a pointer to the sent message, valid for the duration of the 
   *     event.
   * @param result - SUCCESS or FAIL.
   */
  event result_t Transceiver.uartSendDone(TOS_MsgPtr m, result_t result)
  {
        return SUCCESS; 
  }
  
  /**
   * Received a message over the radio
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr Transceiver.receiveRadio(TOS_MsgPtr m)
  {
    uint16_t led_display_cmd[5] = {0, 0, 0, 0, 0};
    
    // Flooding this message to the other nodes
    SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *) m->data;
    uint16_t alreadySent = 0;
    uint16_t LCV = 0;
    uint16_t msgID = cmdMsgFrom->seqno;
    
    if(!(TOS_LOCAL_ADDRESS == 0))
    {       
      for(LCV; LCV < MsgsAlreadySentLength; LCV++)
      {
        if(MsgsAlreadySent[LCV] == msgID)
          alreadySent = 1;
      }
      
      if(alreadySent == 0)   // hasn't already been seen / sent
      {
        // since we're sending this message now, need to add it to the array of messages sent
        LCV = MsgsAlreadySentLength - 1;
        for(LCV; LCV > 0; LCV--)
          // move the first 4 elements in the array to the right one spot (so that the most recently sent messages are stored at the beginning)
          MsgsAlreadySent[LCV] = MsgsAlreadySent[LCV-1];
        MsgsAlreadySent[0] = msgID;
        
        // now send this message:
        if(newMessage()) {
          // This AM type has a message allocated and initialized
          SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *) m->data;
          cmdMsg->seqno = cmdMsgFrom->seqno;
          cmdMsg->action = cmdMsgFrom->action;
          cmdMsg->source = cmdMsgFrom->source;
          cmdMsg->hop_count = cmdMsgFrom->hop_count;
          cmdMsg->args = cmdMsgFrom->args;
          
          call Transceiver.sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg));
        }
      
        call ProcessCmd.execute(m);        
      }
    }
      return m;
    }
  
  
  /**
   * Received a message over UART
   * @param m - the receive message, valid for the duration of the 
   *     event.
   */
  event TOS_MsgPtr Transceiver.receiveUart(TOS_MsgPtr m)
  {
    if(newMessage()) {
      // This AM type has a message allocated and initialized
      SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *) m->data;
      cmdMsg->seqno = cmdMsgFrom->seqno;
      cmdMsg->action = cmdMsgFrom->action;
      cmdMsg->source = cmdMsgFrom->source;
      cmdMsg->hop_count = cmdMsgFrom->hop_count;
      cmdMsg->args = cmdMsgFrom->args;
                  
      call Transceiver.sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg));
    }
    
    return m;
  }
  
  
/*********************************************************************
 * Helper Functions!!
 *********************************************************************/  
  
  /*
   * Used with tranceiver functions.
   * Allocates space for a new SimpleCmdMsg.
   */
  result_t newMessage() {
    if((tosPtr = call Transceiver.requestWrite()) != NULL) 
    {
      cmdMsg = (SimpleCmdMsg *) (tosPtr->data);      
      return SUCCESS;
    }
    return FAIL;
  }
  
  
  /*
   * Copy over each element into the assignFrom array, and store it in the assignTo array.
   * Used to populate local_table.
   * Note: you will need to change the dimensions of these arrays of the number of levels
   * or maximum number of neighbors changes in the node tables.
   */
  void arrayAssign(uint16_t assignFrom[3][7][4], uint16_t assignTo[3][7][4])
  {
    uint16_t r, c, level;
    
    for(level = 0; level < 3; level++)
    {
      for(r = 0; r < 7; r++)
      {
        for(c = 0; c < 4; c++)
        {
          assignTo[level][r][c] = assignFrom[level][r][c];
        }
      } 
    }
  }  
 
  
  /*
   * Copy over each element into the assignFrom array, and store it in the assignTo array.
   * Used to populate local_table_coeffs.
   * Note: you will need to change the dimensions of these arrays of the number of levels
   * or maximum number of neighbors changes in the node tables.
   */
  void arrayAssignDouble(double assignFrom[3][7], double assignTo[3][7])
  {
    uint16_t r, level;
    
    for(level = 0; level < 3; level++)
    {
      for(r = 0; r < 7; r++)
      {
          assignTo[level][r] = assignFrom[level][r];
      } 
    }
  }   
  

  /**
   * Used with the battery voltage measurements.
   * We return the wavelet light and temp values, as well as the voltage value.
   */
  task void voltTask()
 {
   uint16_t display_array[5] = {0,0,0,0,0};
   uint16_t dest_addr = 0x0000;   //hardcoded for 5 node network
   uint16_t next_addr = routing_table[TOS_LOCAL_ADDRESS][dest_addr];
   
   display_array[0] = wav_val[TOS_LOCAL_ADDRESS][0]; 
   display_array[1] = wav_val[TOS_LOCAL_ADDRESS][1];
   display_array[2] = curr_volt;
   
   delaySendMessage(display_array, TOS_LOCAL_ADDRESS, next_addr, dest_addr, 0, SENSOR_MSG);
 }
  
  
  /*
   * Assign the local_table global variable to contain the information stored in the table
   * of this particular node.
   * Note: Due to memory limitations on the mote, only 5 of these tables can be active at a time (ie, comment the rest out and compile / install on the 
   * motes in shifts).  You will also have to make sure that the corresponding table declarations at the top of this file uncommented as well.
   * It would be good to eventually be able to load these tables dynamically (ie, send a mote its table so it only needs to store one).
   */
  void assignWavTable()
  {
    switch(TOS_LOCAL_ADDRESS){
      
      case 1:
        arrayAssign(node1, local_table);
        arrayAssignDouble(node1_coeff, local_table_coeff);
        break;
        
      case 2:
        arrayAssign(node2, local_table);
        arrayAssignDouble(node2_coeff, local_table_coeff);
        break;
        
      case 3:
        arrayAssign(node3, local_table);
        arrayAssignDouble(node3_coeff, local_table_coeff);
        break;
        
      case 4:
        arrayAssign(node4, local_table);
        arrayAssignDouble(node4_coeff, local_table_coeff);
        break;
        
      case 5:
        arrayAssign(node5, local_table);
        arrayAssignDouble(node5_coeff, local_table_coeff);
        break;
        
      case 6:
        arrayAssign(node6, local_table);
        arrayAssignDouble(node6_coeff, local_table_coeff);
        break;
        
      case 7:
        arrayAssign(node7, local_table);
        arrayAssignDouble(node7_coeff, local_table_coeff);
        break;
        
      case 8:
        arrayAssign(node8, local_table);
        arrayAssignDouble(node8_coeff, local_table_coeff);
        break;  
        
      case 9:
        arrayAssign(node9, local_table);
        arrayAssignDouble(node9_coeff, local_table_coeff);
        break;          
        
      case 10:
        arrayAssign(node10, local_table);
        arrayAssignDouble(node10_coeff, local_table_coeff);
        break;  
        
      case 11:
        arrayAssign(node11, local_table);
        arrayAssignDouble(node11_coeff, local_table_coeff);
        break;  
        
      case 12:
        arrayAssign(node12, local_table);
        arrayAssignDouble(node12_coeff, local_table_coeff);
        break;         
        
      case 13:
        arrayAssign(node13, local_table);
        arrayAssignDouble(node13_coeff, local_table_coeff);
        break;          
        
      case 14:
        arrayAssign(node14, local_table);
        arrayAssignDouble(node14_coeff, local_table_coeff);
        break;          
        
      case 15:
        arrayAssign(node15, local_table);
        arrayAssignDouble(node15_coeff, local_table_coeff);
        break;          
        
      case 16:
        arrayAssign(node16, local_table);
        arrayAssignDouble(node16_coeff, local_table_coeff);
        break;          
        
      case 17:
        arrayAssign(node17, local_table);
        arrayAssignDouble(node17_coeff, local_table_coeff);
        break;          
        
      case 18:
        arrayAssign(node18, local_table);
        arrayAssignDouble(node18_coeff, local_table_coeff);
        break;          
        
      case 19:
        arrayAssign(node19, local_table);
        arrayAssignDouble(node19_coeff, local_table_coeff);
        break;          
        
      case 20:
        arrayAssign(node20, local_table);
        arrayAssignDouble(node20_coeff, local_table_coeff);
        break;          

      default:
        break;
    }    
  }
  

 /*
  * Starts one level of the wavelet transform.
  * If the node is a scaling node at this level, it will send the scaling values to its neighbors.
  */
  void startWaveletLevel()
  {
    uint16_t led_display[5] = {0,0,0,0,0};
    uint16_t numNeighbors;
    uint16_t LCV;
    
    if(wav_dec[TOS_LOCAL_ADDRESS] > wavelet_level) //ie we are a scaling node at the current level
    {        
      numNeighbors = local_table[wavelet_level-1][0][0];
      led_display[0] = wav_val[TOS_LOCAL_ADDRESS][0];
      led_display[1] = wav_val[TOS_LOCAL_ADDRESS][1];
      LCV = 0;
      
      for(LCV; LCV < numNeighbors; LCV++)    // send scaling values to this node's neighbors
      {
        uint16_t neighbor = local_table[wavelet_level-1][LCV+1][0]; 
        delaySendMessage(led_display, TOS_LOCAL_ADDRESS, routing_table[TOS_LOCAL_ADDRESS][neighbor], neighbor, wavelet_level, WAVELET_MSG);
      }
      
      // as long as we're not the base node and we're not yet at the maximum wavelet level, increment the wavelet level by one
      if(numNeighbors == 0)
      {
        if(wavelet_level < max_wavelet_level)
        {
          wavelet_level = wavelet_level + 1;
          startWaveletLevel();
        } 
      }
        
      call LedOut.output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
    }   
  }
 
  
 /*
  * Determines whether or not the node has received values back from all of its neighbors on this
  * level of the wavelent transform.  Returns true if it has received all the values.
  */
  uint8_t hasReceivedAllValues()
  {
    uint8_t LCV = 0;
    uint8_t noEmptySpotsFlag = 1;
    
    for(LCV; LCV < local_table[wavelet_level - 1][0][0]; LCV++)
    {
      // loop through the values stored in the local table; if any of them haven't been received yet
      // (indicated by element 3 in the array - stores the flag), then set noEmptySpotsFlag to false
      if(local_table[wavelet_level - 1][LCV+1][3] == 0)
        noEmptySpotsFlag = 0;      
    }
    return noEmptySpotsFlag;
  }
  
  
  /*
   * When a wavelet value is received, find the element in the local table corresponding to this
   * neighbor (source).  Then set element #2 to this wavelet value, and element #3 to 1 for received.
   */
  void addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1)    
  {
    uint16_t lcv = 0;
    for (lcv; lcv < local_table[hops-1][0][0]; lcv++)
    {
      if(local_table[hops-1][lcv+1][0] == source)
      {
        local_table[hops-1][lcv+1][1] = measurements0;
        local_table[hops-1][lcv+1][2] = measurements1;
        local_table[hops-1][lcv+1][3] = 1;
      }     
    }
  }
  
  
  /**
   * Instead of sending a message right away, we add it to the MessagesPending table, with a delay
   * equal to source.
   */
  void delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
                                  uint16_t hops, uint16_t msg_type)
 {
    uint16_t LCV = 0;
    // Look through the messagesPending array, beginning at the first element, looking for a location that isn't
    // storing a message or that is storing a message that has already been sent, so that we can over-write it 
    // with our new message
    while(MessagesPending[LCV][0] == 1)
    {
       LCV = LCV + 1; 
    }
      
    MessagesPending[LCV][0] = 1;         // A flag to show that the message stored in this spot still needs to be sent
    MessagesPending[LCV][1] = source;    // This stores the amount of delay we want to give
    MessagesPending[LCV][2] = source;  
    MessagesPending[LCV][3] = next_addr;
    MessagesPending[LCV][4] = dest_addr;
    MessagesPending[LCV][5] = hops;
    MessagesPending[LCV][6] = msg_type;
    
    // MessagesPendingData stores the data values corresponding to this particular message
    MessagesPendingData[LCV][0] = measurements[0];
    MessagesPendingData[LCV][1] = measurements[1];
    MessagesPendingData[LCV][2] = measurements[2]; 
    MessagesPendingData[LCV][3] = measurements[3];  
    MessagesPendingData[LCV][4] = measurements[4]; 
  }
  
 
  /*
   * After all of the wavelet or scaling values have been received, loop through
   * all of them, multiply by coefficients, and keep a running total.
   */
  void calculateCoefficient(uint16_t numNeighbors, uint16_t addVal)
  {
    uint16_t LCV = 0;
    for(LCV; LCV < numNeighbors; LCV++)
    {
      double coeff = local_table_coeff[wavelet_level - 1][LCV+1];
      double value0 = local_table[wavelet_level - 1][LCV+1][1];    // get the light value
      double value1 = local_table[wavelet_level - 1][LCV+1][2];    // get the temperature value
      
      // Important Note: The values sent by the radio are all stored as UInt values, but we use doubles
      // when we multiply them by coefficients.  In the conversion from UInt to double, a negative value will 
      // be represented as a large positive number.  (We determine that a value is "large" if greater than 32768,
      // half of the maximum value.)  In order to convert to the correct negative value, subtract 2^16, which is 65536.
      if(value0 > 32768)
        value0 = value0 - 65536;
      if(value1 > 32768)
        value1 = value1 - 65536;
      
      // addVal tells us whether to add or subtract these coefficients
      if(addVal == 0)  // prediction
      {
        wav_val[TOS_LOCAL_ADDRESS][0] = wav_val[TOS_LOCAL_ADDRESS][0] - value0*coeff;  
        wav_val[TOS_LOCAL_ADDRESS][1] = wav_val[TOS_LOCAL_ADDRESS][1] - value1*coeff;  
      }
      else   // updating
      {
        wav_val[TOS_LOCAL_ADDRESS][0] = wav_val[TOS_LOCAL_ADDRESS][0] + value0*coeff;
        wav_val[TOS_LOCAL_ADDRESS][1] = wav_val[TOS_LOCAL_ADDRESS][1] + value1*coeff;  
      }
      }        
  }
  
  
  /*
   * After we've totaled the values multiplied by coefficients that are stored in localTable,
   * clear these values out and set their flags to not-received.
   */
  void clearTable(uint16_t numNeighbors)
  {
    uint16_t LCV = 0;
    for(LCV; LCV < numNeighbors; LCV++)
    {
      local_table[wavelet_level - 1][LCV+1][1] = 0;      
      local_table[wavelet_level - 1][LCV+1][2] = 0;
      local_table[wavelet_level - 1][LCV+1][3] = 0;
    }    
  }
}
