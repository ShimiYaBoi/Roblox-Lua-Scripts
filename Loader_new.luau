local PlaceId = game.PlaceId

local base = "https://raw.githubusercontent.com/ShimiYaBoi/Roblox-Lua-Scripts/refs/heads/main/Scripts_new/"
local url = base .. tostring(PlaceId) .. ".luau"

local sucess, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if not sucess then
    warn("Failed to load script for "..PlaceId)
    warn(result)
end