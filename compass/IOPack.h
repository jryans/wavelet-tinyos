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
  TR_BROAD = 5,
  TR_UNI = 6,
  TR_ROUTE = 7
};

enum {
  RO_INIT,
  RO_READY
};

#endif // _IOPACK_H
