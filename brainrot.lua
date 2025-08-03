-- OrionLib and setup
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local player = game.Players.LocalPlayer
local savedBaseCFrame = nil
local jumpCount = 0

-- Utility: CFrame sync break
local function BreakCFrameSync()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp then
        local clone = hum:Clone()
        clone.Parent = char
        hum:Destroy()
        workspace.CurrentCamera.CameraSubject = clone
    end
end

-- Utility: Smart Teleport
local function SmartTeleport(cf)
    BreakCFrameSync()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = true
        task.wait(0.1)
        hrp.CFrame = cf
        task.wait(0.3)
        hrp.Anchored = false
    end
end

-- Create window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Brainrot V2",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanXHub Loaded",
    ConfigFolder = "YoxanXHub"
})

-- Info Tab
local InfoTab = Window:MakeTab({
    Name = "📌 Info",
    Icon = "rbxassetid://6031075938",
    PremiumOnly = false
})
InfoTab:AddParagraph("YoxanXHub V2", "Steal a Brainrot Script")
InfoTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
        OrionLib:MakeNotification({
            Name = "📎 Copied",
            Content = "Discord invite copied!",
            Time = 3
        })
    end
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "⚙️ Main",
    Icon = "rbxassetid://6031071053",
    PremiumOnly = false
})
MainTab:AddButton({
    Name = "💀 Godmode (Break CFrame)",
    Callback = function()
        BreakCFrameSync()
        OrionLib:MakeNotification({
            Name = "Godmode",
            Content = "CFrame sync broken successfully.",
            Time = 2
        })
    end
})
MainTab:AddButton({
    Name = "🔁 Rejoin Server",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Rejoining...",
            Content = "You are being reconnected.",
            Time = 2
        })
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

-- Movement Tab
local MoveTab = Window:MakeTab({
    Name = "🌀 Movement",
    Icon = "rbxassetid://6031071057",
    PremiumOnly = false
})
MoveTab:AddButton({
    Name = "🛸 Float Up",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = true
            char.HumanoidRootPart.CFrame += Vector3.new(0, 75, 0)
            task.wait(1)
            char.HumanoidRootPart.Anchored = false
            OrionLib:MakeNotification({
                Name = "Float Up",
                Content = "You have floated upward.",
                Time = 2
            })
        end
    end
})
MoveTab:AddButton({
    Name = "⚡ Speed Boost (150)",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 150
            OrionLib:MakeNotification({
                Name = "Speed Boost",
                Content = "WalkSpeed set to 150.",
                Time = 2
            })
        end
    end
})
MoveTab:AddBind({
    Name = "Double Jump Key",
    Default = Enum.KeyCode.Space,
    Hold = false,
    Callback = function()
        jumpCount += 1
        if jumpCount >= 2 then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(0, 100, 0)
            end
            jumpCount = 0
        end
        task.delay(0.6, function()
            jumpCount = 0
        end)
    end
})

-- Steal Tab
local StealTab = Window:MakeTab({
    Name = "🧠 Steal",
    Icon = "rbxassetid://6031071051",
    PremiumOnly = false
})
StealTab:AddButton({
    Name = "📍 Save Base Location",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedBaseCFrame = char.HumanoidRootPart.CFrame
            OrionLib:MakeNotification({
                Name = "Base Saved",
                Content = "Your base location has been saved.",
                Time = 2
            })
        end
    end
})
StealTab:AddButton({
    Name = "🚀 Teleport to Base",
    Callback = function()
        if savedBaseCFrame then
            SmartTeleport(savedBaseCFrame)
            OrionLib:MakeNotification({
                Name = "Teleported",
                Content = "Returned to base location.",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ No Base Saved",
                Content = "Use 'Save Base Location' first.",
                Time = 2
            })
        end
    end
})
StealTab:AddButton({
    Name = "💥 Instant Steal (CFrame Safe)",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            BreakCFrameSync()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            hrp.Anchored = true
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 150, 0)
            OrionLib:MakeNotification({
                Name = "Stealing...",
                Content = "Floating for 1.5s...",
                Time = 2
            })
            task.wait(1.5)
            if savedBaseCFrame then
                SmartTeleport(savedBaseCFrame)
            end
        end
    end
})

--// YoxanXHub V2 | Part 2/3 - ESP + Smart Server Hop
local OrionLib = _G.OrionLib
local Players, HttpService, TeleportService, Workspace, CoreGui = 
    game:GetService("Players"), game:GetService("HttpService"), game:GetService("TeleportService"),
    game:GetService("Workspace"), game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local placeId = 109983668079237

local ESPFolder = CoreGui:FindFirstChild("BrainrotESP") or Instance.new("Folder", CoreGui)
ESPFolder.Name = "BrainrotESP"

