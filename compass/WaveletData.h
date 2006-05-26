/*
 * Defines a datatype to carry wavelet values called WaveletData.
 */

typedef struct 
{
	uint16_t value[2]		// Holds one value for each sensor (only two sensors for now)
} WaveletData;