#!/bin/sh

if [ -z $1 ] ;then
  echo "Error: No image set to boot!"
  exit 1
fi

MODEL=$3
if [ -z $3 ]; then
  echo "Error: No nic model set!"
  echo "Error: Default will be 'e1000'."
  MODEL=e1000
fi

if [ -z $2 ]; then
  echo "Error: No tap device chosen to connect to virtual guest!"
  exit 1
fi

if [ -z $4 ]; then
  echo "Warning: No extra parameters given to qemu."
fi

N=$(echo -n $2 | sed 's/.*\([0-9]\+\)$/\1/')
MACADDR="DE:AD:BE:EF:$N$N:$N$N"

echo "mac address: $MACADDR"

kvm -hda $1 -m 1024 smp 2 $4 \
  -net nic,macaddr=$MACADDR,model=$MODEL \
  -net tap,ifname=$2,script=no 