local BrainrotList = {
    ["Agarrini la Palini"] = "Secret", ["Avocadini Guffo"] = "Epic", ["Avocadorilla"] = "Mythic",
    ["Ballerina Cappuccina"] = "Legendary", ["Ballerino Lololo"] = "Brainrot God", ["Bambini Crostini"] = "Epic",
    ["Bananita Dolphinita"] = "Epic", ["Bandito Bobritto"] = "Rare", ["Blueberrini Octopusini"] = "Legendary",
    ["Bombardiro Crocodilo"] = "Mythic", ["Bombombini Gusini"] = "Mythic", ["Boneca Ambalabu"] = "Rare",
    ["Brr Brr Patapim"] = "Epic", ["Brri Brri Bicus Dicus Bombicus"] = "Epic", ["Burbaloni Loliloli"] = "Legendary",
    ["Cacto Hipopotamo"] = "Rare", ["Cappuccino Assassino"] = "Epic", ["Cavallo Virtuso"] = "Mythic",
    ["Chef Crabracadabra"] = "Legendary", ["Chicleteira Bicicleteira"] = "Secret", ["Chimpanzini Spiderini"] = "Secret",
    ["Chimpazini Bananini"] = "Legendary", ["Coco Elefanto"] = "Brainrot God", ["Cocosini Mama"] = "Legendary",
    ["Dragon Cannelloni"] = "Secret", ["Espresso Signora"] = "Brainrot God", ["Frigo Camelo"] = "Mythic",
    ["Gangster Footera"] = "Rare", ["Garama and Madundung"] = "Secret", ["Gattatino Nyanino"] = "Brainrot God",
    ["Girafa Celestre"] = "Brainrot God", ["Glorbo Fruttodrillo"] = "Legendary", ["Gorillo Watermelondrillo"] = "Mythic",
    ["Graipuss Medussi"] = "Secret", ["La Grande Combinasion"] = "Secret", ["Las Tralaleritas"] = "Secret",
    ["Las Vaquitas Saturnitas"] = "Secret", ["Lionel Cactuseli"] = "Legendary", ["Los Combinasionas"] = "Secret",
    ["Los Crocodillitos"] = "Brainrot God", ["Los Tralaleritos"] = "Secret", ["Matteo"] = "Brainrot God",
    ["Nuclearo Dinossauro"] = "Secret", ["Odin Din Din Dun"] = "Brainrot God", ["Orangutini Ananassini"] = "Mythic",
    ["Orcalero Orcala"] = "Brainrot God Lucky", ["Pandaccini Bananini"] = "Legendary", ["Perochello Lemonchello"] = "Epic",
    ["Piccione Macchina"] = "Brainrot God", ["Pipi Avocado"] = "Rare", ["Pot Hotspot"] = "Secret Lucky",
    ["Rhino Toasterino"] = "Mythic", ["Salamino Penguino"] = "Epic", ["Sigma Boy"] = "Legendary",
    ["Spioniro Golubiro"] = "Mythic Lucky", ["Statutino Libertino"] = "Brainrot God", ["Strawberelli Flamingelli"] = "Legendary",
    ["Ta Ta Ta Ta Sahur"] = "Rare", ["Tigrilini Watermelini"] = "Mythic Lucky", ["Tortuginni Dragonfruitini"] = "Secret Lucky",
    ["Tralalero Tralala"] = "Brainrot God", ["Trenostruzzo Turbo 3000"] = "Brainrot God", ["Tric Trac Baraboom"] = "Rare",
    ["Trigoligre Frutonni"] = "Brainrot God Lucky", ["Trippi Troppi"] = "Rare", ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["Trulimero Trulicina"] = "Epic", ["Tung Tung Tung Sahur"] = "Rare", ["Zibra Zubra Zibralini"] = "Mythic Lucky"
}

local SelectedRarities = {
    ["Rare"] = true, ["Epic"] = true, ["Legendary"] = true, ["Mythic"] = true,
    ["Mythic Lucky"] = true, ["Brainrot God"] = true, ["Brainrot God Lucky"] = true,
    ["Secret"] = true, ["Secret Lucky"] = true,
}

local function CreateESP()
    ESPFolder:ClearAllChildren()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Head") then
            local rarity = BrainrotList[v.Name]
            if rarity and SelectedRarities[rarity] then
                local Billboard = Instance.new("BillboardGui", ESPFolder)
                Billboard.Adornee = v.Head
                Billboard.Size = UDim2.new(0, 100, 0, 20)
                Billboard.StudsOffset = Vector3.new(0, 3, 0)
                Billboard.AlwaysOnTop = true

                local TextLabel = Instance.new("TextLabel", Billboard)
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextColor3 = Color3.new(1, 1, 1)
                TextLabel.TextStrokeTransparency = 0
                TextLabel.TextScaled = true
                TextLabel.Text = v.Name .. " ["..rarity.."]"
            end
        end
    end
end

-- Auto refresh ESP every 5 seconds
task.spawn(function()
    while true do
        CreateESP()
        task.wait(5)
    end
end)

