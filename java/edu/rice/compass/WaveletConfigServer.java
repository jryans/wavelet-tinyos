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
	private static WaveletMote mote[];
	private static MoteIF moteListen = new MoteIF();
	private static MoteSend moteSend = new MoteSend();

	/** * Message Types ** */
	static final short MOTECOMMAND = 0;
	static final short RAWDATA = 1;
	static final short WAVELETDATA = 2;
	static final short WAVELETCONFDATA = 3;
	static final short WAVELETCONFHEADER = 4;
	static final short WAVELETSTATE = 5;

	/** * State Control ** */
	static final short S_START_DATASET = 2;
	static final short S_DONE = 10;
	static final short S_RAW = 13;
	private boolean startSent = false;

	/** * Sensor Data ** */
	static final short TEMP = 0;
	static final short LIGHT = 1;
	private static int dataDone;
	private static MoteData mData;

	public static void main(String[] args) throws IOException,
			ClassNotFoundException {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
		FileInputStream fs = new FileInputStream(path);
		XMLDecoder obj = new XMLDecoder(fs);
		// Read in the config data
		wc = (WaveletConfig) obj.readObject();
		obj.close();
		// Setup mote data
		mote = new WaveletMote[wc.mScale.length];
		mData = new MoteData(wc.mScale.length);
		dataDone = wc.mScale.length;
		for (int i = 0; i < wc.mScale.length; i++)
			mote[i] = new WaveletMote(i + 1, wc);
		// Setup data listener
		moteListen.registerListener(new UnicastPack(), new WaveletConfigServer());
		System.out.println("Ready to hear from motes...");
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		int id = pack.get_data_src();
		if (pack.get_data_dest() != 0)
			return; // This would be quite strange
		switch (pack.get_data_type()) {
		case WAVELETCONFHEADER:
			// If true, this is the initial request, else an ACK.
			if (pack.get_data_data_wConfHeader_numLevels() == 0) {
				System.out.println("Got header request from mote " + id);
				try {
					moteSend.sendPack(mote[id - 1].getHeaderPack());
					System.out.println("Sent header pack to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				System.out.println("Got header ack from mote " + id);
				try {
					moteSend.sendPack(mote[id - 1].getNextDataPack());
					System.out.println("Sent data pack to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			break;
		case WAVELETCONFDATA:
			System.out.println("Got data ack from mote " + id);
			// Send the next packet
			if (mote[id - 1].isSending()) {
				try {
					moteSend.sendPack(mote[id - 1].getNextDataPack());
					System.out.println("Sent data pack to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else { // Check if all motes are done
				if (!startSent) {
					boolean done = true;
					for (int i = 0; i < mote.length; i++) {
						if (mote[i].isSending()) {
							done = false;
							break;
						}
					}
					if (done) {
						try {
							moteSend.sendPack(startDataSet());
							startSent = true;
							System.out.println("Sent start command to mote " + id);
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			}
			break;
		case WAVELETDATA:
			if (pack.get_data_data_wData_state() == S_DONE) {
				mData.lightwt[id - 1] = pack.getElement_data_data_wData_value(LIGHT);
				mData.tempwt[id - 1] = pack.getElement_data_data_wData_value(TEMP);
				if (--dataDone == 0)
					saveData();
			} else if (pack.get_data_data_wData_state() == S_RAW) {
				mData.lightraw[id - 1] = pack.getElement_data_data_wData_value(LIGHT);
				mData.tempraw[id - 1] = pack.getElement_data_data_wData_value(TEMP);
			}
			break;
		}
	}

	private void saveData() {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletData.xml";
		try {
			FileOutputStream fs = new FileOutputStream(path);
			//Thread.currentThread().setContextClassLoader(getClass().getClassLoader());
			XMLEncoder obj = new XMLEncoder(fs);
			obj.writeObject(mData);
			obj.close();
			System.out.println("Data write successful!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private BroadcastPack startDataSet() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_START_DATASET);
		pack.set_data_data_wState_dataSetTime(45000);
		return pack;
	}

}
