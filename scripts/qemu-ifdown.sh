#!/bin/sh

switch=br0

if [ -z $1 ]; then
	echo "Warning: no device given as a parameter!"
	exit 1
fi

sudo `which brctl` delif $switch $1
sudo `which ip` link set $1 down
sudo `which tunctl` -d $1
