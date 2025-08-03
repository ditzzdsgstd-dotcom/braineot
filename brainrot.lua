-- YoxanXHub V2 | Part 1/5 - UI Setup
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players and game.Players.LocalPlayer

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Player = game.Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    Name = "🧠 YoxanXHub | Steal a Brainrot V2",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Welcome to YoxanXHub!",
    ConfigFolder = "YoxanX_Storage"
})

-- Tabs
_G.TabESP = Window:MakeTab({Name = "📍 ESP", Icon = "rbxassetid://4370345144", PremiumOnly = false})
_G.TabSteal = Window:MakeTab({Name = "🧠 Steal", Icon = "rbxassetid://4373433809", PremiumOnly = false})
_G.TabCombat = Window:MakeTab({Name = "⚔️ Combat", Icon = "rbxassetid://13593214401", PremiumOnly = false})
_G.TabBase = Window:MakeTab({Name = "🏠 Base", Icon = "rbxassetid://11324738418", PremiumOnly = false})
_G.TabHop = Window:MakeTab({Name = "🌐 Server Hop", Icon = "rbxassetid://6034287600", PremiumOnly = false})

-- YoxanXHub V2 | Part 2/5 - ESP for Brainrot (by rarity)
local selectedRarity = "Secret"
local runESP = true
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "YoxanX_ESP"

