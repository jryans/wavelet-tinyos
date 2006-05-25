/*
 * Combines various mote datatypes into a generic MessageData type.
 */

#include "MoteCommand.h"
#include "RawData.h"
#include "WaveletData.h"

union MessageData
{
	MoteCommand moteCmd;
	RawData raw;
	WaveletData wavelet;
};

enum  // Identifies the type of data stored
{
	MOTECOMMAND = 1,
	RAWDATA = 2,
	WAVELETDATA = 3
};