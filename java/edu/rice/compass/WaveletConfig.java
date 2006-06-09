package edu.rice.compass;

import java.io.*;

public class WaveletConfig implements Serializable {
	/*** Matlab Data ***/
	double[] mScale;
	Object[] mPredNB;
	Object[] mPredCoeff;
	Object[] mUpdCoeff;
    
	public WaveletConfig(double[] scale, Object[] predNB, 
						 Object[] predCoeff, Object[] updCoeff) {
		mScale = scale;
		mPredNB = predNB;
		mPredCoeff = predCoeff;
		mUpdCoeff = updCoeff;
	}
}
