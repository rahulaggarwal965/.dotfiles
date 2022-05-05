local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("property::urgent", function(c)
    c:jump_to()
end)

client.connect_signal("property::floating", function(c)
    if c.floating and not c.maximized then
        c.shape = gears.shape.rectangle
    else
        c.shape = gears.shape.rectangle
    end
end)

client.connect_signal("property::fullscreen", function(c)
  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)
