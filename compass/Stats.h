 /**
 * Stats message that sends various details about the mote's
 * network packets on request.
 * @author Ryan Stinnett
 */

#ifndef _STATS_H
#define _STATS_H

// Report Types

enum {
  WT_CACHE = 0
};

// Report Structs

typedef struct {
  uint8_t level; // Level when cached data was used
  uint16_t index; // Index of mote whose data was pulled from cache
} __attribute__ ((packed)) CacheReport;

typedef struct {
  uint8_t type; // Type of report
  union {
    CacheReport cache;
  } data;
} __attribute__ ((packed)) StatsReport;

// Stats Storage

typedef struct swtnb {
  uint16_t id;
  uint8_t retries;
  uint8_t cacheHits;
} __attribute__ ((packed)) StatsWTNB;

typedef struct swtl {
  uint8_t nbCount;
  StatsWTNB *nb;
} __attribute__ ((packed)) StatsWTL;

typedef struct swt {
  uint8_t numLevels;
  StatsWTL *level;
} __attribute__ ((packed)) StatsWT;

typedef struct ms {
  uint16_t pRcvd; // Packets received (2)
  int8_t rssiMin; // Min RSSI over all packets (1)
  int8_t rssiMax; // Max RSSI over all packets (1)
  float rssiSum; // Sum of RSSI over all packets (4)
  uint8_t lqiMin; // Min LQI over all packets (1)
  uint8_t lqiMax; // Max LQI over all packets (1)
  float lqiSum; // Sum of LQI over all packets (4)
  uint16_t pSent; // Packets sent (2)
  uint16_t pAcked; // Packets sent and were ACKed (2) 
  uint16_t mRcvd; // Messages received (2)
  uint16_t mSent; // Messages sent (2)
  uint16_t mRetriesSum; // Sum of retries over all messages (2)
  float voltage; // Current voltage in mV (4)
  StatsWT wavelet; // Wavelet stats per level per neighbor
} __attribute__ ((packed)) MoteStats;

#endif // _STATS_H
