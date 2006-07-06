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
 * Extends MoteIF to support higher level UnicastPack and BroadcastPack
 * abstractions.  The broadcast implementation is based on BcastInject.
 * @author Ryan Stinnett
 * @author <a href="mailto:szewczyk@sourceforge.net">Robert Szewczyk</a>
 */
package edu.rice.compass.comm;

import java.io.*;
import java.util.Properties;

import edu.rice.compass.CompassTools;
import net.tinyos.message.*;

public class MoteCom extends MoteIF {
	public static final int NET_UART_ADDR = 0xfffe;

	private static Properties p = new Properties();
	private static short sequenceNo;
	public static MoteCom singleton = new MoteCom();

	private MoteCom() {
		sequenceNo = 1;
	}

	public static void loadSeqNo() {
		sequenceNo = restoreSequenceNo();
	}

	private static short restoreSequenceNo() {
		try {
			FileInputStream fis = new FileInputStream(CompassTools.main.packagePath
					+ "bcast.properties");
			p.load(fis);
			short i = (short) Integer.parseInt(p.getProperty("sequenceNo", "1"));
			fis.close();
			return i;
		} catch (IOException e) {
			p.setProperty("sequenceNo", "1");
			return 1;
		}
	}

	private void saveSequenceNo(short i) {
		try {
			FileOutputStream fos = new FileOutputStream(CompassTools.main.packagePath
					+ "bcast.properties");
			p.setProperty("sequenceNo", Integer.toString(i));
			p.store(fos, "#Properties for BcastInject\n");
		} catch (IOException e) {
			System.err.println("Exception while saving sequence number" + e);
			e.printStackTrace();
		}
	}

	private void debugMsg(Message msg) {
		CompassTools.debugPrint("Payload: ");
		for (int i = 0; i < msg.dataLength(); i++) {
			CompassTools.debugPrint(Integer.toHexString(msg.dataGet()[i] & 0xff)
					+ " ");
		}
		CompassTools.debugPrintln();
	}

	public void sendPack(BroadcastPack pack) throws IOException {
		debugMsg(pack);
		pack.set_data_src(NET_UART_ADDR);
		pack.set_data_dest(TOS_BCAST_ADDR);
		pack.set_seqno(sequenceNo);
		try {
			send(TOS_BCAST_ADDR, pack);
			saveSequenceNo(++sequenceNo);
		} catch (IOException e) {
			throw e;
		}
	}

	public void sendPack(UnicastPack pack, int dest) throws IOException {
		debugMsg(pack);
		pack.set_data_src(NET_UART_ADDR);
		pack.set_data_dest(dest);
		send(0, pack);
	}

}
