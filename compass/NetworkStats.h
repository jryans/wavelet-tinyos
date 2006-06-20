/**
 * NetworkStats message that sends various details about the mote's
 * network packets on request.
 * @author Ryan Stinnett
 */

#ifndef _NETWORKSTATS_H
#define _NETWORKSTATS_H

typedef struct {
  uint16_t rcvd; // Packets received (2)
  float rssi; // Sum of RSSI over mote lifetime (4)
  uint16_t sent; // Packets sent (2)
  uint16_t acked; // Packets sent and were ACKed (2)  
} __attribute__ ((packed)) NetworkStats;

#endif // _NETWORKSTATS_H
