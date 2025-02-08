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
local humRootPart = char.HumanoidRootPart
local TycoonOwner = tostring(plr:FindFirstChild("Tycoon").Value)
local TycoonSkins = {}
local Codes = {"EASTER", "stpatricks", "rftx", "xmas2022", "2klikes", "500likes", "halloween", "1kccu", "1kmembers"}
local FinishCFrame = -54.4198723, 14.8375101, 1581.45911, 1, -8.0692425e-10, 8.18418887e-14, 8.0692425e-10, 1, -2.43556242e-09, -8.18399236e-14, 2.43556242e-09, 1

getgenv().AutoCollect = true
getgenv().AutoCollectTree = true
getgenv().AutoSell = true
getgenv().theme = nil
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

for count, name in pairs(game:GetService("ReplicatedStorage").TycoonSkins:GetChildren()) do
    if name:IsA("Folder") then
        TycoonSkins[#TycoonSkins+1] = name.Name
    end
end

function CollectAll()
    for i,v in pairs(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner).Drops:GetChildren()) do
        if v:IsA("Part") then
            v.CanCollide = false
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

--game:GetService("Workspace").Tycoons.5["Orb Processor"]

function SellFunc()
    task.wait()
    firetouchinterest(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner)["Orb Processor"].Model.Deposit.Button, humRootPart, 0)
	firetouchinterest(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner)["Orb Processor"].Model.Deposit.Button, humRootPart, 1)
end

function AutoSellFunc()
    while getgenv().AutoSell == true do
        task.wait()
        firetouchinterest(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner)["Orb Processor"].Model.Deposit.Button, humRootPart, 0)
        firetouchinterest(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner)["Orb Processor"].Model.Deposit.Button, humRootPart, 1)
    end
end

function AutoCollectFunc()
    while getgenv().AutoCollect == true do
        wait(0.4)
        for i,v in pairs(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner).Drops:GetChildren()) do
            if v:IsA("Part") then
                v.CanCollide = false
                v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end

function GetAllEasterEggs()
    spawn(function()
        for i,v in pairs(game:GetService("Workspace").EasterEggs:GetChildren()) do
            task.wait(2)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        end
    end)
end

function ChangeSkin(skin)
    spawn(function()
        game:GetService("ReplicatedStorage").Remotes.ChangeSkin:FireServer(skin)
    end)
end

function RedeemAllCodes()
    spawn(function()
        for _, codes in pairs(Codes) do
            game:GetService("ReplicatedStorage").Remotes.RedeemCode:InvokeServer(codes)
        end
    end)
end

function FinishObby()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-54.4198723, 14.8375101, 1581.45911)
end

function GetRebirthTree()
    spawn(function()
        while getgenv().AutoCollectTree == true do
            task.wait()
            for _, rewards in pairs(game:GetService("Workspace").Tycoons:FindFirstChild(TycoonOwner).RebirthTree.Drops:GetChildren()) do
                rewards.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
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

local Window = Library.CreateLib("Rarity Factory Tycoon", getgenv().theme)

local Tab = Window:NewTab("Main")
local LocalTab = Window:NewTab("Local")
local SettingsTab = Window:NewTab("Settings & Credits")

local MainSection = Tab:NewSection("Farm")
local LocalSection = LocalTab:NewSection("Local")
local SettingsSection = SettingsTab:NewSection("Credits & Settings")

MainSection:NewButton("Redeem All Codes", "...", function()
    RedeemAllCodes()
end)

MainSection:NewButton("Collect All Orbs", "...", function()
    CollectAll()
end)

MainSection:NewButton("Sell Orbs", "...", function()
    SellFunc()
end)

MainSection:NewToggle("Auto Collect Orbs", "...", function(state)
    getgenv().AutoCollect = state
    AutoCollectFunc()
end)

MainSection:NewToggle("Auto Sell Orbs", "...", function(state)
    getgenv().AutoCollect = state
    AutoSellFunc()
end)

MainSection:NewToggle("Auto Collect Rebirth Tree Rewards", "...", function(state)
    getgenv().AutoCollectTree = state
    GetRebirthTree()
end)

MainSection:NewDropdown("Select Tycoon Skin", "...", TycoonSkins, function(currentOption)
    ChangeSkin(currentOption)
end)

MainSection:NewButton("Finish Obby", "...", function()
    FinishObby()
end)

LocalSection:NewSlider("Walk Speed", "SliderInfo", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

LocalSection:NewSlider("Jump Power", "SliderInfo", 500, 50, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

SettingsSection:NewKeybind("Toggle UI", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)

SettingsSection:NewLabel("Kavo UI by xHeptc")
SettingsSection:NewLabel("Script by Shimi")
