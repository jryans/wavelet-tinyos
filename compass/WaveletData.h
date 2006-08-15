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

// Based on diagram at http://www.gliffy.com/publish/1039648/L
enum { // State Timing Table
  WD_CLEAR_SENSORS_TO_READING_SENSORS = 1000,
  WD_READING_SENSORS_TO_UPDATING = 1000,
  WD_READING_SENSORS_TO_OTHER = 500,
}

typedef struct {
  uint32_t sampleTime; // Length of time between samples
  uint8_t transformType; // One of various transform types
  uint8_t resultType; // Controls data sent back to base
  uint8_t timeDomainLength; // Number of data points collected for TD transform
} __attribute__ ((packed)) WaveletOpt;

enum { // Transmit Options
  WT_SLOTS = 8, // Number of transmit slots (must be power of 2)
  WT_SLOT_TIME = 50, // Length of one slot (bms)
  WT_MAX_BANDS = 5, // Maximum number of compression bands
  WT_SLOT_STAGE_TIME = WT_SLOTS * WT_SLOT_TIME, // Length of entire slot stage (bms)
  // Length of wait time after sending one band of data in compressed mode (bms)
  WT_WAIT_STAGE_TIME = 2000,
  // Length of an entire compression band (bms)                            
  WT_BAND_TIME = WT_SLOT_STAGE_TIME + WT_WAIT_STAGE_TIME
};

typedef struct {
  uint8_t numBands; // Number of bands in the following array
  float compTarget[WT_MAX_BANDS]; // Array of compression target values for each band
} __attribute__ ((packed)) WaveletComp;

typedef struct { 
  uint8_t mask; // Bit mask to mark what settings should be read
  uint8_t state; // One of the states from WaveletM
  union {
    WaveletOpt opt;
    WaveletComp comp;
  } data;
} __attribute__ ((packed)) WaveletState;

enum { // Bitmasks
  WS_STATE = 0x01,
  WS_SAMPLETIME = 0x02,
  WS_TRANSFORMTYPE = 0x04,
  WS_RESULTTYPE = 0x08,
  WS_TIMEDOMAINLENGTH = 0x10,
  WS_COMPTARGET = 0x20
};

enum { // Transform Types
  WS_TT_2DRWAGNER = 0, // 2D spatial R. Wagner
  WS_TT_1DHAAR_2DRWAGNER = 1, // 1D time Haar -> 2D spatial R. Wagner
  WS_TT_1DLINEAR_2DRWAGNER = 2 // 1D time linear -> 2D spatial R. Wagner
};

enum { // Result Masks
#ifdef RAW
  WS_RT_RAW = 0x01, // Raw values (off|on)
#endif
  WS_RT_COMP = 0x02 // Compression (off|on)
};

#endif // _WAVELETDATA_H
