-- Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Services and variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local infiniteAmmoEnabled = false
local killEnemyEnabled = false
local espEnabled = false

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Naval Warfare",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "YoxanXHub"
})

-- MAIN TAB
local MainTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://7734053493",
    PremiumOnly = false
})

-- Infinite Ammo Toggle
MainTab:AddToggle({
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(state)
        infiniteAmmoEnabled = state
        if state then
            task.spawn(function()
                while infiniteAmmoEnabled and task.wait(3) do
                    pcall(function()
                        local oh_get_gc = getgc or false
                        local oh_is_x_closure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or checkclosure or false
                        local oh_get_info = debug.getinfo or getinfo or false
                        local oh_set_upvalue = debug.setupvalue or setupvalue or setupval or false

                        if not oh_get_gc or not oh_get_info or not oh_set_upvalue then return end

                        local function oh_find_function(name)
                            for _, v in pairs(oh_get_gc()) do
                                if type(v) == "function" and not oh_is_x_closure(v) then
                                    if oh_get_info(v).name == name then return v end
                                end
                            end
                        end

                        local oh_reload = oh_find_function("reload")
                        if oh_reload then
                            oh_set_upvalue(oh_reload, 4, math.huge)
                        end
                    end)
                end
            end)
        end
    end
})

-- Kill Enemy Toggle
MainTab:AddToggle({
    Name = "Auto Kill Enemies",
    Default = false,
    Callback = function(state)
        killEnemyEnabled = state
        if state then
            task.spawn(function()
                while killEnemyEnabled and task.wait(0.1) do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, v in pairs(workspace:GetDescendants()) do
                                if v:IsA("Humanoid") and v.Parent and v.Parent:FindFirstChild("HumanoidRootPart") then
                                    local target = Players:GetPlayerFromCharacter(v.Parent)
                                    if target and target.Team ~= LocalPlayer.Team then
                                        local Event = ReplicatedStorage:WaitForChild("Event")
                                        Event:FireServer("shootRifle", "", {v.Parent.HumanoidRootPart})
                                        Event:FireServer("shootRifle", "hit", {v})
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- ESP Toggle
MainTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if not state then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    p.Character:FindFirstChild("Totally NOT Esp")?.Destroy()
                    p.Character:FindFirstChild("Icon")?.Destroy()
                end
            end
            return
        end

        task.spawn(function()
            while espEnabled and task.wait(1) do
                pcall(function()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)

                            if not player.Character:FindFirstChild("Totally NOT Esp") then
                                local hl = Instance.new("Highlight", player.Character)
                                hl.Name = "Totally NOT Esp"
                                hl.Adornee = player.Character
                                hl.FillColor = player.TeamColor.Color
                                hl.FillTransparency = 0.5
                                hl.OutlineTransparency = 0
                            end

                            if not player.Character:FindFirstChild("Icon") then
                                local billboard = Instance.new("BillboardGui", player.Character)
                                billboard.Name = "Icon"
                                billboard.AlwaysOnTop = true
                                billboard.Size = UDim2.new(0, 200, 0, 50)
                                billboard.Adornee = player.Character.Head

                                local label = Instance.new("TextLabel", billboard)
                                label.Name = "ESP Text"
                                label.BackgroundTransparency = 1
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.Font = Enum.Font.SciFi
                                label.Text = player.Name .. " | " .. dist
                                label.TextColor3 = player.TeamColor.Color
                                label.TextSize = 18
                            else
                                player.Character.Icon["ESP Text"].Text = player.Name .. " | " .. dist
                            end
                        end
                    end
                end)
            end
        end)
    end
})

-- Notification
OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Combat tab loaded (Part 1/2)",
    Image = "rbxassetid://7733960981",
    Time = 4
})

-- === TELEPORT TAB ===
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://7734053493",
    PremiumOnly = false
})

-- Teleport buttons
local teleportButtons = {
    {Title = "Japan Lobby", CFrame = CFrame.new(-4.103, -295.5, -36.644)},
    {Title = "America Lobby", CFrame = CFrame.new(15.0, -295.5, 46.504)},
    {Title = "America Harbour", CFrame = CFrame.new(-50.992, 23.0, 8129.594)},
    {Title = "Japan Harbour", CFrame = CFrame.new(-150.507, 23.0, -8160.172)}
}

for _, btn in ipairs(teleportButtons) do
    TeleportTab:AddButton({
        Name = btn.Title,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = btn.CFrame
                OrionLib:MakeNotification({
                    Name = "Teleported",
                    Content = "Moved to " .. btn.Title,
                    Image = "rbxassetid://7734053493",
                    Time = 3
                })
            end
        end
    })
end

-- Island teleport
local function teleportToIsland(islandCode)
    local islands = workspace:FindFirstChild("Islands")
    if not islands then return end

    for _, island in pairs(islands:GetChildren()) do
        local code = island:FindFirstChild("IslandCode")
        local post = island:FindFirstChild("Flag") and island.Flag:FindFirstChild("Post")
        if code and code:IsA("StringValue") and code.Value == islandCode and post then
            LocalPlayer.Character.HumanoidRootPart.CFrame = post.CFrame
            OrionLib:MakeNotification({
                Name = "Island Teleport",
                Content = "Teleported to Island " .. islandCode,
                Image = "rbxassetid://7734053493",
                Time = 3
            })
            return
        end
    end

    OrionLib:MakeNotification({
        Name = "Teleport Failed",
        Content = "Island " .. islandCode .. " not found.",
        Image = "rbxassetid://7734053493",
        Time = 3
    })
end

TeleportTab:AddButton({ Name = "Island A", Callback = function() teleportToIsland("A") end })
TeleportTab:AddButton({ Name = "Island B", Callback = function() teleportToIsland("B") end })
TeleportTab:AddButton({ Name = "Island C", Callback = function() teleportToIsland("C") end })

-- === PLAYER TAB ===
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://7734053122",
    PremiumOnly = false
})

-- GodMode
PlayerTab:AddButton({
    Name = "GodMode (Safe Teleport)",
    Callback = function()
        local team = LocalPlayer.Team and LocalPlayer.Team.Name or "Unknown"
        if team == "Japan" then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-150.507, 23.0, -8160.172)
            OrionLib:MakeNotification({ Name = "GodMode", Content = "Teleported to Japan Harbour", Time = 3 })
        elseif team == "USA" then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-50.992, 23.0, 8129.594)
            OrionLib:MakeNotification({ Name = "GodMode", Content = "Teleported to USA Harbour", Time = 3 })
        else
            OrionLib:MakeNotification({ Name = "GodMode", Content = "Team not recognized", Time = 3 })
        end
    end
})

-- Stop Auto Kill
PlayerTab:AddButton({
    Name = "Stop Kill Enemy",
    Callback = function()
        getgenv().killEnemyEnabled = false
        OrionLib:MakeNotification({ Name = "Auto-Kill", Content = "Disabled", Time = 3 })
    end
})

-- Premium locked: Infinite Jump
PlayerTab:AddButton({
    Name = "Infinite Jump (Locked)",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Premium Feature",
            Content = "Unlock with YoxanX Premium",
            Time = 3
        })
    end
})

-- Premium locked: Speed Boost
PlayerTab:AddButton({
    Name = "Speed Boost (Locked)",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Premium Feature",
            Content = "Unlock with YoxanX Premium",
            Time = 3
        })
    end
})

-- Final message
OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Part 2/2 Loaded",
    Image = "rbxassetid://7733960981",
    Time = 4
})
