#!/bin/sh

set -ex

sudo apt-get -y install nodejs node-corepack npm

sudo corepack enable pnpm
