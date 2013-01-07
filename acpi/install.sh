#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

cp low_battery_warning.sh /etc/acpi/
cp low_battery_warning /etc/acpi/events/

chmod u+x /etc/acpi/low_battery_warning.sh

# Reload ACPId event rules
kill -HUP $(pidof acpid)
