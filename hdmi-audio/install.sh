#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

mkdir /etc/alsa
cp asound.hdmi-connected asound.hdmi-disconnected hdmi-switch.sh /etc/alsa/
/etc/alsa/hdmi-switch.sh

cp 90-hdmi.rules /etc/udev/rules.d/
udevadm control --reload-rules
