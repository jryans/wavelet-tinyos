/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.util.*;

public class Packer {

	private BigPack msg;
	private short type;
	private int numPacks;

	private static final int MAX_BLOCKS = 2;
	private static final int MAX_PTRS = 1;

	public void setMessage(BigPack msg) {
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
		pack.set_data_data_bpHeader_packTotal((short) numPacks);
		pack.set_data_data_bpHeader_byteTotal(msg.dataLength());
		Vector blocks = msg.getBlocks();
		for (int i = 0; (i < blocks.size()) && (i < MAX_BLOCKS); i++) {
			BigPackBlock block = (BigPackBlock) blocks.get(i);
			pack.setElement_data_data_bpHeader_block_start(i, block.getStart());
			pack.setElement_data_data_bpHeader_block_length(i, block.getLength());
		}
		Vector pointers = msg.getPointers();
		for (int i = 0; (i < pointers.size()) && (i < MAX_PTRS); i++) {
			BigPackPtr ptr = (BigPackPtr) pointers.get(i);
			pack.setElement_data_data_bpHeader_ptr_addrOfBlock(i, (short)ptr.getAddrOfBlock());
			pack.setElement_data_data_bpHeader_ptr_destBlock(i, (short)ptr.getDestBlock());
			pack.setElement_data_data_bpHeader_ptr_destOffset(i, (short)ptr.getDestOffset());
		}
		return pack;
	}

	public UnicastPack getData(int packNum) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(Wavelet.BIGPACKDATA);
		pack.set_data_data_bpData_curPack((short) packNum);
		int firstByte = packNum * Wavelet.BP_DATA_LEN;
		int length = Wavelet.BP_DATA_LEN;
		if ((firstByte + length) > msg.dataLength())
			length = msg.dataLength() - firstByte;
		pack.set_data_data_bpData_data(msg.dataGet(firstByte, length));
		return pack;
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
