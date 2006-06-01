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
	int8_t src;
	int8_t dest;
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
	WAVELETDATA
};

enum  // Identifies special message destinations
{
	SINK = -2,
	ALL_NODES = -1
};

enum  // Identifies components for the Postmaster
{
  PM_APP = 1,
  PM_SENSOR = 2,
  PM_LED = 4,
  PM_UART = 8,
  PM_NET = 16,
  PM_MAX = 16
};

enum
{
	UART_RETRIES = 2
};

#endif // _MESSAGEDATA_H
