/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass.bigpack;

import java.io.*;
import java.lang.reflect.*;
import net.tinyos.message.*;
import edu.rice.compass.*;
import edu.rice.compass.comm.*;

public class Unpacker extends ProtoPacker {

	public Unpacker(PackerHost owner) {
		super(owner);
	}

	public void newRequest(short mType) {
		if (!busy) {
			busy = true;
			type = mType;
			curPackNum = HEADER_PACK_NUM;
			sendRequest();
		}
	}

	private void sendRequest() {
		UnicastPack req = new UnicastPack();
		req.set_data_type(BigPack.BIGPACKHEADER);
		req.set_data_data_bpHeader_requestType(type);
		req.set_data_data_bpHeader_packTotal((short) 0);
		try {
			owner.sendPack(req);
			System.out.println("Sent BP request to mote " + owner.getID());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void storeRequestData(UnicastPack h) {
		numPacks = h.get_data_data_bpHeader_packTotal();
		numBlocks = h.get_data_data_bpHeader_numBlocks();
		numPtrs = h.get_data_data_bpHeader_numPtrs();
		stream = new byte[h.get_data_data_bpHeader_byteTotal()];
	}

	private void sendAck(UnicastPack pack) {
		try {
			owner.sendPack(pack);
			System.out.println("Sent ack to mote " + owner.getID());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void newData(UnicastPack d) {
		int firstByte = d.get_data_data_bpData_curPack() * BigPack.BP_DATA_LEN;
		int length = BigPack.BP_DATA_LEN;
		if ((firstByte + length) > stream.length)
			length = stream.length - firstByte;
		System.arraycopy(d.get_data_data_bpData_data(), 0, stream, firstByte,
				length);
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		int id = pack.get_data_src();
		if (!busy || id != owner.getID())
			return;
		switch (pack.get_data_type()) {
		case CompassMote.BIGPACKHEADER:
			if (curPackNum == HEADER_PACK_NUM
					&& pack.get_data_data_bpHeader_requestType() == type) {
				// Store specific details of the request
				storeRequestData(pack);
				System.out.println("Got BP header (0/" + numPacks + ") from mote " + id);
				curPackNum++;
				sendAck(pack); // Send an ACK
			}
			break;
		case CompassMote.BIGPACKDATA:
			if (pack.get_data_data_bpData_curPack() == curPackNum) {
				newData(pack); // Store new data
				System.out.println("Got BP data (" + (curPackNum + 1) + "/" + numPacks
						+ ") from mote " + id);
				sendAck(pack); // Send an ACK
				if (morePacksExist()) {
					curPackNum++;
				} else {
					System.out.println("BP rcvd from mote " + id + " complete");
					busy = false; // Done!
					// Find the right class, and make it.
					try {
						Class msgClass = BigPack.getClassFromType(type);
						Constructor msgMake = msgClass.getConstructor(new Class[] {
								byte[].class, int.class, int.class });
						owner.unpackerDone((BigPack) msgMake.newInstance(new Object[] {
								stream, new Integer(numBlocks), new Integer(numPtrs) }));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			break;
		}
	}
}
