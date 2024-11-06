local awful = require("awful")
local ruled = require("ruled")


ruled.client.connect_signal("request::rules", function()

    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        }
    }

    ruled.client.append_rule {
        rule = {
            class = "st-256color"
        },
        properties = { size_hints_honor = false }
    }

    ruled.client.append_rule {
        rule = {
            instance = "brave-browser",
            role  = "pop-up"
        },
        properties = { floating = true }
    }

    ruled.client.append_rule {
        rule = {
            class = "spotify" },
        properties = { screen = 1, tag = "1"}
    }

    ruled.client.append_rule {
        rule = {
            class = "discord"
        },
        properties = { screen = 1, tag = "2"}
    }

    ruled.client.append_rule {
        id = "drag_tab",
        rule = {
            class = "Brave-browser"
        },
        callback = function(c)
            if (mouse.is_left_mouse_button_pressed) then
                c.floating = true
            end
        end
    }

    -- ruled.client.append_rule {
    --     rule = {},
    --     properties = {
    --         titlebars_enabled = true
    --     }
    --    --  callback = function(c)
    --    --      if string.find(c.name, "565") then
    --    --          c.requests_titlebars = true
    --    --      end
    --    -- end
    -- }

end)
