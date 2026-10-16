local ws = workspace
local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char, hum, hrp
local debug = true
local RS = game:GetService("ReplicatedStorage")
local env = getgenv()
local OverWorldIslands = {}
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()

env.AutoBlow = false;
env.AutoSell = false;
env.AutoCollectPicksUps = false;

local Running = {
    Blow = false;
    Sell = false;
    Collect = false;
}

local function UpdateCharacter(character)
    char = character
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    if debug then print("[Debug] Updated Characters Definers") end
end

if plr.Character then
    UpdateCharacter(plr.Character)
end

plr.CharacterAdded:Connect(function(character)
    UpdateCharacter(character)
end)

local function GetWorld(World, Table)
    local island = ws:FindFirstChild("Worlds"):FindFirstChild(World)
    for _, v in ipairs(island.Islands:GetChildren()) do
        if v:IsA("Folder") and v then
            table.insert(Table, v)
            if debug then print("[Debug] Added: ", v, " To Table: ", Table) end
        end
    end
    if debug then print("[Debug] Printing Table: ", Table, "\n", table.concat(table, " | ")) end
end

local function GetCharacter()
    return plr.Character or plr.CharacterAdded:Wait()
end

local function GetHRP()
    local character = GetCharacter()
    return character:WaitForChild("HumanoidRootPart")
end

local function Freeze()
    local root = GetHRP()
    if root then
        root.Anchored = true
    end
end

local function unFreeze()
    local root = GetHRP()
    if root then
        root.Anchored = false
    end
end

function BlowFunc()
    if Running.Blow then return end

    Running.Blow = true;

    local Event = RS:FindFirstChild("Shared").Framework.Network.Remote.RemoteEvent
    while env.AutoBlow == true do
        Event:FireServer("BlowBubble")
        task.wait(0.1)
    end
    Running.Sell = false
end

function SellFunc()
    if Running.Sell then return end

    Running.Sell = true
    local Event = RS:FindFirstChild("Shared").Framework.Network.Remote.RemoteEvent
    while env.AutoSell == true do
        Event:FireServer("SellBubble")
    end
    Running.Sell = false
end

function CollectPickUpsFunc()
    local event = RS.Remotes.Pickups.CollectPickup
    local char = GetCharacter()
    local Pos = char:GetPivot()
    for _, v in ipairs(ws.Rendered:GetChildren()[15]:GetChildren()) do
        if v then
            char:PivotTo(v:GetPivot())
            task.wait(0.1)
        event:FireServer(tostring(v.Name))
            --task.wait(0.2)
            if debug then print("[Debug] Collected: ", v.Name) end
            v:Destroy()
            if debug then print("[Debug] Destroyed: ", v.Name) end
        end
    end
    char:PivotTo(Pos)
    if debug then print("[Debug] Returned Player To Original Position") end
end

function AutoCollectPickUpsFunc()
    if Running.Collect then return end

    Running.Collect = true


    local Event = RS.Remotes.Pickups.CollectPickup

    local function Collect(v)
        if not env.AutoCollectPicksUps or not v:IsA("Instance") then
            return
        end

        local char = GetCharacter()
        if not char then return end

        local Pos = char:GetPivot()

        char:PivotTo(v:GetPivot())
        task.wait(0.1)

        Event:FireServer(tostring(v.Name))
        if debug then print("[Debug] Collected: ", v.Name) end
        v:Destroy()
        if debug then print("[Debug] Destroyed: ", v.Name) end

        local folder = ws.Rendered:GetChildren()[15]
        if not folder then return end

        for _, v in ipairs(folder:GetChildren()) do
            if not env.AutoCollectPicksUps then break end
            Collect(v)
        end

        folder.ChildAdded:Connect(function(v)
            if env.AutoCollectPicksUps then
                task.spawn(Collect, v)
            end
        end)
    end
end

