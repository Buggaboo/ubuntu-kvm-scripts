#!/bin/sh

#set -e -x

# 1st parameter: $1 -> image.qcow2
# 2nd parameter: $2 -> tap0..n
# 3rd parameter: $3 -> virtual ethernet device
# 4th parameter: $4 -> additional parameters, enter like this "-usb -usbdevice 1234:5678"

# pass to 4th parameter
# tip: -nographics
# tip: -usb -usbdevice PQRS:TUVW where P..W are 1..9

if [ -z "$1" ] ;then
  echo "Error: No vm image set to boot!"
  exit 1
fi

MODEL=$3
if [ -z "$3" ]; then
  echo "Warning: No nic model set!"
  echo "Warning: Default will be 'virtio'."
  echo "Warning: Ascertain whether virtio-blk is loaded"
  MODEL=virtio
fi

if [ -z "$2" ]; then
  echo "Error: No tap device chosen to connect to virtual guest!"
  exit 1
fi

if [ -z "$4" ]; then
  echo "Warning: No extra parameters given to qemu."
fi

MACADDR=$(`which python` -c "from random import choice; print 'DE:AD:BE:EF:' + \"%s%s:%s%s\" % tuple([choice('ABCDEF0123456789') for i in xrange(4)])")

echo "mac address: $MACADDR"

KVM=$(which kvm)
if [ -z "$KVM" ]; then
  echo "Error: no qemu available."
  exit 1
fi

sudo $KVM -drive file=$1,if=virtio,boot=on -m 1024 -smp 2 $4 \
  -net nic,macaddr=$MACADDR,model=$MODEL \
  -net tap,ifname=$2,script=no \
  -usb -usbdevice tablet \
  -name "`basename $1` $2" \
  -no-quit \
  -monitor stdio
  

