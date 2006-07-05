package edu.rice.compass;

public class WaveletConfigData {
	/* Matlab Data */
	double[] mScale;
	Object[] mPredNB;
	Object[] mPredCoeff;
	Object[] mUpdCoeff;
	
	public WaveletConfigData(double[] scale, Object[] predNB, 
						 Object[] predCoeff, Object[] updCoeff) {
		mScale = scale;
		mPredNB = predNB;
		mPredCoeff = predCoeff;
		mUpdCoeff = updCoeff;
	}

}
