##
# Project Title
#
# @file
# @version 0.1

all: setup respec

setup: mysetup.nss setup_feats.2da
	./nwnsc.sh mysetup.nss

respec: respec.nss
	./nwnsc.sh respec.nss

# end
