-- YoxanXHub V2.5 | Part 1/5 - UI Setup
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players and game.Players.LocalPlayer

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Player = game.Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    Name = "🧠 YoxanXHub | Steal a Brainrot V2.5",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanXHub is loading...",
    ConfigFolder = "YoxanX_SAB"
})

-- Main Tabs
_G.TabESP = Window:MakeTab({
    Name = "🔍 ESP",
    Icon = "rbxassetid://6031280882",
    PremiumOnly = false
})

_G.TabSteal = Window:MakeTab({
    Name = "🎯 Steal",
    Icon = "rbxassetid://7734035242",
    PremiumOnly = false
})

_G.TabBase = Window:MakeTab({
    Name = "🏠 Base",
    Icon = "rbxassetid://7734016429",
    PremiumOnly = false
})

_G.TabUtility = Window:MakeTab({
    Name = "⚙️ Utility",
    Icon = "rbxassetid://7734053490",
    PremiumOnly = false
})

_G.TabMisc = Window:MakeTab({
    Name = "📦 Misc",
    Icon = "rbxassetid://7734005277",
    PremiumOnly = false
})

-- Notification
OrionLib:MakeNotification({
    Name = "YoxanXHub V2.5",
    Content = "UI loaded. By YoxanXHub.",
    Image = "rbxassetid://7733964641",
    Time = 5
})

-- Discord Invite
_G.TabMisc:AddParagraph("Join Our Discord", "🌐 https://discord.gg/Az8Cm2F6")

-- YoxanXHub V2.5 | Part 2/5 - ESP System
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local rarityFilter = "Secret"
local drawings = {}

local brainrotList = {
    Secret = {"Chimpanzini Spiderini", "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung"},
    Mythic = {"Bombombini Gusini", "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla"},
    Legendary = {"Ballerina Cappuccina", "Chef Crabracadabra", "Lionel Cactuseli"},
    Epic = {"Avocadini Guffo", "Perochello Lemonchello", "Salamino Penguino"},
    Rare = {"Tung Tung Tung Sahur", "Trippi Troppi", "Tric Trac Baraboom"}
}

local function clearESP()
    for _, v in pairs(drawings) do
        if v.Text then v.Text:Remove() end
    end
    drawings = {}
end

local function addESP(obj, text, color)
    local tag = Drawing.new("Text")
    tag.Text = text
    tag.Size = 14
    tag.Center = true
    tag.Outline = true
    tag.Font = 2
    tag.Color = color
    tag.Visible = false
    drawings[#drawings+1] = {Text = tag, Object = obj}
end

local function updateESP()
    clearESP()

    -- Brainrot ESP
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("NameGui") then
            for _, name in pairs(brainrotList[rarityFilter] or {}) do
                if string.find(v.Name, name) then
                    addESP(v, "["..name.."]", Color3.fromRGB(255, 100, 100))
                end
            end
        end
    end

    -- Base Timer ESP
    for _, base in ipairs(Workspace:GetChildren()) do
        if base:IsA("Model") and base:FindFirstChild("Timer") then
            addESP(base, "[Base: "..base.Timer.Value.."s]", Color3.fromRGB(255, 255, 0))
        end
    end

    -- Player ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            addESP(plr.Character, "["..plr.Name.."] "..math.floor(dist).."s", Color3.fromRGB(0, 255, 255))
        end
    end
end

RunService.RenderStepped:Connect(function()
    for _, v in pairs(drawings) do
        if v.Object and v.Object:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Object.HumanoidRootPart.Position)
            v.Text.Position = Vector2.new(pos.X, pos.Y - 20)
            v.Text.Visible = onScreen
        else
            v.Text.Visible = false
        end
    end
end)

-- Auto-refresh
task.spawn(function()
    while task.wait(5) do
        updateESP()
    end
end)

-- Dropdown for rarity filter
_G.TabESP:AddDropdown({
    Name = "Select Brainrot Rarity",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Legendary", "Epic", "Rare"},
    Callback = function(value)
        rarityFilter = value
        updateESP()
    end
})

-- Spectate System
local spectate = nil
local function spectatePlayer(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = plr.Character.Humanoid
    end
end

local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerNames, p.Name) end
end

_G.TabESP:AddDropdown({
    Name = "Spectate Player",
    Default = "",
    Options = playerNames,
    Callback = function(name)
        local target = Players:FindFirstChild(name)
        if target then
            spectatePlayer(target)
        end
    end
})

_G.TabESP:AddButton({
    Name = "Unspectate",
    Callback = function()
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
})

-- YoxanXHub V2.5 | Part 3/5 - Auto Server Hop by Rarity
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetRarity = "Secret"
local PlaceId = 109983668079237
local tryingHop = false

-- Add rarity dropdown
_G.TabUtility:AddDropdown({
    Name = "Hop to Brainrot Rarity",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Legendary", "Epic", "Rare"},
    Callback = function(value)
        targetRarity = value
    end
})

-- Button to force hop manually
_G.TabUtility:AddButton({
    Name = "🔁 Manual Server Hop",
    Callback = function()
        tryingHop = true
        hopToServer()
    end
})

