local wezterm = require("wezterm")

config = wezterm.config_builder()

config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Catppuccin Mocha"

-- Only ask for PragmataPro when it's installed; otherwise WezTerm warns on every load
local fonts = { "Iosevka SS08", "Symbols Nerd Font Mono" }
for _, dir in ipairs({ wezterm.home_dir .. "/Library/Fonts", "/Library/Fonts" }) do
  if #wezterm.glob(dir .. "/PragmataPro*") > 0 then
    table.insert(fonts, 1, { family = "PragmataPro Liga", weight = "Regular" })
    break
  end
end
config.font = wezterm.font_with_fallback(fonts)
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
