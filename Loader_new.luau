local PlaceId = game.PlaceId

local base = "https://raw.githubusercontent.com/ShimiYaBoi/Roblox-Lua-Scripts/refs/heads/main/Scripts_new/"
local url = base .. tostring(PlaceId) .. ".luau"

local sucess, result = pcall(function()
    if not sucess then
        warn("Failed to load script for "..PlaceId)
        if result == nil then
            warn("No script was made for "..PlaceId)
        else
            warn(result)
        end
    end

    return loadstring(game:HttpGet(url))()
end)
