/* 
 * Defines the data carried in a MoteCommand message.
 */

#ifndef _MOTECOMMAND_H
#define _MOTECOMMAND_H

enum   // Commands that can be sent
{
	YELLOW_LED_ON = 1,
	YELLOW_LED_OFF = 2,
	GREEN_LED_ON = 3,
	GREEN_LED_OFF = 4,
	START_SENSING = 5,
	WAVELET = 6
};

typedef struct
{
	int8_t seqno;   // the sequence number of this command; we use this in flooding to make sure we
                  // don't keep broadcasting the same commands over and over
	uint8_t action; // the number of the command to be executed
} MoteCommand;

#endif // _MOTECOMMAND_H