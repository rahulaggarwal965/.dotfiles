local awful = require("awful")
local modifiers = require("keys.modifiers")

local volume_osd = require("osd.volume")
local brightness_osd = require("osd.brightness")

local super = modifiers.super
local shift = modifiers.shift

awful.keyboard.append_global_keybindings({
	awful.key({ super, shift }, "Escape", awesome.quit),
	awful.key({ super, shift }, "w", awesome.restart),

	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("light -U 2", false)
		brightness_osd.update()
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("light -A 2", false)
		brightness_osd.update()
	end),

	awful.key({ super }, "XF86MonBrightnessDown", function()
		awful.spawn.with_shell("light -O && light -S 0")
		brightness_osd.update()
	end),
	awful.key({ super }, "XF86MonBrightnessUp", function()
		awful.spawn.with_shell("light -I")
		brightness_osd.update()
	end),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
		volume_osd.update()
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ -3%")
		volume_osd.update()
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ +3%")
		volume_osd.update()
	end),

	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl -p spotify play-pause", false)
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn("playerctl -p spotify previous", false)
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.spawn("playerctl -p spotify next", false)
	end),

	awful.key({}, "Print", function()
		awful.spawn("screenshot full", false)
	end),
	awful.key({ shift }, "Print", function()
		awful.spawn("screenshot select", false)
	end),
	awful.key({ super, shift }, "s", function()
		awful.spawn("screenshot select", false)
	end),
	awful.key({ super, shift }, "r", function()
		-- Check if screenrecord is running
		awful.spawn.easy_async("pgrep -f 'ffmpeg -f x11grab'", function(stdout, stderr, exitreason, exitcode)
			if exitcode == 0 and stdout ~= "" then
				-- screenrecord is running, stop it with SIGINT (signal 2)
				local pid = tonumber(stdout:match("(%d+)"))
				if pid then
					awful.spawn("kill -2 " .. pid, false)
				end
			else
				-- screenrecord is not running, start it
				awful.spawn("screenrecord select", false)
			end
		end)
	end),

	awful.key({ super, shift }, "n", function()
		awful.spawn([[betterlockscreen -l -- --custom-key-commands \
        --cmd-media-play "playerctl -p spotify play-pause" \
        --cmd-media-prev "playerctl -p spotify previous" \
        --cmd-media-next "playerctl -p spotify next" \
        --cmd-audio-mute "pactl set-sink-mute @DEFAULT_SINK@ toggle" \
        --cmd-volume-down "pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ -3%" \
        --cmd-volume-up "pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ +3%" \
        --cmd-brightness-down "light -U 2" \
        --cmd-brightness-up "light -A 2"]])
	end),

	awful.key({ super, shift }, "d", function()
		require("sysinfo.dnd").toggle()
	end),

	awful.key({ super }, "space", nil, function()
		awful.spawn("rofi -show drun -theme launcher -show-icons", false)
	end),
})
