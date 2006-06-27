 /**
 * Stats message that sends various details about the mote's
 * network packets on request.
 * @author Ryan Stinnett
 */

#ifndef _STATS_H
#define _STATS_H

enum {
  MAX_STATS_REPORTS = 2
};

// Report Types

enum {
  WT_CACHE = 0
};

// Report Structs

typedef struct {
  uint8_t level; // Level when cached data was used
  uint16_t id; // ID of mote whose data was pulled from cache
} __attribute__ ((packed)) CacheReport;

typedef struct {
  uint8_t type; // Type of report
  union {
    CacheReport cache;
  } data;
  uint16_t number; // Number of times this report was sent
} __attribute__ ((packed)) StatsReport;

typedef struct {
  uint16_t id;
  uint8_t retries;
  uint8_t cacheHits;
} __attribute__ ((packed)) StatsWTNB;

typedef struct {
  uint8_t nbCount;
  StatsWTNB *nb;
} __attribute__ ((packed)) StatsWTL;

typedef struct {
  uint8_t numLevels;
  StatsWTL *level;
} __attribute__ ((packed)) StatsWT;

typedef struct {
  uint16_t rcvd; // Packets received (2)
  float rssi; // Sum of RSSI over mote lifetime (4)
  uint16_t sent; // Packets sent (2)
  uint16_t acked; // Packets sent and were ACKed (2) 
  StatsWT wavelet; // Wavelet stats per level per neighbor
} __attribute__ ((packed)) MoteStats;

#endif // _STATS_H
