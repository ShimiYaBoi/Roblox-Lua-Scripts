--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local remotePath = game:GetService("ReplicatedStorage").rEvents
local codes = {"speedchampion000", "racer300", "SPRINT250", "hyper250", "legends500", "sparkles300", "launch200"}
local chests = {"Golden Chest", "Enchanted Chest", "Magma Chest"}
local cities = {"Main City", "Snow City", "Magma City", "Legends Highway"}
local local_trails = {}
local local_pets = {"all"}
local crystal = {"Purple Crystal","Red Crystal","Blue Crystal", "Lightning Crystal", "Snow Crystal", "Inferno Crystal", "Lava Crystal", "Yellow Crystal", "Electro Legends Crystal"}
local plrlocationmap = plr.currentMap.Value
local plrname = plr.Name

getgenv().AutoRebirth = true
getgenv().AutoCollectYellow = true
getgenv().AutoCollectRed = true
getgenv().AutoCollectOrage = true
getgenv().AutoCollectBlue = true
getgenv().AutoCollectGems = true
getgenv().AutoOpen = true
getgenv().AutoJoinRaces = true
getgenv().AutoEvolvePets = true
getgenv().AutoFinishRaces = true

function GetPetsToTable()
    spawn(function()
        for i,v in pairs(plr.petsFolder:GetDescendants()) do
            if v:IsA("StringValue") and v.Name ~= "chosenName" then
                local_pets[#local_pets+1] = v.Name
            end
        end
    end)
end
function GetTrailsToTable()
    spawn(function()
        for i,v in pairs(plr.trailsFolder:GetDescendants()) do
            if v:IsA("Trail") and plr.equippedTrail.Value ~= v.Name then
                local_trails[#local_trails+1] = v.Name
            end
        end
    end)
end

GetPetsToTable()
GetTrailsToTable()

--game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer("openCrystal","Yellow Crystal")
--game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer("sellPet",game:GetService("Players").LocalPlayer.petsFolder.Basic["Yellow Squeak"]) <======== Sell Pet Event
--game:GetService("ReplicatedStorage").rEvents.sellTrailEvent:FireServer("sellTrail",game:GetService("Players").LocalPlayer.trailsFolder.Advanced["Pink Sparks"]) <========= Sell Trail Event

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]
function getHoops()
    spawn(function()
        for i,v in pairs(game:GetService("Workspace").Hoops:GetChildren()) do
            if v:IsA("MeshPart") then
                v.CFrame = char.HumanoidRootPart.CFrame
            end
        end
    end)
end
function FinishRace()
    spawn(function()
        while getgenv().AutoFinishRaces == true do wait(0)
            local plrlocationmapvalue = game:GetService("Players").LocalPlayer.currentMap.Value
            if plrlocationmapvalue == "Magma Race" then
                game.workspace:FindFirstChild(plrname).HumanoidRootPart.CFrame = game:GetService("Workspace").raceMaps.Magma.finishPart.CFrame
            elseif plrlocationmapvalue == "Grass Race" then
                game.workspace:FindFirstChild(plrname).HumanoidRootPart.CFrame = game:GetService("Workspace").raceMaps.Grassland.finishPart.CFrame
            elseif plrlocationmapvalue == "Desert Race" then
                game.workspace:FindFirstChild(plrname).HumanoidRootPart.CFrame = game:GetService("Workspace").raceMaps.Desert.finishPart.CFrame
            end
        end
    end)
end
function JoinRaces()
    spawn(function()
        while getgenv().AutoJoinRaces == true do wait(0.1)
            remotePath.raceEvent:FireServer("joinRace")
        end
    end)
end
function MakeAfkArea()
    spawn(function()
        local afkarea = Instance.new("Part")
        afkarea.CanCollide = true
        afkarea.Material = "Neon"
        afkarea.Parent = game.Workspace
        afkarea.Anchored = true
        afkarea.Size = Vector3.new(100,15,100)
        afkarea.Position = Vector3.new(-571.207275, 228.578812, 2530.0918)
        afkarea.Name = "HAHA SUCK IT LOSERS CANT GET HERE"
        while true do
            afkarea.Color = Color3.new(255/255,0/255,0/255)
                for i = 0,255,10 do
                    wait()
                    afkarea.Color = Color3.new(255/255,i/255,0/255)
                end
                    for i = 255,0,-10 do
                        wait()
                        afkarea.Color = Color3.new(i/255,255/255,0/255)
                    end
                        for i = 0,255,10 do
                            wait()
                            afkarea.Color = Color3.new(0/255,255/255,i/255)
                        end
                        for i = 255,0,-10 do
                            wait()
                            afkarea.Color = Color3.new(0/255,i/255,255/255)
                        end
                    for i = 0,255,10 do
                        wait()
                        afkarea.Color = Color3.new(i/255,0/255,255/255)
                    end
            for i = 255,0,-10 do
                wait()
                afkarea.Color = Color3.new(255/255,0/255,i/255)
            end
        end
    end)
end

function gotoAfkArea()
    spawn(function()
        game.workspace:FindFirstChild(plrname).HumanoidRootPart.CFrame = game.workspace:FindFirstChild("HAHA SUCK IT LOSERS CANT GET HERE").CFrame
    end)
end
function gotoAfkArea_New()
    spawn(function()
        game.workspace:FindFirstChild(plrname).HumanoidRootPart:PivotTo(game.workspace:FindFirstChild("HAHA SUCK IT LOSERS CANT GET HERE").CFrame)
    end)
end
function CollectYellow()
    spawn(function()
        while getgenv().AutoCollectYellow == true do wait(0.1)
            remotePath.orbEvent:FireServer("collectOrb","Yellow Orb","City")
        end
    end)
end
function CollectRed()
    spawn(function()
        while getgenv().AutoCollectRed == true do wait(0.1)
            remotePath.orbEvent:FireServer("collectOrb","Red Orb","City")
        end
    end)
end
function CollectOrage()
    spawn(function()
        while getgenv().AutoCollectOrage == true do wait(0.1)
            remotePath.orbEvent:FireServer("collectOrb","Orange Orb","City")
        end
    end)
end
function CollectBlue()
    spawn(function()
        while getgenv().AutoCollectBlue == true do wait(0.1)
            remotePath.orbEvent:FireServer("collectOrb","Blue Orb","City")
        end
    end)
end
function CollectGem()
    spawn(function()
        while getgenv().AutoCollectGems == true do wait(0.1)
            remotePath.orbEvent:FireServer("collectOrb","Gem","City")
        end
    end)
end
function redeemAllCodes()
    spawn(function()
        for i=1,7 do
        remotePath.codeRemote:InvokeServer(codes[i])
        end
    end)
end
function GetChests()
    spawn(function()
        for i=1,3 do
            remotePath.checkChestRemote:InvokeServer(chests[i])
        end
    end)
end
function AutoOpenCrystal(crystal)
    spawn(function()
        while getgenv().AutoOpen == true do wait(0.5)
            remotePath.openCrystalRemote:InvokeServer("openCrystal",crystal)
        end
    end)
end
function OpenCrystal(crystal)
    spawn(function()
            remotePath.openCrystalRemote:InvokeServer("openCrystal",crystal)
    end)
end
function Rebirth()
    spawn(function()
        while getgenv().AutoRebirth == true do wait(1)
            remotePath.rebirthEvent:FireServer("rebirthRequest")
        end
    end)
end
function EvolvePets(petvalue)
    spawn(function()
        while getgenv().AutoEvolvePets == true do wait(0.1)
            if petvalue == "all" then
                for count,pets in pairs(local_pets) do
                    if pets ~= "all" then
                        remotePath.petEvolveEvent:FireServer("evolvePet", pets)
                    else
                        --Nothing My Guy
                    end
                end
            end
            remotePath.petEvolveEvent:FireServer("evolvePet",petvalue)
            GetPetsToTable()
        end
    end)
end


function GotoCity(v)
    if v == "Main City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9682.98828, 74.8522873, 3099.03394, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
    elseif v == "Snow City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9676.13867, 74.8522873, 3782.69385, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    elseif v == "Magma City" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11054.9688, 232.791656, 4898.62842, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
    elseif v == "Legends Highway" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13098.8711, 232.791656, 5907.62793, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Legends of Speed - XD", getgenv().theme)

local Tab = Window:NewTab("Main")
local LocalTab = Window:NewTab("Local")
local PetsTab = Window:NewTab("Pets and Trails")
local SettingsTab = Window:NewTab("Settings")

local MainSection = Tab:NewSection("Main")
local LocalSection = LocalTab:NewSection("Local")
local PetsSec = PetsTab:NewSection("Pets & Trails")
local SettingsSec = SettingsTab:NewSection("Credits & Settings")

LocalSection:NewSlider("Walk Speed", "...", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

LocalSection:NewSlider("Jump Power", "...", 500, 50, function(j)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
end)

LocalSection:NewButton("Redeem All Codes", "Redeems Codes", function()
    redeemAllCodes()
end)

LocalSection:NewButton("Get Chests Reward", "Chest Rewards", function()
    GetChests()
end)

MainSection:NewButton("Farm Hoops", "Gets all loops", function()
    getHoops()
end)

MainSection:NewToggle("Auto Rebirth", "Auto Rebirth", function(state)
    getgenv().AutoRebirth = state
    Rebirth()
end)

MainSection:NewToggle("Auto Collect Blue Orbs", "Auto Collects Blue orbs", function(state)
    getgenv().AutoCollectBlue = state
    CollectBlue()
end)

MainSection:NewToggle("Auto Collect Orange Orbs", "Auto Collects Orange orbs", function(state)
    getgenv().AutoCollectOrage = state
    CollectOrage()
end)

MainSection:NewToggle("Auto Collect Red Orbs", "Auto Collects Red orbs", function(state)
    getgenv().AutoCollectRed = state
    CollectRed()
end)

MainSection:NewToggle("Auto Collect Yellow Orbs", "Auto Collects Yellow orbs", function(state)
    getgenv().AutoCollectYellow = state
    CollectYellow()
end)

MainSection:NewToggle("Auto Collect Gems", "Auto Collects Gems", function(state)
    getgenv().AutoCollectGems = state
    CollectGem()
end)

local selectedCrystal;
PetsSec:NewDropdown("Select Crystal", "Crystal for pets", crystal, function(currentOption)
    selectedCrystal = currentOption
end)

PetsSec:NewButton("Open Selected Crystal", "...", function()
    if selectedCrystal then
        OpenCrystal(selectedCrystal)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Error",
			Text = "Didn't Select Crystal"
        })
    end
end)

