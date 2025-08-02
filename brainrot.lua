-- Wait until the game is fully loaded
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Define correct key
local CorrectKey = "YoxanXFree"
local InputKey = ""

-- Create the initial key window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Create tab for key input
local KeyTab = KeyWindow:MakeTab({
    Name = "Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Textbox for entering the key
KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        InputKey = value
    end
})

-- Button to validate key
KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if InputKey == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Correct Key",
                Content = "Access granted to YoxanXHub.",
                Image = "rbxassetid://7733964641",
                Time = 3
            })

            task.wait(1)

            -- Destroy previous Orion UI
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "Orion" then
                    v:Destroy()
                end
            end

            })

-- Script 2/4: Main UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanXHub"
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7733760620",
    PremiumOnly = false
})

-- Godmode Toggle
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
            warn("To disable Godmode, manually reset your character.")
        end
    end
})

-- Rejoin Button
MainTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})
		
})
                
        else
            OrionLib:MakeNotification({
                Name = "Wrong Key",
                Content = "The key is incorrect. Try again.",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})
