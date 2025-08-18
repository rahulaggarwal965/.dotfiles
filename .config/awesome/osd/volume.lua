-- volume OSD using shared singleton

local awful      = require("awful")
local shared_osd = require("osd.shared")

local function update_from_system()
	awful.spawn.easy_async_with_shell(
		[[bash -c 'vol=$(pulsemixer --get-volume); mute=$(pulsemixer --get-mute); echo "$vol"; echo "$mute"']],
		function(stdout)
			local vol_line, mute_line = stdout:match("([^\n]*)\n([^\n]*)")
			vol_line = vol_line or stdout
			mute_line = mute_line or "0"

			local left, right = (vol_line or ""):match("(%d+)%s+(%d+)")
			local volume_int = tonumber(left or vol_line) or 0
			local muted = (tonumber(mute_line) or 0) == 1

			shared_osd.show({
				value = volume_int,
				icon  = muted and "" or "",
				muted = muted,
			})
		end
	)
end

return { update = update_from_system }

