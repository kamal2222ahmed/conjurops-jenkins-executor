#!/bin/bash -ex
date

version=$(uname -r)
sudo dpkg -r linux-virtual linux-headers-generic linux-headers-virtual linux-image-virtual
sudo apt-get install -y linux-image-extra-$version


