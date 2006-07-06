/**
 * Translates commands from the Beep interface into start and stop
 * commands to the Sounder.
 * @author Ryan Stinnett
 */
 
configuration BeepC {
  provides interface Beep;
}

implementation {
  components BeepM, Main, Sounder, TimerC;
  
  Beep = BeepM;  
  Main.StdControl -> BeepM;
  BeepM.Sounder -> Sounder;
  BeepM.Timer -> TimerC.Timer[unique("Timer")];
}
