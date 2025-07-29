# Archinstall
TODO

### Setup
```bash
curl -L archinstall.cyrus01337.co.uk | env DISK="/dev/sda" PASSWORD="..." bash
```

#### Use SDDM and auto-login to KDE
```bash
sudo systemctl disable --now greetd && \
    sudo systemctl enable --now sddm
```

#### Use fast greetd and auto-login to Sway
```bash
sudo systemctl disable --now sddm && \
    sudo systemctl enable --now greetd
```
