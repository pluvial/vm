#!/bin/sh

set -ex

cwd=$(pwd)

mkdir -p ~/.local/cache/forgejo
cd ~/.local/cache/forgejo
trap "cd $cwd" EXIT

version="9.0.0"
name="forgejo-$version-linux-arm64"
file="$name.xz"

url="https://codeberg.org/forgejo/forgejo/releases/download/v$version/$file"
# url="https://code.forgejo.org/forgejo/forgejo/releases/download/v$version/$file"

wget $url

mkdir -p ~/.local/opt
cd ~/.local/opt
xz -cd ../cache/forgejo/$file >$name
chmod +x $name

# mkdir -p ~/.local/bin
# cd ~/.local/bin
# ln -s ~/.local/opt/$name forgejo

sudo cp $name /usr/local/bin/forgejo
sudo chmod 755 /usr/local/bin/forgejo

sudo apt-get -y install git-lfs

sudo adduser --system --shell /bin/bash --gecos 'Git Version Control' \
  --group --disabled-password --home /home/git git

sudo mkdir /var/lib/forgejo
sudo chown git:git /var/lib/forgejo && sudo chmod 750 /var/lib/forgejo

sudo mkdir /etc/forgejo
sudo chown root:git /etc/forgejo && sudo chmod 770 /etc/forgejo

# wget -O /etc/systemd/system/forgejo.service https://codeberg.org/forgejo/forgejo/raw/branch/forgejo/contrib/systemd/forgejo.service
wget https://codeberg.org/forgejo/forgejo/raw/branch/forgejo/contrib/systemd/forgejo.service
sudo cp forgejo.service /etc/systemd/system

sudo systemctl enable forgejo.service
sudo systemctl start forgejo.service
