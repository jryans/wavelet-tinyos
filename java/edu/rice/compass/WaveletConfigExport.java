/**
 * MATLAB uses this class to write out its calculated data
 * into XML format for later use by other Java code.
 */
package edu.rice.compass;

import java.io.*;
import java.beans.*;

public class WaveletConfigExport {
	
	/**
	 * Stores the parameters in a WaveletConfig and writes that out
	 * to an XML file.
	 */
	public WaveletConfigExport(double[] scales, Object[] predNB,
			                Object[] predCoeff, Object[] updCoeff) throws IOException {
		WaveletConfig conf = new WaveletConfig(scales, predNB, predCoeff, updCoeff);		
		// Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletConfig.xml";
		FileOutputStream fs = new FileOutputStream(path);
		//ObjectOutputStream obj = new ObjectOutputStream(fs);
		Thread.currentThread().setContextClassLoader(getClass().getClassLoader());
		XMLEncoder obj = new XMLEncoder(fs);
		obj.writeObject(conf);
		obj.close();
	}
	
	public WaveletConfigExport() {
		
	}
	
	public float[][] loadData() {
    // Fixed path name for now
		String path = "C:\\tinyos\\cygwin\\opt\\tinyos-1.x\\tools\\java\\edu\\rice\\compass\\waveletData.xml";
		MoteData mData = new MoteData(0);
		try {
			FileInputStream fs = new FileInputStream(path);
			Thread.currentThread().setContextClassLoader(getClass().getClassLoader());
			XMLDecoder obj = new XMLDecoder(fs);
			mData = (MoteData) obj.readObject();
			obj.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new float[][] {mData.lightraw, mData.lightwt, mData.tempraw, mData.tempwt};
	}
}