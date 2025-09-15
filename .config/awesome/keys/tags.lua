local awful = require("awful")
local modifiers = require("keys.modifiers")

local super = modifiers.super
local ctrl = modifiers.ctrl
local shift = modifiers.shift


awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { super },
		keygroup = "numrow",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),

	awful.key({ super, shift }, "Tab", function()
		local screen = awful.screen.focused()

		if screen.selected_tag then
			local c_index = screen.selected_tag.index
			local n_tags = #screen.tags

			for i = 2, n_tags, 1 do
				local t = screen.tags[(c_index - i) % n_tags + 1]
				if #t:clients() > 0 then
					t:view_only()
					return
				end
			end
		end
	end),

	awful.key({ super }, "Tab", function()
		local screen = awful.screen.focused()

		if screen.selected_tag then
			local c_index = screen.selected_tag.index
			local n_tags = #screen.tags

			for i = 0, n_tags - 2, 1 do
				local t = screen.tags[(c_index + i) % n_tags + 1]
				if #t:clients() > 0 then
					t:view_only()
					return
				end
			end
		end
	end),

	awful.key({ super }, "0", awful.tag.viewnone),
	awful.key({ super, ctrl }, "o", awful.tag.history.restore),

	awful.key({ super, shift }, "=", function()
		awful.layout.inc(1)
	end),
	awful.key({ super }, "-", function()
		awful.layout.inc(-1)
	end),
	awful.key({ super }, "[", function()
		awful.tag.incncol(-1)
	end),
	awful.key({ super }, "]", function()
		awful.tag.incncol(1)
	end),
	awful.key({ super, shift }, "[", function()
		awful.tag.incnmaster(-1)
	end),
	awful.key({ super, shift }, "]", function()
		awful.tag.incnmaster(1)
	end),
})
