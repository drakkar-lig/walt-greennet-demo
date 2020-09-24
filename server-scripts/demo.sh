#!/bin/bash
trap on-exit EXIT

NODES="sink leaf1 leaf2 leaf3 leaf4"
NODE_SET=$(echo $NODES | tr ' ' ',')

on-exit()
{
    stop-nodes
}

start-nodes()
{
    for node in $NODES
    do
        walt node run $node /root/node-demo.sh
    done
}

stop-nodes()
{
    for node in $NODES
    do
        walt node run $node killall walt-serial-autolog
        walt node run $node gnstop
    done
}

walt node wait $NODE_SET
start-nodes
# wait indefinitely
sleep infinity
