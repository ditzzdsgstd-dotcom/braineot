--// Load OrionLib (Nightmare Version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

--// Setup Window for Key System
local Window = OrionLib:MakeWindow({
    Name = "YoxanxHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanxHubKey"
})

--// Key Variable
local CorrectKey = "YoxanxHub Fire"
_G.UserKeyInput = ""

--// Notification Function
local function Notify(title, content)
    OrionLib:MakeNotification({
        Name = title,
        Content = content,
        Image = "rbxassetid://7733964641",
        Time = 4
    })
end

--// Key Tab
local KeyTab = Window:Tab({
    Name = "🔐 Key Verification",
    Icon = "key"
})

KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = false,
    Callback = function(value)
        _G.UserKeyInput = value
    end
})

KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if _G.UserKeyInput == CorrectKey then
            Notify("✅ Access Granted", "Correct Key! Loading YoxanxHub...")
            OrionLib:Destroy() -- Destroy the key UI
            task.wait(1)

            -- Reload OrionLib & Start Script 2/4
            local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local Window = OrionLib:MakeWindow({
                Name = "YoxanxHub",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanxHub"
            })

            _G.YoxanxWindow = Window -- Save the Window globally for use in other parts

            -- Ready for Script 2/4 to continue from here
        else
            Notify("❌ Incorrect Key", "Try again or get the correct key from Discord.")
        end
    end
})
