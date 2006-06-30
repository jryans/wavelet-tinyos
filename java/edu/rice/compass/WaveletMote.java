/**
 * Transforms MATLAB data matrices into config data for each mote
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.util.*;

import edu.rice.compass.bigpack.*;

public class WaveletMote {

	private Packer packer = new Packer();
	Unpacker unpacker;

	private int id; // ID number of the mote represented
	private short state[]; // Mote's state at each scale level that it is used in
	// This could easily be less than total number of levels

	private boolean configDone;

	// Tracks data reception from each mote
	private boolean rawDone;
	private boolean resultDone;

	public WaveletMote(int id) {
		this.id = id;
		configDone = true;
	}
	
	public WaveletMote(int id, WaveletConfig wc) {
		this.id = id;
		configDone = false;
		dataTransform(wc);
	}

	private void dataTransform(WaveletConfig wc) {
		WaveletNeighbor neighbors[][];
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
			state[predLevel - 1] = Wavelet.S_PREDICTING;
		} else {
			for (lastUpdLevel = maxLevel - 1; lastUpdLevel >= 0; lastUpdLevel--) {
				if (updInfo[lastUpdLevel].size() != 0)
					break;
			}
			// If lastUpdLevel is -1, then the mote never updates or predicts.
			// Otherwise, we now know how many levels the mote is used in.
			if (lastUpdLevel < 0) {
				state = new short[1];
				state[0] = Wavelet.S_DONE;
			} else {
				state = new short[lastUpdLevel + 1];
				state[lastUpdLevel] = Wavelet.S_UPDATING;
			}
		}
		// Allocate neighbors array now that the number of states is known
		neighbors = new WaveletNeighbor[state.length][];
		// Now we'll go through and stamp a state on each of the
		// remaining levels and assemble the neighbors array.
		for (int levelIdx = 0; levelIdx < state.length; levelIdx++) {
			if (state[levelIdx] == 0) {
				if (updInfo[levelIdx].size() == 0) {
					state[levelIdx] = Wavelet.S_SKIPLEVEL;
				} else {
					state[levelIdx] = Wavelet.S_UPDATING;
				}
			}
			switch (state[levelIdx]) {
			case Wavelet.S_DONE:
			case Wavelet.S_SKIPLEVEL:
				// First entry about ourselves
				neighbors[levelIdx] = new WaveletNeighbor[] { new WaveletNeighbor(id,
						Wavelet.S_SKIPLEVEL, 0) };
				break;
			case Wavelet.S_UPDATING:
				neighbors[levelIdx] = new WaveletNeighbor[updInfo[levelIdx].size() + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new WaveletNeighbor(id, Wavelet.S_UPDATING, 0);
				for (int nb = 0; nb < updInfo[levelIdx].size(); nb++) {
					UpdateNB curNb = (UpdateNB) updInfo[levelIdx].get(nb);
					// For nb of an update node, look up the coeff based on:
					// Dim 1: ID of predict node, Dim 2: Index in predict nb
					// list
					double[] nbCoeff = (double[]) wc.mUpdCoeff[curNb.predID];
					neighbors[levelIdx][nb + 1] = new WaveletNeighbor(curNb.predID + 1,
							Wavelet.S_UPDATING, (float) nbCoeff[curNb.coeffIndex]);
				}
				break;
			case Wavelet.S_PREDICTING:
				double[] predNb = (double[]) wc.mPredNB[id - 1];
				double[] predCoeff = (double[]) wc.mPredCoeff[id - 1];
				neighbors[levelIdx] = new WaveletNeighbor[predNb.length + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new WaveletNeighbor(id, Wavelet.S_PREDICTING,
						0);
				for (int nb = 0; nb < predNb.length; nb++)
					neighbors[levelIdx][nb + 1] = new WaveletNeighbor((int) predNb[nb],
							Wavelet.S_PREDICTING, (float) predCoeff[nb]);
				break;
			}
		}
		setupPacker(neighbors);
	}

	public void setupPacker(WaveletNeighbor[][] neighbors) {
		WaveletLevel[] lvl = new WaveletLevel[neighbors.length];
		for (int l = 0; l < lvl.length; l++)
			lvl[l] = new WaveletLevel(neighbors[l]);
		packer.setMessage(new WaveletConf(lvl));
	}

	public UnicastPack getHeader() {
		UnicastPack pack = packer.getHeader();
		pack.set_data_dest(id);
		return pack;
	}

	public UnicastPack getData(int packNum) {
		UnicastPack pack = packer.getData(packNum);
		pack.set_data_dest(id);
		return pack;
	}

	public MoteStats extractData() {
		MoteStats stats = (MoteStats) unpacker.unpack();
		return stats;
	}
	
	public MoteOptions makeOptions() {
		return new MoteOptions();
	}

	/**
	 * Controls various mote-wide options
	 */
	class MoteOptions {
		/* Bitmasks */
		private static final short MO_DIAGMODE = 0x01;
		private static final short MO_RFPOWER = 0x02;
		private static final short MO_CLEARSTATS = 0x04;
		private static final short MO_RFACK = 0x08;

		// TODO: Shouldn't be public!
		public UnicastPack pack = new UnicastPack();

		private MoteOptions() {
			pack.set_data_dest(id);
			pack.set_data_type(Wavelet.MOTEOPTIONS);
		}

		public void diagMode(boolean diag) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_DIAGMODE));
			pack.set_data_data_opt_diagMode(Wavelet.b2Cs(diag));
		}

		public void rfPower(int power) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RFPOWER));
			pack.set_data_data_opt_rfPower((short) power);
		}

		public void clearStats() {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_CLEARSTATS));
		}

		public void rfAck(boolean ack) {
			pack.set_data_data_opt_mask((short) (pack.get_data_data_opt_mask() | MO_RFACK));
			pack.set_data_data_opt_diagMode(Wavelet.b2Cs(ack));
		}

		// TODO: Will be used in the future!
		public void send() {

		}
	}

	public int getNumPacks() {
		return packer.getNumPacks();
	}
	
	public int getNumScales() {
		return state.length;
	}

	public boolean isRawDone() {
		return rawDone;
	}

	public void setRawDone(boolean rawDone) {
		this.rawDone = rawDone;
	}

	public boolean isResultDone() {
		return resultDone;
	}

	public void setResultDone(boolean resultDone) {
		this.resultDone = resultDone;
	}

	public boolean isConfigDone() {
		return configDone;
	}

	public boolean isConfigDone(int curPack) {
		configDone = !packer.morePacksExist(curPack);
		return configDone;
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
