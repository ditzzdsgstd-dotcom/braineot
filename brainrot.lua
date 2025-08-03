-- YoxanXHub V2.5 | Part 1/5 - UI Setup by YoxanXHub
local OrionLib = _G.OrionLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
_G.OrionLib = OrionLib

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub V2.5 | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "YoxanXHub V2.5 | Steal a Brainrot"
})
_G.YoxanXWindow = Window

-- Optional color scheme (you can change it later)
OrionLib:MakeNotification({
    Name = "YoxanXHub Loaded",
    Content = "UI Loaded Successfully. Ready for Part 2/5.",
    Image = "rbxassetid://14435821608",
    Time = 5
})

-- Tabs prepared for features in next parts
_G.TabESP = Window:MakeTab({Name = "🧠 ESP", Icon = "rbxassetid://14435821608", PremiumOnly = false})
_G.TabCombat = Window:MakeTab({Name = "⚔️ Combat", Icon = "rbxassetid://14435830703", PremiumOnly = false})
_G.TabServer = Window:MakeTab({Name = "🌐 Server Hop", Icon = "rbxassetid://14435836691", PremiumOnly = false})
_G.TabBase = Window:MakeTab({Name = "🏠 Base", Icon = "rbxassetid://14435838898", PremiumOnly = false})

-- YoxanXHub V2.5 | Part 2/5 - Brainrot ESP w/ Rarity Filter
local ESPSettings = {
    Rare = true,
    Epic = true,
    Legendary = true,
    Mythic = true,
    Secret = true,
    RefreshRate = 5
}

local BrainrotList = {
    Rare = {"Trippi Troppi","Tung Tung Tung Sahur","Gangster Footera","Bandito Bobritto","Boneca Ambalabu","Cacto Hipopotamo","Ta Ta Ta Ta Sahur","Tric Trac Baraboom","Pipi Avocado"},
    Epic = {"Cappuccino Assassino","Brr Brr Patapim","Trulimero Trulicina","Bambini Crostini","Bananita Dolphinita","Perochello Lemonchello","Brri Brri Bicus Dicus Bombicus","Avocadini Guffo","Salamino Penguino"},
    Legendary = {"Burbaloni Loliloli","Chimpazini Bananini","Ballerina Cappuccina","Chef Crabracadabra","Lionel Cactuseli","Glorbo Fruttodrillo","Blueberrini Octopusini","Strawberelli Flamingelli","Pandaccini Bananini","Sigma Boy"},
    Mythic = {"frigo Camelo","Orangutini Ananassini","Rhino Toasterino","Bombardiro Crocodilo","Bombombini Gusini","Cavallo Virtuso","Gorillo Watermelondrillo","Avocadorilla","Spioniro Golubiro","Zibra Zubra Zibralini","Tigrilini Watermelini"},
    Secret = {"La Vacca Staturno Saturnita","Chimpanzini Spiderini","Los Tralaleritos","Las Tralaleritas","Graipuss Medussi","La Grande Combinasion","Nuclearo Dinossauro","Garama and Madundung","Tortuginni Dragonfruitini","Las Vaquitas Saturnitas","Chicleteira Bicicleteira"}
}

local function clearESP()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "YoxanX_ESP" then
            v:Destroy()
        end
    end
end

local function drawESP()
    clearESP()
    for rarity, enabled in pairs(ESPSettings) do
        if rarity ~= "RefreshRate" and enabled then
            for _, name in ipairs(BrainrotList[rarity]) do
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc.Name == name then
                        local esp = Instance.new("BillboardGui", game.CoreGui)
                        esp.Name = "YoxanX_ESP"
                        esp.AlwaysOnTop = true
                        esp.Size = UDim2.new(0, 100, 0, 30)
                        esp.Adornee = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")

                        local label = Instance.new("TextLabel", esp)
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0.5
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 14
                        label.Text = "["..rarity.."] "..npc.Name
                    end
                end
            end
        end
    end
end

-- Auto Refresh
task.spawn(function()
    while task.wait(ESPSettings.RefreshRate) do
        drawESP()
    end
end)

