local awful = require("awful")
local modifiers = require("keys.modifiers")

local super = modifiers.super

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			if c.floating then
				local m = mouse.coords()
				if
					math.abs(m.x - c.x) <= 10
					or math.abs(m.y - c.y) <= 10
					or math.abs(m.x - c.x - c.width) <= 10
					or math.abs(m.y - c.y - c.height) <= 10
				then
					c:activate({ context = "mouse_click", action = "mouse_resize" })
				end
			end
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ super }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ super }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)