/**
 * Computes various statistics on a data stream without
 * storing the data itself.
 * @author Ryan Stinnett
 */

module StatsArrayM {
  provides {
    interface StatsArray[uint8_t id];
    interface StdControl;
  }
}

implementation {
 
  enum {
    numMarkers = 5
  };
  
  const float p = 0.5; 
  const float dnDes[numMarkers] = { 0, p / 2, p, (1 + p) / 2, 1 };
  
  typedef struct { 
  float q[numMarkers];
  int16_t n[numMarkers];
  float nDes[numMarkers];
  uint16_t numSeen;
  float dataSum;
  } saInfo;
  
  uint8_t numArrays = uniqueCount("StatsArray");
  saInfo sa[uniqueCount("StatsArray")];
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    uint8_t a, i;
    for (a = 0; a < numArrays; a++) {
      for (i = 0; i < numMarkers; i++)
        sa[a].n[i] = i + 1;
      sa[a].nDes[0] = 1;
      sa[a].nDes[1] = 1 + 2 * p;
      sa[a].nDes[2] = 1 + 4 * p;
      sa[a].nDes[3] = 3 + 2 * p;
      sa[a].nDes[4] = 5;
      sa[a].dataSum = 0;
      sa[a].numSeen = 0;
    }
    return SUCCESS;
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  /*** Internal Functions ***/

  float parabolaAdj(saInfo *s, int8_t d, uint8_t i) {
    // Break up formula for my own sanity
    uint16_t niminus = s->n[i] - s->n[i - 1];
    uint16_t niplus = s->n[i + 1] - s->n[i];
    float a = (float) d / (niplus + niminus);
    float c = (s->q[i + 1] - s->q[i]) / niplus;
    float f = (s->q[i] - s->q[i - 1]) / niminus;
    return s->q[i] + a * (((niminus + d) * c) + ((niplus - d) * f));
  }

  float linearAdj(saInfo *s, int8_t d, uint8_t i) {
    float a = (s->q[i + d] - s->q[i]) / (s->n[i + d] - s->n[i]);
    return s->q[i] + d * a;
  }

  void sort(saInfo *s) {
    uint8_t mi, i, j;
    float m;
    for (i = 0; i < numMarkers - 1; i++) {
      /* find the minimum */
      mi = i;
      for (j = i + 1; j < numMarkers; j++) {
        if (s->q[j] < s->q[mi]) {
          mi = j;
        }
      }
      m = s->q[mi];
      /* move elements to the right */
      for (j = mi; j > i; j--) {
        s->q[j] = s->q[j - 1];
      }
      s->q[i] = m;
    }
  }
  
  /*** StatsArray ***/  

  command void StatsArray.newData[uint8_t id](int16_t newVal) {
    saInfo *s = &sa[id];
    if (s->numSeen < numMarkers) {
      // Store first five elements as marker heights and sort them
      s->q[numSeen] = newVal;
      if (numSeen == numMarkers - 1)
        sort();
    } else {
      // Find markers that the new value fits between
      uint8_t k, i;
      if (newVal < s->q[0]) {
        s->q[0] = newVal;
        k = 1;
      } else if (s->q[0] <= newVal && newVal < s->q[1]) {
        k = 1;
      } else if (s->q[1] <= newVal && newVal < s->q[2]) {
        k = 2;
      } else if (s->q[2] <= newVal && newVal < s->q[3]) {
        k = 3;
      } else if (s->q[3] <= newVal && newVal <= s->q[4]) {
        k = 4;
      } else if (s->q[4] < newVal) {
        s->q[4] = newVal;
        k = 4;
      }
      // Increment markers from k + 1 to 5
      for (i = k; i < 5; i++)
        s->n[i]++;
      // Update desired positions for all markers
      for (i = 0; i < 5; i++)
        s->nDes[i] += dnDes[i];
      // Adjust heights of markers 2 - 4 if needed
      for (i = 1; i < 4; i++) {
        float d = s->nDes[i] - s->n[i];
        if ((d >= 1 && s->n[i + 1] - s->n[i] > 1)
            || (d <= -1 && s->n[i - 1] - s->n[i] < -1)) {
          int8_t di;
          float qDes;
          (d > 0) ? (di = 1) : (di = -1); // Equiv: di <- sign(d)
          // Try using parabolic formula
          qDes = parabolaAdj(s, di, i);
          // If new value moves marker past another, use linear.
          if (s->q[i - 1] < qDes && qDes < s->q[i + 1]) {
            s->q[i] = qDes;
          } else {
            s->q[i] = linearAdj(s, di, i);
          }
          // Adjust marker position
          s->n[i] += di;
        }
      }
    }
    // Add to sum and increment count
    s->dataSum += newVal;
    s->numSeen++; 
  }
  
  command int16_t StatsArray.min[uint8_t id]() {
    return sa[id].q[0];
  }
  
  command int16_t StatsArray.max[uint8_t id]() {
    return sa[id].q[numMarkers - 1];
  }
  
  command float StatsArray.mean[uint8_t id]() {
    return sa[id].dataSum / sa[id].numSeen;
  }
  
  command float StatsArray.median[uint8_t id]() {
    return sa[id].q[numMarkers / 2];  
  }

}