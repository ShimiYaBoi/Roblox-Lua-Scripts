--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

local Players = game:GetService("Players")
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local remotePath = game:GetService("ReplicatedStorage")
local p1 = char.HumanoidRootPart
local playerlist = {}


--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

game.Players.PlayerRemoving:Connect(function(player)
    local name = player.Name
    for i,v in pairs(playerlist) do
        if v == name then  
            table.remove(playerlist,i)
        end
    end
end)

function TpTO(target)
    local target = Players:FindFirstChild(target)
    spawn(function()
        char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end)
end

function GetLuckyBlock()
    spawn(function()
        remotePath.SpawnLuckyBlock:FireServer()
    end)
end

function GetSuperBlock()
    spawn(function()
        remotePath.SpawnSuperBlock:FireServer()
    end)
end

function GetDiamondBlock()
    spawn(function()
        remotePath.SpawnDiamondBlock:FireServer()
    end)
end

function GetRainbowBlock()
    spawn(function()
        remotePath.SpawnRainbowBlock:FireServer()
    end)
end

function GetGalaxyBlock()
    spawn(function()
        remotePath.SpawnGalaxyBlock:FireServer()
    end)
end

function GetHackerBlock()
    spawn(function()
        for i=1,5 do
            GetGalaxyBlock()
            GetRainbowBlock()
            GetDiamondBlock()
        end
    end)
end

function GetVoidBlock()
    spawn(function()
        for i=1,3 do
            GetGalaxyBlock()
            GetRainbowBlock()
        end
    end)
end

function GetAllPlayers()
    spawn(function()
        for i,v in pairs(Players:GetDescendants()) do
            if v:IsA("Player") and v.Name ~= plr.Name then
                playerlist[#playerlist+1] = v.Name
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
 GetAllPlayers()

 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

 local colors = {
    SchemeColor = Color3.fromRGB(0,255,255),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}

 local Window = Library.CreateLib("Lucky Block GUI", "Midnight")
 local Tab = Window:NewTab("Main")
 local Tab2 = Window:NewTab("Local")
 local Tab3 = Window:NewTab("Settings")
 local Section = Tab:NewSection("Lucky Blocks")
 local Section2 = Tab2:NewSection("Character")
 local Section3 = Tab3:NewSection("Color")

 --Section 1
 Section:NewButton("Lucky Block", "Gives Basic Lucky Block Item", function()
    GetLuckyBlock()
 end)
 Section:NewButton("Super Lucky Block", "Gives Super Lucky Block Item", function()
    GetSuperBlock()
 end)
 Section:NewButton("Diamond Lucky Block", "Gives Diamond Lucky Block Item", function()
    GetDiamondBlock()
 end)

 Section:NewButton("Rainbow Lucky Block", "Gives Rainbow Lucky Block Item", function()
    GetRainbowBlock()
 end)

 Section:NewButton("Galaxy Lucky Block", "Gives Galaxy Lucky Block Item", function()
    GetGalaxyBlock()
 end)
 Section:NewButton("Hacker Lucky Block", "Gives Hacker Lucky Block Item", function()
    GetHackerBlock()
 end)
 Section:NewButton("Void Lucky Block", "Gives Void Lucky Block Item", function()
    GetVoidBlock()
 end)

 --section 2
 Section2:NewSlider("WalkSpeed", "Changes Your WalkSpeed", 500, 16, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
 end)
 Section2:NewSlider("JumpPower", "Changes Your JumpPower", 400, 50, function(j) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
 end)
 Section2:NewButton("Reset Character", "Kills You", function()
    char.Humanoid.Health = 0
 end)
  local dropdown = Section2:NewDropdown("Teleport To Player","Teleports to selected player", playerlist, function(currectOption)
    TpTO(currectOption)
  end)
  Section2:NewButton("Update Player List", "Refreshes Player List", function()
    dropdown:Refresh(playerlist)
  end)
 --Section 3
 Section3:NewKeybind("Toggle UI", "Toggles UI", Enum.KeyCode.RightAlt, function()
	Library:ToggleUI()
 end)
 Section3:NewLabel("Kavo UI by xHeptc")
 Section3:NewLabel("Script by Shimi")
