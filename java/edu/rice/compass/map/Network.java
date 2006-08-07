package edu.rice.compass.map;

import java.awt.*;
import java.awt.geom.*;
import java.io.*;
import java.util.*;

import com.thoughtworks.xstream.*;

import edu.rice.compass.*;
import edu.rice.compass.bigpack.*;

public class Network implements IMoteNetwork, IPaint {

	IStatus status;

	private XStream xs = new XStream();

	boolean networkLoaded = false;
	Vector mote = new Vector();
	Mote selectedMote = null;

	public Network(IStatus aStatus) {
		status = aStatus;
	}

	public void loadNetwork(File netConfig) {
		WaveletConfigData wc = null;
		// Try reading the config data
		try {
			FileInputStream fs = new FileInputStream(netConfig);
			// Read in the config data
			wc = (WaveletConfigData) xs.fromXML(fs);
			fs.close();
			status.setStatusText("Mote network loaded");
		} catch (Exception ex) {
			status.setStatusText("Error reading mote network data!");
			return;
		}
		// Build vector of all motes
		mote.add(new Mote(0, new Point2D.Double(2.5 / 5.4 * 450, 1.0 / 5.4 * 450)));
		for (int m = 0; m < wc.mCoords.length; m++) {
			mote.add(new Mote(m + 1, new Point2D.Double(wc.mCoords[m][0] * 650,
					wc.mCoords[m][1] * 650)));
		}
	}

	public void loadStats(File statsDir) {
		// Load stats for each mote
		Enumeration s = mote.elements();
		while (s.hasMoreElements()) {
			Mote src = (Mote) s.nextElement();
			File srcDir = new File(statsDir.getAbsolutePath() + "/src" + src.getId());
			if (srcDir.exists()) {
				Enumeration d = mote.elements();
				while (d.hasMoreElements()) {
					Mote dest = (Mote) d.nextElement();
					if (!dest.equals(src)) {
						MoteStats stats = null;
						File data = new File(srcDir.getAbsolutePath() + "/" + dest.getId()
								+ ".xml");
						// Try reading stats data
						try {
							FileInputStream fs = new FileInputStream(data);
							stats = (MoteStats) xs.fromXML(fs);
							src.addLine(dest, stats.get_avgRetries());
							fs.close();
						} catch (Exception ex) {
							status.setStatusText("Error reading stats from mote "
									+ src.getId() + " to mote " + dest.getId() + "!");
							return;
						}
					}
				}
			} else {
				status.setStatusText("Couldn't find stats for source mote "
						+ src.getId() + "!");
				return;
			}
		}
		status.setStatusText("Stats data loaded");
	}

	public void paint(Graphics2D g) {
		Graphics2D g2d = (Graphics2D) g.create();
		g2d.setFont(g2d.getFont().deriveFont((float) 10));
		g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
				RenderingHints.VALUE_ANTIALIAS_ON);
		g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
				RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
		if (selectedMote != null)
			selectedMote.paint(g2d);
		Enumeration e = mote.elements();
		while (e.hasMoreElements()) {
			Mote m = (Mote) e.nextElement();
			if (!m.equals(selectedMote))
				m.paint(g2d);
		}
		g2d.dispose();
	}

	public void mapClicked(Point pt) {
		// Check if a mote was clicked
		Enumeration e = mote.elements();
		Mote moteHit = null;
		while (e.hasMoreElements()) {
			Mote m = (Mote) e.nextElement();
			if (m.wasClicked(pt)) {
				moteHit = m;
				break;
			}
		}
		// If no mote was hit, we're done.
		if (moteHit == null)
			return;
		// Swap motes
		if (selectedMote != null)
			selectedMote.deselect();
		moteHit.select();
		selectedMote = moteHit;
	}

}
