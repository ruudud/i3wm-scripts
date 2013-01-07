#!/bin/bash
# 
# Battery information:
# http://permalink.gmane.org/gmane.linux.acpi.devel/39226
#
# Based on ideas found
# https://bbs.archlinux.org/viewtopic.php?id=133047
#
export DISPLAY=:0

# Nag when less than THRESHOLD_SHOW_NAG minutes of battery time left
THRESHOLD_SHOW_NAG=7

# Hibernate when less than THRESHOLD_HIBERNATE minutes left
THRESHOLD_HIBERNATE=5

MSG='Battery level critical'

BAT_INFO_DIR='/sys/class/power_supply/BAT0'
ENERGY_NOW=$(cat $BAT_INFO_DIR/energy_now)
POWER_NOW=$(cat $BAT_INFO_DIR/power_now)

NAG_EXEC='/usr/bin/i3-nagbar'
NAG_PID_FILE='/var/run/i3-nagbar-battery.pid'
NAG_PID=$(cat $NAG_PID_FILE 2>/dev/null)

logger "ACPI Battery event - $1"

# The nag function runs NAG_EXEC if it is not running already
nag()
{
    if [ -e /proc/${NAG_PID} -a /proc/${NAG_PID}/exe -ef $NAG_EXEC ]
    then
        # Nagging already in progress…
        return 0;
    else
        $NAG_EXEC -m "$MSG" -b "Hibernate" "pm-hibernate" &> /dev/null &
        echo $! > $NAG_PID_FILE
    fi
}

nag

# If power is 0, battery is charging
if [ $POWER_NOW -eq 0 ]
then
    exit 0
fi

MINS_LEFT=$(echo "60*$ENERGY_NOW/$POWER_NOW" | bc)
logger "ACPI Battery event - Minutes left: $MINS_LEFT"

# Do not show message or hibernate until battery level below 7 minutes
if [ $MINS_LEFT -gt THRESHOLD_SHOW_NAG ]
then
    exit 0
fi

if [ $MINS_LEFT -gt THRESHOLD_HIBERNATE ]
then
    nag
    exit 0
else
    # If less than 5 minutes, hibernate immediately
    pm-hibernate
fi
