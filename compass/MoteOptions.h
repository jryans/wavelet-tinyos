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
  uint8_t txPower; // (MICAZ) Sets the TX power level (valid: 1 - 31)
  bool rfAck; // (MICAZ) Toggles ACK support (d: on)
  uint16_t radioOffTime; // (MICAZ) Number of seconds to disable radio
  bool hplPM; // Toggles HPLPowerManagement (d: off)
  uint8_t rfChan; // (MICAZ) Sets the RF channel (valid: 11 - 26)
} MoteOptData;

enum { // Bitmasks
  MO_DIAGMODE = 0x01,
  MO_TXPOWER = 0x02,
  MO_CLEARSTATS = 0x04,
  MO_RFACK = 0x08,
  MO_RADIOOFFTIME = 0x10,
  MO_HPLPM = 0x20,
  MO_RFCHAN = 0x40
};

#endif // _MOTEOPTIONS_H
