/**
 * Sends wavelet config details in packets to the motes on demand
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.*;

import java.io.*;

public class WaveletConfigServer implements MessageListener {
	
	private static WaveletConfig wc;
	private static MoteIF mote = new MoteIF();
	
	/*** Message Types ***/
	static final byte MOTECOMMAND = 0;
	static final byte RAWDATA = 1;
	static final byte WAVELETDATA = 2;
	static final byte WAVELETCONFDATA = 3;
	static final byte WAVELETCONFHEADER = 4;
	

	public static void main(String[] args) throws IOException, ClassNotFoundException {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\apps\\compass\\waveletConfig.dat";
		FileInputStream fs = new FileInputStream(path);
		ObjectInputStream obj = new ObjectInputStream(fs);
		// Read in the config data
		wc = (WaveletConfig)obj.readObject();
		WaveletMote aMote = new WaveletMote(1, wc);
		System.err.print(aMote.toString());
		// Setup data listener
		//mote.registerListener(new UnicastPack(), new WaveletConfigServer());
		
	}

	public void messageReceived(int to, Message m) {
		
	}

}
