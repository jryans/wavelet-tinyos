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

enum  // Types of transceivers in use
{
	TR_UART,
	TR_RADIO
};

enum
{
	UART_RETRIES = 2
};

#endif // _MESSAGEDATA_H 