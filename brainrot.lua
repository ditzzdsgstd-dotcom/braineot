-- Wait until game fully loads
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (dari Nightmare)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Delay supaya UI bisa tampil normal
task.wait(0.5)

-- Create the window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Create tab
local Tab = Window:MakeTab({
    Name = "Key Input",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Create textbox
Tab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        print("Entered Key: ", Value)
    end
})

-- Create button
Tab:AddButton({
    Name = "Submit Key",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Notification",
            Content = "Button Pressed!",
            Image = "rbxassetid://7733964641",
            Time = 3
        })
    end
})
