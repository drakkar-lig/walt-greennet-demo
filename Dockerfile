FROM waltplatform/rpi-3-b-plus-default

# WalT
RUN pip install setuptools wheel && pip install walt-node
RUN walt-setup-systemd
RUN ln -s /bin/walt-cat /bin/walt-log-cat

# GreenNet
COPY gnreboot gnflash gnstop openocd /usr/bin/
COPY greennet-ocd-stlink.tcl /usr/lib/
COPY client.greennet_tagv2 sink.greennet_tagv2 node-demo.sh /root/
