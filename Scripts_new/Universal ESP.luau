local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))()
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ws = game:GetService("Workspace")
local cam = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local env = getgenv()

local headOff = Vector3.new(0, 0.5, 0)
local legOff = Vector3.new(0, 3, 0)

env.TeamCheck = false;
env.ShowTeammates = false;
env.TeammateColor = Color3.fromRGB(0,255,0);
env.EnemyColor = Color3.fromRGB(255,0,0);

env.BoxEnabled = false;
env.BoxColor = Color3.fromRGB(255, 255, 255);
env.BoxThickness = 2;
env.BoxTransparency = 1;
env.BoxFilled = false;

env.DistanceTextEnabled = false;
env.DistanceTextFont = 0;
env.DistanceTextColor = Color3.fromRGB(255, 255, 255);
env.DistanceTextSize = 20;

env.PlayerNameTextEnabled = false;
env.PlayerNameTextFont = 0;
env.PlayerNameTextColor = Color3.fromRGB(255,255,255);
env.PlayerNameTextSize = 20;

env.TracersEnabled = false;
env.TracersColor = Color3.fromRGB(255,255,255)
env.TracersThickness = 1

env.HeadDotEnabled = false;
env.HeadDotColor = Color3.fromRGB(255,255,255)
env.HeadDotRadius = 10;

local espCache = {}
local connections = {}

local function GetDistance(v)
    return (v.Position - cam.CFrame.Position).Magnitude
end

local function isValidNumber(n)
    return type(n) == "number" and n == n and n ~= math.huge and n ~= -math.huge
end

local function removeBoxESP(plr)
    if espCache[plr] then
        for _, drawing in pairs(espCache[plr]) do
            pcall(function()
                drawing:Remove()
            end)
        end
        espCache[plr] = nil
    end
end

local function createBoxESP(plr)
    if plr == Player then return end

    local Drawings = {
        BoxOutline = Drawing.new("Square");
        Box = Drawing.new("Square");
        DistanceText = Drawing.new("Text");
        PlayerName = Drawing.new("Text");
        Tracers = Drawing.new("Line");
        HeadDot = Drawing.new("Circle");
    }

    Drawings.BoxOutline.Visible = false;
    Drawings.BoxOutline.Color = Color3.new(0, 0, 0)
    Drawings.BoxOutline.Thickness = env.BoxThickness + 1
    Drawings.BoxOutline.Transparency = 1
    Drawings.BoxOutline.Filled = false

    Drawings.Box.Visible = false
    Drawings.Box.Color = env.BoxColor
    Drawings.Box.Thickness = env.BoxThickness or 2
    Drawings.Box.Transparency = env.BoxTransparency or 1
    Drawings.Box.Filled = false

    Drawings.DistanceText.Center = true
    Drawings.DistanceText.Outline = true
    Drawings.DistanceText.Font = env.DistanceTextFont
    Drawings.DistanceText.Color = env.DistanceTextColor
    Drawings.DistanceText.Visible = false

    Drawings.PlayerName.Center = true
    Drawings.PlayerName.Outline = true
    Drawings.PlayerName.Font = env.PlayerNameTextFont
    Drawings.PlayerName.Color = env.PlayerNameTextColor
    Drawings.PlayerName.Visible = false

    Drawings.Tracers.Visible = false
    Drawings.Tracers.Color = env.TracersColor
    Drawings.Tracers.Thickness = env.TracersThickness

    Drawings.HeadDot.Visible = false
    Drawings.HeadDot.Color = env.HeadDotColor
    Drawings.HeadDot.Radius = env.HeadDotRadius
    Drawings.HeadDot.Filled = true


    espCache[plr] = Drawings
end

for _, plr in ipairs(Players:GetPlayers()) do
    createBoxESP(plr)
end

table.insert(connections, Players.PlayerAdded:Connect(createBoxESP))
table.insert(connections, Players.PlayerRemoving:Connect(removeBoxESP))

print("[ESP] Loaded")

