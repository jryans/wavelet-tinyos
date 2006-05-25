/*
 * Combines various mote datatypes into a generic MessageData type.
 */

includes MoteCommand
includes RawData
includes WaveletData

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