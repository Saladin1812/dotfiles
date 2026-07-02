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
    inputs.helium-browser.packages.x86_64-linux.helium
  ];

  xdg.enable = true;

  xdg.configFile.hypr.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/hypr;
  xdg.configFile.niri.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/niri;
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/nvim;
  xdg.configFile.ohmyposh.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/ohmyposh;
  xdg.configFile.dunst.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/dunst;
  xdg.configFile.waybar.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/waybar;
  xdg.configFile.rofi.source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/rofi;
  xdg.configFile."godot/editor_settings-4.6.tres" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.config/godot/editor_settings-4.6.tres;
    force = true;
  };
  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.zshrc;
  home.file.".cargo/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink /home/saladin/.dotfiles/.cargo/config.toml;
  home.file.".local/bin/godotdev" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      SOCKET="''${GODOT_NVIM_SOCKET:-/tmp/godot.nvim}"
      NVR="''${NVR:-${pkgs.neovim-remote}/bin/nvr}"

      if [[ -S "$SOCKET" ]]; then
        if "$NVR" --nostart --servername "$SOCKET" --remote-expr '1' >/dev/null 2>&1; then
          echo "Neovim server already running at $SOCKET"
          exit 0
        fi

        echo "Removing stale socket: $SOCKET"
        rm -f "$SOCKET"
      fi

      exec ${pkgs.neovim}/bin/nvim --listen "$SOCKET" "$@"
    '';
    executable = true;
    force = true;
  };
  home.file.".local/bin/godot-nvr.sh" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      DEFAULT_TERMINAL="ghostty"
      ARG0="''${1:-}"

      if [[ -n "$ARG0" && "$ARG0" != +* && "$ARG0" != --* && ! -f "$ARG0" ]]; then
        GODOT_TERMINAL="$ARG0"
        shift
      else
        GODOT_TERMINAL="$DEFAULT_TERMINAL"
      fi

      SOCKET="''${GODOT_NVIM_SOCKET:-/tmp/godot.nvim}"
      NVR="''${NVR:-${pkgs.neovim-remote}/bin/nvr}"

      OPEN_MODE="window"
      LINE=""
      FILE=""

      while [[ $# -gt 0 ]]; do
        case "$1" in
          --tab) OPEN_MODE="tab"; shift ;;
          --vsplit) OPEN_MODE="vsplit"; shift ;;
          +[0-9]*) LINE="''${1#+}"; shift ;;
          *) FILE="$1"; shift ;;
        esac
      done

      [ -z "$FILE" ] && exit 0

      NVR_ARGS=()
      [ -n "$LINE" ] && NVR_ARGS+=("+$LINE")
      NVR_ARGS+=("$FILE")

      case "$OPEN_MODE" in
        window) "$NVR" --servername "$SOCKET" --remote "''${NVR_ARGS[@]}" ;;
        tab) "$NVR" --servername "$SOCKET" --remote-tab "''${NVR_ARGS[@]}" ;;
        vsplit) "$NVR" --servername "$SOCKET" -O "''${NVR_ARGS[@]}" ;;
      esac

      "$NVR" --servername "$SOCKET" --remote-send "<C-\\><C-N>zz"
    '';
    executable = true;
    force = true;
  };
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
    gtk4.theme = null;
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
