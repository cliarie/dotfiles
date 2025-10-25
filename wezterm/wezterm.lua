local wezterm = require("wezterm")

config = wezterm.config_builder()

config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("PragmataPro Liga", { weight = "Regular" })
config.font_size = 12.5

config.initial_rows = 50
config.initial_cols = 180

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

config.background = {
  {
    source = { Color = "#282c35" },
    width = "100%",
    height = "100%",
    opacity = 0.80,
  },
}
return config
