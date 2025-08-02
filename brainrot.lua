-- YoxanXHub | Steal a Brainrot | Auto Steal + ESP Timer
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub | Steal a Brainrot",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub_Config"
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7734053497",
    PremiumOnly = false
})

MainTab:AddButton({
    Name = "Auto Steal",
    Callback = function()
        local function decode_constant(encoded)
            local decoded = {}
            for i = 1, #encoded do
                decoded[i] = string.char(string.byte(encoded, i) ~ 0x25)
            end
            return table.concat(decoded)
        end

        local function load_bytecode(raw_data)
            local constants, instructions = {}, {}
            for i, val in ipairs(raw_data.constants) do
                constants[i] = decode_constant(val)
            end
            for i, instr in ipairs(raw_data.instructions) do
                instructions[i] = {
                    op = instr[1],
                    a = instr[2],
                    b = instr[3],
                    c = instr[4]
                }
            end
            return constants, instructions
        end

        local function execute(constants, instructions, env)
            local ip = 1
            local stack = {}
            local function fetch()
                local instr = instructions[ip]
                ip += 1
                return instr
            end
            while true do
                local instr = fetch()
                local op, a, b, c = instr.op, instr.a, instr.b, instr.c
                if op == "LOADK" then
                    stack[a] = constants[b]
                elseif op == "MOVE" then
                    stack[a] = stack[b]
                elseif op == "CALL" then
                    local func = stack[a]
                    local args = {}
                    for i = 1, b do args[i] = stack[a + i] end
                    local results = {func(table.unpack(args))}
                    for i = 1, c do stack[a + i - 1] = results[i] end
                elseif op == "RETURN" then
                    return
                else
                    warn("Unknown opcode:", op)
                end
            end
        end

        local bytecode_data = {
            constants = {"\x6b\x44\x47", "\x58\x4a\x41"}, -- Replace with actual encoded constants
            instructions = {
                {"LOADK", 1, 1},
                {"LOADK", 2, 2},
                {"CALL", 1, 1, 1},
                {"RETURN", 0, 0, 0}
            }
        }

        local constants, instructions = load_bytecode(bytecode_data)
        execute(constants, instructions, {})
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://7734098371",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "ESP: Base Timer",
    Default = false,
    Callback = function(state)
        local runService = game:GetService("RunService")
        local Players = game:GetService("Players")

        local function showTimerAbovePlayer(player)
            local character = player.Character or player.CharacterAdded:Wait()
            local head = character:WaitForChild("Head")

            local gui = Instance.new("BillboardGui", head)
            gui.Name = "BaseTimerESP"
            gui.Size = UDim2.new(0, 100, 0, 40)
            gui.Adornee = head
            gui.AlwaysOnTop = true

            local text = Instance.new("TextLabel", gui)
            text.Size = UDim2.new(1, 0, 1, 0)
            text.TextColor3 = Color3.new(1, 1, 1)
            text.BackgroundTransparency = 1
            text.TextStrokeTransparency = 0
            text.Text = "Timer: 0s"
            text.TextScaled = true

            local timer = 30
            local conn = runService.RenderStepped:Connect(function(dt)
                if not gui or not gui.Parent then
                    conn:Disconnect()
                else
                    timer -= dt
                    text.Text = string.format("Timer: %ds", math.max(0, math.floor(timer)))
                end
            end)
        end

        if state then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer then
                    showTimerAbovePlayer(p)
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                local char = p.Character
                if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("BaseTimerESP") then
                    char.Head.BaseTimerESP:Destroy()
                end
            end
        end
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://7734098371",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "ESP: Name + Body X-Ray",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local function applyESP(player)
            if player == Players.LocalPlayer then return end
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character:FindFirstChild("Head")
                if not head:FindFirstChild("NameESP") then
                    -- Billboard Name
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "NameESP"
                    esp.Adornee = head
                    esp.Size = UDim2.new(0, 100, 0, 20)
                    esp.StudsOffset = Vector3.new(0, 2, 0)
                    esp.AlwaysOnTop = true
                    esp.Parent = head

                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.new(1, 1, 1)
                    text.TextStrokeTransparency = 0
                    text.TextStrokeColor3 = Color3.new(0, 0, 0)
                    text.TextScaled = true
                    text.Text = player.Name
                    text.Font = Enum.Font.GothamBold
                    text.Parent = esp
                end

                -- Body X-Ray
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("XRAYBOX") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "XRAYBOX"
                        box.Adornee = part
                        box.Size = part.Size
                        box.Color3 = Color3.fromRGB(0, 255, 0)
                        box.Transparency = 0.5
                        box.ZIndex = 5
                        box.AlwaysOnTop = true
                        box.Parent = part
                    end
                end
            end
        end

        local function clearESP(player)
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("NameESP") then
                    head.NameESP:Destroy()
                end
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local box = part:FindFirstChild("XRAYBOX")
                        if box then box:Destroy() end
                    end
                end
            end
        end

        if state then
            -- Initial
            for _, p in pairs(Players:GetPlayers()) do
                applyESP(p)
            end
            -- Updates
            Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    wait(1)
                    applyESP(p)
                end)
            end)
        else
            for _, p in pairs(Players:GetPlayers()) do
                clearESP(p)
            end
        end
    end
})

-- Finder Tab
local FinderTab = Window:MakeTab({
    Name = "Finder",
    Icon = "rbxassetid://7734104849",
    PremiumOnly = false
})

FinderTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

FinderTab:AddButton({
    Name = "Join Small Server",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YoxanXHub/Assets/main/small_server.lua"))()
    end
})

-- Info Tab
local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://7733658504",
    PremiumOnly = false
})

InfoTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Az8Cm2F6")
        OrionLib:MakeNotification({
            Name = "Discord Copied",
            Content = "Link discord telah disalin ke clipboard!",
            Image = "rbxassetid://7734053497",
            Time = 5
        })
    end
})

InfoTab:AddParagraph("YoxanXHub", "Discord : YoxanXHub")
