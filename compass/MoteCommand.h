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
	uint8_t cmd;    // One of the above commands
} MoteCommand;

#endif // _MOTECOMMAND_H