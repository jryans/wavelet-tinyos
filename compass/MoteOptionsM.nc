/**
 * Sets options sent in a MoteOptions message.
 * @author Ryan Stinnett
 */

includes MessageData;
includes MoteOptions;

module MoteOptionsM {
  uses {
#ifdef PLATFORM_MICAZ
  	interface CC2420Control;
    interface StdControl as TransControl;
    interface MacControl;
#endif
  	interface Stats;
    interface Message;
    interface Timer as RadioDelay;
    interface PowerManagement as PM;
  }
  provides {
    interface MoteOptions;
    interface StdControl;
  }
}
implementation {
#if 0 // TinyOS Plugin Workaround
  typedef char msgData;
  typedef char MoteOptData;
#endif

  /*** Message ***/
    
  event void Message.receive(msgData msg) {
    if (msg.type == MOTEOPTIONS) {
      MoteOptData *o = &msg.data.opt;
      dbg(DBG_USR2, "MoteOptions: Rcvd new options data\n");
      if ((o->mask & MO_DIAGMODE) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting diagnostics mode to %i\n", o->diagMode);
        signal MoteOptions.diag(o->diagMode);
      }
      if ((o->mask & MO_CLEARSTATS) != 0) {
        dbg(DBG_USR2, "MoteOptions: Clearing stats data\n");
        call Stats.clear();
      }
      if ((o->mask & MO_HPLPM) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting power management to %i\n", o->hplPM);
        (o->hplPM) ? call PM.enable()
                   : call PM.disable();
      }
#ifdef PLATFORM_MICAZ
      if ((o->mask & MO_TXPOWER) != 0) {
        if (o->txPower > 0 && o->txPower < 32) {
          dbg(DBG_USR2, "MoteOptions: Setting TX power level to %i\n", o->txPower);
          call CC2420Control.SetRFPower(o->txPower);
        }
      }
      if ((o->mask & MO_RFCHAN) != 0) {
        if (o->rfChan > 10 && o->rfChan < 27) {
          dbg(DBG_USR2, "MoteOptions: Setting RF channel to %i\n", o->rfChan);
          call CC2420Control.TunePreset(o->rfChan);
        }
      }
      if ((o->mask & MO_RFACK) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting RF ACK support to %i\n", o->rfAck);
        (o->rfAck) ? call MacControl.enableAck()
                   : call MacControl.disableAck();
      }
      if ((o->mask & MO_RADIOOFFTIME) != 0) {
        dbg(DBG_USR2, "MoteOptions: Turning radio off for %i seconds\n", o->radioOffTime);
        call RadioDelay.start(TIMER_ONE_SHOT, o->radioOffTime * 1024);
        call TransControl.stop();
      }
#endif
    }
  }
 
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    return SUCCESS;
  }
  
  /*** MoteOptions ***/
  
  default event void MoteOptions.diag(bool state) {}
  
  /*** Timer ***/
  
  event result_t RadioDelay.fired() {
#ifdef PLATFORM_MICAZ
    call TransControl.start();
#endif
    return SUCCESS;
  }
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
#ifdef PLATFORM_MICAZ
    call TransControl.init();
#endif
    return SUCCESS;
  }

  command result_t StdControl.start() {
    // Set options to default values
#ifdef PLATFORM_MICAZ
    call TransControl.start();
    call MacControl.enableAck();
#endif
    return SUCCESS;
  }

  command result_t StdControl.stop() {
#ifdef PLATFORM_MICAZ
    call TransControl.stop();
#endif
    return SUCCESS;
  }
  
}