PetsSec:NewToggle("Auto Open Crystals", "...", function(bool)
    if selectedCrystal then
        getgenv().AutoOpen = bool
        AutoOpenCrystal(selectedCrystal)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Error",
			Text = "Didn't Select Crystal"
        })
    end
end)

local Evolve_Pet_value;
task.wait(0.33)
PetsSec:NewDropdown("Pets To Evolve", "...", local_pets, function(currentOption)
    Evolve_Pet_value = currentOption
end)

PetsSec:NewButton("Refresh Pets List", "...", function()
    GetPetsToTable()
end)

PetsSec:NewToggle("Auto Evolve Pets", "...", function(state)
    if Evolve_Pet_value then
        getgenv().AutoEvolvePets = state
        if Evolve_Pet_value == "all" then
            EvolvePets(Evolve_Pet_value)
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Error",
			Text = "Pet Hasn't been selected"
		})
    end
end)

LocalSection:NewButton("AFK Area", "Makes AFK Area", function()
    if game.workspace:FindFirstChild("HAHA SUCK IT LOSERS CANT GET HERE") == nil then
		MakeAfkArea()
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Error",
			Text = "AFK Area Already Exists"
		})
	end
end)

LocalSection:NewButton("Goto AFK Area", "...", function()
	if game.workspace:FindFirstChild("HAHA SUCK IT LOSERS CANT GET HERE") == nil then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Error",
			Text = "AFK Area Not found, Please Make one"
		})
	else
		gotoAfkArea_New()
	end
end)

LocalSection:NewDropdown("Teleport To City", "...", cities, function(currentOption)
    GotoCity(currentOption)
end)

LocalSection:NewToggle("Auto Join Races", "...", function(state)
    getgenv().AutoJoinRaces = state
    JoinRaces()
end)

LocalSection:NewToggle("Auto Finish Races", "...", function(state)
    getgenv().AutoFinishRaces = state
    FinishRace()
end)

SettingsSec:NewLabel("Kavo Library by xHeptc")
SettingsSec:NewLabel("Scripting by Shimi")

SettingsSec:NewKeybind("Toggle UI", "...", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
