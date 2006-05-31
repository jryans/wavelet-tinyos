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

struct _msgEntry
{
  struct MessageData aMsg;
  uint8_t refs; // Tracks how many components 
  uint8_t poster; // ID of the component that posted the message
  result_t finalAns;
  bool sent;
);

typedef struct _msgEntry *msgEntry;
  
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
  PM_APP,
  PM_SENSOR,
  PM_LED,
  PM_UART,
  PM_NET
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
