/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.Message;

public class Packer {

	private Message msg;
	private short type;
	private int numPacks;

	public Packer(Message msg) {
		this.msg = msg;
		if (msg.getClass().getName().endsWith("WaveletConf")) {
			type = Wavelet.BP_WAVELETCONF;
		}
		numPacks = msg.dataLength() / Wavelet.BP_DATA_LEN;
		if (msg.dataLength() % Wavelet.BP_DATA_LEN != 0)
			numPacks++;
	}

	public UnicastPack getHeader() {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(Wavelet.BIGPACKHEADER);
		pack.set_data_data_bpHeader_requestType(type);
		pack.set_data_data_bpHeader_packTotal((short)numPacks);
		pack.set_data_data_bpHeader_bytesTotal(msg.dataLength());
		return pack;
	}

	public UnicastPack getData(int packNum) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(Wavelet.BIGPACKDATA);
		pack.set_data_data_bpData_curPack((short)packNum);
		int firstByte = packNum * Wavelet.BP_DATA_LEN;
		int length = Wavelet.BP_DATA_LEN;
		if ((firstByte + length) > msg.dataLength())
			length = msg.dataLength() - firstByte;
		pack.set_data_data_bpData_data(msg.dataGet(firstByte, length));
		return pack;
	}
	
	public boolean morePacksExist(int curPack) {
		if (curPack + 1 > numPacks)
			return false;
		return true;
	}

	public int getNumPacks() {
		return numPacks;
	}

}
