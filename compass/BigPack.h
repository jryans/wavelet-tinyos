/**
 * Defines generic packets used for transferring multipacket data.
 * @author Ryan Stinnett
 */

#ifndef _BIGPACK_H
#define _BIGPACK_H

#include "PackOffsets.h"

typedef struct bb {
  uint16_t start; // Position where this block starts in the data stream
  uint16_t length; // Length of the data block in bytes
} __attribute__ ((packed)) BigPackBlock;

typedef struct bp {
  uint8_t addrOfBlock; // Block ID whose address will be the value of the pointer
  uint8_t destBlock; // Block ID that contains the pointer
  uint8_t destOffset; // Pointer's location as an offset from the start of destBlock
  bool blockArray; // TRUE if this points to an array of blocks, rather than just a single block
} __attribute__ ((packed)) BigPackPtr;

/* enum {
  MAX_BLOCKS = 2,
	MAX_PTRS = 1
}; */

typedef struct {
  uint8_t requestType; // Type of big pack request
  uint8_t packTotal; // Total number of packs
  uint16_t byteTotal; // Length of data in bytes
  uint8_t numBlocks; // Number of data blocks
  uint8_t numPtrs; // Number of pointers that need to be rebuilt
} __attribute__ ((packed)) BigPackHeader;


enum {
  BP_DATA_LEN = UPACK_MSG_DATA_LEN - 1
};

typedef struct {
  uint8_t curPack; // Current pack number
  int8_t data[BP_DATA_LEN]; // Data
} __attribute__ ((packed)) BigPackData;

enum {
  WAVELETCONF = 0
};

#endif // _BIGPACK_H
