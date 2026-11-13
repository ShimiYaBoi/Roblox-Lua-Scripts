local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local char,hum,hrp
local debug: boolean = false
local env = getgenv()
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local DebugUsers = {285226551}
local PlayerBase;
local Remotes = ReplicatedStorage:FindFirstChild("Remotes", true)
local FishingShared = require(ReplicatedStorage:WaitForChild("FishingShared", 5))

env.AutoThrowNet = false;
env.AutoRebirth = false;
env.AutoBuyNets = false;
env.AutoCollectCash = false;
env.AutoEquipBest = false;

local Running = {
    NetThrow = false;
    Rebirth = false;
    BuyNets = false;
    CollectCash = false;
    EquipBest = false;
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

local function GetCharacter()
    return plr.Character or plr.CharacterAdded:Wait()
end

local function GetHRP()
    local character = GetCharacter()
    return character:WaitForChild("HumanoidRootPart")
end

local function GetUserId()
    return plr.UserId
end

if table.find(DebugUsers, GetUserId()) then
    debug = true
end

for _, base in ipairs(ws.Map:FindFirstChild("Bases"):GetChildren()) do
    if base:GetAttribute("OwnerUserId") == GetUserId() then
        PlayerBase = base
        if debug then print("[Debug] Found Player's Base: " .. tostring(base)) end
    end
end

function ThrowNetFunc()
    if Running.NetThrow then return end;

    Running.NetThrow = true
    local Event = Remotes.ThrowNet
    while env.AutoThrowNet do
        task.wait(0.1)
        if PlayerBase:GetAttribute("NetState") == "Idle" then
            Event:FireServer()
            if debug then print("[Debug] Net State Changed from 'Idle'") end
            task.wait(1.2)
        else
            if debug then print("[Debug] Net State Is: " .. tostring(PlayerBase:GetAttribute("NetState"))) end
            task.wait(0.5)
        end
    end
    Running.NetThrow = false;
end

function RebirthFunc()
    if Running.Rebirth then return end
    local Event = Remotes.RebirthRequest

    Running.Rebirth = true
    while env.AutoRebirth do
        task.wait(0.1)
        local plrData = Remotes.GetData:InvokeServer()
        if FishingShared.CanRebirth(plrData) then
            if debug then print("[Debug] Can Rebirth, Attempting Rebirth") end
            Event:FireServer()
        end
    end
    Running.Rebirth = false
end

function BuyNets()
    if Running.BuyNets then return end
    local TotalNets = #FishingShared.Nets
    local Event = Remotes.BuyItem

    Running.BuyNets = true
    while env.AutoBuyNets do
        local CurrentNet = plr:GetAttribute("NetTier")
        if CurrentNet <= TotalNets then
            Event:FireServer("Net", CurrentNet+1)
            if debug then print("[Debug] Bought: " .. CurrentNet+1 .. " Tier") end
        end
        task.wait(1)
    end
    Running.BuyNets = false;
end

function CollectCashFunc()
    if Running.CollectCash then return end

    local Event = Remotes.CollectPadReq
    Running.CollectCash = true
    while env.AutoCollectCash do
        task.wait(1.1)
        for i=1, 10 do
            Event:FireServer(i)
        end
    end
    Running.CollectCash = false
end

function AutoEquipBestFunc()
    if Running.EquipBest then return end

    local Event = Remotes.BestSetup
    Running.EquipBest = true
    while env.AutoEquipBest do
        task.wait(2.5)
        Event:FireServer()
    end
    Running.EquipBest = false
end

local Window = Airflow:CreateWindow({
    Name = "Shimi's Hub",
    LoadingSubtitle = "by shimixd",
    Icon = "fish",
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
        Title = "Net A Fish",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Shimi's Hub",
        FileName = "Net A Fish",
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
                    {Title = "v1.0", Date = "---", Content = "Created the Script", "Planning To Update The Hub Later"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Main";
    Desc = "Auto Farm Functions";
    Icon = "fishing-hook";
    EmptyText = "Nothing yet";
})

local SettingsTab = Window:CreateTab({
    Name = "Settings";
    Desc = "Themes, Keybinds, UI";
    Icon = "settings";
    EmptyText = "Nothing here yet";
})

MainTab:Toggle({
    Name = "Auto Throw Net";
    Desc = "Automatically Throws Net";
    Flag = "AutoNet";
    CurrentValue = false;
    Callback = function(state)
        env.AutoThrowNet = state

        if state then
            task.spawn(ThrowNetFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Rebirth";
    Desc = "Automatically Rebirths when Can";
    Flag = "AutoRebirth";
    CurrentValue = false;
    Callback = function(state)
        env.AutoRebirth = state

        if state then
            task.spawn(RebirthFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Collect Cash";
    Desc = "Automatically Collects Cash";
    Flag = "CollectCash";
    CurrentValue = false;
    Callback = function(state)
        env.AutoCollectCash = state

        if state then
            task.spawn(CollectCashFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Equip Best";
    Desc = "Equips Best Fish you have";
    Flag = "AutoFishEquip";
    CurrentValue = false;
    Callback = function(state)
        env.AutoEquipBest = state

        if state then
            task.spawn(AutoEquipBestFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Buy Net";
    Desc = "Automatically Buys the next Net";
    Flag = "BuyNetFlag";
    CurrentValue = false;
    Callback = function(state)
        env.AutoBuyNets = state

        if state then
            task.spawn(BuyNets)
        end
    end
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
                env.AutoThrowNet = false;
                env.AutoRebirth = false;
                env.AutoBuyNets = false;
                env.AutoCollectCash = false;
                env.AutoEquipBest = false;
            end;
        })
    end;
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "F",
    OnChanged = function(Key)
        Window:SetKeybind(Key)
    end,
})

SettingsTab:CreateThemePicker({ Flag = "Theme"})

SettingsTab:CreateConfigManager({ Name = "Configs" })

task.wait(1.7)
Notification = Airflow:Notify({
    Title = "Loaded",
    Content = "Airflow UI by Pookie",
    Icon = "check",
    Type = "Success",
    Duration = 4,
})
