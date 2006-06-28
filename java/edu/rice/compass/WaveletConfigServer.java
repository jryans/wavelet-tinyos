/**
 * Sends wavelet config details in packets to the motes on demand
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import net.tinyos.message.*;
import java.util.*;
import java.io.*;
import com.martiansoftware.jsap.*;
import com.thoughtworks.xstream.*;
import edu.rice.compass.bigpack.*;

public class WaveletConfigServer implements MessageListener {

	private static WaveletConfig wc;
	private static WaveletMote mote[];
	private static MoteIF moteListen = new MoteIF();
	private static MoteSend moteSend;
	static JSAPResult config;
	private static XStream xs = new XStream();;

	private boolean startSent = false;

	private static int transState;

	private static boolean debug;

	/* Sensor Data */
	private static MoteData mData;
	private static long setLength;
	private static int numSets;
	private static int curSet;

	/* Wavelet Config Timer */
	private static Timer pulseTimer = new Timer();

	public static void main(String[] args) throws Exception {
		SimpleJSAP parser = new SimpleJSAP("WaveletConfigServer",
				"Controls TinyOS motes running CompassC", new Parameter[] {
						new Switch("debug", JSAP.NO_SHORTFLAG, "debug"),
						new Switch("pack", JSAP.NO_SHORTFLAG, "pack"),
						new Switch("prog", JSAP.NO_SHORTFLAG, "prog"),
						new Switch("ping", JSAP.NO_SHORTFLAG, "ping"),
						new Switch("load", JSAP.NO_SHORTFLAG, "load"),
						new FlaggedOption("file", JSAP.STRING_PARSER, "",
								JSAP.NOT_REQUIRED, 'f', "file"),
						new FlaggedOption("setlength", JSAP.LONG_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'l', "length"),
						new FlaggedOption("sets", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 's', "sets"),
						new Switch("clear", 'c', "clear"),
						new Switch("force", JSAP.NO_SHORTFLAG, "force"),
						new Switch("stats", JSAP.NO_SHORTFLAG, "stats"),
						new FlaggedOption("dest", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'd', "dest") });

		config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(1);

		if (config.getBoolean("clear")) {
			moteSend = new MoteSend(true);
		} else {
			moteSend = new MoteSend(false);
		}

		debug = config.getBoolean("debug");

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
			setLength = config.getLong("setlength");
			numSets = config.getInt("sets");
			// Fixed path name for now
			String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
			FileInputStream fs = new FileInputStream(path);
			// Read in the config data
			wc = (WaveletConfig) xs.fromXML(fs);
			fs.close();
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
			transState = BigPack.BP_SENDING;
			listen();
			// Setup and start config pulse timer
			pulseTimer.scheduleAtFixedRate(new ConfigPulse(mote.length), 200, 300);
		} else if (config.getBoolean("stats")) {
			// Fixed path name for now
			String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
			FileInputStream fs = new FileInputStream(path);
			// Read in the config data
			wc = (WaveletConfig) xs.fromXML(fs);
			fs.close();
			// Setup mote data
			mote = new WaveletMote[wc.mScale.length];
			for (int i = 0; i < mote.length; i++)
				mote[i] = new WaveletMote(i + 1, wc);
			int dest = config.getInt("dest");
			UnicastPack req = new UnicastPack();
			req.set_data_dest(dest);
			req.set_data_type(BigPack.BIGPACKHEADER);
			req.set_data_data_bpHeader_requestType(BigPack.BP_STATS);
			req.set_data_data_bpHeader_packTotal((short) 0);
			transState = BigPack.BP_RECEIVING;
			listen();
			moteSend.sendPack(req);
			System.out.println("Sent stats request to mote " + dest);
		} else if (config.getBoolean("ping")) {
			pulseTimer.scheduleAtFixedRate(new Ping(config.getInt("sets")), 200, 100);
		} else if (config.getBoolean("load")) {
			if (!config.getString("file").equals("")) {
				try {
					FileInputStream fs = new FileInputStream(config.getString("out"));
					MoteStats stats = (MoteStats) xs.fromXML(fs);
					printStats(stats);
					fs.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			System.exit(0);
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

	private void sendAck(UnicastPack u) {
		int dest = u.get_data_src();
		u.set_data_dest(dest);
		u.set_data_src(0);
		try {
			moteSend.sendPack(u);
			System.out.println("Sent ack to mote " + dest);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void messageReceived(int to, Message m) {
		UnicastPack pack = (UnicastPack) m;
		int id = pack.get_data_src();
		if (pack.get_data_dest() != 0)
			return; // This would be quite strange
		WaveletMote theMote = mote[id - 1];
		switch (pack.get_data_type()) {
		case Wavelet.BIGPACKHEADER:
			// If true, this is the initial request, else an ACK.
			if (pack.get_data_data_bpHeader_packTotal() == 0) {
				System.out.println("Got BP header request from mote " + id);
				try {
					moteSend.sendPack(theMote.getHeader());
					System.out.println("Sent BP header (0/" + theMote.getNumPacks()
							+ ") to mote " + id);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} else {
				if (transState == BigPack.BP_SENDING) {
					System.out.println("Got BP header ack from mote " + id);
					try {
						UnicastPack newPack = theMote.getData(0);
						moteSend.sendPack(newPack);
						System.out.println("Sent BP data ("
								+ (newPack.get_data_data_bpData_curPack() + 1) + "/"
								+ theMote.getNumPacks() + ") to mote " + id);
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else if (transState == BigPack.BP_RECEIVING) {
					theMote.unpacker = new Unpacker(pack);
					System.out.println("Got BP header (0/"
							+ theMote.unpacker.getNumPacks() + ") from mote " + id);
					sendAck(pack);
				}
			}
			break;
		case Wavelet.BIGPACKDATA:
			if (transState == BigPack.BP_SENDING) {
				System.out.println("Got BP data ack from mote " + id);
				short curPack = pack.get_data_data_bpData_curPack();
				if (!theMote.isConfigDone(curPack)) {
					// Send the next packet
					try {
						moteSend.sendPack(theMote.getData(++curPack));
						System.out.println("Sent BP data (" + (curPack + 1) + "/"
								+ theMote.getNumPacks() + ") to mote " + id);
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else {
					System.out.println("Config done for mote " + id);
					attemptStart();
				}
			} else if (transState == BigPack.BP_RECEIVING) {
				short curPack = pack.get_data_data_bpData_curPack();
				if (theMote.unpacker.newData(pack)) {
					System.out.println("Got BP data (" + (curPack + 1) + "/"
							+ theMote.unpacker.getNumPacks() + ") from mote " + id);
					sendAck(pack);
					if (!theMote.unpacker.morePacksExist(curPack)) {
						MoteStats stats = theMote.extractData();
						printStats(stats);
						// Setup output file
						if (!config.getString("file").equals("")) {
							try {
								FileOutputStream fs = new FileOutputStream(config
										.getString("file"));
								xs.toXML(stats, fs);
								fs.close();
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
						System.exit(0);
					}
				}
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
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	private synchronized static void nextSet() {
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
			xs.toXML(mData, fs);
			fs.close();
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

	static void directedStartup(int moteNum) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_dest(moteNum);
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

	public static void debugPrint(String s) {
		if (debug)
			System.out.print(s);
	}

	public static void debugPrintln(String s) {
		if (debug)
			System.out.println(s);
	}

	public static void sendPing(int mote) {
		UnicastPack pack = new UnicastPack();
		pack.set_data_dest(mote);
		pack.set_data_type(Wavelet.MOTECOMMAND);
		pack.set_data_data_moteCmd_cmd((short) 0);
		try {
			moteSend.sendPack(pack);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void printStats(MoteStats stats) {
		// System.out.println("Stats for Mote " + id + ":");
		System.out.println("  Voltage: " + (stats.get_voltage() / 1000) + " V");
		System.out.println("  *Unicast* Packets:");
		System.out.println("    Received: " + stats.get_pRcvd());
		if (stats.get_pRcvd() > 0) {
			System.out.println("      Avg. RSSI: "
					+ ((stats.get_rssiSum() / stats.get_pRcvd()) - 45));
			System.out.println("      Min. RSSI: " + (stats.get_rssiMin() - 45));
			System.out.println("      Max. RSSI: " + (stats.get_rssiMax() - 45));
			System.out.println("      Avg. LQI:  "
					+ (stats.get_lqiSum() / stats.get_pRcvd()));
			System.out.println("      Min. LQI:  " + stats.get_lqiMin());
			System.out.println("      Max. LQI:  " + stats.get_lqiMax());
		}
		System.out.println("    Sent: " + stats.get_pSent());
		if (stats.get_pSent() > 0)
			System.out.println("      ACKed: " + stats.get_pAcked() + " ("
					+ (stats.get_pAcked() * 100 / stats.get_pSent()) + "%)");
		System.out.println("  Messages:");
		System.out.println("    Received: " + stats.get_mRcvd());
		System.out.println("    Sent:     " + stats.get_mSent());
		if (stats.get_mSent() > 0)
			System.out.println("      Avg. Retries: "
					+ ((float) stats.get_mRetriesSum() / stats.get_mSent()));
		StatsWTL level[] = stats.get_wavelet_level();
		if (level.length > 0) {
			System.out.println("  Wavelet:");
			for (int l = 0; l < level.length; l++) {
				StatsWTNB nb[] = level[l].get_nb();
				System.out.println("    Level " + (l + 1) + ":");
				for (int n = 0; n < nb.length; n++) {
					System.out.println("      Neighbor " + (n + 1) + ":");
					System.out.println("        ID:         " + nb[n].get_id());
					System.out.println("        Retries:    " + nb[n].get_retries());
					System.out.println("        Cache Hits: " + nb[n].get_cacheHits());
				}
			}
		}
	}

}

class ConfigPulse extends TimerTask {

	private int numMotes;
	private int curMote;

	public ConfigPulse(int numMotes) {
		this.numMotes = numMotes;
		curMote = 0;
	}

	public void run() {
		if (curMote++ < numMotes) {
			WaveletConfigServer.directedStartup(curMote);
		} else {
			cancel();
		}
	}

}

class Ping extends TimerTask {

	private int numPings;

	public Ping(int pings) {
		numPings = pings;
	}

	public void run() {
		if (numPings-- > 0) {
			System.out.println((numPings + 1) + " pings left!");
			WaveletConfigServer.sendPing(WaveletConfigServer.config.getInt("dest"));
		} else {
			cancel();
			System.exit(0);
		}
	}

}
