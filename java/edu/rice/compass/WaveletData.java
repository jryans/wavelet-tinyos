package edu.rice.compass;

import edu.rice.compass.comm.*;
import net.tinyos.message.*;

public class WaveletData implements MessageListener {

	/* Sensors */
	private static final short TEMP = 0;
	private static final short LIGHT = 1;
	static final short WT_SENSORS = 2;

	/* Offsets */
	private static final short RAW_OFFSET = 0;
	private static final short WT_OFFSET = 1;

	public float value[][][]; // value[dataset][sensor][mote]
	private DataCheck check;
	private int curSet;

	public WaveletData() {}
	
	public WaveletData(int sets, int motes) {
		value = new float[sets][2 * WT_SENSORS][motes];
		check = new DataCheck(sets, motes);
		curSet = 0;
		MoteCom.singleton.registerListener(new UnicastPack(), this);
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		if (pack.get_data_type() == CompassMote.WAVELETDATA) {
			int id = pack.get_data_src();
			// Check if data is from the next set
			setCheck(pack.get_data_data_wData_dataSet() - 1);
			// Store mote data
			if (pack.get_data_data_wData_state() == CompassMote.S_DONE) {
				value[curSet][TEMP * 2 + WT_OFFSET][id - 1] = pack.getElement_data_data_wData_value(TEMP);
				value[curSet][LIGHT * 2 + WT_OFFSET][id - 1] = pack.getElement_data_data_wData_value(LIGHT);
				System.out.println("Got wavelet data from mote " + id);
				check.setWaveletDone(id);
			} else if (pack.get_data_data_wData_state() == CompassMote.S_RAW) {
				value[curSet][TEMP * 2 + RAW_OFFSET][id - 1] = pack.getElement_data_data_wData_value(TEMP);
				value[curSet][LIGHT * 2 + RAW_OFFSET][id - 1] = pack.getElement_data_data_wData_value(LIGHT);
				System.out.println("Got raw data from mote " + id);
				check.setRawDone(id);
			}
		}
	}

	private synchronized void setCheck(int msgSet) {
		if (msgSet > curSet)
			nextSet();
	}

	private synchronized void nextSet() {
		int[] mLeft = check.isDataDone();
		if (mLeft[RAW_OFFSET] == 0 && mLeft[WT_OFFSET] == 0) {
			System.out.println("Data set " + (curSet + 1) + " complete!");
		} else {
			System.out.println("Data set " + (curSet + 1) + " incomplete, missing "
					+ mLeft[RAW_OFFSET] + " raw and " + mLeft[WT_OFFSET]
					+ " wavelet.");
		}
		if (++curSet < value.length) {
			//clearDataCheck();
		} else {
			CompassMote.broadcast.sendStop();
			CompassTools.saveResult(this, "waveletData.xml");
		}
	}

	class DataCheck {

		boolean dataDone[][][];

		private DataCheck(int sets, int motes) {
			dataDone = new boolean[sets][motes][2];
			clearDataCheck();
		}

		private void clearDataCheck() {
			for (int s = 0; s < dataDone.length; s++) {
				for (int m = 0; m < dataDone[s].length; m++) {
					dataDone[s][m][RAW_OFFSET] = false;
					dataDone[s][m][WT_OFFSET] = false;
				}
			}
		}

		private void setRawDone(int m) {
			dataDone[curSet][m - 1][RAW_OFFSET] = true;
		}

		private void setWaveletDone(int m) {
			dataDone[curSet][m - 1][WT_OFFSET] = true;
		}
		
		private int[] isDataDone() {
			int[] dataCheck = new int[2];
			for (int m = 0; m < dataDone[curSet].length; m++) {
				if (!dataDone[curSet][m][RAW_OFFSET])
					dataCheck[RAW_OFFSET]++;
				if (!dataDone[curSet][m][WT_OFFSET])
					dataCheck[WT_OFFSET]++;
			}
			return dataCheck;
		}

	}
}
