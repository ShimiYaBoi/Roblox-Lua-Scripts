local ws = workspace
--local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char, hum, hrp
local debug = false
local RS = game:GetService("ReplicatedStorage")
local env = getgenv()
local OverWorldIslands = {"The Overworld"}
local MGParasideIslands = {}
local SevenSeasIslands = {}
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local Shared = RS:FindFirstChild("Shared")
local SData = Shared.Data
local Framework = Shared.Framework
local Utils = Shared.Utils
local RemoteHandle = Framework.Network.Remote.RemoteEvent
local FunctionHandle = Framework.Network.Remote.RemoteFunction
local Client = RS.Client
local StatsUtil = require(Utils.Stats.StatsUtil)
local localData = require(Client.Framework.Services.LocalData)
local Data = localData:Get()

env.AutoBlow = false;
env.AutoSell = false;
env.AutoCollectPicksUps = false;
env.SellPercent = 50;
env.TelePlace = nil;
env.TOT = false;

local Running = {
    Blow = false;
    Sell = false;
    Collect = false;
    TrickOrTreat = false;
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
            if debug then print("[Debug] Added: ", v, " To ", Table) end
        end
    end
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

    local Event = RemoteHandle
    while env.AutoBlow == true do
        Event:FireServer("BlowBubble")
        task.wait(0.1)
    end
    Running.Blow = false
end

function SellFunc()
    if Running.Sell then return end

    Running.Sell = true

    local Event = RemoteHandle
    while env.AutoSell == true do
        task.wait(0.1)
        if (env.SellPercent/100)*StatsUtil:GetBubbleStorage(Data) <= Data.Bubble.Amount then
            Event:FireServer("SellBubble")
            if debug then print("[Debug] Sold Bubbles with Amount of: ", Data.Bubble.Amount) end
        end
    end
    Running.Sell = false;
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
 --if Running.Collect then return end
    --Running.Collect = true

    local Event = RS.Remotes.Pickups.CollectPickup
    local folder = ws.Rendered:GetChildren()[15]

    if not folder then
        --Running.Collect = false
        return
    end

    local function Collect(v)
        if not env.AutoCollectPicksUps then return end
        if not v:IsA("Model") then return end

        local char = GetCharacter()
        if not char then return end

        local Pos = char:GetPivot()

        char:PivotTo(v:GetPivot())
        task.wait(0.2)

        Event:FireServer(tostring(v.Name))

        if debug then print("[Debug] Collected:", v.Name) end

        v:Destroy()

        if debug then print("[Debug] Destroyed:", v.Name) end

        char:PivotTo(Pos)
    end

    for _, v in ipairs(folder:GetChildren()) do
        if not env.AutoCollectPicksUps then break end
        Collect(v)
        task.wait(0.2)
    end

    folder.ChildAdded:Connect(function(v)
        if env.AutoCollectPicksUps then
            task.spawn(Collect, v)
            task.wait(0.2)
        end
    end)
end

function RedeemCodes()
    local mod = require(RS.Shared.Data.Codes)

    for code, _ in pairs(mod) do
        local Event = FunctionHandle
        Event:InvokeServer("RedeemCode", code)
        if debug then print("[Debug] Redeemed: ", code) end
        task.wait(0.7)
    end
end

function TPToIsland(world, island)
    if world then
        if debug then print("[Debug] World: ", world, "Is Found") end
            if island then 
                if debug then print("[Debug] Island: ", island, "Is Found") end
                local Event = RemoteHandle
                if island == "The Overworld" then
                    Event:FireServer("Teleport", "Workspace.Worlds.The Overworld.PortalSpawn")
                else
                    Event:FireServer("Teleport", "Workspace.Worlds." .. tostring(world) .. ".Islands." .. tostring(island) .. ".Island" .. ".Portal.Spawn")
                end
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

function TrickOrTreatFunc()
    local houseFolder = ws:FindFirstChild("HalloweenEvent").Houses
    if Running.TrickOrTreat then return end
    Running.TrickOrTreat = true
    while env.TOT == true do
        task.wait(2)
        if not houseFolder then
            env.TOT = false;
            Running.TrickOrTreat = false;
            break
        end
        for _, house in ipairs(houseFolder:GetChildren()) do
            if house then
                if debug then print("[Debug] House Found") end
                local Active = house:FindFirstChild("Activation"):FindFirstChild("Active")
                local Ring = Active.Parent.Root
                local root = GetHRP()
                if Active then
                    if debug then print("[Debug] Found Active State: ", Active.Value) end
                    if Active.Value == true then
                        root.Position = Ring.Position
                        task.wait(0.1)
                        RemoteHandle:FireServer("TrickOrTreat", house)
                        task.wait(0.5)
                        if debug then print("[Debug] Collect House", house) end
                    end
                else
                    if debug then print("[Debug] Active is not found,", Active) end
                end
            end
        end
    end
    Running.TrickOrTreat = false;
end

local Window = Airflow:CreateWindow({
    Name = "Bubble Gum Sim ",
    LoadingSubtitle = "by shimixd",
    Icon = "bubbles",
    Theme = "Default",
    ToggleUIKeybind = "R",
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
                    {Title = "v1.2", Date = "Oct 17, 2026", Content = "Added Halloween 2026 Event"},
                    {Title = "v1.1", Date = "Oct 17, 2026", Content = "Rewrote some function and recreated the tabs"},
                    {Title = "v1.0", Date = "Oct 16, 2026", Content = "Created the Script"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local BubbleTab = Window:CreateTab({
    Name = "Bubbles";
    Desc = "Bubbles Automation";
    Icon = "shell";
    EmptyText = "Nothing here yet";
})

SellPercentageSlider = BubbleTab:CreateSlider({
    Name = "Sell %",
    Desc = "Sell when reached % of storage",
    Range = { 1, 100 },
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SellPercent",
    Callback = function(state)
        if debug then print("[Debug] Sell Percentage set to: ", state) end
        env.SellPercent = state
    end,
})

BubbleBlowToggle = BubbleTab:CreateToggle({
    Name = "Auto Blow Bubbles",
    Desc = "",
    CurrentValue = false,
    Flag = "AutoBlow",
    Callback = function(value)
        env.AutoBlow = value

        if debug then
            print("[Debug] Auto Blow State:", value)
        end

        if value then
            task.spawn(BlowFunc)
        end
    end,
})

SellBubbleToggle = BubbleTab:CreateToggle({
    Name = "Auto Sell Bubbles";
    Desc = "";
    CurrentValue = false;
    Flag = "AutoSell";
    Callback = function(state)
        env.AutoSell = state
        if debug then print("[Debug] Auto Sell State: ", state) end
        if state then task.spawn(SellFunc) end
    end;
})

local AutoTab = Window:CreateTab({
    Name = "Automation";
    Desc = "Automation Stuff";
    Icon = "cog";
    EmptyText = "Nothing here yet";
})

UnlockIslandsButton = AutoTab:CreateButton({
    Name = "Unlock All Islands";
    Desc = "Unlocks all islands in the Overworld";
    Icon = "lock-keyhole-open";
    Style = "";
    Callback = function()
        UnlockAllWorlds("The Overworld")
    end
})

AutoCollectPickups = AutoTab:CreateToggle({
    Name = "Auto Collect Pickups";
    Desc = "";
    CurrentValue = false;
    Flag = "CollectPickUps";
    Callback = function(state)
        env.AutoCollectPicksUps = state
        if debug then print("[Debug] Auto Pick up State: ", state) end
        if state then task.spawn(AutoCollectPickUpsFunc) end
    end;
})

CodesButton = AutoTab:CreateButton({
    Name = "Redeem Codes",
    Desc = "",
    Icon = "gift",
    Style = "",
    Callback = function()
        if debug then print("[Debug] Redeemed Codes") end
        RedeemCodes()
    end,
})

CollectButton = AutoTab:CreateButton({
    Name = "Collect Pickups nearby",
    Desc = "Collect Once",
    Icon = "gift",
    Style = "",
    Callback = function()
        if debug then print("[Debug] Collecting Pickups") end
        CollectPickUpsFunc()
    end,
})

local TeleportTab = Window:CreateTab({
    Name = "Teleportation";
    Desc = "Teleport stuff";
    Icon = "move";
    EmptyText = "Nothing here yet";
})

GetWorld("The Overworld", OverWorldIslands)
TeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport To";
    Desc = "Selection of Islands to teleport to";
    Options = OverWorldIslands;
    MultipleOptions = false;
    SearchAfter = 7;
    Flag = "TeleportPlace";
    Callback = function(opt)
        if debug then print("[Debug] Selected Teleport option: ", opt) end
        if opt then
            env.TelePlace = opt
        end
    end
})

TeleportButton = TeleportTab:CreateButton({
    Name = "Teleport";
    Desc = "Teleport to selected location";
    Icon = "mouse-pointer-click";
    Callback = function()
        if debug then print("[Debug] Pressed Teleport \n [Debug] Tried to Teleport to: ", env.TelePlace) end
        TPToIsland("The Overworld", env.TelePlace)
    end
})

local EventTab = Window:CreateTab({
    Name = "Halloween Event";
    Desc = "Halloween 2026 Event tab";
    Icon = "ghost";
    EmptyText = "Nothing here yet";
})

EventTab:CreateButton({
    Name = "Teleport To Event";
    Icon = "mouse-pointer-click";
    Style = "";
    Callback = function()
        RemoteHandle:FireServer("Teleport", "Workspace.HalloweenEvent.Spawn")
    end
})

TrickOrTreatToggle = EventTab:CreateToggle({
    Name = "Auto Trick or Treat";
    Desc = "";
    CurrentValue = false;
    Flag = "TrickOrTreat";
    Callback = function(state)
        env.TOT = state
        if debug then print("[Debug] Auto Trick Or Treat State: ", state) end
        if state then task.spawn(TrickOrTreatFunc) end
    end;
})

local SettingsTab = Window:CreateTab({
    Name = "Settings";
    Desc = "Themes, Keybinds, UI";
    Icon = "settings";
    EmptyText = "Nothing here yet";
})

SettingsTab:CreateButton({
    Name = "Unload Script";
    Icon = "power";
    Style = "Danger";
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?";
            ConfirmText = "Unload";
            Callback = function()
                Window:Destroy()
            end;
        })
    end;
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "R",
    OnChanged = function(Key)
        Window:SetKeybind(Key)
    end,
})

task.wait(1.7)
Notification = Airflow:Notify({
    Title = "Loaded",
    Content = "Airflow UI by Pookie",
    Icon = "check",
    Type = "Success",
    Duration = 4,
})
