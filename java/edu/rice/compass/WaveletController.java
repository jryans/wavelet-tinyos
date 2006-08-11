/**
 * Responsible for managing much of the wavelet transform process on the motes,
 * as well as providing various related utilities to other classes.
 * @author Ryan Stinnett
 */
package edu.rice.compass;

import java.util.*;

import edu.rice.compass.CompassMote.*;

public class WaveletController {

	/* Variables */
	private Vector mote = new Vector();
	private WaveletConfigData wc;
	private int maxScale = 0;

	/* Transform Options */
	private int numSets; // Number of data sets
	private long dataSetTime; // Length of time between data sets (and samples)
	private short transformType; // One of various transform types
	private boolean rawRes;
	private boolean compRes;
	// Number of data points collected for TD transform
	private short timeDomainLength;
	private short maxBand;

	/* Transform Types */
	// 2D spatial R. Wagner
	private static final short WS_TT_2DRWAGNER = 0;
	// 1D time Haar -> 2D spatial R. Wagner
	private static final short WS_TT_1DHAAR_2DRWAGNER = 1;
	// 1D time linear -> 2D spatial R. Wagner
	private static final short WS_TT_1DLINEAR_2DRWAGNER = 2;

	/* Transmit Options */
	// Number of transmit slots (must be power of 2)
	private static final short WT_SLOTS = 8;
	// Length of one slot (bms)
	private static final long WT_SLOT_TIME = 50;
	// Maximum number of compression bands
	private static final short WT_MAX_BANDS = 5;
	// Length of entire slot stage (bms)
	private static final long WT_SLOT_STAGE_TIME = WT_SLOTS * WT_SLOT_TIME;
	// Length of wait time after sending one band of data in compressed mode (bms)
	private static final long WT_WAIT_STAGE_TIME = 2000;
	// Length of an entire compression band (bms)
	private static final long WT_BAND_TIME = WT_SLOT_STAGE_TIME
			+ WT_WAIT_STAGE_TIME;

	public WaveletController(WaveletConfigData mWC) {
		wc = mWC;
		buildMotes(); // Create each mote's config data and the mote itself
	}

	private void buildMotes() {
		// Find max scale
		for (int i = 0; i < wc.mScale.length; i++)
			if (wc.mScale[i] > maxScale)
				maxScale = (int) wc.mScale[i];
		// Build each mote
		for (int i = 0; i < wc.mScale.length; i++)
			mote.add(new CompassMote(i + 1, wc));
	}

	public void configMotes() {
		System.out.println("Wavelet config starting");
		new Timer().scheduleAtFixedRate(new ConfigPulse(mote), 200, 300);
	}

	public void runSets() {
		new WaveletData(numSets, mote.size());
		startTransform();
	}

	private void startTransform() {
		// Uncompressed transform uses a single S_START_DATASET
		// broadcast that includes transform options to start a loop of data sets
		// without further control by the sink.
		// Compressed transform first sends transform options, but with no state
		// attached. At the start of each data set, a S_START_DATASET broadcast
		// is sent with updated target band values.
		if (compRes) {
			WaveletState ws = CompassMote.broadcast.makeState();
			setTransformOptions(ws);
			ws.send();
			new Timer().scheduleAtFixedRate(new StartCompDataSet(), 500,
					calcBandEnding());
		} else {
			startDataSet();
		}
		System.out.println("Starting transform!");
	}

	private long calcBandEnding() {
		long bms = dataSetTime + maxBand * WT_BAND_TIME + WT_SLOT_STAGE_TIME + 1000;
		return (long) (1.024 * bms);
	}

	private void startDataSet() {
		WaveletState ws = CompassMote.broadcast.makeState();
		ws.state(CompassMote.S_START_DATASET);
		if (compRes) {
			ws.compTarget(new float[] { 400, 200, 0 });
		} else {
			setTransformOptions(ws);
		}
		ws.send();
	}

	private void setTransformOptions(WaveletState ws) {
		ws.dataSetTime(dataSetTime);
		ws.transformType(transformType);
		ws.resultType(rawRes, compRes);
		if (transformType == WS_TT_1DHAAR_2DRWAGNER
				|| transformType == WS_TT_1DLINEAR_2DRWAGNER)
			ws.timeDomainLength(timeDomainLength);
	}

	public void setNumSets(int numSets) {
		this.numSets = numSets;
	}

	public void setDataSetTime(long setLength, boolean force) {
		if (!force) {
			long minSetLen = 5000 + 3000 * (maxScale - 1);
			if (setLength < minSetLen) {
				if (setLength != 0) {
					System.out.println("Set length "
							+ setLength
							+ " is smaller than "
							+ minSetLen
							+ ", the minimum time required for the motes to process this data set.");
					System.out.println("Using minimum time, run with --force if you want to ignore this.");
				}
				setLength = minSetLen;
			}
		}
		dataSetTime = setLength;
	}

	public void setTransformType(String transformName) {
		if (transformName.equals("2DRWAGNER")) {
			transformType = WS_TT_2DRWAGNER;
		} else if (transformName.equals("1DHAAR_2DRWAGNER")) {
			transformType = WS_TT_1DHAAR_2DRWAGNER;
		} else if (transformName.equals("1DLINEAR_2DRWAGNER")) {
			transformType = WS_TT_1DLINEAR_2DRWAGNER;
		} else {
			System.out.println("Unknown transform type!");
			System.exit(1);
		}
	}

	public void setResultType(boolean raw, boolean comp) {
		rawRes = raw;
		compRes = comp;
	}

	public void setTimeDomainLength(short timeDomainLength) {
		this.timeDomainLength = timeDomainLength;
	}

	public void setMaxBand(short maxBand) {
		this.maxBand = maxBand;
	}

	class ConfigPulse extends TimerTask {

		private Enumeration moteEnum;
		private Vector mote;

		public ConfigPulse(Vector mMote) {
			mote = mMote;
			moteEnum = mote.elements();
		}

		public void run() {
			if (moteEnum.hasMoreElements()) { // More motes to configure
				CompassMote cm = (CompassMote) moteEnum.nextElement();
				cm.sendStartup();
			} else { // Wait for all motes to finish
				Enumeration waitEnum = mote.elements();
				boolean allDone = true;
				while (waitEnum.hasMoreElements()) {
					CompassMote cm = (CompassMote) waitEnum.nextElement();
					if (!cm.isConfigDone()) {
						allDone = false;
						break;
					}
				}
				if (allDone) {
					System.out.println("Wavelet config complete");
					runSets();
					cancel();
				}
			}
		}

	}

	class StartCompDataSet extends TimerTask {

		boolean setEnded = false;

		public void run() {
			if (setEnded) {
				System.out.println("Reached end of band " + maxBand
						+ ", starting next data set.");
			} else {
				setEnded = true;
			}
			startDataSet();
		}

	}

}