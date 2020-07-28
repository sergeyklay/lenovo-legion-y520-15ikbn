#!/bin/bash

# Poratge
rsync -a --delete /etc/portage/package.use/ "$(pwd)/etc/portage/package.use/"
cp /etc/portage/make.conf "$(pwd)/etc/portage/make.conf"
cp /etc/portage/package.mask "$(pwd)/etc/portage/package.mask"
cp /etc/portage/package.license "$(pwd)/etc/portage/package.license"

# Grub
cp /etc/default/grub "$(pwd)/etc/default"

# Kernel config
cp "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"

# Kernel modules
rsync -a --delete /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"

# Samba config
cp /etc/samba/smb.conf "$(pwd)/etc/samba/smb.conf"
