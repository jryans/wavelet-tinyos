package edu.rice.compass;

public class WaveletConfig {
	/*** Matlab Data ***/
	double[] mScales;
	double[][] mPredNB;
    double[][] mPredCoeff;
    double[][] mUpdCoeff;
    
    
	public WaveletConfig(double[] scales, double[][] predNB, 
			             double[][] predCoeff, double[][] updCoeff) {
		mScales = scales;
		mPredNB = predNB;
		mPredCoeff = predCoeff;
		mUpdCoeff = updCoeff;
	}
}
