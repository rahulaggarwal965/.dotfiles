local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local playerctl = require("lgi").require("Playerctl")

local M = {}
local meta = {}

M.instances = {}

local popup = awful.popup {
    widget = {
        widget = wibox.container.background,
        bg = "red",
        {
            widget = wibox.container.margin,
            margins = 10,
            forced_width = 300,
            forced_height = 100,
        }
    },
    visible = false,
    ontop = true,
    -- placement = function(obj, _)
    --     awful.placement.top_left(obj, { margin = { top = 30, left = 10 }, parent = awful.screen.focused() })
    -- end
}

function M.new()
    local textbox = wibox.widget {
        widget = wibox.widget.textbox,
        font = "SF Pro Display 9",
        markup = [[<span font = "Font Awesome 6 Free 9"></span>   ]] .. string.format("%s - <i>%s</i>", gears.string.xml_escape(M.artist), gears.string.xml_escape(M.title))
    }

    local widget = wibox.widget {
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        buttons = {
            awful.button({}, 1, function()
                awful.placement.top_left(popup, { margins = { top = 34, left = 10 }, parent = awful.screen.focused() })
                popup.visible = true
            end),
            awful.button({}, 2, function() M.player:play_pause() end),
            awful.button({}, 3, function() M.player:next() end)
        },
        {
            widget = wibox.container.margin,
            margins = { left = dpi(5), right = dpi(10) },
            textbox
        }
    }

    table.insert(M.instances, textbox)
    return widget
end


M.player = playerctl.Player.new("spotify")
-- startup
M.title = M.player:get_title() or ""
M.artist = M.player:get_artist() or ""
M.art_url = M.player:print_metadata_prop("mpris:artUrl") or ""
M.album = M.player:get_album() or ""

M.player.on_metadata = function (_, metadata)
    local data = metadata.value
    M.title = data["xesam:title"] or ""
    M.artist = data["xesam:artist"][1] or ""
    for i = 2, #data["xesam:artist"] do
        M.artist = M.artist .. ", " .. data["xesam:artist"][i]
    end
    M.art_url = data["mpris:artUrl"] or ""
    M.album = data["xesam:album"] or ""

    print(M.art_url)
    for _, instance in pairs(M.instances) do
        instance.markup = [[<span font = "Font Awesome 6 Free 9"></span>   ]] .. string.format("%s - <i>%s</i>", gears.string.xml_escape(M.artist), gears.string.xml_escape(M.title))
    end
end



function meta.__call(_, ...)
    return M.new(...)
end

return setmetatable(M, meta)
