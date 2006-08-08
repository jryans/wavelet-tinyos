/**
 * Executes various utilities based on command line arguments
 * that are useful when working with motes running the Compass program.
 * Runs most of the error checking on user input.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

import java.util.*;
import java.io.*;
import java.net.*;

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
	public String packagePath;
	public String workingDir;

	public static void main(String[] args) {
		try {
			main = new CompassTools(args);
			main.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public CompassTools(String[] args) throws JSAPException {
		SimpleJSAP parser = new SimpleJSAP("CompassTools",
				"Controls TinyOS motes running CompassC", new Parameter[] {
						new FlaggedOption("diag", JSAP.BOOLEAN_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "diag"),
						new FlaggedOption("route", JSAP.BOOLEAN_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "route"),
						new FlaggedOption("mote", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "mote"),
						new Switch("debug", JSAP.NO_SHORTFLAG, "debug"),
						new Switch("pack", JSAP.NO_SHORTFLAG, "pack"),
						new FlaggedOption("prog", JSAP.BOOLEAN_PARSER, "yes",
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "prog"),
						new Switch("transform", 't', "transform"),
						new FlaggedOption("ping", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "ping"),
						new FlaggedOption("pm", JSAP.BOOLEAN_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "pm"),
						new FlaggedOption("chan", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "chan"),
						new FlaggedOption("power", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "power"),
						new FlaggedOption("rofftime", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'r', "radioofftime"),
						new FlaggedOption("retries", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "radioretries"),
						new Switch("opt", 'o', "options"),
						new Switch("load", JSAP.NO_SHORTFLAG, "load"),
						new Switch("summary", JSAP.NO_SHORTFLAG, "summary"),
						new Switch("ver", JSAP.NO_SHORTFLAG, "ver"),
						new UnflaggedOption("file"),
						new FlaggedOption("setlength", JSAP.LONG_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'l', "length"),
						new FlaggedOption("config", JSAP.STRING_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "config"),
						new FlaggedOption("sets", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 's', "sets"),
						new Switch("ignoreseqno", JSAP.NO_SHORTFLAG, "ignoreseqno"),
						new Switch("clear", 'c', "clear"),
						new Switch("force", JSAP.NO_SHORTFLAG, "force"),
						new Switch("stats", JSAP.NO_SHORTFLAG, "stats"),
						new Switch("pwrcntl", 'p', "pwrcntl"),
						new Switch("broadcast", 'b', "broadcast"),
						new Switch("reboot", JSAP.NO_SHORTFLAG, "reboot"),
						new FlaggedOption("awake", JSAP.BOOLEAN_PARSER, "yes",
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "awake"),
						new FlaggedOption("mode", JSAP.STRING_PARSER, "CS",
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "mode"),
						new FlaggedOption("sleepInt", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "sleepInt"),
						new FlaggedOption("wakeInt", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, JSAP.NO_SHORTFLAG, "wakeInt"),
						new FlaggedOption("dest", JSAP.INTEGER_PARSER, JSAP.NO_DEFAULT,
								JSAP.NOT_REQUIRED, 'd', "dest") });

		config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(1);
	}

	private void execute() {
		debug = config.getBoolean("debug");

		// Store package path and working directory
		Class pClass = CompassTools.class;
		Package mPackage = pClass.getPackage();
		URL pAddr = pClass.getResource("/" + mPackage.getName().replace('.', '/'));
		packagePath = pAddr.getPath() + "/";
		workingDir = System.getProperty("user.dir") + "/";

		// Load broadcast sequence number
		if (!config.getBoolean("ignoreseqno"))
			MoteCom.loadSeqNo();

		if (config.getBoolean("transform")) {
			// Ensure the wavelet config file exists
			File wcFile;
			if (config.contains("config")) { // Supplied path
				wcFile = new File(config.getString("config"));
				if (!wcFile.isAbsolute())
					wcFile = new File(workingDir + config.getString("config"));
			} else { // Default path
				wcFile = new File(packagePath + "waveletConfig.xml");
			}
			if (!wcFile.exists()) {
				System.out.println("Wavelet config file at " + wcFile.getPath()
						+ "does not exist!");
				System.exit(1);
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
				System.exit(1);
			}
			// Check for valid set length
			setLength = config.getLong("setlength", 0);
			if (!config.getBoolean("force")) {
				long minSetLen = 6000 + 4000 * (wCont.getMaxScale() - 1);
				if (setLength < minSetLen) {
					if (setLength == 0) {
						System.out.println("Set length is smaller than "
								+ minSetLen
								+ ", the minimum time required for the motes to process this data set.");
						System.out.println("Using minimum time, run with --force if you want to ignore this.");
					}
					setLength = minSetLen;
				}
			}
			// Inputs are good, stop the motes to make sure they aren't
			// doing anything first.
			CompassMote.forceStop();
			if (config.getBoolean("prog")) {
				wCont.configMotes(); // Send config to each mote
			} else {
				System.out.println("Skipping wavelet config transmission");
				configDone(); // Start transform
			}
		} else if (config.getBoolean("stats")) {
			new CompassMote(destCheck()).getStats();
			new Timer().schedule(new Timeout(), 5000);
		} else if (config.getInt("ping", 0) != 0 && !config.getBoolean("opt")) {
			new Timer().scheduleAtFixedRate(new Ping(config.getInt("ping"),
					new CompassMote(destCheck())), 100, 30);
		} else if (config.getBoolean("opt")) {
			CompassMote cm;
			CompassMote.MoteOptions opt;
			if (config.getBoolean("broadcast")) {
				cm = new CompassMote(0);
				opt = cm.makeOptions(true);
			} else {
				cm = new CompassMote(destCheck());
				opt = cm.makeOptions(false);
			}
			if (config.contains("power"))
				opt.txPower(config.getInt("power"));
			if (config.getBoolean("clear"))
				opt.clearStats();
			if (config.contains("rofftime")) {
				if (config.contains("ping")) {
					opt.pingNum(config.getInt("ping"), config.getInt("rofftime"));
				} else {
					opt.radioOffTime(config.getInt("rofftime"));
				}
			}
			if (config.contains("pm"))
				opt.hplPM(config.getBoolean("pm"));
			if (config.contains("chan"))
				opt.rfChan(config.getInt("chan"));
			if (config.contains("retries"))
				opt.radioRetries(config.getInt("retries"));
			opt.send();
			System.exit(0);
		} else if (config.getBoolean("pwrcntl")) {
			CompassMote cm = new CompassMote(destCheck());
			CompassMote.PwrControl pm = cm.makePwrControl();
			pm.pmMode(config.getString("mode"));
			pm.awake(config.getBoolean("awake"));
			if (config.contains("sleepInt"))
				pm.sleepInterval(config.getInt("sleepInt") * 1024 / 1000);
			if (config.contains("wakeInt"))
				pm.wakeInterval(config.getInt("wakeInt") * 1024 / 1000);
			pm.reboot(config.getBoolean("reboot"));
			pm.send();
			System.exit(0);
		} else if (config.contains("route") && config.contains("mote")) {
			CompassMote cm = new CompassMote(destCheck());
			cm.sendRouterLink(config.getInt("mote"), config.getBoolean("route"));
			System.exit(0);
		} else if (config.getBoolean("load")) {
			if (config.contains("file")) {
				try {
					File in = new File(config.getString("file"));
					if (!in.isAbsolute())
						in = new File(workingDir + config.getString("file"));
					FileInputStream fs = new FileInputStream(in);
					MoteStats stats = (MoteStats) xs.fromXML(fs);
					System.out.println("Stats from file:");
					stats.printStats();
					fs.close();
				} catch (Exception e) {
					e.printStackTrace();
					System.exit(1);
				}
				System.exit(0);
			} else {
				System.out.println("No input file was given!");
				System.exit(1);
			}
		} else if (config.getBoolean("ver")) {
			CompassMote cm = new CompassMote(destCheck());
			cm.getCompileTime();
		} else if (config.getBoolean("summary")) {
			if (config.contains("file")) {
				try {
					File in = new File(config.getString("file"));
					if (!in.isAbsolute())
						in = new File(workingDir + config.getString("file"));
					File dFiles[] = in.listFiles();
					if (dFiles == null) {
						System.out.println("No files in that directory!");
						System.exit(1);
					}
					System.out.println("Dest ID  P ACK %  M DEL %  AVG RET");
					System.out.println("-------  -------  -------  -------");
					TreeSet motes = new TreeSet(new Comparator() {
						public int compare(Object o0, Object o1) {
							File f0 = (File) o0;
							File f1 = (File) o1;
							int id0 = Integer.parseInt(f0.getName().substring(0,
									f0.getName().indexOf('.')));
							int id1 = Integer.parseInt(f1.getName().substring(0,
									f1.getName().indexOf('.')));
							return id0 - id1;
						}
					});
					for (int f = 0; f < dFiles.length; f++) {
						if (dFiles[f].getName().endsWith(".xml")) {
							motes.add(dFiles[f]);
						}
					}
					Iterator m = motes.iterator();
					while (m.hasNext()) {
						File aFile = (File) m.next();
						FileInputStream fs = new FileInputStream(aFile);
						MoteStats stats = (MoteStats) xs.fromXML(fs);
						String entry = aFile.getName().substring(0,
								aFile.getName().indexOf('.'));
						entry = strExpand(entry, 9);
						entry += (stats.get_pAcked() * 100 / stats.get_pSent());
						entry = strExpand(entry, 18);
						entry += (stats.get_mDelivered() * 100 / stats.get_mSent());
						entry = strExpand(entry, 27);
						entry += (stats.get_avgRetries());
						System.out.println(entry);
						fs.close();
					}
				} catch (Exception e) {
					e.printStackTrace();
					System.exit(1);
				}
				System.exit(0);
			} else {
				System.out.println("No input directory was given!");
				System.exit(1);
			}
		} else {
			System.out.println("Invalid command line options!");
			System.exit(1);
		}
	}

	private String strExpand(String src, int fLen) {
		int iLen = src.length();
		for (int sp = 0; sp < fLen - iLen; sp++)
			src += " ";
		return src;
	}

	private int destCheck() {
		if (!config.contains("dest") || (config.getInt("dest") < 0)) {
			System.out.println("No valid destination mote supplied!");
			System.exit(1);
		}
		return config.getInt("dest");
	}

	public void configDone() {
		wCont.runSets(config.getInt("sets"), setLength);
	}

	public void saveResult(Object data, String fileName) {
		if (config.contains("file"))
			fileName = config.getString("file");
		File out = new File(fileName);
		if (!out.isAbsolute())
			out = new File(workingDir + fileName);
		try {
			FileOutputStream fs = new FileOutputStream(fileName);
			xs.toXML(data, fs);
			fs.close();
			System.out.println("Data write successful!");
		} catch (Exception e) {
			System.out.println("Couldn't write data!");
			e.printStackTrace();
			System.exit(1);
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

class Timeout extends TimerTask {

	public void run() {
		System.out.println("Timeout reached!");
		System.exit(1);
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
