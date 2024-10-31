#!/bin/sh

set -ex

arch=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')
arch_alt=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/x64/')

# sudo install -dm 755 /etc/apt/keyrings
# wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
# echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$arch] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
# sudo apt update
# sudo apt -y install mise

# cargo install mise

# cargo install cargo-binstall
# cargo binstall mise

# curl https://mise.jdx.dev/mise-latest-linux-$arch_alt > ~/.local/bin/mise
# chmod +x ~/.local/bin/mise

file="install.sh"
url="https://mise.run"

cwd=$(pwd)

mkdir -p ~/.local/cache/mise
cd ~/.local/cache/mise
trap "cd $cwd" EXIT

wget -O $file $url
chmod +x $file

./$file

echo "~/.local/bin/mise activate fish | source" >>~/.config/fish/config.fish
