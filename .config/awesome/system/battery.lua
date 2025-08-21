local upower = require("lgi").require("UPowerGlib")

-- Battery signal module that emits battery state changes
local M = {}

-- Get the display device (usually the main battery)
local device = upower.Client():get_display_device()

-- Setup the notification handler
device.on_notify = function(dev)
    -- Emit signal with percentage and state
    -- States: 0=Unknown, 1=Charging, 2=Discharging, 3=Empty, 4=FullyCharged, 5=PendingCharge, 6=PendingDischarge
    awesome.emit_signal("signal::battery", math.floor(dev.percentage), dev.state)
end

-- Emit initial battery state
awesome.emit_signal("signal::battery", math.floor(device.percentage), device.state)

return M