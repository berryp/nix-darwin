local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Terminal
config.audible_bell = "Disabled"
config.initial_cols = 160
config.initial_rows = 48
config.window_close_confirmation = "NeverPrompt"

-- Appearance
config.color_scheme = "Tokyo Night Storm"
config.font = wezterm.font("Fira Code")

-- Keyboard shortcuts
config.keys = {
	{
		key = ",",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewWindow({
			args = {
				"/etc/profiles/per-user/berryp/bin/nvim",
				"/users/berryp/.config/wezterm/wezterm.lua",
			},
		}),
	},
}

return config
