/**
 * Defines various datatypes and constants used by the wavelet
 * application, including packets for obtaining configuration
 * data over the network.  Getting to be a bit struct-crazy...
 * @author Ryan Stinnett
 */

#ifndef _WAVELETDATA_H
#define _WAVELETDATA_H

#include "Sensors.h"

/*** Constants ***/

enum {
  WT_MAX_LEVELS = 10, // Should be able to go up to 22 without changing
                      // config transfer algorithm.
  WT_MOTE_PER_CONFDATA = 3
};

/*** Internal Wavelet Data ***/

typedef struct {
  uint16_t id; // ID number of the mote 
  float coeff; // WT coeff for the mote (neg: predict, pos: update)
} __attribute__ ((packed)) MoteInfo;

typedef struct {
	uint8_t state; // State this mote will have in this level
	float value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} __attribute__ ((packed)) IntWaveletData;

typedef struct { // One MoteInfo and IntWaveletData for each neighbor
  MoteInfo info;
  IntWaveletData data;
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

typedef struct {
  uint8_t numLevels; // Total number of WT levels that will be coming
  uint8_t nbCount[WT_MAX_LEVELS]; // Number of neighbors for each level
} __attribute__ ((packed)) WaveletConfHeader;

typedef struct { // Slight reorganization of data for initial transfer and setup
  // FIX: id should be 16 bits, not enough room
  uint8_t id; // ID number of the mote 
  uint8_t state; // State this mote will have in this level
	float coeff; // WT coeff for the mote (neg: predict, pos: update)
} __attribute__ ((packed)) WaveletConfMote;

typedef struct {
  uint8_t level; // Current level being transmitted
  uint8_t packNum; // Sequential packet number in that level
  uint8_t moteCount; // Number of motes in this pack
  WaveletConfMote moteConf[WT_MOTE_PER_CONFDATA]; // Array of MoteInfos
} __attribute__ ((packed)) WaveletConfData;

/*** State Control ***/

// Used by the PC to query and set state
typedef struct { 
  uint8_t state; // One the states from WaveletM
  uint32_t dataSetTime; // Length of time between data sets (and samples) 
} __attribute__ ((packed)) WaveletState;

#endif // _WAVELETDATA_H
