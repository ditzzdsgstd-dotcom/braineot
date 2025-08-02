-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Key value
local CorrectKey = "YoxanXFree"

-- Create initial window for key input
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Make the tab for key entry
local KeyTab = KeyWindow:MakeTab({
    Name = "Enter Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Temporary variable for user input
local UserInput = ""

-- Textbox for entering key
KeyTab:AddTextbox({
    Name = "Type the Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        UserInput = Value
    end
})

-- Button to submit key
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

            -- Wait and destroy current window
            task.wait(1)
            KeyWindow:Destroy()

            -- OrionLib by Nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanXHub"
})

-- Main Tab
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "home"
})

MainTab:Toggle({
    Name = "Godmode",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local clone = humanoid:Clone()
                clone.Parent = char
                humanoid:Destroy()
                clone.Name = "Humanoid"
                workspace.CurrentCamera.CameraSubject = clone
            end
        end
    end
})

MainTab:Button({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        TeleportService:Teleport(game.PlaceId, player)
    end
})

-- ESP Tab
local ESPTab = Window:Tab({
    Name = "Visuals",
    Icon = "eye"
})

local function highlightPlayer(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "YoxanXESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
end

local function clearESP()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("YoxanXESP") then
            plr.Character:FindFirstChild("YoxanXESP"):Destroy()
        end
    end
end

local espEnabled = false
ESPTab:Toggle({
    Name = "X-Ray Players",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if not state then
            clearESP()
        end
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and not plr.Character:FindFirstChild("YoxanXESP") then
                highlightPlayer(plr)
            end
        end
    end
end)

                
            OrionLib:MakeNotification({
                Name = "Incorrect",
                Content = "Wrong Key Entered.",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})
