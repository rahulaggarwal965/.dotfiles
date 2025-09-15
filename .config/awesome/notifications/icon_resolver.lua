local menubar = require("menubar")

local M = {}

-- Common app name to icon name mappings
M.icon_mappings = {
    ["Brave"] = "brave-browser",
}

-- Generate common variants of an app name for icon lookup
local function generate_variants(app_name)
    local lower = app_name:lower()
    return {
        lower .. "-client",
        lower .. "-desktop",
        lower:gsub(" ", "-"),
        lower:gsub(" ", "_"),
        lower:gsub(" ", ""),
    }
end

-- Resolve app icon from app name
function M.resolve_app_icon(app_name)
    -- Use pcall to catch any errors and return nil
    local success, result = pcall(function()
        if not app_name then return nil end

        -- Try exact mapping first
        local mapped_name = M.icon_mappings[app_name]
        if mapped_name then
            local path = menubar.utils.lookup_icon(mapped_name)
            if path then return path end
        end

        -- Try original app name
        local path = menubar.utils.lookup_icon(app_name)
            or menubar.utils.lookup_icon(app_name:lower())
        if path then return path end

        -- Try with common suffixes/prefixes
        local variants = generate_variants(app_name)
        for _, variant in ipairs(variants) do
            path = menubar.utils.lookup_icon(variant)
            if path then return path end
        end

        return nil
    end)
    
    -- Return the result if successful, nil if there was an error
    return success and result or nil
end

return M