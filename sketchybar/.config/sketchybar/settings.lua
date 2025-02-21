return {
	paddings = 3,
	group_paddings = 5,

	icons = "sf-symbols", -- alternatively available: sf-symbols

	-- This is a font configuration for SF Pro and SF Mono (installed manually)
	font = require("helpers.default_font"),
	clipboard = {
		max_items = 7,
	},
	calendar = {
		click_script = "open -a Calendar",
	},
	stocks = {
		default_symbol = { symbol = "SXR8.DE", name = "S&P 500" },
		symbols = {
			{ symbol = "VWCE.DE", name = "FTSE All-World" },
			{ symbol = "BTC-USD", name = "Bitcoin" },
			{ symbol = "MEUD.PA", name = "Stoxx 600" },
		},
	},
	weather = {
		location = "Vilnius",
		use_shortcut = false,
	},
	python_command = "python3",

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	-- font = {
	--   text = "JetBrainsMono Nerd Font", -- Used for text
	--   numbers = "JetBrainsMono Nerd Font", -- Used for numbers
	--   style_map = {
	--     ["Regular"] = "Regular",
	--     ["Semibold"] = "Medium",
	--     ["Bold"] = "SemiBold",
	--     ["Heavy"] = "Bold",
	--     ["Black"] = "ExtraBold",
	--   },
	-- },
}
