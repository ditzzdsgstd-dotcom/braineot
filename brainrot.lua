-- YoxanXHub V2.5 | Steal a Brainrot | 1/5 (UI Loader)
-- Make sure this is executed before part 2/5 to 5/5
   local orionlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot V2.5",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "YoxanXHub V2.5",
    ConfigFolder = "YoxanXHub_SAB"
})

-- Tabs
getgenv().TabESP = Window:MakeTab({Name = "📡 ESP", Icon = "rbxassetid://6031075938", PremiumOnly = false})
getgenv().TabSteal = Window:MakeTab({Name = "🎯 Steal", Icon = "rbxassetid://6034287529", PremiumOnly = false})
getgenv().TabBase = Window:MakeTab({Name = "🏠 Base", Icon = "rbxassetid://6035047377", PremiumOnly = false})
getgenv().TabUtil = Window:MakeTab({Name = "🛠 Utility", Icon = "rbxassetid://6031260794", PremiumOnly = false})
getgenv().TabMisc = Window:MakeTab({Name = "📦 Misc", Icon = "rbxassetid://6031094678", PremiumOnly = false})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local BrainrotList = {} -- Auto-filled list later
local RarityFilter = "All"

-- ESP container
local ESPObjects = {}

-- Color per rarity
local RarityColors = {
    ["Common"] = Color3.fromRGB(180, 180, 180),
    ["Rare"] = Color3.fromRGB(0, 170, 255),
    ["Epic"] = Color3.fromRGB(180, 0, 255),
    ["Legendary"] = Color3.fromRGB(255, 170, 0),
    ["Mythic"] = Color3.fromRGB(255, 0, 0),
    ["Secret"] = Color3.fromRGB(255, 255, 0),
    ["Brainrot God"] = Color3.fromRGB(0, 255, 0)
}

-- Cleanup
local function clearESP()
    for _,v in pairs(ESPObjects) do
        if v and v.Adornee then
            v:Destroy()
        end
    end
    ESPObjects = {}
end

-- Create ESP Label
local function createESP(obj, text, color)
    local Billboard = Instance.new("BillboardGui", obj)
    Billboard.Name = "ESP_"..obj.Name
    Billboard.Size = UDim2.new(0,100,0,40)
    Billboard.Adornee = obj
    Billboard.AlwaysOnTop = true

    local Label = Instance.new("TextLabel", Billboard)
    Label.Size = UDim2.new(1,0,1,0)
    Label.Text = text
    Label.BackgroundTransparency = 1
    Label.TextColor3 = color or Color3.fromRGB(255,255,255)
    Label.TextStrokeTransparency = 0.4
    Label.Font = Enum.Font.GothamBold
    Label.TextScaled = true

    table.insert(ESPObjects, Billboard)
end

-- Main ESP loop
local function updateESP()
    clearESP()

    -- Brainrot ESP
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildWhichIsA("Humanoid") then
            local name = v.Name
            local rarity = "Unknown"
            for key, color in pairs(RarityColors) do
                if name:lower():find(key:lower()) then
                    rarity = key
                    break
                end
            end
            if RarityFilter == "All" or RarityFilter == rarity then
                createESP(v:FindFirstChild("HumanoidRootPart"), name.." ["..rarity.."]", RarityColors[rarity] or Color3.new(1,1,1))
            end
        end
    end

    -- Base Timer ESP
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:lower():find("base") and v:FindFirstChild("TimerGui") then
            createESP(v:FindFirstChild("Part") or v:FindFirstChildWhichIsA("BasePart"), "Timer: "..v.TimerGui.TextLabel.Text, Color3.fromRGB(255, 255, 255))
        end
    end

    -- Player ESP
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            createESP(plr.Character.HumanoidRootPart, plr.DisplayName.." ["..dist.."m]", Color3.fromRGB(0,255,255))
        end
    end
end

-- Run every 5s
task.spawn(function()
    while true do
        if getgenv().ESPEnabled then
            updateESP()
        else
            clearESP()
        end
        task.wait(5)
    end
end)

-- UI Toggles
TabESP:AddToggle({
    Name = "Enable All ESP",
    Default = true,
    Callback = function(v)
        getgenv().ESPEnabled = v
    end
})

