package edu.rice.compass;

public class WaveletConfig {
	/*** Matlab Data ***/
	double[] mScale;
	Object[] mPredNB;
	Object[] mPredCoeff;
	Object[] mUpdCoeff;
    
	/* public WaveletConfig() {
		
	} */
	
	public WaveletConfig(double[] scale, Object[] predNB, 
						 Object[] predCoeff, Object[] updCoeff) {
		mScale = scale;
		mPredNB = predNB;
		mPredCoeff = predCoeff;
		mUpdCoeff = updCoeff;
	}

	/* public Object[] getMPredCoeff() {
		return mPredCoeff;
	}

	public void setMPredCoeff(Object[] predCoeff) {
		mPredCoeff = predCoeff;
	}

	public Object[] getMPredNB() {
		return mPredNB;
	}

	public void setMPredNB(Object[] predNB) {
		mPredNB = predNB;
	}

	public double[] getMScale() {
		return mScale;
	}

	public void setMScale(double[] scale) {
		mScale = scale;
	}

	public Object[] getMUpdCoeff() {
		return mUpdCoeff;
	}

	public void setMUpdCoeff(Object[] updCoeff) {
		mUpdCoeff = updCoeff;
	} */
}
