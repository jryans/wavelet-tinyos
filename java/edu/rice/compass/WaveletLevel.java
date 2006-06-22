/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'WaveletLevel'
 * message type.
 */

package edu.rice.compass;

public class WaveletLevel extends net.tinyos.message.Message {		

    public WaveletLevel(WaveletNeighbor nb[]) {
    	super(size_nbCount() + size_nbPtr() + elementSize_nb() * nb.length);
    	set_nbCount((short)nb.length);
    	set_nb(nb);
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: nbCount
    //   Field type: short
    //   Offset (bits): 0
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

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
        return (short)getUIntElement(offsetBits_nbCount(), 8);
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

    /////////////////////////////////////////////////////////
    // TEMP STORAGE SPACE, WILL BE OVERWRITTEN!
    // Accessor methods for field: nbPtr
    //   Field type: unsigned int
    //   Offset (bits): 8
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return the size, in bytes, of the field 'nbPtr'
     */
    private static int size_nbPtr() {
        return (16 / 8);
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: nb
    //   Field type: WaveletNeighbor[]
    //   Offset (bits): 24
    //   Size of each element (bits): exNB.dataLength() * 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'nb' is signed (false).
     */
    public static boolean isSigned_nb() {
        return false;
    }

    /**
     * Return whether the field 'nb' is an array (true).
     */
    public static boolean isArray_nb() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'nb'
     */
    public int offset_nb(int index1) {
        int offset = 24;
        if (index1 < 0 || index1 >= get_nbCount()) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * elementSizeBits_nb();
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'nb'
     */
    public int offsetBits_nb(int index1) {
        int offset = 24;
        if (index1 < 0 || index1 >= get_nbCount()) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * elementSizeBits_nb();
        return offset;
    }

    /**
     * Return the entire array 'nb' as a WaveletNeighbor[]
     */
    public WaveletNeighbor[] get_nb() {
        WaveletNeighbor[] tmp = new WaveletNeighbor[get_nbCount()];
        for (int index0 = 0; index0 < numElements_nb(0); index0++) {
            tmp[index0] = getElement_nb(index0);
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'nb' from the given WaveletNeighbor[]
     */
    public void set_nb(WaveletNeighbor[] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
            setElement_nb(index0, value[index0]);
        }
    }

    /**
     * Return an element (as a WaveletNeighbor) of the array 'nb'
     */
    public WaveletNeighbor getElement_nb(int index1) {
        return new WaveletNeighbor(dataGet(offset_nb(index1), elementSize_nb()));
    }

    /**
     * Set an element of the array 'nb'
     */
    public void setElement_nb(int index1, WaveletNeighbor value) {
        dataSet(value, offset_nb(index1));
    }

    /**
     * Return the total size, in bytes, of the array 'nb'
     */
    public int totalSize_nb() {
        return (elementSizeBits_nb() * get_nbCount() / 8);
    }

    /**
     * Return the total size, in bits, of the array 'nb'
     */
    public int totalSizeBits_nb() {
        return elementSizeBits_nb() * get_nbCount();
    }

    /**
     * Return the size, in bytes, of each element of the array 'nb'
     */
    public static int elementSize_nb() {
    	  WaveletNeighbor exNB = new WaveletNeighbor();
        return exNB.dataLength();
    }

    /**
     * Return the size, in bits, of each element of the array 'nb'
     */
    public static int elementSizeBits_nb() {
        return elementSize_nb() * 8;
    }

    /**
     * Return the number of dimensions in the array 'nb'
     */
    public static int numDimensions_nb() {
        return 1;
    }

    /**
     * Return the number of elements in the array 'nb'
     */
    public int numElements_nb() {
        return get_nbCount();
    }

    /**
     * Return the number of elements in the array 'nb'
     * for the given dimension.
     */
    public int numElements_nb(int dimension) {
      int array_dims[] = { get_nbCount(),  };
        if (dimension < 0 || dimension >= 1) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

}
