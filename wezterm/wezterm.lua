local wezterm = require 'wezterm'
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

return config

