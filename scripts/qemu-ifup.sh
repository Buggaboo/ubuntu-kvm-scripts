#!/bin/sh

# Warning: I forgot what the 2nd parameter of this script does..., but it works

#set -e -x

switch=br0

if [ -z "$1" ]; then
       echo "Error: no interface specified"
       exit 1
fi

sudo $(which tunctl) -u $(whoami) -t $1
sudo $(which ip) link set $1 up
$(`test -z $2 || echo -n "sudo ip addr add $2 dev $1"`)
sleep 0.5s
sudo $(which brctl) addif $switch $1

exit 0
