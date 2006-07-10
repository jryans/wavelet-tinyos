/**
 * Describes a unicast networking pack
 * @author Ryan Stinnett
 */

#ifndef _UNICASTPACK_H
#define _UNICASTPACK_H

#include "MessageData.h"

struct UnicastPack {
  //uint16_t hops;  Takes up too much space...
  uint8_t retriesLeft;
  msgData data;
} __attribute__ ((packed));

typedef struct UnicastPack uPack;

enum {
  NET_UART_ADDR = 0xfffe
};

#endif /* _UNICASTPACK_H */
