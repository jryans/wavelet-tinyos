package edu.rice.compass.bigpack;

import net.tinyos.message.Message;
import java.util.*;

import edu.rice.compass.WaveletConfigServer;

public abstract class BigPack extends Message {

	/* Constants */

	static final short TOSH_DATA_LENGTH = 29;
	static final short UPACK_MSG_OFFSET = 1;
	static final short UPACK_DATA_LEN = TOSH_DATA_LENGTH - UPACK_MSG_OFFSET;
	static final short MSG_DATA_OFFSET = 5;
	static final short UPACK_MSG_DATA_LEN = UPACK_DATA_LEN - MSG_DATA_OFFSET;
	static final short BP_DATA_LEN = UPACK_MSG_DATA_LEN - 1;

	public static final short BP_WAVELETCONF = 0;
	public static final short BP_STATS = 1;

	public static final short BP_SENDING = 0;
	public static final short BP_RECEIVING = 1;

	public static final short BIGPACKHEADER = 2;
	public static final short BIGPACKDATA = 3;

	/* Variables */

	private static final short BPP_PTR = 0;
	private static final short BPP_ARRAY = 1;

	protected List blocks = new Vector();
	private List pointers = new Vector();

	protected int firstMainBlk;

	protected BigPack(int dataLength) {
		super(dataLength);
	}

	/**
	 * Regenerates a root big pack and any associated children.
	 * 
	 * @param rawData
	 */
	protected BigPack(byte[] rawData, int dataLength, int numBlks, int numPtrs) {
		super(dataLength);
		int offset = 0;
		WaveletConfigServer.debugPrintln("BigPack: Blocks and Pointers");
		// Pull blocks and pointers out of data stream
		for (int i = 0; i < numBlks; i++) {
			WaveletConfigServer.debugPrintln("BigPack: Block #" + (i + 1));
			BigPackBlock blk = new BigPackBlock(byteRange(rawData, offset,
					BigPackBlock.DEFAULT_MESSAGE_SIZE));
			WaveletConfigServer.debugPrintln("BigPack:   Start:  " + blk.get_start());
      WaveletConfigServer.debugPrintln("BigPack:   Length: " + blk.get_length());
			blocks.add(blk);
			offset += BigPackBlock.DEFAULT_MESSAGE_SIZE;
		}
    for (int i = 0; i < numPtrs; i++) {
			WaveletConfigServer.debugPrintln("BigPack: Pointer #" + (i + 1));
			BigPackPtr ptr = new BigPackPtr(byteRange(rawData, offset,
					BigPackPtr.DEFAULT_MESSAGE_SIZE));
			WaveletConfigServer.debugPrintln("BigPack:   Addr of Block: " + (ptr.get_addrOfBlock() + 1));
	    WaveletConfigServer.debugPrintln("BigPack:   Dest Block:    " + (ptr.get_destBlock() + 1));
	    WaveletConfigServer.debugPrintln("BigPack:   Dest Offset:   " + (ptr.get_destOffset()));
	    if (ptr.get_blockArray() == BPP_ARRAY) {
	    	WaveletConfigServer.debugPrintln("BigPack:   Block Array:   Yes");
	    } else {
	    	WaveletConfigServer.debugPrintln("BigPack:   Block Array:   No");
	    }
			pointers.add(ptr);
			offset += BigPackPtr.DEFAULT_MESSAGE_SIZE;
		}
		rawData = byteRange(rawData, offset, rawData.length - offset);
		breakUpData(rawData, blocks.size() - 1);
	}

