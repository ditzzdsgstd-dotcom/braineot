repeat task.wait() until game:IsLoaded()

-- Correct Key
local CorrectKey = "YoxanXFree"
local UserInput = ""

-- Load OrionLib (Nightmare)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Key UI Window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

local KeyTab = KeyWindow:MakeTab({
    Name = "Enter Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

KeyTab:AddTextbox({
    Name = "Type the Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        UserInput = Value
    end
})

KeyTab:AddButton({
    Name = "Submit",
    Callback = function()
        if UserInput == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Correct Key",
                Content = "Welcome to YoxanXHub!",
                Image = "rbxassetid://7733964641",
                Time = 3
            })

            -- Wait before clearing UI
            task.wait(1)

            -- Destroy all Orion UI instances
            for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
                if gui.Name == "Orion" then
                    gui:Destroy()
                end
            end

            -- Reload OrionLib for main UI
            local OrionLibMain = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local Window = OrionLibMain:MakeWindow({
                Name = "YoxanXHub",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            -- Load Script 2/4
            

        else
            OrionLib:MakeNotification({
                Name = "Wrong Key",
                Content = "Try again.",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})
