#!/usr/bin/env sh

set -xe
INCLUDE_PATH="../../dev/Scripts"

WINEDEBUG=-all
WINEPREFIX=~/wine-prefixes/games/Neverwinter-Nights-2-Complete
wine nwnsc.exe -g -i $INCLUDE_PATH $1
