#!/bin/bash
set -x
export DISPLAY=:0

hdmi_status="$(cat /sys/class/drm/card0-HDMI-A-1/status)"

change-display() {
  local user="$(w -h | grep tty | head -n1 | awk '{print $1}')"
  
  if [[ $hdmi_status == "disconnected" ]]; then
      [[ $(pgrep X) > 0 ]] && su $user -c "xrandr --output HDMI1 --off"
  else
      [[ $(pgrep X) > 0 ]] && su $user -c "xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1"
  fi
}

change-audio() {
  ln -sf "/etc/alsa/asound.hdmi-$hdmi_status" /etc/asound.conf
  /usr/sbin/alsactl restore
}

change-display
change-audio

exit 0
