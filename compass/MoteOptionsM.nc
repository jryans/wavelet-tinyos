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
#ifdef PLATFORM_MICAZ        
      if ((o->mask & MO_RFPOWER) != 0) {
        if (o->rfPower > 0 && o->rfPower < 32) {
          dbg(DBG_USR2, "MoteOptions: Setting RF power to %i\n", o->rfPower);
          call CC2420Control.SetRFPower(o->rfPower);
        }
      }
#endif
      if ((o->mask & MO_CLEARSTATS) != 0) {
        dbg(DBG_USR2, "MoteOptions: Clearing stats data\n");
        call Stats.clear();
      }
#ifdef PLATFORM_MICAZ
      if ((o->mask & MO_RFACK) != 0) {
        dbg(DBG_USR2, "MoteOptions: Setting RF ACK support to %i\n", o->rfAck);
        (o->rfAck) ? call MacControl.enableAck()
                   : call MacControl.disableAck();
      }
#endif
    }
  }
 
  event result_t Message.sendDone(msgData msg, result_t result, uint8_t retries) {
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