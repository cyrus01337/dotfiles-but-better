# Dotfiles

This repository includes all of my dotfiles ranging from my shell configuration
to how I operate Tmux to my workflow with Neovim. This is intended to be public
source to make cloning and handling easier, and as a result is not intended to
be used by others due to my usage of submodules and SSH authentication.

### I used to be able to use this, what happened?

Maintenance upkeep crept onto me which I'd rather be without when working on my
own personal files, hence my decision. I will no longer provide instructions as
of this commit.

### Setup

Kept for personal usage:

```sh
(which curl &> /dev/null \
    && curl -L dotfiles.cyrus01337.co.uk \
    || wget -qLO- dotfiles.cyrus.co.uk) | bash
```
