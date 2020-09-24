client.greennet_tagv2 firmware is hardcoded to reach the sink at address:
280:e1ff:fea0:13e3 (sensor number 495)

Unless this specific sensor board can be found and flashed with sink.greennet_tagv2,
client.greennet_tagv2 will have to be recompiled from 
repository: git@gitlab.imag.fr:greennet/contiki
branch: cnert2016
file: examples/greennet_tagv2/cnert-demo/client.c
macro: UDP_CONNECTION_ADDR
and flashed to all client (leaf) nodes.


