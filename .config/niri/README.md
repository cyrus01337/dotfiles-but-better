### Setup
```bash
PACKAGES="swww xwayland-satellite"
PACKAGE_MANAGER_FLAGS="-S --needed --noconfirm"

(which yay &> /dev/null \
    && yay $PACKAGE_MANAGER_FLAGS $PACKAGES \
    || sudo pacman $PACKAGE_MANAGER_FLAGS $PACKAGES)
```
