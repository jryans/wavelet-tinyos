/**
 * MATLAB uses this class to write out its calculated data
 * into XML format for later use by other Java code.
 */
package edu.rice.compass;

import java.io.*;

public class WaveletConfigXml {
	
	/**
	 * Stores the parameters in a WaveletConfig and writes that out
	 * to an XML file.
	 */
	public WaveletConfigXml(double[] scales, Object[] predNB,
			                Object[] predCoeff, Object[] updCoeff) throws IOException {
		WaveletConfig conf = new WaveletConfig(scales, predNB, predCoeff, updCoeff);		
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\apps\\compass\\waveletConfig.dat";
		FileOutputStream fs = new FileOutputStream(path);
		ObjectOutputStream obj = new ObjectOutputStream(fs);
		
		obj.writeObject(conf);
		obj.close();
	}
}
