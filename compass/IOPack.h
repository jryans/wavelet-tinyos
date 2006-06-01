/*
 * Combines various I/O packets into a generic type.
 */

#ifndef _IOPACK_H
#define _IOPACK_H

#include "BroadcastPack.h"

union IOPack {
  BroadcastPack bcast;
} __attribute__ ((packed));

enum  // Types of transceivers in use
{
  TR_COMPASS = 5
};

#endif // _IOPACK_H
