/**
 * Requests wavelet config data from BigPackM on startup.
 * @author Ryan Stinnett
 */
 
includes WaveletData;

module ConfigTestM {
  uses interface BigPack;
  uses interface Timer;
  provides interface StdControl;
}
implementation {
 
  command result_t StdControl.init() {
    return SUCCESS;
  }

  command result_t StdControl.start() {
    if (TOS_LOCAL_ADDRESS != 0)
      call Timer.start(TIMER_ONE_SHOT, 1000);
    return SUCCESS;
  }
  
  event result_t Timer.fired() {
    call BigPack.request(BP_WAVELETCONF);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }
  
  /**
   * Once the request is complete, the requester is given a pointer to the main
   * data block.
   */
  event void BigPack.requestDone(int8_t *mainBlock, result_t result) {
    uint8_t i, l;
    WaveletConf *bob = (WaveletConf *) mainBlock;
    ExtWaveletLevel **lvl = bob->level;
    dbg(DBG_USR2, "BigPack: Wavelet Config Test\n");
    for (l = 0; l < bob->numLevels; l++) {
      dbg(DBG_USR2, "BigPack: Level #%i\n", l + 1);
      for (i = 0; i < lvl[l]->nbCount; i++) {
        dbg(DBG_USR2, "BigPack:   Neighbor #%i\n", i + 1);
        dbg(DBG_USR2, "BigPack:     ID:    %i\n", lvl[l]->nb[i].id);
        dbg(DBG_USR2, "BigPack:     State: %i\n", lvl[l]->nb[i].state);
        dbg(DBG_USR2, "BigPack:     Coeff: %f\n", lvl[l]->nb[i].coeff);
      }
    }
    call BigPack.free(mainBlock);
  }
}
