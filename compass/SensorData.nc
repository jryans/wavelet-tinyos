/**
 * Allows applications to request and receive data from the sensor system.
 * @author Ryan Stinnett
 */

includes RawData;

interface SensorData {
	/**
	 * Requests new data from the sensor system
	 * @return Struct containing the requested values
	 */
	command RawData readSensors();
}
