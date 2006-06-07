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
	public WaveletConfigXml(double[] scales, double[][] predNB,
			                double[][] predCoeff, double[][] updCoeff) throws IOException {
		WaveletConfig conf = new WaveletConfig(scales, predNB, predCoeff, updCoeff);		
		FileOutputStream fs = new FileOutputStream("waveletConfig.xml");
		ObjectOutputStream obj = new ObjectOutputStream(fs);
		
		obj.writeObject(conf);
	}
}
