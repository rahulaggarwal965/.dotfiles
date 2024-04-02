local awful = require("awful")
local beautiful = require("beautiful")

local super = "Mod4"
local alt   = "Mod1"
local ctrl  = "Control"
local shift = "Shift"

local terminal = os.getenv("TERMINAL")
local browser = os.getenv("BROWSER")

awful.keyboard.append_global_keybindings({
    awful.key({super, shift}, "Escape", awesome.quit),
    awful.key({super, shift}, "w", awesome.restart),

    awful.key({super, shift}, "Tab", function()
        local screen = awful.screen.focused()

        if (screen.selected_tag) then
            local c_index = screen.selected_tag.index
            local n_tags = #screen.tags

            for i = 2, n_tags, 1 do
                local t = screen.tags[(c_index - i) % n_tags + 1]
                if #t:clients() > 0 then
                    t:view_only()
                    return
                end
            end
        end
    end),
    awful.key({super}, "Tab", function()
        local screen = awful.screen.focused()

        if (screen.selected_tag) then
            local c_index = screen.selected_tag.index
            local n_tags = #screen.tags

            for i = 0, n_tags - 2, 1 do
                local t = screen.tags[(c_index + i) % n_tags + 1]
                if #t:clients() > 0 then
                    t:view_only()
                    return
                end
            end
        end
    end),

    awful.key({super}, "0", awful.tag.viewnone),

    awful.key({alt, shift}, "Tab", function() awful.client.focus.byidx(-1) end),
    awful.key({alt}, "Tab", function() awful.client.focus.byidx(1) end),

    awful.key({super}, "h", function() awful.client.focus.global_bydirection("left",  nil, true) end),
    awful.key({super}, "j", function() awful.client.focus.global_bydirection("down",  nil, true) end),
    awful.key({super}, "k", function() awful.client.focus.global_bydirection("up",    nil, true) end),
    awful.key({super}, "l", function() awful.client.focus.global_bydirection("right", nil, true) end),

    awful.key({super, ctrl}, "o", awful.tag.history.restore),

    awful.key({super, shift}, "=", function() awful.layout.inc(1)  end),
    awful.key({super}, "-", function() awful.layout.inc(-1) end),

    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("light -U 2", false) end),
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("light -A 2", false) end),

    awful.key({super}, "XF86MonBrightnessDown", function()
        awful.spawn.with_shell("light -O && light -S 0") end),
    awful.key({super}, "XF86MonBrightnessUp", function()
        awful.spawn.with_shell("light -I") end),

    awful.key({}, "XF86AudioMute", function()
        awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false) end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ -3%") end),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ +3%") end),

    awful.key({}, "XF86AudioPlay", function()
        awful.spawn("playerctl -p spotify play-pause", false) end),
    awful.key({}, "XF86AudioPrev", function()
        awful.spawn("playerctl -p spotify previous", false) end),
    awful.key({}, "XF86AudioNext", function()
        awful.spawn("playerctl -p spotify next", false) end),

    awful.key({}, "Print", function() awful.spawn("screenshot full", false) end),
    awful.key({shift}, "Print", function() awful.spawn("screenshot select", false) end),
    awful.key({super, shift}, "s", function() awful.spawn("screenshot select", false) end),

    awful.key({super, shift}, "n", function() awful.spawn("betterlockscreen -l", false) end),

    awful.key({super}, "space", nil, function() awful.spawn("rofi -show drun -theme launcher -show-icons", false) end),

    awful.key({super}, "Return", function() awful.spawn(terminal, false) end),

    awful.key({super, alt}, "b", function() awful.spawn(browser, false) end),
    awful.key({super, alt}, "d", function() awful.spawn("discord", false) end),
    awful.key({super, alt}, "l", function() awful.spawn("slack", false) end),
    awful.key({super, alt}, "s", function()
        for _, c in ipairs(client.get()) do
            if c.instance:match("spotify") then
                c:jump_to()
                return
            end
        end
        awful.spawn("spotify")
    end),

    awful.key({super, alt}, "h", function() awful.spawn(terminal.. " -e btop", false) end),
    awful.key({super, alt}, "p", function() awful.spawn(terminal.. " -e pulsemixer", false) end)
})

