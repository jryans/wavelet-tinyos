# Top-level Makefile for tools/java

TOS = $(shell ncc -print-tosdir)
PACKAGE = edu.rice.compass.comm
APP = $(TOS)/../apps/compass
MIG = mig java

# List of message classes to build
MSGS = UnicastPack.java BroadcastPack.java

INITIAL_TARGETS = $(MSGS)
OTHER_CLEAN = cleanmig

ROOT = ../../../..
include $(ROOT)/Makefile.include

UnicastPack.java:
	$(MIG) -java-classname=$(PACKAGE).UnicastPack $(APP)/IOPack.h UnicastPack -o $@
	$(JAVAC) $@

BroadcastPack.java:
	$(MIG) -java-classname=$(PACKAGE).BroadcastPack $(APP)/IOPack.h BroadcastPack -o $@
	$(JAVAC) $@

cleanmig:
	rm -f $(MSGS)