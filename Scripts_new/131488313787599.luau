local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char,hum,hrp
local debug = false
local env = getgenv()
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage:WaitForChild("Shared", 10).Remotes)
local State = require(plr.PlayerScripts:FindFirstChild("Client", true).State)
local RebirthReady = plr.PlayerGui.HUD.Menu.Tiles.Rebirth
local Shared = ReplicatedStorage:FindFirstChild("Shared", true)
local Formulas = require(Shared.Formulas)

env.PerfectShot = false;
env.AutoRebirth = false;
env.AutoEquipBest = false;
env.AutoBuyBestGun = false;
env.AutoBuySlots = false

local Running = {
    PerfectBullet = false;
    Rebirth = false;
    EquipBest = false;
    BuyGun = false;
    Slots = false;
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

function PerfectShotFunc()
    if Running.PerfectBullet then return end

    Running.PerfectBullet = true
    while env.PerfectShot do
        local Event1 = Remotes.Get("BeginShot")
        local Event2 = Remotes.Get("FireShot")

        Event1:InvokeServer()
        if debug then print("[Debug] Initiating Shot") end
        task.wait(0.5)
        Event2:InvokeServer(Event1:InvokeServer().Token,1)
        if debug then print("[Debug] Initiating FireEvent with Token: " .. tostring(Event1:InvokeServer().Token)) end
    end
    Running.PerfectBullet = false;
end

local rebirthConnection = nil

function AutoRebirthFunc()
    if rebirthConnection then
        rebirthConnection:Disconnect()
        rebirthConnection = nil
    end

    if not env.AutoRebirth then
        Running.Rebirth = false
        return
    end

    if Running.Rebirth then return end
    Running.Rebirth = true

    local Event = ReplicatedStorage.Remotes.Action

    if RebirthReady:GetAttribute("Ready") then
        Event:InvokeServer("Rebirth")
    end

    rebirthConnection = RebirthReady:GetAttributeChangedSignal("Ready"):Connect(function()
        if debug then print("[Debug] Rebirth Attribute: ", RebirthReady:GetAttribute("Ready")) end
        
        if not env.AutoRebirth then
            AutoRebirthFunc()
            return
        end

        if RebirthReady:GetAttribute("Ready") then
            Event:InvokeServer("Rebirth")
        end
    end)
end

function AutoEquipBestFunc()
    if Running.EquipBest then return end

    Running.EquipBest = true
    while env.AutoEquipBest do
        local Event = ReplicatedStorage.Remotes.Action
        task.wait(2)
        Event:InvokeServer("EquipBest")
    end
    Running.EquipBest = false
end

function BuyGunFunc()
    if Running.BuyGun then return end

    Running.BuyGun = true
    while env.AutoBuyBestGun do
        local Data = State.Data
        local Gun;
        local Event = ReplicatedStorage.Remotes.Action
        if Data then
            Gun = Formulas.NextGun(Data);
        else
            Gun = Data
        end

        if Gun and Data.Cash >= Gun.Cost then
            Event:InvokeServer("BuyGun")
            if debug then print("[Debug] Bought Next Gun") end
            task.wait(0.5)
        else
            if debug then print("[Debug] Cannot Afford Next Gun") end
        end
        task.wait(1)
    end
    Running.BuyGun = false;
end

function BuySlotsFunc()
    if Running.Slots then return end

    Running.Slots = true
    local Event = ReplicatedStorage.Remotes.Action
    while env.AutoBuySlots do
        Event:InvokeServer("BuySlot")
        task.wait(2)
    end
    Running.Slots = false
end

local Window = Airflow:CreateWindow({
    Name = "Bullet Vs Everything",
    LoadingSubtitle = "by shimixd",
    Icon = "target",
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
        Title = "Shimi's Hub",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Template",
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
                    {Title = "v1.3", Tag = "Latest", Changes = "Fixed Auto Rebirth", "Added Auto buy slots", "Fixed Hub Titles"};
                    {Title = "v1.2", Date = "Nov 8th", Changes = "Added Auto Buy Guns"};
                    {Title = "v1.1", Date = "Nov 4th", Changes = "Added Auto Shot", "Added Auto Rebirth"};
                    {Title = "v1.0", Date = "Nov 2nd", Content = "Created The script with Simple Functions"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Farm";
    Desc = "Auto Farm";
    Icon = "star";
    EmptyText = "Nothing here yet"
})

MainTab:Toggle({
    Name = "Perfect Shot";
    Desc = "Shoots at the perfect score";
    CurrentValue = false;
    Flag = "Perfect_Shot";
    Callback = function(state)
        env.PerfectShot = state
        if debug then print("[Debug] Perfect Shot State: ", state) end
        if state then
            task.spawn(PerfectShotFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Rebirth";
    Desc = "Automatically Rebirths";
    CurrentValue = false;
    Flag = "AutoRebirth";
    Callback = function(state)
        env.AutoRebirth = state
        if debug then print("[Debug] Auto Rebirth State: ", state) end
        task.spawn(AutoRebirthFunc)
    end
})

MainTab:Toggle({
    Name = "Auto Equip Best";
    Desc = "Equip best props for the range";
    CurrentValue = false;
    Flag = "EquipBest";
    Callback = function(state)
        env.AutoEquipBest = state
        if debug then print("[Debug] Auto Equip State: ", state) end
        if state then
            task.spawn(AutoEquipBestFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Buy Gun";
    Desc = "Automatically Buys next Gun";
    CurrentValue = false;
    Flag = "BestGun";
    Callback = function(state)
        env.AutoBuyBestGun = state
        if debug then print("[Debug] Auto Best Gun: ", state) end
        if state then
            task.spawn(BuyGunFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Slots Gun";
    Desc = "Automatically Buys Slots";
    CurrentValue = false;
    Flag = "SlotsBuy";
    Callback = function(state)
        env.AutoBuySlots = state
        if debug then print("[Debug] Auto Buy Slots: ", state) end
        if state then
            task.spawn(BuySlotsFunc)
        end
    end
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
                env.PerfectShot = false;
                env.AutoRebirth = false;
                env.AutoEquipBest = false;
                env.AutoBuyBestGun = false;
                Window:Destroy()
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
