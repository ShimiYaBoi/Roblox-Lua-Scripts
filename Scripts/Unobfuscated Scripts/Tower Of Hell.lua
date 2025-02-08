--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

getgenv().God = true

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

local function DisableSignal(signal, name)
    local successes = true
    for i, connection in next, getconnections(signal) do
        local success, err = pcall(connection.Disable)
        if success then
            print('successfully disconnected ' .. name .. '\'s #' .. tostring(i) .. ' connection')
        else
            if err then
                print('failed to disconnect ' .. name .. '\'s # ' .. tostring(i) .. 'connection due to ' .. err)
            end
            successes = false
        end
    end
    return successes
end

local localscript = game:GetService'Players'.LocalPlayer.PlayerScripts.LocalScript
local localscript2 = game:GetService'Players'.LocalPlayer.PlayerScripts.LocalScript2

local localscriptSignal = localscript.Changed
local localscript2Signal = localscript2.Changed

if DisableSignal(localscriptSignal, 'localscript') then
    localscript:Destroy()
end
if DisableSignal(localscript2Signal, 'localscript2') then
    localscript2:Destroy()
end

function GetAllItems()
    spawn(function()
        for i,v in pairs(game:GetService("ReplicatedStorage").Gear:GetChildren()) do
            if v:IsA("Tool") then
                local clone = v:Clone()
                clone.Parent = game:GetService("Players").LocalPlayer.Backpack
            end
        end
    end)
end

function TpToTop()
    spawn(function()
        local endzone = game.Workspace.tower.sections.finish.start.CFrame
        local player = game.Players.LocalPlayer.Character
        player.HumanoidRootPart.CFrame = endzone
    end)
end

function godMode()
    spawn(function()
        if getgenv().God == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("KillScript").Disabled = true
        else
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("KillScript").Disabled = false
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

local Window = Library.CreateLib("Tower Of Hell - XD", getgenv().theme)

local Tab = Window:NewTab("Main")
local LocalTab = Window:NewTab("Local")
local CreditsTab = Window:NewTab("Credits & Settings")

local Section = Tab:NewSection("Main")
local LocalSection = LocalTab:NewSection("Character")
local CreditsSection = CreditsTab:NewSection("Credits + Settings")

Section:NewButton("Get All Items", "Gives all the items", function()
    GetAllItems()
end)

Section:NewButton("Finish Obby", "Teleports to the top", function()
    TpToTop()
end)

Section:NewButton("GodMode", "Makes you invincible to kill parts", function()
    godMode()
end)

LocalSection:NewSlider("WalkSpeed", "Changes Walk Speed", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

LocalSection:NewSlider("Jump Power", "High Jumps", 500, 50, function(j) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
end)

LocalSection:NewSlider("Gravity", "Changes Gravity", 196, 1, function(g) -- 500 (MaxValue) | 0 (MinValue)
    game.Workspace.Gravity = g
end)

CreditsSection:NewKeybind("Toggle UI", "...", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)

CreditsSection:NewLabel("Kavo Library by xHeptc")
CreditsSection:NewLabel("Scripting by Shimi")
CreditsSection:NewLabel("Anti-Cheat Bypass By TechHog on YT <-- Special Thanks")
