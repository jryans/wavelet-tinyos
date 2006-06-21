/*
 * Combines various mote datatypes into a generic MessageData type.
 */

#ifndef _MESSAGEDATA_H
#define _MESSAGEDATA_H

#include "MoteCommand.h"
#include "WaveletData.h"
#include "Stats.h"
#include "BigPack.h"

struct MessageData {
	uint16_t src;
	uint16_t dest;
	uint8_t type;
	union {
		MoteCommand moteCmd;
		WaveletData wData;
    WaveletConfData wConfData;
    WaveletConfHeader wConfHeader;
    BigPackHeader bpHeader;
    BigPackData bpData;
    WaveletState wState;
    MoteStats stats;
	} data;
} __attribute__ ((packed));

typedef struct MessageData msgData;
  
enum { // Identifies the type of data stored
	MOTECOMMAND = 0,
	WAVELETDATA = 1,
	WAVELETCONFDATA = 2,
	WAVELETCONFHEADER = 3,
	BIGPACKHEADER = 2,
	BIGPACKDATA = 3,
	WAVELETSTATE = 4,
	MOTESTATS = 5
};

#endif // _MESSAGEDATA_H
