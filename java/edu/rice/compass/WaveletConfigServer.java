/**
 * Sends wavelet config details in packets to the motes on demand
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.*;
import java.io.*;
import java.beans.*;

public class WaveletConfigServer implements MessageListener {
	
	private static WaveletConfig wc;
	private static MoteIF moteCom = new MoteIF();
	private static WaveletMote mote[];
	
	/*** Message Types ***/
  static final byte MOTECOMMAND = 0;
	static final byte RAWDATA = 1;
	static final byte WAVELETDATA = 2;
	static final byte WAVELETCONFDATA = 3;
	static final byte WAVELETCONFHEADER = 4;
	

	public static void main(String[] args) throws IOException, ClassNotFoundException {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\apps\\compass\\waveletConfig.xml";
		FileInputStream fs = new FileInputStream(path);
		XMLDecoder obj = new XMLDecoder(fs);
		// Read in the config data
		wc = (WaveletConfig)obj.readObject();
		// Setup mote data
		mote = new WaveletMote[wc.mScale.length];
		for (int i = 0; i < wc.mScale.length; i++)
			mote[i] = new WaveletMote(i + 1, wc);
		// Setup data listener
		moteCom.registerListener(new UnicastPack(), new WaveletConfigServer());
		System.out.println("Ready to hear from motes...");
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		short id = pack.get_data_src();
		if (pack.get_data_dest() != 0)
			return; // This would be quite strange
		switch (pack.get_data_type()) {
		case WAVELETCONFHEADER:
			// If true, this is the initial request, else an ACK.
			if (pack.get_data_data_wConfHeader_numLevels() == 0) {
				try {
					moteCom.send(0, mote[id - 1].getHeaderPack());
					System.out.println("Sent header pack to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

}
