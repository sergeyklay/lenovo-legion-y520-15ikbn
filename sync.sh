#!/bin/bash

# Portage
rsync -a --delete /etc/portage/package.use/ "$(pwd)/etc/portage/package.use/"
cp /etc/portage/make.conf "$(pwd)/etc/portage/make.conf"
cp /etc/portage/package.mask "$(pwd)/etc/portage/package.mask"
cp /etc/portage/package.license "$(pwd)/etc/portage/package.license"
cp /etc/portage/package.mask "$(pwd)/etc/portage/package.mask"
cp /var/lib/portage/world var/lib/portage/world

# Grub
cp /etc/default/grub "$(pwd)/etc/default"

# Kernel config
cp "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"

# Kernel modules
rsync -a --delete /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"

# fstab
cp /etc/fstab "$(pwd)/etc/fstab"

# Samba config
cp /etc/samba/smb.conf "$(pwd)/etc/samba/smb.conf"

# Name Service Switch configuration
cp /etc/nsswitch.conf "$(pwd)/etc/nsswitch.conf"

# avahi
cp /etc/avahi/avahi-daemon.conf "$(pwd)/etc/avahi/avahi-daemon.conf"

# genkernel
cp /etc/genkernel.conf "$(pwd)/etc/genkernel.conf"
