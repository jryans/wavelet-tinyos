/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass.comm;


public class Unpacker extends ProtoPacker {

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
			return new MoteStats(stream, numBlocks, numPtrs);
		}
		return null;
	}

}
