#!/bin/bash

printf "Ready to crash Docker container on fatal Supervisor event\n";

while read line; do
  echo "Processing Event: $line" >&2;
  echo "tmpreaper clearing out tmp" && tmpreaper --all --showdeleted --force 1h /tmp && echo "tmpreaper finished clearing tmp";
  echo "Emptying IB logs directory" && find ./myfolder -mindepth 1 ! -regex '^/root/Jts/ibgateway\(/.*\)?' -delete && echo "Finished clearing IB logs directory";
  kill -SIGQUIT $PPID
done < /dev/stdin