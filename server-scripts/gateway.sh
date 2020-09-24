#!/bin/bash
trap ctrl-c INT

ctrl-c()
{
    kill $$
}

# writing to fd 5 sends to stdout
# writing to fd 6 sends a log line to vizwalt
pid=$$
exec 5>&1
exec 6> >(nc localhost 4445; kill $pid)

# we must associate an index to each node
first_ts=""

publish-log()
{
    echo "$1" >&5 # print to stdout
    echo "$1" >&6 # send to vizwalt
}

normalize_ts()
{
    # PB: Added LANG var because awk float formating depends on the locale
    LANG=en_US.utf8 awk "BEGIN {printf \"%.3f\", $1+1-$first_ts}"
}

# PB: Argument parser in order to enable the vizwalt sys:IgnoreTimestamps
# option if wanted.
ignore_ts=true
if [[ $# > 0 ]]; then
    if [ "$1" = "--ignore-ts" ]; then
        ignore_ts=true
    fi
fi

walt log show --realtime --streams "vizwalt"                \
            --nodes all-nodes                               \
            --format '{timestamp:%s.%f} {line}' | {
    # set -x
    sed_cmd='sed -e #'  # do nothing at first iteration
    next_node_id=1
    while read timestamp line
    do
        # normalize timestamps
        # --------------------
        if [ "$first_ts" = "" ]
        then
            first_ts=$timestamp
            # PB: If --ignore-ts option is present, we set vizwalt IgnoreTimestamps
            # variable to true through WalT log when the first packet is received.
            "$ignore_ts" && publish-log "0:sys:IgnoreTimestamps"
        fi
        timestamp=$(normalize_ts $timestamp)

        # replace each nodeid(<id>) by an integer node id (needed by cooja)
        # -----------------------------------------------------------------
        # 1- replace known nodes
        line="$(echo "$line" | $sed_cmd)"
        # 2- detect new nodes and affect a node id
        new_nodes="$(echo "$line" | grep -o 'nodeid([^)]*)' | sed -e 's/nodeid(\(.*\))/\1/g')"
        for new_node in $new_nodes
        do
            sed_expr="-e s/nodeid($new_node)/$next_node_id/g"
            # publish the name as a log line
            publish-log "$timestamp:$next_node_id:Attributes:name=$new_node"
            sed_cmd="$sed_cmd $sed_expr"
            next_node_id=$((next_node_id+1))
        done
        # 3- replace new nodes just detected
        line="$(echo "$line" | $sed_cmd)"

        # publish walt log
        # ----------------
        publish-log "$timestamp:$line"
    done
}
