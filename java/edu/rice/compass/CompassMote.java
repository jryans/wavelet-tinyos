/**
 * Adds message processing specific to each Compass mote, such as
 * support for reading stats data from a mote.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.io.*;
import java.util.*;
import net.tinyos.message.*;
import edu.rice.compass.bigpack.*;
import edu.rice.compass.comm.*;

public class CompassMote extends PackerMote implements MessageListener {

	/* Message Types */
	public static final short MOTEOPTIONS = 0;
	public static final short WAVELETDATA = 1;
	public static final short BIGPACKHEADER = 2;
	public static final short BIGPACKDATA = 3;
	public static final short WAVELETSTATE = 4;
	public static final short ROUTERDATA = 5;
	public static final short PWRCONTROL = 6;
	public static final short COMPTIME = 7;

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

	public static CompassMote broadcast = new CompassMote(0) {
		public MoteOptions makeOptions() {
			return new MoteOptions(true);
		}

		public WaveletState makeState() {
			return new WaveletState(true);
		}
	};

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
				CompassTools.saveResult(msg, "stats.xml");
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

	public void sendStartup() {
		WaveletState ws = makeState();
		ws.state(S_STARTUP);
		ws.send();
	}

	public void sendStop() {
		WaveletState ws = makeState();
		ws.state(S_OFFLINE);
		ws.send();
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

	public void getCompileTime() {
		MoteCom.singleton.registerListener(new UnicastPack(), this);
		UnicastPack pack = new UnicastPack();
		pack.set_data_type(COMPTIME);
		try {
			sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		if (pack.get_data_type() == COMPTIME && pack.get_data_src() == id) {
			System.out.println("Compiled On: "
					+ new Date(pack.get_data_data_cTime() * 1000));
			System.exit(0);
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
		return new MoteOptions(false);
	}

	/**
	 * Controls various mote-wide options
	 */
	public class MoteOptions {

		/* Bitmasks */
		private static final short MO_PINGNUM = 0x01;
		private static final short MO_TXPOWER = 0x02;
		private static final short MO_CLEARSTATS = 0x04;
		private static final short MO_RFACK = 0x08;
		private static final short MO_RADIOOFFTIME = 0x10;
		private static final short MO_HPLPM = 0x20;
		private static final short MO_RFCHAN = 0x40;
		private static final short MO_RADIORETRIES = 0x80;

		private OptionsPack pack;
		boolean bcast;

		private MoteOptions(boolean broadcast) {
			bcast = broadcast;
			if (bcast) {
				pack = new BroadcastPack();
			} else {
				pack = new UnicastPack();
			}
			pack.set_data_type(MOTEOPTIONS);
		}

		public void pingNum(int num, int dest) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_PINGNUM));
			pack.set_data_data_opt_pingNum(num);
			pack.set_data_data_opt_radioOffTime(dest);
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
			pack.set_data_data_opt_rfAck(b2Cs(ack));
		}

		public void radioOffTime(int time) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RADIOOFFTIME));
			pack.set_data_data_opt_radioOffTime(time);
		}

		public void radioRetries(int retries) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RADIORETRIES));
			pack.set_data_data_opt_radioRetries((short) retries);
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
				if (bcast) {
					sendPack((BroadcastPack) pack);
				} else {
					sendPack((UnicastPack) pack);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	public PwrControl makePwrControl() {
		return new PwrControl();
	}

	/**
	 * Controls mote power cycle settings
	 */
	public class PwrControl {

		/* PM Modes */
		private static final short PM_SLEEP_ON_SILENCE = 0;
		private static final short PM_CHECK_SINK = 1;

		/* Defaults */
		private static final int MO_DEF_SLEEP = 2 * 1024;
		private static final int MO_DEF_WAKE = 60 * 1024;

		private UnicastPack pack = new UnicastPack();

		private PwrControl() {
			pack.set_data_type(PWRCONTROL);
			pack.set_data_data_pCntl_sleepInterval(MO_DEF_SLEEP);
			pack.set_data_data_pCntl_wakeUpInterval(MO_DEF_WAKE);
		}

		public void pmMode(String mode) {
			if (mode.equals("SOS")) {
				pack.set_data_data_pCntl_pmMode(PM_SLEEP_ON_SILENCE);
			} else if (mode.equals("CS")) {
				pack.set_data_data_pCntl_pmMode(PM_CHECK_SINK);
			}
		}

		public void awake(boolean awake) {
			pack.set_data_data_pCntl_stayAwake(b2Cs(awake));
		}

		public void sleepInterval(int sleep) {
			pack.set_data_data_pCntl_sleepInterval(sleep);
		}

		public void wakeInterval(int wake) {
			pack.set_data_data_pCntl_wakeUpInterval(wake);
		}

		public void reboot(boolean reboot) {
			pack.set_data_data_pCntl_reboot(b2Cs(reboot));
		}

		public void send() {
			try {
				sendPack(pack);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	public WaveletState makeState() {
		return new WaveletState(false);
	}

	/**
	 * Controls wavelet transform state and options
	 */
	public class WaveletState {

		/* Bitmasks */
		private static final short WS_STATE = 0x01;
		private static final short WS_DATASETTIME = 0x02;
		private static final short WS_TRANSFORMTYPE = 0x04;
		private static final short WS_RESULTTYPE = 0x08;
		private static final short WS_TIMEDOMAINLENGTH = 0x10;
		private static final short WS_COMPTARGET = 0x20;

		/* Result Masks */
		private static final short WS_RT_RAW = 0x01; // Raw values (off|on)
		private static final short WS_RT_COMP = 0x02; // Compression (off|on)

		private OptionsPack pack;
		private boolean bcast;

		private WaveletState(boolean broadcast) {
			bcast = broadcast;
			if (bcast) {
				pack = new BroadcastPack();
			} else {
				pack = new UnicastPack();
			}
			pack.set_data_type(WAVELETSTATE);
		}

		public void state(short state) {
			pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_STATE));
			pack.set_data_data_wState_state(state);
		}

		public void dataSetTime(long dataSetTime) {
			pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_DATASETTIME));
			pack.set_data_data_wState_data_opt_dataSetTime(dataSetTime);
		}

		public void transformType(short transformType) {
			pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_TRANSFORMTYPE));
			pack.set_data_data_wState_data_opt_transformType(transformType);
		}

		public void resultType(boolean raw, boolean comp) {
			short type = 0;
			if (raw)
				type |= WS_RT_RAW;
			if (comp)
				type |= WS_RT_COMP;
			resultType(type);
		}

		public void resultType(short resultType) {
			pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_RESULTTYPE));
			pack.set_data_data_wState_data_opt_resultType(resultType);
		}

		public void timeDomainLength(short timeDomainLength) {
			pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_TIMEDOMAINLENGTH));
			pack.set_data_data_wState_data_opt_timeDomainLength(timeDomainLength);
		}

		public void compTarget(float compTarget[]) {
			if (compTarget.length <= 5) {
				pack.set_data_data_wState_mask((short) (pack.get_data_data_wState_mask() | WS_RESULTTYPE));
				pack.set_data_data_wState_data_comp_numTargets((short)compTarget.length);
				pack.set_data_data_wState_data_comp_compTarget(compTarget);
			} else {
				System.out.println("Compression target array too large!");
				System.exit(1);
			}
		}

		public void send() {
			try {
				if (bcast) {
					sendPack((BroadcastPack) pack);
				} else {
					sendPack((UnicastPack) pack);
				}
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
				if (curNbs != null) {
					for (int nb = 0; nb < curNbs.length; nb++) {
						if (curNbs[nb] == id)
							updInfo[(int) wc.mScale[mote] - 1].add(new UpdateNB(mote, nb));
					}
				}
			}
		}
		// If this mote predicts (predLevel != 0) then that level is
		// its last level. Otherwise, we find the last level it updates.
		if (predLevel != 0) {
			state = new short[predLevel];
			// If it has no neighbors at predLevel, then it should really skip.
			if (wc.mPredNB[id - 1] != null) {
				state[predLevel - 1] = S_PREDICTING;
			} else {
				state[predLevel - 1] = S_SKIPLEVEL;
			}
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
				for (int nb = 1; nb < neighbors[levelIdx].length; nb++)
					neighbors[levelIdx][nb] = new WaveletNeighbor((int) predNb[nb - 1],
							S_PREDICTING, (float) predCoeff[nb - 1]);
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
