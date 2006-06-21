/**
 * Sends wavelet config details in packets to the motes on demand
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.*;
import java.io.*;
import java.beans.*;
import java.util.*;
import com.martiansoftware.jsap.*;

public class WaveletConfigServer implements MessageListener {

	private static WaveletConfig wc;
	private static WaveletMote mote[];
	private static MoteIF moteListen = new MoteIF();
	private static MoteSend moteSend;

	private boolean startSent = false;

	/* Sensor Data */
	private static MoteData mData;
	private static long setLength;
	private static int numSets;
	private static int curSet;

	public static void main(String[] args) throws Exception {
		SimpleJSAP parser = new SimpleJSAP("WaveletConfigServer",
				"Controls TinyOS motes running CompassC", new Parameter[] {
						new Switch("pack", JSAP.NO_SHORTFLAG, "pack"),
						new Switch("prog", JSAP.NO_SHORTFLAG, "prog"),
						new FlaggedOption("setlength", JSAP.LONG_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'l', "length"),
						new FlaggedOption("sets", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 's', "sets"),
						new Switch("clear", 'c', "clear"),
						new Switch("force", 'f', "force"),
						new Switch("stats", JSAP.NO_SHORTFLAG, "stats"),
						new FlaggedOption("dest", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'd', "dest"),
						new Switch("test", 't', "test") });

		JSAPResult config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(1);

		if (config.getBoolean("clear")) {
			moteSend = new MoteSend(true);
		} else {
			moteSend = new MoteSend(false);
		}

		if (config.getBoolean("pack")) {
			if (args[1].equals("b")) {
				BroadcastPack tPack = new BroadcastPack();
				tPack.set_data_type(Wavelet.MOTECOMMAND);
				tPack.set_data_data_moteCmd_cmd((short) Integer.parseInt(args[2]));
				moteSend.sendPack(tPack);
			} else if (args[1].equals("u")) {
				UnicastPack tPack = new UnicastPack();
				tPack.set_data_dest((short) Integer.parseInt(args[2]));
				tPack.set_data_type(Wavelet.MOTECOMMAND);
				tPack.set_data_data_moteCmd_cmd((short) Integer.parseInt(args[3]));
				moteSend.sendPack(tPack);
			}
			System.exit(0);
		} else if (config.getBoolean("prog")) {
			forceStartup();
			setLength = config.getLong("setlength");
			numSets = config.getInt("sets");
			// Fixed path name for now
			String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
			FileInputStream fs = new FileInputStream(path);
			XMLDecoder obj = new XMLDecoder(fs);
			// Read in the config data
			wc = (WaveletConfig) obj.readObject();
			obj.close();
			// Check for valid set length
			int maxScale = 0;
			for (int i = 0; i < wc.mScale.length; i++)
				if (wc.mScale[i] > maxScale)
					maxScale = (int) wc.mScale[i];
			long minSetLen = 6000 + 4000 * (maxScale - 1);
			if (setLength < minSetLen && !config.getBoolean("force")) {
				System.out
						.println("Set length is smaller than "
								+ minSetLen
								+ ", the minimum time required for the motes to process this data set.");
				System.out.println("Run again with --force if you wish to proceed.");
			}
			// Setup mote data
			mote = new WaveletMote[wc.mScale.length];
			for (int i = 0; i < mote.length; i++)
				mote[i] = new WaveletMote(i + 1, wc);
			// Init data collection
			curSet = 0;
			mData = new MoteData(numSets, Wavelet.WT_SENSORS, mote.length);
			clearDataCheck();
			listen();
		} else if (config.getBoolean("stats")) {
			int dest = config.getInt("dest");
			UnicastPack req = new UnicastPack();
			req.set_data_dest(dest);
			req.set_data_type(Wavelet.MOTESTATS);
			listen();
			moteSend.sendPack(req);
			System.out.println("Sent stats request to mote " + dest);
		}
	}

	private static void listen() {
		// Setup data listener
		moteListen.registerListener(new UnicastPack(), new WaveletConfigServer());
		System.out.println("Ready to hear from motes...");
	}

	private static void clearDataCheck() {
		for (int i = 0; i < mote.length; i++) {
			mote[i].setRawDone(false);
			mote[i].setResultDone(false);
		}
	}

	private static int[] dataCheck() {
		int[] dataCheck = new int[2];
		for (int i = 0; i < mote.length; i++) {
			if (!mote[i].isRawDone())
				dataCheck[Wavelet.RAW_OFFSET]++;
			if (!mote[i].isResultDone())
				dataCheck[Wavelet.WT_OFFSET]++;
		}
		return dataCheck;
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		int id = pack.get_data_src();
		if (pack.get_data_dest() != 0)
			return; // This would be quite strange
		switch (pack.get_data_type()) {
		/*
		 * case Wavelet.WAVELETCONFHEADER: // If true, this is the initial request,
		 * else an ACK. if (pack.get_data_data_wConfHeader_numLevels() == 0) {
		 * System.out.println("Got header request from mote " + id); try {
		 * moteSend.sendPack(mote[id - 1].getHeaderPack()); System.out.println("Sent
		 * header pack to mote " + id); } catch (IOException e) {
		 * e.printStackTrace(); } } else { System.out.println("Got header ack from
		 * mote " + id); try { moteSend .sendPack(mote[id -
		 * 1].getNextDataPack((short) 0, (short) -1)); System.out.println("Sent data
		 * pack to mote " + id); } catch (IOException e) { e.printStackTrace(); } }
		 * break; case Wavelet.WAVELETCONFDATA: System.out.println("Got data ack
		 * from mote " + id); // Send the next packet if (!mote[id -
		 * 1].isConfigDone()) { short curLevel =
		 * pack.get_data_data_wConfData_level(); short curPack =
		 * pack.get_data_data_wConfData_packNum(); if (mote[id -
		 * 1].nextPackExists(curLevel, curPack)) { try { moteSend.sendPack(mote[id -
		 * 1].getNextDataPack(curLevel, curPack)); System.out.println("Sent data
		 * pack to mote " + id); } catch (IOException e) { e.printStackTrace(); } }
		 * else { mote[id - 1].setConfigDone(true); System.out.println("Config done
		 * for mote " + id); attemptStart(); } } break;
		 */
		case Wavelet.BIGPACKHEADER:
			Packer packer = mote[id - 1].testPacker();
			if (pack.get_data_data_bpHeader_packTotal() == 0) {
				try {
					moteSend.sendPack(packer.getHeader());
					System.out.println("Sent pack header (0/"
							+ (packer.getNumPacks() + 1) + ") to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				try {
					UnicastPack newPack = packer.getData(0);
					moteSend.sendPack(newPack);
					System.out.println("Sent data pack ("
							+ (newPack.get_data_data_bpData_curPack() + 1) + "/"
							+ (packer.getNumPacks() + 1) + ") to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			break;
		case Wavelet.BIGPACKDATA:
			Packer packer2 = mote[id - 1].testPacker();
			try {
				UnicastPack newPack = packer2.getData(pack
						.get_data_data_bpData_curPack() + 1);
				moteSend.sendPack(newPack);
				System.out.println("Sent data pack ("
						+ (newPack.get_data_data_bpData_curPack() + 1) + "/"
						+ (packer2.getNumPacks() + 1) + ") to mote " + id);
			} catch (IOException e) {
				e.printStackTrace();
			}
			break;
		case Wavelet.WAVELETDATA:
			// Check if data is from the next set
			setCheck(pack.get_data_data_wData_dataSet() - 1);
			// Store mote data
			if (pack.get_data_data_wData_state() == Wavelet.S_DONE) {
				mData.value[curSet][Wavelet.TEMP * 2 + Wavelet.WT_OFFSET][id - 1] = pack
						.getElement_data_data_wData_value(Wavelet.TEMP);
				mData.value[curSet][Wavelet.LIGHT * 2 + Wavelet.WT_OFFSET][id - 1] = pack
						.getElement_data_data_wData_value(Wavelet.LIGHT);
				System.out.println("Got wavelet data from mote " + id);
				mote[id - 1].setResultDone(true);
			} else if (pack.get_data_data_wData_state() == Wavelet.S_RAW) {
				mData.value[curSet][Wavelet.TEMP * 2 + Wavelet.RAW_OFFSET][id - 1] = pack
						.getElement_data_data_wData_value(Wavelet.TEMP);
				mData.value[curSet][Wavelet.LIGHT * 2 + Wavelet.RAW_OFFSET][id - 1] = pack
						.getElement_data_data_wData_value(Wavelet.LIGHT);
				System.out.println("Got raw data from mote " + id);
				mote[id - 1].setRawDone(true);
			}
			break;
		case Wavelet.MOTESTATS:
			int rcvd = pack.get_data_data_stats_rcvd();
			int sent = pack.get_data_data_stats_sent();
			int acked = pack.get_data_data_stats_acked();
			System.out.println("Stats for mote " + pack.get_data_src() + ":");
			System.out.println("Received:  " + rcvd);
			System.out.println("Avg. RSSI: "
					+ (pack.get_data_data_stats_rssi() / rcvd - 45));
			System.out.println("Sent:      " + sent);
			System.out.println("ACKed:     " + acked + " (" + (acked * 100 / sent)
					+ "%)");
			for (int i = 0; i < pack.get_data_data_stats_numReps(); i++) {
				System.out.println("Report " + (i + 1) + ":");
				System.out.println("  Count: "
						+ pack.getElement_data_data_stats_reports_number(i));
				System.out.print("  Type:  ");
				switch (pack.getElement_data_data_stats_reports_type(i)) {
				case Wavelet.WT_CACHE:
					System.out.println("Cache Hit");
					System.out.println("  Level: "
							+ pack.getElement_data_data_stats_reports_data_cache_level(i));
					System.out.println("  Mote:  "
							+ pack.getElement_data_data_stats_reports_data_cache_mote(i));
					break;
				}
			}
			System.exit(0);
			break;
		}
	}

	synchronized private void setCheck(int msgSet) {
		if (msgSet > curSet)
			nextSet();
	}

	private void attemptStart() {
		if (!startSent) {
			boolean done = true;
			for (int i = 0; i < mote.length; i++) {
				if (!mote[i].isConfigDone()) {
					done = false;
					break;
				}
			}
			if (done) {
				try {
					startSent = true;
					startDataSet();
					System.out.println("Start command sent!");
					// setTimer.scheduleAtFixedRate(setTracker, setLength / 1024 * 1000,
					// setLength / 1024 * 1000);
					// setTimer.schedule(setTimeout, setLength * 2);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	synchronized static void nextSet() {
		int[] check = dataCheck();
		if (check[Wavelet.RAW_OFFSET] == 0 && check[Wavelet.WT_OFFSET] == 0) {
			System.out.println("Data set " + (curSet + 1) + " complete!");
		} else {
			System.out.println("Data set " + (curSet + 1) + " incomplete, missing "
					+ check[Wavelet.RAW_OFFSET] + " raw and " + check[Wavelet.WT_OFFSET]
					+ " wavelet.");
		}
		if (++curSet < numSets) {
			clearDataCheck();
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
		pack.set_data_type(Wavelet.WAVELETSTATE);
		pack.set_data_data_wState_state(Wavelet.S_STARTUP);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void forceStop() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(Wavelet.WAVELETSTATE);
		pack.set_data_data_wState_state(Wavelet.S_OFFLINE);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void startDataSet() {
		BroadcastPack pack = new BroadcastPack();
		pack.set_data_type(Wavelet.WAVELETSTATE);
		pack.set_data_data_wState_state(Wavelet.S_START_DATASET);
		pack.set_data_data_wState_dataSetTime(setLength);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
