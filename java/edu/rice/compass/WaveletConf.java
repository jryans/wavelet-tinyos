/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'WaveletConf'
 * message type.
 */

package edu.rice.compass;

public class WaveletConf extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 3;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = -1;

    /** Create a new WaveletConf of size 3. */
    public WaveletConf() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new WaveletConf of the given data_length. */
    public WaveletConf(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf with the given data_length
     * and base offset.
     */
    public WaveletConf(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf using the given byte array
     * as backing store.
     */
    public WaveletConf(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf using the given byte array
     * as backing store, with the given base offset.
     */
    public WaveletConf(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public WaveletConf(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf embedded in the given message
     * at the given base offset.
     */
    public WaveletConf(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new WaveletConf embedded in the given message
     * at the given base offset and length.
     */
    public WaveletConf(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <WaveletConf> \n";
      try {
        s += "  [numLevels=0x"+Long.toHexString(get_numLevels())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [level=0x"+Long.toHexString(get_level())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: numLevels
    //   Field type: short, unsigned
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'numLevels' is signed (false).
     */
    public static boolean isSigned_numLevels() {
        return false;
    }

    /**
     * Return whether the field 'numLevels' is an array (false).
     */
    public static boolean isArray_numLevels() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'numLevels'
     */
    public static int offset_numLevels() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'numLevels'
     */
    public static int offsetBits_numLevels() {
        return 0;
    }

    /**
     * Return the value (as a short) of the field 'numLevels'
     */
    public short get_numLevels() {
        return (short)getUIntElement(offsetBits_numLevels(), 8);
    }

    /**
     * Set the value of the field 'numLevels'
     */
    public void set_numLevels(short value) {
        setUIntElement(offsetBits_numLevels(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'numLevels'
     */
    public static int size_numLevels() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'numLevels'
     */
    public static int sizeBits_numLevels() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: level
    //   Field type: int, unsigned
    //   Offset (bits): 8
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'level' is signed (false).
     */
    public static boolean isSigned_level() {
        return false;
    }

    /**
     * Return whether the field 'level' is an array (false).
     */
    public static boolean isArray_level() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'level'
     */
    public static int offset_level() {
        return (8 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'level'
     */
    public static int offsetBits_level() {
        return 8;
    }

    /**
     * Return the value (as a int) of the field 'level'
     */
    public int get_level() {
        return (int)getUIntElement(offsetBits_level(), 16);
    }

    /**
     * Set the value of the field 'level'
     */
    public void set_level(int value) {
        setUIntElement(offsetBits_level(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'level'
     */
    public static int size_level() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'level'
     */
    public static int sizeBits_level() {
        return 16;
    }

}