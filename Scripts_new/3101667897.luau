--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]


------------> Legends Of Speed / https://www.roblox.com/games/3101667897/Legends-Of-Speed

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local RS = game:GetService("ReplicatedStorage")
local Events = RS.rEvents
local maps = {}
local plrCurrentMap = plr.currentMap.Value
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local env = getgenv()
local debug = false; --debugging
local Orbs = {}
local Crystals = {}
local CrystalsData = {}
local crystalToOpen
local Areas = {}
local AreasPos = {}
local petFolder = plr.petsFolder
local trailFolder = plr.trailsFolder
local PetRaritySells = {}
local TrailRaritySells = {}
local selectedPetRaritiesToSell = {}
local selectedTrailRaritiesToSell = {}

for _, model in ipairs(ws.areaCircles:GetChildren()) do
    local areaName = model:FindFirstChild("areaName")
    local circle = model:FindFirstChild("circleInner")

    if areaName and circle then
        if not table.find(Areas, areaName.Value) then
            table.insert(Areas, areaName.Value)
        end

        AreasPos[areaName.Value] = circle.Position + Vector3.new(0,5,0)
    end
end

if debug then
    warn("AreasPos Table")
    for name, pos in pairs(AreasPos) do
        print("Area: ", name, " Position + 5Y Value: ", pos)
    end
    warn("Areas Table")
    for _, name in ipairs(Areas) do
        print("Area Name: ", name)
    end
end

local function GetOrbNames()
    local Orbies = {}

    for _, orb in ipairs(RS.Orbs:GetChildren()) do
        if orb then
            table.insert(Orbies, orb.Name)
        end
    end
    return Orbies
end

local function GetPetRarities()
    local Tiers = {}

    for _, tier in ipairs(plr.petsFolder:GetChildren()) do
        if tier then
            table.insert(Tiers, tier.Name)
        end
    end
    return Tiers
end

local function GetTrailRarities()
    local Tiers = {}

    for _, tier in ipairs(plr.trailsFolder:GetChildren()) do
        if tier then
            table.insert(Tiers, tier.Name)
        end
    end
    return Tiers
end

local function GetNil(name, id)
    for _, obj in getnilinstances() do
        if obj.Name == name and obj:GetDebugId() == id then
            return obj
        end
    end
end

local function getId(m) -- waste?
    local id = m:GetDebugId()

    return id
end

local function getCrystals()
    local cr = {}
    local crData = {}

    for _, shop in ipairs(RS.crystalPrices:GetChildren()) do
        local Price = shop.price.Value
        local Type = shop.priceType.Value
        if shop then
            table.insert(cr, shop.Name)

            crData[shop.Name] = {
                Price = Price,
                Type = Type
            }
        end
    end

    return cr, crData
end

Crystals, CrystalsData = getCrystals()
if debug then
    warn("Crystals Data Table")
    for name, data in pairs(CrystalsData) do
        print("Crystal: ", name, "Price: ", data.Price, " ", data.Type)
    end
end

Orbs = GetOrbNames()
if debug then
    warn("Orbs Table")
    for location, name in ipairs(Orbs) do
        print(name)
    end
end

PetRaritySells = GetPetRarities()
if debug then
    warn("Pet Tiers")
    for _, name in ipairs(PetRaritySells) do
        print("Pet Tiers:", name)
    end
end

TrailRaritySells = GetTrailRarities()
if debug then
    warn("Trails Tier:")
    for _, name in ipairs(PetRaritySells) do
        print("Trails Tiers:", name)
    end
end

if debug then warn("Loaded Map: ", plrCurrentMap) end

plr.currentMap.Changed:Connect(function(map)
    plrCurrentMap = map
    if debug then warn("Updated Map: ", map) end
end)

env.AutoRebirth = false;
env.AutoCollectOrbs = false;
env.AutoClaimFreeGifts = false;
env.AutoClaimHoops = false;
env.AutoOpenCrystal = false;
env.AutoSellPetsTier = false;
env.AutoSellTrailsTier = false;

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

function RebirthFunc()
    task.spawn(function()
        while env.AutoRebirth == true do
            task.wait(0.3)
            Events.rebirthEvent:FireServer("rebirthRequest")
        end
    end)
end

