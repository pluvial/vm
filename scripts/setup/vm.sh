#!/bin/sh

set -ex

cwd=$(pwd)
dir=~/vm

mkdir -p $dir
cd $dir
trap "cd $cwd" EXIT

repo=pluvial/vm
repo_url=https://github.com/$repo
tarball_url=$repo_url/archive/main.tar.gz

# curl -L $tarball_url | tar xzf - --strip-components=1
# wget $tarball_url -O - | tar xzf - --strip-components=1
# git clone --depth=1 $repo_url .
# git clone $repo_url .
gh repo clone $repo .
