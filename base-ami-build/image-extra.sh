#!/bin/bash -ex
date

version=$(uname -r)
sudo apt-get install -y linux-image-extra-$version
sudo apt-mark hold linux-image-$version linux-image-extra-$version

