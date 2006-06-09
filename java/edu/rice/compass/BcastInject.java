// $Id: BcastInject.java,v 1.7 2003/10/07 21:46:08 idgay Exp $

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


/**
 * 
 *
 * @author <a href="mailto:szewczyk@sourceforge.net">Robert Szewczyk</a>
 */
package edu.rice.compass;

import net.tinyos.util.*;
import java.io.*;
import java.util.Properties;
import net.tinyos.message.*;

public class BcastInject {
    static Properties p = new Properties();
    public static final byte YELLOW_LED_ON = 1;
    public static final byte YELLOW_LED_OFF = 2;
    public static final byte GREEN_LED_ON = 3;
    public static final byte GREEN_LED_OFF = 4;
    public static final byte START_SENSING = 5;
    public static final byte WAVELET = 6; //changed 2-11-06

    public boolean read_log_done = false; 
        
    public static final short TOS_BCAST_ADDR = (short) 0xffff;
 
    public static void usage() {
 System.err.println("Usage: java net.tinyos.tools.BcastInject"+
      " <command> [arguments]");
 System.err.println("\twhere <command> and [arguments] can be one of the following:");
 System.err.println("\t\tled_on");
 System.err.println("\t\tled_off");
 System.err.println("\t\tradio_louder");
 System.err.println("\t\tradio_quieter");
 System.err.println("\t\tstart_sensing [nsamples interval_ms]");
 System.err.println("\t\tread_log [dest_address]");
    }

    public static void startSensingUsage() {
 System.err.println("Usage: java net.tinyos.tools.BcastInject"
      + " start_sensing [num_samples interval_ms]");
    }
    public static void  readLogUsage() {
 System.err.println("Usage: java net.tinyos.tools.BcastInject" +
      " read_log [dest_address]");
    } 

    public static byte restoreSequenceNo() {
 try {
     FileInputStream fis = new FileInputStream("bcast.properties");
     p.load(fis);
     byte i = (byte)Integer.parseInt(p.getProperty("sequenceNo", "1"));
     fis.close();
     return i;
 } catch (IOException e) {
     p.setProperty("sequenceNo", "1");
     return 1;
 }
    }
    public static void saveSequenceNo(int i) {
 try {
     FileOutputStream fos = new FileOutputStream("bcast.properties");
     p.setProperty("sequenceNo", Integer.toString(i));
     p.store(fos, "#Properties for BcastInject\n");
 } catch (IOException e) {
     System.err.println("Exception while saving sequence number" +
          e);
     e.printStackTrace();
 }
    }

