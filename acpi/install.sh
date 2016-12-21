#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

cp low_battery_warning.sh /etc/acpi/
cp battery /etc/acpi/events/

# Reload ACPId event rules
kill -HUP $(pidof acpid)
