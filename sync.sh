#!/bin/bash

# Poratge
rsync -a /etc/portage/package.use/ "$(pwd)/etc/portage/package.use/"
cp /etc/portage/make.conf          "$(pwd)/etc/portage/make.conf"
cp /etc/portage/package.mask       "$(pwd)/etc/portage/package.mask"

# Kernel config
cp "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"

# Kernel modules
rsync -a /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"

# X11 config
rsync -a /etc/X11/xorg.conf.d/ "$(pwd)/etc/X11/xorg.conf.d/"
