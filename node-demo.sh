#!/bin/sh

# Daemon mode by default, deactivated by -d as *first* argument
if [ "$1" != -d ]; then
  "$0" -d "$@" &
  exit 0
fi

# reboot the sensor
gnreboot

# start forwarding traces to walt
walt-serial-autolog /dev/ttyACM1
