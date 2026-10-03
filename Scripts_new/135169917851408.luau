--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

-------> Merge Hackers / https://www.roblox.com/games/135169917851408/Merge-Hackers

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local hrp = char.HumanoidRootPart
local RS = game:GetService("ReplicatedStorage")
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local plotModule = require(game:GetService("ReplicatedStorage").Shared.PlotPresence)
local plots = ws:WaitForChild("Plots")
local myPlot = plots:FindFirstChild(tostring(plotModule.MyPlot()))
local buyCount

getgenv().AutoCollect = false;
getgenv().AutoConvert = false;
getgenv().AutoCollectCash = false;
getgenv().AutoUpgradeConvert = false;
getgenv().AutoBuyNoobs = false;
getgenv().AutoMerge = false;
getgenv().AutoUpgradeNoobs = false;
getgenv().AutoClaimIndex = false;
getgenv().AutoRebirth = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function CollectFunc()
    task.spawn(function()
        while getgenv().AutoCollect == true do
            for _, v in ipairs(myPlot.Cards:GetChildren()) do
                if v and v.PrimaryPart then
                    v.PrimaryPart.Position = hrp.Position
                    task.wait(0.1)
                end
            end
            task.wait(0.1)
        end
    end)
end

function ConvertFunc()
    task.spawn(function()
        while getgenv().AutoConvert == true do
            firetouchinterest(myPlot.Buttons.ConvertButton.TouchPart, hrp, false)
            task.wait(0.1)
            firetouchinterest(myPlot.Buttons.ConvertButton.TouchPart, hrp, true)
        end
    end)
end

function CollectCashFunc()
    task.spawn(function()
        while getgenv().AutoCollectCash == true do
            firetouchinterest(myPlot.Buttons.CollectButton.TouchPart, hrp, false)
            task.wait(0.1)
            firetouchinterest(myPlot.Buttons.CollectButton.TouchPart, hrp, true)
        end
    end)
end

function UpgradeConvertFunc()
    task.spawn(function()
        while getgenv().AutoUpgradeConvert == true do
            firetouchinterest(myPlot.Buttons.Upgrade1.TouchPart, hrp, false)
            task.wait(0.1)
            firetouchinterest(myPlot.Buttons.Upgrade1.TouchPart, hrp, true)
        end
    end)
end

function BuyNoobsFunc()
    task.spawn(function()
        while getgenv().AutoBuyNoobs == true do
            if buyCount == 1 then
                firetouchinterest(myPlot.Buttons.Button1.TouchPart, hrp, false)
                task.wait(0.1)
                firetouchinterest(myPlot.Buttons.Button1.TouchPart, hrp, true)
            elseif buyCount == 5 then
                firetouchinterest(myPlot.Buttons.Button2.TouchPart, hrp, false)
                task.wait(0.1)
                firetouchinterest(myPlot.Buttons.Button2.TouchPart, hrp, true)
            elseif buyCount == 25 then
                firetouchinterest(myPlot.Buttons.Button3.TouchPart, hrp, false)
                task.wait(0.1)
                firetouchinterest(myPlot.Buttons.Button3.TouchPart, hrp, true)
            elseif buyCount == 100 then
                firetouchinterest(myPlot.Buttons.Button4.TouchPart, hrp, false)
                task.wait(0.1)
                firetouchinterest(myPlot.Buttons.Button4.TouchPart, hrp, true)
            end
        end
    end)
end

function MergeFunc()
    task.spawn(function()
        while getgenv().AutoUpgradeConvert == true do
            firetouchinterest(myPlot.Buttons.MergeButton.TouchPart, hrp, false)
            task.wait(0.1)
            firetouchinterest(myPlot.Buttons.MergeButton.TouchPart, hrp, true)
        end
    end)
end

function UpgradeNoobsFunc()
    task.spawn(function()
        while getgenv().AutoUpgradeConvert == true do
            firetouchinterest(myPlot.Buttons.Upgrade2.TouchPart, hrp, false)
            task.wait(0.1)
            firetouchinterest(myPlot.Buttons.Upgrade2.TouchPart, hrp, true)
        end
    end)
end

function ClaimIndexFunc()
    task.spawn(function()
        while getgenv().AutoClaimIndex == true do
            local Event = game:GetService("ReplicatedStorage").Remotes.Milestones
            Event:FireServer("all")
            task.wait(1)
        end
    end)
end

function RebirthFunc()
    task.spawn(function()
        while getgenv().AutoRebirth == true do
            local Event = game:GetService("ReplicatedStorage").Remotes.Rebirth
            Event:FireServer(true)
            task.wait(1)
        end
    end)
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

local Window = WindUI:CreateWindow({
    Title = "Merge Hackers",
    Icon = "monitor-dot", -- lucide icon. optional
    Author = "by shimixd", -- optional
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
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

local AutoFarm = Window:Tab({
    Title = "Auto Farm",
    Icon = "hand-coins", -- optional
    Locked = false,
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically Collect Cards",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoCollect = state;
        CollectFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Convert",
    Desc = "Automatically Convert Cards",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoConvert = state;
        ConvertFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Collect Cash",
    Desc = "Automatically Collects Cash",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoCollectCash = state;
        CollectCashFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Upgrade Convert",
    Desc = "Automatically Upgrades Convert Speed",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoUpgradeConvert = state;
        UpgradeConvertFunc()
    end
})

local Dropdown = AutoFarm:Dropdown({
    Title = "Noobs to buy",
    Desc = "How much to buy",
    Values = {"1", "5", "25", "100"},
    Value = "1",
    Callback = function(option) 
        buyCount = tonumber(option)
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Noobs",
    Desc = "Automatically Buys Noobs",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoBuyNoobs = state;
        BuyNoobsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Merge",
    Desc = "Automatically Merges",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoMerge = state;
        MergeFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Upgrade Noobs tier",
    Desc = "Automatically Upgrades Noob tiers",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoUpgradeNoobs = state;
        UpgradeNoobsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Claim Index",
    Desc = "Automatically Claims Index",
    Icon = "check",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        getgenv().AutoClaimIndex = state;
        ClaimIndexFunc()
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
        RebirthFunc()
    end
})

local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false,
})

local Keybind = Settings:Keybind({
    Title = "Toggle Menu",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})