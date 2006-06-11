/*
 * Combines various I/O packets into a generic type and defines routing constants.
 */

#ifndef _IOPACK_H
#define _IOPACK_H

#include "BroadcastPack.h"
#include "UnicastPack.h"

// Assigns one type for each component that uses Transceiver
// to prevent conflicts.
enum  
{
  AM_BROADCASTPACK = 5,
  AM_UNICASTPACK = 6,
  AM_ROUTER = 7
};

enum {
  RO_INIT,
  RO_READY
};

#endif // _IOPACK_H
