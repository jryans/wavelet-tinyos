/**
 * Stores constants shared between the various Wavelet classes.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

public class Wavelet {

	/* Wavelet States */
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

	/* Message Types */
	static final short MOTEOPTIONS = 0;
	static final short WAVELETDATA = 1;
	static final short BIGPACKHEADER = 2;
	static final short BIGPACKDATA = 3;
	static final short WAVELETSTATE = 4;
	static final short MOTESTATS = 5;

	/* Sensors */
	static final short TEMP = 0;
	static final short LIGHT = 1;
	static final short WT_SENSORS = 2;

	/* Offsets */
	static final short RAW_OFFSET = 0;
	static final short WT_OFFSET = 1;
	
	/* C Boolean */
	private static final short C_FALSE = 0;
	private static final short C_TRUE = 1;
	
	/* C Type Helpers */
	
	public static short b2Cs(boolean b) {
		if (b) return C_TRUE;
		return C_FALSE;
	}

}
