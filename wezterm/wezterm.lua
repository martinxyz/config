local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- config.color_scheme = 'Tomorrow Night'
-- config.color_scheme = 'Breeze'
-- config.color_scheme = 'Breath Darker (Gogh)'
config.color_scheme = 'Hardcore'

-- no effect? (after installing the font with apt)
-- font = wezterm.font('JetBrainsMono Nerd Font')
-- font_size = 14
-- line_height = 1.2
scrollback_lines = 10000

-- no effect?
hide_tab_bar_if_only_one_tab = true
-- enable_tab_bar = false

config.default_prog = { '/usr/bin/fish', '-l' }
config.set_environment_variables = {
	SHELL = '/usr/bin/fish'
}

config.initial_cols = 100
config.initial_rows = 35


-- https://wezterm.org/config/mouse.html#configuring-mouse-assignments
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
}

return config

