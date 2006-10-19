COMPONENT = CompassC

# Used by Wavelet and Network
CFLAGS += -I%T/lib/Transceiver 
CFLAGS += -I%T/lib/State

# For now, use twice the max number of neighbors
CFLAGS += -DMAX_TOS_MSGS=20

# Adds (annoying) beeps to indicate various errors
# CFLAGS += -DBEEP

# Enables storage of raw data values
# Transmission still needs to be enabled at runtime
CFLAGS += -DRAW

# Selects either static or sim routing
CFLAGS += -DROUTE_STATIC
# CFLAGS += -DROUTE_SIM

include $(TOSROOT)/apps/Makerules
