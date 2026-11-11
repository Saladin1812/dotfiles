local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.font_size = 18
config.font = wezterm.font("BlexMono Nerd Font Mono")
config.color_scheme = "tokyonight_night"
config.default_prog = { '/usr/bin/fish' }
config.initial_cols = 100
config.initial_rows = 25

config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}

config.window_decorations = 'RESIZE'
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'

-- Keymap
config.keys = {
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.SendString 'clear\n'
  },
}

return config
