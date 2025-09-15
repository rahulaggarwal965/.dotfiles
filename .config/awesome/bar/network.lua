local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

local M = {}
local meta = {}

M.instances = {}

local function wifi_icon_for(state)
	-- Priorities:
	-- 1) Wi-Fi radio off -> icon: wifi-off
	-- 2) Wi-Fi radio on but not connected -> icon: wifi-0
	-- 3) Connected on ethernet -> icon: ethernet
	-- 4) Connected on wifi -> strength bars by signal
	local font = beautiful.font or "SF Pro Display 10"
	local fa = "RobotoMono Nerd Font 10"

	if state and state.primary_type == "ethernet" and state.connected then
		return { text = " ", font = fa } -- ethernet icon
	end

	if state and state.primary_type == "wifi" then
		if state.wifi_radio == false then
			return { text = "󰖪 ", font = fa } -- wifi off
		end
		if not state.connected then
			return { text = "󰤯 ", font = fa } -- wifi on, no connection
		end
		local signal = tonumber(state.signal or 0) or 0
		if signal >= 75 then
			return { text = "󰤨 ", font = fa } -- full
		elseif signal >= 50 then
			return { text = "󰤥 ", font = fa } -- 3 bars
		elseif signal >= 25 then
			return { text = "󰤢 ", font = fa } -- 2 bars
		else
			return { text = "󰤟 ", font = fa } -- 1 bar
		end
	end

	-- Fallbacks
	if state and state.wifi_radio == false then
		return { text = "󰖪 ", font = fa }
	end
	if state and not state.connected then
		return { text = "󰤯 ", font = fa }
	end
	return { text = "󰤟 ", font = fa }
end

function M.new()
	local textbox = wibox.widget {
		widget = wibox.widget.textbox,
		font = "Font Awesome 6 Free 10",
		halign = "center",
		text = "󰤯 ",
	}

	local widget = wibox.widget {
		widget = wibox.container.background,
		shape = gears.shape.rounded_rect,
		{
			widget = wibox.container.margin,
			margins = { left = dpi(8), right = dpi(8) },
			textbox
		}
	}

	awesome.connect_signal("system::network", function(state)
		local icon = wifi_icon_for(state)
		textbox.font = icon.font
		textbox.text = icon.text
	end)

	-- initialize with current state if available
	local sys = require("sysinfo.network_nm")
	local current = sys.get_state and sys.get_state() or nil
	require("gears").debug.dump(current)
	local icon = wifi_icon_for(current)
	print("icon", gears.debug.dump_return(icon))
	textbox.font = icon.font
	textbox.text = icon.text

	table.insert(M.instances, textbox)
	return widget
end

function meta.__call(_, ...)
	return M.new(...)
end

return setmetatable(M, meta)