function CollectOrbsFunc()
    task.spawn(function()
        while env.AutoCollectOrbs == true do
            task.wait(0.1)
            if plrCurrentMap and next(Orbs) then
                for _,name in ipairs(Orbs) do
                    Events.orbEvent:FireServer("collectOrb", name, plrCurrentMap)
                    task.wait(0.1)
                    if debug then print("Collected: ", name, "Inside: ", plrCurrentMap) end
                end
            end
        end
    end)
end

function ClaimGiftsFunc()
    task.spawn(function()
        while env.AutoClaimFreeGifts == true do
            task.wait(1)
            for i=1, 8 do
                Events.freeGiftClaimRemote:InvokeServer("claimGift", i)
            end
        end
    end)
end

function ClaimHoopsFunc()
    task.spawn(function()
        while env.AutoClaimHoops == true do
           task.wait(0.1)
           for _, hoop in ipairs(ws.Hoops:GetChildren()) do
            if hoop then
                firetouchinterest(hoop, hrp, false)
                task.wait(0.1)
                firetouchinterest(hoop, hrp, true)
            end
           end
        end
    end)
end

function OpenCrystalFunc()
    task.spawn(function()
        while env.AutoOpenCrystal == true do
            task.wait(0.5)
            if crystalToOpen then
                Events.openCrystalRemote:InvokeServer("openCrystal",crystalToOpen)
            else
                --Notification
                WindUI:Notify({
                    Title = "Error",
                    Content = "Crystal not Found",
                    Duration = 5, -- 3 seconds
                    Icon = "circle-x",
                })
                env.AutoOpenCrystal = false
            end
        end
    end)
end

function GoCityFunc(city)
    task.spawn(function()
        local position = AreasPos[city]

        if not position then
            if debug then warn(position, " Not Found") end
        else
            hrp.CFrame = CFrame.new(position)
            if debug then print("Location: ", city) end
        end
    end)
end

function IsRarity(tier)
    return table.find(selectedPetRaritiesToSell, tier) ~= nil, table.find(selectedTrailRaritiesToSell, tier) ~= nil
end

function SellPetButton()
    for _, tier in ipairs(selectedPetRaritiesToSell) do
        if debug then
            print("Sell Button:")
            print("Selected Tier(s): ", tier)
        end

        local tierFolder = petFolder:FindFirstChild(tier)

        if not tierFolder then
            if debug then
                warn("No Folder Found:", tier)

                WindUI:Notify({
                Title = "Error",
                Content = "Selected Rarity not found: " .. tostring(tier),
                Duration = 5,
                Icon = "circle-x",
                })

                continue
            end
        end

        if debug then
            print("Found Tier Folder: ", tierFolder)
            print("Pet Count: ", #tierFolder:GetChildren())
        end

        for _, pet in ipairs(tierFolder:GetChildren()) do
            if debug then print("Pet: ", pet, "\nPet Name: ", pet.Name, "\nDebug Id: ", getId(pet)) end

            local petName = pet.Name
            local petId = getId(pet)

            pet:Destroy()

            local nilPet = GetNil(petName, petId) --Needed?

            if debug then print("Nil Pet Name: ", nilPet, "\nDebugId: ", petId) end

            if nilPet then
                local Remote = Events.sellPetEvent

                Remote:FireServer("sellPet", GetNil(petName, petId))

                if debug then print("Pet Sell: ", petName, "\nPet Rarity: ", tier) end
            else
                warn("Could not find nil instance for:", petName, petId)
            end
        end
    end
end

function SellTrailButton()
    for _, tier in ipairs(selectedTrailRaritiesToSell) do
        if debug then
            print("Sell Button:")
            print("Selected Tier(s): ", tier)
        end

        local tierFolder = trailFolder:FindFirstChild(tier)

        if not tierFolder then
            if debug then
                warn("No Folder Found:", tier)

                WindUI:Notify({
                Title = "Error",
                Content = "Selected Rarity not found: " .. tostring(tier),
                Duration = 5,
                Icon = "circle-x",
                })

                continue
            end
        end

        if debug then
            print("Found Tier Folder: ", tierFolder)
            print("Trails Count: ", #tierFolder:GetChildren())
        end

        for _, trail in ipairs(tierFolder:GetChildren()) do
            if debug then print("Trail: ", trail, "\nPet Name: ", trail.Name, "\nDebug Id: ", getId(trail)) end

            local trailName = trail.Name
            local trailId = getId(trail)

            trail:Destroy()

            local niltrail = GetNil(trailName, trailId) --Needed?

            if debug then print("Nil trail Name: ", niltrail, "\nDebugId: ", trailId) end

            if niltrail then
                local Remote = Events.sellTrailEvent

                Remote:FireServer("sellTrail", GetNil(trailName, trailId))

                if debug then print("Trail Sell: ", trailName, "\nTrail Rarity: ", tier) end
            else
                warn("Could not find nil instance for:", trailName, trailId)
            end
        end
    end
end

function SellPetFunc()
    task.spawn(function()
        while env.AutoSellPetsTier == true do
        SellPetButton()
        task.wait(0.1)
        end
    end)    
end

function SellTrailFunc()
    task.spawn(function()
        while env.AutoSellTrailsTier == true do
        SellTrailButton()
        task.wait(0.1)
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
    Title = "Legends of Speed",
    Icon = "sport-shoe", -- lucide icon. optional
    Author = "by shimixd", -- optional

--[[    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            --print("clicked")
        end,
    },]]
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
    Icon = "hand-coins", -- optional
    Locked = false,
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Rebirth",
    Desc = " ",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoRebirth = state
        RebirthFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Collect Orbs",
    Desc = " ",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoCollectOrbs = state
        CollectOrbsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Claim Gifts",
    Desc = "Collects Free Gift",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoClaimFreeGifts = state
        ClaimGiftsFunc()
    end
})

