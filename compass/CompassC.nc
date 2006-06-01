/**
 * Top level configuration that links applications to various
 * hardware systems.
 * @author Ryan Stinnett
 */

configuration CompassC {}
implementation {
  components LedControlC, Main, UARTControlC, DelugeC;

  Main.StdControl -> DelugeC;
  LedControlC.LedData -> UARTControlC.In;
}
