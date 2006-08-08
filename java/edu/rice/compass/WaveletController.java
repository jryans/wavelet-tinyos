/**
 * Responsible for managing much of the wavelet transform process on the motes,
 * as well as providing various related utilities to other classes.
 * @author Ryan Stinnett
 */
package edu.rice.compass;

import java.util.*;

public class WaveletController {

	/* Variables */
	private Vector mote = new Vector();
	private WaveletConfigData wc;
	private int maxScale = 0;

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

	public void runSets(int numSets) {
		new WaveletData(numSets, mote.size());
		CompassMote.broadcast.startDataSet();
		System.out.println("Sent start command!");
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
				CompassTools.main.configDone();
				cancel();
			}
		}
	}

}