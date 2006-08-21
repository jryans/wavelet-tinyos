/**
 * Combines various mote datatypes into a generic MessageData type.
 * @author Ryan Stinnett
 */

#ifndef _MESSAGEDATA_H
#define _MESSAGEDATA_H

#include "MoteOptions.h"
#include "Wavelet.h"
#include "BigPack.h"
#include "Router.h"

// Basic data payload unit
struct MessageData {
	uint16_t src;
	uint16_t dest;
	uint8_t type;
	union {
		MoteOptData opt;
		WaveletData wData;
    BigPackHeader bpHeader;
    BigPackData bpData;
    WaveletControl wCntl;
    RouterData rData;
    PwrControl pCntl;
    uint32_t cTime;
	} data;
} __attribute__ ((packed));

typedef struct MessageData msgData;
  
enum { // Identifies the type of data stored
	MOTEOPTIONS = 0,
	WAVELETDATA = 1,
	BIGPACKHEADER = 2,
	BIGPACKDATA = 3,
	WAVELETCONTROL = 4,
	ROUTERDATA = 5,
	PWRCONTROL = 6,
	COMPTIME = 7
};

#endif // _MESSAGEDATA_H
