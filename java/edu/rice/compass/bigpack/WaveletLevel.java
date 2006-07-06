/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'WaveletLevel'
 * message type.
 */

package edu.rice.compass.bigpack;

public class WaveletLevel extends BigPack {
	
	private static int staticDataLen = size_nbCount() + size_nbPtr();

	public WaveletLevel(WaveletNeighbor nb[]) {
		super(staticDataLen, nb);
		set_nbCount((short) nb.length);
		int arrayDataLen = nb[0].dataLength() * nb.length;
		addPointer(addBlock(staticDataLen, arrayDataLen), 
							 addBlock(offset_nbCount(), staticDataLen), 
							 offset_nbPtr());
	}

	// Message-type-specific access methods appear below.

	// ///////////////////////////////////////////////////////
	// Accessor methods for field: nbCount
	// Field type: short
	// Offset (bits): 0
	// Size (bits): 8
	// ///////////////////////////////////////////////////////

	/**
	 * Return whether the field 'nbCount' is signed (false).
	 */
	public static boolean isSigned_nbCount() {
		return false;
	}

	/**
	 * Return whether the field 'nbCount' is an array (false).
	 */
	public static boolean isArray_nbCount() {
		return false;
	}

	/**
	 * Return the offset (in bytes) of the field 'nbCount'
	 */
	public static int offset_nbCount() {
		return (0 / 8);
	}

	/**
	 * Return the offset (in bits) of the field 'nbCount'
	 */
	public static int offsetBits_nbCount() {
		return 0;
	}

	/**
	 * Return the value (as a short) of the field 'nbCount'
	 */
	public short get_nbCount() {
		return (short) getUIntElement(offsetBits_nbCount(), 8);
	}

	/**
	 * Set the value of the field 'nbCount'
	 */
	public void set_nbCount(short value) {
		setUIntElement(offsetBits_nbCount(), 8, value);
	}

	/**
	 * Return the size, in bytes, of the field 'nbCount'
	 */
	public static int size_nbCount() {
		return (8 / 8);
	}

	/**
	 * Return the size, in bits, of the field 'nbCount'
	 */
	public static int sizeBits_nbCount() {
		return 8;
	}

	// ///////////////////////////////////////////////////////
	// TEMP STORAGE SPACE, WILL BE OVERWRITTEN!
	// Accessor methods for field: nbPtr
	// Field type: unsigned int
	// Offset (bits): 8
	// Size (bits): 16
	// ///////////////////////////////////////////////////////

	/**
	 * Return the size, in bytes, of the field 'nbPtr'
	 */
	private static int size_nbPtr() {
		return (16 / 8);
	}

	/**
	 * Return the offset (in bytes) of the field 'nbPtr'
	 */
	public static int offset_nbPtr() {
		return (8 / 8);
	}

}