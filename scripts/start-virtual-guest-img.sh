#!/bin/sh

MODEL=$2
if [ -z $2 ]; then
  echo "Warning: No nic model set!"
  echo "Warning: Default will be 'e1000'."
  MODEL=e1000
fi

echo "kvm -hda $1 -m 1024 -net nic,model=$MODEL -net user -smp 2 $3 &"

kvm -hda $1 -m 1024 \
  -net nic,model=$MODEL -net user -smp 2 $3 &
