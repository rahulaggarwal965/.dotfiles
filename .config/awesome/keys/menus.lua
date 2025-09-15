local awful = require("awful")
local modifiers = require("keys.modifiers")

local super = modifiers.super

local function keychord(chords)
	local g = awful.keygrabber({
		stop_key = "Escape",
		keypressed_callback = function(self, _, key)
			if chords[key] then
				chords[key]()
			end
			self:stop()
		end,
	})
	return function()
		g:start()
	end
end

awful.keyboard.append_global_keybindings({
	awful.key(
		{ super },
		"m",
		keychord({
			b = function()
				awful.spawn("rofi -show bluetooth -theme menu", false)
			end,
			t = function()
				awful.spawn("transmission-dmenu", false)
			end,
			e = function()
				awful.spawn("ebooks-dmenu", false)
			end,
			p = function()
				awful.spawn("power-dmenu", false)
			end,
		})
	),
})