awful.keyboard.append_global_keybindings({
    awful.key({
        modifiers = {super},
        keygroup = "numrow",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end
    }),
    awful.key({
        modifiers = {super, shift},
        keygroup = "numrow",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end
    }),
    awful.key({
        modifiers = {super, ctrl},
        keygroup = "numrow",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    local c = client.focus
                    c:move_to_tag(tag)
                    c:jump_to()
                end
            end
        end
    })
})

local function keychord(chords)
    local g = awful.keygrabber {
        stop_key = "Escape",
        keypressed_callback = function(self, _, key)
            if chords[key] then
                chords[key]()
            end
            self:stop()
        end,
    }
    return function() g:start() end
end

awful.keyboard.append_global_keybindings({
    awful.key({super}, "m", keychord {
        b = function() awful.spawn("rofi -show bluetooth -theme menu", false) end,
        t = function() awful.spawn("transmission-dmenu", false) end,
        e = function() awful.spawn("ebooks-dmenu", false) end,
        p = function() awful.spawn("power-dmenu", false) end,
    })
})

local direction_translate = {
    ["left"]  = "left",
    ["down"]  = "bottom",
    ["up"]    = "top",
    ["right"] = "right",
}

local function move_client(c, direction)
    if c.floating or awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        local old = c:geometry()
        local new = awful.placement[direction_translate[direction]](c, {honor_padding = true, honor_workarea = true, margins = 0, pretend = true})
        if direction == "up" or direction == "down" then
            c:geometry({x = old.x, y = new.y})
        else
            c:geometry({x = new.x, y = old.y})
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end

local floating_resize_amount = beautiful.xresources.apply_dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if c.floating or awful.layout.get(mouse.screen) == awful.layout.suit.floating then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({

        -- Move clients
        awful.key({super, shift}, "h", function(c)
            move_client(c, "left")
        end),
        awful.key({super, shift}, "j", function(c)
            move_client(c, "down")
        end),
        awful.key({super, shift}, "k", function(c)
            move_client(c, "up")
        end),
        awful.key({super, shift}, "l", function(c)
            move_client(c, "right")
        end),

        awful.key({ctrl, alt}, "h", function(c)
            resize_client(c, "left")
        end),
        awful.key({ctrl, alt}, "j", function(c)
            resize_client(c, "down")
        end),
        awful.key({ctrl, alt}, "k", function(c)
            resize_client(c, "up")
        end),
        awful.key({ctrl, alt}, "l", function(c)
            resize_client(c, "right")
        end),

        awful.key({super, ctrl}, "h", function(c)
            local s = c.screen:get_next_in_direction("left")
            if s then
                c:move_to_screen(s)
            end
        end),
        awful.key({super, ctrl}, "l", function(c)
            local s = c.screen:get_next_in_direction("right")
            if s then
                c:move_to_screen(s)
            end
        end),

        -- Fullscreen
        awful.key({super}, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),

        -- Floating
        awful.key({super}, "g", function(c)
            c.floating = not c.floating
            c:raise()
        end),

        -- Close clients
        awful.key({super}, "q", function(c) c:kill() end),
        awful.key({super, shift}, "q", function(c) awesome.kill(c.pid, 15) end),
    })
end)

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            if (c.floating) then
                local m = mouse.coords()
                if (math.abs(m.x - c.x) <= 10 or math.abs(m.y - c.y) <= 10 or
                    math.abs(m.x - c.x - c.width) <= 10 or math.abs(m.y - c.y - c.height) <= 10) then
                    c:activate({context = "mouse_click", action = "mouse_resize"})
                end
            end
            c:activate({context = "mouse_click"})
        end),
        awful.button({super}, 1, function(c)
            c:activate({context = "mouse_click", action = "mouse_move"})
        end),
        awful.button({super}, 3, function(c)
            c:activate({context = "mouse_click", action = "mouse_resize"})
        end)
    })
end)


