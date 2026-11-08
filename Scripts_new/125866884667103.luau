local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char,hum,hrp
local debug = false
local env = getgenv()
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
local plot = plr:GetAttribute("assignedPlot")
local currentPlot = ws:FindFirstChild("Plots"):FindFirstChild(plot)
local UpgradeButtons = currentPlot:FindFirstChild("Buttons")
local SellButtons = currentPlot:FindFirstChild("Sell")

local amount = nil

env.AutoCollectFish = false;
env.AutoUpgrade = false;
env.AutoDeposit = false;
env.AutoUpgradeChef = false;
env.AutoCollectMoney = false;
env.AutoMerge = false;

local Running = {
    CollectFish = false;
    Upgrade = false;
    Deposit = false;
    UpgradeChef = false;
    CollectMoney = false;
    Merge = false;
}

    if debug then print("[Debug] Player Plot Attribute: ", plot) end
if currentPlot then
    if debug then print("[Debug] Current Plot Found In Workspace") end
else
    if debug then warn("[Debug] Current plot not Found in Workspace")
end

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

local CollectConnection

local function Collecting(v)
    if not env.AutoCollectFish then return end

    if not v then
        warn("[Debug] v is NIL")
        return
    end

    if not v.Parent then
        warn("[Debug] v has no Parent")
        return
    end

    local Hit = v:FindFirstChild("Hitbox", true)
    if not Hit then
        warn("[Debug] Hitbox missing")
        return
    end

    local Event = Remotes:FindFirstChild("LootPickup")
    if not Event then
        warn("[Debug] LootPickup missing")
        return
    end

    local lootTier = Hit:GetAttribute("LootTier")
    if lootTier == nil then
        warn("[Debug] LootTier missing")
        return
    end

    task.wait(0.1)

    if not v.Parent then
        warn("[Debug] Object was removed before collection")
        return
    end

    Event:FireServer({lootTier}, false)

    if v.Parent then
        v:Destroy()
    end
end

function AutoCollectFishFunc()
    if Running.CollectFish then return end

    local fishFolder = ws:FindFirstChild("ClientLoot")

    if not fishFolder then
        if debug then
            print("[Debug] Fish Collect Folder not Found")
        end
        return
    end

    Running.CollectFish = true

    if not CollectConnection then
        CollectConnection = fishFolder.ChildAdded:Connect(function(v)
            if env.AutoCollectFish then
                task.spawn(Collecting, v)
            end
        end)
    end

    for _, obj in ipairs(fishFolder:GetChildren()) do
        if not env.AutoCollectFish then break end

        task.spawn(Collecting, obj)
    end

    Running.CollectFish = false
end

function AutoBuyFishermen()
    if Running.Upgrade then return end

    Running.Upgrade = true
    local root = GetHRP()
    while env.AutoUpgrade do
        if amount ~= nil then
            if amount == 1 then
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy1").Button, root, false)
                task.wait()
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy1").Button, root, true)
            elseif amount == 5 then
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy5").Button, root, false)
                task.wait()
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy5").Button, root, true)
            elseif amount == 25 then
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy25").Button, root, false)
                task.wait()
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy25").Button, root, true)
            elseif amount == 100 then
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy100").Button, root, false)
                task.wait()
                firetouchinterest(UpgradeButtons:FindFirstChild("ButtonBuy100").Button, root, true)
            end
        else
            Airflow:Notify({
                Title = "Error";
                Content = "Fishermen Amount is not Selected";
                Icon = "circle-x";
                Type = "Error";
                Duration = 4
            })
            env.AutoUpgrade = false;
            Running.Upgrade = false;
            break
        end
    end
    Running.Upgrade = false;
end

function AutoCollectMoneyFunc()
    if Running.CollectMoney then return end

    Running.CollectMoney = true
    while env.AutoCollectMoney do
        local root = GetHRP()
        local Button = SellButtons:FindFirstChild("CollectButton").Button

        firetouchinterest(Button, root, false)
        task.wait()
        firetouchinterest(Button, root, true)
    end
    Running.CollectMoney = false
