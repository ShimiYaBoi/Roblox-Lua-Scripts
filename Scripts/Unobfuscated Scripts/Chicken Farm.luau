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


getgenv().AutoCollectEggs = false;
getgenv().AutoBuyChickens = false;
getgenv().AutoCollectMoney = false;
getgenv().AutoDepositEggs = false;
getgenv().AutoObby = false;
getgenv().AutoUpgrade = false;
getgenv().AutoMerge = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

--[[

----> Old Function

function CollectEggsFunc()
    for _, v in ipairs(ws:FindFirstChild("Eggs"):GetChildren()) do
        if v:IsA("Model") then
            local Event = Remotes.__remoteevent
            if not model then continue end
            v.PrimaryPart.Position = char:FindFirstChild("HumanoidRootPart").Position
            Event:FireServer("Collect Egg", v.Name)
            v:Destroy()
        elseif not v then
            return
        end
    end
end]]

function CollectEgg()

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
            task.wait(1)
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
        --Function
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
        --Function
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
        getgenv().AutoCollectEggs = state
        CollectMoneyFunc()
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
        --Function
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
        --Function
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