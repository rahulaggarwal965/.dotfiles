local awful = require("awful")

local M = {}
local meta = {}

function M.new(args)
    local widget = awful.widget.taglist {
        screen  = args.screen,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    return widget
end

function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
