--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

--https://www.roblox.com/games/133363783004873/Collect-1-Million-Items

local ws = workspace
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char, hum, hrp
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:FindFirstChild("Remotes")
local env = getgenv()
local debug = false
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local leaderstats = plr.leaderstats
local HttpService = game:GetService("HttpService")
local CashUpgrades = {}
local GemsUpgrades = {}
local selectedUpgrades = {
    Cash = {};
    Gems = {};
}
local SortedPushers = {}
local PusherModule = require(RS:FindFirstChild("Others").PusherShop)
local SortedTrails = {}
local TrailsModule = require(RS:FindFirstChild("Others").TrailShop)

env.AutoSell = false;
env.AutoRebirth = false;
env.AutoClaimIndex = false;
env.AutoUpgrade = false;
env.MaxUpgrade = false;
env.AutoPrestige = false;
env.MaxRebirth = false;
env.AutoRoll = false;
env.RollAmount = "One";
env.AutoMerge = false;
env.AutoEquipBest = false;
env.AutoEquipPusher = false;
env.AutoEquipTrail = false;

local Running = {
    Sell = false;
    Rebirth = false;
    ClaimIndex = false;
    Upgrade = false;
    Prestige = false;
    Roll = false;
    Merge = false;
    EquipBest = false;
    EquipPusher = false;
    EquipTrail = false;
}

