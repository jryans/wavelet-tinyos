/*
 * Defines a datatype to carry wavelet values called WaveletData.
 */

#ifndef _WAVELETDATA_H
#define _WAVELETDATA_H

#include "Sensors.h"

typedef struct 
{
	uint16_t value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} WaveletData;

#endif // _WAVELETDATA_H
