--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:FindFirstChild("Paper").Remotes
local chickenCount = nil


getgenv().AutoCollectEggs = false;
getgenv().AutoBuyChickens = false;
getgenv().AutoCollectMoney = false;
getgenv().AutoDepositEggs = false;
getgenv().AutoObby = false;
getgenv().AutoUpgrade = false;
getgenv().AutoMerge = false;
getgenv().AutoRebirth = false;
getgenv().AutoTiers = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function AutoCollectEggsFunc()
    while getgenv().AutoCollectEggs == true do
        for _, v in ipairs(ws:FindFirstChild("Eggs"):GetChildren()) do
            if not v then continue end
            if v:IsA("Model") then
                local Event = Remotes.__remoteevent
                v.PrimaryPart.Position = char:FindFirstChild("HumanoidRootPart").Position
                Event:FireServer("Collect Egg", v.Name)
                v:Destroy()
                task.wait(0.1)
            end
        end
        task.wait(0.1)
    end
end

function DepositEggsFunc()
    spawn(function()
        while getgenv().AutoDepositEggs == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Deposit Eggs")
            task.wait(1)
        end
    end)
end

function CollectMoneyFunc()
    spawn(function()
        while getgenv().AutoCollectMoney == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Collect Cash")
            task.wait(0.1)
        end
    end)
end

function AutoObbyFunc()
    spawn(function()
        while getgenv().AutoObby == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Claim Obby")
            task.wait(10)
        end
    end)
end

function AutoTiersFunc()
    spawn(function()
        while getgenv().AutoTiers == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Upgrade Buy Tier Level")
            task.wait(1)
        end
    end)
end

function AutoMergeFunc()
    spawn(function()
        while getgenv().AutoMerge == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Merge Chickens")
        end
    end)
end

function AutoBuyChickensFunc(c)
    while getgenv().AutoBuyChickens == true do
        local Event = Remotes.__remotefunction
        Event:InvokeServer("Buy Chickens", c)
    end
end

function AutoUpgradeFunc()
    spawn(function()
        while getgenv().AutoUpgrade == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Upgrade Process Level")
        end
    end)
end

function AutoRebirthFunc()
    spawn(function()
        while getgenv().AutoRebirth == true do
            local Event = Remotes.__remotefunction
            Event:InvokeServer("Rebirth")
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

 local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

 local Window = WindUI:CreateWindow({
    Title = "Chicken Farm",
    Icon = "egg", -- lucide icon. optional
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
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local AutoFarm = Window:Tab({
    Title = "Auto Farm",
    Icon = "drumstick", -- optional
    Locked = false,
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Collect Eggs",
    Desc = "Automatically Collect eggs",
    Icon = "egg",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoCollectEggs = state
        AutoCollectEggsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Upgrade",
    Desc = "Automatically Upgrades",
    Icon = "egg",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoUpgrade = state
        AutoUpgradeFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Deposit",
    Desc = "Automatically Deposits",
    Icon = "arrow-big-down-dash",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoDepositEggs = state
        DepositEggsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Collect Cash",
    Desc = "Automatically Collects Cash",
    Icon = "arrow-big-down-dash",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoCollectMoney = state
        CollectMoneyFunc()
    end
})

local Dropdown = AutoFarm:Dropdown({
    Title = "Chicken Buy Count",
    Desc = "Dropdown Description",
    Values = {"1", "5", "25", "100"},
    Value = 1,
    Callback = function(option) 
        chickenCount = tonumber(option)
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Chickens",
    Desc = "Automatically Buys Chickens",
    Icon = "egg",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoBuyChickens = state
        AutoBuyChickensFunc(chickenCount)
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Merge",
    Desc = "Automatically Merges",
    Icon = "egg",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoMerge = state
        AutoMergeFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Tiers",
    Desc = "Automatically Buys Tiers",
    Icon = "egg",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoTiers = state
        AutoTiersFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Finish Obby",
    Desc = "Finishes Obby Automatically for bonus",
    Icon = "arrow-big-down-dash",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoObby = state
        AutoObbyFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Rebirths",
    Desc = "Rebirths When can",
    Icon = "arrow-big-down-dash",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().Rebirth = state
        AutoRebirthFunc()
    end
})