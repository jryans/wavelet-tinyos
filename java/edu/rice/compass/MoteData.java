package edu.rice.compass;

public class MoteData {
	
	// value[dataset][sensor][mote]
	float value[][][];
	
	public MoteData() {
		
	}

	public MoteData(int sets, int sens, int motes) {
		value = new float[sets][2 * sens][motes];
	}

	/* public float[][][] getValue() {
		return value;
	}

	public void setValue(float[][][] value) {
		this.value = value;
	} */

}

