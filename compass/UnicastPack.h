/**
 * Describes a unicast networking pack
 * @author Ryan Stinnett
 */

#ifndef _UNICASTPACK_H
#define _UNICASTPACK_H

#include "MessageData.h"

struct UnicastPack {
  uint8_t retriesLeft;
  msgData data;
} __attribute__ ((packed));

typedef struct UnicastPack uPack;

enum {
  RADIO_RETRIES = 0
};

#endif /* _UNICASTPACK_H */
