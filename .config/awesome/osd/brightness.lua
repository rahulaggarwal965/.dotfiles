-- brightness OSD using shared singleton

local awful      = require("awful")
local shared_osd = require("osd.shared")

local function update_from_system()
	awful.spawn.easy_async_with_shell(
		[[bash -c 'val=$(light -G 2>/dev/null || echo 0); printf "%.0f\n" "$val"']],
		function(stdout)
			local value = tonumber(stdout) or 0
			value = math.max(0, math.min(100, value))
			shared_osd.show({
				value = value,
				icon  = "",
			})
		end
	)
end

return { update = update_from_system }