end

function AutoDepositFunc()
    if Running.Deposit then return end

    Running.Deposit = true
    while env.AutoDeposit do
        local root = GetHRP()
        local Button = SellButtons:FindFirstChild("DepositButton").Button

        firetouchinterest(Button, root, false)
        task.wait()
        firetouchinterest(Button, root, true)
    end
    Running.Deposit = false;
end

function AutoUpgradeChefFunc()
    if Running.UpgradeChef then return end

    Running.UpgradeChef = true
    while env.AutoUpgradeChef do
        local root = GetHRP()
        local Button = SellButtons.UpgradeButton.Button

        firetouchinterest(Button, root, false)
        task.wait()
        firetouchinterest(Button, root, true)
    end
end

function MergeFunc()
    if Running.Merge then return end

    Running.Merge = true
    while env.AutoMerge do
        local root = GetHRP()
        local Button = UpgradeButtons:FindFirstChild("ButtonMerge").Button

        firetouchinterest(Button, root, false)
        task.wait()
        firetouchinterest(Button, root, true)
    end
end

local Window = Airflow:CreateWindow({
    Name = "Sell a Million Sushi",
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
        Title = "Sell Million Sushi",
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
                    {Title = "v1.0", Tag = "Latest", Content = "Might Update it if there are new features"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Main";
    Desc = "Auto Farm";
    Icon = "star";
    EmptyText = "nothing here yet";
})

MainTab:CreateToggle({
    Name = "Auto Collect Fish";
    Desc = "Collecting Fish automatically";
    CurrentValue = false;
    Flag = "CollectFish";
    Callback = function(state)
        env.AutoCollectFish = state

        if state then
            task.spawn(AutoCollectFishFunc)
        end
    end
})

MainTab:CreateDropdown({
    Name = "Buy Amount";
    Desc = "How many Fishermen to buy";
    Options = {1,5,25,100};
    CurrentOption = nil;
    MultipleOptions = false;
    Flag = "Fishermen_Amount";
    Callback = function(option)
        amount = option
    end
})

MainTab:CreateToggle({
    Name = "Auto Buy Fishermen";
    Desc = "Automatically buys Fishermen amount selected";
    CurrentValue = false;
    Flag = "FisherMenUpgrade";
    Callback = function(state)
        env.AutoUpgrade = state

        if state then
            task.spawn(AutoBuyFishermen)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Collect Money";
    Desc = "Automatically Collects Money";
    CurrentValue = false;
    Flag = "CollectCash";
    Callback = function(state)
        env.AutoCollectMoney = state

        if state then
            task.spawn(AutoCollectMoneyFunc)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Deposit Fish";
    Desc = "Automatically Deposits Fish";
    CurrentValue = false;
    Flag = "DepositFish";
    Callback = function(state)
        env.AutoDeposit = state

        if state then
            task.spawn(AutoDepositFunc)
        end
    end
})

--[[MainTab:CreateToggle({
    Name = "Auto Upgrade Chef";
    Desc = "Automatically Upgrades Chef";
    CurrentValue = false;
    Flag = "UpgradeChef";
    Callback = function(state)
        env.AutoUpgradeChef = state

        if state then
            task.spawn(AutoUpgradeChefFunc)
        end
    end
})]]

MainTab:CreateToggle({
    Name = "Auto Merge";
    Desc = "Automatically Merges";
    CurrentValue = false;
    Flag = "Merge";
    Callback = function(state)
        env.AutoMerge = state

        if state then
            task.spawn(MergeFunc)
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
                env.AutoCollectFish = false;
                env.AutoUpgrade = false;
                env.AutoDeposit = false;
                env.AutoUpgradeChef = false;
                env.AutoCollectMoney = false;
                env.AutoMerge = false;
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