table.insert(connections, RunService.RenderStepped:Connect(function()
    for plr, drawings in pairs(espCache) do
        local character = plr.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        local success = false

        if character and humanoid and rootPart and head and humanoid.Health > 0 then
            local rootPos, onScreen = cam:WorldToViewportPoint(rootPart.Position)

            if onScreen and rootPos.Z > 0 and isValidNumber(rootPos.X) and isValidNumber(rootPos.Y) then
                local headPos = cam:WorldToViewportPoint(head.Position + headOff)
                local legPos = cam:WorldToViewportPoint(rootPart.Position - legOff)

                if headPos.Z > 0 and legPos.Z > 0 and isValidNumber(headPos.Y) and isValidNumber(legPos.Y) then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    if isValidNumber(height) and height > 5 and height < 5000 then
                        local size = Vector2.new(width, height)
                        local position = Vector2.new(rootPos.X - size.X / 2, rootPos.Y - size.Y / 2)
                        local headPosition = Vector2.new(headPos.X, headPos.Y)

                        if isValidNumber(position.X) and isValidNumber(position.Y) then
                            success = true
                            if not env.TeamCheck then
                                if env.BoxEnabled == true then
                                    drawings.BoxOutline.Size = size
                                    drawings.BoxOutline.Position = position
                                    drawings.BoxOutline.Visible = true
                                    drawings.BoxOutline.Thickness = env.BoxThickness + 1

                                    drawings.Box.Size = size
                                    drawings.Box.Position = position
                                    drawings.Box.Visible = true
                                    drawings.Box.Color = env.BoxColor
                                    drawings.Box.Thickness = env.BoxThickness
                                    drawings.Box.Transparency = env.BoxTransparency
                                else
                                    drawings.BoxOutline.Visible = false
                                    drawings.Box.Visible = false
                                end

                                if env.DistanceTextEnabled == true then
                                    drawings.DistanceText.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 2)
                                    drawings.DistanceText.Text = math.floor(GetDistance(rootPart)) .. " Studs"
                                    drawings.DistanceText.Color = env.DistanceTextColor
                                    drawings.DistanceText.Font = env.DistanceTextFont
                                    drawings.DistanceText.Size = env.DistanceTextSize
                                    drawings.DistanceText.Visible = true
                                else
                                    drawings.DistanceText.Visible = false
                                end

                                if env.PlayerNameTextEnabled == true then
                                    drawings.PlayerName.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 20)
                                    drawings.PlayerName.Text = plr.Name
                                    drawings.PlayerName.Color = env.PlayerNameTextColor
                                    drawings.PlayerName.Font = env.PlayerNameTextFont
                                    drawings.PlayerName.Size = env.PlayerNameTextSize
                                    drawings.PlayerName.Visible = true
                                else
                                    drawings.PlayerName.Visible = false;
                                end
                                if env.TracersEnabled == true then
                                    drawings.Tracers.Visible = true
                                    drawings.Tracers.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 1)
                                    drawings.Tracers.To = Vector2.new(rootPos.X, rootPos.Y)
                                    drawings.Tracers.Thickness = env.TracersThickness
                                    drawings.Tracers.Color = env.TracersColor
                                else
                                    drawings.Tracers.Visible = false
                                end
                                if env.HeadDotEnabled == true then
                                    drawings.HeadDot.Visible = true
                                    drawings.HeadDot.Position = headPosition
                                    drawings.HeadDot.Color = env.HeadDotColor
                                    drawings.HeadDot.Radius = env.HeadDotRadius
                                else
                                    drawings.HeadDot.Visible = false
                                end
                            else
                                if plr.TeamColor == Player.TeamColor then
                                    if env.ShowTeammates then
                                        if env.BoxEnabled == true then
                                            drawings.BoxOutline.Size = size
                                            drawings.BoxOutline.Position = position
                                            drawings.BoxOutline.Visible = true
                                            drawings.BoxOutline.Thickness = env.BoxThickness + 1

                                            drawings.Box.Size = size
                                            drawings.Box.Position = position
                                            drawings.Box.Visible = true
                                            drawings.Box.Color = env.TeammateColor
                                            drawings.Box.Thickness = env.BoxThickness
                                            drawings.Box.Transparency = env.BoxTransparency
                                        else
                                            drawings.BoxOutline.Visible = false
                                            drawings.Box.Visible = false
                                        end

                                        if env.DistanceTextEnabled == true then
                                            drawings.DistanceText.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 2)
                                            drawings.DistanceText.Text = math.floor(GetDistance(rootPart)) .. " Studs"
                                            drawings.DistanceText.Color = env.TeammateColor
                                            drawings.DistanceText.Font = env.DistanceTextFont
                                            drawings.DistanceText.Size = env.DistanceTextSize
                                            drawings.DistanceText.Visible = true
                                        else
                                            drawings.DistanceText.Visible = false
                                        end

                                        if env.PlayerNameTextEnabled == true then
                                            drawings.PlayerName.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 20)
                                            drawings.PlayerName.Text = plr.Name
                                            drawings.PlayerName.Color = env.TeammateColor
                                            drawings.PlayerName.Font = env.PlayerNameTextFont
                                            drawings.PlayerName.Size = env.PlayerNameTextSize
                                            drawings.PlayerName.Visible = true
                                        else
                                            drawings.PlayerName.Visible = false;
                                        end
                                        if env.TracersEnabled == true then
                                            drawings.Tracers.Visible = true
                                            drawings.Tracers.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 1)
                                            drawings.Tracers.To = Vector2.new(rootPos.X, rootPos.Y)
                                            drawings.Tracers.Thickness = env.TracersThickness
                                            drawings.Tracers.Color = env.TeammateColor
                                        else
                                            drawings.Tracers.Visible = false
                                        end
                                        if env.HeadDotEnabled == true then
                                            drawings.HeadDot.Visible = true
                                            drawings.HeadDot.Position = headPosition
                                            drawings.HeadDot.Color = env.TeammateColor
                                        else
                                            drawings.HeadDot.Visible = false
                                        end
                                    else
                                        drawings.BoxOutline.Visible = false
                                        drawings.Box.Visible = false
                                        drawings.DistanceText.Visible = false
                                        drawings.PlayerName.Visible = false
                                        drawings.Tracers.Visible = false
                                    end
                                elseif plr.TeamColor ~= Player.TeamColor then
                                    if env.BoxEnabled == true then
                                        drawings.BoxOutline.Size = size
                                        drawings.BoxOutline.Position = position
                                        drawings.BoxOutline.Visible = true
                                        drawings.BoxOutline.Thickness = env.BoxThickness + 1

                                        drawings.Box.Size = size
                                        drawings.Box.Position = position
                                        drawings.Box.Visible = true
                                        drawings.Box.Color = env.EnemyColor
                                        drawings.Box.Thickness = env.BoxThickness
                                        drawings.Box.Transparency = env.BoxTransparency
                                    else
                                        drawings.BoxOutline.Visible = false
                                        drawings.Box.Visible = false
                                    end

                                    if env.DistanceTextEnabled == true then
                                        drawings.DistanceText.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 2)
                                        drawings.DistanceText.Text = math.floor(GetDistance(rootPart)) .. " Studs"
                                        drawings.DistanceText.Color = env.EnemyColor
                                        drawings.DistanceText.Font = env.DistanceTextFont
                                        drawings.DistanceText.Size = env.DistanceTextSize
                                        drawings.DistanceText.Visible = true
                                    else
                                        drawings.DistanceText.Visible = false
                                    end

                                    if env.PlayerNameTextEnabled == true then
                                        drawings.PlayerName.Position = Vector2.new(position.X + size.X / 2, position.Y + size.Y + 20)
                                        drawings.PlayerName.Text = plr.Name
                                        drawings.PlayerName.Color = env.EnemyColor
                                        drawings.PlayerName.Font = env.PlayerNameTextFont
                                        drawings.PlayerName.Size = env.PlayerNameTextSize
                                        drawings.PlayerName.Visible = true
                                    else
                                        drawings.PlayerName.Visible = false;
                                    end
                                    if env.TracersEnabled == true then
                                        drawings.Tracers.Visible = true
                                        drawings.Tracers.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 1)
                                        drawings.Tracers.To = Vector2.new(rootPos.X, rootPos.Y)
                                        drawings.Tracers.Thickness = env.TracersThickness
                                        drawings.Tracers.Color = env.EnemyColor
                                    else
                                        drawings.Tracers.Visible = false
                                    end
                                    if env.HeadDotEnabled == true then
                                        drawings.HeadDot.Visible = true
                                        drawings.HeadDot.Position = headPosition
                                        drawings.HeadDot.Color = env.EnemyColor
                                    else
                                        drawings.HeadDot.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not success then
            drawings.BoxOutline.Visible = false
            drawings.Box.Visible = false
            drawings.DistanceText.Visible = false
            drawings.PlayerName.Visible = false
            drawings.Tracers.Visible = false
        end
    end
