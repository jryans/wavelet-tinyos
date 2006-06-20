/*
 * Combines various mote datatypes into a generic MessageData type.
 */

#ifndef _MESSAGEDATA_H
#define _MESSAGEDATA_H

#include "MoteCommand.h"
#include "RawData.h"
#include "WaveletData.h"
#include "Stats.h"

struct MessageData {
	uint16_t src;
	uint16_t dest;
	uint8_t type;
	union {
		MoteCommand moteCmd;
		RawData raw;
		WaveletData wData;
		WaveletConfData wConfData;
    WaveletConfHeader wConfHeader;
    WaveletState wState;
    MoteStats stats;
	} data;
} __attribute__ ((packed));

typedef struct MessageData msgData;
  
enum { // Identifies the type of data stored
	MOTECOMMAND,
	RAWDATA,
	WAVELETDATA,
	WAVELETCONFDATA,
	WAVELETCONFHEADER,
	WAVELETSTATE,
	MOTESTATS
};

#endif // _MESSAGEDATA_H
