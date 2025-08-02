-- Wait for game load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib from Nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Add a short delay to make sure GUI renders properly
task.wait(0.5)

-- Create Key System Window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Your key setup
local CorrectKey = "YoxanxHub Fire"
_G.EnteredKey = ""

-- Make a proper tab (MUST be done after window is initialized!)
local KeyTab = KeyWindow:MakeTab({
    Name = "Enter Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Add TextBox to enter key
KeyTab:AddTextbox({
    Name = "Key Input",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        _G.EnteredKey = Value
    end
})

-- Add Button to check key
KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if _G.EnteredKey == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Correct Key",
                Content = "Access Granted!",
                Image = "rbxassetid://7733964641",
                Time = 3
            })

            OrionLib:Destroy() -- destroy key window
            task.wait(1)

            -- Load main UI here (reloading OrionLib and window)
            local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local MainWindow = OrionLib:MakeWindow({
                Name = "YoxanXHub | Main",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            -- Save window globally for later use
            _G.YoxanWindow = MainWindow
        else
            OrionLib:MakeNotification({
                Name = "Wrong Key",
                Content = "Invalid key entered!",
                Image = "rbxassetid://7733964641",
                Time = 3
            })
        end
    end
})
