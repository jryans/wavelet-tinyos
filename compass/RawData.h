/*
 * Defines a datatype to carry raw sensor values called RawData.
 */

typedef struct
{
	uint16_t value[2]		// Holds one value for each sensor (only two sensors for now)
} RawData;