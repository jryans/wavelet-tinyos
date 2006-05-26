// This begins the section modified by The Moters (Fall 2005 - Spring 2006)
/* SensorMsg is the message type for SensorToRfm/RfmToSensor. */

typedef struct
{
  uint16_t val[5];          // all of the data is stored in this 5-element array
  uint16_t next_addr;       // the hex address of the next mote for this message to be sent to
                            // (it will either be the same as dest_addr or a hop on the way to the destination)  
  uint16_t dest_addr;       // the hex address of the mote that is this message's final destination
  uint16_t src;             // the hex address of the mote that originated this message (source)  
  uint16_t hops;            // the number of hops that have occurred for the msg to get from the source mote to this mote
  uint16_t msg_type;        // denotes whether this is a wavelet message or just a sensor message
} SensorMsg;

enum 
{
  AM_SENSORMSG = 4
};

enum 
{
  WAVELET_MSG = 0x0003,
  SENSOR_MSG = 0x0004
};
