/**
 * Executes various utilities based on command line arguments
 * that are useful when working with motes running the Compass program.
 * Runs most of the error checking on user input.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.util.*;
import java.io.*;
import com.martiansoftware.jsap.*;
import com.thoughtworks.xstream.*;
import edu.rice.compass.bigpack.*;
import edu.rice.compass.comm.*;

public class CompassTools {

	public static CompassTools main;
	private static boolean debug;

	private JSAPResult config;
	private XStream xs = new XStream();
	private WaveletController wCont;
	private long setLength;

	public static void main(String[] args) {
		try {
			main = new CompassTools(args);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public CompassTools(String[] args) throws JSAPException {
		SimpleJSAP parser = new SimpleJSAP("WaveletConfigServer",
				"Controls TinyOS motes running CompassC", new Parameter[] {
						new FlaggedOption("diag", JSAP.BOOLEAN_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "diag"),
						new Switch("debug", JSAP.NO_SHORTFLAG, "debug"),
						new Switch("pack", JSAP.NO_SHORTFLAG, "pack"),
						new Switch("prog", JSAP.NO_SHORTFLAG, "prog"),
						new Switch("ping", JSAP.NO_SHORTFLAG, "ping"),
						new FlaggedOption("power", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "power"),
						new FlaggedOption("rofftime", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'r', "radioofftime"),
						new Switch("opt", 'o', "options"),
						new Switch("load", JSAP.NO_SHORTFLAG, "load"),
						new UnflaggedOption("file"),
						new FlaggedOption("setlength", JSAP.LONG_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'l', "length"),
						new FlaggedOption("config", JSAP.STRING_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "config"),
						new FlaggedOption("sets", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 's', "sets"),
						new Switch("loadseqno", JSAP.NO_SHORTFLAG, "loadseqno"),
						new Switch("clear", 'c', "clear"),
						new Switch("force", JSAP.NO_SHORTFLAG, "force"),
						new Switch("stats", JSAP.NO_SHORTFLAG, "stats"),
						new FlaggedOption("dest", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'd', "dest") });

		config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(0);

		debug = config.getBoolean("debug");

		// Load broadcast sequence number
		if (config.getBoolean("loadseqno"))
			MoteCom.loadSeqNo();

		if (config.getBoolean("prog")) {
			// Ensure the wavelet config file exists
			File wcFile;
			if (config.contains("config")) { // Supplied path
				wcFile = new File(config.getString("config"));
			} else { // Default path
				wcFile = new File("waveletConfig.xml");
			}
			if (!wcFile.exists()) {
				System.out.println("Wavelet config file at " + wcFile.getPath()
						+ "does not exist!");
				System.exit(0);
			}
			// Try reading the config data
			try {
				FileInputStream fs = new FileInputStream(wcFile);
				// Read in the config data
				WaveletConfigData wc = (WaveletConfigData) xs.fromXML(fs);
				fs.close();
				debugPrintln("Wavelet config loaded");
				// WaveletController calls back over here as different steps are
				// completed.
				wCont = new WaveletController(wc);
			} catch (Exception e) {
				System.out.println("Error reading wavelet config!");
				e.printStackTrace();
				System.exit(0);
			}
			// Check for valid set length
			setLength = config.getLong("setlength");
			if (!config.getBoolean("force")) {
				long minSetLen = 6000 + 4000 * (wCont.getMaxScale() - 1);
				if (setLength < minSetLen) {
					System.out.println("Set length is smaller than "
							+ minSetLen
							+ ", the minimum time required for the motes to process this data set.");
					System.out.println("Using minimum time, run with --force if you want to ignore this.");
					setLength = minSetLen;
				}
			}
			// Send config to each mote
			wCont.configMotes();
		} else if (config.getBoolean("stats")) {
			new CompassMote(destCheck()).getStats();
		} else if (config.getBoolean("ping")) {
			new Timer().scheduleAtFixedRate(new Ping(config.getInt("sets"),
					new CompassMote(destCheck())), 100, 50);
		} else if (config.getBoolean("opt")) {
			CompassMote cm = new CompassMote(config.getInt("dest"));
			CompassMote.MoteOptions opt = cm.makeOptions();
			if (config.contains("power"))
				opt.txPower(config.getInt("power"));
			if (config.getBoolean("clear"))
				opt.clearStats();
			if (config.contains("diag"))
				opt.diagMode(config.getBoolean("diag"));
			if (config.contains("rofftime"))
				opt.radioOffTime(config.getInt("rofftime"));
			opt.send();
			System.exit(0);
		} else if (config.getBoolean("load")) {
			if (config.contains("file")) {
				try {
					FileInputStream fs = new FileInputStream(config.getString("file"));
					MoteStats stats = (MoteStats) xs.fromXML(fs);
					System.out.println("Stats from file:");
					stats.printStats();
					fs.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				System.out.println("No input file was given!");
			}
			System.exit(0);
		}
	}

	private int destCheck() {
		if (!config.contains("dest") || (config.getInt("dest") < 0)) {
			System.out.println("No valid destination mote supplied!");
			System.exit(0);
		}
		return config.getInt("dest");
	}

	public void configDone() {
		wCont.runSets(config.getInt("sets"), config.getLong("setlength"));
	}

	public void saveResult(Object data, String fileName) {
		if (config.contains("file"))
			fileName = config.getString("file");
		try {
			FileOutputStream fs = new FileOutputStream(fileName);
			xs.toXML(data, fs);
			fs.close();
			System.out.println("Data write successful!");
		} catch (Exception e) {
			System.out.println("Couldn't write data!");
			e.printStackTrace();
		}
		System.exit(0);
	}

	public static void debugPrint(String s) {
		if (debug)
			System.out.print(s);
	}

	public static void debugPrintln(String s) {
		if (debug)
			System.out.println(s);
	}

	public static void debugPrintln() {
		if (debug)
			System.out.println();
	}

}

class Ping extends TimerTask {

	private int numPings;
	private CompassMote mote;

	public Ping(int pings, CompassMote aMote) {
		numPings = pings;
		mote = aMote;
	}

	public void run() {
		if (numPings-- > 0) {
			System.out.println((numPings + 1) + " pings left!");
			mote.sendPing();
		} else {
			cancel();
			System.exit(0);
		}
	}

}