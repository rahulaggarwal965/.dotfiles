local awful = require("awful")
local modifiers = require("keys.modifiers")

local super = modifiers.super
local alt = modifiers.alt

local terminal = os.getenv("TERMINAL")
local browser = os.getenv("BROWSER")

-- Find a client by its instance (WM_CLASS instance)
local function find_client_by_instance(instance)
	for _, c in ipairs(client.get()) do
		if c.instance ~= nil and c.instance:match(instance) then
			return c
		end
	end
	return nil
end

local function jump_to_or_spawn(instance, command)
	local c = find_client_by_instance(instance)
	if c then
		c:jump_to()
	else
		awful.spawn(command or instance)
	end
end

-- Move a client to current tag, unminimize it, and focus it
local function pop_up_or_spawn(instance, command)
	local t = awful.screen.focused().selected_tag
	local c = find_client_by_instance(instance)
	if t and c then
		c:move_to_tag(t)
		c.minimized = false
		c:activate({ raise = true })
	else
		awful.spawn(command or instance)
	end
end

awful.keyboard.append_global_keybindings({

	awful.key({ super }, "Return", function()
		awful.spawn(terminal, false)
	end),

	awful.key({ super, alt }, "b", function()
		awful.spawn(browser, false)
	end),
	awful.key({ super, alt }, "d", function()
		awful.spawn("discord", false)
	end),
	awful.key({ super, alt }, "l", function()
		awful.spawn("/usr/bin/slack", false)
	end),
	awful.key({ super, alt }, "o", function()
		pop_up_or_spawn("outlook.office.com__mail", "brave-browser --app=https://outlook.office.com/mail/")
	end),
	awful.key({ super, alt }, "t", function()
		pop_up_or_spawn("teams.microsoft.com", "brave-browser --app=https://teams.microsoft.com/")
	end),
	awful.key({ super, alt }, "n", function()
		jump_to_or_spawn("notion.so", "brave-browser --app=https://notion.so/")
	end),
	awful.key({ super, alt }, "w", function()
		pop_up_or_spawn("web.whatsapp.com", "brave-browser --app=https://web.whatsapp.com/")
	end),
	awful.key({ super, alt }, "s", function()
		jump_to_or_spawn("spotify")
	end),

	awful.key({ super, alt }, "h", function()
		awful.spawn(terminal .. " -e btop", false)
	end),
	awful.key({ super, alt }, "p", function()
		awful.spawn(terminal .. " -e pulsemixer", false)
	end),
})