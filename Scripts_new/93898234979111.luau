--[[
 __       ______   ______   ________   __       ______       ________   ___   __    ______       _______    __       ______    _______   ________   __       ______      
/_/\     /_____/\ /_____/\ /_______/\ /_/\     /_____/\     /_______/\ /__/\ /__/\ /_____/\     /______/\  /_/\     /_____/\ /_______/\ /_______/\ /_/\     /_____/\     
\:\ \    \:::_ \ \\:::__\/ \::: _  \ \\:\ \    \::::_\/_    \::: _  \ \\::\_\\  \ \\:::_ \ \    \::::__\/__\:\ \    \:::_ \ \\::: _  \ \\::: _  \ \\:\ \    \::::_\/_    
 \:\ \    \:\ \ \ \\:\ \  __\::(_)  \ \\:\ \    \:\/___/\    \::(_)  \ \\:. `-\  \ \\:\ \ \ \    \:\ /____/\\:\ \    \:\ \ \ \\::(_)  \/_\::(_)  \ \\:\ \    \:\/___/\   
  \:\ \____\:\ \ \ \\:\ \/_/\\:: __  \ \\:\ \____\_::._\:\    \:: __  \ \\:. _    \ \\:\ \ \ \    \:\\_  _\/ \:\ \____\:\ \ \ \\::  _  \ \\:: __  \ \\:\ \____\_::._\:\  
   \:\/___/\\:\_\ \ \\:\_\ \ \\:.\ \  \ \\:\/___/\ /____\:\    \:.\ \  \ \\. \`-\  \ \\:\/.:| |    \:\_\ \ \  \:\/___/\\:\_\ \ \\::(_)  \ \\:.\ \  \ \\:\/___/\ /____\:\ 
    \_____\/ \_____\/ \_____\/ \__\/\__\/ \_____\/ \_____\/     \__\/\__\/ \__\/ \__\/ \____/_/     \_____\/   \_____\/ \_____\/ \_______\/ \__\/\__\/ \_____\/ \_____\/ 
                                                                                                                                                                         
]]

local env = getgenv and getgenv() or _G

env.ShimiHubSession = (env.ShimiHubSession or 0) + 1
local currentSession = env.ShimiHubSession

if type(env.ShimiHubUnload) == "function" then
    pcall(env.ShimiHubUnload)
end

env.ShimiHubLoaded = true
env.ShimiHubConnections = {}

local function TrackConnection(conn: RBXScriptConnection)
    table.insert(env.ShimiHubConnections, conn)
    return conn
end

local function IsActiveSession(): boolean
    return env.ShimiHubLoaded == true and env.ShimiHubSession == currentSession
end

local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local char, hum, hrp
local debug: boolean = false
local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local DebugUsers = {285226551}
local PlayerBase
local Remotes = ReplicatedStorage:FindFirstChild("Remotes", true)
local FishingShared = require(ReplicatedStorage:WaitForChild("FishingShared", 5))
local SkillTree = require(ReplicatedStorage:WaitForChild("SkillTree", 5))
local SpearsUpgradesList, selectedSpearsUpgradesList = {}, {}
local HelperUpgradesList, selectedHelperUpgradesList = {}, {}
local BoatUpgradesList, selectedBoatUpgradesList = {"Hull"}, {}
local UpgradesList = {}
local selectedFishingUpgrades, selectedMarketUpgrades, selectedShowcaseUpgrades = {}, {}, {}
local NetBranch, LuckBranch, CrewBranch, FortuneBranch = {}, {}, {}, {}

env.AutoThrowNet = false
env.AutoRebirth = false
env.AutoBuyNets = false
env.AutoCollectCash = false
env.AutoEquipBest = false
env.AutoSpearUpgrades = false
env.AutoHelperUpgrades = false
env.AutoClaimIndex = false
env.AutoFishingUpgrades = false
env.AutoMarketUpgrade = false
env.AutoSkillTreeUpgrade = false;
env.SelectedSkillTree = nil;
env.AutoBoatUpgrades = false;
env.AutoMegFight = false;
env.AutoBloopFight = false;

local Running = {
    NetThrow = false,
    Rebirth = false,
    BuyNets = false,
    CollectCash = false,
    EquipBest = false,
    SpearUpgrades = false,
    HelperUpgrades = false,
    ClaimIndex = false,
    FishingUgprades = false,
    MarketUpgrades = false,
    SkillTree = false;
    BoatUpgrades = false;
    MegFight = false;
    BloopFight = false;
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
    if not IsActiveSession() then return end
    char = character
    hum = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    if debug then print("[Debug] Updated Characters Definers") end
end

if plr.Character then
    UpdateCharacter(plr.Character)
end

TrackConnection(plr.CharacterAdded:Connect(function(character)
    if not IsActiveSession() then return end
    UpdateCharacter(character)
end))

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

function DebugPrint(msg: any, msgType: string?)
    if debug then
        msgType = msgType or "Info"
        local format = "[Debug | " .. tostring(msgType) .. "] " .. tostring(msg)

        if msgType == "Warning" then
            warn(format)
        else
            print(format)
        end
    end
end

for _, base in ipairs(ws.Map:FindFirstChild("Bases"):GetChildren()) do
    if base:GetAttribute("OwnerUserId") == GetUserId() then
        PlayerBase = base
        DebugPrint("Found Player's Base: " .. tostring(base))
    end
end

for _, t in ipairs(FishingShared.Spear.Upgrades) do
    for name, value in pairs(t) do
        if name == "Id" then
            table.insert(SpearsUpgradesList, value)
            DebugPrint("Spear Upgrade Added: " .. value)
        end
    end
end

for _, t in ipairs(FishingShared.Helper.Upgrades) do
    for name, value in pairs(t) do
        if name == "Id" then
            table.insert(HelperUpgradesList, value)
            DebugPrint("Fishermen Upgrade Added: " .. value)
        end
    end
end

for _, t in ipairs(FishingShared.Upgrades) do
    local tab = t.Tab

    if not UpgradesList[tab] then
        UpgradesList[tab] = {}
    end

    table.insert(UpgradesList[tab], t.Id)
end

for _, t in ipairs(FishingShared.Boat.Upgrades) do
    for name, value in pairs(t) do
        if name == "Id" then
            table.insert(BoatUpgradesList, value)
        end
    end
end
DebugPrint("Boat Upgrades Table: " .. table.concat(BoatUpgradesList, " | "))

function GetValidPlayerData()
    while IsActiveSession() do
        local success, data = pcall(function()
            return Remotes.GetData:InvokeServer()
        end)

        if success and data and data.Helper then
            return data
        end

        task.wait(0.5)
    end
    return nil
end

function ThrowNetFunc()
    if Running.NetThrow then return end

    Running.NetThrow = true
    local Event = Remotes.ThrowNet
    while IsActiveSession() and env.AutoThrowNet do
        task.wait(0.1)
        if not IsActiveSession() or not env.AutoThrowNet then break end
        if PlayerBase:GetAttribute("NetState") == "Idle" then
            Event:FireServer()
            if debug then print("[Debug] Net State Changed from 'Idle'") end
            task.wait(1.2)
        else
            if debug then print("[Debug] Net State Is: " .. tostring(PlayerBase:GetAttribute("NetState"))) end
            task.wait(0.5)
        end
    end
    Running.NetThrow = false
end

function RebirthFunc()
    if Running.Rebirth then return end
    local Event = Remotes.RebirthRequest

    Running.Rebirth = true
    while IsActiveSession() and env.AutoRebirth do
        task.wait(0.1)
        if not IsActiveSession() or not env.AutoRebirth then break end
        local plrData = GetValidPlayerData()
        if not plrData or not IsActiveSession() or not env.AutoRebirth then break end
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
    while IsActiveSession() and env.AutoBuyNets do
        local CurrentNet = plr:GetAttribute("NetTier")
        if CurrentNet <= TotalNets then
            Event:FireServer("Net", CurrentNet + 1)
            if debug then print("[Debug] Bought: " .. CurrentNet + 1 .. " Tier") end
        end
        task.wait(1)
    end
    Running.BuyNets = false
end

function CollectCashFunc()
    if Running.CollectCash then return end

    Running.CollectCash = true
    while IsActiveSession() and env.AutoCollectCash do
        if PlayerBase then
            local root = GetHRP()
            local savedPos = root.Position
            local Pedastal = PlayerBase:FindFirstChild("Pedestals", true)
            if Pedastal then
                if debug then print("[Debug] Pedastal Found") end
                for _, v in ipairs(Pedastal:GetChildren()) do
                    if not IsActiveSession() or not env.AutoCollectCash then break end
                    local pad = v:FindFirstChild("Pad", true)
                    if pad then
                        root.Position = pad.Position
                        task.wait(0.2)
                        if debug then print("[Debug] Collected Pedestal: " .. tostring(v:GetAttribute("Slot"))) end
                    end
                end
                if IsActiveSession() and root and root.Parent then
                    root.Position = savedPos
                end
            end
        else
            env.AutoCollectCash = false
            Running.CollectCash = false
            if debug then warn("[Debug] Player base not Found - Check Locator") end
            return
        end
        task.wait(60)
    end
    Running.CollectCash = false
end

function AutoEquipBestFunc()
    if Running.EquipBest then return end

    local Event = Remotes.BestSetup
    Running.EquipBest = true
    while IsActiveSession() and env.AutoEquipBest do
        task.wait(2.5)
        if not IsActiveSession() or not env.AutoEquipBest then break end
        Event:FireServer()
    end
    Running.EquipBest = false
end

function UpgradeSpears()
    if Running.SpearUpgrades then return end

    Running.SpearUpgrades = true
    local Event = Remotes.SpearAction
    while IsActiveSession() and env.AutoSpearUpgrades do
        for _, id in ipairs(selectedSpearsUpgradesList) do
            if not IsActiveSession() or not env.AutoSpearUpgrades then break end
            if table.find(selectedSpearsUpgradesList, id) then
                Event:InvokeServer("buy", id)
            end
        end
        task.wait(0.1)
    end
    Running.SpearUpgrades = false
end

function UpgradeHelper()
    if Running.HelperUpgrades then return end

    Running.HelperUpgrades = true
    local Event = Remotes.HelperAction
    while IsActiveSession() and env.AutoHelperUpgrades do
        local plrData = GetValidPlayerData()
        if not plrData or not IsActiveSession() or not env.AutoHelperUpgrades then break end
        for _, id in ipairs(selectedHelperUpgradesList) do
            if not IsActiveSession() or not env.AutoHelperUpgrades then break end
            if table.find(selectedHelperUpgradesList, id) then
                if FishingShared.HelperLevelOk(plrData, id, plrData.Helper[tostring(tostring(id))] + 1) then
                    Event:InvokeServer("buy", id)
                end
            end
        end
        task.wait(0.1)
    end
    Running.HelperUpgrades = false
end

function ClaimIndexFunc()
    if Running.ClaimIndex then return end

    Running.ClaimIndex = true
    local Event = Remotes.Rewards
    while IsActiveSession() and env.AutoClaimIndex do
        task.wait(2)
        if not IsActiveSession() or not env.AutoClaimIndex then break end
        Event:InvokeServer("claimMutSetAll")
    end
    Running.ClaimIndex = false
end

function UpgradeFishingTab()
    if Running.FishingUgprades then return end

    Running.FishingUgprades = true
    local Event = Remotes.BuyItem
    while IsActiveSession() and env.AutoFishingUpgrades do
        local plrData = GetValidPlayerData()
        if not plrData or not IsActiveSession() or not env.AutoFishingUpgrades then break end
        for _, id in ipairs(selectedFishingUpgrades) do
            if not IsActiveSession() or not env.AutoFishingUpgrades then break end
            if table.find(selectedFishingUpgrades, id) then
                if FishingShared.UpgradeLevelOk(plrData, FishingShared.UpgradeById[tostring(id)], plrData.Upgrades[tostring(id)] + 1) then
                    Event:FireServer("Upgrade", tostring(id))
                end
            end
        end
        task.wait(0.1)
    end
    Running.FishingUgprades = false
end

function UpgradeMarketTab()
    if Running.MarketUpgrades then return end

    Running.MarketUpgrades = true
    local Event = Remotes.BuyItem
    while IsActiveSession() and env.AutoMarketUpgrade do
        local plrData = GetValidPlayerData()
        if not plrData or not IsActiveSession() or not env.AutoMarketUpgrade then break end
        for _, id in ipairs(selectedMarketUpgrades) do
            if not IsActiveSession() or not env.AutoMarketUpgrade then break end
            if table.find(selectedMarketUpgrades, id) then
                if FishingShared.UpgradeLevelOk(plrData, FishingShared.UpgradeById[tostring(id)], plrData.Upgrades[tostring(id)] + 1) then
                    Event:FireServer("Upgrade", tostring(id))
                end
            end
        end
        task.wait(0.1)
    end
    Running.MarketUpgrades = false
end

local BranchTables = {
    Net = NetBranch,
    Luck = LuckBranch,
    Fortune = FortuneBranch,
    Crew = CrewBranch
}

for _, node in ipairs(SkillTree.Nodes) do
    local branch = BranchTables[node.Branch]

    if branch then
        table.insert(branch, node.Id)
    end
end

function TreeUpgradeFunc(branch)
    if Running.SkillTree then return end

    Running.SkillTree = true
    local Event = Remotes.SkillTree
    while IsActiveSession() and env.AutoSkillTreeUpgrade do
        local plrData = GetValidPlayerData()
        if not plrData or not IsActiveSession() or not env.AutoSkillTreeUpgrade then break end
        if not env.SelectedSkillTree then
            env.AutoSkillTreeUpgrade = false;
            Running.SkillTree = false;
            DebugPrint("Skill Tree not Selected", "Warning")
            break;
        end
        for _, id in ipairs(env.SelectedSkillTree) do
            task.wait(0.6)
            if SkillTree.canBuy(plrData, id) then
                Event:InvokeServer("buy", tostring(id))
                DebugPrint("Bought: " .. id)
            else
                DebugPrint("Couldn't Buy: " .. id, "Warning")
                DebugPrint(SkillTree.canBuy(plrData, id), "Warning")
            end
        end
    end
    Running.SkillTree = false;
end

DebugPrint("Skill Tree Net Branch: " .. table.concat(NetBranch, " | "))
DebugPrint("Skill Tree Luck Branch: " .. table.concat(LuckBranch, " | "))
DebugPrint("Skill Tree Fortune Branch: " .. table.concat(FortuneBranch, " | "))
DebugPrint("Skill Tree Crew Branch: " .. table.concat(CrewBranch, " | "))

function BoatUpgradeFunc()
    if Running.BoatUpgrades then return end

    Running.BoatUpgrades = true
    local Event = Remotes.BoatAction
    while IsActiveSession() and env.AutoBoatUpgrades do
        for _, id in ipairs(selectedBoatUpgradesList) do
            if not IsActiveSession() or not env.AutoBoatUpgrades then break end
            if table.find(selectedBoatUpgradesList, id) then
                Event:InvokeServer("buy", tostring(id))
            end
        end
        task.wait(0.5)
    end
    Running.BoatUpgrades = false;
end

function FightMegalodonFunc()
    if Running.MegFight then return end

    Running.MegFight = true
    local Event = Remotes.MegEvent

    while env.AutoMegFight and IsActiveSession() do
        if not ws:GetAttribute("MegActive") then
            DebugPrint("Megalodon is not Active, Waiting", "Warning")

            repeat task.wait(2) until ws:GetAttribute("MegActive")
            if not env.AutoMegFight then break end
        end
        local Meg = ws.MegalodonLocal:WaitForChild("Megalodon")
        Event:FireServer("fire", Meg.Position + Vector3.new(2, 0, 0))
        task.wait(0.3)
    end
    Running.MegFight = false
end

function FightBloopFunc()
    if Running.BloopFight then return end

    Running.BloopFight = true
    local Event = Remotes.BloopEvent
    while env.AutoBloopFight and IsActiveSession() do
        if not ws:GetAttribute("BloopActive") then
            DebugPrint("Bloop Is not Active, Waiting", "Warning")
            repeat task.wait(2) until ws:GetAttribute("BloopActive")
        end
        local Bloop = ws.BloopLocal:WaitForChild("Bloop")
        Event:FireServer("fire", Bloop.Position + Vector3.new(2,0,0))
        task.wait(0.3)
    end
    Running.BloopFight = false;
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
    Name = "Shimi's Hub",
    LoadingSubtitle = "by shimixd",
    Icon = "fish",
    Theme = "Default",
    ToggleUIKeybind = "F2",
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
                    {Title = "v1.3", Tag = "Latest", Changes = {"Rewrote Script Loading Functions | Better Execution and Loader check", "Added Auto Skill Tree Upgrades + Auto Boat Upgrades", "Added Megalodon and Bloop Auto Fights"}}, -- 20.11.26
                    {Title = "v1.2", Date = "18th Nov, 2026", Changes = {"Improved Auto Upgrade Function For Fisherman and Spear Gun", "Added More Auto Upgrades + Auto Claim Index"}},
                    {Title = "v1.1", Date = "14th Nov, 2026", Changes = {"Fixed Auto Collect Cash", "Added Auto Upgrades"}},
                    {Title = "v1.0", Date = "13th Nov, 2026", Content = "Created the Script, Planning To Update The Hub Later"}
                }
            }
        }
    },
    Parent = game:GetService("CoreGui"),
})

env.ShimiHubUnload = function()
    env.ShimiHubLoaded = false

    env.AutoThrowNet = false
    env.AutoRebirth = false
    env.AutoBuyNets = false
    env.AutoCollectCash = false
    env.AutoEquipBest = false
    env.AutoSpearUpgrades = false
    env.AutoHelperUpgrades = false
    env.AutoClaimIndex = false
    env.AutoFishingUpgrades = false
    env.AutoMarketUpgrade = false
    env.AutoSkillTreeUpgrade = false;
    env.AutoBoatUpgrades = false;
    env.AutoMegFight = false;
    env.AutoBloopFight = false;

    if type(env.ShimiHubConnections) == "table" then
        for _, conn in ipairs(env.ShimiHubConnections) do
            if typeof(conn) == "RBXScriptConnection" and conn.Connected then
                conn:Disconnect()
            end
        end
        table.clear(env.ShimiHubConnections)
    end

    if Window then
        pcall(function()
            Window:Destroy()
        end)
        Window = nil
    end
end

local MainTab = Window:CreateTab({
    Name = "Main",
    Desc = "Auto Farm Functions",
    Icon = "fishing-hook",
    EmptyText = "Nothing yet",
})

local UpgradesTab = Window:CreateTab({
    Name = "Upgrades",
    Desc = "Auto Upgrades Menu",
    Icon = "arrow-up",
    EmptyText = "Nothing here yet",
})

local BattlesTab = Window:CreateTab({
    Name = "Battles",
    Desc = "Auto Fights and Events";
    Icon = "sword";
    EmptyText = "Nothing here yet";
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Desc = "Themes, Keybinds, UI",
    Icon = "settings",
    EmptyText = "Nothing here yet",
})

MainTab:Toggle({
    Name = "Auto Throw Net",
    Desc = "Automatically Throws Net",
    Flag = "AutoNet",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoThrowNet = state

        if state then
            task.spawn(ThrowNetFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Rebirth",
    Desc = "Automatically Rebirths when Can",
    Flag = "AutoRebirth",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoRebirth = state

        if state then
            task.spawn(RebirthFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Collect Cash",
    Desc = "Automatically Collects Cash",
    Flag = "CollectCash",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoCollectCash = state

        if state then
            task.spawn(CollectCashFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Equip Best",
    Desc = "Equips Best Fish you have",
    Flag = "AutoFishEquip",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoEquipBest = state

        if state then
            task.spawn(AutoEquipBestFunc)
        end
    end
})

MainTab:Toggle({
    Name = "Buy Net",
    Desc = "Automatically Buys the next Net",
    Flag = "BuyNetFlag",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoBuyNets = state

        if state then
            task.spawn(BuyNets)
        end
    end
})

MainTab:Toggle({
    Name = "Auto Claim Index",
    Desc = "Automatically Claims Index",
    Flag = "ClaimIndex",
    CurrentValue = false,
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoClaimIndex = state

        if state then
            task.spawn(ClaimIndexFunc)
        end
    end
})

UpgradesTab:CreateDropdown({
    Name = "Spear Upgrades",
    Desc = "What Upgrades to buy",
    Options = SpearsUpgradesList,
    CurrentOption = nil,
    MultipleOptions = true,
    SearchAfter = 5,
    Flag = "SpearUpgradesList",
    Callback = function(opt)
        if not IsActiveSession() then return end
        selectedSpearsUpgradesList = opt

        if debug then print("[Debug] Selected Spear Upgrade(s): " .. table.concat(selectedSpearsUpgradesList, ", ")) end
        if #selectedSpearsUpgradesList == 0 then
            env.AutoSpearUpgrades = false
            if debug then print("[Debug] Disabled Auto Spear Upgrade") end
        else
            if debug then print("[Debug] Enabled Auto Spear Upgrade") end
            env.AutoSpearUpgrades = true
            task.spawn(UpgradeSpears)
        end
    end
})

UpgradesTab:CreateDropdown({
    Name = "Fisherman Upgrades",
    Desc = "What Upgrades to buy",
    Options = HelperUpgradesList,
    CurrentOption = nil,
    MultipleOptions = true,
    SearchAfter = 5,
    Flag = "HelperUpgradesList",
    Callback = function(opt)
        if not IsActiveSession() then return end
        selectedHelperUpgradesList = opt

        if debug then print("[Debug] Selected Helper Upgrade(s): " .. table.concat(selectedHelperUpgradesList, ", ")) end
        if #selectedHelperUpgradesList == 0 then
            env.AutoHelperUpgrades = false
            if debug then print("[Debug] Disabled Auto Helper Upgrades") end
        else
            if debug then print("[Debug] Enabled Auto Helper Upgrades") end
            env.AutoHelperUpgrades = true
            task.spawn(UpgradeHelper)
        end
    end
})

UpgradesTab:CreateDropdown({
    Name = "Boat Upgrades",
    Desc = "Boat Upgrades and Boat Unlocks",
    Options = BoatUpgradesList,
    CurrentOption = nil,
    MultipleOptions = true,
    SearchAfter = 5,
    Flag = "BoatUpgradesList",
    Callback = function(opt)
        if not IsActiveSession() then return end
        selectedBoatUpgradesList = opt

        DebugPrint("Selected boat Upgrades: " .. table.concat(selectedBoatUpgradesList, " | "))
        if #selectedBoatUpgradesList == 0 then
            env.AutoBoatUpgrades = false
            DebugPrint("Disabling Boat Upgrades")
        else
            DebugPrint("Enabling Boat Upgrades")
            env.AutoBoatUpgrades = true
            task.spawn(BoatUpgradeFunc)
        end
    end
})

UpgradesTab:Dropdown({
    Name = "Fishing Tab Upgrades",
    Desc = "Fishing Upgrades",
    Options = UpgradesList["Fishing"],
    CurrentOption = {},
    MultipleOptions = true,
    SearchAfter = 4,
    Flag = "FishingTabUpgrades",
    Callback = function(opt)
        if not IsActiveSession() then return end
        selectedFishingUpgrades = opt

        if #selectedFishingUpgrades == 0 then
            env.AutoFishingUpgrades = false
        else
            env.AutoFishingUpgrades = true
            task.spawn(UpgradeFishingTab)
        end
    end
})

UpgradesTab:Dropdown({
    Name = "Market Tab Upgrades",
    Desc = "Market Upgrades",
    Options = UpgradesList["Market"],
    CurrentOption = {},
    MultipleOptions = true,
    SearchAfter = 4,
    Flag = "MarketTabUpgrades",
    Callback = function(opt)
        if not IsActiveSession() then return end
        selectedMarketUpgrades = opt

        if #selectedMarketUpgrades == 0 then
            env.AutoMarketUpgrade = false
        else
            env.AutoMarketUpgrade = true
            task.spawn(UpgradeMarketTab)
        end
    end
})

UpgradesTab:Dropdown({
    Name = "Skill tree Upgrade";
    Desc = "Select Node to upgrade";
    Options = {"Net", "Luck", "Fortune", "Crew"};
    CurrentOption = {};
    MultipleOptions = false;
    Flag = "BranchTreeUpgrade";
    Callback = function(opt)
        if not IsActiveSession() then return end
        if opt == "Net" then env.SelectedSkillTree = NetBranch end
        if opt == "Luck" then env.SelectedSkillTree = LuckBranch end
        if opt == "Fortune" then env.SelectedSkillTree = FortuneBranch end
        if opt == "Crew" then env.SelectedSkillTree = CrewBranch end

        if opt then
            DebugPrint(tostring(opt) .. " Is Selected")
            env.AutoSkillTreeUpgrade = true;
            task.spawn(TreeUpgradeFunc, env.SelectedSkillTree)
        else
            DebugPrint("Nothing Selected in Skill Tree")
            env.AutoSkillTreeUpgrade = false;
        end
    end
})

BattlesTab:CreateParagraph({
    Title = "Kraken & Pirates Fight";
    Content = "Kraken & Pirates are fought using the net, Enable 'Auto net' for The kraken and Pirate fights"
})

BattlesTab:Toggle({
    Name = "Megalodon Fight";
    Desc = "Automatically Fires at the Megalodon at the maximum Range possible";
    CurrentValue = false;
    Flag = "MegFightFlag";
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoMegFight = state

        if state then
            task.spawn(FightMegalodonFunc)
        end
    end
})

BattlesTab:Toggle({
    Name = "Bloop Fight";
    Desc = "Automatically Fires at the Bloop at the maximum Range possible";
    CurrentValue = false;
    Flag = "BloopFightFlag";
    Callback = function(state)
        if not IsActiveSession() then return end
        env.AutoBloopFight = state

        if state then
            task.spawn(FightBloopFunc)
        end
    end
})

if debug then
    SettingsTab:Toggle({
        Name = "Debug";
        Desc = "Debug Logs";
        CurrentValue = true;
        Flag = "debug";
        Callback = function(s)
            debug = s
        end
    })
end

SettingsTab:CreateButton({
    Name = "Unload Script",
    Icon = "power",
    Style = "Danger",
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?",
            ConfirmText = "Unload",
            Callback = function()
                if type(env.ShimiHubUnload) == "function" then
                    env.ShimiHubUnload()
                end
            end,
        })
    end,
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "F2",
    OnChanged = function(Key)
        if not IsActiveSession() or not Window then return end
        Window:SetKeybind(Key)
    end,
})

SettingsTab:CreateThemePicker({ Flag = "Theme" })

SettingsTab:CreateConfigManager({ Name = "Configs" })

task.wait(1.7)
if IsActiveSession() then
    Notification = Airflow:Notify({
        Title = "Loaded",
        Content = "Airflow UI by Pookie",
        Icon = "check",
        Type = "Success",
        Duration = 4,
    })
end