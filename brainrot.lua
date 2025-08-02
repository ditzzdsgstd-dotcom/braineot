-- Wait until the game is fully loaded
repeat task.wait() until game:IsLoaded()

-- Load OrionLib (Nightmare version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

-- Define correct key
local CorrectKey = "YoxanXFree"
local InputKey = ""

-- Create the initial key window
local KeyWindow = OrionLib:MakeWindow({
    Name = "YoxanXHub | Key System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXKey"
})

-- Create tab for key input
local KeyTab = KeyWindow:MakeTab({
    Name = "Key",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

-- Textbox for entering the key
KeyTab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        InputKey = value
    end
})

-- Button to validate key
KeyTab:AddButton({
    Name = "Submit Key",
    Callback = function()
        if InputKey == CorrectKey then
            OrionLib:MakeNotification({
                Name = "Correct Key",
                Content = "Access granted to YoxanXHub.",
                Image = "rbxassetid://7733964641",
                Time = 3
            })

            task.wait(1)

            -- Destroy previous Orion UI
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "Orion" then
                    v:Destroy()
                end
            end

            -- Reload OrionLib, ready for Script 2/4
            local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()
            local MainWindow = Orion:MakeWindow({
                Name = "YoxanXHub",
                HidePremium = false,
                SaveConfig = true,
                ConfigFolder = "YoxanXHub"
            })

                -- ESP Tab
local ESPTab = Window:MakeTab({
	Name = "ESP",
	Icon = "eye",
	PremiumOnly = false
})

-- Player X-Ray ESP Toggle
local ESPEnabled = false
local ESPBoxes = {}

local function clearESP()
	for _, adorn in pairs(ESPBoxes) do
		if adorn and adorn.Parent then
			adorn:Destroy()
		end
	end
	table.clear(ESPBoxes)
end

local function applyESPToPlayer(player)
	if player == LocalPlayer then return end
	if not player.Character then return end

	for _, part in ipairs(player.Character:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local box = Instance.new("BoxHandleAdornment")
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 5
			box.Size = part.Size
			box.Transparency = 0.7
			box.Color3 = Color3.fromRGB(255, 85, 255)
			box.Parent = part
			table.insert(ESPBoxes, box)
		end
	end
end

local function refreshESP()
	clearESP()
	for _, player in ipairs(Players:GetPlayers()) do
		applyESPToPlayer(player)
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(1)
			refreshESP()
		end
	end)
end)

RunService.RenderStepped:Connect(function()
	if ESPEnabled then
		refreshESP()
	end
end)

ESPTab:AddToggle({
	Name = "X-Ray Player ESP",
	Default = false,
	Callback = function(state)
		ESPEnabled = state
		if not state then
			clearESP()
		else
			refreshESP()
		end
	end
})

-- ████████ AUTO TAB
local AutoTab = Window:MakeTab({
	Name = "Auto",
	Icon = "zap",
	PremiumOnly = false
})

-- Auto Steal Button
AutoTab:AddButton({
	Name = "Auto Steal (Hold E)",
	Callback = function()
		local function autoSteal()
			while task.wait() do
				local brainrots = workspace:GetChildren()
				for _, v in ipairs(brainrots) do
					if v:IsA("Model") and v:FindFirstChild("ProximityPrompt") then
						fireproximityprompt(v.ProximityPrompt)
					end
				end
			end
		end
		coroutine.wrap(autoSteal)()
	end
})

-- ████████ UTILITY TAB
local UtilityTab = Window:MakeTab({
	Name = "Utility",
	Icon = "settings",
	PremiumOnly = false
})

-- Godmode
UtilityTab:AddToggle({
	Name = "Godmode (Reset to cancel)",
	Default = false,
	Callback = function(state)
		if state then
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local hum = char:FindFirstChildWhichIsA("Humanoid")
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

-- Rejoin Server
UtilityTab:AddButton({
	Name = "Rejoin Same Server",
	Callback = function()
		local placeId = game.PlaceId
		local jobId = game.JobId

		local success, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
		end)

		if not success then
			TeleportService:Teleport(placeId, LocalPlayer)
		end
	end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
	Name = "Visual",
	Icon = "eye",
	PremiumOnly = false
})

-- Base Timer ESP (Shows how long until a base unlocks)
VisualTab:AddToggle({
	Name = "ESP Base Timer",
	Default = false,
	Callback = function(enabled)
		if not enabled then
			for _, gui in ipairs(game.CoreGui:GetChildren()) do
				if gui.Name == "BaseTimerESP" then
					gui:Destroy()
				end
			end
			return
		end

		local function displayTimer()
			local gui = Instance.new("ScreenGui", game.CoreGui)
			gui.Name = "BaseTimerESP"

			local label = Instance.new("TextLabel")
			label.Parent = gui
			label.Size = UDim2.new(0, 200, 0, 40)
			label.Position = UDim2.new(0.5, -100, 0, 10)
			label.BackgroundTransparency = 0.3
			label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			label.TextColor3 = Color3.fromRGB(0, 255, 127)
			label.Font = Enum.Font.GothamBold
			label.TextScaled = true
			label.Text = "Base Timer: Scanning..."

			while gui and gui.Parent and enabled do
				local timer = 0

				-- Search for timer GUI objects in the base
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("TextLabel") and v.Text:find("Base unlocks in") then
						local timeText = v.Text:match("%d+")
						timer = tonumber(timeText)
					end
				end

				if timer > 0 then
					label.Text = "Base unlocks in: " .. timer .. "s"
				else
					label.Text = "No active base lock."
				end

				task.wait(1)
			end
		end

		coroutine.wrap(displayTimer)()
	end
})

-- Anti Lag Button
VisualTab:AddButton({
	Name = "Anti Lag",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Texture") or v:IsA("Decal") then
				v:Destroy()
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			end
		end
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level1
	end
})

-- Player Count Button
VisualTab:AddButton({
	Name = "Show Player Count",
	Callback = function()
		local count = #game:GetService("Players"):GetPlayers()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Player Count",
			Text = "There are " .. count .. " players in the game.",
			Duration = 5
		})
	end
})
                
        else
            OrionLib:MakeNotification({
                Name = "Wrong Key",
                Content = "The key is incorrect. Try again.",
                Image = "rbxassetid://7733658504",
                Time = 3
            })
        end
    end
})
