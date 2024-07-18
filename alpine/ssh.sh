#!/bin/bash

set -e
# set -x

script=$(readlink -f "$0")
dir=$(dirname "$script")

if [ "$1" = "--root" ]; then
  user=root
  shift # filter out --root
  args="$@"
else
  user=alpine
  args="$@"
fi

ip=$($dir/ip.sh)

cmd="ssh $user@$ip $args"
echo "$cmd"
eval "$cmd"
