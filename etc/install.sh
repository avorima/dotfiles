#!/bin/bash

if [[ $UID -ne 0 ]]; then
    echo "Please run this script as root:"
    echo "  sudo $0 $*"
    exit 1
fi

cp -f $HOME/etc/pm/performance /etc/pm/power.d/
cp -f $HOME/etc/services/i3lock.service /etc/systemd/system/
cp -f $HOME/etc/acpi/low_battery_warning.sh /etc/acpi/
cp -f $HOME/etc/acpi/battery /etc/acpi/events/
cp -f $HOME/etc/udev/monitor-hotplug.conf /etc/udev/rules.d/

# Reload ACPId event rules
kill -HUP $(pidof acipd)

# Reaload udev rules
udevadm control --reload-rules
