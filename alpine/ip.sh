#!/bin/bash

set -e
# set -x

script=$(readlink -f "$0")
dir=$(dirname "$script")

# remove leading zeros from mac address components
mac=$(cat $dir/.virt.mac | sed 's/^0//g; s/:0/:/g')
ip=$(ndp -an | grep $mac | awk '{print $1}')

echo $ip
