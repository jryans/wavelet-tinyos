/**
 * Describes a broadcast ping message used for testing link quality.
 * @author Ryan Stinnett
 */

#ifndef _PING_H
#define _PING_H

typedef struct { // Broadcast Ping Msg
  uint16_t seqNum; // Current sequence number
} __attribute__ ((packed)) PingMsg;

enum {
  AM_PINGMSG = 100,
  PING_INTERVAL = 30
};

#endif // _PING_H
