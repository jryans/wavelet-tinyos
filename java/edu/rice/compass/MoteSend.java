/* "Copyright (c) 2000-2003 The Regents of the University  of California.  
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
 * Allows Java programs to send broadcast and unicast packets to the
 * motes.  The broadcast implementation is based on BcastInject.
 * @author Ryan Stinnett
 * @author <a href="mailto:szewczyk@sourceforge.net">Robert Szewczyk</a>
 */
package edu.rice.compass;

import net.tinyos.util.*;
import java.io.*;
import java.util.Properties;
import net.tinyos.message.*;

public class MoteSend {
	static Properties p = new Properties();

	static final short TOS_BCAST_ADDR = (short) 0xffff;

	static short sequenceNo = 0;

	public static boolean debug = false;

	private static MoteIF moteCom = new MoteIF(PrintStreamMessenger.out);

	short restoreSequenceNo() {
		try {
			FileInputStream fis = new FileInputStream("bcast.properties");
			p.load(fis);
			short i = (short) Integer.parseInt(p.getProperty("sequenceNo", "1"));
			fis.close();
			return i;
		} catch (IOException e) {
			p.setProperty("sequenceNo", "1");
			return 1;
		}
	}

	void saveSequenceNo(short i) {
		try {
			FileOutputStream fos = new FileOutputStream("bcast.properties");
			p.setProperty("sequenceNo", Integer.toString(i));
			p.store(fos, "#Properties for BcastInject\n");
		} catch (IOException e) {
			System.err.println("Exception while saving sequence number" + e);
			e.printStackTrace();
		}
	}

	public MoteSend() {
		//if (sequenceNo == 0)
			//sequenceNo = restoreSequenceNo();
			sequenceNo = 1;
	}

	/*public void sendDiag() {
		UnicastPack packet = new UnicastPack();

		packet.set_retriesLeft((short) 0);
		packet.set_data_src(0);
		packet.set_data_dest(1);

		switch (cmd) {
		case 1:
			packet.set_data_type((short) 4);
			packet.set_data_data_wConfHeader_numLevels((short) 2);
			packet.setElement_data_data_wConfHeader_nbCount(0, (short) 2);
			packet.setElement_data_data_wConfHeader_nbCount(1, (short) 2);
			break;
		case 2:
			packet.set_data_type((short) 3);
			packet.set_data_data_wConfData_level((short) 0);
			packet.set_data_data_wConfData_packNum((short) 0);
			packet.set_data_data_wConfData_moteCount((short) 2);
			packet.setElement_data_data_wConfData_moteConf_id(0, (short) 1);
			packet.setElement_data_data_wConfData_moteConf_state(0, (short) 5);
			packet.setElement_data_data_wConfData_moteConf_coeff(0, (float) 0);
			packet.setElement_data_data_wConfData_moteConf_id(1, (short) 2);
			packet.setElement_data_data_wConfData_moteConf_state(1, (short) 4);
			packet.setElement_data_data_wConfData_moteConf_coeff(1, (float) 0);
			break;
		case 3:
			packet.set_data_type((short) 3);
			packet.set_data_data_wConfData_level((short) 1);
			packet.set_data_data_wConfData_packNum((short) 0);
			packet.set_data_data_wConfData_moteCount((short) 2);
			packet.setElement_data_data_wConfData_moteConf_id(0, (short) 1);
			packet.setElement_data_data_wConfData_moteConf_coeff(0, (float) 0);
			packet.setElement_data_data_wConfData_moteConf_id(1, (short) 2);
			packet.setElement_data_data_wConfData_moteConf_coeff(1, (float) 0);
			break;
		}
	}*/

	private void debugMsg(Message msg) {
		if (debug) {
			System.out.print("Payload: ");
			for (int i = 0; i < msg.dataLength(); i++) {
				System.out.print(Integer.toHexString(msg.dataGet()[i] & 0xff) + " ");
			}
			System.out.println();
		}
	}
	
	public void sendPack(BroadcastPack pack) throws IOException {
		debugMsg(pack);
		pack.set_data_src(0);
		pack.set_data_dest(TOS_BCAST_ADDR);
		pack.set_seqno(sequenceNo);
		try {
			moteCom.send(TOS_BCAST_ADDR, pack);
			saveSequenceNo(++sequenceNo);
		} catch(IOException e) {
			throw e;
		}
	}
	
	public void sendPack(UnicastPack pack) throws IOException {
		debugMsg(pack);
		pack.set_data_src(0);
		moteCom.send(0, pack);
	}
	
}
