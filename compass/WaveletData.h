/**
 * Defines various datatypes and constants used by the wavelet
 * application, including packets for obtaining configuration
 * data over the network.  Getting to be a bit struct-crazy...
 * @author Ryan Stinnett
 */

#ifndef _WAVELETDATA_H
#define _WAVELETDATA_H

#include "Sensors.h"

/*** Internal Wavelet Data ***/

typedef struct { // Describes each neighbor mote
  uint16_t id; // ID number of the mote 
  uint8_t state; // State this mote will have in this level
  float coeff; // WT coeff for the mote
	float value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} __attribute__ ((packed)) WaveletNeighbor;

typedef struct {
  uint8_t nbCount; // Number of neighbors at this level
  WaveletNeighbor *nb; // Array of WaveletNeighbors
} __attribute__ ((packed)) WaveletLevel;

/*** Transmitted Data ***/

typedef struct {
  uint8_t dataSet; // Data set this data belongs to
	uint8_t level; // Wavelet level this data belongs to
	uint8_t state; // State this mote has in this level
	float value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} __attribute__ ((packed)) WaveletData;

/*** Big Pack Data ***/

typedef struct wn { // Describes each neighbor mote
  uint16_t id; // ID number of the mote 
  uint8_t state; // State this mote will have in this level
  float coeff; // WT coeff for the mote
} __attribute__ ((packed)) ExtWaveletNeighbor;

typedef struct wl {
  uint8_t nbCount; // Number of neighbors at this level
  ExtWaveletNeighbor *nb; // Array of ExtWaveletNeighbors
} __attribute__ ((packed)) ExtWaveletLevel;

typedef struct wc {
  uint8_t numLevels; 
  ExtWaveletLevel **level; // Array of ExtWaveletLevels
} __attribute__ ((packed)) ExtWaveletConf;

/*** State Control ***/

// Used by the PC to query and set state
typedef struct { 
  uint8_t state; // One the states from WaveletM
  uint32_t dataSetTime; // Length of time between data sets (and samples) 
} __attribute__ ((packed)) WaveletState;

#endif // _WAVELETDATA_H
