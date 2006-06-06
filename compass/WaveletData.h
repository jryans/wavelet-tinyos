/*
 * Defines a datatype to carry wavelet values called WaveletData.
 */

#ifndef _WAVELETDATA_H
#define _WAVELETDATA_H

#include "Sensors.h"

typedef struct 
{
	uint8_t state;
	uint16_t value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} WaveletData;

enum {
  WT_LEVELS = 3,
  WT_NEIGHBORS = 7
};

#endif // _WAVELETDATA_H
