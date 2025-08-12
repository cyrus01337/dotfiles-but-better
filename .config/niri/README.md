### Notes
This is helpful for getting details on the current workspace:
```bash
niri msg --json workspaces | qq ".[] | select(.is_focused)"
```

This is helpful for getting all windows (combine with above to filter by workspace):
```bash
niri msg windows
```

### Setup
```bash
yay -S --needed --noconfirm flameshot grim libnotify mako niri swww sysmenu xwayland-satellite
```
