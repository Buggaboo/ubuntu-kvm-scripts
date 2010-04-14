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

VIRTIOCDROM=""
MODEL=$3
if [ -z "$3" ]; then
  echo "Warning: No nic model set!"
  echo "Warning: Default will be 'e1000'."
  MODEL=e1000
  if [ "$MODEL" != "virtio" ]; then
    if [ ! -f "./NetKVM-and-viostor.iso" ]; then
      $(which wget) -nc -nd -nH http://www.famzah.net/download/kvm/virtio-windows/24.09.2009/NetKVM-and-viostor.iso
      VIRTIOCDROM=-cdrom ./NetKVM-and-viostor.iso
    fi
  fi
fi

if [ -z "$2" ]; then
  echo "Error: No tap device chosen to connect to virtual guest!"
  exit 1
fi

if [ -z "$4" ]; then
  echo "Warning: No extra parameters given to qemu."
fi

#N=$(echo $2 | egrep -o "[a-f0-9]$")
#MACADDR="DE:AD:BE:EF:$N$N:$N$N"
#MACADDR=$(`which python` -c "\"from random import choice; print ':'.join([''.join([choice('abcdef1234567890'),choice('abcdef1234567890')]) for i in xrange(8) ])\"")
MACADDR=$(`which python` -c "\"from random import choice; print 'DE:AD:BE:EF:'+':'.join([ ''.join([choice('ABCDEF1234567890'),choice('ABCDEF1234567890')]) for i in xrange(2) ])\"")

echo "mac address: $MACADDR"

KVM=$(which qemu-system-x86_64)
if [ -z "$KVM" ]; then
  echo "Error: no qemu available."
  exit 1
fi

sudo $KVM -hda $1 -m 1024 -smp 2 $4 \
  -net nic,macaddr=$MACADDR,model=$MODEL \
  -net tap,ifname=$2,script=no \
  -usb \
  -name "`basename $1` $2" \
  -no-quit \
  -monitor stdio \
  $VIRTIOCDROM
