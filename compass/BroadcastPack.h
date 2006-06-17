/**
 * I converted the TinyOS library Bcast to a version that makes use of the
 * Transceiver library.
 * @author Ryan Stinnett
 */

#ifndef _BROADCASTPACK_H
#define _BROADCASTPACK_H

#include "MessageData.h"

struct BroadcastPack {
  int16_t seqno;
  msgData data;
} __attribute__ ((packed));

typedef struct BroadcastPack bPack;

enum {
  BCAST_REP_DELAY = 300,
  BCAST_REPEATS = 3
};

#endif /* _BROADCASTPACK_H */
