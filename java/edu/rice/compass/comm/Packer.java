/**
 * Chops up the data of a message into multiple packs.
 * @author Ryan Stinnett
 */

package edu.rice.compass.comm;

import net.tinyos.message.Message;

public class Packer extends ProtoPacker {

	public Packer(PackerDest owner) {
		super(owner);
	}
	
	public void sendMessage(BigPack msg) {
		stream = msg.dataStream();
		numBlocks = msg.numBlocks();
		numPtrs = msg.numPointers();
		type = BigPack.getType(); // potential problem...
		numPacks = stream.length / BigPack.BP_DATA_LEN;
		if (stream.length % BigPack.BP_DATA_LEN != 0)
			numPacks++;
	}

	public UnicastPack getHeader() {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(BigPack.BIGPACKHEADER);
		pack.set_data_data_bpHeader_requestType(type);
		pack.set_data_data_bpHeader_packTotal((short) numPacks);
		pack.set_data_data_bpHeader_byteTotal(stream.length);
		pack.set_data_data_bpHeader_numBlocks((short)numBlocks);
		pack.set_data_data_bpHeader_numPtrs((short)numPtrs);
		return pack;
	}

	public UnicastPack getData(int packNum) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(BigPack.BIGPACKDATA);
		pack.set_data_data_bpData_curPack((short) packNum);
		int firstByte = packNum * BigPack.BP_DATA_LEN;
		int length = BigPack.BP_DATA_LEN;
		if ((firstByte + length) > stream.length)
			length = stream.length - firstByte;
		pack.set_data_data_bpData_data(byteRange(firstByte, length));
		return pack;
	}
	
	private byte[] byteRange(int offsetFrom, int length) {
		byte[] tmp = new byte[length];
		System.arraycopy(stream, offsetFrom, tmp, 0, length);
		return tmp;
	}

	public void messageReceived(int to, Message m) {
		// TODO Auto-generated method stub
		
	}
	
	

}
