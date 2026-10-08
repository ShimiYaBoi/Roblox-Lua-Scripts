--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

-------> +1 Swordwave Legend / https://www.roblox.com/games/113220849219354/1-Swordwave-Legend


local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS.Shared.Remotes
local WinToFarm = nil
local WinFarmMethod
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local UIState = require(plr.PlayerScripts.UI.UIState)
local Upgrades = {"PowerPerClick", "TrainingSpeed", "WinsPerStage", "EffectiveHP", "WalkSpeed", "Wavestep", "PetEquipSlots"}


getgenv().AutoClick = false;
getgenv().AutoWin = false;
getgenv().AutoRebirth = false;
getgenv().AutoBuyUpgrades = false;
getgenv().AutoUpgradeDojo = false;
getgenv().AutoEvolve = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function AutoClickFunc()
    task.spawn(function()
        while getgenv().AutoClick == true do
            local Remote = Remotes.GameplayRemoteEvents.TrainClick
            task.wait(0.1)
            Remote:FireServer()
        end
    end)
end

function AutoWinFunc()
    task.spawn(function()
        while getgenv().AutoWin == true do
            local Remote = Remotes.GameplayRemoteEvents.ReportCombat

            local winToFarm = tonumber(WinToFarm)

            if WinToFarm == nil then
                WindUI:Notify({
                Title = "Invalid Value",
                Content = "Please Select Wins ",
                Duration = 5, -- 3 seconds
                Icon = "info",
                })
                getgenv().AutoWin = false;
                break
            end
            task.wait(0.1)

            if WinFarmMethod == nil then
                WindUI:Notify({
                Title = "Non Selected",
                Content = "Please Select Win Method",
                Duration = 5, -- 3 seconds
                Icon = "info",
                })
                getgenv().AutoWin = false;
                break
            end

            if WinFarmMethod == "Stages" then
                for i=1, winToFarm do
                    Remote:FireServer({Stage = i})
                    task.wait(0.1)
                    Remote:FireServer({Cleared = i})
                    task.wait(0.1)
                    Remote:FireServer({InHub = true})
                    if getgenv().AutoWin == false then
                        break
                    end
                end
            elseif WinFarmMethod == "Instant" then
                Remote:FireServer({Stage = winToFarm})
                task.wait(0.1)
                Remote:FireServer({Cleared = winToFarm})
                task.wait(0.1)
                Remote:FireServer({InHub = true})
            end
        end
    end)
end

function AutoRebirthFunc()
    task.spawn(function()
        while getgenv().AutoRebirth == true do
            if UIState.canRebirth() == true then
                if UIState.rebirthGainTier() == "Even" or UIState.rebirthGainTier() == "Big" then
                    local Remote = Remotes.GameplayRemoteEvents.RequestRebirth
                    Remote:FireServer()
                end
            end
            task.wait(0.5)
        end
    end)
end

function AutoBuyUpgradesFunc()
    task.spawn(function()
        while getgenv().AutoBuyUpgrades == true do
            for _, name in pairs(Upgrades) do
                local Remote = Remotes.GameplayRemoteEvents.BuyRebirthUpgrade

                Remote:FireServer(tostring(name))
                task.wait(0.5)
            end
        end
    end)
end

function AutoBuyDojoFunc()
    task.spawn(function()
        while getgenv().AutoUpgradeDojo == true do
            local Remote = Remotes.GameplayRemoteEvents.RequestDojoUpgrade

            Remote:FireServer()
            task.wait(0.5)
        end
    end)
end

function AutoEvolveFunc()
    task.spawn(function()
        while getgenv().AutoEvolve == true do
            local Remote = Remotes.GameplayRemoteEvents.RequestEvolve

            Remote:FireServer()
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
    Title = "+1 Swordwave Legend",
    Icon = "swords", -- lucide icon. optional
    Author = "by shimixd", -- optional
})

WindUI:Popup({
    Title = "Currently Not Updated",
    Icon = "Some features might not work needs to be updated",
    Content = "Popup content",
    Buttons = {
        {
            Title = "Understood",
            Icon = "arrow-right",
            Callback = function() end,
            Variant = "Primary",
        }
    }
})

WindUI:Notify({
    Title = "Loaded!",
    Content = "Made with WindUI By .ftgs",
    Duration = 10, -- 3 seconds
    Icon = "heart-handshake",
})

Window:EditOpenButton({
    Title = "Open Example UI",
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
    Icon = "sword", -- optional
    Locked = false,
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Click",
    Desc = "",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoClick = state
        AutoClickFunc()
    end
})

local Input = AutoFarm:Input({
    Title = "Wins",
    Desc = "Number To farm wins (1-140)",
    Value = nil,
    InputIcon = "crown",
    Type = "Input", -- or "Textarea"
    Placeholder = "",
    Callback = function(input) 
        if input and input % 1 == 0 then
            input = math.clamp(input, 1, 220)
            WinToFarm = input
        else
            WindUI:Popup({
                Title = "Wrong Input",
                Icon = "circle-alert",
                Content = "The value you have entered is wrong, Please Select a value between 1 to 140",
                Buttons = {
                    {
                        Title = "I got it",
                        Callback = function() Value = 1 end,
                        Varient = "Primary"
                    }
                }
            })
        end
    end
})

--[[local Dropdown = AutoFarm:Dropdown({
    Title = "Win Farm Method",
    Desc = "",
    Values = { "Stages", "Instant"},
    Value = nil,
    Callback = function(option) 
        WinFarmMethod = option 
    end
})]]

local Button = AutoFarm:Button({
    Title = "Win Method",
    Desc = "Select Win Farm",
    Locked = false,
    Callback = function()
        local Dialog = Window:Dialog({
            Icon = "info",
            Title = "Win Farm Method",
            Content = "Stages - Rapidly finishes Stages (Goes from 1 to Selected Stage) | Instant - Finishes the selected stage instantly (Recommended)",
            Buttons = {
                {
                    Title = "Stages",
                    Callback = function()
                        WinFarmMethod = "Stages"
                        print(WinFarmMethod)
                    end,
                },
                {
                    Title = "Instant",
                    Callback = function()
                        WinFarmMethod = "Instant"
                        print(WinFarmMethod)
                    end,
                },
            },
        })
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Win",
    Desc = "Farm Wins",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoWin = state
        AutoWinFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Rebirth",
    Desc = "Automatically Rebirths",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoRebirth = state
        AutoRebirthFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Upgrades",
    Desc = "Automatically Buys Rebirth Upgrades",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoBuyUpgrades = state
        AutoBuyUpgradesFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Buy Dojo Upgrades",
    Desc = "Automatically Upgrades Dojo Station",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoUpgradeDojo = state
        AutoBuyDojoFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Evolve",
    Desc = "Automatically Evolves",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        getgenv().AutoEvolve = state
        AutoEvolveFunc()
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