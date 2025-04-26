nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
};

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  imports = [
    /etc/nixos/hardware-configuration.nix

    (import "${home-manager}/nixos")
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  time.timeZone = "Europe/London";

  console.keyMap = "uk";
  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "cyrus";
      };
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    xserver = {
      desktopManager.xterm.enable = false;
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
  ];

  documentation.nixos.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    khelpcenter
    kinfocenter
    kmenuedit
    konsole
    okular
    oxygen
    spectacle
  ];
  environment.systemPackages = with pkgs; [
    alacritty
    ast-grep
    bun
    cargo
    docker
    docker-compose
    fastfetch
    fd
    flatpak
    fzf
    gcc
    gnumake
    go
    iproute2
    jq
    julia
    kdePackages.qtmultimedia
    lazydocker
    lua51Packages.jsregexp
    lua51Packages.lua
    lua51Packages.luarocks
    neovim
    nodePackages.prettier
    nodejs
    parallel
    php83
    php83Packages.composer
    php83Packages.php-cs-fixer
    python311
    python311Packages.black
    python311Packages.isort
    ripgrep
    stylua
    tailscale
    unzip
    vim
    vscode
    wget
    zulu

    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
# meta

## (neo)vim
p.vim
p.vimdoc
p.regex
p.markdown_inline

## project management
p.gitignore
p.gitcommit
p.markdown

# web dev

## front-end
p.html
p.css
p.javascript
p.typescript
p.astro

## back-end
p.php
p.sql

# dev-ops
p.dockerfile

# software/cli
p.bash
p.python
p.lua

# general
p.go
p.nix

# configuration formats
p.json
p.jsonc
p.yaml
p.toml

# documentation
p.markdown
    ]))
  ];
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #   ];
  # };
  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;

  users.users.cyrus = {
    description = "cyrus";
    extraGroups = [ "docker" "networkmanager" "sudo" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      bat
      dive
      # fish
      git
      gh
      lazygit
      stow
      tmux
    ];
  };
  home-manager.users.cyrus = { pkgs, ... }: {
    home.packages = with pkgs; [
      fish
    ];
    programs.fish.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.
  };

  programs.firefox.enable = true;
  # programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nix-ld.enable = true;
  # programs.starship.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.xserver.videoDrivers = [ "vmware" ];
  systemd.services.flatpak-repo = {
    path = [
      pkgs.flatpak
    ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
    wantedBy = [
      "multi-user.target"
    ];
  };
  virtualisation.docker.enable = true;
  virtualisation.vmware.guest.enable = true;
}
