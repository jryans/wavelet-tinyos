/**
 * Adds message processing specific to each Compass mote, such as
 * support for reading stats data from a mote.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.io.*;
import java.util.*;
import edu.rice.compass.bigpack.*;
import edu.rice.compass.comm.*;

public class CompassMote extends PackerMote {

	/* Message Types */
	public static final short MOTEOPTIONS = 0;
	public static final short WAVELETDATA = 1;
	public static final short BIGPACKHEADER = 2;
	public static final short BIGPACKDATA = 3;
	public static final short WAVELETSTATE = 4;
	public static final short ROUTERDATA = 5;

	/* Wavelet Mote States */
	static final short S_IDLE = 0;
	static final short S_STARTUP = 1;
	static final short S_START_DATASET = 2;
	static final short S_READING_SENSORS = 3;
	static final short S_UPDATING = 4;
	static final short S_PREDICTING = 5;
	static final short S_PREDICTED = 7;
	static final short S_UPDATED = 8;
	static final short S_SKIPLEVEL = 9;
	static final short S_DONE = 10;
	static final short S_OFFLINE = 11;
	static final short S_ERROR = 12;
	static final short S_RAW = 13;

	private WaveletConf wConf;
	private boolean configDone = false;

	public CompassMote(int mID, WaveletConfigData wc) {
		this(mID);
		wConf = dataTransform(wc);
		setPackerApp(WaveletConf.getType(), makeWaveletConfApp(wConf));
	}

	public CompassMote(int mID) {
		super(mID);
		setPackerApp(MoteStats.getType(), makeStatsApp(mID));
	}

	private PackerMoteApp makeStatsApp(final int mote) {
		return new PackerMoteApp() {
			public void unpackerDone(BigPack msg) {
				MoteStats stats = (MoteStats) msg;
				System.out.println("Stats for Mote " + mote + ":");
				stats.printStats();
				CompassTools.main.saveResult(msg, "stats.xml");
			}
		};
	}

	private PackerMoteApp makeWaveletConfApp(final WaveletConf conf) {
		return new PackerMoteApp() {
			public BigPack buildPack() {
				return conf;
			}

			public void packerDone() {
				setConfigDone(true);
			}
		};
	}

	public boolean getStats() {
		System.out.println("Requesting stats from mote " + id);
		return requestPack(MoteStats.getType());
	}

	private UnicastPack makeStatePack(short newState) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(newState);
		return pack;
	}

	public void sendStartup() {
		UnicastPack pack = makeStatePack(S_STARTUP);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void forceStop() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_OFFLINE);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendPing() {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type((short) 20);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void startDataSet(long setLength) {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_START_DATASET);
		pack.set_data_data_wState_dataSetTime(setLength);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void sendRouterLink(int mote, boolean enable) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(ROUTERDATA);
		pack.set_data_data_rData_enable(b2Cs(enable));
		pack.set_data_data_rData_mote(mote);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/* C Boolean */
	private static final short C_FALSE = 0;
	private static final short C_TRUE = 1;

	/* C Type Helpers */
	private static short b2Cs(boolean b) {
		if (b)
			return C_TRUE;
		return C_FALSE;
	}

	public MoteOptions makeOptions() {
		return new MoteOptions();
	}

	/**
	 * Controls various mote-wide options
	 */
	public class MoteOptions {

		/* Bitmasks */
		private static final short MO_DIAGMODE = 0x01;
		private static final short MO_TXPOWER = 0x02;
		private static final short MO_CLEARSTATS = 0x04;
		private static final short MO_RFACK = 0x08;
		private static final short MO_RADIOOFFTIME = 0x10;
		private static final short MO_HPLPM = 0x20;
		private static final short MO_RFCHAN = 0x40;

		private UnicastPack pack = new UnicastPack();

		private MoteOptions() {
			pack.set_data_type(MOTEOPTIONS);
		}

		public void diagMode(boolean diag) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_DIAGMODE));
			pack.set_data_data_opt_diagMode(b2Cs(diag));
		}

		public void txPower(int power) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_TXPOWER));
			pack.set_data_data_opt_txPower((short) power);
		}

		public void clearStats() {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_CLEARSTATS));
		}

		public void rfAck(boolean ack) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RFACK));
			pack.set_data_data_opt_diagMode(b2Cs(ack));
		}

		public void radioOffTime(int time) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RADIOOFFTIME));
			pack.set_data_data_opt_radioOffTime(time);
		}

		public void hplPM(boolean pm) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_HPLPM));
			pack.set_data_data_opt_hplPM(b2Cs(pm));
		}

		public void rfChan(int chan) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RFCHAN));
			pack.set_data_data_opt_rfChan((short) chan);
		}

		public void send() {
			try {
				sendPack(pack);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	// TODO: Change to use scale, not level!
	private WaveletConf dataTransform(WaveletConfigData wc) {
		WaveletNeighbor neighbors[][];
		short state[];
		int predLevel, lastUpdLevel;
		int maxLevel = 0;
		// Find the level at which this mote predicts, if any
		predLevel = (int) wc.mScale[id - 1];
		// Find motes that we are a predict neighbor for
		// i.e. we update when they predict
		for (int mote = 0; mote < wc.mScale.length; mote++) {
			if (wc.mScale[mote] > maxLevel)
				maxLevel = (int) wc.mScale[mote];
		}
		Vector updInfo[] = new Vector[maxLevel];
		for (int level = 0; level < maxLevel; level++)
			updInfo[level] = new Vector();
		// updInfo holds one Vector for each possible scale.
		// The Vectors will hold two numbers each time we find we are
		// someone's predict neighbor: the predict mote's id,
		// and the index of our position in their neighbor list.
		for (int mote = 0; mote < wc.mScale.length; mote++) {
			if (wc.mScale[mote] != 0) {
				double curNbs[] = (double[]) wc.mPredNB[mote];
				for (int nb = 0; nb < curNbs.length; nb++) {
					if (curNbs[nb] == id)
						updInfo[(int) wc.mScale[mote] - 1].add(new UpdateNB(mote, nb));
				}
			}
		}
		// If this mote predicts (predLevel != 0) then that level is
		// its last level. Otherwise, we find the last level it updates.
		if (predLevel != 0) {
			state = new short[predLevel];
			state[predLevel - 1] = S_PREDICTING;
		} else {
			for (lastUpdLevel = maxLevel - 1; lastUpdLevel >= 0; lastUpdLevel--) {
				if (updInfo[lastUpdLevel].size() != 0)
					break;
			}
			// If lastUpdLevel is -1, then the mote never updates or predicts.
			// Otherwise, we now know how many levels the mote is used in.
			if (lastUpdLevel < 0) {
				state = new short[1];
				state[0] = S_DONE;
			} else {
				state = new short[lastUpdLevel + 1];
				state[lastUpdLevel] = S_UPDATING;
			}
		}
		// Allocate neighbors array now that the number of states is known
		neighbors = new WaveletNeighbor[state.length][];
		// Now we'll go through and stamp a state on each of the
		// remaining levels and assemble the neighbors array.
		for (int levelIdx = 0; levelIdx < state.length; levelIdx++) {
			if (state[levelIdx] == 0) {
				if (updInfo[levelIdx].size() == 0) {
					state[levelIdx] = S_SKIPLEVEL;
				} else {
					state[levelIdx] = S_UPDATING;
				}
			}
			switch (state[levelIdx]) {
			case S_DONE:
			case S_SKIPLEVEL:
				// First entry about ourselves
				neighbors[levelIdx] = new WaveletNeighbor[] { new WaveletNeighbor(id,
						S_SKIPLEVEL, 0) };
				break;
			case S_UPDATING:
				neighbors[levelIdx] = new WaveletNeighbor[updInfo[levelIdx].size() + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new WaveletNeighbor(id, S_UPDATING, 0);
				for (int nb = 1; nb < neighbors[levelIdx].length; nb++) {
					// Choose neighbors randomly, to increase chances that other
					// nodes won't have them in the same order.
					UpdateNB curNb = (UpdateNB) updInfo[levelIdx].remove((int) (Math.random() * updInfo[levelIdx].size()));
					// For nb of an update node, look up the coeff based on:
					// Dim 1: ID of predict node, Dim 2: Index in predict nb
					// list
					double[] nbCoeff = (double[]) wc.mUpdCoeff[curNb.predID];
					neighbors[levelIdx][nb] = new WaveletNeighbor(curNb.predID + 1,
							S_UPDATING, (float) nbCoeff[curNb.coeffIndex]);
				}
				break;
			case S_PREDICTING:
				double[] predNb = (double[]) wc.mPredNB[id - 1];
				double[] predCoeff = (double[]) wc.mPredCoeff[id - 1];
				neighbors[levelIdx] = new WaveletNeighbor[predNb.length + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new WaveletNeighbor(id, S_PREDICTING, 0);
				for (int nb = 0; nb < predNb.length; nb++)
					neighbors[levelIdx][nb + 1] = new WaveletNeighbor((int) predNb[nb],
							S_PREDICTING, (float) predCoeff[nb]);
				break;
			}
		}
		WaveletLevel[] lvl = new WaveletLevel[neighbors.length];
		for (int l = 0; l < lvl.length; l++)
			lvl[l] = new WaveletLevel(neighbors[l]);
		return new WaveletConf(lvl);
	}

	public boolean isConfigDone() {
		return configDone;
	}

	private void setConfigDone(boolean configDone) {
		this.configDone = configDone;
	}

}

class UpdateNB {
	int predID;
	int coeffIndex;

	UpdateNB(int predID, int coeffIndex) {
		this.predID = predID;
		this.coeffIndex = coeffIndex;
	}
}
