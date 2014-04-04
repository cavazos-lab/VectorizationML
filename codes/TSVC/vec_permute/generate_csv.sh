#!/usr/bin/env bash

mkdir -p res
for i in *.c
do
    benchmark=$(echo $i | sed 's/\.c//')
    ./parseimpl.sh < exec/$benchmark/run.log > res/$benchmark.out
done