-- Brainrot names by rarity
local brainrotNames = {
    Secret = {"Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung", "Chimpanzini Spiderini"},
    Mythic = {"Bombombini Gusini", "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla"},
    Legendary = {"Ballerina Cappuccina", "Chef Crabracadabra", "Lionel Cactuseli"},
    Epic = {"Avocadini Guffo", "Perochello Lemonchello", "Salamino Penguino"},
    Rare = {"Trippi Troppi", "Tric Trac Baraboom", "Bandito Bobritto"}
}

-- Hop function
function hopToServer()
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&limit=100", PlaceId)
        ))
    end)
    
    if not success then
        warn("Failed to get server list")
        return
    end

    local servers = response.data
    for _, server in pairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
            break
        end
    end
end

-- Check if desired Brainrot exists in current server
function checkServerForRarity()
    local found = false
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("NameGui") then
            for _, name in pairs(brainrotNames[targetRarity]) do
                if string.find(v.Name, name) then
                    found = true
                    break
                end
            end
        end
        if found then break end
    end
    return found
end

-- Auto-hop loop every 10s
task.spawn(function()
    while task.wait(10) do
        if not checkServerForRarity() then
            hopToServer()
        end
    end
end)

-- YoxanXHub V2.5 | Part 4/5 - Movement & Combat System
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local humanoid = nil
local HRP = nil
local float = false
local noclip = false
local godmode = false
local speedBoost = false
local speedValue = 200

local function setupCharacter()
    repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
end

setupCharacter()
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- Anti TP
local lastPos = nil
RunService.Heartbeat:Connect(function()
    if HRP and lastPos then
        local dist = (HRP.Position - lastPos).Magnitude
        if dist > 100 then
            HRP.CFrame = CFrame.new(lastPos)
        end
    end
    if HRP then lastPos = HRP.Position end
end)

-- Godmode (no damage and break respawn)
local function enableGodmode()
    if not LocalPlayer.Character then return end
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Anchored = false
        end
    end
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    HRP.Velocity = Vector3.zero
    HRP.CFrame = HRP.CFrame + Vector3.new(0, 0.1, 0)
end

-- Float Mode
RunService.RenderStepped:Connect(function()
    if float and HRP then
        HRP.Velocity = Vector3.new(0, 25, 0)
    end
end)

-- Speed Toggle
RunService.RenderStepped:Connect(function()
    if speedBoost and humanoid then
        humanoid.WalkSpeed = speedValue
    else
        humanoid.WalkSpeed = 16
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Steal Logic
local function instantSteal()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and string.find(v.Name, "Steal") then
            fireproximityprompt(v)
            task.wait(0.2)
            HRP.CFrame = CFrame.new(_G.savedBase or Vector3.new(0, 15, 0))
            break
        end
    end
end

-- Save base
local function saveBase()
    _G.savedBase = HRP.Position + Vector3.new(0, 5, 0)
    _G.notify("✅ Base saved!")
end

-- Orion Toggles & Buttons
_G.TabCombat:AddToggle({
    Name = "Godmode (CFrameSafe)",
    Default = true,
    Callback = function(state)
        godmode = state
        if state then enableGodmode() end
    end
})

_G.TabCombat:AddToggle({
    Name = "Float Mode",
    Default = false,
    Callback = function(state) float = state end
})

_G.TabCombat:AddToggle({
    Name = "Noclip Mode",
    Default = false,
    Callback = function(state) noclip = state end
})

_G.TabCombat:AddToggle({
    Name = "Speed Boost",
    Default = true,
    Callback = function(state) speedBoost = state end
})

_G.TabCombat:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 300,
    Default = 200,
    Increment = 10,
    Callback = function(value) speedValue = value end
})

_G.TabCombat:AddButton({
    Name = "💾 Save My Base",
    Callback = saveBase
})

_G.TabCombat:AddButton({
    Name = "⚡ Instant Steal",
    Callback = instantSteal
})

-- YoxanXHub V2.5 | Part 5/5 - Utility & UI Polish
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- ⚙️ FPS Counter
local fps = 0
local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
	fps += 1
	if tick() - lastUpdate >= 1 then
		_G.TabUtility:SetName("Utility ⚙️ [FPS: "..fps.."]")
		fps = 0
		lastUpdate = tick()
	end
end)

-- 🧪 Debug Info Button
_G.TabUtility:AddButton({
	Name = "📊 Show Debug Info",
	Callback = function()
		local ping = math.floor(Stats().Network.ServerStatsItem["Data Ping"]:GetValue())
		local plrCount = #Players:GetPlayers()
		_G.notify("📈 Ping: "..ping.." ms\n👥 Players: "..plrCount.."\n🧠 Loaded: V2.5")
	end
})

-- 🔔 Custom Notify Function
_G.notify = function(text)
	local Orion = getgenv().OrionLib
	if Orion and Orion:FindFirstChild("MakeNotification") then
		Orion:MakeNotification({
			Name = "YoxanXHub V2.5",
			Content = text,
			Image = "rbxassetid://7733954760", -- bell icon
			Time = 4
		})
	end
end

-- 💾 Settings Placeholder
_G.TabUtility:AddParagraph("Save/Load Settings", "Coming soon in V3.0...")

OrionLib:Init()
