/**
 * Defines the data carried in a MoteCommand message.
 * @author Ryan Stinnett
 */

#ifndef _MOTECOMMAND_H
#define _MOTECOMMAND_H

enum   // Commands that can be sent
{
	YELLOW_LED_ON = 1,
	YELLOW_LED_OFF = 2,
	GREEN_LED_ON = 3,
	GREEN_LED_OFF = 4,
	RED_LED_ON = 5,
	RED_LED_OFF = 6,
	YELLOW_LED_TOG = 7,
	GREEN_LED_TOG = 8,
	RED_LED_TOG = 9,
	BEEP_ON = 10
};

typedef struct
{
	uint8_t cmd;    // One of the above commands
} MoteCommand;

#endif // _MOTECOMMAND_H
