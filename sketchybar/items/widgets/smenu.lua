local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 200
-- Main smenu icon to trigger popup


local smenu = sbar.add("item", {
	position = "left",
	display = 1,
	background = {
		border_width = 0,
		border_color = colors.bar.border
	},
	icon = {
		string = icons.start,
		color = colors.primary,
		padding_left = 5,
		padding_right = 10,
		size = 14,
	},
	popup = {
		align = "left",
		horizontal = false,
		height = "dynamic",
		width = popup_width,
	}
})

-- Hover effect
smenu:subscribe("mouse.entered", function()
	sbar.animate("elastic", 15, function()
		smenu:set({
			icon = {
				font = { size = 16, style = "Bold" },
				color = colors.white,
			},
		})
	end)
end)

smenu:subscribe("mouse.exited", function()
	sbar.animate("elastic", 15, function()
		smenu:set({
			icon = {
				font = { size = 14, style = "Bold" },
				color = colors.primary,
			},
		})
	end)
end)



-- Helper function to create menu items with hover effect
local function create_menu_item(position, label, icon_string, click_command)
	local item = sbar.add("item", {
		position = position,
		icon = {
			string = icon_string,
			padding_left = 5,
			padding_right = 15,
			color = colors.primary,
		},
		label = {
			string = label,
			color = colors.primary,
			padding_left = 10,
			padding_right = 20,
			align = "left",
			font = { size = 12 }
		},
		background = {
			padding_left = 10,
			padding_right = 20,
			color = colors.transparent,
			height = 40, -- Reduced height for compactness
			width = popup_width

		},
		click_script = click_command
	})

	-- Hover effect
	item:subscribe("mouse.entered", function()
		sbar.animate("elastic", 15, function()
			item:set({
				icon = {
					padding_left = 5,
					padding_right = 15,
					color = colors.orange,
					font = { size = 16 },
				},
				label = {
					color = colors.darkGrey,
					padding_left = 10,
					padding_right = 20,
					align = "left",
					font = { size = 12, style = "Bold" }
				},
			})
		end)
	end)
	item:subscribe("mouse.exited", function()
		sbar.animate("elastic", 15, function()
			item:set({
				icon = {
					padding_left = 5,
					padding_right = 20,
					font = { size = 14 },
					color = colors.primary,
				},
				label = {
					padding_left = 10,
					padding_right = 20,
					string = label,
					color = colors.primary,
					align = "left",
					font = { size = 12 }
				},
			})
		end)
	end)

	return item
end

-- Add each custom menu entry to the popup
local about_mac = create_menu_item("popup." .. smenu.name, "About", icons.user,
	"open -a 'About This Mac'")
local system_settings = create_menu_item("popup." .. smenu.name, "Settings", icons.circle_gear,
	"open -a 'System Preferences'")
local force_quit = create_menu_item("popup." .. smenu.name, "Force Quit", icons.circle_quit,
	"osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down}'")
local sleep = create_menu_item("popup." .. smenu.name, "Sleep", icons.circle_sleep, "pmset displaysleepnow")
local restart = create_menu_item("popup." .. smenu.name, "Restart", icons.circle_restart,
	"osascript -e 'tell app \"System Events\" to restart'")
local shutdown = create_menu_item("popup." .. smenu.name, "Power off", icons.circle_shutdown,
	"osascript -e 'tell app \"System Events\" to shut down'")

-- Toggles popup on click
smenu:subscribe("mouse.clicked", function(env)
	sbar.animate("elastic", 15, function()
		smenu:set({
			icon = {
				color = colors.white,
				size = 18,
			},
			popup = {
				y_offset = 0,
				height = 0,
				drawing = "toggle"
			}
		})
	end)
end)

-- Hides popup on mouse exit
smenu:subscribe("mouse.exited.global", function(env)
	sbar.animate("elastic", 15, function()
		smenu:set({
			popup = {
				y_offset = -10,
				height = 0,
				drawing = false
			}
		})
	end)
end)


return smenu
