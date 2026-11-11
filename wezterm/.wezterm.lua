local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.font_size = 17
config.font = wezterm.font("BlexMono Nerd Font Mono")
config.color_scheme = "tokyonight_night"
config.default_prog = { '/usr/bin/fish' }

config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}

config.window_decorations = 'RESIZE'
config.enable_tab_bar = false

-- Keymap
config.keys = {
  {
    key = 'q',
    mods = 'SUPER',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },

  {
    key = 'c',
    mods = 'SUPER',
    action = wezterm.action.SendString 'clear\n'
  },
}

return config
