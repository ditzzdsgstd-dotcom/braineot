-- YoxanXHub Pet Spawner UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/1nig1htmare1234/SCRIPTS/main/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "YoxanXHub Pet Spawner",
    HidePremium = false,
    IntroEnabled = false,
    SaveConfig = false,
    ConfigFolder = "YoxanXHub_PetSpawner"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local spawnerEnabled = false

MainTab:AddToggle({
    Name = "Spawner",
    Default = false,
    Callback = function(Value)
        spawnerEnabled = Value
    end
})

-- Dropdown untuk pilih brainrot
local selectedBrainrot = "Noobini Pizzanini"
local brainrotList = {
    "Noobini Pizzanini", "Lirilì Larilà", "Tim Cheese", "Fluriflura", "Talpa Di Fero", "Svinina Bombardino", "Pipi Kiwi", "Pipi Corni",
    "Trippi Troppi", "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu", "Cacto Hipopotamo",
    "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom", "Pipi Avocado", "Cappuccino Assassino", "Brr Brr Patapim", "Trulimero Trulicina",
    "Bambini Crostini", "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus", "Avocadini Guffo",
    "Ti Ti Ti Sahur", "Salamino Penguino", "Penguino Cocosino", "Burbaloni Loliloli", "Chimpanzini Bananini",
    "Ballerina Cappuccina", "Chef Crabracadabra", "Lionel Cactuseli", "Glorbo Fruttodrillo", "Blueberrinni Octopusini",
    "Strawberelli Flamingelli", "Cocosini Mama", "Pandaccini Bananini", "Sigmа Boy", "Frigo Camelo", "Orangutini Ananassini",
    "Rhino Toasterino", "Bombardiro Crocodilo", "Bombombini Gusini", "Avocadorilla", "Cavallo Virtuoso", "Gorilla Watermelondrillo",
    "Ganganzelli Trulala", "Spioniro Golubiro", "Zibra Zubra Zibralini", "Tigrilini Watermelini", "Cocofanto Elefanto",
    "Girafa Celestre", "Gattatino Neonino", "Matteo", "Tralalero Tralala", "Los Crocodillitos", "Espresso Signora",
    "Odin Din Din Dun", "Statutino Libertino", "Tukanno Bananno", "Trenostruzzo Turbo 3000", "Trippi Troppi Troppa Trippa",
    "Ballerino Lololo", "Los Tungtungtungcitos", "Piccione Macchina", "Tigroligre Frutonni", "Orcalero Orcala",
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Agarrini la Palini", "Los Tralaleritos", "Las Tralaleritas",
    "Las Vaquitas Saturnitas", "Graipuss Medussi", "Chicleteira Bicicleteira", "La Grande Combinasion", "Los Combinasionas",
    "Nuclearo Dinossauro", "Garama and Madundung", "Dragon Cannelloni", "Torrtuginni Dragonfrutini", "Pot Hotspot"
}

MainTab:AddDropdown({
    Name = "Select Brainrot",
    Default = "Noobini Pizzanini",
    Options = brainrotList,
    Callback = function(Value)
        selectedBrainrot = Value
    end
})

MainTab:AddButton({
    Name = "Spawn Selected Brainrot",
    Callback = function()
        SpawnSpecificBrainrot(selectedBrainrot)
    end
})

-- Fungsi spawn spesifik brainrot
local NPCFolder = game.ServerStorage:WaitForChild("NPCFolder")

local function NPCMove(NPC)
    local CheckPoints = workspace:WaitForChild("CheckPoints")
    local CheckPointNumber = 1

    NPC.Humanoid:MoveTo(CheckPoints["Checkpoint" .. CheckPointNumber].Position)

    local AT = NPC.Humanoid.Animator:LoadAnimation(NPC.WalkAnimation)
    AT:Play()

    NPC.Humanoid.MoveToFinished:Connect(function()
        CheckPointNumber += 1
        if CheckPointNumber > #CheckPoints:GetChildren() then
            NPC:Destroy()
        else
            NPC.Humanoid:MoveTo(CheckPoints["Checkpoint" .. CheckPointNumber].Position)
        end
    end)
end

local function SpawnSpecificBrainrot(name)
    if not name then return end
    local npcData = NPCFolder:FindFirstChild(name)
    if not npcData then
        warn("Brainrot Not Found: " .. name)
        return
    end

    local NPC = npcData.Rig:Clone()
    NPC.Parent = workspace

    NPC.Head.InfoGUI.PriceTextLabel.Text = "$" .. npcData.Price.Value
    NPC.Head.InfoGUI.NameTextLabel.Text = npcData.Name
    NPC.Head.InfoGUI.RarityTextLabel.Text = npcData.Rarity.Value
    NPC.Head.InfoGUI.MoneyPerSecondTextLabel.Text = "$" .. npcData.MoneyPerSecond.Value .. "/s"

    NPC:PivotTo(workspace.Spawner.CFrame)
    NPCMove(NPC)
end

-- Loop default jika spawner toggle aktif
task.spawn(function()
    while true do
        if spawnerEnabled then
            SpawnSpecificBrainrot(selectedBrainrot)
        end
        task.wait(1)
    end
end)

OrionLib:Init()
