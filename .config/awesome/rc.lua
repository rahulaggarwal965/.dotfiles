-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

require("core.keys")
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(require("theme"))

-- This is used later as the default terminal and editor to run.
terminal = os.getenv("TERMINAL")
browser  = os.getenv("BROWSER")
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
local hide = function (o)
    -- naughty.notify({ title = "hide triggered"})
    -- print("launcher ==== " .. tostring(mylauncher))
    -- print("object ===== " .. tostring(o.widget))
    if o ~= mymainmenu.wibox then
        mymainmenu:hide()
    end
end

mymainmenu.wibox:connect_signal("property::visible", function (w)


    if w.visible then
        wibox.connect_signal("button::press", hide)
        client.connect_signal("button::press", hide)
        awful.mouse.append_global_mousebinding(awful.button({}, 1, hide))
    else
        wibox.disconnect_signal("button::press", hide)
        client.disconnect_signal("button::press", hide)
        awful.mouse.remove_global_mousebinding(awful.button({}, 1, hide))
    end
end)
--
-- mymainmenu.wibox:connect_signal("mouse::enter", function ()
--     naughty.notify({ title = "entered menu" })
-- end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
require("core.layout")
-- }}}

-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%a, %b %d   %I:%M %p")

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height   = 32,
        widget   = {
            layout = wibox.layout.align.horizontal,
            expand = "outside",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            {
                layout = wibox.container.place,
                halign = "center",
                mytextclock,
            },
            nil
        }
    }
end)
-- }}}

-- {{{ Key bindings

-- Focus related keybindings
-- awful.keyboard.append_global_keybindings({
--     awful.key({ modkey,           }, "j",
--         function ()
--             awful.client.focus.byidx( 1)
--         end,
--         {description = "focus next by index", group = "client"}
--     ),
--     awful.key({ modkey,           }, "k",
--         function ()
--             awful.client.focus.byidx(-1)
--         end,
--         {description = "focus previous by index", group = "client"}
--     ),
--     awful.key({ modkey,           }, "Tab",
--         function ()
--             awful.client.focus.history.previous()
--             if client.focus then
--                 client.focus:raise()
--             end
--         end,
--         {description = "go back", group = "client"}),
--     awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
--               {description = "focus the next screen", group = "screen"}),
--     awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
--               {description = "focus the previous screen", group = "screen"}),
--     awful.key({ modkey, "Control" }, "n",
--               function ()
--                   local c = awful.client.restore()
--                   -- Focus restored client
--                   if c then
--                     c:activate { raise = true, context = "key.unminimize" }
--                   end
--               end,
--               {description = "restore minimized", group = "client"}),
-- })

-- Layout related keybindings
-- awful.keyboard.append_global_keybindings({
--     awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
--               {description = "swap with next client by index", group = "client"}),
--     awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
--               {description = "swap with previous client by index", group = "client"}),
--     awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
--               {description = "jump to urgent client", group = "client"}),
--     awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
--               {description = "increase master width factor", group = "layout"}),
--     awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
--               {description = "decrease master width factor", group = "layout"}),
--     awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--               {description = "increase the number of master clients", group = "layout"}),
--     awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--               {description = "decrease the number of master clients", group = "layout"}),
--     awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--               {description = "increase the number of columns", group = "layout"}),
--     awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--               {description = "decrease the number of columns", group = "layout"}),
--     awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
--               {description = "select next", group = "layout"}),
--     awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
--               {description = "select previous", group = "layout"}),
-- })

-- }}}


require("core.rules")
-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

require("core.signals")
