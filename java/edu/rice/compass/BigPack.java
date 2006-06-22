package edu.rice.compass;

import net.tinyos.message.Message;
import java.util.*;

public abstract class BigPack extends Message {

	private Vector blocks = new Vector();
	private Vector pointers = new Vector();

	protected BigPack(int dataLength) {
		super(dataLength);
	}

	/**
	 * Creates a new big pack with initial static data, followed
	 * by data from an array of messages.
	 * @param staticLen
	 * @param msg
	 */
	protected BigPack(int staticLen, Message[] msg) {
		super(staticLen + msg[0].dataLength() * msg.length);
		for (int i = 0; i < msg.length; i++)
			dataSet(msg[i], staticLen + msg[0].dataLength() * i);
	}

	private BigPack() {
		super(1);
	}

	public byte[] dataGet(int offsetFrom, int length) {
		byte[] tmp = new byte[length];
		System.arraycopy(dataGet(), offsetFrom, tmp, 0, length);
		return tmp;
	}

	protected BigPackBlock addBlock(int start, int length) {
		BigPackBlock blk = new BigPackBlock(start, length);
		blocks.add(blk);
		return blk;
	}

	protected void addPointer(BigPackBlock addrOfBlock, BigPackBlock destBlock,
			int destOffset) {
		int src = blocks.indexOf(addrOfBlock);
		int dest = blocks.indexOf(destBlock);
		pointers.add(new BigPackPtr(src, dest, destOffset));
	}

	public Vector getBlocks() {
		return blocks;
	}

	public Vector getPointers() {
		return pointers;
	}

}

class BigPackBlock {
	private int start; // Start of data block in the stream
	private int length; // Length of the data block in bytes

	BigPackBlock(int start, int len) {
		this.start = start;
		length = len;
	}

	int getLength() {
		return length;
	}

	int getStart() {
		return start;
	}
}

class BigPackPtr {
	private int addrOfBlock; // Block ID whose address will be the value of the
	// pointer
	private int destBlock; // Block ID that contains the pointer
	private int destOffset; // Pointer's location as an offset from the start of

	// destBlock

	BigPackPtr(int addrOfBlock, int destBlock, int destOffset) {
		this.addrOfBlock = addrOfBlock;
		this.destBlock = destBlock;
		this.destOffset = destOffset;
	}

	int getAddrOfBlock() {
		return addrOfBlock;
	}

	int getDestBlock() {
		return destBlock;
	}

	int getDestOffset() {
		return destOffset;
	}
}