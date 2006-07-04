/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass.bigpack;

import java.io.*;
import edu.rice.compass.*;
import edu.rice.compass.comm.*;
import net.tinyos.message.*;

public class Packer extends ProtoPacker {

	public Packer(PackerHost owner) {
		super(owner);
	}

	private void newMessage(BigPack msg) {
		if (!busy) {
			busy = true;
			stream = msg.dataStream();
			numBlocks = msg.numBlocks();
			numPtrs = msg.numPointers();
			type = BigPack.getType(); // potential problem...
			numPacks = stream.length / BigPack.BP_DATA_LEN;
			if (stream.length % BigPack.BP_DATA_LEN != 0)
				numPacks++;
		}
	}

	private void sendHeader() {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(BigPack.BIGPACKHEADER);
		pack.set_data_data_bpHeader_requestType(type);
		pack.set_data_data_bpHeader_packTotal((short) numPacks);
		pack.set_data_data_bpHeader_byteTotal(stream.length);
		pack.set_data_data_bpHeader_numBlocks((short) numBlocks);
		pack.set_data_data_bpHeader_numPtrs((short) numPtrs);
		try {
			owner.getMoteCom().sendPack(pack);
			System.out.println("Sent BP header (0/" + numPacks + ") to mote "
					+ owner.getID());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void sendData() {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(BigPack.BIGPACKDATA);
		pack.set_data_data_bpData_curPack(curPackNum);
		int firstByte = curPackNum * BigPack.BP_DATA_LEN;
		int length = BigPack.BP_DATA_LEN;
		if ((firstByte + length) > stream.length)
			length = stream.length - firstByte;
		pack.set_data_data_bpData_data(byteRange(firstByte, length));
		try {
			owner.getMoteCom().sendPack(pack);
			System.out.println("Sent BP data (" + (curPackNum + 1) + "/" + numPacks
					+ ") to mote " + owner.getID());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private byte[] byteRange(int offsetFrom, int length) {
		byte[] tmp = new byte[length];
		System.arraycopy(stream, offsetFrom, tmp, 0, length);
		return tmp;
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		int id = pack.get_data_src();
		if (id != owner.getID())
			return;
		switch (pack.get_data_type()) {
		case Wavelet.BIGPACKHEADER:
			// If true, this is the initial request, else an ACK.
			if (!busy && pack.get_data_data_bpHeader_packTotal() == 0) {
				System.out.println("Got BP header request from mote " + id);
				type = pack.get_data_data_bpHeader_requestType();
				// Build a new BigPack of the requested type
				newMessage(owner.buildPack(type));
				curPackNum = HEADER_PACK_NUM;
				sendHeader(); // Send BP header
			} else if (busy && pack.get_data_data_bpHeader_packTotal() != 0
					&& curPackNum == HEADER_PACK_NUM
					&& pack.get_data_data_bpHeader_requestType() == type) {
				System.out.println("Got BP header ack from mote " + id);
				curPackNum++;
				sendData(); // Send BP data
			}
			break;
		case Wavelet.BIGPACKDATA:
			if (busy && pack.get_data_data_bpData_curPack() == curPackNum) {
				if (morePacksExist()) {
					System.out.println("Got BP data ack from mote " + id);
					curPackNum++;
					sendData(); // Send BP data
				} else {
					System.out.println("BP sent to mote " + id + " complete");
					busy = false;
					owner.packerDone(null); // Done!
				}
			}
			break;
		}
	}

}
