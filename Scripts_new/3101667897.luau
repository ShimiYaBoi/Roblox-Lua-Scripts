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
local debug = true; --debugging
local Orbs = {}
local Crystals = {}
local CrystalsData = {}
local crystalToOpen
local Areas = {}
local AreasPos = {}

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
                env.AutoOpenCrystal = false
            end
        end
    end)
end

function GoCityFunc(city)
    task.spawn(function()
        local position = AreasPos[city]

        if not position then
            -- Notification
        else
            hrp.CFrame = CFrame.new(position)
        end
    end)
end