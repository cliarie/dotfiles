-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Setting default window size
config.window_decorations = "RESIZE"
config.initial_rows = 50
config.initial_cols = 180
config.native_macos_fullscreen_mode = true

-- For example, changing the color scheme:
config.color_scheme = "catppuccin-mocha"

config.font_size = 14.0

config.font =
  wezterm.font('PragmataPro Liga', { weight = 200, italic = false })

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

local act = wezterm.action

local w = require('wezterm')

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
local function is_vim(pane)
  -- This gsub is equivalent to POSIX basename(3)
  -- Given "/foo/bar" returns "bar"
  -- Given "c:\\foo\\bar" returns "bar"
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = w.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.keys= {
	{
		key = "w",
		mods = "CMD",
		action = act.CloseCurrentTab({ confirm = false }),
	},
    -- move between split panes
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
    -- resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),
	{
		key = "h",
		mods = "SHIFT|CMD",
		action = act.SplitHorizontal({}),
	},
	{
		key = "k",
		mods = "SHIFT|CMD",
		action = act.CloseCurrentPane({
			confirm = false,
		}),
	},
  }

-- and finally, return the configuration to wezterm
return config