--[[
 ______   __  __   ___   __    ______  _________  ________  ______   ___   __    ______      
/_____/\ /_/\/_/\ /__/\ /__/\ /_____/\/________/\/_______/\/_____/\ /__/\ /__/\ /_____/\     
\::::_\/_\:\ \:\ \\::\_\\  \ \\:::__\/\__.::.__\/\__.::._\/\:::_ \ \\::\_\\  \ \\::::_\/_    
 \:\/___/\\:\ \:\ \\:. `-\  \ \\:\ \  __ \::\ \     \::\ \  \:\ \ \ \\:. `-\  \ \\:\/___/\   
  \:::._\/ \:\ \:\ \\:. _    \ \\:\ \/_/\ \::\ \    _\::\ \__\:\ \ \ \\:. _    \ \\_::._\:\  
   \:\ \    \:\_\:\ \\. \`-\  \ \\:\_\ \ \ \::\ \  /__\::\__/\\:\_\ \ \\. \`-\  \ \ /____\:\ 
    \_\/     \_____\/ \__\/ \__\/ \_____\/  \__\/  \________\/ \_____\/ \__\/ \__\/ \_____\/ 
                                                                                             
]]

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

for i,v in pairs(PusherModule.Pushers) do
    table.insert(SortedPushers, {Name = i, Price = v})
end

table.sort(SortedPushers, function(a, b)
    return a.Price < b.Price
end)

if debug then
    for _, push in ipairs(SortedPushers) do
        print("[Debug] Pusher: ",push.Name, push.Price)
    end
end

for i, v in pairs(TrailsModule.Trails) do
    if v.Price ~= nil then
        table.insert(SortedTrails, {
        Name = i;
        Price = v.Price;
        })
    end
end

if SortedTrails then
    table.sort(SortedTrails, function(a, b)
        return a.Price < b.Price
    end)
else
    if debug then print("[Debug] Table not found or nil") end
end

if debug then
    for _, trail in ipairs(SortedTrails) do
        print("[Debug] Trail: ", trail.Name, trail.Price)
    end
end

local SellConnection

local function Selling(v)
    if not env.AutoSell then return end
    if not v or not v.Parent then return end

    local Event = Remotes:FindFirstChild("SellItem")
    if not Event then
        if debug then
            warn("[Debug] SellItem remote not found")
        end
        return
    end

    task.wait(0.1)

    if not env.AutoSell or not v.Parent then return end

    local name = v.Name
    local att = v:GetAttribute("SellToken")

    if att == nil then
        if debug then
            warn("[Debug] SellToken missing for:", name)
        end
        return
    end

    Event:FireServer(tostring(name), att)

    if debug then
        print("[Debug] Sent sell request:", name, " With GUID: ",att)
    end

    v:Destroy()
end

function AutoSellFunc()
    if Running.Sell then return end

    local folder = ws:FindFirstChild("LocalItems")

    if not folder then
        if debug then
            warn("[Debug] LocalItems folder not found")
        end
        return
    end

    Running.Sell = true

    if not SellConnection then
        SellConnection = folder.ChildAdded:Connect(function(v)
            if env.AutoSell then
                task.spawn(Selling, v)
            end
        end)
    end

    for _, obj in ipairs(folder:GetChildren()) do
        if not env.AutoSell then break end

        task.spawn(Selling, obj)
        --task.wait(0.1)
    end

    Running.Sell = false
end

function RebirthFunc()
    if Running.Rebirth then return end

    Running.Rebirth = true
    local Event = Remotes.BuyRebirth
    task.spawn(function()
        while env.AutoRebirth == true do
            task.wait(0.5)
            local randomId = HttpService:GenerateGUID(false)
            if debug then print("[Debug] GeneratedGUID: ", randomId) end

            Event:FireServer(randomId, leaderstats.Rebirth.Value, leaderstats.Prestige.Value, env.MaxRebirth)
        end
    end)
    Running.Rebirth = false
end

function PrestigeFunc()
    if Running.Prestige then return end

    Running.Prestige = true
    local Event = Remotes.BuyPrestige
    task.spawn(function()
        while env.AutoPrestige == true do
            task.wait(0.5)
            local randomId = HttpService:GenerateGUID(false)
            if debug then print("[Debug] GeneratedGUID: ", randomId) end

            Event:FireServer(randomId, leaderstats.Rebirth.Value, leaderstats.Prestige.Value, false)
        end
    end)
    Running.Prestige = false
end

function ClaimIndexFunc()
    if Running.ClaimIndex then return end

    Running.ClaimIndex = true
    task.spawn(function()
        while env.AutoClaimIndex == true do
            local Event = Remotes.ClaimIndexReward
            Event:FireServer("ALL")
            task.wait(0.1)
        end
    end)
    Running.ClaimIndex = false;
end

for _, obj in ipairs(plr.PlayerGui.Main.UIFrames.UpgradeFrame.ScrollingFrame:GetChildren()) do
    if obj:IsA("Frame") then
        table.insert(CashUpgrades, obj.Name)
        if debug then print("[Debug] Insreted Cash Upgrade: ", obj.Name) end
    end
end

for _, obj in ipairs(plr.PlayerGui.Main.UIFrames.UpgradeFrame.OtherScrollingFrame.GemUpgradesFrame:GetChildren()) do
    if obj:IsA("Frame") and obj.Name ~= "pass" then
        table.insert(GemsUpgrades, obj.Name)
        if debug then print("[Debug] Insreted Gem Upgrade: ", obj.Name) end
    end
end

if debug then print("[Debug] Current Player's Pusher: ", plr:FindFirstChild("PusherCurrent").Value) end
if debug then print("[Debug] Current Player's Total Collected Items: ", plr:FindFirstChild("leaderstats").Collected.Value) end

if debug then print("[Debug] Current Player's Trail: ", plr:FindFirstChild("TrailCurrent").Value) end
if debug then print("[Debug] Current Player's Cash: ", plr:FindFirstChild("leaderstats").Cash.Value) end

function UpgradeCashFunc()
    if Running.Upgrade then return end

    Running.Upgrade = true
    local Event = Remotes.BuyUpgrade
    task.spawn(function()
        while env.AutoUpgrade do
            task.wait(0.1)
            for _, upg in ipairs(selectedUpgrades.Cash) do
                if not env.AutoUpgrade then
                    if debug then print("[Debug] AutoUgprade is not found nor enabled") end
                    break
                end

                Event:FireServer(upg, env.MaxUpgrade)
                if debug then print("[Debug] Buying Cash Upgrade: ", upg) end

                task.wait(0.2)
            end

            for _, upg in ipairs(selectedUpgrades.Gems) do
                if not env.AutoUpgrade then
                    if debug then print("[Debug] AutoUgprade is not found nor enabled") end
                    break
                end

                Event:FireServer(upg, env.MaxUpgrade)
                if debug then print("[Debug] Buying Gem Upgrade: ", upg) end

                task.wait(0.2)
            end
        end
    end)
    Running.Upgrade = false
end

function RollPetFunc()
    local Event = Remotes.RollPets
    task.spawn(function()
        while env.AutoRoll do
            task.wait(0.5)
            Event:InvokeServer(env.RollAmount)
        end
    end)
end

function AutoMergeFunc()
    if Running.Merge then return end

    Running.Merge = true

    local folder = plr.PetOwned
    local remote = Remotes.MergePets
    task.spawn(function()
        while env.AutoMerge do
            local speciesValues = {}
            local foundPair = false

            for _, numberValue in ipairs(folder:GetChildren()) do
                if not env.AutoMerge then
                    break
                end

                if numberValue:IsA("NumberValue") then
                    local species = numberValue:GetAttribute("Species")

                    if species ~= nil then
                        speciesValues[species] = speciesValues[species] or {}
                        table.insert(speciesValues[species], numberValue)

                        if #speciesValues[species] >= 2 then
                            local values = speciesValues[species]

                            remote:InvokeServer(values[1].Name, values[2].Name, false)
                            if debug then print("[Debug] Merged: " .. tostring(values[1]:GetAttribute("Species"))) end
                            foundPair = true
                            break
                        end
                    end
                end
            end
            task.wait(foundPair and 0.1 or 0.5)
        end
    end)
    Running.Merge = false
end

function EquipBestPetFunc()
    if Running.EquipBest then return end

    Running.EquipBest = true
    local Event = Remotes.EquipPet
    task.spawn(function()
        while env.AutoEquipBest do
            task.wait(2)
            Event:FireServer(nil,"Best")
        end
    end)
end

function EquipBestPusherFunc()
    if Running.EquipPusher then return end

    Running.EquipPusher = true
    local Event = Remotes.EquipPusher
    local CollectedStats = plr:FindFirstChild("leaderstats").Collected
    local PusherEquippedStats = plr:FindFirstChild("PusherCurrent")
    task.spawn(function()
        while env.AutoEquipPusher do
            local Collected = CollectedStats.Value
            local PusherEquipped = PusherEquippedStats.Value
            local CurrentPrice = PusherModule.Pushers[PusherEquipped]
            if debug then print("[Debug] Total: ", Collected, " Current Pusher: ", PusherEquipped) end
            if CurrentPrice then
                for _, pusher in ipairs(SortedPushers) do
                    if pusher.Price > CurrentPrice then
                        if Collected >= pusher.Price then
                            Event:FireServer(pusher.Name)

                            if debug then
                                print("[Debug] Equipped Pusher:", pusher.Name)
                            end
                        elseif debug then
                            print("[Debug] Cannot afford next pusher:", pusher.Name)
                        end
                        break
                    end
                end
            elseif debug then
                warn("[Debug] Unknown current pusher:", PusherEquipped)
            end
            task.wait(0.5)
        end
        Running.EquipPusher = false
    end)
end

function EquipBestTrailFunc()
    if Running.EquipTrail then return end

    Running.EquipTrail = true
    local Event = Remotes.BuyEquipTrail
    local TrailEquippedStats = plr:FindFirstChild("TrailCurrent")
    local CashStats = plr:FindFirstChild("leaderstats")
        and plr.leaderstats:FindFirstChild("Cash")

    task.spawn(function()
        while env.AutoEquipTrail do
            if not TrailEquippedStats or not CashStats then
                warn("[Debug] TrailCurrent or Cash stats not found")
                task.wait(0.5)
                continue
            end

            local Cash = CashStats.Value
            local TrailEquipped = TrailEquippedStats.Value

            -- Safely handle an empty or unknown equipped trail.
            local CurrentTrail = TrailsModule.Trails[TrailEquipped]
            local CurrentPrice = CurrentTrail and CurrentTrail.Price or 0

            if debug then
                print("[Debug] Cash:", Cash, "Current Trail:", TrailEquipped)
            end

            for _, trail in ipairs(SortedTrails) do
                if trail.Price > CurrentPrice then
                    if Cash >= trail.Price then
                        Event:FireServer(trail.Name)

                        if debug then
                            print("[Debug] Equipped Trail:", trail.Name)
                        end
                    elseif debug then
                        print("[Debug] Cannot afford next Trail:", trail.Name)
                    end

                    break
                end
            end

            task.wait(0.5)
        end

        Running.EquipTrail = false
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

local Window = Airflow:CreateWindow({
    Name = "Collect 1 Million Items",
    LoadingSubtitle = "by shimixd",
    Icon = "shopping-cart",
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
        Title = "Collect Million Items",
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
                    {Title = "v1.2", Tag = "Latest", Changes = {"Added Auto Equip Best Pusher", "Added Auto Buy Trails", "Improved Functions and stability"}};
                    {Title = "v1.1", Date = "Oct 18, 2026", Changes = {"Themes", "Fixed Functions", "Added Equip Best", "Added Configs", "Made Faster some Functions"}};
                    {Title = "v1.0", Date = "Oct 17, 2026", Content = "Created the Script | Has world 2 Support"}
                }
            }
        }

    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Main";
    Desc = "Main functions and stuff";
    Icon = "star";
    EmptyText = "Nothing here yet";
})

AutoSellToggle = MainTab:CreateToggle({
    Name = "Auto Sell Items";
    Desc = "Instantly Collects and sells the items";
    CurrentValue = false;
    Flag = "AutoSell";
    Callback = function(state)
        env.AutoSell = state

        if debug then print("[Debug] Auto Sell state: ", state) end

        if state then
            task.spawn(AutoSellFunc)
        end
    end
})

RebirthMaxButton = MainTab:CreateButton({
    Name = "Rebirth Max Buy";
    Desc = "Select to buy 1 rebirth or max";
    Icon = "mouse-pointer-click";
    Style = "";
    Callback = function()
        Airflow:Dialog({
            Title = "Choose";
            Content = "Max or 1 Rebirth";
            Icon = "list";
            CloseOnBackdrop = true;
            Buttons = {
                {Title = "1 Rebirth", Callback = function() env.MaxRebirth = false end},
                {Title = "Max Rebirth", Variant = "Primary", Callback = function() env.MaxRebirth = true end},
            },
        })
    end
})

AutoRebirthToggle = MainTab:CreateToggle({
    Name = "Auto Rebirth";
    Desc = "Automatically Rebirths";
    CurrentValue = false;
    Flag = "AutoRebirth";
    Callback = function(state)
        if debug then print("[Debug] Auto Rebirth state: ", state) end
        env.AutoRebirth = state
        if state then
            task.spawn(RebirthFunc)
        end
    end
})

AutoPrestigeToggle = MainTab:CreateToggle({
    Name = "Auto Prestige";
    Desc = "Automatically Prestiges";
    CurrentValue = false;
    Flag = "AutoPrestige";
    Callback = function(state)
        if debug then print("[Debug] Auto Prestige state: ", state) end
        env.AutoPrestige = state
        if state then
            task.spawn(PrestigeFunc)
        end
    end
})

AutoClaimIndexToggle = MainTab:CreateToggle({
    Name = "Auto Claim Index";
    Desc = "Automatically claims index";
    CurrentValue = false;
    Flag = "ClaimIndex";
    Callback = function(state)
        if debug then print("[Debug] Auto Claim Index state: ", state) end
        env.AutoClaimIndex = state
        if state then
            task.spawn(ClaimIndexFunc)
        end
    end
})

AutoPusherToggle = MainTab:CreateToggle({
    Name = "Auto Pusher";
    Desc = "Equips Best Pusher";
    CurrentValue = false;
    Flag = "PusherBest";
    Callback = function(state)
        if debug then print("[Debug] Auto Pusher state: ", state) end
        env.AutoEquipPusher = state
        if state then
            task.spawn(EquipBestPusherFunc)
        end
    end
})

AutoTrailToggle = MainTab:CreateToggle({
    Name = "Auto Trail";
    Desc = "Buys Best Trail";
    CurrentValue = false;
    Flag = "TrailBest";
    Callback = function(state)
        if debug then print("[Debug] Auto Trail state: ", state) end
        env.AutoEquipTrail = state
        if state then
            task.spawn(EquipBestTrailFunc)
        end
    end
})

local UpgradesTab = Window:CreateTab({
    Name = "Upgrades";
    Desc = "Upgrades";
    Icon = "circle-fading-arrow-up";
    EmptyText = "Nothing here yet";
})

CashUpgradesDropdown = UpgradesTab:CreateDropdown({
    Name = "Select Cash Upgrades";
    Desc = "Options for cash upgrades";
    Options = CashUpgrades;
    MultipleOptions = true;
    CurrentOption = nil;
    Placeholder = "Select Upgrade";
    Flag = "SelectedCashUpg";
    Callback = function(Options)
        selectedUpgrades.Cash = Options

        if debug then print("[Debug] Selected Cash Upgrades: ", table.concat(Options, ", ")) end
    end
})

GemUpgradesDropdown = UpgradesTab:CreateDropdown({
    Name = "Select Gem Upgrades";
    Desc = "Options for Gem upgrades";
    Options = GemsUpgrades;
    MultipleOptions = true;
    CurrentOption = nil;
    Placeholder = "Select Upgrade";
    Flag = "SelectedGemUpg";
    Callback = function(Options)
        selectedUpgrades.Gems = Options

        if debug then print("[Debug] Selected Gems Upgrades: ", table.concat(Options, ", ")) end
    end
})

MaxUpgradeToggle = UpgradesTab:CreateToggle({
    Name = "Max Upgrade";
    Desc = "Upgrades with maximum amount possible";
    CurrentValue = false;
    Flag = "MaxUpgrade";
    Callback = function(state)
        if debug then print("[Debug] Max Upgrade state: ", state) end

        env.MaxUpgrade = state;
    end
})

AutoUpgradeCashToggle = UpgradesTab:CreateToggle({
    Name = "Auto Upgrade Cash";
    Desc = "Automatically buys cash upgrades";
    CurrentValue = false;
    Flag = "CashUpgrades";
    Callback = function(state)
        env.AutoUpgrade = state
        if debug then print("[Debug] Auto Upgrade state: ", state) end
        if state then
            task.spawn(UpgradeCashFunc)
        end
    end
})

local PetsTab = Window:CreateTab({
    Name = "Pets";
    Desc = "Pet rolls and merge";
    Icon = "paw-print";
    EmptyText = "Nothing here yet";
})

RebirthMaxButton = PetsTab:CreateButton({
    Name = "Pets To Roll";
    Desc = "Show many pets to roll";
    Icon = "mouse-pointer-click";
    Style = "";
    Callback = function()
        Airflow:Dialog({
            Title = "Choose";
            Content = "1 or 5";
            Icon = "list";
            CloseOnBackdrop = true;
            Buttons = {
                {Title = "1 Pet | Cost = 2", Callback = function() env.RollAmount = "One" end},
                {Title = "5 Pets | Cost = 10", Variant = "Primary", Callback = function() env.RollAmount = "Five" end},
            },
        })
    end
})

AutoRollPetsToggle = PetsTab:CreateToggle({
    Name = "Auto Roll";
    Desc = "Automatically rolls for pets";
    CurrentValue = false;
    Flag = "AutoRoll";
    Callback = function(state)
        env.AutoRoll = state
        if debug then print("[Debug] Auto Roll state: ", state) end

        if state then
            task.spawn(RollPetFunc)
        end
    end
})

AutoMergePetsToggle = PetsTab:CreateToggle({
    Name = "Auto Merge";
    Desc = "Automatically Merges pets";
    CurrentValue = false;
    Flag = "AutoMerge";
    Callback = function(state)
        env.AutoMerge = state
        if debug then print("[Debug] Auto Merge state: ", state) end

        if state then
            task.spawn(AutoMergeFunc)
        end
    end
})

AutoEquipBestToggle = PetsTab:CreateToggle({
    Name = "Auto Equip best";
    Desc = "Equips best pet";
    CurrentValue = false;
    Flag = "AutoEquip";
    Callback = function(state)
        env.AutoEquipBest = state
        if debug then print("[Debug] Auto Equip Best: ", state) end

        if state then
            task.spawn(EquipBestPetFunc)
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