function RedeemCodes()
    local mod = require(RS.Shared.Data.Codes)

    for code, _ in pairs(mod) do
        local Event = RS.Shared.Framework.Network.Remote.RemoteFunction
        Event:InvokeServer("RedeemCode", code)
        if debug then print("[Debug] Redeemed: ", code) end
    end
end

GetWorld("The Overworld", OverWorldIslands)

function TPToIsland(world, island)
    if world then
        if debug then print("[Debug] World: ", world, "Is Found") end
            if island then 
                if debug then print("[Debug] Island: ", island, "Is Found") end
                local Event = RS:FindFirstChild("Shared").Framework.Network.Remote.RemoteEvent

                Event:FireServer("Teleport", "Workspace.Worlds." .. tostring(world) .. ".Islands." .. tostring(island) .. ".Island" .. ".Portal.Spawn")
            else
                if debug then print("[Debug] Island: ", island, "Is not Found") end
            end
        else
            if debug then print("[Debug] World: ", world, "Is Not Found") end
        return
    end
end

function UnlockAllWorlds(world)
    local char = GetCharacter()
    local Pos = char:GetPivot()
    for _, v in ipairs(ws.Worlds:FindFirstChild(world).Islands:GetDescendants()) do
        if v:IsA("Part") and v.Name == "UnlockHitbox" then
            local root = GetHRP()
            Freeze()
            root.Position = v.Position
            task.wait(1)
        end
    end
    char:PivotTo(Pos)
    task.wait(0.1)
    unFreeze()
end

local Window = Airflow:CreateWindow({
    Name = "Bubble Gum Sim ",
    LoadingSubtitle = "by shimixd",
    Icon = "lens",
    Theme = "Default",
    ToggleUIKeybind = "F",
    Size = UDim2.fromOffset(640, 480),
    MinSize = Vector2.new(480, 360),
    MaxSize = Vector2.new(1000, 700),
    MaxNotifications = 4,
    KeepOnScreen = true,
    OpenButton = { Title = "Hub", Icon = "monitor" },
    Loading = {
        Enabled = true,
        Title = "Bubble Gum Simulator",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyHub",
        FileName = "default",
    },
     Home = {
        Name = "Home",
        Stats = {"Game", "Executor", "FPS", "Ping", "Players", "Time"},
        TimeFormat = "%H:%M",
        Pages = {
            {
                Name = "Changelog",
                Icon = "scroll-text",
                Entries = {
                    {Title = "v1.0", Date = "Oct 16, 2026", Content = "Created the Script"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Main",
    Desc = "Bubbles, World & Etc",
    Icon = "globe",
    EmptyText = "Nothing here yet",
})

local Toggle = MainTab:CreateToggle({
    Name = "Auto Blow Bubbles",
    Desc = "Auto Clicks",
    CurrentValue = false,
    Flag = "AutoBlow",
    Callback = function(value)
        if debug then print("[Debug] Auto Blow State: ", value) end
        if value then
            env.AutoBlow = value;
            BlowFunc()
        end
    end,
})

local Toggle = MainTab:CreateToggle({
    Name = "Auto Sell Bubbles",
    Desc = "Auto Sells",
    CurrentValue = false,
    Flag = "AutoBlow",
    Callback = function(value)
        if debug then print("[Debug] Auto Blow State: ", value) end
        if value then
            env.AutoSell = value;
            SellFunc()
        end
    end,
})

local Button = MainTab:CreateButton({
    Name = "Redeem Codes",
    Desc = "",
    Icon = "gift",
    Style = "Primary",
    Callback = function()
        if debug then print("[Debug] Redeemed Codes") end
        RedeemCodes()
    end,
})

local Button = MainTab:CreateButton({
    Name = "Unlock All Worlds",
    Desc = "",
    Icon = "lock-keyhole-open",
    Style = "Primary",
    Callback = function()
        if debug then print("[Debug] Unlocked All Worlds") end
        UnlockAllWorlds("The Overworld")
    end,
})