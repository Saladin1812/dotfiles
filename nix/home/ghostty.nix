{
  pkgs,
  ...
}:
{
  enable = true;
  enableZshIntegration = true;
  settings = {
    theme = "TokyoNight";
    font-family = "JetBrainsMono Nerd Font Mono";
    font-size = 14;
    gtk-titlebar = false;
    window-width = 140;
    window-height = 40;
    window-padding-x = 5;
    window-padding-y = 5;
    window-save-state = "always";
    background-opacity = 0.8;
  };
}
