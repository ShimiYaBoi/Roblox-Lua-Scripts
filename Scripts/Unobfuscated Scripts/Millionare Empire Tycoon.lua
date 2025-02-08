--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]
getgenv().AutoMoney = true
getgenv().AutoCollectCash = true
getgenv().AutoRebirth = true

local plr = game:GetService("Players").LocalPlayer
local plrTycoonRef = plr.TycoonReference.Value
local char = plr.Character
local tycoon = tostring(plrTycoonRef)
local plrTycoon = game:GetService("Workspace").Tycoons:FindFirstChild(tycoon)
local moneygivervalue = 0
local remotePath = game:GetService("ReplicatedStorage")
local collector = plrTycoon.StarterParts.Collector.Givers:FindFirstChild("Giver")
local collector_original_place = collector.CFrame


--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function giveMoney()
    spawn(function()
        remotePath.RespawnService:FireServer(moneygivervalue)
    end)
end

function autoGiveMoney()
    spawn(function()
        while getgenv().AutoMoney == true do wait(1)
            remotePath.RespawnService:FireServer(moneygivervalue)
        end
    end)
end

function autoRebirthTycoon()
    spawn(function()
        while getgenv().AutoRebirth == true do
            remotePath.rebirthEvent:FireServer()
        end
    end)
end

function CollectCashAuto()
    spawn(function()
        if getgenv().AutoCollectCash == true then wait(1)
            while getgenv().AutoCollectCash == true do wait(1)
                collector.Transparency = 1
                collector.CanCollide = false
                collector.CFrame = char.HumanoidRootPart.CFrame
            end
        else
            collector.Transparency = 0
            collector.CanCollide = true
            collector.CFrame = collector_original_place
            collector.Transparency = 0
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

 local Window = Library.CreateLib("Millionaire Empire Tycoon Fucker", "DarkTheme")

 local Tab1 = Window:NewTab("Main")
 local Tab2 = Window:NewTab("Local")

 local Section1 = Tab1:NewSection("Money")
 local Section2 = Tab2:NewSection("Player")

Section1:NewLabel("WARNING: DONT GIVE MORE THE 9000QTS")

 Section1:NewTextBox("Money Value", "WARNING: DONT GIVE MORE THE 9000QTS", function(txt)
	moneygivervalue = txt
end)


 Section1:NewButton("Get Money", "Gives you the amount of the money you typed", function()
    giveMoney()
end)

Section1:NewToggle("Auto Give Money", "WARNING: DONT GIVE MORE THE 9000QTS", function(bool)
    getgenv().AutoMoney = bool
    autoGiveMoney()
end)
Section1:NewToggle("Auto Collect Cash", "Auto Collects Cash", function(state)
    getgenv().AutoCollectCash = state
    CollectCashAuto()
end)
Section1:NewToggle("Auto Rebirth", "Auto Rebirth when you finish tycoon", function(state)
    getgenv().AutoRebirth = state
    wait(3)
    autoRebirthTycoon()
end)

Section2:NewSlider("WalkSpeed", "Changes Your WalkSpeed", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
 end)
 Section2:NewSlider("JumpPower", "Changes Your JumpPower", 400, 50, function(j) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
 end)
