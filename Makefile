##
# Project Title
#
# @file
# @version 0.1
BIN        =
NWNSC      = /usr/bin/wine ../../bin/nwnsc.exe
NWNSCFLAGS = -g
NWN2DIR    = wine-prefixes/games/Neverwinter-Nights-2-Complete/drive_c/users/b/Documents/Neverwinter Nights 2
OVERRIDE   = $(HOME)/$(NWN2DIR)/override
INCLUDEDIR = $(HOME)/$(NWN2DIR)/dev/src/include
INCFLAGS   = -i "$(OVERRIDE)/zMerger/;$(OVERRIDE)/uReeron/;$(INCLUDEDIR)/Scripts/;$(INCLUDEDIR)/Scripts_X1/;$(INCLUDEDIR)/Scripts_X2/;"
DESTDIR    = ../../../override/zzMyScripts/

# copy:

all: compile 2da ncs

2da: $(wildcard *.2da)
	for file in $?; do cp $$file $(DESTDIR); done

ncs: $(wildcard *.ncs)
	for file in $?; do mv $$file $(DESTDIR); done

compile: $(wildcard *.nss)
	for file in $?; do $(NWNSC) $(NWNSCFLAGS) $(INCFLAGS) $$file; done

clean:
	rm *.ncs

# end
