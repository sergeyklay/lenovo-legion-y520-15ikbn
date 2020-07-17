#!/bin/bash

rsync -a /etc/modules-load.d/ "$(pwd)/etc/modules-load.d/"

rsync -a /etc/portage/package.use/ "$(pwd)/etc/portage/package.use/"
cp /etc/portage/make.conf          "$(pwd)/etc/portage/make.conf"

cp "/usr/src/linux-$(uname -r)/.config" "$(pwd)/usr/src/linux/.config"
