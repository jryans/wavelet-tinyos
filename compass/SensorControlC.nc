// Portions of this code created by The Moters (Fall 2005 - Spring 2006)

/**
 * This application takes data readings from various sensors when requested
 * and sends back the values when they arrive.
 * @author The Moters
 * @author Ryan Stinnett
 */

configuration SensorControlC {
  provides interface SensorData;
}

implementation {
  components SensorControlM, PhotoTemp, Voltage, Main;

  SensorData = SensorControlM;
  Main.StdControl -> SensorControlM;
  SensorControlM.LightADC -> PhotoTemp.ExternalPhotoADC;
  SensorControlM.TempADC -> PhotoTemp.ExternalTempADC;
  SensorControlM.VoltADC -> Voltage.ADC;
  SensorControlM.LightControl -> PhotoTemp.PhotoStdControl;
  SensorControlM.TempControl -> PhotoTemp.TempStdControl; 
  SensorControlM.VoltControl -> Voltage.StdControl;
}
