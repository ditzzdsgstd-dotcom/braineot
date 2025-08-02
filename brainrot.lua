-- Load OrionLib from Nightmare repo
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Create key window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHubKey"
})

-- Setup correct key
local CorrectKey = "YoxanxHub Fire"
_G.UserInput = ""

-- Create Key Tab
local KeyTab = Window:MakeTab({
    Name = "Key Verification",
    Icon = "rbxassetid://7734053497", -- Any icon works
    PremiumOnly = false
})

-- Textbox for entering key
KeyTab:AddTextbox({
    Name = "Enter Your Key",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        _G.UserInput = Value
    end
})

-- Button to check key
KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if _G.UserInput == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Access Granted",
                Content = "Key correct! Loading YoxanXHub...",
                Image = "rbxassetid://7733964641",
                Time = 4
            })
            OrionLib:Destroy() -- destroy key UI
            task.wait(1)

            -- Load OrionLib again for main UI
            local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local Window = OrionLib:MakeWindow({
                Name = "YoxanXHub",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            -- Save Window globally for future tabs
            _G.YoxanWindow = Window

            -- You may continue Script 2/4 here, or in separate loadstring
        else
            OrionLib:MakeNotification({
                Name = "Incorrect Key",
                Content = "Wrong key entered. Get the correct one from Discord.",
                Image = "rbxassetid://7733964641",
                Time = 4
            })
        end
    end
})
