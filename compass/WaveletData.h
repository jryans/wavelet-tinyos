/*
 * Defines various datatypes and constants used by the wavelet
 * application, including packets for obtaining configuration
 * data over the network.  Getting to be a bit struct-crazy...
 */

#ifndef _WAVELETDATA_H
#define _WAVELETDATA_H

#include "Sensors.h"

typedef struct {
	uint8_t state;
	uint16_t value[WT_SENSORS];		// Holds one value for each sensor (only two sensors for now)
} WaveletData;

typedef struct {
  uint16_t id; // ID number of the mote 
  float coeff; // The WT coeff for the mote (neg: predict, pos: update)
} MoteInfo;

typedef struct {
  uint8_t numLevels; // Total number of WT levels that will be coming
  uint8_t *nbCount; // Number of neighbors for each level
} WaveletConfHeader;

typedef struct {
  uint8_t level; // Current level being transmitted
  uint8_t packNum; // Sequential packet number in that level
  uint8_t moteCount; // Number of motes in this pack (max of 3)
  MoteInfo *info; // Array of up to three MoteInfos
} WaveletConfData;

typedef struct { // One MoteInfo and WaveletData for each neighbor
  MoteInfo info;
  WaveletData data;
} WaveletNeighbor;

typedef struct {
  uint8_t nbCount; // Number of neighbors at this level
  WaveletNeighbor *nb; // Array of WaveletNeighbors
} WaveletLevel;

#endif // _WAVELETDATA_H
