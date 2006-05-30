/*
 * Combines various mote datatypes into a generic MessageData type.
 */

includes MoteCommand;
includes RawData;
includes WaveletData;

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
};
  
enum  // Identifies the type of data stored
{
	MOTECOMMAND,
	RAWDATA,
	WAVELETDATA
};

enum  // Identifies special message destinations
{
	SINK = -2,
	BROADCAST = -1
};

enum  // Types of transceivers in use
{
	UART,
	RADIO
};

enum
{
	UART_RETRIES = 2
};