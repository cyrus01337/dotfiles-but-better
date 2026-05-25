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
yay -S --needed --noconfirm roji grim libnotify mako niri wbg xwayland-satellite
```
