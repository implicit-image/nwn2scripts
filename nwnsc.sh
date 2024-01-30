#!/usr/bin/env sh

set -xe
INCLUDE_PATH="$HOME/wine-prefixes/games/Neverwinter-Nights-2-Complete/drive_c/users/b/Documents/Neverwinter Nights 2/dev/Scripts/"
COMPILER_PATH="$HOME/wine-prefixes/games/Neverwinter-Nights-2-Complete/drive_c/users/b/Documents/Neverwinter Nights 2/override/scripts"
WINEDEBUG=-all
WINEPREFIX=~/wine-prefixes/games/Neverwinter-Nights-2-Complete
wine "$COMPILER_PATH/nwnsc.exe" -g -i "$INCLUDE_PATH" "$1"
