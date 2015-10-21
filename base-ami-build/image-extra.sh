#!/bin/bash -ex
date

version=$(uname -r)
sudo apt-get install -y linux-image-extra-$version

# These packages always depend on the latest version of the associated
# kernel packages. We don't want the kernel upgraded, so get rid of
# them.
sudo dpkg -r linux-virtual linux-headers-generic linux-headers-virtual linux-image-virtual


