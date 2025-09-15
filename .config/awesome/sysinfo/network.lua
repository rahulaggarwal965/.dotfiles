-- luacheck: globals awesome
local lgi = require("lgi")
local NM = lgi.require("NM")
local GLib = lgi.GLib
local awesome_instance = rawget(_G, "awesome")

-- Event-driven Network monitor using NetworkManager (GI via lgi)
-- Emits: awesome.emit_signal("system::network", state_table)
-- state_table fields:
--   connected (bool)
--   primary_type ("wifi"|"ethernet"|nil)
--   interface (string|nil)
--   ssid (string|nil)
--   connection_name (string|nil)
--   signal (number 0-100|nil)
--   wifi_radio (bool|nil)
--   connections (array of { device, type, state, connection_name, ssid, signal, is_primary })
local M = {}

M._state = {
	connected = false,
	primary_type = nil,
	interface = nil,
	ssid = nil,
	connection_name = nil,
	signal = nil,
	wifi_radio = nil,
	connections = {}
}

local function ssid_to_string(ssid)
	if not ssid then return nil end
	-- Prefer NM utility if available (handles binary/encoding correctly)
	local ok, result = pcall(function()
		if NM.utils_ssid_to_utf8 then
			return NM.utils_ssid_to_utf8(ssid)
		end
		return nil
	end)
	if ok and result and result ~= "" then
		return result
	end
	-- Fallback: ssid may be an array of bytes
	if type(ssid) == "table" then
		local chars = {}
		for i = 1, #ssid do
			local b = ssid[i]
			if type(b) == "number" then
				chars[#chars + 1] = string.char(b)
			end
		end
		return table.concat(chars)
	end
	-- Last resort
	return tostring(ssid)
end

local function device_type_to_str(device)
	local dtype
	local ok, res = pcall(function() return device:get_device_type() end)
	if ok then dtype = res end
	if dtype == "ETHERNET" then return "ethernet" end
	if dtype == "WIFI" then return "wifi" end
	return nil
end

local function get_wifi_stats_for_device(device)
	local ssid, strength = nil, nil
	local ok, ap = pcall(function()
		return device:get_active_access_point()
	end)
	if ok and ap then
		local ok_ssid, raw_ssid = pcall(function() return ap:get_ssid() end)
		if ok_ssid then ssid = ssid_to_string(raw_ssid) end
		local ok_strength, s = pcall(function() return ap.strength or ap:get_strength() end)
		if ok_strength then strength = s end
	end
	return ssid, strength
end

local client

local function build_state()
	local new_state = {
		connected = false,
		primary_type = nil,
		interface = nil,
		ssid = nil,
		connection_name = nil,
		signal = nil,
		wifi_radio = nil,
		connections = {}
	}

	if not client then
		return new_state
	end

	-- wifi radio
	local ok_radio, radio = pcall(function()
		return (client.wireless_enabled ~= nil) and client.wireless_enabled or client:get_wireless_enabled()
	end)
	if ok_radio then
		new_state.wifi_radio = radio and true or false
	end

	local primary_ac
	local ok_primary, res_primary = pcall(function() return client:get_primary_connection() end)
	if ok_primary then primary_ac = res_primary end

	-- Collect active connections
	local active = {}
	local ok_active, ac_list = pcall(function() return client:get_active_connections() end)
	if ok_active and type(ac_list) == "table" then
		active = ac_list
	end

	local primary_dev_iface = nil
	if primary_ac then
		local ok_devs, devs = pcall(function() return primary_ac:get_devices() end)
		if ok_devs and type(devs) == "table" and #devs > 0 then
			local pdev = devs[1]
			local ok_iface, iface = pcall(function() return pdev:get_iface() end)
			if ok_iface then primary_dev_iface = iface end
		end
	end

	for _, ac in ipairs(active) do
		local ok_id, conn_name = pcall(function() return ac:get_id() end)
		local ok_devs, devs = pcall(function() return ac:get_devices() end)
		if ok_devs and type(devs) == "table" then
			for _, dev in ipairs(devs) do
				local d_iface = nil
				pcall(function() d_iface = dev:get_iface() end)
				local dtype = device_type_to_str(dev)
				local is_primary = (primary_dev_iface ~= nil and d_iface == primary_dev_iface) or false
				local ssid, strength = nil, nil
				if dtype == "wifi" then
					ssid, strength = get_wifi_stats_for_device(dev)
				end
				local entry = {
					device = d_iface or "",
					type = dtype,
					state = "connected",
					connection_name = ok_id and conn_name or nil,
					ssid = ssid,
					signal = strength,
					is_primary = is_primary
				}
				table.insert(new_state.connections, entry)
				if is_primary then
					new_state.connected = true
					new_state.primary_type = dtype
					new_state.interface = d_iface
					new_state.connection_name = ok_id and conn_name or nil
					new_state.ssid = ssid
					new_state.signal = strength
				end
			end
		end
	end

	-- If no explicit primary device found but there are active connections, pick the first
	if not new_state.connected and #new_state.connections > 0 then
		local first = new_state.connections[1]
		new_state.connected = true
		new_state.primary_type = first.type
		new_state.interface = first.device
		new_state.connection_name = first.connection_name
		new_state.ssid = first.ssid
		new_state.signal = first.signal
		-- also mark it as primary in list
		first.is_primary = true
	end

	return new_state
end

local function emit_network_info()
	local ok, new_state = pcall(build_state)
	if not ok then
		return
	end
	M._state = new_state
	if awesome_instance then
		awesome_instance.emit_signal("system::network", new_state)
	end
end

local function setup_watchers()
	if not client then return end

	client.on_notify = function(_, _)
		emit_network_info()
	end
	client.on_active_connection_added = function()
		emit_network_info()
	end
	client.on_active_connection_removed = function()
		emit_network_info()
	end
	client.on_device_added = function(_, _)
		emit_network_info()
	end
	client.on_device_removed = function(_, _)
		emit_network_info()
	end

	-- Periodic refresh to capture signal strength fluctuations
	GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 20, function()
		emit_network_info()
		return true -- repeat
	end)
end

function M.get_state()
	return M._state
end

-- Initialize
print("Initializing network monitor (NM)")
local ok_client, res_client = pcall(function() return NM.Client.new(nil) end)
if ok_client and res_client then
	client = res_client
	setup_watchers()
	emit_network_info()
else
	print("[sysinfo.network_nm] Failed to initialize NM.Client; NetworkManager GI may be unavailable")
end

return M

