-- Tower Incremental | https://www.roblox.com/games/75766778174856/Tower-Incremental

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:FindFirstChild("Remotes")
local Shared = RS:FindFirstChild("Shared")
local plr = Players.LocalPlayer
local debug = true
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local char, hum, hrp
local env = getgenv()
local UpgradeGroup1 = {"moreMoney", "fasterMoney", "speedBuff"}

env.AutoBuyStairs = false;
env.AutoUpgrade1 = false;
env.SelectedMulti = nil;

local Running = {
    Stairs = false,
    Upgrades1 = false,

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

function BuyStairsFunc()
    if Running.Stairs then return end

    Running.Stairs = true

    local StairsFolder = workspace:FindFirstChild("Stairs")
    local root = GetHRP()

    task.spawn(function()
        while env.AutoBuyStairs == true do
            for _, stair in ipairs(StairsFolder:GetDescendants()) do
                if stair:IsA("Part") and stair:FindFirstChild("TouchInterest") then
                    local stairToBuy = stair
                    local stairIndex = stair:GetAttribute("StairIndex")

                    root.Position = stairToBuy.Position + Vector3.new(0, 2, 0)

                    Remotes:FindFirstChild("BuyStair"):FireServer(stairIndex)
                    if debug then print("[Debug] Current Player Stair: " .. tostring(stairIndex)) end
                end
            end
            task.wait(0.5)
        end
        Running.Stairs = false
    end)
end

function BuyUpgrades1Func()
    task.spawn(function()
        if Running.Upgrades1 then return end

        Running.Upgrades = true

        while env.AutoUpgrade1 == true do
            for _, upg in pairs(UpgradeGroup1) do
                if Remotes and Remotes:FindFirstChild("BuyUpgrade") then
                    if debug then print("[Debug] Fired Upgrade Remote with: " .. upg .. " With Multi: " .. tostring(env.SelectedMulti)) end
                    Remotes:FindFirstChild("BuyUpgrade"):FireServer(upg, env.SelectedMulti)
                end
            end
            task.wait(0.2)
        end

        Running.Upgrades = false
    end)
end

local Window = Airflow:CreateWindow({
    Name = "Tower Incremental",
    LoadingSubtitle = "by shimixd",
    Icon = "chess-rook",
    Theme = "Default",
    ToggleUIKeybind = "F",
    Size = UDim2.fromOffset(640, 480),
    MinSize = Vector2.new(480, 360),
    MaxSize = Vector2.new(1000, 700),
    MaxNotifications = 4,
    KeepOnScreen = true,
    OpenButton = { Title = "UI", Icon = "monitor" },
    Loading = {
        Enabled = true,
        Title = "Tower Incremental",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
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
                    {Title = "v1.1", Tag = "Latest", Changes = {"Tabs"}, {"Functions"}},
                    {Title = "v1.0", Date = "Oct 10, 2026", Content = "Made 1st function | Added UI | located Upgrades and made functions"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
    
})

local AutoFarmTab = Window:CreateTab({
    Name = "Auto Farm",
    Desc = "",
    Icon = "hand-coins",
    EmptyText = "Nothing here yet",
})

local Toggle = AutoFarmTab:CreateToggle({
    Name = "Auto Buy Stairs",
    Desc = "",
    CurrentValue = false,
    Flag = "AutoBuyStairs",
    Callback = function(state)
        env.AutoBuyStairs = state
        if state then
            BuyStairsFunc()
        end
    end,
})

local Button = AutoFarmTab:CreateButton({
    Name = "Buy Multiplier",
    Desc = "Select a buy multiplier",
    Icon = "refresh-cw",
    Style = "Primary",
    Callback = function()
        Airflow:Dialog({
            Title = "Choose",
            Content = "Pick one.",
            Icon = "list",
            CloseOnBackdrop = true,
            Buttons = {
                { Title = "1", Callback = function() env.SelectedMulti = 1 end },
                { Title = "10", Callback = function() env.SelectedMulti = 10 end },
                { Title = "Max", Callback = function() env.SelectedMulti = 0 end },
    },
})
    end,
})

local Toggle = AutoFarmTab:CreateToggle({
    Name = "Auto Buy Upgrades1",
    Desc = "1st upgrade group",
    CurrentValue = false,
    Flag = "AutoBuyUpgrade1",
    Callback = function(state)
        env.AutoUpgrade1 = state
        if state then
            BuyUpgrades1Func()()
        end
    end,
})

if debug then
    local Button = AutoFarmTab:CreateButton({
    Name = "Upgrade",
    Desc = "Testing",
    Icon = "refresh-cw",
    Style = "Primary",
    Callback = function()
        print("clicked")
    end,
})
end
