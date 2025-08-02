local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanxHub - Steal a Brainrot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanxHub"
})

-- Loading Notification
OrionLib:MakeNotification({
    Name = "YoxanxHub Loaded",
    Content = "Welcome to Steal a Brainrot Hub!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Device Selection Tab
local DeviceTab = Window:Tab({
    Name = "Device",
    Icon = "monitor"
})

DeviceTab:Dropdown({
    Name = "Select Your Device",
    Default = "PC",
    Options = {"PC", "Mobile"},
    Callback = function(selected)
        if selected == "Mobile" then
            OrionLib:MakeNotification({
                Name = "Note",
                Content = "Mobile scaling not applied (currently cosmetic only).",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Store for toggles and state
local States = {
    InfiniteJump = false,
    Godmode = false,
    NoClip = false,
    Invisible = false,
    Fly = false,
    Chasing = false,
    HitboxESP = false,
    SavedPosition = nil
}

local MainTab = Window:Tab({
    Name = "Main",
    Icon = "swords"
})

-- Set / Return Location
MainTab:AddButton({
    Name = "Set Location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            States.SavedPosition = char.HumanoidRootPart.CFrame
            OrionLib:MakeNotification({Name = "Location Set", Content = "Saved current position!", Time = 3})
        end
    end
})

MainTab:AddButton({
    Name = "Return to Location",
    Callback = function()
        local char = LocalPlayer.Character
        if States.SavedPosition and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = States.SavedPosition
        else
            OrionLib:MakeNotification({Name = "No Saved Location", Content = "Use 'Set Location' first.", Time = 3})
        end
    end
})

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if States.InfiniteJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

MainTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(v) States.InfiniteJump = v end
})

-- Godmode
MainTab:AddToggle({
    Name = "Godmode",
    Default = false,
    Callback = function(enabled)
        States.Godmode = enabled
        if enabled then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local clone = hum:Clone()
                clone.Parent = char
                hum:Destroy()
                clone.Name = "Humanoid"
                workspace.CurrentCamera.CameraSubject = clone
            end
        end
    end
})

-- Rejoin Server
MainTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Reset Character
MainTab:AddButton({
    Name = "Force Reset",
    Callback = function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
})

-- Invisible
MainTab:AddToggle({
    Name = "Invisible",
    Default = false,
    Callback = function(v)
        States.Invisible = v
        local char = LocalPlayer.Character
        if not char then return end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.LocalTransparencyModifier = v and (v and (States.Invisible and 1 or 0))
            elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                v.Handle.LocalTransparencyModifier = States.Invisible and 1 or 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = not States.Invisible
            end
        end
    end
})

-- NoClip
RunService.Stepped:Connect(function()
    if States.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

MainTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(v) States.NoClip = v end
})

-- Fly
local flyConnection
MainTab:AddToggle({
    Name = "Fly (Hold Space/X)",
    Default = false,
    Callback = function(state)
        States.Fly = state
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if state and root and hum then
            hum.PlatformStand = true
            flyConnection = RunService.RenderStepped:Connect(function()
                local direction = hum.MoveDirection
                local speed = 28
                local velocity = direction * speed
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, speed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.X) then
                    velocity = velocity + Vector3.new(0, -speed, 0)
                end
                root.Velocity = velocity
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            hum.PlatformStand = false
            root.Velocity = Vector3.zero
        end
    end
})

-- Hitbox ESP (Box adornments on players)
local adornments = {}

local function ClearHitboxESP()
    for _, obj in pairs(adornments) do
        if obj and obj.Parent then obj:Destroy() end
    end
    adornments = {}
end

local function DrawHitboxESP()
    ClearHitboxESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Adornee = part
                    adorn.Size = part.Size
                    adorn.Transparency = 0.6
                    adorn.Color3 = Color3.fromRGB(170, 0, 255)
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 10
                    adorn.Parent = part
                    table.insert(adornments, adorn)
                end
            end
        end
    end
end

MainTab:AddToggle({
    Name = "Hitbox ESP",
    Default = false,
    Callback = function(v)
        States.HitboxESP = v
        if v then
            DrawHitboxESP()
        else
            ClearHitboxESP()
        end
    end
})

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local VisualTab = Window:Tab({
    Name = "Visual / Auto",
    Icon = "eye"
})

-- 🕓 ESP Base Timer
VisualTab:AddToggle({
    Name = "Base Timer ESP",
    Default = false,
    Callback = function(enabled)
        if not enabled then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BillboardGui") and v.Name == "TimerESP" then
                    v:Destroy()
                end
            end
            return
        end

        RunService.RenderStepped:Connect(function()
            for _, base in pairs(Workspace:GetDescendants()) do
                if base.Name == "BasePart" and base:IsA("Part") then
                    if not base:FindFirstChild("TimerESP") then
                        local gui = Instance.new("BillboardGui", base)
                        gui.Name = "TimerESP"
                        gui.Size = UDim2.new(0, 100, 0, 40)
                        gui.AlwaysOnTop = true
                        gui.StudsOffset = Vector3.new(0, 4, 0)

                        local label = Instance.new("TextLabel", gui)
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.TextColor3 = Color3.new(1, 1, 1)
                        label.TextStrokeTransparency = 0.5
                        label.Text = "Timer"
                    end

                    local gui = base:FindFirstChild("TimerESP")
                    if gui then
                        local label = gui:FindFirstChildOfClass("TextLabel")
                        if label then
                            local timerValue = base:FindFirstChild("Timer")
                            if timerValue and timerValue:IsA("NumberValue") then
                                label.Text = math.floor(timerValue.Value) .. "s"
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- 🤖 Auto Steal Nearby
VisualTab:AddToggle({
    Name = "Auto Steal",
    Default = false,
    Callback = function(state)
        getgenv().AutoSteal = state
        while getgenv().AutoSteal and task.wait(0.2) do
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.ObjectText == "Steal" and v.MaxActivationDistance >= 10 then
                    fireproximityprompt(v)
                end
            end
        end
    end
})

-- 🧠 Brainrot NPC Dropdown Teleport
local function GetBrainrotList()
    local brainrots = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name:find("Brainrot") then
            table.insert(brainrots, v.Name)
        end
    end
    return brainrots
end

VisualTab:AddDropdown({
    Name = "Teleport to Brainrot NPC",
    Options = GetBrainrotList(),
    Callback = function(npcName)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name == npcName and v:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:PivotTo(v.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
                break
            end
        end
    end
})

-- 🩻 X-Ray Player ESP
VisualTab:AddToggle({
    Name = "Player X-Ray ESP",
    Default = false,
    Callback = function(toggle)
        if toggle then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            local highlight = Instance.new("BoxHandleAdornment")
                            highlight.Name = "XRayESP"
                            highlight.Adornee = part
                            highlight.AlwaysOnTop = true
                            highlight.ZIndex = 10
                            highlight.Size = part.Size
                            highlight.Color3 = Color3.fromRGB(0, 255, 255)
                            highlight.Transparency = 0.5
                            highlight.Parent = part
                        end
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChild("XRayESP") then
                            part:FindFirstChild("XRayESP"):Destroy()
                        end
                    end
                end
            end
        end
    end
})
