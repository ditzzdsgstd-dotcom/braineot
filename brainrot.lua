-- Load OrionLib from nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Set your key
local CorrectKey = "YoxanxHub Fire"
local KeyEntered = ""

-- Create main window for key input
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub Key",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

local Tab = Window:Tab({
    Name = "Key System",
    Icon = "key"
})

Tab:AddTextbox({
    Title = "Enter Your Key",
    Placeholder = "Type the key here",
    Default = "",
    Callback = function(text)
        KeyEntered = text
    end
})

Tab:AddButton({
    Title = "Submit Key",
    Callback = function()
        if KeyEntered == CorrectKey then
            OrionLib:MakeNotification({
                Name = "✅ Access Granted",
                Content = "Welcome to YoxanXHub!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            -- Wait before removing key UI
            wait(1)
            game:GetService("CoreGui"):FindFirstChild("Orion"):Destroy()

            -- Your main script goes here (example: load main hub)
            loadstring(game:HttpGet("https://your-script-url.com/script.lua"))()
        else
            OrionLib:MakeNotification({
                Name = "❌ Invalid Key",
                Content = "The key you entered is incorrect.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})
                
-- Reload OrionLib for the main UI
OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Main UI Window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanXHub"
})

OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Script loaded successfully!",
    Time = 3
})

-- Main Functional Tab
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "settings"
})

-- Godmode
MainTab:Toggle({
    Title = "Godmode",
    Desc = "Makes your character immortal (reset to disable)",
    Default = false,
    Callback = function(state)
        local Player = game:GetService("Players").LocalPlayer
        if state then
            local Char = Player.Character or Player.CharacterAdded:Wait()
            local Humanoid = Char:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                local Clone = Humanoid:Clone()
                Clone.Parent = Char
                Humanoid:Destroy()
                Clone.Name = "Humanoid"
                workspace.CurrentCamera.CameraSubject = Clone
            end
        else
            warn("To disable Godmode, reset your character manually.")
        end
    end
})

-- Rejoin Current Server
MainTab:Button({
    Title = "Rejoin Server",
    Desc = "Rejoins the current game server (after godmode)",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        pcall(function()
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end)
    end
})

-- Infinite Jump
MainTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Allows you to jump infinitely",
    Default = false,
    Callback = function(state)
        local UIS = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChildOfClass("Humanoid")
        if state then
            _G.InfiniteJump = UIS.JumpRequest:Connect(function()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if _G.InfiniteJump then _G.InfiniteJump:Disconnect() end
        end
    end
})

-- Force Reset
MainTab:Button({
    Title = "Reset Character",
    Desc = "Forces your character to reset",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
        end
    end
})

-- Visual Tab
local VisualTab = Window:Tab({
    Name = "Visual",
    Icon = "eye"
})

-- ESP Timer: Show Base Open Countdown
VisualTab:Toggle({
    Title = "Show Base Timer",
    Desc = "Displays countdown until base opens above it",
    Default = false,
    Callback = function(state)
        local function updateTimers()
            for _, base in ipairs(workspace:GetDescendants()) do
                if base:IsA("Model") and base:FindFirstChild("OpenTimer") then
                    local head = base:FindFirstChild("Head") or base:FindFirstChildWhichIsA("BasePart")
                    if head then
                        if state then
                            if not head:FindFirstChild("TimerBillboard") then
                                local billboard = Instance.new("BillboardGui", head)
                                billboard.Name = "TimerBillboard"
                                billboard.Size = UDim2.new(0, 100, 0, 40)
                                billboard.StudsOffset = Vector3.new(0, 3, 0)
                                billboard.AlwaysOnTop = true

                                local label = Instance.new("TextLabel", billboard)
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                                label.TextStrokeTransparency = 0
                                label.TextScaled = true
                                label.Font = Enum.Font.GothamBold
                                label.Name = "TimerLabel"
                            end
                        else
                            if head:FindFirstChild("TimerBillboard") then
                                head.TimerBillboard:Destroy()
                            end
                        end
                    end
                end
            end
        end

        game:GetService("RunService").RenderStepped:Connect(function()
            if state then
                for _, base in ipairs(workspace:GetDescendants()) do
                    if base:IsA("Model") and base:FindFirstChild("OpenTimer") then
                        local head = base:FindFirstChild("Head") or base:FindFirstChildWhichIsA("BasePart")
                        if head and head:FindFirstChild("TimerBillboard") then
                            local timer = base.OpenTimer
                            local label = head.TimerBillboard:FindFirstChild("TimerLabel")
                            if label then
                                label.Text = tostring(math.floor(timer.Value)) .. "s"
                            end
                        end
                    end
                end
            end
        end)

        updateTimers()
    end
})

-- ESP Player (Body + Name)
VisualTab:Toggle({
    Title = "ESP Player",
    Desc = "Highlights all player bodies and names",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local function createESP(player)
            if player == Players.LocalPlayer then return end
            local char = player.Character
            if not char then return end

            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("XRay") then
                    local box = Instance.new("BoxHandleAdornment", part)
                    box.Name = "XRay"
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                    box.Transparency = 0.5
                    box.Color3 = Color3.fromRGB(0, 255, 0)
                end
            end

            local head = char:FindFirstChild("Head")
            if head and not head:FindFirstChild("NameTag") then
                local billboard = Instance.new("BillboardGui", head)
                billboard.Name = "NameTag"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true

                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = player.Name
                text.TextColor3 = Color3.new(1, 1, 1)
                text.TextStrokeColor3 = Color3.new(0, 0, 0)
                text.TextStrokeTransparency = 0
                text.TextScaled = true
                text.Font = Enum.Font.GothamBold
            end
        end

        local function clearESP(player)
            local char = player.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:FindFirstChild("XRay") then
                        part.XRay:Destroy()
                    end
                end
            end
            local head = char:FindFirstChild("Head")
            if head and head:FindFirstChild("NameTag") then
                head.NameTag:Destroy()
            end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if state then
                createESP(p)
            else
                clearESP(p)
            end
        end

        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if state then
                    wait(1)
                    createESP(p)
                end
            end)
        end)

        Players.PlayerRemoving:Connect(function(p)
            clearESP(p)
        end)
    end
})

-- Auto Steal (Experimental)
VisualTab:Button({
    Title = "Auto Steal (Beta)",
    Desc = "Tries to steal nearby open brainrot bases automatically",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local function trySteal()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent and obj.Parent:FindFirstChild("OpenTimer") then
                    if obj.Parent.OpenTimer.Value <= 1 then
                        fireproximityprompt(obj)
                    end
                end
            end
        end

        while task.wait(1) do
            pcall(trySteal)
        end
    end
})
