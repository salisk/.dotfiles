local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local slack = sbar.add("item", "widgets.slack", {
	position = "right",
	icon = {
		string = "󰒱",
		font = {
			style = settings.font.style_map["Regular"],
			size = 19.0,
		},
	},
	label = { font = { family = settings.font.numbers } },
	update_freq = 30,
	popup = { align = "center" },
})

slack:subscribe({ "routine", "workspace_change" }, function()
	sbar.exec('lsappinfo info -only StatusLabel "Slack"', function(status_info)
		local icon = "󰒱"
		local label = ""
		local icon_color = colors.green

		-- Extract label using pattern matching
		local label_match = status_info:match('"label"="([^"]*)"')

		if label_match then
			label = label_match

			-- Determine icon color based on Slack status
			if label == "" then
				icon_color = colors.green -- No notifications
			elseif label == "•" then
				icon_color = colors.yellow -- Unread messages
			elseif label:match("^%d+$") then
				icon_color = colors.red -- Specific number of notifications
			else
				-- Unexpected status, don't update
				return
			end
		else
			-- No valid status found
			return
		end

		slack:set({
			icon = {
				string = icon,
				color = icon_color,
			},
			label = {
				string = label,
			},
		})
	end)
end)

slack:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a Slack")
end)

sbar.add("bracket", "widgets.slack.bracket", { slack.name }, {
	background = {
		color = colors.bg3,
	},
})

sbar.add("item", "widgets.slack.padding", {
	position = "right",
	width = settings.group_paddings,
})
