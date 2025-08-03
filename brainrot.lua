-- YoxanXHub V2.5 | Part 1/3 - No Key, UI Setup
repeat task.wait() until game:IsLoaded()

if not _G.OrionLib then
    _G.OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
end

local OrionLib = _G.OrionLib

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub V2.5 | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanXHub V2.5",
    IntroIcon = "rbxassetid://7733960981",
    Icon = "rbxassetid://7733960981"
})

_G.YoxanXWindow = Window -- Allow other parts to access the same window

-- Create empty tabs for the next parts to fill
Window:MakeTab({ Name = "ESP", Icon = "rbxassetid://7734053494", PremiumOnly = false })
Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://7734053494", PremiumOnly = false })
Window:MakeTab({ Name = "Server Hop", Icon = "rbxassetid://7734053494", PremiumOnly = false })
Window:MakeTab({ Name = "Base", Icon = "rbxassetid://7734053494", PremiumOnly = false })

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "V2.5 UI Loaded. Type 2/3 to continue.",
    Time = 6
})

-- YoxanXHub V2.5 | Part 2/3 - ESP + Server Hop
local OrionLib = _G.OrionLib
local Window = _G.YoxanXWindow
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Brainrot Data by Rarity
local BrainrotList = {
    ["Secret"] = {
        "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas", "Graipuss Medussi", "La Grande Combinasion",
        "Nuclearo Dinossauro", "Garama and Madundung", "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas",
        "Chicleteira Bicicleteira", "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas"
    },
    ["Mythic"] = {
        "Frigo Camelo", "Orangutini Ananassini", "Rhino Toasterino", "Bombardiro Crocodilo", "Bombombini Gusini",
        "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla"
    },
    ["Legendary"] = {
        "Burbaloni Loliloli", "Chimpazini Bananini", "Ballerina Cappuccina", "Chef Crabracadabra", "Lionel Cactuseli",
        "Glorbo Fruttodrillo", "Blueberrini Octopusini", "Strawberelli Flamingelli", "Pandaccini Bananini",
        "Sigma Boy"
    }
}

-- ESP Core
local DrawingESP = {}
local selectedRarity = "Secret"

local function clearESP()
    for _, v in ipairs(DrawingESP) do
        if v.obj then
            v.obj:Remove()
        end
    end
    table.clear(DrawingESP)
end

local function createESP()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Head") then
            for _, name in ipairs(BrainrotList[selectedRarity] or {}) do
                if v.Name:lower():find(name:lower()) then
                    local tag = Drawing.new("Text")
                    tag.Text = "[" .. name .. "]"
                    tag.Size = 16
                    tag.Color = Color3.new(1, 1, 0)
                    tag.Center = true
                    tag.Outline = true
                    tag.Visible = false

                    table.insert(DrawingESP, {
                        model = v,
                        obj = tag
                    })
                end
            end
        end
    end
end

-- ESP updater (runs every 5s)
task.spawn(function()
    while true do
        for _, item in ipairs(DrawingESP) do
            if item.model and item.model:FindFirstChild("Head") then
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(item.model.Head.Position)
                item.obj.Position = Vector2.new(pos.X, pos.Y)
                item.obj.Visible = visible
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        createESP()
        task.wait(5)
    end
end)

-- Server Hop Logic
local function hopToBestServer()
    OrionLib:MakeNotification({ Name = "YoxanXHub", Content = "Scanning servers...", Time = 4 })
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/109983668079237/servers/Public?limit=100"))
    end)

    if success and servers.data then
        local bestServer = nil
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers then
                if server.id ~= game.JobId then
                    bestServer = server.id
                    break
                end
            end
        end
        if bestServer then
            OrionLib:MakeNotification({ Name = "Server Hop", Content = "Teleporting to better server...", Time = 3 })
            task.wait(2)
            game:GetService("TeleportService"):TeleportToPlaceInstance(109983668079237, bestServer)
        else
            OrionLib:MakeNotification({ Name = "Server Hop", Content = "No better server found.", Time = 4 })
        end
    else
        OrionLib:MakeNotification({ Name = "Server Hop", Content = "Failed to fetch servers.", Time = 4 })
    end
