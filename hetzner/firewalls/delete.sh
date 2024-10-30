#!/bin/sh

set -ex

project=$PROJECT

hcloud context use $project

hcloud firewall delete https
hcloud firewall delete mosh
hcloud firewall delete ping
hcloud firewall delete ssh
hcloud firewall delete tailnet
hcloud firewall delete vite
