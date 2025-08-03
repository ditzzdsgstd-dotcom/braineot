--// YoxanXHub Brainrot V2 — Part 1/5

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local player = game.Players.LocalPlayer
local savedBaseCFrame = nil
local jumpCount = 0

-- Break CFrame Sync (Godmode)
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

-- Smart Teleport (Safe + Anchored)
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

-- Create UI
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Brainrot V2",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "YoxanXHub Loaded",
    ConfigFolder = "YoxanXHub"
})

-- 📌 Info Tab
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

-- ⚙️ Main Tab
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
            Name = "Godmode Activated",
            Content = "CFrame desync complete.",
            Time = 2
        })
    end
})
MainTab:AddButton({
    Name = "🔁 Rejoin Server",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Rejoining...",
            Content = "Teleporting to new session.",
            Time = 2
        })
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

-- 🌀 Movement Tab
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
    Name = "⚡ Speed Boost (200)",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 200
            OrionLib:MakeNotification({
                Name = "Speed Boost",
                Content = "WalkSpeed set to 200.",
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

-- 🧠 Steal Tab
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
                Content = "Your base position has been saved.",
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
                Content = "You returned to your base.",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ No Base Saved",
                Content = "Use Save Base first.",
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
            hrp.CFrame += Vector3.new(0, 150, 0)
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

-- ESP Core Setup
local player = game.Players.LocalPlayer
local BrainrotESP = {}
local selectedRarities = {
    ["Secret"] = true,
    ["Legendary"] = true,
    ["Mythic"] = true,
    ["Mythic Lucky"] = true,
    ["Brainrot God"] = true,
    ["Brainrot God Lucky"] = true,
    ["Epic"] = false,
    ["Rare"] = false,
    ["Common"] = false
}

-- Brainrot List with Rarity
local brainrotList = {
    ["Noobini Pizzanini"] = "Common", ["Lirili Larila"] = "Common", ["TIM Cheese"] = "Common",
    ["Flurifura"] = "Common", ["Talpa Di Fero"] = "Common", ["Svinia Bombardino"] = "Common",
    ["Pipi Kiwi"] = "Common", ["Pipi Corni"] = "Common", ["Trippi Troppi"] = "Rare",
    ["Tung Tung Tung Sahur"] = "Rare", ["Gangster Footera"] = "Rare", ["Bandito Bobritto"] = "Rare",
    ["Boneca Ambalabu"] = "Rare", ["Cacto Hipopotamo"] = "Rare", ["Ta Ta Ta Ta Sahur"] = "Rare",
    ["Tric Trac Baraboom"] = "Rare", ["Pipi Avocado"] = "Rare", ["Cappuccino Assassino"] = "Epic",
    ["Brr Brr Patapim"] = "Epic", ["Trulimero Trulicina"] = "Epic", ["Bambini Crostini"] = "Epic",
    ["Bananita Dolphinita"] = "Epic", ["Perochello Lemonchello"] = "Epic", ["Brri Brri Bicus Dicus Bombicus"] = "Epic",
    ["Avocadini Guffo"] = "Epic", ["Salamino Penguino"] = "Epic", ["Burbaloni Loliloli"] = "Legendary",
    ["Chimpazini Bananini"] = "Legendary", ["Ballerina Cappuccina"] = "Legendary", ["Chef Crabracadabra"] = "Legendary",
    ["Lionel Cactuseli"] = "Legendary", ["Glorbo Fruttodrillo"] = "Legendary", ["Blueberrini Octopusini"] = "Legendary",
    ["Strawberelli Flamingelli"] = "Legendary", ["Pandaccini Bananini"] = "Legendary", ["Cocosini Mama"] = "Legendary",
    ["Sigma Boy"] = "Legendary", ["frigo Camelo"] = "Mythic", ["Orangutini Ananassini"] = "Mythic",
    ["Rhino Toasterino"] = "Mythic", ["Bombardiro Crocodilo"] = "Mythic", ["Bombombini Gusini"] = "Mythic",
    ["Cavallo Virtuso"] = "Mythic", ["Gorillo Watermelondrillo"] = "Mythic", ["Avocadorilla"] = "Mythic",
    ["Spioniro Golubiro"] = "Mythic Lucky", ["Zibra Zubra Zibralini"] = "Mythic Lucky", ["Tigrilini Watermelini"] = "Mythic Lucky",
    ["Coco Elefanto"] = "Brainrot God", ["Girafa Celestre"] = "Brainrot God", ["Gattatino Nyanino"] = "Brainrot God",
    ["Matteo"] = "Brainrot God", ["Tralalero Tralala"] = "Brainrot God", ["Espresso Signora"] = "Brainrot God",
    ["Odin Din Din Dun"] = "Brainrot God", ["Statutino Libertino"] = "Brainrot God", ["Trenostruzzo Turbo 3000"] = "Brainrot God",
    ["Ballerino Lololo"] = "Brainrot God", ["Trigoligre Frutonni"] = "Brainrot God Lucky", ["Orcalero Orcala"] = "Brainrot God Lucky",
    ["Los Crocodillitos"] = "Brainrot God", ["Piccione Macchina"] = "Brainrot God", ["Trippi Troppi Troppa Trippa"] = "Brainrot God",
    ["La Vacca Staturno Saturnita"] = "Secret", ["Chimpanzini Spiderini"] = "Secret", ["Los Tralaleritos"] = "Secret",
    ["Las Tralaleritas"] = "Secret", ["Graipuss Medussi"] = "Secret", ["La Grande Combinasion"] = "Secret",
    ["Nuclearo Dinossauro"] = "Secret", ["Garama and Madundung"] = "Secret", ["Tortuginni Dragonfruitini"] = "Secret Lucky",
    ["Pot Hotspot"] = "Secret Lucky", ["Las Vaquitas Saturnitas"] = "Secret", ["Chicleteira Bicicleteira"] = "Secret",
    ["Agarrini la Palini"] = "Secret", ["Dragon Cannelloni"] = "Secret", ["Los Combinasionas"] = "Secret"
}

-- Create Billboard ESP
local function createESP(part, text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "YoxESP"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = part

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    table.insert(BrainrotESP, billboard)
end

-- Clear all old ESPs
local function clearESP()
    for _, gui in ipairs(BrainrotESP) do
        if gui and gui.Parent then gui:Destroy() end
    end
    BrainrotESP = {}
end

-- Update ESP Logic
local function updateBrainrotESP()
    clearESP()
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("Head") then
            local name = model.Name
            local rarity = brainrotList[name]
            if rarity and selectedRarities[rarity] then
                local color = rarity == "Secret" and Color3.fromRGB(255, 0, 0)
                    or rarity == "Legendary" and Color3.fromRGB(255, 215, 0)
                    or rarity == "Mythic" and Color3.fromRGB(128, 0, 255)
                    or rarity == "Mythic Lucky" and Color3.fromRGB(255, 0, 255)
                    or rarity == "Brainrot God" and Color3.fromRGB(0, 255, 255)
                    or rarity == "Brainrot God Lucky" and Color3.fromRGB(100, 255, 255)
                    or rarity == "Epic" and Color3.fromRGB(0, 200, 255)
                    or rarity == "Rare" and Color3.fromRGB(0, 255, 0)
                    or Color3.fromRGB(255, 255, 255)

                createESP(model.Head, name .. " [" .. rarity .. "]", color)
            end
        end
    end
end

-- Create ESP Tab using existing OrionLib window
local ESPTab = Window:MakeTab({
    Name = "🧿 ESP",
    Icon = "rbxassetid://6031075935",
    PremiumOnly = false
})

-- Add toggles for each rarity
for rarity, _ in pairs(selectedRarities) do
    ESPTab:AddToggle({
        Name = "Show " .. rarity,
        Default = selectedRarities[rarity],
        Callback = function(value)
            selectedRarities[rarity] = value
            updateBrainrotESP()
        end
    })
end

-- Add toggle for auto-refresh
local autoRefresh = true
ESPTab:AddToggle({
    Name = "Auto Refresh ESP (5s)",
    Default = true,
    Callback = function(val)
        autoRefresh = val
    end
})

-- Start ESP auto-loop
task.spawn(function()
    while true do
        if autoRefresh then
            updateBrainrotESP()
        end
        task.wait(5)
    end
end)

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetPlaceId = 109983668079237 -- Steal a Brainrot place ID
local maxServerChecks = 100
local minimumTargetFound = false
local checkedServers = {}
local brainrotTargets = {
    "Secret", "Mythic", "Mythic Lucky", "Brainrot God", "Brainrot God Lucky", "Legendary"
}

-- Brainrot name to rarity mapping (simplified for performance)
local brainrotRarity = {}
for name, rarity in pairs(brainrotList or {}) do
    brainrotRarity[name] = rarity
end

-- Detect if a server has target brainrot
local function hasTargetBrainrot()
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and brainrotRarity[model.Name] then
            local rarity = brainrotRarity[model.Name]
            if table.find(brainrotTargets, rarity) then
                return true
            end
        end
    end
    return false
end

-- Try to teleport to a unique server
local function teleportToBestServer()
    local cursor = ""
    for i = 1, maxServerChecks do
        local url = "https://games.roblox.com/v1/games/" .. targetPlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and response and response.data then
            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers and not checkedServers[server.id] then
                    checkedServers[server.id] = true
                    TeleportService:TeleportToPlaceInstance(targetPlaceId, server.id, LocalPlayer)
                    return
                end
            end
        end

        if response.nextPageCursor then
            cursor = response.nextPageCursor
        else
            break
        end
    end

    warn("No suitable servers found after checking " .. maxServerChecks)
end

-- Auto hop if no good brainrot found
task.delay(10, function()
    if not hasTargetBrainrot() then
        warn("No target brainrot found, hopping...")
        teleportToBestServer()
    else
        print("✅ Target brainrot already in current server")
    end
end)

-- Manual UI button (optional, add to Orion tab if desired)
if Window and Window.MakeTab then
    local HopTab = Window:MakeTab({
        Name = "🌐 Server Hop",
        Icon = "rbxassetid://6035067836",
        PremiumOnly = false
    })

    HopTab:AddButton({
        Name = "🔄 Server Hop Now",
        Callback = teleportToBestServer
    })
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

-- Store ESP drawing
local espObjects = {}
local espSettings = {
    refreshRate = 5,
    brainrotFilter = {"Legendary", "Mythic", "Secret", "Brainrot God"}
}

-- Clear old ESP
local function ClearESP()
    for _, v in pairs(espObjects) do
        if v then v:Remove() end
    end
    espObjects = {}
end

-- Draw ESP for brainrots
local function BrainrotESP()
    ClearESP()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            local name = v.Name
            for _, rarity in pairs(espSettings.brainrotFilter) do
                if string.find(name, rarity) then
                    local box = Drawing.new("Text")
                    box.Text = name
                    box.Size = 15
                    box.Center = true
                    box.Outline = true
                    box.Color = Color3.fromRGB(255, 255, 0)
                    box.Visible = true

                    espObjects[#espObjects+1] = box

                    RunService.RenderStepped:Connect(function()
                        if v and v:FindFirstChild("HumanoidRootPart") then
                            local pos, onScreen = camera:WorldToViewportPoint(v.HumanoidRootPart.Position)
                            box.Visible = onScreen
                            box.Position = Vector2.new(pos.X, pos.Y)
                        else
                            box.Visible = false
                        end
                    end)
                end
            end
        end
    end
end

-- Base Lock Timer ESP
local function DrawBaseTimer()
    local baseUI = workspace:FindFirstChild("BaseLockTimer") or workspace:FindFirstChildWhichIsA("TextLabel", true)
    if baseUI and baseUI:IsA("TextLabel") then
        local timerLabel = Drawing.new("Text")
        timerLabel.Text = "⏳ " .. baseUI.Text
        timerLabel.Size = 18
        timerLabel.Color = Color3.new(1, 0, 0)
        timerLabel.Position = Vector2.new(100, 120)
        timerLabel.Outline = true
        timerLabel.Visible = true
        espObjects[#espObjects+1] = timerLabel

        RunService.RenderStepped:Connect(function()
            if baseUI and baseUI.Parent then
                timerLabel.Text = "⏳ " .. baseUI.Text
            else
                timerLabel.Text = "Base Locked"
            end
        end)
    end
end

-- Spectate
local spectating = false
local originalCamera = camera.CameraSubject
local function SpectatePlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = target.Character.Humanoid
        spectating = true
    end
end

local function StopSpectating()
    camera.CameraSubject = originalCamera
    spectating = false
end

-- Anti-Steal Tracker (teleport to thief)
local function TrackStealer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
            break
        end
    end
end

-- UI Setup (Optional: Use existing OrionLib window)
if Window then
    local ESPTab = Window:MakeTab({
        Name = "🧠 ESP",
        Icon = "rbxassetid://6031075938",
        PremiumOnly = false
    })

    ESPTab:AddButton({
        Name = "🔍 Refresh Brainrot ESP",
        Callback = BrainrotESP
    })

    ESPTab:AddButton({
        Name = "⏳ Show Base Timer ESP",
        Callback = DrawBaseTimer
    })

    ESPTab:AddTextbox({
        Name = "👁️ Spectate Player",
        Default = "",
        TextDisappear = true,
        Callback = SpectatePlayer
    })

    ESPTab:AddButton({
        Name = "❌ Stop Spectating",
        Callback = StopSpectating
    })

    ESPTab:AddButton({
        Name = "🚨 Track Stealer",
        Callback = TrackStealer
    })
end

-- Auto refresh ESP every 5s
task.spawn(function()
    while true do
        BrainrotESP()
        task.wait(espSettings.refreshRate)
    end
end)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local savedBaseCFrame = nil

-- || [UTILITY] Break CFrame sync
local function BreakCFrame()
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

-- || [UTILITY] Safe TP + CFrame break
local function SmartTP(cf)
	BreakCFrame()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Anchored = true
		hrp.CFrame = cf
		task.wait(0.2)
		hrp.Anchored = false
	end
end

-- || [AUTO STEAL FUNCTION]
local function InstantSteal()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
			if string.match(obj.Name, "Brainrot") and not obj:IsDescendantOf(player.Character) then
				local brainPos = obj.HumanoidRootPart.CFrame
				SmartTP(brainPos + Vector3.new(0, 2, 0))
				task.wait(0.2)
				if savedBaseCFrame then
					SmartTP(savedBaseCFrame + Vector3.new(0, 3, 0))
				end
				break
			end
		end
	end
end

-- || [NOCLIP FUNCTION]
local noClipActive = false
RunService.Stepped:Connect(function()
	if noClipActive and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

-- || [AUTO SERVER HOP (RARE+ SERVER)]
local function AutoHop()
	local HttpService = game:GetService("HttpService")
	local PlaceID = game.PlaceId
	local cursor = ""
	local tried = 0

	while tried < 100 do
		local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?limit=100&sortOrder=Asc&cursor=" .. cursor
		local data = game:HttpGet(url)
		local servers = HttpService:JSONDecode(data)

		if servers and servers.data then
			for _, s in pairs(servers.data) do
				if s.playing < s.maxPlayers and s.id ~= game.JobId then
					TeleportService:TeleportToPlaceInstance(PlaceID, s.id, player)
					return
				end
			end
		end

		if servers and servers.nextPageCursor then
			cursor = servers.nextPageCursor
		else
			break
		end
		tried += 1
		task.wait(1)
	end
end

-- || UI Connection (OrionLib assumed already initialized)
if Window then
	local StealTab = Window:MakeTab({
		Name = "🔪 Auto Steal",
		Icon = "rbxassetid://6031071054",
		PremiumOnly = false
	})

	StealTab:AddButton({
		Name = "💾 Save Base CFrame",
		Callback = function()
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				savedBaseCFrame = hrp.CFrame
				OrionLib:MakeNotification({
					Name = "Saved",
					Content = "Base CFrame saved.",
					Time = 2
				})
			end
		end
	})

	StealTab:AddButton({
		Name = "💥 Instant Steal",
		Callback = function()
			if savedBaseCFrame then
				InstantSteal()
			else
				OrionLib:MakeNotification({
					Name = "Error",
					Content = "Save base CFrame first.",
					Time = 2
				})
			end
		end
	})

	StealTab:AddToggle({
		Name = "🚫 NoClip Mode",
		Default = false,
		Callback = function(v)
			noClipActive = v
		end
	})

	StealTab:AddButton({
		Name = "🌍 Server Hop (Auto)",
		Callback = function()
			OrionLib:MakeNotification({
				Name = "Searching",
				Content = "Looking for better server...",
				Time = 3
			})
			AutoHop()
		end
	})
end
