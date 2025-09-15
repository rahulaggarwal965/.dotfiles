local awful = require("awful")
local naughty = require("naughty")

local M = {}

-- Configuration: Define command pairs for DND on/off
-- Each entry should have 'on' and 'off' commands
M.commands = {
    -- Slack commands
    {
        on = "slack-cli status edit focusing :dart:; slack-cli snooze start 1440",
        off = "slack-cli status clear; slack-cli snooze end"
    },
}

-- Function to execute commands for a given state
local function execute_commands(state)
    for _, command_pair in ipairs(M.commands) do
        local command = state and command_pair.on or command_pair.off
        if command then
            awful.spawn.with_shell(command)
        end
    end
end

M.toggle = function()
    naughty.suspended = not naughty.suspended
    awesome.emit_signal("system::dnd", naughty.suspended)

    execute_commands(naughty.suspended)
end

return M
