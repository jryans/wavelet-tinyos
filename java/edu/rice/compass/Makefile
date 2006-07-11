# Top-level Makefile for tools/java

PACKAGE = edu.rice.compass
SUBDIRS = bigpack
INITIAL_TARGETS = msgs
OTHER_CLEAN = msgs-clean


ROOT = ../../..
include $(ROOT)/Makefile.include

msgs:
	(cd comm; $(MAKE))
msgs-clean:
	(cd comm; $(MAKE) clean)
