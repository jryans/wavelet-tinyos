COMPONENT = TestC

# Used by Wavelet and Network
CFLAGS += -I%T/lib/Transceiver 
CFLAGS += -I%T/lib/State

# Used by SortedArray
#CFLAGS += -I../Blackbook5/media/AT45DB

# Sets the max number of neighbors
CFLAGS += -DMAX_WT_NBS=6

# For now, use twice the max number of neighbors
CFLAGS += -DMAX_TOS_MSGS=20

# Attempts for each unicast transmission
CFLAGS += -DRADIO_RETRIES=5

# Adds (annoying) beeps to indicate various errors
# CFLAGS += -DBEEP

# Transmits raw values back to base for comparison
CFLAGS += -DRAW

include $(TOSROOT)/apps/Makerules
