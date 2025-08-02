-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Create temporary window for key UI
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub Key System",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "YoxanXHubKey"
})

local correctKey = "YoxanXFree"
local inputKey = ""

local KeyTab = KeyWindow:Tab({
    Name = "Key Input",
    Icon = "lock"
})

KeyTab:AddTextbox({
    Name = "Enter your key",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        inputKey = Value
    end
})

KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if inputKey == correctKey then
            OrionLib:MakeNotification({
                Name = "Correct Key",
                Content = "Access granted!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })

            task.delay(1.5, function()
                OrionLib:Destroy()

                -- RELOAD OrionLib clean for the main UI (Script 2/4 will continue here)
                local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
                local Window = OrionLib:MakeWindow({
                    Name = "YoxanXHub",
                    HidePremium = false,
                    SaveConfig = true,
                    ConfigFolder = "YoxanXHub"
                })

                -- Script 2/4 begins here (Godmode, ESP, etc.)
                -- Tinggal lanjut di bawah ini
            end)
        else
            OrionLib:MakeNotification({
                Name = "Incorrect Key",
                Content = "Please try again.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
