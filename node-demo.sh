#!/bin/sh

# Run in background, release ssh command
# if this script is run by:
# walt node run <this-node> /root/node-demo.sh
at now << EOF

# reboot the sensor
gnreboot

# start forwarding traces to walt
walt-serial-autolog /dev/ttyACM1

EOF
