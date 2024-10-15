#!/bin/sh

set -ex

sudo apt-get -y install elixir erlang

mix local.hex

sudo apt-get -y install inotify-tools
mix archive.install hex phx_new
