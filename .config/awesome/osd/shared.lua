-- Shared OSD popup (singleton)

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local M = {}

local popup
local icon
local slider
local auto_hide_timer

local function ensure_popup()
	if popup then return popup end

	icon = wibox.widget({
		font   = beautiful.font,
		align  = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	slider = wibox.widget({
		bar_color        = (beautiful.fg_normal or "#FFFFFF") .. "33",
		handle_color     = beautiful.fg_focus or "#FFFFFF",
		handle_shape        = gears.shape.circle,
		bar_active_color = beautiful.fg_focus or "#FFFFFF",
		bar_height       = dpi(4),
		bar_width        = dpi(10),
		value            = 0,
		minimum          = 0,
		maximum          = 100,
		widget           = wibox.widget.slider,
	})

	popup = wibox({
		type    = "popup",
		screen  = awful.screen.focused(),
		height  = dpi(180),
		width   = dpi(55),
		shape   = gears.shape.rounded_rect,
		bg      = beautiful.bg_normal or "#000000AA",
		halign  = "center",
		valign  = "center",
		ontop   = true,
		visible = false,
	})

	awful.placement.right(popup, { margins = { right = (beautiful.useless_gap or 0) * 2 } })

	auto_hide_timer = gears.timer({
		autostart   = true,
		timeout     = 2.0,
		single_shot = true,
		callback    = function()
			popup.visible = false
		end,
	})

	popup:setup({
		{
			{
				slider,
				forced_height = dpi(100),
				forced_width  = dpi(5),
				direction     = "east",
				widget        = wibox.container.rotate,
			},
			margins = dpi(15),
			layout  = wibox.container.margin,
		},
		{
			icon,
			margins = { bottom = dpi(10) },
			widget  = wibox.container.margin,
		},
		spacing = dpi(10),
		layout  = wibox.layout.fixed.vertical,
	})

	return popup
end

local function show_popup()
	local p = ensure_popup()
	-- move to current screen before showing
	p.screen = awful.screen.focused()
	awful.placement.right(p, { margins = { right = (beautiful.useless_gap or 0) * 2 } })
	if p.visible then
		auto_hide_timer:again()
	else
		p.visible = true
		auto_hide_timer:start()
	end
end

-- Public API: show/update the OSD with common styling
-- args = { value:number(0..100), icon:string, muted:boolean(optional),
--          accent:string(optional), danger:string(optional) }
function M.show(args)
	ensure_popup()

	local value = math.max(0, math.min(100, tonumber(args.value or 0)))
	local muted = args.muted or false
	local accent = args.accent or (beautiful.fg_focus or "#FFFFFF")
	local danger = args.danger or (beautiful.fg_urgent or "#FF5555")

	icon.markup = string.format("<span>%s</span>", args.icon or "")
	slider.value = value

	if muted or value == 0 then
		slider.handle_color = danger
		slider.bar_active_color = danger
	else
		slider.handle_color = accent
		slider.bar_active_color = accent
	end

	show_popup()
end

return M

