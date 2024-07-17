#!/bin/sh

set -e
set -x

apk upgrade -U

./setup-user.sh
./setup-ssh.sh
