-- // Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot",
    HidePremium = false,
    IntroEnabled = true,
    IntroText = "YoxanXHub",
    SaveConfig = false,
    ConfigFolder = "YoxanXHub"
})

-- // Key System
OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Copy key from discord.gg/Az8Cm2F6",
    Image = "rbxassetid://4483345998",
    Time = 8
})

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Script Loading...",
    Time = 4
})

OrionLib:MakeNotification({
    Name = "Key System",
    Content = "Checking key...",
    Time = 2
})

local CorrectKey = "LACAZETTE"

OrionLib:MakeNotification({
    Name = "Enter Key",
    Content = "Press RightShift to open UI and enter key",
    Time = 5
})

local KeyTab = Window:Tab({
    Name = "Key System",
    Icon = "key",
    PremiumOnly = false
})

KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        if Value == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Access Granted",
                Content = "Welcome to YoxanXHub!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Incorrect Key",
                Content = "Join Discord for the correct key!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

KeyTab:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Discord link copied to clipboard.",
            Time = 3
        })
    end
})

-- Continuing from the previous script (no new window)

-- Main Tab
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

-- Godmode Toggle
MainTab:Toggle({
    Title = "Godmode",
    Desc = "Makes you immortal (reset character to disable)",
    Icon = "shield",
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
            warn("Godmode must be disabled manually by resetting your character.")
        end
    end
})

-- Rejoin Server Button
MainTab:Button({
    Title = "Rejoin Server",
    Desc = "Use this after enabling Godmode (does not use autoexec)",
    Icon = "globe",
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
            warn("Failed to rejoin same server, teleporting to another server instead:", err)
            TeleportService:Teleport(placeId, Player)
        end
    end
})

-- Visual Tab
local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

-- ESP with player name and semi-xray effect
VisualTab:Toggle({
    Title = "Player ESP",
    Desc = "Shows player names and highlights bodies",
    Default = false,
    Callback = function(enabled)
        local Players = game:GetService("Players")
        local function createESP(player)
            if player == Players.LocalPlayer then return end
            local character = player.Character or player.CharacterAdded:Wait()
            if not character then return end
            local head = character:WaitForChild("Head", 5)
            if not head then return end

            local box = Instance.new("BillboardGui")
            box.Name = "ESPBox"
            box.Adornee = head
            box.Size = UDim2.new(0, 100, 0, 40)
            box.StudsOffset = Vector3.new(0, 2, 0)
            box.AlwaysOnTop = true
            box.Parent = head

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Text = player.Name
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 16
            nameLabel.Parent = box

            -- Apply xray style to limbs
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Adornee = part
                    adorn.Size = part.Size
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 5
                    adorn.Transparency = 0.5
                    adorn.Color3 = Color3.fromRGB(0, 255, 0)
                    adorn.Parent = part
                end
            end
        end

        local function removeESP(player)
            local character = player.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BoxHandleAdornment") or (part:IsA("BillboardGui") and part.Name == "ESPBox") then
                        part:Destroy()
                    end
                end
            end
        end

        if enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
            Players.PlayerAdded:Connect(function(player)
                task.delay(1, function() if enabled then createESP(player) end end)
            end)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end
})

-- Show player count
VisualTab:Button({
    Title = "Show Player Count",
    Desc = "Displays the number of players in-game",
    Callback = function()
        local count = #game:GetService("Players"):GetPlayers()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Player Count",
            Text = "There are " .. count .. " players currently.",
            Duration = 5
        })
    end
})

-- Steal Tab
local StealTab = Window:Tab({
    Title = "Steal",
    Icon = "zap"
})

-- Teleport up toggle
StealTab:Button({
    Title = "Toggle Sky Teleport",
    Desc = "Teleports your character up and back down",
    Callback = function()
        local gui = Instance.new("ScreenGui", game.CoreGui)
        gui.Name = "ToggleSkyGui"
        local btn = Instance.new("TextButton", gui)
        btn.Size = UDim2.new(0, 160, 0, 40)
        btn.Position = UDim2.new(0, 20, 0.5, -20)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Text = "Teleport UP: OFF"
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Draggable = true
        local toggled = false
        local original = nil

        btn.MouseButton1Click:Connect(function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if not toggled then
                original = hrp.Position
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
                btn.Text = "Teleport UP: ON"
            else
                hrp.CFrame = CFrame.new(original or hrp.Position - Vector3.new(0, 200, 0))
                btn.Text = "Teleport UP: OFF"
            end
            toggled = not toggled
        end)
    end
})

-- Speed boost
StealTab:Button({
    Title = "Speed Boost",
    Desc = "Increases your walking speed (94)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 94
            end
        end
    end
})
