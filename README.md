# Scripts for running i3 window manager on laptop
This repo includes configuration, scripts and commands needed to get
[i3 window manager](http://i3wm.org/) to work better on a laptop.
Tested on i3 v4.13 running on Arch Linux, but these tips should work on
other Linux systems as well.


## i3 config
See the [dotfiles repo](https://github.com/ruudud/dotfiles/blob/master/i3/config)
for example config.


## When HDMI connects, fix monitor setup and HDMI audio
To configure Alsa to use HDMI sound when connected,
edit the `asound.hdmi-connected` script in the `hdmi-switch/` folder, and then
run the `install.sh` script. `The hdmi-switch.sh` script is run each time the
HDMI cable is connected or disconnected, and also runs xrandr.

An [answer on StackExchange](http://unix.stackexchange.com/questions/29185/how-to-check-why-sound-over-hdmi-doesnt-work)
provides help on finding the correct Alsa device and card.

TODO: switch to Pulseaudio?


# Lock on suspend (when closing laptop lid)
The following requires that you're using systemd-logind.
Add the file `/etc/systemd/system/i3lock.service` with the following contents,
replacing `USERNAM` with your user:

```
[Unit]
Description=i3lock on suspend
Before=sleep.target

[Service]
User=<USERNAME>
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -c 141414

[Install]
WantedBy=sleep.target
```


# Dimming screen when on battery, monitor off
Add the file `/etc/pm/power.d/performance` with the following contents;
 
```shell
#!/bin/sh

if [ "$1" = "true" ]
then 
    # Battery
    # Dim screen
    echo 13 > /sys/class/backlight/acpi_video0/brightness
    # 300s before standby and suspend, 60s monitor off
    xset dpms 100 100 100
else
    # AC
    # Full brightness
    echo 15 > /sys/class/backlight/acpi_video0/brightness
    # 300s before standby suspend and monitor off
    xset dpms 300 300 300
fi
```

Remember to `chmod u+x /etc/pm/power.d/performance` afterwards.