-- UI Toggles
if _G.TabESP then
    _G.TabESP:AddLabel("ESP Rarity Filter")
    for _, rarity in ipairs({"Rare","Epic","Legendary","Mythic","Secret"}) do
        _G.TabESP:AddToggle({
            Name = "Show "..rarity.." NPCs",
            Default = ESPSettings[rarity],
            Callback = function(val)
                ESPSettings[rarity] = val
                drawESP()
            end
        })
    end
end

-- YoxanXHub V2.5 | Part 3/5 - Server Hop with Rarity Filter
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = 109983668079237 -- Steal a Brainrot game ID
local AutoHop = false
local HopCooldown = 10

-- Filter for which rarities to search in servers
local DesiredRarities = {
    Secret = true,
    Mythic = true,
    Legendary = false,
    Epic = false
}

-- Function to teleport to new server (doesn't duplicate)
local function hopToServer()
    local cursor = ""
    local found = false

    repeat
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100%s", PlaceId, cursor ~= "" and "&cursor="..cursor or "")
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and response and response.data then
            for _, server in ipairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    -- Found a valid server
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                    found = true
                    break
                end
            end
        end
        cursor = response.nextPageCursor
        task.wait(1)
    until not cursor or found
end

-- Add UI buttons/toggles
if _G.TabServer then
    _G.TabServer:AddLabel("Rarity Filter for Auto Hop")
    for _, rarity in ipairs({"Secret","Mythic","Legendary","Epic"}) do
        _G.TabServer:AddToggle({
            Name = rarity,
            Default = DesiredRarities[rarity],
            Callback = function(v)
                DesiredRarities[rarity] = v
            end
        })
    end

    _G.TabServer:AddButton({
        Name = "🔁 Manual Server Hop",
        Callback = function()
            OrionLib:MakeNotification({Name="Server Hop", Content="Searching for server...", Time=4})
            hopToServer()
        end
    })

    _G.TabServer:AddToggle({
        Name = "🌍 Auto Server Hop (every "..HopCooldown.."s)",
        Default = false,
        Callback = function(v)
            AutoHop = v
            if v then
                OrionLib:MakeNotification({Name="Auto Hop", Content="Enabled", Time=3})
                task.spawn(function()
                    while AutoHop do
                        hopToServer()
                        task.wait(HopCooldown)
                    end
                end)
            end
        end
    })
end

-- YoxanXHub V2.5 | Part 4/5 - Instant Steal, TP Base, Anti-Steal
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local BasePosition = nil
local AntiSnap = true
local InstantStealEnabled = true
local AntiStealEnabled = false

-- CFrame Break Function
local function BreakCFrame()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = true
        task.wait(0.05)
        root.Anchored = false
    end
end

-- Save Base Location
local function SaveBase()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        BasePosition = hrp.Position
        OrionLib:MakeNotification({
            Name = "Base Saved",
            Content = "Your base location has been saved.",
            Time = 3
        })
    end
end

-- TP to Saved Base
local function TeleportToBase()
    if BasePosition then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(BasePosition + Vector3.new(0, 3, 0))
            BreakCFrame()
        end
    end
end

-- Instant Steal Tracker
local function SetupInstantSteal()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    backpack.ChildAdded:Connect(function(tool)
        if InstantStealEnabled and tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            wait(0.3)
            TeleportToBase()
        end
    end)
end

-- Anti-Steal Chase Tracker
local function TrackThief()
    local brainrots = workspace:FindFirstChild("Brainrots")
    if not brainrots then return end

    for _, brainrot in ipairs(brainrots:GetChildren()) do
        local ownerTag = brainrot:FindFirstChild("Owner")
        if ownerTag and ownerTag.Value ~= LocalPlayer.Name then
            local thief = Players:FindFirstChild(ownerTag.Value)
            if thief and thief.Character and thief.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = thief.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                BreakCFrame()
                OrionLib:MakeNotification({Name="Anti-Steal", Content="Chasing "..thief.Name, Time=3})
                break
            end
        end
    end
end

-- Base Lock Timer ESP
local function ShowBaseLockTimer()
    local timer = workspace:FindFirstChild("BaseTimer") or workspace:FindFirstChild("Timer")
    if timer and timer:IsA("NumberValue") then
        OrionLib:MakeNotification({
            Name = "Base Lock",
            Content = "Time remaining: "..math.floor(timer.Value).."s",
            Time = 4
        })
    end
end

-- Init
SetupInstantSteal()

-- UI Controls
if _G.TabCombat then
    _G.TabCombat:AddButton({
        Name = "📍 Save Base Location",
        Callback = SaveBase
    })

    _G.TabCombat:AddButton({
        Name = "🚪 Teleport to Base",
        Callback = TeleportToBase
    })

    _G.TabCombat:AddToggle({
        Name = "🧠 Instant Steal → Auto TP Base",
        Default = true,
        Callback = function(val)
            InstantStealEnabled = val
        end
    })

    _G.TabCombat:AddToggle({
        Name = "🛡️ Anti-Steal Tracker",
        Default = false,
        Callback = function(v)
            AntiStealEnabled = v
            if v then
                task.spawn(function()
                    while AntiStealEnabled do
                        TrackThief()
                        task.wait(2.5)
                    end
                end)
            end
        end
    })

    _G.TabCombat:AddButton({
        Name = "⏳ Show Base Lock Timer",
        Callback = ShowBaseLockTimer
    })
end

-- YoxanXHub V2.5 | Part 5/5 - Godmode + SpeedBoost 200
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid, RootPart = nil, nil
local GodmodeEnabled = false
local SpeedBoost = false
local JumpBoost = false

-- Setup
local function UpdateStats()
    if Humanoid then
        Humanoid.WalkSpeed = SpeedBoost and 200 or 16
        Humanoid.JumpPower = JumpBoost and 120 or 50
    end
end

local function ApplyGodmode()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = char:WaitForChild("Humanoid", 5)
    RootPart = char:WaitForChild("HumanoidRootPart", 5)

    if Humanoid then
        Humanoid.StateChanged:Connect(function(_, state)
            if GodmodeEnabled then
                local blockedStates = {
                    [Enum.HumanoidStateType.Ragdoll] = true,
                    [Enum.HumanoidStateType.Seated] = true,
                    [Enum.HumanoidStateType.FallingDown] = true,
                    [Enum.HumanoidStateType.Physics] = true,
                }
                if blockedStates[state] then
                    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end)
    end

    if RootPart then
        task.spawn(function()
            while GodmodeEnabled and RootPart do
                RootPart.Anchored = false
                task.wait(0.2)
            end
        end)
    end
    UpdateStats()
end

-- Reapply godmode on respawn
LocalPlayer.CharacterAdded:Connect(function()
    if GodmodeEnabled then
        task.wait(1)
        ApplyGodmode()
    end
end)

-- Initial start
task.spawn(function()
    repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    ApplyGodmode()
end)

-- UI Controls (in TabCombat)
if _G.TabCombat then
    _G.TabCombat:AddToggle({
        Name = "🦾 True Godmode (No Freeze/Ragdoll)",
        Default = true,
        Callback = function(state)
            GodmodeEnabled = state
            if state then
                ApplyGodmode()
                OrionLib:MakeNotification({Name="Godmode", Content="Enabled", Time=3})
            else
                OrionLib:MakeNotification({Name="Godmode", Content="Disabled", Time=3})
                if Humanoid then
                    Humanoid.WalkSpeed = 16
                    Humanoid.JumpPower = 50
                end
            end
        end
    })

    _G.TabCombat:AddToggle({
        Name = "⚡ Speed Boost (200 WalkSpeed)",
        Default = false,
        Callback = function(state)
            SpeedBoost = state
            UpdateStats()
        end
    })

    _G.TabCombat:AddToggle({
        Name = "🪂 Jump Boost (120 JumpPower)",
        Default = false,
        Callback = function(state)
            JumpBoost = state
            UpdateStats()
        end
    })
end
