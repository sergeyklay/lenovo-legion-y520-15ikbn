#!/bin/bash

sync_or_copy() {
  local src_path=$1
  local dest_path=$2

  if [ -d "$src_path" ]; then
    rsync -a --delete "$src_path/" "$dest_path/"
  elif [ -f "$src_path" ]; then
    cp "$src_path" "$dest_path"
  else
    rm -rf "$dest_path"
  fi
}

# Portage
PACKAGE_FILES=(
  make.conf
  package.use
  package.accept_keywords
  package.mask
  package.unmask
  package.license
)
for f in "${PACKAGE_FILES[@]}"; do
  sync_or_copy "/etc/portage/$f" "$(pwd)/etc/portage/$f"
done


sync_or_copy /etc/eselect/repository.conf "$(pwd)/etc/eselect/repository.conf"
sync_or_copy /var/lib/portage/world "$(pwd)/var/lib/portage/world"

# cfg
sync_or_copy /etc/cfg-update.conf "$(pwd)/etc/cfg-update.conf"

# Grub
sync_or_copy /etc/default/grub "$(pwd)/etc/default"

# Console
sync_or_copy /etc/vconsole.conf "$(pwd)/etc/vconsole.conf"

# Kernel config
sync_or_copy "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"

# Kernel modules
rsync -a --delete /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"

# fstab
sync_or_copy /etc/fstab "$(pwd)/etc/fstab"

# Samba config
sync_or_copy /etc/samba/smb.conf "$(pwd)/etc/samba/smb.conf"

# Name Service Switch configuration
sync_or_copy /etc/nsswitch.conf "$(pwd)/etc/nsswitch.conf"

# avahi
sync_or_copy /etc/avahi/avahi-daemon.conf "$(pwd)/etc/avahi/avahi-daemon.conf"

# udev
#
# Run this first time:
#   udevadm control --reload-rules
#   systemctl daemon-reload
sync_or_copy /usr/local/bin/usb-mount.sh "$(pwd)/usr/local/bin/usb-mount.sh"
sync_or_copy /etc/systemd/system/usb-mount@.service "$(pwd)/etc/systemd/system/usb-mount@.service"
sync_or_copy /etc/udev/rules.d/99-local.rules "$(pwd)/etc/udev/rules.d/99-local.rules"
