/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'WaveletConf'
 * message type.
 */

package edu.rice.compass.bigpack;

public class WaveletConf extends BigPack {

	private static int staticDataLen = size_lvlCount() + size_lvlPtr();

	public WaveletConf(WaveletLevel lvl[]) {
		super(staticDataLen, lvl);
		set_lvlCount((short) lvl.length);
		addArray((BigPackBlock)blocks.get(firstMainBlk), 
				       addBlock(offset_lvlCount(), staticDataLen), 
				       offset_lvlPtr());
	}
	
	public static short getType() {
		return BP_WAVELETCONF;
	}

	// Message-type-specific access methods appear below.

	// ///////////////////////////////////////////////////////
	// Accessor methods for field: lvlCount
	// Field type: short
	// Offset (bits): 0
	// Size (bits): 8
	// ///////////////////////////////////////////////////////

	/**
	 * Return whether the field 'lvlCount' is signed (false).
	 */
	public static boolean isSigned_lvlCount() {
		return false;
	}

	/**
	 * Return whether the field 'lvlCount' is an array (false).
	 */
	public static boolean isArray_lvlCount() {
		return false;
	}

	/**
	 * Return the offset (in bytes) of the field 'lvlCount'
	 */
	public static int offset_lvlCount() {
		return (0 / 8);
	}

	/**
	 * Return the offset (in bits) of the field 'lvlCount'
	 */
	public static int offsetBits_lvlCount() {
		return 0;
	}

	/**
	 * Return the value (as a short) of the field 'lvlCount'
	 */
	public short get_lvlCount() {
		return (short) getUIntElement(offsetBits_lvlCount(), 8);
	}

	/**
	 * Set the value of the field 'lvlCount'
	 */
	public void set_lvlCount(short value) {
		setUIntElement(offsetBits_lvlCount(), 8, value);
	}

	/**
	 * Return the size, in bytes, of the field 'lvlCount'
	 */
	public static int size_lvlCount() {
		return (8 / 8);
	}

	/**
	 * Return the size, in bits, of the field 'lvlCount'
	 */
	public static int sizeBits_lvlCount() {
		return 8;
	}

	// ///////////////////////////////////////////////////////
	// TEMP STORAGE SPACE, WILL BE OVERWRITTEN!
	// Accessor methods for field: lvlPtr
	// Field type: unsigned int
	// Offset (bits): 8
	// Size (bits): 16
	// ///////////////////////////////////////////////////////

	/**
	 * Return the size, in bytes, of the field 'lvlPtr'
	 */
	private static int size_lvlPtr() {
		return (16 / 8);
	}

	/**
	 * Return the offset (in bytes) of the field 'lvlPtr'
	 */
	public static int offset_lvlPtr() {
		return (8 / 8);
	}

}
