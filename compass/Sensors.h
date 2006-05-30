/*
 * A static sensor list is used to assign array slot of each sensor.
 */

#ifndef _SENSORS_H
#define _SENSORS_H

// Gives array indices for each sensor type
enum {
	TEMP = 0,
	LIGHT = 1,
	VOLT = 2  // WT not currently done on voltage values
};

// Total number of sensors
enum {
  NUM_SENSORS = 3,
  WT_SENSORS = 2
};

// Time between sensor samples in ms
enum {
	SAMPLE_TIME = 500
};

#endif // _SENSORS_H