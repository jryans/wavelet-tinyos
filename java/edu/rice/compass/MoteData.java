package edu.rice.compass;

import java.io.*;

public class MoteData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	// value[dataset][sensor][mote]
	float value[][][];
	
	public MoteData() {
		
	}

	public MoteData(int sets, int sens, int motes) {
		value = new float[sets][2 * sens][motes];
	}

	public float[][][] getValue() {
		return value;
	}

	public void setValue(float[][][] value) {
		this.value = value;
	}

}

