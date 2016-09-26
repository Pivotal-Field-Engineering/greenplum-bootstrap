#!/usr/bin/env bash

#
# used to cleanup image from all things needed by tools to deploy
# image should be only Pivotal software
#

set -x
set -o pipefail

set
source /tmp/release.properties

# ENABLE NTP
chkconfig ntpd on

# CLEAN UP
rm -f /home/gpadmin/VBoxGuestAdditions.iso
rm -rf /tmp/bins
rm -rf /tmp/configs

# Defragment the blocks or else the generated VM image will still be huge
if [[ $BUILD_NAME = "vbox" || $BUILD_NAME = "vmware" ]]; then
dd if=/dev/zero of=/bigemptyfile bs=4096k
rm -rf /bigemptyfile
fi
