local awful = require("awful")
local beautiful = require("beautiful")
local modifiers = require("keys.modifiers")

local super = modifiers.super
local shift = modifiers.shift
local ctrl = modifiers.ctrl
local alt = modifiers.alt

awful.key.keygroups["hjkl"] = {
	{"h", "left"},
	{"j", "down"},
	{"k", "up"},
	{"l", "right"},
}

local direction_translate = {
	["left"] = "left",
	["down"] = "bottom",
	["up"] = "top",
	["right"] = "right",
}

local function move_client(direction, c)
	if c.floating or awful.layout.get(mouse.screen) == awful.layout.suit.floating then
		local old = c:geometry()
		local new = awful.placement[direction_translate[direction]](
			c,
			{ honor_padding = true, honor_workarea = true, margins = 0, pretend = true }
		)
		if direction == "up" or direction == "down" then
			c:geometry({ x = old.x, y = new.y })
		else
			c:geometry({ x = new.x, y = old.y })
		end
	else
		awful.client.swap.bydirection(direction, c, nil)
	end
end

local floating_resize_amount = beautiful.xresources.apply_dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(direction, c)
	if c.floating or awful.layout.get(mouse.screen) == awful.layout.suit.floating then
		if direction == "up" then
			c:relative_move(0, 0, 0, -floating_resize_amount)
		elseif direction == "down" then
			c:relative_move(0, 0, 0, floating_resize_amount)
		elseif direction == "left" then
			c:relative_move(0, 0, -floating_resize_amount, 0)
		elseif direction == "right" then
			c:relative_move(0, 0, floating_resize_amount, 0)
		end
	else
		if direction == "up" then
			awful.client.incwfact(-tiling_resize_factor)
		elseif direction == "down" then
			awful.client.incwfact(tiling_resize_factor)
		elseif direction == "left" then
			awful.tag.incmwfact(-tiling_resize_factor)
		elseif direction == "right" then
			awful.tag.incmwfact(tiling_resize_factor)
		end
	end
end

awful.keyboard.append_global_keybindings({
	awful.key({ alt, shift }, "Tab", function()
		awful.client.focus.byidx(-1)
	end),
	awful.key({ alt }, "Tab", function()
		awful.client.focus.byidx(1)
	end),

	awful.key({
		modifiers = { super },
		keygroup = "hjkl",
		on_press = function(direction)
			awful.client.focus.global_bydirection(direction, nil, true)
		end,
	}),

	awful.key({
		modifiers = { super, shift },
		keygroup = "numrow",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { super, ctrl },
		keygroup = "numrow",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					local c = client.focus
					c:move_to_tag(tag)
					c:jump_to()
				end
			end
		end,
	}),
})

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({

		-- Move clients
        awful.key({
            modifiers = { super, shift },
            keygroup = "hjkl",
            on_press = move_client,
        }),

        awful.key({
            modifiers = { ctrl, alt },
            keygroup = "hjkl",
            on_press = resize_client,
        }),


		awful.key({ super, ctrl }, "h", function(c)
			local s = c.screen:get_next_in_direction("left")
			if s then
				c:move_to_screen(s)
			end
		end),
		awful.key({ super, ctrl }, "l", function(c)
			local s = c.screen:get_next_in_direction("right")
			if s then
				c:move_to_screen(s)
			end
		end),

		-- Fullscreen
		awful.key({ super }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),

		-- Floating
		awful.key({ super }, "g", function(c)
			c.floating = not c.floating
			c:raise()
		end),

		-- Maximization
		awful.key({ super }, "y", function(c)
			c.maximized = not c.maximized
			c:raise()
		end),

		awful.key({ super }, "t", function(c)
			c.ontop = not c.ontop
			c:raise()
		end),

		awful.key({ super }, "s", function(c)
			c.sticky = not c.sticky
			c:raise()
		end),

		-- Close clients
		awful.key({ super }, "q", function(c)
			if c.minimize_instead_of_kill then
				c.minimized = true
			else
				c:kill()
			end
		end),
		awful.key({ super, shift }, "q", function(c)
			awesome.kill(c.pid, 15)
		end),
	})
end)