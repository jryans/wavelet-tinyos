/**
 * Computes various statistics on a data stream without
 * storing the data itself.
 * @author Ryan Stinnett
 * 
 * Median algorithm based on:
 * R. Jain and I. Chlamtac. The P^2 algorithm for dynamic
 * calculation of quantile and histograms without storing
 * observations. <i>Communications of the ACM</i>,
 * 28(10):1076-1085, October 1986.
 */

module StatsArrayM {
  provides {
    interface StatsArray[uint8_t id];
    interface StdControl;
  }
  uses {
    interface JDebug;
    interface SoftFloat;
  }
}

implementation {
 
  enum {
    numMarkers = 5
  };
  
  /*float64 half = call SoftFloat.float64_div(
                   call SoftFloat.int32_to_float64(1),
                   call SoftFloat.int32_to_float64(2));
  float64 p = half; */
  float64 one = call SoftFloat.int32_to_float64(1);
  float64 negone = call SoftFloat.int32_to_float64(-1);
  float64 dnDes[numMarkers];
  
  typedef struct { 
    float64 q[numMarkers];
    float64 n[numMarkers];
    float64 nDes[numMarkers];
    uint16_t numSeen;
    float64 dataSum;
  } saInfo;
  
  uint8_t numArrays = uniqueCount("StatsArray");
  saInfo sa[uniqueCount("StatsArray")];
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    int32_t a, i;
    dnDes[0] = call SoftFloat.int32_to_float64(0);
    dnDes[1] = call SoftFloat.float32_to_float64((float)0.25);
    dnDes[2] = call SoftFloat.float32_to_float64((float)0.5);
    dnDes[3] = call SoftFloat.float32_to_float64((float)0.75);
    dnDes[4] = call SoftFloat.int32_to_float64(1);
    for (a = 0; a < numArrays; a++) {
      for (i = 0; i < numMarkers; i++)
        sa[a].n[i] = call SoftFloat.int32_to_float64(i + 1);
      sa[a].nDes[0] = call SoftFloat.int32_to_float64(1);
      sa[a].nDes[1] = call SoftFloat.int32_to_float64(2);
      sa[a].nDes[2] = call SoftFloat.int32_to_float64(3);
      sa[a].nDes[3] = call SoftFloat.int32_to_float64(4);
      sa[a].nDes[4] = call SoftFloat.int32_to_float64(5);
      sa[a].dataSum = call SoftFloat.int32_to_float64(0);
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
  
  void printq() {
   /* call JDebug.jdbg("N0: %i", 0, sa[1].n[0], 0);
    call JDebug.jdbg("N1: %i", 0, sa[1].n[1], 0);
    call JDebug.jdbg("N2: %i", 0, sa[1].n[2], 0);
    call JDebug.jdbg("N3: %i", 0, sa[1].n[3], 0);
    call JDebug.jdbg("N4: %i", 0, sa[1].n[4], 0);
    call JDebug.jdbg("q0: %i", 0, (uint16_t) sa[1].q[0], 0);
    call JDebug.jdbg("q1: %i", 0, (uint16_t) sa[1].q[1], 0);
    call JDebug.jdbg("q2: %i", 0, (uint16_t) sa[1].q[2], 0);
    call JDebug.jdbg("q3: %i", 0, (uint16_t) sa[1].q[3], 0);
    call JDebug.jdbg("q4: %i", 0, (uint16_t) sa[1].q[4], 0); */
  }

  float64 parabolaAdj(uint8_t id, float64 d, uint8_t i) {
    saInfo *s = &sa[id];
    // Break up formula for readability
    float64 niminus = call SoftFloat.float64_sub(s->n[i], s->n[i - 1]);
    float64 niplus = call SoftFloat.float64_sub(s->n[i + 1], s->n[i]);
    float64 a = call SoftFloat.float64_div(d, call SoftFloat.float64_add(niplus, niminus));
    float64 c = call SoftFloat.float64_div(call SoftFloat.float64_sub(s->q[i + 1], s->q[i]), niplus);
    float64 f = call SoftFloat.float64_div(call SoftFloat.float64_sub(s->q[i], s->q[i - 1]), niminus);
    return call SoftFloat.float64_add(s->q[i], 
             call SoftFloat.float64_mul(a, 
               call SoftFloat.float64_add(
                 call SoftFloat.float64_mul(call SoftFloat.float64_add(niminus, d), c),
                 call SoftFloat.float64_mul(call SoftFloat.float64_sub(niplus, d), f))));
  }

  float64 linearAdj(uint8_t id, float64 d, uint8_t i) {
    saInfo *s = &sa[id];
    float64 a = call SoftFloat.float64_div(
                  call SoftFloat.float64_sub(s->q[i + d], s->q[i]), 
                  call SoftFloat.float64_sub(s->n[i + d], s->n[i]));
    return call SoftFloat.float64_add(s->q[i], call SoftFloat.float64_mul(d, a));
  }

  void sort(uint8_t id) {
    saInfo *s = &sa[id];
    uint8_t mi, i, j;
    float64 m;
    for (i = 0; i < numMarkers - 1; i++) {
      /* find the minimum */
      mi = i;
      for (j = i + 1; j < numMarkers; j++) {
        if (call SoftFloat.float64_lt(s->q[j], s->q[mi])) {
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

  command void StatsArray.newData[uint8_t id](float64 newVal) {
    saInfo *s = &sa[id];
    if (s->numSeen < numMarkers) {
      // Store first five elements as marker heights and sort them
      s->q[s->numSeen] = newVal;
      if (s->numSeen == numMarkers - 1)
        sort(id);
    } else {
      // Find markers that the new value fits between
      uint8_t k, i;
      if (call SoftFloat.float64_lt(newVal, s->q[0])) {
        s->q[0] = newVal;
        k = 1;
      } else if (call SoftFloat.float64_le(s->q[0], newVal) && 
                 call SoftFloat.float64_lt(newVal, s->q[1])) {
        k = 1;
      } else if (call SoftFloat.float64_le(s->q[1], newVal) && 
                 call SoftFloat.float64_lt(newVal, s->q[2])) {
        k = 2;
      } else if (call SoftFloat.float64_le(s->q[2], newVal) && 
                 call SoftFloat.float64_lt(newVal, s->q[3])) {
        k = 3;
      } else if (call SoftFloat.float64_le(s->q[3], newVal) && 
                 call SoftFloat.float64_le(newVal, s->q[4])) {
        k = 4;
      } else if (call SoftFloat.float64_lt(s->q[4], newVal)) {
        s->q[4] = newVal;
        k = 4;
      }
      // Increment markers from k + 1 to 5
      for (i = k; i < 5; i++)
        s->n[i] = call SoftFloat.float64_add(s->n[i], call SoftFloat.int32_to_float64(1));
      // Update desired positions for all markers
      for (i = 0; i < 5; i++)
        s->nDes[i] = call SoftFloat.float64_add(s->nDes[i], dnDes[i]);
      // Adjust heights of markers 2 - 4 if needed
      for (i = 1; i < 4; i++) {
        float64 d = call SoftFloat.float64_sub(s->nDes[i], s->n[i]);
        if ((d >= 1 && call SoftFloat.float64_sub(s->n[i + 1], s->n[i] > 1)
            || (d <= -1 && s->n[i - 1] - s->n[i] < -1)) {
          int8_t di;
          float qDes;
          (d > 0) ? (di = 1) : (di = -1); // Equiv: di <- sign(d)
          // Try using parabolic formula
          qDes = parabolaAdj(id, di, i);
          // If new value moves marker past another, use linear.
          if (s->q[i - 1] < qDes && qDes < s->q[i + 1]) {
            s->q[i] = qDes;
          } else {
            s->q[i] = linearAdj(id, di, i);
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
  
  command float StatsArray.min[uint8_t id]() {
    return sa[id].q[0];
  }
  
  command float StatsArray.max[uint8_t id]() {
    return sa[id].q[numMarkers - 1];
  }
  
  command float StatsArray.mean[uint8_t id]() {
    printq();
    return sa[id].dataSum / sa[id].numSeen;
  }
  
  command float StatsArray.median[uint8_t id]() {
    printq();
    return sa[id].q[numMarkers / 2];  
  }

}
