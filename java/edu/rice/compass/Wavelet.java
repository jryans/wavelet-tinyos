/**
 * Stores constants shared between the various Wavelet classes.
 * @author Ryan Stinnett
 */

package edu.rice.compass;

public class Wavelet {
	
	// TODO: Move wavelet config specific types out of here

	

	
	
	/* C Boolean */
	private static final short C_FALSE = 0;
	private static final short C_TRUE = 1;
	
	/* C Type Helpers */
	
	public static short b2Cs(boolean b) {
		if (b) return C_TRUE;
		return C_FALSE;
	}

}
