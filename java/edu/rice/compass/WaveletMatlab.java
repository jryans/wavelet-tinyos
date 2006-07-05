/**
 * MATLAB uses this class to write out its calculated data
 * into XML format for later use by other Java code.
 */
package edu.rice.compass;

import java.io.*;
import com.thoughtworks.xstream.*;

public class WaveletMatlab {

	private static XStream xs = new XStream();
	
	private WaveletMatlab() {}

	/**
	 * Stores the parameters in a WaveletConfig and writes that out to an XML
	 * file.
	 */
	public static void saveConfig(double[] scales, Object[] predNB,
			Object[] predCoeff, Object[] updCoeff) {
		WaveletConfigData conf = new WaveletConfigData(scales, predNB, predCoeff, updCoeff);
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
		try {
			FileOutputStream fs = new FileOutputStream(path);
			xs.toXML(conf, fs);
			fs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static float[][][] loadData() {
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletData.xml";
		WaveletData mData = new WaveletData();
		try {
			FileInputStream fs = new FileInputStream(path);
			mData = (WaveletData) xs.fromXML(fs);
			fs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mData.value;
	}
}