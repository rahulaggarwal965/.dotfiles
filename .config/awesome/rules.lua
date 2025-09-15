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
            instance = "brave-browser",
            role  = "pop-up"
        },
        properties = { floating = true }
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

    ruled.client.append_rule {
        id = "minimize_instead_of_close",
        rule_any = {
            instance = {
                "web.whatsapp.com",
                "teams.microsoft.com",
                "outlook.office.com__mail",
            }
        },
        properties = {
            minimize_instead_of_kill = true,
            floating = true,
        }
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
