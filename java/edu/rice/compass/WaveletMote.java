/**
 * Transforms MATLAB data matrices into config data for each mote
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.util.*;

public class WaveletMote {
	
	private int id; // ID number of the mote represented
	
	// Possible States
	static final short S_PREDICTING = 5;
	static final short S_UPDATING = 4;
	static final short S_SKIPLEVEL = 9;
	static final short S_DONE = 10;
	
	short state[]; // Mote's state at each scale level that it is used in
                   // This could easily be less than total number of levels

  // Array indices: nbs[level][nb_index]
	NeighborInfo neighbors[][]; // Mote's neighbors during each state
    
	public WaveletMote(int id, WaveletConfig wc) {
		this.id = id;
		dataTransform(wc);
	}
	
	private void dataTransform(WaveletConfig wc) {
		int predLevel, lastUpdLevel;
		int maxLevel = 0;
		// Find the level at which this mote predicts, if any
		predLevel = (int)wc.mScale[id - 1];
		// Find motes that we are a predict neighbor for
		// i.e. we update when they predict
		for (int mote = 0; mote < wc.mScale.length; mote++) {
			if (wc.mScale[mote] > maxLevel)
				maxLevel = (int)wc.mScale[mote];
		}
		Vector updInfo[] = new Vector[maxLevel];
		// updInfo holds one Vector for each possible scale.
		// The Vectors will hold two numbers each time we find we are
		// someone's predict neighbor: the predict mote's id,
		// and the index of our position in their neighbor list.
		for (int mote = 0; mote < wc.mScale.length; mote++) {
			if (wc.mScale[mote] != 0) {
				double curNbs[] = (double[])wc.mPredNB[mote];
				for (int nb = 0; nb < curNbs.length; nb++) {
					if (curNbs[nb] == id)
						updInfo[(int)wc.mScale[mote] - 1].add(new UpdateNB(mote, nb));
				}
			}
		}
		// If this mote predicts (predLevel != 0) then that level is
		// its last level.  Otherwise, we find the last level it updates.
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
		neighbors = new NeighborInfo[state.length][];
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
				neighbors[levelIdx] = new NeighborInfo[] {new NeighborInfo(id, 0)};
				break;
			case S_UPDATING:
				neighbors[levelIdx] = new NeighborInfo[updInfo[levelIdx].size() + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new NeighborInfo(id, 0);
				for (int nb = 0; nb < updInfo[levelIdx].size(); nb++) {
					UpdateNB curNb = (UpdateNB)updInfo[levelIdx].get(nb);
					// For nb of an update node, look up the coeff based on:
					// Dim 1: ID of predict node, Dim 2: Index in predict nb list
					double[] nbCoeff = (double[])wc.mUpdCoeff[curNb.predID];
					neighbors[levelIdx][nb + 1] = 
						new NeighborInfo(curNb.predID, (float)nbCoeff[curNb.coeffIndex]);
				}
				break;
			case S_PREDICTING:
				double[] predNb = (double[])wc.mPredNB[id - 1];
				double[] predCoeff = (double[])wc.mPredCoeff[id - 1];
				neighbors[levelIdx] = new NeighborInfo[predNb.length + 1];
				// First entry about ourselves
				neighbors[levelIdx][0] = new NeighborInfo(id, 0);
				for (int nb = 0; nb < predNb.length; nb++)
					neighbors[levelIdx][nb + 1] =
						new NeighborInfo((int)predNb[nb], (float)predCoeff[nb]);
				break;
			}
		}
	}
	
	public String toString() {
		return state.toString() + "/n" + neighbors.toString();
	}

}

class NeighborInfo {
	int id;
	float coeff;
	NeighborInfo(int id, float coeff) {
		this.id = id;
		this.coeff = coeff;
	}
	
	public String toString() {
		return "ID: " + id + " Co: " + coeff;
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
