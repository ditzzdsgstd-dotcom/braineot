-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Correct key
local CorrectKey = "YoxanXFree"

-- Make the key input window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Create key tab
local KeyTab = KeyWindow:MakeTab({
    Name = "Enter Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Input variable
local UserInput = ""

-- Textbox input
KeyTab:AddTextbox({
    Name = "Type the Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        UserInput = Value
    end
})

-- Submit button
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

            task.wait(1)

            -- Destroy Key UI
            KeyWindow:Destroy()

            -- Reload Orion for main UI
            local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local Window = OrionLib:MakeWindow({
                Name = "YoxanXHub | Steal A Brainrot",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            -- NOTE: You can now continue Script 2/4 after this manually
        else
            OrionLib:MakeNotification({
                Name = "Incorrect",
                Content = "Wrong Key Entered.",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})
