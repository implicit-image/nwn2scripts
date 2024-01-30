##
# Project Title
#
# @file
# @version 0.1

all: setup respec

setup: setup.nss setup_feats.2da
	./nwnsc.sh setup.nss

respec: respec.nss
	./nwnsc.sh respec.nss


# end
