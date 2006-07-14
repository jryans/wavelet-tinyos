package edu.rice.compass;

import java.util.*;
import com.martiansoftware.jsap.*;

public class QuantileSim {

	private static QuantileSim main;
	private TreeSet sumData;
	private double dataSeen;
	private QuantData inputData;
	private JSAPResult config;

	private double ep;
	private double phi;
	private double minVal = Double.NaN;
	private double maxVal = Double.NaN;
	private double p;

	private QuantileSim(String[] args) throws JSAPException {
		SimpleJSAP parser = new SimpleJSAP("QuantileSim",
				"Simulation of estimated quantiles over a stream", new Parameter[] {
						new FlaggedOption("ep", JSAP.DOUBLE_PARSER, JSAP.NO_DEFAULT,
								JSAP.REQUIRED, 'e', "epsilon"),
						new FlaggedOption("phi", JSAP.DOUBLE_PARSER, JSAP.NO_DEFAULT,
								JSAP.REQUIRED, 'p', "phi") });

		config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(0);

		sumData = new TreeSet();
		dataSeen = 0;
		p = 0;
		ep = config.getDouble("ep");
		phi = config.getDouble("phi");
	}

	public static void main(String[] args) {
		try {
			main = new QuantileSim(args);
			main.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void execute() {
		// Load simulated data
		inputData = QuantMatlab.loadData();
		System.out.println("Epsilon: " + ep + ", Phi: " + phi);
		System.out.println("Input Elements: " + inputData.data.length);
		// Add each input to the summary to simulate a stream
		for (int i = 0; i < inputData.data.length; i++) {
			System.out.println("Adding element " + i);
			newData(inputData.data[i]);
		}
	}

	private void newData(double newVal) {
		if ((dataSeen % (1 / (2 * ep))) == 0)
			compress();
		insert(newVal);
		dataSeen++;
		p = Math.floor(2 * ep * dataSeen);
	}

	private void compress() {

	}

	private void insert(double val) {

	}

	private class Tuple {

		private double val;
		private double g;
		private double delta;

		private Tuple(double mVal) {
			boolean newMinMax = false;
			val = mVal;
			g = 1;
			if (dataSeen == 0) {
				minVal = val;
				maxVal = val;
				newMinMax = true;
			} else if (val < minVal) {
				minVal = val;
				newMinMax = true;
			} else if (val > maxVal) {
				maxVal = val;
				newMinMax = true;
			}
			if (newMinMax) {
				delta = 0;
			} else {
				delta = p;
			}
		}

		private int band(Tuple t) {
			int numBands = ((int) Math.ceil(Math.log(2 * ep * dataSeen))) + 1;
			if (t.delta == p) {
				return 0;
			} else if (t.delta == 0) {
				return numBands;
			} else {
				int a;
				for (a = 1; a < numBands; a++) {
					if (((p - Math.pow(2, a) - (p % Math.pow(2, a))) < t.delta)
							&& (t.delta <= (p - Math.pow(2, a - 1) - (p % Math.pow(2, a - 1)))))
						break;				
				}
				if (a >= numBands) {
					System.out.println("Couldn't find valid band!");
					System.exit(0);
				}
				return a;
			}
		}
	}
}
