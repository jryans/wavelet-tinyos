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
    interface MacControl;
#endif
    interface StdControl as TransControl;
    interface StdControl as DelugeControl;
  	interface Stats;
    interface Message;
    interface Timer as Wake;
    interface Timer as Sleep;
    interface Timer as Deluge;
    interface PowerManagement as PM;
    interface Leds;
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
  typedef char PwrControl;
#endif

  PwrControl pCntl;
  bool sleeping;
  bool startup;
  bool stayAwake;

  /*** Message ***/
    
  event void Message.receive(msgData msg) {
    switch (msg.type) {
    case MOTEOPTIONS: {
      MoteOptData *o = &msg.data.opt;
      dbg(DBG_USR2, "MoteOptions: Rcvd new options data\n");
      if ((o->mask & MO_DIAGMODE) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting diagnostics mode to %i\n", o->diagMode);
        signal MoteOptions.receive(MO_DIAGMODE, o->diagMode);
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
      if ((o->mask & MO_RADIORETRIES) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting radio retries to %i\n", o->radioRetries);
        signal MoteOptions.receive(MO_RADIORETRIES, o->radioRetries);
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
#endif
      if ((o->mask & MO_RADIOOFFTIME) != 0) {
        dbg(DBG_USR2, "MoteOptions: Turning radio off for %i seconds\n", o->radioOffTime);
        call Wake.start(TIMER_ONE_SHOT, o->radioOffTime * 1024);
        signal Sleep.fired();
      }
      break; }
    case PWRCONTROL: {
      if (TOS_LOCAL_ADDRESS == 0 && msg.src != NET_UART_ADDR) {
        msg.dest = msg.src;
        msg.src = 0;
        msg.data.pCntl = pCntl;
        call Message.send(msg);
      } else {
        pCntl = msg.data.pCntl;
      }
      break; }
    }
  }
 
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
    return SUCCESS;
  }
  
  /*** MoteOptions ***/
  
  /**
   * Signaled when an option affecting other applications is received.
   */
  default event void MoteOptions.receive(uint8_t optMask, uint8_t optValue) {}
  
  /**
   * Reset sleep countdown.
   */
  command void MoteOptions.resetSleep() {
    if (pCntl.pmMode == PM_SLEEP_ON_SILENCE) {
      dbg(DBG_USR1, "MoteOptions: Resetting sleep timer, will sleep in %i ms\n", pCntl.sleepInterval);
      call Sleep.stop();
      call Sleep.start(TIMER_ONE_SHOT, pCntl.sleepInterval);
    }
  }
  
  /*** Timer ***/
  
  void checkSink() {
    msgData msg;
    msg.src = TOS_LOCAL_ADDRESS;
    msg.dest = 0;
    msg.type = PWRCONTROL;
    call Message.send(msg);
    dbg(DBG_USR1, "MoteOptions: Waiting %i ms to hear from sink\n", pCntl.sleepInterval);
    call Sleep.start(TIMER_ONE_SHOT, pCntl.sleepInterval);
  }
  
  event result_t Wake.fired() {
    dbg(DBG_USR1, "MoteOptions: Reached next wake up interval");
    call Wake.start(TIMER_ONE_SHOT, pCntl.wakeUpInterval);
    if (sleeping) { 
      call TransControl.start();
    }
    call Deluge.start(TIMER_ONE_SHOT, 10);    
    return SUCCESS;
  }
  
  void goToSleep() {
    dbg(DBG_USR1, "MoteOptions: Going to sleep until next wake up interval");
    sleeping = TRUE;
    call Leds.redOff();
    call DelugeControl.stop();
    call TransControl.stop();
  }
  
  event result_t Sleep.fired() {
    switch (pCntl.pmMode) {
    case PM_CHECK_SINK: {
      call Wake.stop();
      call Wake.start(TIMER_ONE_SHOT, pCntl.wakeUpInterval - pCntl.sleepInterval);
      if (pCntl.stayAwake)
        return SUCCESS; }
    case PM_SLEEP_ON_SILENCE: {
      goToSleep();
      break; }
    }
    return SUCCESS;
  }
  
  event result_t Deluge.fired() {
    if (startup && TOS_LOCAL_ADDRESS != 0) {
      startup = FALSE;
      call PM.enable();
    }
    if (sleeping) {
      sleeping = FALSE;
      call DelugeControl.start();
      call Leds.redOn();
      if (TOS_LOCAL_ADDRESS != 0 && pCntl.pmMode == PM_SLEEP_ON_SILENCE) 
        call MoteOptions.resetSleep();
    }
    if (TOS_LOCAL_ADDRESS != 0 && pCntl.pmMode == PM_CHECK_SINK)
      checkSink();    
    return SUCCESS;
  }
  
  /*** StdControl ***/
  
  command result_t StdControl.init() {
    pCntl.sleepInterval = MO_DEF_SLEEP;
    pCntl.wakeUpInterval = MO_DEF_WAKE;
    pCntl.stayAwake = FALSE;
    pCntl.pmMode = PM_CHECK_SINK;
    sleeping = TRUE;
    startup = TRUE;
    call Leds.init();
    call TransControl.init();
    call DelugeControl.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
#ifdef PLATFORM_MICAZ
    call MacControl.enableAck();
#endif
    if (TOS_LOCAL_ADDRESS != 0) {
      signal Wake.fired();
    } else {
      call TransControl.start();
      call Deluge.start(TIMER_ONE_SHOT, 10);
    }
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call DelugeControl.stop();
    call TransControl.stop();
    return SUCCESS;
  }
  
}
