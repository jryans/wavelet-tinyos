/*
 * Combines various mote datatypes into a generic MessageData type.
 */

#ifndef _MESSAGEDATA_H
#define _MESSAGEDATA_H

#include "MoteOptions.h"
#include "WaveletData.h"
#include "BigPack.h"
#include "Router.h"

struct MessageData {
	uint16_t src;
	uint16_t dest;
	uint8_t type;
	union {
		MoteOptData opt;
		WaveletData wData;
    BigPackHeader bpHeader;
    BigPackData bpData;
    WaveletState wState;
    RouterData rData;
	} data;
} __attribute__ ((packed));

typedef struct MessageData msgData;
  
enum { // Identifies the type of data stored
	MOTEOPTIONS = 0,
	WAVELETDATA = 1,
	BIGPACKHEADER = 2,
	BIGPACKDATA = 3,
	WAVELETSTATE = 4,
	ROUTERDATA = 5
};

#endif // _MESSAGEDATA_H