	private void breakUpData(byte[] rawData, int thisBlk) {
		try {
			// The pack's block is at blockNum, which helps locate its data.
			BigPackBlock blk = (BigPackBlock) blocks.get(thisBlk);
			if (blk.get_length() != data_length)
				//throw new Exception("Static data block's length doesn't match.");
				System.out.println("Static data block's length is " + blk.get_length() +
						", but this class's length should be " + data_length);
			data = byteRange(rawData, blk.get_start(), data_length);
			if (numChildTypes() > 0) {
				// Initialize child storage
				initChildren();
				// Grab pointers that reference us as their destination block,
				// create them, and attach them here as children.
				List pToC = pointers.subList(pointers.size() - numChildTypes(),
						pointers.size());
				// Gives each child the full raw data set, all blocks, but only the 
				// applicable pointers.
				for (int i = 0; i < pToC.size(); i++) {
					BigPackPtr ptr = (BigPackPtr) pToC.get(i);
					if (ptr.get_destBlock() != thisBlk)
						throw new Exception(
								"Pointer's dest block should be this pack's static data block.");
					int childCnt = numChildren(ptr.get_destOffset());
					int childBlockNum[] = new int[childCnt];
					List childPtr[] = new List[childCnt];
					if (ptr.get_blockArray() == BPP_PTR) { // Single source block
						List pForC = pointers.subList(0, pointers.size() - numChildTypes());
						for (int c = 0; c < childCnt; c++) {
							childBlockNum[c] = ptr.get_addrOfBlock();
							childPtr[c] = pForC;
						}
					} else if (ptr.get_blockArray() == BPP_ARRAY) { // Multiple source
																													// blocks
						int pPerC = (pointers.size() - numChildTypes()) / childCnt;
						for (int c = 0; c < childCnt; c++) {
							childBlockNum[c] = ptr.get_addrOfBlock() + c;
							childPtr[c] = pointers.subList(c * pPerC, (c + 1) * pPerC);
						}
					}
					storeChildren(rawData, ptr.get_destOffset(), childBlockNum, childPtr);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void breakUpData(byte[] rawData, int thisBlk, int cOffset) {
		try {
			// The pack's block is at blockNum, which helps locate its data.
			BigPackBlock blk = (BigPackBlock) blocks.get(thisBlk);
			if (blk.get_length() != data_length)
				//throw new Exception("Static data block's length doesn't match.");
				System.out.println("Static data block's length is " + blk.get_length() +
						", but this class's length should be " + data_length);
			data = byteRange(rawData, blk.get_start() + cOffset * data_length, data_length);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected BigPack(byte[] rawData, int dataLength, int blockNum,
			List nBlocks, List nPtrs) {
		super(dataLength);
		blocks = nBlocks;
		pointers = nPtrs;
		breakUpData(rawData, blockNum);
	}

	protected BigPack(byte[] rawData, int dataLength, int blockNum,
			List nBlocks, List nPtrs, int cOffset) {
		super(dataLength);
		blocks = nBlocks;
		pointers = nPtrs;
		breakUpData(rawData, blockNum, cOffset);
	}

	protected void initChildren() {
	}

	protected void storeChildren(byte[] rawData, int offset, int[] childBlockNum,
			List[] childPtr) {
	}

	protected int numChildren(int offset) {
		return 0;
	}

	protected int numChildTypes() {
		return 0;
	}

	/**
	 * Creates a new big pack with initial static data, followed by data from an
	 * array of messages.
	 * 
	 * @param staticLen
	 * @param msg
	 */
	protected BigPack(int staticLen, Message[] msg) {
		super(staticLen + msg[0].dataLength() * msg.length);
		for (int i = 0; i < msg.length; i++)
			dataSet(msg[i], staticLen + msg[0].dataLength() * i);
	}

	/**
	 * Creates a new big pack with initial static data, followed by data from an
	 * array of big packs.
	 * 
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
		for (int i = 0; i < bp.length; i++) {
			dataSet(bp[i], offset);
			// Copy and adjust offsets on blocks
			for (int b = 0; b < bp[i].blocks.size(); b++) {
				blocks.add(bp[i].blocks.get(b));
				BigPackBlock blk = (BigPackBlock) blocks.get(blocks.size() - 1);
				blk.set_start(offset + blk.get_start());
			}
			offset += bp[i].dataLength();
		}
		// Push each main block to the end
		int blkOffset = 0;
		for (int i = 0; i < bp.length; i++) {
			blkOffset += bp[i].blocks.size();
			BigPackBlock blk = (BigPackBlock) blocks.remove(blkOffset - (i + 1));
			blocks.add(blk);
		}
		// Copy and adjust block numbers on pointers
		blkOffset = 0;
		firstMainBlk = blocks.size() - bp.length;
		for (int i = 0; i < bp.length; i++) {
			for (int b = 0; b < bp[i].pointers.size(); b++) {
				pointers.add(bp[i].pointers.get(b));
				BigPackPtr ptr = (BigPackPtr) pointers.get(pointers.size() - 1);
				ptr.set_addrOfBlock((short) (blkOffset + ptr.get_addrOfBlock()));
				ptr.set_destBlock((short) (firstMainBlk + i));
			}
			blkOffset += bp[i].blocks.size() - 1;
		}
	}

	private byte[] byteRange(byte[] src, int offsetFrom, int length) {
		byte[] tmp = new byte[length];
		System.arraycopy(src, offsetFrom, tmp, 0, length);
		return tmp;
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
		ptr.set_addrOfBlock((short) blocks.indexOf(addrOfBlock));
		ptr.set_destBlock((short) blocks.indexOf(destBlock));
		ptr.set_destOffset((short) destOffset);
		ptr.set_blockArray(BPP_PTR);
		pointers.add(ptr);
	}

	protected void addArray(BigPackBlock addrOfBlock, BigPackBlock destBlock,
			int destOffset) {
		BigPackPtr ptr = new BigPackPtr();
		ptr.set_addrOfBlock((short) blocks.indexOf(addrOfBlock));
		ptr.set_destBlock((short) blocks.indexOf(destBlock));
		ptr.set_destOffset((short) destOffset);
		ptr.set_blockArray(BPP_ARRAY);
		pointers.add(ptr);
	}

	public int numBlocks() {
		return blocks.size();
	}

	public int numPointers() {
		return pointers.size();
	}

	/**
	 * Returns the "complete" data stream which is: 1. Data for each block 2. Data
	 * for each pointer 3. Actual data payload
	 */
	public byte[] dataStream() {
		byte[] stream = new byte[BigPackBlock.DEFAULT_MESSAGE_SIZE * blocks.size()
				+ BigPackPtr.DEFAULT_MESSAGE_SIZE * pointers.size() + data_length];
		int offset = 0;
		BigPackBlock blks[] = (BigPackBlock[]) blocks.toArray(new BigPackBlock[0]);
		for (int b = 0; b < blks.length; b++) {
			System.arraycopy(blks[b].dataGet(), 0, stream, offset,
					BigPackBlock.DEFAULT_MESSAGE_SIZE);
			offset += BigPackBlock.DEFAULT_MESSAGE_SIZE;
		}
		BigPackPtr ptrs[] = (BigPackPtr[]) pointers.toArray(new BigPackPtr[0]);
		for (int b = 0; b < ptrs.length; b++) {
			System.arraycopy(ptrs[b].dataGet(), 0, stream, offset,
					BigPackPtr.DEFAULT_MESSAGE_SIZE);
			offset += BigPackPtr.DEFAULT_MESSAGE_SIZE;
		}
		System.arraycopy(data, 0, stream, offset, data_length);
		return stream;
	}

}