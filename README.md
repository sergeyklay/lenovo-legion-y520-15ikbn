# Lenovo Y520 (Legion) Setup

This repository contains my personal configuration for the
`Lenovo Y520-15IKBN (Legion) Type 80WK` I use on the daily as
a secondary workstation.

This repository holds the following configurations:

- Linux Kernel Configuration
- Linux Kernel Modules
- Gentoo Portage Configuration
- GRUB Configuration

## Key features

- UEFI BIOS
- GRUB2
- Systemd
- Gnome
- Samba
- Wayland

## Logs

There are some logs in the `var/logs/` directory I keep for historical reasons
and debugging purposes:

- [dmesg](./var/logs/dmesg) - The Kernel ring buffer
- [lsmod](./var/logs/lsmod) - The status of loaded modules
- [lspci](./var/logs/lspci) - List of all PCI devices
- [lsusb](./var/logs/lsusb) - List of USB devices
- [rfkill](./var/logs/rfkill) - List of all available wireless devices

## Links

Other projects I also support from time to time are:

- [GNU Emacs configuration][emacsd]: My personal configuration for GNU Emacs
- [Dotfiles][dotfiles]: All my dotfiles that I port around from system to system with me

## License

This is free and unencumbered software released into the public domain.
For more see [LICENSE](./LICENSE) file.

[emacsd]: https://github.com/sergeyklay/.emacs.d
[dotfiles]: https://github.com/sergeyklay/dotfiles
