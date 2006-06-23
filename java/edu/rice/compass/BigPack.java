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
	
	/**
	 * Creates a new big pack with initial static data, followed
	 * by data from an array of big packs.
	 * @param staticLen
	 * @param msg
	 */
	protected BigPack(int staticLen, BigPack[] bp) {
		// Initialize data storage
		super(0);
		base_offset = 0;
		data_length = staticLen;
		for (int i = 0; i < bp.length; i++) {
			data_length += bp[i].dataLength();
		}
		data = new byte[data_length];
		// Combine each big pack
		int offset = staticLen;
		for (int i = 0; i <  bp.length; i++) {
			dataSet(bp[i], offset);
			if (i == 0) { // Straight copy
				blocks = bp[i].blocks;
				pointers = bp[i].pointers;
			} else { // Must adjust offsets on blocks
				for (int b = 0; b < bp[i].blocks.size(); b++) {
					blocks.add(bp[i].blocks.get(b));
					BigPackBlock blk = (BigPackBlock) blocks.lastElement();
					blk.set_start(offset + blk.get_start());
				}
				for (int b = 0; b < bp[i].pointers.size(); b++)
					pointers.add(bp[i].pointers.get(b));
			}
			offset += bp[i].dataLength();
		}
	}

	private BigPack() {
		super(0);
	}

	protected BigPackBlock addBlock(int start, int length) {
		BigPackBlock blk = new BigPackBlock();
		blk.set_length(length);
		blk.set_start(start);
		blocks.add(blk);
		return blk;
	}

	protected void addPointer(BigPackBlock addrOfBlock, BigPackBlock destBlock,
			int destOffset) {
		BigPackPtr ptr = new BigPackPtr();
		ptr.set_addrOfBlock((short)blocks.indexOf(addrOfBlock));
		ptr.set_destBlock((short)blocks.indexOf(destBlock));
		ptr.set_destOffset((short)destOffset);
		pointers.add(ptr);
	}

	public int numBlocks() {
		return blocks.size();
	}

	public int numPointers() {
		return pointers.size();
	}
	
	/**
	 * Returns the "complete" data stream which is:
	 *  1. Data for each block
	 *  2. Data for each pointer
	 *  3. Actual data payload
	 */
	public byte[] dataStream() {
		byte[] stream = new byte[BigPackBlock.DEFAULT_MESSAGE_SIZE * blocks.size() +
		                         BigPackPtr.DEFAULT_MESSAGE_SIZE * pointers.size() +
		                         data_length];
		int offset = 0;
		BigPackBlock blks[] = (BigPackBlock[]) blocks.toArray();
		for (int b = 0; b < blks.length; b++) {
			System.arraycopy(blks[b].dataGet(), 0, stream, offset, BigPackBlock.DEFAULT_MESSAGE_SIZE);
			offset += BigPackBlock.DEFAULT_MESSAGE_SIZE;
		}
		BigPackPtr ptrs[] = (BigPackPtr[]) pointers.toArray();
		for (int b = 0; b < ptrs.length; b++) {
			System.arraycopy(ptrs[b].dataGet(), 0, stream, offset, BigPackPtr.DEFAULT_MESSAGE_SIZE);
			offset += BigPackPtr.DEFAULT_MESSAGE_SIZE;
		}
		System.arraycopy(data, 0, stream, offset, data_length);
		return stream;
	}

}