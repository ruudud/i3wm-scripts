#!/bin/bash
set -x
export DISPLAY=:0

echo "blipp" > /tmp/blapp

hdmi_status="$(cat /sys/class/drm/card0-HDMI-A-1/status)"
USERID="$(cat /var/run/ConsoleKit/database | grep -B 6 is_active=true | grep uid= | cut -f 2 -d '=')"
USER="$(grep $USERID /etc/passwd | cut -f 1 -d ':')"

if [[ $hdmi_status == "disconnected" ]]; then
    [[ $(pgrep X) > 0 ]] && su $USER -c "xrandr --output HDMI1 --off"
else
    [[ $(pgrep X) > 0 ]] && su $USER -c "xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1"
fi

ln -sf "/etc/alsa/asound.hdmi-$hdmi_status" /etc/asound.conf
/usr/sbin/alsactl restore

exit 0
