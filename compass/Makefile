COMPONENT = CompassC

CFLAGS += -I%T/lib/Transceiver 
CFLAGS += -I%T/lib/State

# Sets the max number of neighbors
CFLAGS += -DMAX_WT_NBS=6

# For now, use twice the max number of neighbors
CFLAGS += -DMAX_TOS_MSGS=12

# Adds (annoying) beeps to indicate various errors
CFLAGS += -DBEEP

# Transmits raw values back to base for comparison
CFLAGS += -DRAW

include $(TOSROOT)/apps/Makerules
