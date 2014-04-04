#!/usr/bin/env bash

pattern="Time(Sec)"
parsing=0
(while read line
    do
    if ! [[ $line = *$pattern* ]] # ignore lines with /pattern/
    then
	if [[ -n "$line" ]] # check if line is not empty
	then
	    if [[ $parsing -eq 0 ]] # if we haven't read benchmark, read it!
	    then
		bench=$(echo $line | sed 's/[^_]*_\(.*\)/\1/;s/\.*exe//')
		parsing=1
	    else
		set -- $line
		if [[ -z "$3" ]] # we actually read the next benchmark; store it
		then
		    bench=$(echo $line | sed 's/[^_]*_\(.*\)/\1/;s/\.*exe//')
		    parsing=1
		else # set time and checksum
		    parsing=0
		fi
		# print
		time=$2
		chksum=$3
		echo "$bench,$time,$chksum"
	    fi
	fi
    fi
done) | sort -n -k2 -t,
