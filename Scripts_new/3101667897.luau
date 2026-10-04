------------> Legends Of Speed / https://www.roblox.com/games/3101667897/Legends-Of-Speed

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local RS = game:GetService("ReplicatedStorage")
local Events = RS.rEvents
local maps = {}
local plrCurrentMap = plr.currentMap
local env = getgenv()

env.AutoRebirth = false;
env.AutoCollectOrbs = false;