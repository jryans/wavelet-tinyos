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

	private static Hashtable packApps = new Hashtable();

	public PackerMote(int mID) {
		super(mID);
		curPacker = packer;
		curPacker.enable();
	}

	public static void setPackApp(BigPack tPack, PackerApp app) {
		Integer type = new Integer(tPack.getType());
		packApps.put(type, app);
	}

	public BigPack buildPack(short type) {
		PackerApp pa = (PackerApp) packApps.get(new Integer(type));
		if (pa == null)
			return null;
		BigPack bp = pa.buildPack(id);
		if (bp == null)
			return null;
		return bp;
	}

	public void unpackerDone(BigPack msg) {
		switchPacker(packer);
		PackerApp pa = (PackerApp) packApps.get(new Integer(msg.getType()));
		if (pa == null)
			return;
		pa.unpackerDone(msg, id);
	}

	public void packerDone(short type) {
		PackerApp pa = (PackerApp) packApps.get(new Integer(type));
		if (pa == null)
			return;
		pa.packerDone(id);
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

	public boolean requestPack(BigPack msg) {
		if (switchPacker(unpacker)) {
			unpacker.newRequest(msg);
			return true;
		}
		return false;
	}
}