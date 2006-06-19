/**
 * Sends wavelet config details in packets to the motes on demand
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.*;
import java.io.*;
import java.beans.*;
import java.util.*;

public class WaveletConfigServer implements MessageListener {

	private static WaveletConfig wc;
	private static WaveletMote mote[];
	private static MoteIF moteListen = new MoteIF();
	private static MoteSend moteSend;

	/** * Message Types ** */
	static final short MOTECOMMAND = 0;
	static final short RAWDATA = 1;
	static final short WAVELETDATA = 2;
	static final short WAVELETCONFDATA = 3;
	static final short WAVELETCONFHEADER = 4;
	static final short WAVELETSTATE = 5;

	/** * State Control ** */
	static final short S_STARTUP = 1;
	static final short S_START_DATASET = 2;
	static final short S_DONE = 10;
	static final short S_OFFLINE = 11;
	static final short S_RAW = 13;
	private boolean startSent = false;

	/** * Sensor Data ** */
	static final short TEMP = 0;
	static final short LIGHT = 1;
	static final short WT_SENSORS = 2;
	private static int resultsDone;
	private static int rawDone;
	private static MoteData mData;
	private static long setLength;
	private static int numSets;
	private static int curSet;
	private Timer setTimer = new Timer();
	private SetTracker setTracker = new SetTracker();

	public static void main(String[] args) throws IOException,
			ClassNotFoundException {
		if (args[0].equals("pack")) {
			moteSend = new MoteSend(false);
			if (args[1].equals("b")) {
				BroadcastPack tPack = new BroadcastPack();
				tPack.set_data_type(MOTECOMMAND);
				tPack.set_data_data_moteCmd_cmd((short) Integer.parseInt(args[2]));
				moteSend.sendPack(tPack);
			} else if (args[1].equals("u")) {
				UnicastPack tPack = new UnicastPack();
				tPack.set_data_dest((short) Integer.parseInt(args[2]));
				tPack.set_data_type(MOTECOMMAND);
				tPack.set_data_data_moteCmd_cmd((short) Integer.parseInt(args[3]));
				moteSend.sendPack(tPack);
			}
			System.exit(0);
		} else if (args[0].equals("prog")) {
			if ((args.length > 3) && (args[3].equals("clear"))) {
				moteSend = new MoteSend(true);
			} else {
				moteSend = new MoteSend(false);
			}
			forceStartup();
			setLength = Integer.parseInt(args[1]);
			numSets = Integer.parseInt(args[2]);
			// Fixed path name for now
			String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
			FileInputStream fs = new FileInputStream(path);
			XMLDecoder obj = new XMLDecoder(fs);
			// Read in the config data
			wc = (WaveletConfig) obj.readObject();
			obj.close();
			// Setup mote data
			mote = new WaveletMote[wc.mScale.length];
			for (int i = 0; i < mote.length; i++)
				mote[i] = new WaveletMote(i + 1, wc);
			// Init data collection
			curSet = 0;
			mData = new MoteData(numSets, WT_SENSORS, mote.length);
			resultsDone = wc.mScale.length;
			rawDone = wc.mScale.length;
			// Setup data listener
			moteListen.registerListener(new UnicastPack(), new WaveletConfigServer());
			System.out.println("Ready to hear from motes...");
		}
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
					moteSend
							.sendPack(mote[id - 1].getNextDataPack((short) 0, (short) -1));
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
					short curPack = pack.get_data_data_wConfData_packNum();
					short curLevel = pack.get_data_data_wConfData_level();
					moteSend.sendPack(mote[id - 1].getNextDataPack(curLevel, curPack));
					System.out.println("Sent data pack to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (!mote[id - 1].isSending()) {
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
							startSent = true;
							startDataSet();
							System.out
									.println("Last mote was " + id + ", sent start command");
							setTimer.scheduleAtFixedRate(setTracker, setLength / 1024 * 1000, setLength / 1024 * 1000);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
			break;
		case WAVELETDATA:
			if (pack.get_data_data_wData_state() == S_DONE) {
				mData.value[curSet][TEMP * 2 + 1][id - 1] = pack
						.getElement_data_data_wData_value(TEMP);
				mData.value[curSet][LIGHT * 2 + 1][id - 1] = pack
						.getElement_data_data_wData_value(LIGHT);
				System.out.println("Got wavelet data from mote " + id);
				resultsDone--;
			} else if (pack.get_data_data_wData_state() == S_RAW) {
				mData.value[curSet][TEMP * 2][id - 1] = pack
						.getElement_data_data_wData_value(TEMP);
				mData.value[curSet][LIGHT * 2][id - 1] = pack
						.getElement_data_data_wData_value(LIGHT);
				System.out.println("Got raw data from mote " + id);
				rawDone--;
			}
			break;
		}
	}

	static void nextSet() {
		if (resultsDone <= 0 && rawDone <= 0) {
			System.out.println("Data set " + (curSet + 1) + " complete!");
		} else {
			System.out.println("Data set " + (curSet + 1) + " incomplete, missing "
					+ rawDone + " raw and " + resultsDone + " wavelet.");
		}
		if (++curSet < numSets) {
			resultsDone = wc.mScale.length;
			rawDone = wc.mScale.length;
		} else {
			saveData();
		}
	}

	private static void saveData() {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletData.xml";
		try {
			FileOutputStream fs = new FileOutputStream(path);
			// XMLEncoder obj = new XMLEncoder(fs);
			ObjectOutputStream obj = new ObjectOutputStream(fs);
			obj.writeObject(mData);
			obj.close();
			System.out.println("Data write successful!");
			forceStop();
			System.exit(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void forceStartup() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_STARTUP);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void forceStop() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_OFFLINE);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void startDataSet() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(WAVELETSTATE);
		pack.set_data_data_wState_state(S_START_DATASET);
		pack.set_data_data_wState_dataSetTime(setLength);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}

class SetTracker extends TimerTask {

	public void run() {
		WaveletConfigServer.nextSet();
	}

}