    public static void main(String[] argv) throws IOException {
// String cmd;
 byte sequenceNo = 0;
 boolean read_log = false;

 if (argv.length < 1) {
     usage();
     System.exit(-1);
 }

// cmd = argv[0];

// if (cmd.equals("start_sensing") && argv.length != 3) {
//     startSensingUsage();
//     System.exit(-1);
// } else if (cmd.equals("read_log") && argv.length != 3) {
//     readLogUsage();
//     System.exit(-1);
// }
 
// SimpleCmdMsg packet = new SimpleCmdMsg(); 
//
// sequenceNo = restoreSequenceNo();
// packet.set_seqno(sequenceNo);
// packet.set_hop_count((short)0);
// packet.set_source(0);
// 
// byte[] theData = new byte[] {1};
// if (cmd.equals("yellow_on")) {
//     packet.set_action(YELLOW_LED_ON);
//	 //theData = new byte[] { -2, -1, 0, 1 };
// } else if (cmd.equals("yellow_off")) {
//     packet.set_action(YELLOW_LED_OFF);
//	 //theData = new byte[] { -2, -1, 0, 2 };
// } else if (cmd.equals("green_on")) {
//     packet.set_action(GREEN_LED_ON);
//	 //theData = new byte[] { -2, -1, 0, 3 };
// } else if (cmd.equals("green_off")) {
//     packet.set_action(GREEN_LED_OFF);
//	 //theData = new byte[] { -2, -1, 0, 4 };
// } else if (cmd.equals("start_sensing")) {
//     packet.set_action(START_SENSING);
//     short nsamples = (short)Integer.parseInt(argv[1]);
//     long interval_ms = (long)Integer.parseInt(argv[2]);
//     packet.set_args_ss_args_nsamples(nsamples);
//     packet.set_args_ss_args_interval(interval_ms);
// } else if (cmd.equals("wavelet")) {
//     //read_log = true;
//     packet.set_action(WAVELET);
//     //short address = (short)Integer.parseInt(argv[1]);
//     //packet.set_args_ss_args_nsamples(address);
//     //long secondarg = (long)Integer.parseInt(argv[2]);
//     //packet.set_args_ss_args_interval(secondarg);
// } else {
//     usage();
//     System.exit(-1);
// }
//        
// theData = new byte[] { 2, -2, -1, 0, 1 };
 
// byte[] bts = new byte[cmd.length() / 2];
// for (int i = 0; i < bts.length; i++) {
//    bts[i] = (byte) Integer.parseInt(cmd.substring(2*i, 2*i+2), 16);
// }
// 
// SimpleCmdMsg packet = new SimpleCmdMsg(bts);
// int type = Integer.parseInt(argv[1]);
// packet.setType(type);
 
 int cmd = Integer.parseInt(argv[0]);
 UnicastPack packet = new UnicastPack();

 packet.set_retriesLeft((short)0);
 packet.set_data_src((short)0);
 packet.set_data_dest((short)1);
 
 switch (cmd) {
 case 1:
     packet.set_data_type((short)4);
     packet.set_data_data_wConfHeader_numLevels((short)2);
     packet.setElement_data_data_wConfHeader_nbCount(0, (short)2);
     packet.setElement_data_data_wConfHeader_nbCount(1, (short)2);
     break;
 case 2:
     packet.set_data_type((short)3);
     packet.set_data_data_wConfData_level((short)0);
     packet.set_data_data_wConfData_packNum((short)0);
     packet.set_data_data_wConfData_moteCount((short)2);
     packet.setElement_data_data_wConfData_moteConf_id(0, (short)1);
     packet.setElement_data_data_wConfData_moteConf_state(0, (short)5);
     packet.setElement_data_data_wConfData_moteConf_coeff(0, (float)0);
     packet.setElement_data_data_wConfData_moteConf_id(1, (short)2);
     packet.setElement_data_data_wConfData_moteConf_state(1, (short)4);
     packet.setElement_data_data_wConfData_moteConf_coeff(1, (float)0);
     break;
 case 3:
     packet.set_data_type((short)3);
     packet.set_data_data_wConfData_level((short)1);
     packet.set_data_data_wConfData_packNum((short)0);
     packet.set_data_data_wConfData_moteCount((short)2);
     packet.setElement_data_data_wConfData_moteConf_id(0, (short)1);
     packet.setElement_data_data_wConfData_moteConf_coeff(0, (float)0);
     packet.setElement_data_data_wConfData_moteConf_id(1, (short)2);
     packet.setElement_data_data_wConfData_moteConf_coeff(1, (float)0);
     break;
 }
 
 
 try {
     System.err.print("Sending payload: ");
     
     for (int i = 0; i < packet.dataLength(); i++) {
  System.err.print(Integer.toHexString(packet.dataGet()[i] & 0xff)+ " ");
     }
     System.err.println();

     MoteIF mote = new MoteIF(PrintStreamMessenger.err);

     // Need to wait for a read_log message to come back
     BcastInject bc = null;
     if (read_log) {
  bc = new BcastInject();
 // mote.registerListener(new LogMsg(), bc);
     }
     
//     if (type == 5) {
//     mote.send(TOS_BCAST_ADDR, packet);
//     } else {
//     mote.send(Integer.parseInt(argv[2]), packet);
//     }
     
     mote.send(0, packet);

     if (read_log) {
  synchronized (bc) {
      if (bc.read_log_done == false) {
   System.err.println("Waiting for response to read_log...");
   bc.wait(10000);
      }
      if (bc.read_log_done == false) {
   System.err.println("Warning: Timed out waiting for response to read_log command!");
      }
  }
     }

     saveSequenceNo(sequenceNo+1);
     System.exit(0);

 } catch(Exception e) {
     e.printStackTrace();
 } 

    }

}

