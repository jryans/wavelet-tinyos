/*
 * Combines various mote datatypes into a generic MessageData type.
 */

#ifndef _MESSAGEDATA_H
#define _MESSAGEDATA_H

#include "MoteCommand.h"
#include "RawData.h"
#include "WaveletData.h"

struct MessageData
{
	int16_t src;
	int16_t dest;
	uint8_t type;
	
	union
	{
		MoteCommand moteCmd;
		RawData raw;
		WaveletData wavelet;
	} data;
} __attribute__ ((packed));

typedef struct MessageData *msgPtr;
typedef struct MessageData msgData;
  
enum  // Identifies the type of data stored
{
	MOTECOMMAND,
	RAWDATA,
	WAVELETDATA,
};

enum  // Identifies special message destinations
{
	ALL_NODES = -1
};

#endif // _MESSAGEDATA_H
