/**
 * Adds support for sending and receiving BigPack data to
 * each mote.
 * @author Ryan Stinnett
 */
package edu.rice.compass.bigpack;

import java.util.*;
import edu.rice.compass.comm.*;

public class PackerMote extends Mote implements PackerHost {

	private Unpacker unpacker = new Unpacker(this);
	private Packer packer = new Packer(this);
	private ProtoPacker curPacker;

	private Hashtable packApps = new Hashtable();

	public PackerMote(int mID) {
		super(mID);
		curPacker = packer;
		curPacker.enable();
	}

	public void setPackerApp(short pType, PackerMoteApp app) {
		Integer type = new Integer(pType);
		packApps.put(type, app);
	}

	public BigPack buildPack(short type) {
		PackerMoteApp pa = (PackerMoteApp) packApps.get(new Integer(type));
		if (pa == null)
			return null;
		BigPack bp = pa.buildPack();
		if (bp == null)
			return null;
		return bp;
	}

	public void unpackerDone(BigPack msg) {
		switchPacker(packer);
		PackerMoteApp pa = (PackerMoteApp) packApps.get(new Integer(msg.getType()));
		if (pa == null)
			return;
		pa.unpackerDone(msg);
	}

	public void packerDone(short type) {
		PackerMoteApp pa = (PackerMoteApp) packApps.get(new Integer(type));
		if (pa == null)
			return;
		pa.packerDone();
	}

	public boolean switchPacker(ProtoPacker newPacker) {
		if (curPacker.getBusy()) {
			System.out.println("Current packer is busy!");
			return false;
		}
		if (curPacker != newPacker) {
			curPacker.disable();
			curPacker = newPacker;
			curPacker.enable();
		}
		return true;
	}

	public boolean requestPack(short mType) {
		if (switchPacker(unpacker)) {
			unpacker.newRequest(mType);
			return true;
		}
		System.out.println("Request failed!");
		return false;
	}
}