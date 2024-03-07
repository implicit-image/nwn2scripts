##
# Project Title
#
# @file
# @version 0.1

NWNSC      = /usr/bin/wine ../../bin/nwnsc.exe
NWNSCFLAGS = -g
INCFLAGS   = -i "../../../override/zMerger/;../../../override/uReeron/;../../Scripts/;../../Scripts_X1/;../../Scripts_X2/;"
DESTDIR    = ../../../override/zzMyScripts/

# copy:

all: compile 2da ncs

2da: $(wildcard *.2da)
	for file in $?; do cp $$file $(DESTDIR); done

ncs: $(wildcard *.ncs)
	for file in $?; do mv $$file $(DESTDIR); done

compile: $(wildcard *.nss)
	for file in $?; do $(NWNSC) $(NWNSCFLAGS) $(INCFLAGS) $$file; done

# end
