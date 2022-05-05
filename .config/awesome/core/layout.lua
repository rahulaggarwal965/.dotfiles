local gears = require("gears")
local awful = require("awful")

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.floating,
        awful.layout.suit.max
    })
end)

local tag_store = {}

-- Handle clients when a screen is removed
tag.connect_signal("request::screen", function(t)
    local fallback_tag

    for s in screen do
        if s ~= t.screen then
            fallback_tag = awful.tag.find_by_name(s, t.name)
            if fallback_tag then break end
        end
    end

    fallback_tag = fallback_tag or awful.tag.find_fallback()

    local output = next(t.screen.outputs)

    if not tag_store[output] then
        tag_store[output] = {}
    end

    local clients = t:clients()
    tag_store[output][t.name] = clients
    -- Don't keep references to killed clients by using a weak metatable
    setmetatable(tag_store[output][t.name], {__mode = "v"})

    for _, c in ipairs(clients) do
      c:move_to_tag(fallback_tag)
    end

end)

screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])

    -- clear out killed clients
    collectgarbage()

    local output = next(s.outputs)
    local original_tags = tag_store[output]
    if original_tags then
        for _, tag in ipairs(s.tags) do
            local clients = original_tags[tag.name]

            if clients then
                for _, client in ipairs(clients) do
                    client:move_to_tag(tag)
                end
            end
        end
    end
end)

client.connect_signal("focus", function(c)
    c:raise()
end)
