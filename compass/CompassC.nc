/**
 * Top level configuration that links applications to various
 * hardware systems.
 * @author Ryan Stinnett
 */

configuration CompassC {}
implementation {
  components Main, DelugeC, NetworkC, MoteCommandC;

  /*** Deluge: allows for wireless mote reprogramming ***/
  Main.StdControl -> DelugeC;
  
  /*** Network: provides broadcast and unicast I/O ***/
  MoteCommandC.Message -> NetworkC;
  // Apps and subsystems
}