-- Smart Server Hop
local function SmartHop()
    local bestServer, bestCount = nil, 0
    local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100"
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if not success then return end

    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            local infoUrl = "https://www.roblox.com/games/getgameinstancesjson?placeId="..placeId.."&startIndex=0"
            local _, serverInfo = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(infoUrl))
            end)
            if serverInfo then
                local count = 0
                for _, instance in pairs(serverInfo.Collection or {}) do
                    for _, user in pairs(instance.CurrentPlayers or {}) do
                        if user.Name then
                            for name, rarity in pairs(BrainrotList) do
                                if SelectedRarities[rarity] and string.find(user.Name, name) then
                                    count += 1
                                end
                            end
                        end
                    end
                    if count > bestCount then
                        bestServer = server
                        bestCount = count
                    end
                end
            end
        end
    end

    if bestServer and bestServer.id then
        OrionLib:MakeNotification({
            Name = "Server Hop",
            Content = "Teleporting to better server...",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
        TeleportService:TeleportToPlaceInstance(placeId, bestServer.id, LocalPlayer)
    else
        OrionLib:MakeNotification({
            Name = "Server Hop",
            Content = "No better server found.",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
end

-- Create UI tab
local ESPTab = OrionLib:MakeTab({Name = "ESP & Server Hop", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Add rarity toggles
for rarity, _ in pairs(SelectedRarities) do
    ESPTab:AddToggle({
        Name = "Show " .. rarity,
        Default = true,
        Callback = function(v)
            SelectedRarities[rarity] = v
            CreateESP()
        end
    })
end

-- Add hop button
ESPTab:AddButton({
    Name = "Smart Hop (Auto Best Server)",
    Callback = SmartHop
})

--// YoxanXHub V2 | Part 3/3 - Instant Steal, Base Lock, Anti Steal
local OrionLib = _G.OrionLib
local Players, Workspace, RunService = game:GetService("Players"), game:GetService("Workspace"), game:GetService("RunService")
local LocalPlayer, HumanoidRootPart = Players.LocalPlayer, nil
local SavedBaseCFrame = nil
local AntiStealEnabled, LockEnabled, InstantStealEnabled = true, true, true

-- Setup
local function GetHRP()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Save base location
local function SaveBase()
    local hrp = GetHRP()
    if hrp then
        SavedBaseCFrame = hrp.CFrame
        OrionLib:MakeNotification({Name = "Base Saved", Content = "Base location saved.", Time = 3})
    end
end

-- Return to saved base
local function ReturnToBase()
    local hrp = GetHRP()
    if hrp and SavedBaseCFrame then
        hrp.CFrame = SavedBaseCFrame
    end
end

-- Instant Steal
local function InstantSteal(npc)
    if npc and npc:FindFirstChild("Head") and GetHRP() then
        local hrp = GetHRP()
        hrp.CFrame = npc.Head.CFrame + Vector3.new(0, 1.5, 0)
        task.wait(0.25)
        ReturnToBase()
    end
end

-- Auto detect nearby Brainrots to steal
local function FindNearestBrainrot()
    local closest, dist = nil, math.huge
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Head") then
            local mag = (v.Head.Position - GetHRP().Position).Magnitude
            if mag < 150 and BrainrotList[v.Name] then
                if mag < dist then
                    closest, dist = v, mag
                end
            end
        end
    end
    return closest
end

-- Anti Steal Tracker
local function WatchSteals()
    Workspace.ChildAdded:Connect(function(child)
        if not AntiStealEnabled then return end
        if child:IsA("Model") and child:FindFirstChild("Head") and BrainrotList[child.Name] then
            local tag = child:FindFirstChild("Stealer") or child:FindFirstChildWhichIsA("ObjectValue")
            if tag and tag.Value and tag.Value ~= LocalPlayer then
                task.wait(0.2)
                GetHRP().CFrame = tag.Value.Character and tag.Value.Character:FindFirstChild("HumanoidRootPart").CFrame or GetHRP().CFrame
                OrionLib:MakeNotification({
                    Name = "Anti Steal",
                    Content = "Someone is stealing! Teleported to them.",
                    Time = 3
                })
            end
        end
    end)
end

-- Base Lock Timer
local function MonitorBase()
    while LockEnabled do
        local timer = Workspace:FindFirstChild("BaseTimer") or Workspace:FindFirstChildWhichIsA("IntValue")
        if timer and timer.Value <= 0 then
            OrionLib:MakeNotification({
                Name = "Base Locked",
                Content = "Timer hit 0. Base auto-locked.",
                Time = 3
            })
            task.wait(5)
        end
        task.wait(1)
    end
end

-- UI Setup
local Tab = OrionLib:MakeTab({
    Name = "Base & Steal",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "Save Base Position",
    Callback = SaveBase
})

Tab:AddToggle({
    Name = "Enable Instant Steal",
    Default = true,
    Callback = function(v)
        InstantStealEnabled = v
    end
})

Tab:AddToggle({
    Name = "Enable Anti Steal Tracker",
    Default = true,
    Callback = function(v)
        AntiStealEnabled = v
    end
})

Tab:AddToggle({
    Name = "Enable Auto Base Lock Monitor",
    Default = true,
    Callback = function(v)
        LockEnabled = v
    end
})

-- Auto run core systems
task.spawn(function()
    WatchSteals()
    MonitorBase()
end)

-- Optional: Auto-Instant Steal if enabled
task.spawn(function()
    while true do
        if InstantStealEnabled then
            local target = FindNearestBrainrot()
            if target then InstantSteal(target) end
        end
        task.wait(3)
    end
end)
