{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  documentation.nixos.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    kinfocenter
    kmenuedit
    gwenview
    konsole
    okular
    oxygen
    spectacle
  ];
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    iproute2
    parallel
    wget
    gnumake
    gcc
    jq
    vim
    fastfetch
    vscode
  ];
  programs.nix-ld.libraries = with pkgs; [
    nodejs
  ];
  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  users.users.cyrus = {
    description = "cyrus";
    extraGroups = [ "docker" "networkmanager" "sudo" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      alacritty
      bat
      bun
      dive
      fish
      flatpak
      fzf
      git
      gh
      go
      lazydocker
      lazygit
      luarocks
      neovim
      php
      phpPackages.composer
      python312
      python312Packages.pip
      ripgrep
      stow
      stylua
      tmux
      vim
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nix-ld.enable = true;
  programs.starship.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;
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
