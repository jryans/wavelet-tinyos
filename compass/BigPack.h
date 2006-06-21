/**
 * Defines generic packets used for transferring multipacket data.
 * @author Ryan Stinnett
 */

#ifndef _BIGPACK_H
#define _BIGPACK_H

#include "PackOffsets.h"

typedef struct {
  uint8_t requestType; // Type of big pack request
  uint8_t packTotal; // Total number of packs
  uint16_t bytesTotal; // Length of data in bytes
} __attribute__ ((packed)) BigPackHeader;

enum {
  BP_DATA_LEN = UPACK_MSG_DATA_LEN - 1
};

typedef struct {
  uint8_t curPack; // Current pack number
  uint8_t data[BP_DATA_LEN]; // Data
} __attribute__ ((packed)) BigPackData;

enum {
  WAVELETCONF = 0
};

#endif // _BIGPACK_H
