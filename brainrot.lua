-- YoxanXHub | Steal a Brainrot (1/3)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub_Config"
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Godmode",
    Default = false,
    Callback = function(state)
        local Player = game:GetService("Players").LocalPlayer
        if state then
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                local Clone = Humanoid:Clone()
                Clone.Parent = Character
                Humanoid:Destroy()
                Clone.Name = "Humanoid"
                workspace.CurrentCamera.CameraSubject = Clone
            end
        else
            warn("Matikan godmode manual dengan reset.")
        end
    end
})

MainTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local placeId = game.PlaceId
        local jobId = game.JobId
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
        end)
        if not success then
            warn("Gagal rejoin:", err)
            TeleportService:Teleport(placeId, Player)
        end
    end
})

MainTab:AddButton({
    Name = "Speed Boost",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 94
    end
})

MainTab:AddButton({
    Name = "Instant Steal",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brianrot/refs/heads/main/Slowversion.lua"))()
    end
})

MainTab:AddButton({
    Name = "Float GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brianrot/main/float.lua"))()
    end
})

Berikut adalah Bagian 2/3 dari script YoxanXHub | Steal a Brainrot — yaitu isi dari Tab Steal dan Tab Visual:


---

✅ OrionLib Script (Bagian 2/3 – Tab Steal & Visual)

-- Steal Tab
local StealTab = Window:MakeTab({
    Name = "Steal",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

StealTab:AddButton({
    Name = "Steal GUI",
    Callback = function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "YoxanXHub Steal"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = game.CoreGui

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 200, 0, 50)
        ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
        ToggleButton.Text = "Teleport UP: OFF"
        ToggleButton.TextColor3 = Color3.new(1, 1, 1)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.TextSize = 14
        ToggleButton.Active = true
        ToggleButton.Draggable = true
        ToggleButton.Parent = ScreenGui
        Instance.new("UICorner", ToggleButton)

        local toggled = false
        local originalPosition = nil

        ToggleButton.MouseButton1Click:Connect(function()
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            if not toggled then
                originalPosition = hrp.Position
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
                ToggleButton.Text = "Teleport UP: ON"
                toggled = true
            else
                if originalPosition then
                    hrp.CFrame = CFrame.new(originalPosition)
                else
                    hrp.CFrame = hrp.CFrame - Vector3.new(0, 200, 0)
                end
                ToggleButton.Text = "Teleport UP: OFF"
                toggled = false
            end
        end)
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://7734098371",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        local espEnabled = state
        local Players = game:GetService("Players")

        local function createESP(player)
            if player == Players.LocalPlayer then return end
            local character = player.Character or player.CharacterAdded:Wait()
            local head = character:WaitForChild("Head")
            if head:FindFirstChild("ESPBox") then return end

            local box = Instance.new("BillboardGui")
            box.Name = "ESPBox"
            box.Adornee = head
            box.Size = UDim2.new(0, 50, 0, 50)
            box.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
            box.AlwaysOnTop = true
            box.Parent = head

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 0.8
            frame.BackgroundColor3 = Color3.new(0, 1, 0)
            frame.Parent = box

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, -0.5, 0)
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextSize = 14
            nameLabel.Parent = frame
        end

        local function removeESP(player)
            if player and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("ESPBox") then
                    head.ESPBox:Destroy()
                end
            end
        end

        if espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                removeESP(player)
            end
        end

        Players.PlayerAdded:Connect(function(player)
            if espEnabled then
                task.delay(1, function()
                    createESP(player)
                end)
            end
        end)

        Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    end
})

VisualTab:AddButton({
    Name = "Show Player Count",
    Callback = function()
        local count = #game:GetService("Players"):GetPlayers()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Player Count",
            Text = "There are " .. count .. " players in the game.",
            Duration = 5
        })
        end
})

-- Finder Tab
local FinderTab = Window:MakeTab({
    Name = "Finder",
    Icon = "rbxassetid://7734104849",
    PremiumOnly = false
})

FinderTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Player = game:GetService("Players").LocalPlayer
        TeleportService:Teleport(game.PlaceId, Player)
    end
})

FinderTab:AddButton({
    Name = "Join Lowest Server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Player = game.Players.LocalPlayer

        local function GetServers(cursor)
            local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor then
                url = url .. "&cursor=" .. cursor
            end
            local response = game:HttpGet(url)
            return HttpService:JSONDecode(response)
        end

        local found = false
        local cursor = nil
        while not found do
            local data = GetServers(cursor)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Player)
                    found = true
                    break
                end
            end
            cursor = data.nextPageCursor
            if not cursor then break end
        end
    end
})

-- Info Tab
local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://7733658504",
    PremiumOnly = false
})

InfoTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
    end
})

InfoTab:AddParagraph("YoxanXHub", "Discord: YoxanXHub\nScript Version: 1.1.0 Beta")
