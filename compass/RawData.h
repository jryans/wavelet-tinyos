/*
 * Defines a datatype to carry raw sensor values called RawData.
 */
 
#ifndef _RAWDATA_H
#define _RAWDATA_H
 
#include "Sensors.h"

typedef struct {
	uint16_t value[NUM_SENSORS];		// Holds one value for each sensor listed in Sensors.h
} RawData;

#endif // _RAWDATA_H
