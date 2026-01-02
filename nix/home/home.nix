{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "saladin";
  home.homeDirectory = "/home/saladin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    protonup-ng
    bibata-cursors
    morewaita-icon-theme
    inputs.zen-browser.packages.x86_64-linux.default
    pkgs.nur.repos.Ev357.helium
  ];

  xdg.enable = true;

  xdg.configFile.hypr.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/hypr;
  xdg.configFile.niri.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/niri;
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/nvim;
  xdg.configFile.ohmyposh.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/ohmyposh;
  xdg.configFile.dunst.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/dunst;
  xdg.configFile.waybar.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/waybar;
  xdg.configFile.rofi.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/rofi;
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.zshrc;
  home.file.".cargo/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.cargo/config.toml;
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "MoreWaita";
    };
  };

  home.file.".config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text =
    builtins.toJSON
      { Path = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"; };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  programs = {
    alacritty = import ./alacritty.nix { inherit config pkgs; };
    fzf = import ./fzf.nix { inherit pkgs; };
    ghostty = import ./ghostty.nix { inherit pkgs; };
    git = import ./git.nix { inherit config pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    vscode = import ./vscode.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit config pkgs; };
    obs-studio = import ./obs-studio.nix { inherit config pkgs; };
  };

  imports = [
    # Assuming the nvimunity.nix file is in a 'nix' subdirectory
    ./nvimunity.nix
  ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   ".config/nvim".source = ./dotfiles/nvim;
  #    ".config/ohmyposh".source = ./dotfiles/ohmyposh;
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/saladin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\$HOME/.steam/root/compatibilitytools.d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