end

-- UI Integration
local TabESP = Window.Tabs[1]
TabESP:AddDropdown({
    Name = "Select Rarity",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Legendary"},
    Callback = function(val)
        selectedRarity = val
        createESP()
    end
})

TabESP:AddButton({
    Name = "Refresh ESP Now",
    Callback = function()
        createESP()
    end
})

local TabHop = Window.Tabs[3]
TabHop:AddButton({
    Name = "Auto-Hop to Best Server",
    Callback = function()
        hopToBestServer()
    end
})

-- YoxanXHub V2.5 | Part 3/3 - Instant Steal, Base, Godmode, Anti Steal
local OrionLib = _G.OrionLib
local Window = _G.YoxanXWindow
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- === BASE SYSTEM ===
local SavedBasePos = nil
local LockTime = 0
local IsLocked = false

local function SaveBase()
    if HRP then
        SavedBasePos = HRP.CFrame
        OrionLib:MakeNotification({ Name = "Base Saved", Content = "Your base location has been saved.", Time = 4 })
    end
end

local function LockBase(seconds)
    LockTime = seconds
    IsLocked = true
    OrionLib:MakeNotification({ Name = "Base Locked", Content = "Base locked for " .. seconds .. " seconds.", Time = 4 })
    task.spawn(function()
        while LockTime > 0 do
            task.wait(1)
            LockTime -= 1
        end
        IsLocked = false
        OrionLib:MakeNotification({ Name = "Base Unlocked", Content = "Base is now unlocked.", Time = 4 })
    end)
end

-- === INSTANT STEAL ===
local function InstantSteal(target)
    if target and target:FindFirstChild("Head") then
        HRP.CFrame = target.Head.CFrame * CFrame.new(0, 0, 2)
        task.wait(0.2)
        if SavedBasePos then
            HRP.CFrame = SavedBasePos
        end
    end
end

-- === GODMODE ===
local function ApplyGodmode()
    local function removeHumanoidStates()
        local hum = Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
    removeHumanoidStates()
    Character:FindFirstChildOfClass("Humanoid").Health = 100
    RunService.Stepped:Connect(function()
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = 100
            removeHumanoidStates()
        end
    end)
    OrionLib:MakeNotification({ Name = "Godmode", Content = "Godmode enabled (CFrame-safe).", Time = 4 })
end

-- === ANTI STEAL TRACK ===
local function DetectBrainrotTheft()
    task.spawn(function()
        while true do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Brainrot") then
                    local stolen = plr.Character:FindFirstChild("Brainrot")
                    if stolen and stolen:IsDescendantOf(plr.Character) then
                        OrionLib:MakeNotification({
                            Name = "Anti Steal Triggered",
                            Content = plr.Name .. " may have stolen your Brainrot!",
                            Time = 4
                        })
                        HRP.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -2)
                        break
                    end
                end
            end
            task.wait(2)
        end
    end)
end

-- === UI ===
local BaseTab = Window.Tabs[4]
BaseTab:AddButton({
    Name = "Save My Base Location",
    Callback = SaveBase
})
BaseTab:AddDropdown({
    Name = "Lock Base Timer",
    Options = { "80", "100", "200" },
    Callback = function(v)
        LockBase(tonumber(v))
    end
})

local CombatTab = Window.Tabs[2]
CombatTab:AddButton({
    Name = "Enable Godmode",
    Callback = ApplyGodmode
})
CombatTab:AddButton({
    Name = "Start Anti-Steal Detection",
    Callback = DetectBrainrotTheft
})
CombatTab:AddButton({
    Name = "Steal & Return to Base",
    Callback = function()
        local nearest = nil
        local dist = math.huge
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Head") and v.Name:lower():find("brainrot") then
                local d = (v.Head.Position - HRP.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = v
                end
            end
        end
        if nearest then InstantSteal(nearest) end
    end
})
