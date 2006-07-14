package edu.rice.compass;

import com.martiansoftware.jsap.*;

public class PSSim {

	private static PSSim main;
	private JSAPResult config;

	private QuantData inputData;

	private double p;
	private static final int numMarkers = 5;
	private double q[] = new double[numMarkers];
	private int n[] = new int[] { 1, 2, 3, 4, 5 };
	private double nDes[];
	private double dnDes[];
	private int numSeen;

	private PSSim(String[] args) throws JSAPException {
		SimpleJSAP parser = new SimpleJSAP("PSSim",
				"Simulation of estimating a p-quantile",
				new Parameter[] { new FlaggedOption("p", JSAP.DOUBLE_PARSER, "0.5",
						JSAP.REQUIRED, 'p', JSAP.NO_LONGFLAG) });

		config = parser.parse(args);
		if (parser.messagePrinted())
			System.exit(0);

		p = config.getDouble("p");
		// Calculate dnDes[], which are constant values
		dnDes = new double[] { 0, p / 2, p, (1 + p) / 2, 1 };
		// Initialize nDes[]
		nDes = new double[] { 1, 1 + 2 * p, 1 + 4 * p, 3 + 2 * p, 5 };
	}

	public static void main(String[] args) {
		try {
			main = new PSSim(args);
			main.execute();
			System.exit(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void execute() {
		double dataSum = 0;
		// Load simulated data
		inputData = QuantMatlab.loadData();
		System.out.println("Markers: " + numMarkers + ", p: " + p);
		System.out.println("Input Elements: " + inputData.data.length);
		// Add each input to the summary to simulate a stream
		for (numSeen = 0; numSeen < inputData.data.length; numSeen++) {
			System.out.println("Adding element " + (numSeen + 1) + ": "
					+ inputData.data[numSeen]);
			newData(inputData.data[numSeen]);
			dataSum += inputData.data[numSeen];
		}
		// Print final stats
		System.out.println("Final stats:");
		System.out.println("  Min: " + min());
		System.out.println("  Max: " + max());
		System.out.println("  Avg: " + dataSum / numSeen);
		System.out.println("  Est. p-quantile: " + pval());
		System.out.println("  Act. p-quantile: " + inputData.median);
		System.out.println("  Error: " + Math.abs(pval() - inputData.median));
	}

	private double min() {
		return q[0];
	}

	private double pval() {
		return q[numMarkers / 2];
	}

	private double max() {
		return q[numMarkers - 1];
	}

	private void newData(double newVal) {
		if (numSeen < 5) {
			// Store first five elements as marker heights and sort them
			q[numSeen] = newVal;
			if (numSeen == 4)
				sort();
		} else {
			// Find markers that the new value fits between
			int k = 6;
			if (newVal < q[0]) {
				q[0] = newVal;
				k = 1;
			} else if (q[0] <= newVal && newVal < q[1]) {
				k = 1;
			} else if (q[1] <= newVal && newVal < q[2]) {
				k = 2;
			} else if (q[2] <= newVal && newVal < q[3]) {
				k = 3;
			} else if (q[3] <= newVal && newVal <= q[4]) {
				k = 4;
			} else if (q[4] < newVal) {
				q[4] = newVal;
				k = 4;
			}
			if (k == 6) {
				System.out.println("Can't find k for new data element!");
				System.exit(0);
			}
			// Increment markers from k + 1 to 5
			for (int i = k; i < 5; i++)
				n[i]++;
			// Update desired positions for all markers
			for (int i = 0; i < 5; i++)
				nDes[i] += dnDes[i];
			// Adjust heights of markers 2 - 4 if needed
			for (int i = 1; i < 4; i++) {
				double d = nDes[i] - n[i];
				if ((d >= 1 && n[i + 1] - n[i] > 1)
						|| (d <= -1 && n[i - 1] - n[i] < -1)) {
					int di = (int) (d / Math.abs(d)); // Equiv: di <- sign(d)
					// Try using parabolic formula
					double qDes = parabolaAdj(di, i);
					// If new value moves marker past another, use linear.
					if (q[i - 1] < qDes && qDes < q[i + 1]) {
						q[i] = qDes;
					} else {
						q[i] = linearAdj(di, i);
					}
					// Adjust marker position
					n[i] += di;
				}
			}
		}
	}

	double parabolaAdj(int d, int i) {
		// Break up formula for my own sanity
		int niminus = n[i] - n[i - 1];
		int niplus = n[i + 1] - n[i];
		double a = (double) d / (niplus + niminus);
		double c = (q[i + 1] - q[i]) / niplus;
		double f = (q[i] - q[i - 1]) / niminus;
		return q[i] + a * (((niminus + d) * c) + ((niplus - d) * f));
	}

	double linearAdj(int d, int i) {
		double a = (q[i + d] - q[i]) / (n[i + d] - n[i]);
		return q[i] + d * a;
	}

	void sort() {
		int mi;
		double m;
		for (int i = 0; i < numMarkers - 1; i++) {
			/* find the minimum */
			mi = i;
			for (int j = i + 1; j < numMarkers; j++) {
				if (q[j] < q[mi]) {
					mi = j;
				}
			}
			m = q[mi];
			/* move elements to the right */
			for (int j = mi; j > i; j--) {
				q[j] = q[j - 1];
			}
			q[i] = m;
		}
	}

}