TabESP:AddDropdown({
    Name = "Filter Rarity (Brainrot)",
    Options = {"All", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Brainrot God"},
    Default = "All",
    Callback = function(v)
        RarityFilter = v
    end
})

-- Spectate system
TabESP:AddDropdown({
    Name = "Spectate Player",
    Options = {},
    Callback = function(playerName)
        local plr = Players:FindFirstChild(playerName)
        if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChild("Humanoid")
        end
    end
})

-- Auto refresh Spectate List
task.spawn(function()
    while true do
        local list = {}
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        pcall(function()
            TabESP["Sections"][3].Dropdown:Refresh(list)
        end)
        task.wait(10)
    end
end)

OrionLib:MakeNotification({
    Name = "YoxanX ESP",
    Content = "ESP fully loaded!",
    Image = "rbxassetid://7733658504",
    Time = 5
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local StealTab = TabSteal

local noclipEnabled = false
local followEnabled = false

-- 🔓 Noclip toggle
StealTab:AddToggle({
    Name = "Noclip Bypass",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
    end
})

-- 💨 Instant Steal (teleport inside base + return)
StealTab:AddButton({
    Name = "Instant Steal Nearest",
    Callback = function()
        local closest, minDist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local brainrot = plr:FindFirstChild("Brainrot")
                local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if brainrot and dist < minDist then
                    closest, minDist = plr, dist
                end
            end
        end

        if closest then
            -- 🔁 Break CFrame anti teleport
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            root.Anchored = false
            root.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            task.wait(0.5)
            -- 🏠 Teleport to base
            local base = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Base")
            if base and base:FindFirstChild("BasePlate") then
                root.CFrame = base.BasePlate.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- 🧠 Auto follow thief (useful when someone steals from you)
StealTab:AddToggle({
    Name = "Auto Follow Thief",
    Default = false,
    Callback = function(v)
        followEnabled = v
    end
})

-- 🕵️ Follow thief logic
task.spawn(function()
    while true do
        if followEnabled then
            local thief = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if plr.Character:FindFirstChild("StolenBrainrot") then
                        thief = plr
                        break
                    end
                end
            end
            if thief then
                LocalPlayer.Character.HumanoidRootPart.CFrame = thief.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
        end
        task.wait(1)
    end
end)

-- 🧱 Noclip handler
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

local BaseTab = TabBase
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local savedBasePos = nil
local autoLock = false
local RunService = game:GetService("RunService")

-- Save base position
BaseTab:AddButton({
    Name = "💾 Save Base Location",
    Callback = function()
        local base = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Base")
        if base and base:FindFirstChild("BasePlate") then
            savedBasePos = base.BasePlate.Position + Vector3.new(0, 3, 0)
            OrionLib:MakeNotification({Name="Saved", Content="Base location saved!", Time=4})
        end
    end
})

-- Teleport to saved base
BaseTab:AddButton({
    Name = "🏠 Teleport to Saved Base",
    Callback = function()
        if savedBasePos then
            LocalPlayer.Character:PivotTo(CFrame.new(savedBasePos))
        else
            OrionLib:MakeNotification({Name="Error", Content="No base position saved!", Time=3})
        end
    end
})

-- Auto Lock Toggle
BaseTab:AddToggle({
    Name = "🔐 Auto Lock Base when Timer = 0",
    Default = false,
    Callback = function(v)
        autoLock = v
    end
})

-- Base lock logic
task.spawn(function()
    while true do
        if autoLock then
            local base = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Base")
            if base and base:FindFirstChild("BaseLockTimer") then
                local timerVal = tonumber(base.BaseLockTimer.Text)
                if timerVal and timerVal <= 0 then
                    fireclickdetector(base:FindFirstChildOfClass("ClickDetector"))
                    OrionLib:MakeNotification({
                        Name = "Base Locked",
                        Content = "Auto Locked your base!",
                        Time = 3
                    })
                    autoLock = false
                end
            end
        end
        task.wait(1)
    end
end)

-- Godmode Toggle
BaseTab:AddToggle({
    Name = "🛡️ Godmode (Anti KB & CFrame Reset)",
    Default = false,
    Callback = function(state)
        if state then
            RunService.Stepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
                    LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end
            end)
        end
    end
})

local UtilityTab = TabUtility
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local FPS = 0
local bestRarity = "Secret"

-- FPS Counter
UtilityTab:AddLabel("FPS: Calculating...")

RunService.RenderStepped:Connect(function()
    FPS += 1
end)

coroutine.wrap(function()
    while true do
        UtilityTab:UpdateLabel("FPS: " .. tostring(FPS))
        FPS = 0
        task.wait(1)
    end
end)()

-- Spectate system
UtilityTab:AddDropdown({
    Name = "🎥 Spectate Player",
    Default = "None",
    Options = table.map(Players:GetPlayers(), function(plr) return plr.Name end),
    Callback = function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character then
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        end
    end
})

-- Reset camera
UtilityTab:AddButton({
    Name = "Reset Camera",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
})

-- Reset whole UI
UtilityTab:AddButton({
    Name = "🔄 Reset YoxanXHub",
    Callback = function()
        OrionLib:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
    end
})

-- Dropdown to choose rarity
UtilityTab:AddDropdown({
    Name = "🌐 Target Server Rarity",
    Default = "Secret",
    Options = {"Secret", "Mythic", "Legendary"},
    Callback = function(value)
        bestRarity = value
    end
})

-- Auto Server Hop based on rarity
UtilityTab:AddButton({
    Name = "Auto Server Hop to Best",
    Callback = function()
        local placeId = 109983668079237
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)

        if success and servers.data then
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers then
                    -- You would check for brainrot rarity in server data if available.
                    -- For now, hop to first available with space.
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    return
                end
            end
        else
            warn("Could not fetch servers")
        end
    end
})

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "UI Loaded! Continue to 2/5.",
    Image = "rbxassetid://7733658504",
    Time = 5
})
