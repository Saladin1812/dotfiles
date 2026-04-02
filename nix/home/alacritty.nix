{
  pkgs,
  ...
}:
{
  enable = true;
  package = pkgs.alacritty;

  settings = {
    window = {
      padding = {
        x = 4;
        y = 8;
      };
      decorations = "None";
      opacity = 0.8;
      startup_mode = "Windowed";
      title = "Alacritty";
      dynamic_title = true;
    };

    general = {
      import = [
        pkgs.alacritty-theme.tokyo_night
      ];

      live_config_reload = true;
    };

    font =
      {
        size = 15;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold.style = "Bold";
        italic.style = "Italic";
        bold_italic.style = "Bold Italic";
      };

    mouse.hide_when_typing = true;

    cursor = {
      style = "Block";
    };

    env = {
      TERM = "xterm-256color";
    };
  };
}
