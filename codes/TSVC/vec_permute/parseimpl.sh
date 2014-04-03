#!/usr/bin/env bash

(while read line
do
    bench=$(echo $line | sed 's/[^_]*_\(.*\)/\1/;s/\.*exe//')
    read line
    read line
    read line
    set -- $line
    time=$2
    chksum=$3
    echo "$bench,$time,$chksum"
done) | sort -n -k2 -t,
