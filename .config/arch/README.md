# Archinstall
There's a [better way of doing this](https://github.com/archlinux/archinstall/tree/master/archinstall/default_profiles), this exists as a simpler alternative for better/worse.

### Setup
```bash
curl -L archinstall.cyrus01337.co.uk | env DEVELOPMENT_ENVIRONMENT="sway" DISK="/dev/sda" PASSWORD="..." bash
```

### Post-install

#### Switching display managers
The default display manager is [`greetd`](https://wiki.archlinux.org/title/Greetd). To switch to SDDM, run the following:
```bash
change-display-manager sddm
```

To switch back to `greetd`, run the following:
```bash
change-display-manager greetd
```
