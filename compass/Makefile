COMPONENT = CompassC

CFLAGS += -I%T/lib/Transceiver 
CFLAGS += -I%T/lib/State

# For now, use twice the max number of neighbors
CFLAGS += -DMAX_TOS_MSGS=15

# Adds (annoying) beeps to indicate various errors
CFLAGS += -DBEEP

# Transmits raw values back to base for comparison
CFLAGS += -DRAW

# Enables CC2420 features, like ACKs
CFLAGS += -DCC2420

include $(TOSROOT)/apps/Makerules
