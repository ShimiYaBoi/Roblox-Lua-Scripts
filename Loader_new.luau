local PlaceId = game.PlaceId

local base = "https://raw.githubusercontent.com/ShimiYaBoi/Roblox-Lua-Scripts/refs/heads/main/Scripts_new/"
local url = base .. tostring(PlaceId) .. ".luau"

local success, source = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    warn("Failed to download script for PlaceId " .. PlaceId)
    warn("Error: " .. tostring(source))
    return
end

if not source or source == "" then
    warn("No script was found for PlaceId " .. PlaceId)
    return
end

local loadSuccess, script = pcall(function()
    return loadstring(source)
end)

if not loadSuccess then
    warn("Failed to compile script for PlaceId " .. PlaceId)
    warn("Error: " .. tostring(script))
    return
end

if not script then
    warn("loadstring returned nil for PlaceId " .. PlaceId)
    return
end

local runSuccess, result = pcall(function()
    return script()
end)

if not runSuccess then
    warn("Script crashed for PlaceId " .. PlaceId)
    warn("Error: " .. tostring(result))
    return
end

print("Successfully loaded script for PlaceId " .. PlaceId)
