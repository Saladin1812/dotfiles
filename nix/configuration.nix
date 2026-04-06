# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./modules/languages.nix
    ./modules/godot.nix
  ];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
    substituters = [
      "https://cache.nixos.org"
      "https://attic.xuyh0120.win/lantian"
      "https://nix-cache.tokidoki.dev/tokidoki"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
    ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Ensure SecondarySSD mount point is owned by saladin
  systemd.tmpfiles.rules = [
    "d /home/saladin/SecondarySSD 0755 saladin users -"
  ];

  zramSwap.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable gnome keyring with auto-unlock
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;

  hardware.openrazer.enable = true;

  # SU 75 Pro keyboard - WebHID access for xsyd.top
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="1ca6", ATTRS{idProduct}=="3002", MODE="0666"
  '';

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saladin = {
    isNormalUser = true;
    description = "Saladin";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
      "disk"
      "openrazer"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhxuQm7+naB8nLmZaX8z/3WKI1w+TuHEkEakwO6TQxE saladin nixos"
    ];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
           action.id == "org.freedesktop.udisks2.filesystem-mount" ||
           action.id == "org.freedesktop.udisks2.modify-device" ||
           action.id == "org.freedesktop.udisks2.open-device" ||
           action.id == "org.freedesktop.udisks2.open-device-system") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      "saladin" = import ./home/home.nix;
    };
  };

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  services.system76-scheduler.enable = true;

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  programs.niri = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome # For Gnome / Niri
      pkgs.xdg-desktop-portal-gtk # Fallback
      pkgs.xdg-desktop-portal-cosmic # For Cosmic
    ];
    config.common.default = [
      "cosmic"
      "gnome"
      "gtk"
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # For Steam Remote Play
    dedicatedServer.openFirewall = true; # For Source Dedicated Server hosting
    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.proton-cachyos
    ];
    gamescopeSession = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      iosevka
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig.enable = true;
  };

  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  programs.gamemode.enable = true;

  nixpkgs.config.allowUnfree = true;

  drivers.mesa-git = {
    enable = true;
    cacheCleanup = {
      enable = true;
      protonPackage = pkgs.proton-cachyos;
    };
    steamOrphanCleanup.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ mesa.opencl ];
  };
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    android-tools
    pkgsRocm.blender
    clinfo
    direnv
    discord
    deluge
    dunst
    ente-auth
    ente-desktop
    fd
    ffmpeg
    fzf
    codex
    deadlock-mod-manager
    ghostty
    gimp3
    git
    git-filter-repo
    gnomeExtensions.appindicator
    gnome-disk-utility
    grim
    gh
    jq
    itch
    libnotify
    loupe
    lutris
    lxqt.lxqt-policykit
    mangohud
    mesa-demos
    neovim
    fastfetch
    networkmanagerapplet
    oh-my-posh
    openssl
    papirus-icon-theme
    pavucontrol
    polychromatic
    postman
    openrazer-daemon
    pkg-config
    protontricks
    cabextract
    prismlauncher
    papers
    ripgrep
    rofi
    awww
    slurp
    supabase-cli
    steamguard-cli
    tutanota-desktop
    nautilus
    teams-for-linux
    unityhub
    xwayland-satellite
    xdg-user-dirs
    yazi
    unrar
    unzip
    celluloid
    onlyoffice-desktopeditors
    tmux
    vim
    waybar
    wget
    wl-clipboard
    zapzap
    zoxide
  ];

  programs.steam.package = pkgs.steam.override {
    extraPkgs =
      pkgs: with pkgs; [
        libxcursor
        libxi
        libxinerama
        libxscrnsaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
  };

  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
