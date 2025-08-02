-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local CorrectKey = "YoxanXFree"
local UserInput = ""

-- Create Key UI Window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Key Tab
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

-- Submit Button
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
                -- 🔥 Manual Orion destroy
                for _, v in pairs(game.CoreGui:GetChildren()) do
                    if v.Name == "Orion" then
                        v:Destroy()
                    end
                end

                -- 🔁 Reload Orion
                OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
                _G.MainWindow = OrionLib:MakeWindow({
                    Name = "YoxanXHub",
                    HidePremium = false,
                    SaveConfig = true,
                    ConfigFolder = "YoxanXHub"
                })

                -- ✅ Ready for 2/4 using _G.MainWindow
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
