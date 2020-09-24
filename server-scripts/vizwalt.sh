#!/bin/bash
trap ctrl-c INT

PID=$$

ctrl-c()
{
    # kill process childs
    kill -INT $(ps --ppid $PID -o pid=) 2>/dev/null
}

{
    ssh -X 192.168.152.2 /root/vizwalt.sh
    ctrl-c
} &
walt log wait --streams vizwalt-sync VIZWALT-OK
walt node expose vnode-vizwalt 4445 4445
