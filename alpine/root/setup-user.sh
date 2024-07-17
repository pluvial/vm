#!/bin/sh

set -e
set -x

apk add doas

adduser -g alpine alpine
adduser alpine wheel
