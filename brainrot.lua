-- Load OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local infiniteAmmoEnabled = false
local killEnemyEnabled = false
local espEnabled = false

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Naval Warfare",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub"
})

-- Functions
local function InfiniteAmmo(state)
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

local function KillEnemy()
    killEnemyEnabled = true
    OrionLib:MakeNotification({
        Name = "Kill Enemy",
        Content = "Auto-kill activated.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
    task.spawn(function()
        while killEnemyEnabled and task.wait(0.1) do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Humanoid") and v.Parent and v.Parent:FindFirstChild("HumanoidRootPart") then
                            local targetPlayer = Players:GetPlayerFromCharacter(v.Parent)
                            if targetPlayer and targetPlayer.Team ~= LocalPlayer.Team then
                                local Event = game:GetService("ReplicatedStorage"):WaitForChild("Event")
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

local function ESPS(state)
    espEnabled = state
    if not state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                pcall(function()
                    p.Character:FindFirstChild("Totally NOT Esp")?.Destroy()
                    p.Character:FindFirstChild("Icon")?.Destroy()
                end)
            end
        end
        return
    end

    task.spawn(function()
        while espEnabled do
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)

                        if not player.Character:FindFirstChild("Totally NOT Esp") then
                            local highlight = Instance.new("Highlight", player.Character)
                            highlight.Name = "Totally NOT Esp"
                            highlight.Adornee = player.Character
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.FillColor = player.TeamColor.Color
                            highlight.FillTransparency = 0.5
                        end

                        if not player.Character:FindFirstChild("Icon") then
                            local billboard = Instance.new("BillboardGui", player.Character)
                            billboard.Name = "Icon"
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.AlwaysOnTop = true
                            billboard.Adornee = player.Character.Head

                            local label = Instance.new("TextLabel", billboard)
                            label.Name = "ESP Text"
                            label.BackgroundTransparency = 1
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.Font = Enum.Font.SciFi
                            label.TextColor3 = player.TeamColor.Color
                            label.TextSize = 18
                            label.Text = player.Name .. " | " .. dist
                        else
                            player.Character.Icon["ESP Text"].Text = player.Name .. " | " .. dist
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

-- Tabs and Sections
local MainTab = Window:MakeTab({ Name = "Main", Icon = "rbxassetid://7733920766", PremiumOnly = false })
MainTab:AddToggle({ Name = "Infinite Ammo", Default = false, Callback = InfiniteAmmo })
MainTab:AddToggle({ Name = "ESP", Default = false, Callback = ESPS })
MainTab:AddButton({ Name = "Kill Enemy", Callback = KillEnemy })

local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://7734053493", PremiumOnly = false })

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
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        end
    })
end

local function teleportToIsland(islandCode)
    local islands = workspace:FindFirstChild("Islands")
    if not islands then return end

    for _, island in pairs(islands:GetChildren()) do
        local code = island:FindFirstChild("IslandCode")
        local flagPost = island:FindFirstChild("Flag") and island.Flag:FindFirstChild("Post")
        if code and code:IsA("StringValue") and code.Value == islandCode and flagPost then
            LocalPlayer.Character.HumanoidRootPart.CFrame = flagPost.CFrame
            OrionLib:MakeNotification({
                Name = "Teleported",
                Content = "Island " .. islandCode,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
    end
end

TeleportTab:AddButton({ Name = "Island A", Callback = function() teleportToIsland("A") end })
TeleportTab:AddButton({ Name = "Island B", Callback = function() teleportToIsland("B") end })
TeleportTab:AddButton({ Name = "Island C", Callback = function() teleportToIsland("C") end })

local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://7734053122", PremiumOnly = false })
PlayerTab:AddButton({
    Name = "GodMode (Safe Teleport)",
    Callback = function()
        local team = LocalPlayer.Team and LocalPlayer.Team.Name or "Unknown"
        if team == "Japan" then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-150.507, 23.0, -8160.172)
        elseif team == "USA" then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-50.992, 23.0, 8129.594)
        else
            OrionLib:MakeNotification({ Name = "Unknown Team", Content = "No teleport", Time = 3 })
        end
    end
})

PlayerTab:AddButton({
    Name = "Stop Kill Enemy",
    Callback = function()
        killEnemyEnabled = false
        OrionLib:MakeNotification({ Name = "Auto-Kill Disabled", Content = "", Time = 3 })
    end
})

PlayerTab:AddButton({
    Name = "Infinite Jump (Premium)",
    Callback = function()
        OrionLib:MakeNotification({ Name = "Locked", Content = "Premium only.", Time = 3 })
    end
})

PlayerTab:AddButton({
    Name = "Speed Boost (Premium)",
    Callback = function()
        OrionLib:MakeNotification({ Name = "Locked", Content = "Premium only.", Time = 3 })
    end
})

-- Final Notification
OrionLib:MakeNotification({
    Name = "YoxanXHub",
    Content = "Loaded successfully!",
    Image = "rbxassetid://7733960981",
    Time = 5
})