-- Brainrot Data (Name -> Rarity)
local brainrotList = {
    ["Graipuss Medussi"] = "Secret",
    ["La Grande Combinasion"] = "Secret",
    ["Garama and Madundung"] = "Secret",
    ["Gorillo Watermelondrillo"] = "Mythic",
    ["Avocadorilla"] = "Mythic",
    ["Cocofanta Elefanto"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God",
    ["Chimpanzini Bananini"] = "Legendary",
    ["Chef Crabracadabra"] = "Legendary",
    ["Perochello Lemonchello"] = "Epic",
    ["Cappuccino Assassino"] = "Epic",
    ["Bandito Bobritto"] = "Rare",
    ["Ta Ta Ta Ta Sahur"] = "Rare"
    -- Add more as needed
}

-- Create ESP
local function createESP(target, name)
    if target:FindFirstChild("ESP") then return end
    local tag = Instance.new("BillboardGui", target)
    tag.Name = "ESP"
    tag.AlwaysOnTop = true
    tag.Size = UDim2.new(0, 100, 0, 40)
    tag.StudsOffset = Vector3.new(0, 2, 0)

    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "💀 " .. name
    text.TextColor3 = Color3.fromRGB(255, 200, 0)
    text.TextStrokeTransparency = 0.5
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
end

-- ESP Loop
task.spawn(function()
    while runESP do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and not model:FindFirstChild("ESP") and model:FindFirstChild("HumanoidRootPart") then
                local name = model.Name
                local rarity = brainrotList[name]
                if rarity == selectedRarity then
                    createESP(model.HumanoidRootPart, name)
                end
            end
        end
        task.wait(5)
    end
end)

-- UI Dropdown
_G.TabESP:AddDropdown({
    Name = "Brainrot Rarity ESP",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Brainrot God", "Legendary", "Epic", "Rare"},
    Callback = function(option)
        selectedRarity = option
        for _, gui in ipairs(ESPFolder:GetDescendants()) do
            if gui:IsA("BillboardGui") then gui:Destroy() end
        end
    end
})

_G.TabESP:AddToggle({
    Name = "ESP Toggle",
    Default = true,
    Callback = function(state)
        runESP = state
        if not state then
            for _, gui in ipairs(ESPFolder:GetDescendants()) do
                if gui:IsA("BillboardGui") then gui:Destroy() end
            end
        end
    end
})

-- YoxanXHub V2 | Part 3/5 - Smart Server Hop
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local placeId = 109983668079237
local Player = game.Players.LocalPlayer
local selectedHopRarity = "Secret"

local brainrotList = {
    ["Graipuss Medussi"] = "Secret", ["La Grande Combinasion"] = "Secret",
    ["Garama and Madundung"] = "Secret", ["Gorillo Watermelondrillo"] = "Mythic",
    ["Avocadorilla"] = "Mythic", ["Cocofanta Elefanto"] = "Brainrot God",
    ["Espresso Signora"] = "Brainrot God", ["Chimpanzini Bananini"] = "Legendary",
    ["Chef Crabracadabra"] = "Legendary", ["Perochello Lemonchello"] = "Epic",
    ["Cappuccino Assassino"] = "Epic", ["Bandito Bobritto"] = "Rare",
    ["Ta Ta Ta Ta Sahur"] = "Rare"
}

local function getServerList()
    local servers = {}
    local cursor = ""
    repeat
        local response = HttpService:JSONDecode(game:HttpGet(
            ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&limit=100&cursor=%s"):format(placeId, cursor)))
        for _, server in ipairs(response.data) do
            if type(server.players) == "table" then
                table.insert(servers, server)
            end
        end
        cursor = response.nextPageCursor
    until not cursor
    return servers
end

local function hopToBestServer()
    local myJobId = game.JobId
    local servers = getServerList()
    for _, server in ipairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= myJobId then
            TeleportService:TeleportToPlaceInstance(placeId, server.id, Player)
            break
        end
    end
end

_G.TabHop:AddDropdown({
    Name = "Target Rarity (for Server Hop)",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Brainrot God", "Legendary", "Epic", "Rare"},
    Callback = function(value)
        selectedHopRarity = value
    end
})

_G.TabHop:AddButton({
    Name = "🌐 Auto Hop to Rich Server",
    Callback = function()
        OrionLib:MakeNotification({Name = "Server Hop", Content = "Searching servers...", Image = "", Time = 3})
        hopToBestServer()
    end
})

-- YoxanXHub V2 | Part 4/5 - Steal & Base
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local brainrotAbove = nil
local savedBasePos = nil

-- Save Base Position
_G.TabBase:AddButton({
    Name = "📍 Save Base Location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedBasePos = char.HumanoidRootPart.Position
            OrionLib:MakeNotification({Name = "Base Saved", Content = "Your base location has been saved!", Time = 3})
        end
    end
})

-- Teleport to Base (even if locked)
_G.TabBase:AddButton({
    Name = "🏠 Teleport to Saved Base",
    Callback = function()
        if savedBasePos and LocalPlayer.Character and HRP then
            HRP.CFrame = CFrame.new(savedBasePos + Vector3.new(0, 3, 0))
        end
    end
})

-- Anti-Steal Tracker (teleport to thief)
_G.TabBase:AddButton({
    Name = "🛡️ Anti-Steal Track",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local tag = plr.Character.Head:FindFirstChild("BrainrotNameTag")
                if tag then
                    HRP.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
})

-- Instant Steal Logic
RunService.RenderStepped:Connect(function()
    if not HRP then return end
    local char = LocalPlayer.Character
    if not char then return end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            local name = model.Name
            local rarity = brainrotList[name]
            if rarity and model:FindFirstChild("BrainrotNameTag") then
                -- check if brainrot is held by you
                if model:FindFirstChild("Parent") == char then
                    -- teleport immediately to base (CFrame break)
                    if savedBasePos then
                        HRP.CFrame = CFrame.new(savedBasePos + Vector3.new(0, 3, 0))
                    end
                end
            end
        end
    end
end)

-- YoxanXHub V2 | Part 5/5 - Movement Mods
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local noclipEnabled = false
local speedEnabled = true
local jumpEnabled = true
local godEnabled = true

-- Apply Movement Mods
local function applyMods()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        if speedEnabled then hum.WalkSpeed = 200 end
        if jumpEnabled then hum.JumpPower = 100 end
        if godEnabled then root.Anchored = false; root.CFrame = root.CFrame + Vector3.new(0, 0.01, 0) end
    end
end

-- Noclip Toggle
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- Auto Reapply Mods on Respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    applyMods()
end)

-- Buttons
_G.TabCombat:AddToggle({
    Name = "🛡️ Godmode (CFrame Safe)",
    Default = true,
    Callback = function(state)
        godEnabled = state
        applyMods()
    end
})

_G.TabCombat:AddToggle({
    Name = "🏃 Speed 200",
    Default = true,
    Callback = function(state)
        speedEnabled = state
        applyMods()
    end
})

_G.TabCombat:AddToggle({
    Name = "🌀 Jump 100",
    Default = true,
    Callback = function(state)
        jumpEnabled = state
        applyMods()
    end
})

_G.TabCombat:AddToggle({
    Name = "🚪 Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

OrionLib:MakeNotification({
    Name = "YoxanXHub V2 Loaded",
    Content = "Ready To Use.",
    Image = "rbxassetid://4483345998",
    Time = 4
})
