#!/bin/sh

set -ex

sudo apt-get -y install fail2ban python3-systemd

printf '[DEFAULT]\ndefault_backend = systemd\nlogtarget = SYSTEMD-JOURNAL\n' | sudo tee /etc/fail2ban/jail.local >/dev/null
