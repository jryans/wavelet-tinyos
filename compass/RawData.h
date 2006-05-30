/*
 * Defines a datatype to carry raw sensor values called RawData.
 */
 
includes Sensors;

typedef struct
{
	uint16_t value[NUM_SENSORS]		// Holds one value for each sensor listed in Sensors.h
} RawData;