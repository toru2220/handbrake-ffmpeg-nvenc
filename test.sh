#!/bin/bash

NUM_MAX=20
i=0

while [ "$i" -lt ${NUM_MAX} ]
do
  logger "$1 (PID=$$,NUM=$i)"
  sleep 1
  i=$((i+1))
done

