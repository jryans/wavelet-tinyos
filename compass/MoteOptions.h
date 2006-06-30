/**
 * Defines the setting carried in a MoteOptions message.
 * @author Ryan Stinnett
 */

#ifndef _MOTEOPTIONS_H
#define _MOTEOPTIONS_H

typedef struct
{
  uint8_t mask; // Bit mask to mark what settings should be read
  bool diagMode; // Controls diagnostic mode for testing (d: off)
  uint8_t rfPower; // If running on real motes, this will set the RF power
  bool rfAck; // Toggles ACK support on real motes (d: on)
} MoteOptData;

enum { // Bitmasks
  MO_DIAGMODE = 0x01,
  MO_RFPOWER = 0x02,
  MO_CLEARSTATS = 0x04,
  MO_RFACK = 0x08
};

#endif // _MOTEOPTIONS_H
