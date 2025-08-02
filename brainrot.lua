-- OrionLib dari nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Buat jendela Key System
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false
})

-- Key yang benar
local correctKey = "YoxanxHub Fire"

-- Variabel untuk menampung input
local inputKey = ""

-- Buat tab untuk input key
local KeyTab = KeyWindow:MakeTab({
    Name = "Key Input",
    Icon = "rbxassetid://7733658504",
    PremiumOnly = false
})

-- Textbox untuk isi key
KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        inputKey = value
    end
})

-- Tombol cek key
KeyTab:AddButton({
    Name = "Check Key",
    Callback = function()
        if inputKey == correctKey then
            OrionLib:MakeNotification({
                Name = "Correct Key!",
                Content = "Access Granted to YoxanXHub.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            wait(1)
            KeyWindow:Destroy()

            -- Buka UI utama
            local MainWindow = OrionLib:MakeWindow({
                Name = "YoxanXHub - Steal a Brainrot",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

            MainWindow:MakeNotification({
                Name = "Welcome!",
                Content = "YoxanXHub Loaded Successfully!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            -- lanjutkan script 2/3 dan 3/3 di sini...

        else
            OrionLib:MakeNotification({
                Name = "Invalid Key",
                Content = "Key is incorrect. Try again.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
        end
    end
})
