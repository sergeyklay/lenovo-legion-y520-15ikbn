#!/bin/bash

# Portage
rsync -a --delete /etc/portage/package.use/ "$(pwd)/etc/portage/package.use/"
rsync -a --delete /etc/portage/package.accept_keywords/ "$(pwd)/etc/portage/package.accept_keywords/"
rsync -a --delete /etc/portage/package.mask/ "$(pwd)/etc/portage/package.mask/"

cp /etc/portage/make.conf "$(pwd)/etc/portage/make.conf"
cp /etc/portage/package.license "$(pwd)/etc/portage/package.license"

if [ -f /etc/portage/package.unmask ]; then
  cp /etc/portage/package.unmask "$(pwd)/etc/portage/package.unmask"
else
  rm "$(pwd)/etc/portage/package.unmask"
fi

cp /etc/eselect/repository.conf "$(pwd)/etc/eselect/repository.conf"
cp /var/lib/portage/world "$(pwd)/var/lib/portage/world"

# cfg
cp /etc/cfg-update.conf "$(pwd)/etc/cfg-update.conf"

# Grub
cp /etc/default/grub "$(pwd)/etc/default"

# Console
cp /etc/vconsole.conf "$(pwd)/etc/vconsole.conf"

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

# udev
#
# Run this first time:
#   udevadm control --reload-rules
#   systemctl daemon-reload
cp /usr/local/bin/usb-mount.sh "$(pwd)/usr/local/bin/usb-mount.sh"
cp /etc/systemd/system/usb-mount@.service "$(pwd)/etc/systemd/system/usb-mount@.service"
cp /etc/udev/rules.d/99-local.rules "$(pwd)/etc/udev/rules.d/99-local.rules"
