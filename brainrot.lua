-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Key value
local CorrectKey = "YoxanxHubFire"

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

            -- Load Main Hub (Script 2/4)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YoxanXHub/Steal-Brainrot-Hub/main/2.lua"))()
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
