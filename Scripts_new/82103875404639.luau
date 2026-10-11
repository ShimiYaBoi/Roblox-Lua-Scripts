------------ Tap Incremental | https://www.roblox.com/games/82103875404639/Tap-Incremental

local ws = workspace;
local Players = game:GetService("Players");
local RStorage = game:GetService("ReplicatedStorage")
local Remotes = RStorage:FindFirstChild("Remotes")
local plr = Players.LocalPlayer;
local char, hum, hrp;
local debug = true;
local env = getgenv()

local Running = {

}

local function updateCharacter(character)
    char = character
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
end

if plr.Character then
    updateCharacter(plr.Character)
end

plr.CharacterAdded:Connect(function(character)
    updateCharacter(character)

    if debug then
        print("[Debug] Character respawned - Refrences updated")
    end
end)

local function getCharacter()
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getHRP()
    local character = getCharacter()
    return character:WaitForChild("HumanoidRootPart")
end
