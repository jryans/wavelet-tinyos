/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass.bigpack;

import edu.rice.compass.UnicastPack;
import edu.rice.compass.Wavelet;

public class Unpacker {

	private short type;
	private int numPacks;
	private int numBlocks;
	private int numPtrs;
	private byte[] stream;
	private int curPackNum;

	public Unpacker(UnicastPack h) {
		type = h.get_data_data_bpHeader_requestType();
		numPacks = h.get_data_data_bpHeader_packTotal();
		numBlocks = h.get_data_data_bpHeader_numBlocks();
		numPtrs = h.get_data_data_bpHeader_numPtrs();
		stream = new byte[h.get_data_data_bpHeader_byteTotal()];
		curPackNum = 0;
	}

	public boolean newData(UnicastPack d) {
		int packNum = d.get_data_data_bpData_curPack();
		if (packNum != curPackNum)
			return false;
		int firstByte = packNum * BigPack.BP_DATA_LEN;
		int length = BigPack.BP_DATA_LEN;
		if ((firstByte + length) > stream.length)
			length = stream.length - firstByte;
		System.arraycopy(d.get_data_data_bpData_data(), 0, stream, firstByte,
				length);
		curPackNum++;
		return true;
	}

	public BigPack unpack() {
		if (type == BigPack.BP_STATS) {
			BigPack pack = new MoteStats(stream);
			pack.makeChildren();
			return pack;
		}
		return null;
	}

	public boolean morePacksExist(int curPack) {
		if (curPack + 1 >= numPacks)
			return false;
		return true;
	}

	public int getNumPacks() {
		return numPacks;
	}

}
