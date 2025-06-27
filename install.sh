#!/usr/bin/env bash

set -e
set -x

apt update
apt install sudo -y

# Installing build dependencies
sudo apt install autoconf build-essential -y
# Configuring
autoreconf
./configure
# Building
make all_lib
# Library install
sudo make install_lib

exit 0

