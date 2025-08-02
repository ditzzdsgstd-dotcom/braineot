-- Load OrionLib from Nightmare
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local CorrectKey = "YoxanxHub Fire"
local userKey = ""

-- Create Window
local Window = OrionLib:MakeWindow({
	Name = "YoxanxHub | Key System",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "YoxanxHubKey"
})

-- Key Tab
local KeyTab = Window:Tab({
	Name = "🔑 Enter Key",
	Icon = "key"
})

-- Input field
KeyTab:Textbox({
	Name = "Enter Your Key",
	Default = "",
	Placeholder = "Type your key...",
	Callback = function(value)
		userKey = value
	end
})

-- Submit button
KeyTab:Button({
	Name = "🔓 Submit Key",
	Callback = function()
		if userKey == CorrectKey then
			OrionLib:MakeNotification({
				Name = "✅ Access Granted",
				Content = "Welcome to YoxanxHub!",
				Image = "rbxassetid://7733964641",
				Time = 4
			})

			wait(1)
			OrionLib:Destroy()

			-- Paste 2/3 features script here

		else
			OrionLib:MakeNotification({
				Name = "❌ Invalid Key",
				Content = "Wrong key, try again.",
				Image = "rbxassetid://7733964641",
				Time = 4
			})
		end
	end
})

-- Discord Invite Button
KeyTab:Button({
	Name = "📋 Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/Az8Cm2F6")
		OrionLib:MakeNotification({
			Name = "📎 Copied",
			Content = "Discord link copied to clipboard.",
			Image = "rbxassetid://7733964641",
			Time = 3
		})
	end
})

-- Re-create OrionLib after key UI destroyed
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
local Window = OrionLib:MakeWindow({
	Name = "YoxanxHub | Main",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "YoxanxHubMain"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Main Tab
local MainTab = Window:Tab({
	Name = "🛠 Main",
	Icon = "settings"
})

-- Godmode
MainTab:Toggle({
	Name = "Godmode",
	Default = false,
	Callback = function(state)
		if state then
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				local clone = hum:Clone()
				clone.Parent = char
				hum:Destroy()
				clone.Name = "Humanoid"
				workspace.CurrentCamera.CameraSubject = clone
			end
		end
	end
})

-- Rejoin
MainTab:Button({
	Name = "Rejoin Server",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local PlaceId = game.PlaceId
		local JobId = game.JobId
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
	end
})

-- Fly
local flying = false
local flyConn
MainTab:Toggle({
	Name = "Fly (PC Only)",
	Default = false,
	Callback = function(state)
		flying = state
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if not (hrp and hum) then return end
		hum.PlatformStand = state
		if flyConn then flyConn:Disconnect() end
		if flying then
			flyConn = RunService.RenderStepped:Connect(function()
				local move = hum.MoveDirection * 40
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					move = move + Vector3.new(0, 40, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.X) then
					move = move + Vector3.new(0, -40, 0)
				end
				hrp.Velocity = move
			end)
		else
			if flyConn then flyConn:Disconnect() end
			hrp.Velocity = Vector3.zero
			hum.PlatformStand = false
		end
	end
})

-- Infinite Jump
local ijEnabled = false
local ijConn
MainTab:Toggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(state)
		ijEnabled = state
		if ijConn then ijConn:Disconnect() end
		if ijEnabled then
			ijConn = UserInputService.JumpRequest:Connect(function()
				local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
			end)
		end
	end
})

-- Reset
MainTab:Button({
	Name = "Force Reset",
	Callback = function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.Health = 0 end
	end
})

-- Hitbox ESP
local espEnabled = false
local espConnections = {}
function clearESP()
	for _, adorn in pairs(espConnections) do
		if adorn then adorn:Destroy() end
	end
	table.clear(espConnections)
end

function createESPForPlayer(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local box = Instance.new("BoxHandleAdornment")
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Size = part.Size
			box.Transparency = 0.5
			box.Color3 = Color3.fromRGB(255, 0, 170)
			box.Parent = part
			table.insert(espConnections, box)
		end
	end
end

MainTab:Toggle({
	Name = "ESP Hitbox Players",
	Default = false,
	Callback = function(state)
		espEnabled = state
		clearESP()
		if espEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				createESPForPlayer(plr)
			end
		end
	end
})

Players.PlayerAdded:Connect(function(plr)
	if espEnabled then
		plr.CharacterAdded:Connect(function()
			wait(1)
			createESPForPlayer(plr)
		end)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if espEnabled then
		clearESP()
	end
end)

-- Visual Tab (continued from existing OrionLib Window)
local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

-- Auto Steal
VisualTab:Toggle({
    Title = "Auto Steal",
    Desc = "Automatically steals the nearest brainrot every second",
    Default = false,
    Callback = function(enabled)
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local StealConnection

        if enabled then
            StealConnection = RunService.RenderStepped:Connect(function()
                local closest
                local shortest = math.huge
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc.Name == "Brainrot" and npc:FindFirstChild("Head") then
                        local distance = (npc.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < shortest then
                            closest = npc
                            shortest = distance
                        end
                    end
                end

                if closest and closest:FindFirstChild("Head") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, closest.Head, 0)
                    wait(0.05)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, closest.Head, 1)
                end
            end)
        else
            if StealConnection then StealConnection:Disconnect() end
        end
    end
})

-- Base Timer ESP
VisualTab:Toggle({
    Title = "Base Timer ESP",
    Desc = "Show timer for base opening",
    Default = false,
    Callback = function(state)
        local billboardName = "BaseTimerESP"
        if state then
            local gui = Instance.new("BillboardGui")
            gui.Name = billboardName
            gui.Size = UDim2.new(0, 100, 0, 40)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.AlwaysOnTop = true
            gui.Parent = game.CoreGui

            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Text = "..."

            local RunService = game:GetService("RunService")
            local basePart = workspace:FindFirstChild("BaseTimerPart") or workspace:FindFirstChildWhichIsA("Part")

            gui.Adornee = basePart

            gui:SetAttribute("Running", true)

            spawn(function()
                while gui:GetAttribute("Running") do
                    local timeLeft = basePart:FindFirstChild("TimeLeft")
                    if timeLeft and timeLeft:IsA("NumberValue") then
                        label.Text = "Base opens in: " .. math.floor(timeLeft.Value) .. "s"
                    end
                    task.wait(1)
                end
            end)
        else
            local gui = game.CoreGui:FindFirstChild(billboardName)
            if gui then
                gui:SetAttribute("Running", false)
                gui:Destroy()
            end
        end
    end
})

-- X-Ray ESP for Players
VisualTab:Toggle({
    Title = "X-Ray Players",
    Desc = "See all players through walls",
    Default = false,
    Callback = function(state)
        local players = game:GetService("Players")
        local localPlayer = players.LocalPlayer
        local adorns = {}

        local function highlightCharacter(char)
            if not char or char == localPlayer.Character then return end
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = char
            highlight.Parent = game.CoreGui
            table.insert(adorns, highlight)
        end

        if state then
            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character then
                    highlightCharacter(plr.Character)
                end
                plr.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    highlightCharacter(char)
                end)
            end
        else
            for _, adorn in ipairs(adorns) do
                if adorn then adorn:Destroy() end
            end
            table.clear(adorns)
        end
    end
})
