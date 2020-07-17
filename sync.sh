#!/bin/bash

rsync -a /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"
cp /etc/portage/make.conf "$(pwd)/etc/portage/make.conf"
cp "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"