end))

local Window = Airflow:CreateWindow({
    Name = "Universal ESP",
    LoadingSubtitle = "by shimixd",
    Icon = "scan-eye",
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
        Title = "ESP",
        Text = "Starting",
        Steps = { "Preparing interface", "Loading icons", "Almost there" },
        Duration = 1.6,
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalESP",
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
                    {Title = "v1.0", Tag = "Latest", Content = "Created Box ESP"}
                }
            }
        }
    },
    Parent = game:GetService("CoreGui"),
})

local MainTab = Window:CreateTab({
    Name = "Visuals";
    Desc = "ESP Features";
    Icon = "view";
    EmptyText = "Nothing here yet"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings";
    Desc = "Visual Settings, Unload Script";
    Icon = "settings";
    EmptyText = "Nothing here yet";
})

MainTab:Toggle({
    Name = "Team Check";
    Desc = "Checks if the player is with the LocalPlayer";
    CurrentValue = false;
    Flag = "TeamCheck";
    Callback = function(state)
        env.TeamCheck = state
    end
})

MainTab:Toggle({
    Name = "Show Teammates";
    Desc = "If Team check is Enabled, Show Teammates";
    CurrentValue = false;
    Flag = "ShowTeam8";
    Callback = function(state)
        env.ShowTeammates = state
    end
})

