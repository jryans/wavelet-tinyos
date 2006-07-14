COMPONENT = TestC

# Used by Wavelet and Network
CFLAGS += -I%T/lib/Transceiver 
CFLAGS += -I%T/lib/State

# For now, use twice the max number of neighbors
CFLAGS += -DMAX_TOS_MSGS=20

# Adds (annoying) beeps to indicate various errors
# CFLAGS += -DBEEP

# Transmits raw values back to base for comparison
CFLAGS += -DRAW

include $(TOSROOT)/apps/Makerules
