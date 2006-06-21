/**
 * Allows applications to request and receive data from the sensor system.
 * @author Ryan Stinnett
 */

includes Sensors;

interface SensorData {
	/**
	 * Requests new data from the sensor system.
	 */
	command void readSensors();
	
	/**
	 * When the sensors are done, this event returns the requested data
	 * to applications.
	 * @param data Struct containing the requested values
	 */
	event void readDone(float data[NUM_SENSORS]);
}
