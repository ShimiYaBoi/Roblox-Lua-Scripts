--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

-------> +1 Speed Evolve / https://www.roblox.com/games/83569851223739/1-Speed-Evolve

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local RS = game:GetService("ReplicatedStorage")
local Events = game:GetService("ReplicatedStorage").Modules.Shared.RemoteEventService
local WinsLocation = workspace.Wins
local wins = {}
local hum = char.Humanoid
local humrootpart = char.HumanoidRootPart
local Helper = require(RS.Modules.WorldSpecific.Helper)
local EvolutionData = require(RS.Modules.Shared.EvolutionData)

local currentwinsfrom = nil
local selectedWin = nil

for i, v in ipairs(workspace.Wins:GetChildren()) do
    if v:IsA("Model") then
        table.insert(wins, v.Name)
    end
end

table.sort(wins, function(a, b)
    return tonumber(a) < tonumber(b)
end)

getgenv().Autospeed = false;
getgenv().AutoEvolve = false;
getgenv().AutoRebirth = false;
getgenv().AutoWin = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function AutoSpeedFunc()
    spawn(function()
        while getgenv().Autospeed == true do wait(0.1)
            Events.AddSpeedRemoteEvent:FireServer()
        end
    end)
end

function AutoEvolveFunc()
    spawn(function()
        while getgenv().AutoEvolve == true do wait(0.1)
            local plrwins = tonumber(plr.leaderstats.Wins.Value)
            local PlrLevel = plr.PlayerStats.Level.Value
            local currentEvolution = plr.PlayerStats.EvolutionSelected.Value
            local nextEvolution = EvolutionData.GetNextEvolution(currentEvolution)
            local nextData = EvolutionData.Evolutions[nextEvolution]


            if nextData.Level <= PlrLevel and nextData.WinsCost <= plrwins then 
                Events.EvolutionRemoteEvent:FireServer({Action = "Evolve"})
                task.wait(0.5)
            else
                task.wait(0.1)
            end
        end
    end)
end

function AutoRebirthFunc()
    spawn(function()
        while getgenv().AutoRebirth == true do
            local rebirths = plr.leaderstats.Rebirths.Value
            local requiredLevel = Helper.GetRebirthLevelRequired(rebirths)
            local PlrLevel = plr.PlayerStats.Level.Value
            if requiredLevel <= PlrLevel then
                Events.RebirthRemoteEvent:FireServer()
                task.wait(0.5)
            else
                task.wait(0.1)
            end
        end
    end)
end

function TeleportToWin(num)
    if num then
        local button = WinsLocation:FindFirstChild(num)
        if button then
            char:PivotTo(button:GetPivot())
        end
    end
end

--[[
 __        ________   _______   ______    ________   ______    __  __    
/_/\      /_______/\/_______/\ /_____/\  /_______/\ /_____/\  /_/\/_/\   
\:\ \     \__.::._\/\::: _  \ \\:::_ \ \ \::: _  \ \\:::_ \ \ \ \ \ \ \  
 \:\ \       \::\ \  \::(_)  \/_\:(_) ) )_\::(_)  \ \\:(_) ) )_\:\_\ \ \ 
  \:\ \____  _\::\ \__\::  _  \ \\: __ `\ \\:: __  \ \\: __ `\ \\::::_\/ 
   \:\/___/\/__\::\__/\\::(_)  \ \\ \ `\ \ \\:.\ \  \ \\ \ `\ \ \ \::\ \ 
    \_____\/\________\/ \_______\/ \_\/ \_\/ \__\/\__\/ \_\/ \_\/  \__\/ 
                                                                         
 ]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Speed Per Evolution",
    Icon = "paw-print", -- lucide icon. optional
    Author = "by shimixd", -- optional
})

WindUI:Notify({
    Title = "Loaded!",
    Content = "Made with WindUI By .ftgs",
    Duration = 10, -- 3 seconds
    Icon = "heart-handshake",
})

Window:EditOpenButton({
    Title = "Open Menu",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local AutoFarm = Window:Tab({
    Title = "Auto Farm",
    Icon = "bird", -- optional
    Locked = false,
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Speed",
    Desc = "Automatically Adds Speed",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().Autospeed = state;
        AutoSpeedFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Evolve",
    Desc = "Automatically Evolves",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoEvolve = state;
        AutoEvolveFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Rebirth",
    Desc = "Automatically Rebirths",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoRebirth = state;
        AutoRebirthFunc()
    end
})

local Dropdown = AutoFarm:Dropdown({
    Title = "World Wins",
    Desc = "Select Which world take wins from",
    Values = wins,
    --Value = 1,
    Callback = function(option) 
        selectedWin = option
    end
})

local Button = AutoFarm:Button({
    Title = "Get Win",
    Desc = "Teleporting To The Win Button",
    Locked = false,
    Callback = function()
        if selectedWin then
            TeleportToWin(selectedWin)
        else
            WindUI:Notify({
            Title = "Selection Not Found",
            Content = "Please Select Win World",
            Duration = 5, -- 3 seconds
            Icon = "octagon-x",
            })
        end
    end
})

local Button = AutoFarm:Button({
    Title = "No 'Gameplay Loading' Screen",
    Desc = "Remove 'Gameplay Loading Screen'",
    Locked = false,
    Callback = function()
        local GamePlayeScreen = game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]
        if GamePlayeScreen then
            GamePlayeScreen:Destroy()
        else
            WindUI:Notify({
                Title = "'Gameplay Loading' Screen Not Found",
                Content = "Loading Screen not found. Might be Destroyed",
                Duration = 5,
                Icon = "monitor-off"
            })
        end
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Win",
    Desc = "Automatically Wins ",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoWin = state;
        if selectedWin then
            spawn(function()
                while AutoWin == true do
                    if not char then
                        task.wait(0.1)
                    else
                        TeleportToWin(selectedWin)
                        task.wait(1)
                    end
                end
            end)
        else
            WindUI:Notify({
            Title = "Selection Not Found",
            Content = "Please Select Win World",
            Duration = 5, -- 3 seconds
            Icon = "octagon-x",
            })
        end
    end
})

local PlayerWindow = Window:Tab({
    Title = "Player",
    Icon = "user-cog", -- optional
    Locked = false,
})

local Slider = PlayerWindow:Slider({
    Title = "Speed",
    Desc = "Set Your Walk Speed",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 999,
        Default = 16,
    },
    Callback = function(value)
        hum.WalkSpeed = value
    end
})

local Slider = PlayerWindow:Slider({
    Title = "Jump",
    Desc = "Set Your Jump Power",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 9999,
        Default = 50,
    },
    Callback = function(value)
        hum.JumpPower = value
    end
})

local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings", -- optional
    Locked = false,
})

local Keybind = Settings:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})