# Lenovo Y520 (Legion) - Server Configuration

System configuration for my **Lenovo Y520-15IKBN (Legion) Type 80WK** running
Gentoo Linux as a headless home mini-server.

## What's here

- Kernel configuration (`usr/src/linux/.config`)
- Portage configuration (`etc/portage/`)
- GRUB configuration (`etc/default/grub`)
- System configs (fstab, avahi, cups, modules, etc.)
- Hardware logs for reference (`var/logs/`)

## Key features

- UEFI + GRUB2
- Systemd
- Headless (no GUI, no Wayland, no sound)
- Intel HD 630 (i915, for emergency console access)
- Intel Wireless 8265 (iwlwifi) + Realtek RTL8111 Ethernet
- NVMe root, XFS

## Usage

```sh
# Show available commands
make help

# Sync live system configs into repo
make sync

# Capture hardware/system logs
make logs

# Show diff between live system and repo
make diff

# Remove stale files that no longer exist on the system
make clean
```

## Links

- [GNU Emacs configuration](https://github.com/sergeyklay/.emacs.d)
- [Dotfiles](https://github.com/sergeyklay/dotfiles)

## License

This is free and unencumbered software released into the public domain.
See [LICENSE](./LICENSE) for details.
