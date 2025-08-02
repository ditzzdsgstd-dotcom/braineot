-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local CorrectKey = "YoxanXFree"
local UserInput = ""

-- Create Key UI Window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | KeyY System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Key Tab
local KeyTab = KeyWindow:MakeTab({
    Name = "Enter Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Textbox
KeyTab:AddTextbox({
    Name = "Type the Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        UserInput = Value
    end
})

-- Submit Button
KeyTab:AddButton({
    Name = "Submit",
    Callback = function()
        if UserInput == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Success",
                Content = "Correct Key!",
                Image = "rbxassetid://7733964641",
                Time = 3
            })

            task.delay(0.5, function()
                -- 🔥 Manual Orion destroy
                for _, v in pairs(game.CoreGui:GetChildren()) do
                    if v.Name == "Orion" then
                        v:Destroy()
                    end
                end

                -- 🔁 Reload Orion
                OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
                _G.MainWindow = OrionLib:MakeWindow({
                    Name = "YoxanXHub",
                    HidePremium = false,
                    SaveConfig = true,
                    ConfigFolder = "YoxanXHub"
                })

                -- Check if main window exists
if not _G.MainWindow then return end

-- 🛡️ Main Tab
local MainTab = _G.MainWindow:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Godmode",
    Default = false,
    Callback = function(state)
        local Player = game:GetService("Players").LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if state and Humanoid then
            local Clone = Humanoid:Clone()
            Clone.Parent = Character
            Humanoid:Destroy()
            Clone.Name = "Humanoid"
            workspace.CurrentCamera.CameraSubject = Clone
        end
    end
})

MainTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Player = game:GetService("Players").LocalPlayer
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})


-- 🎯 Steal Tab
local StealTab = _G.MainWindow:MakeTab({
    Name = "Steal",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

StealTab:AddButton({
    Name = "Speed Boost (94 WS)",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 94
    end
})

StealTab:AddButton({
    Name = "Float GUI",
    Callback = function()
        local gui = Instance.new("ScreenGui", game.CoreGui)
        gui.Name = "FloatGUI"

        local btn = Instance.new("TextButton", gui)
        btn.Size = UDim2.new(0, 150, 0, 40)
        btn.Position = UDim2.new(0.5, -75, 0.5, -20)
        btn.Text = "Float Up"
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Draggable = true

        local toggled = false
        local originalPos = nil

        btn.MouseButton1Click:Connect(function()
            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if not toggled then
                originalPos = root.Position
                root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
                btn.Text = "Float Down"
            else
                root.CFrame = CFrame.new(originalPos or root.Position - Vector3.new(0, 200, 0))
                btn.Text = "Float Up"
            end
            toggled = not toggled
        end)
    end
})


-- 🧠 ESP Tab
local VisualTab = _G.MainWindow:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://7734098371",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "Base Timer ESP",
    Default = false,
    Callback = function(state)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TextLabel") and string.find(obj.Name:lower(), "timer") then
                obj.Visible = state
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "X-Ray Player ESP",
    Default = false,
    Callback = function(state)
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = state and 0.5 or 0
                        part.Material = state and Enum.Material.ForceField or Enum.Material.Plastic
                    end
                end
            end
        end
    end
})
                    
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Add new tab
local ExtraTab = Window:MakeTab({
    Name = "Extra Tools",
    Icon = "rocket",
    PremiumOnly = false
})

-- BASE TIMER ESP (looks for countdowns near base)
ExtraTab:AddToggle({
    Name = "Base Timer ESP",
    Default = false,
    Callback = function(state)
        if state then
            OrionLib:MakeNotification({
                Name = "Base Timer ESP",
                Content = "Enabled - Timer will appear above bases",
                Image = "rbxassetid://7733964641",
                Time = 4
            })
            game:GetService("RunService").RenderStepped:Connect(function()
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Text:find("s") and v.Visible then
                        v.TextColor3 = Color3.fromRGB(255, 100, 100)
                        v.TextStrokeTransparency = 0.5
                    end
                end
            end)
        else
            OrionLib:MakeNotification({
                Name = "Base Timer ESP",
                Content = "Disabled",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})

-- SERVER HOP (joins lowest pop server)
ExtraTab:AddButton({
    Name = "Server Hop (Low Server)",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local Servers = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local ServerData = HttpService:JSONDecode(Servers)

        for _, server in pairs(ServerData.data) do
            if server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
})

-- SPEED BOOST
local Walkspeed = 16
ExtraTab:AddToggle({
    Name = "Speed Boost (WalkSpeed 40)",
    Default = false,
    Callback = function(state)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        if state then
            Walkspeed = hum.WalkSpeed
            hum.WalkSpeed = 40
        else
            hum.WalkSpeed = Walkspeed
        end
    end
})

-- FLOAT GUI
ExtraTab:AddButton({
    Name = "Floating Button",
    Callback = function()
        local ButtonGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        ButtonGui.Name = "FloatButton"

        local Float = Instance.new("TextButton", ButtonGui)
        Float.Size = UDim2.new(0, 120, 0, 40)
        Float.Position = UDim2.new(0, 20, 0.5, -20)
        Float.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Float.TextColor3 = Color3.new(1,1,1)
        Float.Text = "Toggle UI"
        Float.Font = Enum.Font.GothamBold
        Float.TextSize = 16

        Float.MouseButton1Click:Connect(function()
            local ui = game:GetService("CoreGui"):FindFirstChild("Orion") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Orion")
            if ui then
                ui.Enabled = not ui.Enabled
            end
        end)
    end
})      
                
