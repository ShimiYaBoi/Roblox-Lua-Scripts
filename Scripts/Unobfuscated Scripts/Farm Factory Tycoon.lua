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
local plr = game:GetService("Players").LocalPlayer
local plrs = game:GetService("Players")
local char = plr.Character
local RS = game:GetService("ReplicatedStorage")
local RE = RS.Remote.Event
local RF = RS.Remote.Function
local valueupgrader = 0
local themes = {"LightTheme", "DarkTheme", "GrapeTheme", "BloodTheme", "Ocean", "Midnight", "Sentinel", "Synapse", "Serpent"}
local TycoonOwnerName = plr.Team

hum = char.HumanoidRootPart

getgenv().AutoInfMoney = true;
getgenv().AutoUpgradeChickens = true;
getgenv().AutoUpgradeCows = true;
getgenv().AutoUpgradeSheep = true;
getgenv().AutoCompleteMissions = true;
getgenv().AutoFreeSpin = true;
getgenv().RemoveBarriers = true;
getgenv().AutoCollectCashChicken = true;
getgenv().AutoCollectCashCow = true;
getgenv().AutoCollectCashSheep = true;
--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

if getgenv().theme == nil then
    getgenv().theme = "Serpent"
end

function InfMoney()
    spawn(function()
        while getgenv().AutoInfMoney == true do
            RE.Offline["[S-C]TryGetFreeReward"]:FireServer()
            task.wait()
        end
    end)
end

function CompleteMissions()
    spawn(function()
        while getgenv().AutoCompleteMissions == true do
            task.wait(2)
            RE.Misson["[C-S]TryGetMissonReward"]:FireServer("Misson1")
            RE.Misson["[C-S]TryGetMissonReward"]:FireServer("Misson2")
            RE.Misson["[C-S]TryGetMissonReward"]:FireServer("Misson3")
        end
    end)
end

function SpinWheel()
    spawn(function()
        while getgenv().AutoFreeSpin == true do
            RF.Spin["[C-S]TryUseFreeSpin"]:InvokeServer()
            task.wait(300)
        end
    end)
end

function UpgradeChickens(value)
    spawn(function()
        while getgenv().AutoUpgradeChickens == true do
            task.wait(1)
            if value ~= "All" then do
                for i=1,25,1 do
                    RE.Spawn["[C-S]TryUpgrade"]:FireServer("Chicken"..value)
                end
                RE.Spawn["[C-S]TryRebirth"]:FireServer("Chicken"..value)
                end
            else
                for count = 1,11,1 do
                    for count2 = 1,25,1 do
                        RE.Spawn["[C-S]TryUpgrade"]:FireServer("Chicken"..count)
                    end
                    RE.Spawn["[C-S]TryRebirth"]:FireServer("Chicken"..count)
                end
            end
        end
    end)
end

function UpgradeCows(value)
    spawn(function()
        while getgenv().AutoUpgradeCows == true do
            task.wait(1)
            if value ~= "All" then do
                for i=1,25,1 do
                    RE.Spawn["[C-S]TryUpgrade"]:FireServer("Cow"..value)
                end
                RE.Spawn["[C-S]TryRebirth"]:FireServer("Cow"..value)
            end
            else
                for count = 1,11,1 do
                    for count2 = 1,25,1 do
                        RE.Spawn["[C-S]TryUpgrade"]:FireServer("Cow"..count)
                    end
                    RE.Spawn["[C-S]TryRebirth"]:FireServer("Cow"..count)
                end
            end
        end
    end)
end

function UpgradeSheep(value)
    spawn(function()
        while getgenv().AutoUpgradeSheep == true do
            task.wait(1)
            if value ~= "All" then do
                for i=1,25,1 do
                    RE.Spawn["[C-S]TryUpgrade"]:FireServer("Sheep"..value)
                end
                RE.Spawn["[C-S]TryRebirth"]:FireServer("Sheep"..value)
            end
            else
                for count = 1,11,1 do
                    for count2 = 1,25,1 do
                        RE.Spawn["[C-S]TryUpgrade"]:FireServer("Sheep"..count)
                    end
                    RE.Spawn["[C-S]TryRebirth"]:FireServer("Sheep"..count)
                end
            end
        end
    end)
end