local Toggle = AutoFarm:Toggle({
    Title = "Auto Claim Hoops",
    Desc = "",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoClaimHoops = state
        ClaimHoopsFunc()
    end
})

local Dropdown = AutoFarm:Dropdown({
    Title = "City",
    Desc = "Teleport To",
    Values = Areas,
    Value = nil,
    Callback = function(option) 
        GoCityFunc(option)
    end
})

local PetTab = Window:Tab({
    Title = "Pets",
    Icon = "egg", -- optional
    Locked = false,
})

local CrystalDropdownValues = {}
local CrystalNames = {}

for _, crystal in ipairs(Crystals) do
    local data = CrystalsData[crystal]

    if data then
        local displayName = crystal .. " - " .. data.Price .. " " .. data.Type

        table.insert(CrystalDropdownValues, displayName)

        CrystalNames[displayName] = crystal
    end
end

local Dropdown = PetTab:Dropdown({
    Title = "Crystal",
    Desc = "To Open",
    Values = CrystalDropdownValues,
    Value = nil,
    Callback = function(option)
        local crystalName = CrystalNames[option]

        crystalToOpen = crystalName
        if debug then print("Selected:", crystalName) end
    end
})

local Toggle = PetTab:Toggle({
    Title = "Auto Open Crystal",
    Desc = "",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoOpenCrystal = state
        OpenCrystalFunc()
    end
})

local Dropdown = PetTab:Dropdown({
    Title = "Pet Rarities To Sell",
    Desc = "",
    Values = GetPetRarities(),
    Value = nil,
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        selectedPetRaritiesToSell = option
        if debug then print("Pet Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) end
    end
})

local Dropdown = PetTab:Dropdown({
    Title = "Trails Rarities To Sell",
    Desc = "",
    Values = GetTrailRarities(),
    Value = nil,
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        selectedTrailRaritiesToSell = option
        if debug then print("Trails Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) end
    end
})

local Toggle = PetTab:Toggle({
    Title = "Auto Sell Pets Rarity",
    Desc = "",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoSellPetsTier = state
        SellPetFunc()
    end
})

local Toggle = PetTab:Toggle({
    Title = "Auto Sell Trails Rarity",
    Desc = "",
    Icon = "check",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        env.AutoSellTrailsTier = state
        SellTrailFunc()
    end
})

if debug then
    local Button = PetTab:Button({
        Title = "Sell Pet Rarity",
        Desc = "Test Button",
        Locked = false,
        Callback = function()
            SellPetButton()
        end
    })
end

if debug then
    local Button = PetTab:Button({
        Title = "Sell Trails Rarity",
        Desc = "Test Button",
        Locked = false,
        Callback = function()
            SellTrailButton()
        end
    })
end

local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings", -- optional
    Locked = false,
})

local Keybind = Settings:Keybind({
    Title = "Toggle Menu",
    Desc = "Keybind to open ui",
    Value = "F",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})