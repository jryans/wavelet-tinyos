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
  uint8_t receiver; // ID of the components to send to
  result_t finalAns;
  bool sent;
  bool complete;
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
  PM_APP = 1,
  PM_SENSOR = 2,
  PM_LED = 4,
  PM_UART = 8,
  PM_NET = 16,
  PM_MAX = 16
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
