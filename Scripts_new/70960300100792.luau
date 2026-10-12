local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char, hum, hrp
local RS = game:GetService("ReplicatedStorage")
local debug = true
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local Remotes = RS:FindFirstChild("Remotes")
local env = getgenv()

env.AutoDropper = false;
env.MaxUpgrade = false;
env.AutoUpgrade1 = false;
env.AutoRebirth = false;
env.AutoUpgrade2 = false;

local Running = {
    Dropper = false;
    AutoUpgrade1 = false;
    Rebirth = false;
    AutoUpgrade2 = false;
}

local CashSelectedUpgrades = {}
local RebirthSelectedUpgrades = {}

local UpgradePrefixes = {
    Cash = {
        ["More Cash"] = "CashMoreCash";
        ["More XP"] = "CashMoreXP";
        ["Faster Button"] = "CashFasterButton"
    },
    RebirthPoints = {
        ["More Cash"] = "RebirthMoreCash";
        ["More XP"] = "RebirthMoreXP";
        ["More RP"] = "RebirthMoreRebirthPoints"
    }
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

function DropFunc()
    task.spawn(function()
        if Running.Dropper then return end

        Running.Dropper = true

        local Event = Remotes:FindFirstChild("DropperClick")

        while env.AutoDropper == true do
            if Event then
                Event:FireServer() 
            else
                if debug then print("[Debug] Remote not found, Disabling...") end
                env.AutoDropper = false;
                Running.Dropper = false;
                return
            end
            task.wait(0.2)
        end
        Running.Dropper = false
    end)
end

function UpgradeFunc(group, upgrade, max)
    local Event = Remotes:FindFirstChild("Upgrade")
    if not Event and debug then print("[Debug] Remote Not Found") end
    if debug then
        print("[Debug] Group: ", group)
        print("[Debug] Option: ", upgrade)
    end
    local upgrades = UpgradePrefixes[group]
    if not upgrades then
        if debug then warn("[Debug] Unknown group: ", group) end
        Airflow:Notify({
            Title = "Error",
            Content = "Upgrades Not found",
            Icon = "x",
            Type = "Error",
            Duration = 4,
        })
        return
    end
    local prefix = upgrades[upgrade]
    if not prefix then
        if debug then warn("[Debug] Unknown option:", upgrade, "in", group) end
        Airflow:Notify({
            Title = "Error",
            Content = "Prefix Not found",
            Icon = "x",
            Type = "Error",
            Duration = 4,
        })
        return
    end
    if debug then
        print("[Debug] Prefix:", prefix)
        print("[Debug] Max:", max)
    end
    Event:FireServer(group, prefix, max)
end

function CreateAutoUpgradeToggle(tab, group, upgrade, toggleId)
    local toggle = tab:CreateToggle({
        Name = "Auto Upgrade",
        Desc = "",
        CurrentValue = false,
        Callback = function(state)
            env[toggleId] = state
            if debug then print("[Debug] Global: ", toggleId, " Switched To: ", state) end

            if not state then
                return
            end

            task.spawn(function()
                if Running[toggleId] then return end

                Running[toggleId] = true
                while env[toggleId] == true do
                    for _, option in ipairs(upgrade()) do
                        if not env[toggleId] then
                            break
                        end

                        local upgrades = UpgradePrefixes[group]
                        local prefix = upgrades and upgrades[option]

                        if prefix then
                            UpgradeFunc(group, option, env.MaxUpgrade)
                        end
                        task.wait(0.2)
                    end
                    if #upgrade() == 0 then
                        task.wait(0.2)
                    end
                end

                Running[toggleId] = false
            end)

        end,
    })
    return toggle
end

function RebirthFunc()
    task.spawn(function()
        if Running.Rebirth then return end

        Running.Rebirth = true
        local Event = Remotes:FindFirstChild("Rebirth")
        if debug and not Event then print("[Debug] Remote not Found") end
        while env.AutoRebirth == true do
            Event:FireServer()
            task.wait(0.2)
        end
        Running.Rebirth = false
    end)
end

local Window = Airflow:CreateWindow({
    Name = "Dropper Incremental",
    LoadingSubtitle = "by shimixd",
    Icon = "gamepad-2",
    Theme = "Default",
    ToggleUIKeybind = "F",
    Size = UDim2.fromOffset(640, 480),
    MinSize = Vector2.new(480, 360),
    MaxSize = Vector2.new(1000, 700),
    MaxNotifications = 4,
    KeepOnScreen = true,
    OpenButton = { Title = "Airflow", Icon = "wind" },
    Loading = {
        Enabled = true,
        Title = "Dropper Incremental",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    Home = { Name = "Home" , Stats = { "FPS", "Ping", "Executor", "Game", "Time", "Uptime" }, TimeFormat = "%H:%M",},
    Parent = game:GetService("CoreGui"),
})

local WorldTab = Window:CreateTab({
    Name = "Cash",
    Desc = "Dropper Upgrades & etc",
    Icon = "box",
    EmptyText = "Nothing here yet",
})

local RebirthTab = Window:CreateTab({
    Name = "Rebirths",
    Desc = "Rebirths Upgrades",
    Icon = "rotate-ccw",
    EmptyText = "Nothing here yet",
})

local Toggle = WorldTab:CreateToggle({
    Name = "Auto Drop",
    Desc = "Triggers Dropper",
    CurrentValue = false,
    Callback = function(state)
        if debug then print("[Debug] Auto Dropper Loop: ", state) end
        env.AutoDropper = state
        if state then
            DropFunc()
        end
    end,
})

local Dropdown = WorldTab:CreateDropdown({
    Name = "Upgrades",
    Desc = "Cash Upgrades",
    Options = { "More Cash", "More XP", "Faster Button"},
    CurrentOption = nil,
    MultipleOptions = true,
    Placeholder = "None",
    SearchAfter = 6,
    Callback = function(Options)
        CashSelectedUpgrades = Options
        if debug then print("[Debug] Selected Cash Upgrades: ", table.concat(CashSelectedUpgrades, ", ")) end
    end,
})

local CashMaxToggle = WorldTab:CreateToggle({
    Name = "Max Upgrade",
    Desc = "Buy Maximum Amount",
    CurrentValue = false,
    Callback = function(state)
        env.MaxUpgrade = state
        if debug then print("[Debug] Max Upgrade State: ", state) end
    end
})

local CashToggle = CreateAutoUpgradeToggle(WorldTab, "Cash", function() return CashSelectedUpgrades end, "AutoUpgrade1")

local Toggle = RebirthTab:CreateToggle({
    Name = "Auto Rebirth",
    Desc = "",
    CurrentValue = false,
    Callback = function(state)
        if debug then print("[Debug] Auto Dropper Loop: ", state) end
        env.AutoRebirth = state
        if state then
            RebirthFunc()
        end
    end,
})

local Dropdown = RebirthTab:CreateDropdown({
    Name = "Upgrades",
    Desc = "Rebirth Upgrades",
    Options = { "More Cash", "More XP", "More RP"},
    CurrentOption = nil,
    MultipleOptions = true,
    Placeholder = "None",
    SearchAfter = 6,
    Callback = function(Options)
        RebirthSelectedUpgrades = Options
        if debug then print("[Debug] Selected Rebirth Upgrades: ", table.concat(RebirthSelectedUpgrades, ", ")) end
    end,
})

local RebirthMaxToggle = RebirthTab:CreateToggle({
    Name = "Max Upgrade",
    Desc = "Buy Maximum Amount",
    CurrentValue = false,
    Callback = function(state)
        env.MaxUpgrade = state
        if debug then print("[Debug] Max Upgrade State: ", state) end
        if state ~= CashMaxToggle:Get() then
            if debug then print("[Debug] Changed State of Cash Max Toggle to: ", state) end
            CashMaxToggle:Set(state)
        end
    end
})

if CashMaxToggle:Get() ~= RebirthMaxToggle:Get() then
    RebirthMaxToggle:Set(CashMaxToggle:Get())
    if debug then print("[Debug] Changed State of Rebirth Max Toggle to: ", CashMaxToggle:Get()) end
end

local RebirthToggle = CreateAutoUpgradeToggle(RebirthTab, "RebirthPoints", function() return RebirthSelectedUpgrades end, "AutoUpgrade2")