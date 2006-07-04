/**
 * Holds elements common to both Unpacker and Packer classes.
 * @author Ryan Stinnett
 */

package edu.rice.compass.bigpack;

import net.tinyos.message.*;
import edu.rice.compass.comm.*;

abstract class ProtoPacker implements MessageListener {
	
	protected static final short HEADER_PACK_NUM = -1;

	protected short type;
	protected int numPacks;
	protected int numBlocks;
	protected int numPtrs;
	protected byte[] stream;
	protected short curPackNum;
	
	protected PackerHost owner;
	protected boolean busy = false;
	
	protected ProtoPacker(PackerHost mOwner) {
		owner = mOwner;
		owner.getMoteCom().registerListener(new UnicastPack(), this);
	}

	protected boolean morePacksExist() {
		if (curPackNum + 1 >= numPacks)
			return false;
		return true;
	}
	
	public boolean getBusy() {
		return busy;
	}
	
	public void close() {
		owner.getMoteCom().deregisterListener(new UnicastPack(), this);
	}

}