/**
 * Stores constants shared between the various Wavelet classes.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

public class Wavelet {
	
	/* Wavelet Config */
	static final short WT_MOTE_PER_CONFDATA = 3;
	
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
	static final short MOTECOMMAND = 0;
	//static final short RAWDATA = 1;
	static final short WAVELETDATA = 1;
	static final short WAVELETCONFDATA = 2;
	static final short WAVELETCONFHEADER = 3;
	static final short WAVELETSTATE = 4;
	static final short MOTESTATS = 5;
	
	/* Sensors */
	static final short TEMP = 0;
	static final short LIGHT = 1;
	static final short WT_SENSORS = 2;
	
	/* Offsets */
	static final short RAW_OFFSET = 0;
	static final short WT_OFFSET = 1;
	
	/* Stats Report Types */
	static final short WT_CACHE = 0;

}
