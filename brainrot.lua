-- OrionLib by Nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Set your custom key
local correctKey = "YoxanxHub Fire"

-- Temporary window for key input
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false
})

-- Key Tab
local KeyTab = KeyWindow:Tab({
    Name = "Enter Key",
    Icon = "key"
})

-- Textbox for input
KeyTab:Textbox({
    Name = "Key Input",
    Default = "",
    TextDisappear = false,
    Callback = function(input)
        if input == correctKey then
            OrionLib:MakeNotification({
                Name = "Access Granted",
                Content = "Correct key! Loading YoxanXHub...",
                Image = "rbxassetid://4483345998",
                Time = 4
            })

            wait(1)
            KeyWindow:Destroy()

            -- Main UI after correct key
            local MainWindow = OrionLib:MakeWindow({
                Name = "YoxanXHub - Steal a Brainrot",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            MainWindow:MakeNotification({
                Name = "Welcome!",
                Content = "Enjoy using YoxanXHub!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            -- Continue with Script 2/3 and 3/3 here...

        else
            OrionLib:MakeNotification({
                Name = "Invalid Key",
                Content = "The key you entered is incorrect.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
        end
    end
})
