package edu.rice.compass;

public class MoteData {
	float lightraw[];
	float lightwt[];
	float tempraw[];
	float tempwt[];
	
	public MoteData() {
		
	}

	public MoteData(int numMotes) {
		lightraw = new float[numMotes];
		lightwt = new float[numMotes];
		tempraw = new float[numMotes];
		tempwt = new float[numMotes];
	}

	public float[] getLightraw() {
		return lightraw;
	}

	public void setLightraw(float[] lightraw) {
		this.lightraw = lightraw;
	}

	public float[] getLightwt() {
		return lightwt;
	}

	public void setLightwt(float[] lightwt) {
		this.lightwt = lightwt;
	}

	public float[] getTempraw() {
		return tempraw;
	}

	public void setTempraw(float[] tempraw) {
		this.tempraw = tempraw;
	}

	public float[] getTempwt() {
		return tempwt;
	}

	public void setTempwt(float[] tempwt) {
		this.tempwt = tempwt;
	}

}

