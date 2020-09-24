FROM waltplatform/rpi-3-b-plus-default

# OS packages
RUN apt-get update && apt-get install --no-install-recommends -y at psmisc

# WalT
RUN pip install --upgrade pip setuptools wheel
RUN pip install walt-node
RUN walt-setup-systemd

# GreenNet
COPY 99-greennet-nodes.rules /etc/udev/rules.d/
COPY gnreboot gnflash gnstop gninit openocd /usr/bin/
COPY greennet-ocd-stlink.tcl /usr/lib/
COPY client.greennet_tagv2 sink.greennet_tagv2 node-demo.sh /root/