MainTab:Toggle({
    Name = "Box ESP";
    Desc = "Draws Box around the players";
    CurrentValue = false;
    Flag = "BoxESP";
    Callback = function(state)
        env.BoxEnabled = state
    end
})

MainTab:Toggle({
    Name = "Distance";
    Desc = "Distance from the target";
    CurrentValue = false;
    Flag = "DistanceESP";
    Callback = function(state)
        env.DistanceTextEnabled = state
    end
})

MainTab:Toggle({
    Name = "Names";
    Desc = "Player's names";
    CurrentValue = false;
    Flag = "NameESP";
    Callback = function(state)
        env.PlayerNameTextEnabled = state
    end
})

MainTab:Toggle({
    Name = "Tracers";
    Desc = "Player Tracers";
    CurrentValue = false;
    Flag = "TracersESP";
    Callback = function(state)
        env.TracersEnabled = state
    end
})

MainTab:Toggle({
    Name = "Head Dot";
    Desc = "Marks the player's head";
    CurrentValue = false;
    Flag = "HeadDotESP";
    Callback = function(state)
        env.HeadDotEnabled = state
    end
})

SettingsTab:CreateSection("Visuals Settings")

SettingsTab:CreateColorPicker({
    Name = "Enemy Color";
    Desc = "Color of the Enemy";
    Color = env.EnemyColor;
    Flag = "Enemy_Color";
    Callback = function(color)
        env.EnemyColor = color
    end
})

SettingsTab:CreateColorPicker({
    Name = "Teammate Color";
    Desc = "Color of the Teammate";
    Color = env.TeammateColor;
    Flag = "Teammate_Color";
    Callback = function(color)
        env.TeammateColor = color
    end
})

SettingsTab:CreateColorPicker({
    Name = "Box Color";
    Desc = "Color of the Box ESP";
    Color = env.BoxColor;
    Flag = "BoxESP_Color";
    Callback = function(color)
        env.BoxColor = color
    end
})

SettingsTab:CreateSlider({
    Name = "Box Thickness";
    Desc = "Thickness of the box";
    Range = {1, 10};
    Increment = 1;
    CurrentValue = 2;
    Flag = "BoxESP_Thickness";
    Callback = function(v)
        env.BoxThickness = v
    end
})

SettingsTab:CreateColorPicker({
    Name = "Distance Text Color";
    Desc = "Color of the Distance Text ESP";
    Color = env.DistanceTextColor;
    Flag = "DistanceESP_Color";
    Callback = function(color)
        env.DistanceTextColor = color
    end
})

SettingsTab:CreateColorPicker({
    Name = "Player's Name color";
    Desc = "Player Text Color";
    Color = env.PlayerNameTextColor;
    Flag = "NameESP_Color";
    Callback = function(c)
        env.PlayerNameTextColor = c
    end
})

SettingsTab:CreateSlider({
    Name = "Tracers Thickness";
    Desc = "Thickness of the Tracers";
    Range = {1, 5};
    Increment = 0.1;
    CurrentValue = 2;
    Flag = "BoxESP_Thickness";
    Callback = function(v)
        env.TracersThickness = v
    end
})

SettingsTab:CreateColorPicker({
    Name = "Tracers Color";
    Desc = "Tracers Color";
    Color = env.TracersColor;
    Flag = "TracersESP_Color";
    Callback = function(c)
        env.TracersColor = c
    end
})

SettingsTab:CreateColorPicker({
    Name = "Head Dot Color";
    Desc = "HeadDot Color";
    Color = env.HeadDotColor;
    Flag = "HeadDotESP_Color";
    Callback = function(c)
        env.HeadDotColor = c
    end
})

SettingsTab:CreateSlider({
    Name = "Head Dot Radius";
    Desc = "Makes the circle big or small";
    Range = {1, 10};
    Incremental = 1;
    CurrentValue = 5;
    Flag = "HeadDotESP_Radius";
    Callback = function(v)
        env.HeadDotRadius = v
    end
})

SettingsTab:CreateSection("UI Settings")

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
                
                env.BoxEnabled = false
                env.DistanceTextEnabled = false
                env.PlayerNameTextEnabled = false
                env.TracersEnabled = false;
                env.HeadDotEnabled = false;

                for _, conn in ipairs(connections) do
                    if conn.Connected then
                        conn:Disconnect()
                    end
                end
                table.clear(connections)

                for plr, _ in pairs(espCache) do
                    removeBoxESP(plr)
                end
                table.clear(espCache)
            end;
        })
    end;
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "F2",
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
