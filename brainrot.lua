-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Correct key
local CorrectKey = "YoxanXFree"
local UserInput = ""

-- Key input window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Key input tab
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

            task.delay(0.5, function()
                -- Completely reload OrionLib after destroying UI
                KeyWindow:Destroy()
                OrionLib = nil
                task.wait(0.5)

                OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
                _G.MainWindow = OrionLib:MakeWindow({
                    Name = "YoxanXHub | STEAL A BRAINROT",
                    HidePremium = false,
                    SaveConfig = true,
                    ConfigFolder = "YoxanXHub"
                })

                -- 🟩 You can now continue from script 2/4 using: _G.MainWindow
            end)

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