function TPObby(obbyname)
    spawn(function()
        if obbyname == "Easy Obby" then
            hum.CFrame = CFrame.new(44.486763, 34.2691383+5, -944.947205)
        end
        if obbyname == "Epic Obby" then
            hum.CFrame = CFrame.new(124.230576, 34.2690086+5, -946.316284)
        end
        if obbyname == "Impossible Obby" then
            hum.CFrame = CFrame.new(202.394577, 34.2689857+5, -950.002625)
        end
    end)
end

function RemoveDoors()
    spawn(function()
        for i,v in pairs(ws.Obby.Wall:GetChildren()) do
            if v:IsA("Part") then
                v.CanCollide = false
                v.Transparency = 1
            end
        end
    end)
end

function CollectCashChicken()
    spawn(function()
        while getgenv().AutoCollectCashChicken == true do
            task.wait(2)
            RE.Coop["[C-S]GetCoopReward"]:FireServer(1)
        end
    end)
end

function CollectCashCow()
    spawn(function()
        while getgenv().AutoCollectCashChicken == true do
            task.wait(2)
            RE.Coop["[C-S]GetCoopReward"]:FireServer(2)
        end
    end)
end

function CollectCashSheep()
    spawn(function()
        while getgenv().AutoCollectCashChicken == true do
            task.wait(2)
            RE.Coop["[C-S]GetCoopReward"]:FireServer(3)
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Farm Factory Tycoon - XD", getgenv().theme)

local Tab1 = Window:NewTab("Main")
local Tab2 = Window:NewTab("Local")
local Tab3 = Window:NewTab("Settings & Credits")

local Section1 = Tab1:NewSection("Farm")
local Section2 = Tab2:NewSection("Character")
local Section3 = Tab3:NewSection("Credits")
local Section4 = Tab3:NewSection("Settings")

Section1:NewToggle("Infinite Money", "Gives Free Money", function(state)
    getgenv().AutoInfMoney = state
    InfMoney()
end)

Section1:NewDropdown("Animal Number", "Which Animal To Upgrade", {"All", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, function(currentOption)
    valueupgrader = currentOption
end)

Section1:NewToggle("Auto Upgrade Chicken","Auto Upgrades Chicken", function(state)
    getgenv().AutoUpgradeChickens = state
    UpgradeChickens(valueupgrader)
end)

Section1:NewToggle("Auto Upgrade Cow","Auto Upgrades Cow", function(state)
    getgenv().AutoUpgradeCows = state
    UpgradeCows(valueupgrader)
end)

Section1:NewToggle("Auto Upgrade Sheep","Auto Upgrades Sheep", function(state)
    getgenv().AutoUpgradeSheep = state
    UpgradeSheep(valueupgrader)
end)

Section1:NewToggle("Auto Collect Chicken Money","Barn Money Collector", function(state)
    getgenv().AutoCollectCashChicken = state
    CollectCashChicken()
end)

Section1:NewToggle("Auto Collect Cow Money","Barn Money Collector", function(state)
    getgenv().AutoCollectCashCow = state
    CollectCashCow()
end)

Section1:NewToggle("Auto Collect Sheep Money","Barn Money Collector", function(state)
    getgenv().AutoCollectCashSheep = state
    CollectCashSheep()
end)

Section1:NewToggle("Auto Complete Missions", "Completes Mission Automatically", function(state)
    getgenv().AutoCompleteMissions = state
    CompleteMissions()
end)

Section1:NewToggle("Auto Spin Wheel","Auto Spins Wheel When Available", function(state)
    getgenv().AutoFreeSpin = state
    SpinWheel()
end)

Section2:NewSlider("WalkSpeed", "Changes WalkSpeed", 500, 16, function(s)
    char.Humanoid.WalkSpeed = s
end)

Section2:NewDropdown("Finish Obby", "Choose Obby to Finish", {"Easy Obby", "Epic Obby", "Impossible Obby"}, function(currentOption)
    TPObby(currentOption)
end)

Section2:NewLabel("WARNING: Removing Barriers won't gives ability to spam finish obbies")
Section2:NewButton("Remove Obby Barriers", "Removes timer barriers", function(state)
    RemoveDoors()
end) 

Section3:NewLabel("Kavo Library by xHeptc")
Section3:NewLabel("Scripting by Shimi")

Section4:NewKeybind("Toggle GUI", "Toggles GUI with Binded Key", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
