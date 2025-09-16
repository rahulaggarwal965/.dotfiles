local awful = require("awful")
local ruled = require("ruled")

-- Table mapping website names to their corresponding app names
local website_to_app = {
	["teams.microsoft.com"] = "Microsoft Teams",
	["outlook.office.com"] = "Microsoft Outlook",
	["web.whatsapp.com"] = "Whatsapp",
}

-- Function to clean up message by removing website name and empty lines
local function clean_message(lines)
	-- Remove the first line (website name)
	table.remove(lines, 1)
	-- Remove any empty lines that follow
	while #lines > 0 and lines[1]:match("^%s*$") do
		table.remove(lines, 1)
	end
	-- Reconstruct message without website name
	return table.concat(lines, "\n")
end

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {
			app_name = "Brave",
		},
		callback = function(n)
			-- Check if message exists and has content
			if not n.message or n.message == "" then
				return
			end

			-- Split message into lines
			local lines = {}
			for line in n.message:gmatch("[^\r\n]+") do
				table.insert(lines, line)
			end

			-- If no lines, return early
			if #lines == 0 then
				return
			end

			-- Extract website name from first line
			local website_name = lines[1]:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace

			-- Check if website name matches our special cases
			local new_app_name = website_to_app[website_name]
			if new_app_name then
				-- Change app name to the mapped application
				n.app_name = new_app_name
				n.message = clean_message(lines)
			end
		end,
	})

	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)
