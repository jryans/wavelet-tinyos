/**
 * Describes a message for changing the routing configuration
 * at runtime.
 * @author Ryan Stinnett
 */

#ifndef _ROUTER_H
#define _ROUTER_H

typedef struct
{
  bool enable; // TRUE: enable link FALSE: disable link
  uint16_t mote; // ID of mote whose link will be altered
} __attribute__ ((packed)) RouterData;

#endif // _ROUTER_H
