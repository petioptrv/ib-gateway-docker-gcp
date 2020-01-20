#!/bin/bash

printf "Ready to crash Docker container on fatal Supervisor event\n";

while read line; do
  echo "Processing Event: $line" >&2;
  kill -3 $(pgrep supervisor)
done < /dev/stdin