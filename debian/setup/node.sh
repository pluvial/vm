#!/bin/sh

set -ex

sudo apt-get install nodejs node-corepack npm

corepack enable pnpm
