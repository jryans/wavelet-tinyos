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

	/* Transform Types */
	// 2D spatial R. Wagner
	private static final short WS_TT_2DRWAGNER = 0;
	// 1D time Haar -> 2D spatial R. Wagner
	private static final short WS_TT_1DHAAR_2DRWAGNER = 1;
	// 1D time linear -> 2D spatial R. Wagner
	private static final short WS_TT_1DLINEAR_2DRWAGNER = 2;

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

	public int getMaxScale() {
		return maxScale;
	}

	public void configMotes() {
		System.out.println("Wavelet config starting");
		new Timer().scheduleAtFixedRate(new ConfigPulse(mote), 200, 300);
	}

	public void runSets() {
		new WaveletData(numSets, mote.size());
		startDataSet();
		System.out.println("Sent start command!");
	}

	private void startDataSet() {
		if (compRes) {
			WaveletState ws = CompassMote.broadcast.makeState();
			setStateOptions(ws);
			ws.send();
			ws = CompassMote.broadcast.makeState();
			ws.state(CompassMote.S_START_DATASET);
			ws.compTarget(new float[] { 400, 200 });
			ws.send();
		} else {
			WaveletState ws = CompassMote.broadcast.makeState();
			ws.state(CompassMote.S_START_DATASET);
			setStateOptions(ws);
			ws.send();
		}
	}

	private void setStateOptions(WaveletState ws) {
		if (!compRes)
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

	public void setDataSetTime(long dataSetTime) {
		this.dataSetTime = dataSetTime;
	}

	public void setResultType(boolean raw, boolean comp) {
		rawRes = raw;
		compRes = comp;
	}

	public void setTimeDomainLength(short timeDomainLength) {
		this.timeDomainLength = timeDomainLength;
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

}