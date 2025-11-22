-- Auto Paintball Script
-- Requiere Library.lua
-- Compatible con PC y Móvil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Cargar librería (ajusta la ruta según donde la tengas)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/LIBRARYS/refs/heads/main/idklib.lua"))()
-- O si está en un ModuleScript: local Library = require(game.ReplicatedStorage.Library)

-- ==================== CONFIGURACIÓN ====================
local PaintballConfig = {
    Enabled = false,
    FireRate = 0.1,
    MaxDistance = 500,
    ShootAllMode = false,
    ESPColor = Color3.fromRGB(255, 105, 180),
    ESPTransparency = 0.3
}

local ESP_Objects = {}
local LastFireTime = 0
local ClosestPlayer = nil

-- ==================== FUNCIONES ESP ====================
local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP_Objects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PaintballESP"
    highlight.FillColor = PaintballConfig.ESPColor
    highlight.FillTransparency = PaintballConfig.ESPTransparency
    highlight.OutlineColor = PaintballConfig.ESPColor
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = humanoidRootPart

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = PaintballConfig.ESPColor
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Parent = billboard

    ESP_Objects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        DistanceLabel = distanceLabel
    }
end

local function RemoveESP(player)
    if ESP_Objects[player] then
        if ESP_Objects[player].Highlight then 
            ESP_Objects[player].Highlight:Destroy() 
        end
        if ESP_Objects[player].Billboard then 
            ESP_Objects[player].Billboard:Destroy() 
        end
        ESP_Objects[player] = nil
    end
end

local function UpdateAllESP()
    if PaintballConfig.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player)
            end
        end
    else
        for player, _ in pairs(ESP_Objects) do
            RemoveESP(player)
        end
    end
end

-- ==================== FUNCIONES DE TARGETING ====================
local function GetClosestPlayer()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local closestPlayer = nil
    local shortestDistance = PaintballConfig.MaxDistance

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if targetRoot and humanoid and humanoid.Health > 0 then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer, shortestDistance
end

local function GetAllValidPlayers()
    local character = LocalPlayer.Character
    if not character then return {} end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return {} end

    local validPlayers = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if targetRoot and humanoid and humanoid.Health > 0 then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                
                if distance <= PaintballConfig.MaxDistance then
                    table.insert(validPlayers, {
                        Player = player, 
                        Root = targetRoot, 
                        Distance = distance
                    })
                end
            end
        end
    end

    return validPlayers
end

local function FireAtTarget(position)
    local args = {position}
    
    pcall(function()
        ReplicatedStorage:WaitForChild("Packages")
            :WaitForChild("Net")
            :WaitForChild("RE/UseItem")
            :FireServer(unpack(args))
    end)
end

-- ==================== LOOP PRINCIPAL ====================
RunService.Heartbeat:Connect(function()
    if not PaintballConfig.Enabled then
        ClosestPlayer = nil
        return
    end

    -- Modo Shoot All
    if PaintballConfig.ShootAllMode then
        local allPlayers = GetAllValidPlayers()
        
        if #allPlayers > 0 then
            local currentTime = tick()
            if currentTime - LastFireTime >= PaintballConfig.FireRate then
                for _, playerData in ipairs(allPlayers) do
                    FireAtTarget(playerData.Root.Position)
                    
                    if ESP_Objects[playerData.Player] and ESP_Objects[playerData.Player].DistanceLabel then
                        ESP_Objects[playerData.Player].DistanceLabel.Text = string.format("%.0fm", playerData.Distance)
                    end
                end
                
                LastFireTime = currentTime
            end
        end
        return
    end

    -- Modo normal (un objetivo)
    local closest, distance = GetClosestPlayer()
    ClosestPlayer = closest

    if ClosestPlayer and ClosestPlayer.Character then
        local targetRoot = ClosestPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot then
            if ESP_Objects[ClosestPlayer] and ESP_Objects[ClosestPlayer].DistanceLabel then
                ESP_Objects[ClosestPlayer].DistanceLabel.Text = string.format("%.0fm", distance)
            end
            
            local currentTime = tick()
            if currentTime - LastFireTime >= PaintballConfig.FireRate then
                FireAtTarget(targetRoot.Position)
                LastFireTime = currentTime
            end
        end
    end
end)

-- ==================== EVENTOS DE JUGADORES ====================
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        if PaintballConfig.Enabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Actualizar ESP cuando se active/desactive
local lastEnabled = PaintballConfig.Enabled
RunService.Heartbeat:Connect(function()
    if PaintballConfig.Enabled ~= lastEnabled then
        UpdateAllESP()
        lastEnabled = PaintballConfig.Enabled
    end
end)

-- Inicializar ESP para jugadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        player.CharacterAdded:Connect(function()
            wait(0.5)
            if PaintballConfig.Enabled then
                CreateESP(player)
            end
        end)
    end
end

-- ==================== CREAR GUI ====================
local window = Library:CreateWindow("🎨 Paintball Hacks")

-- Tab Principal
local mainTab = window:CreateTab("Principal", "🏠")

-- Toggle Auto Paintball
window:CreateToggle(mainTab, "🎯 Auto Paintball", PaintballConfig, function(enabled)
    PaintballConfig.Enabled = enabled
end)

-- Tab Configuración
local configTab = window:CreateTab("Configuración", "⚙️")

-- Info del juego
window:CreateToggle(configTab, "📊 Info del Juego", {
    Enabled = false,
    Settings = {}
}, function(enabled)
    print("Info activada:", enabled)
end)

-- Tab Info
local infoTab = window:CreateTab("Info", "ℹ️")

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(1, 0, 0, 200)
InfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InfoFrame.BorderSizePixel = 0
InfoFrame.Parent = infoTab.Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoFrame

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 1, -20)
InfoText.Position = UDim2.new(0, 10, 0, 10)
InfoText.BackgroundTransparency = 1
InfoText.Text = [[
🎨 PAINTBALL HACKS v1.0

✨ Características:
• Auto disparo al jugador más cercano
• ESP con marcadores visuales en rosa
• Modo disparar a todos (BETA)
• Configuración personalizable
• Compatible con PC y Móvil

⚙️ Configuración:
• Velocidad de Disparo: 5-100ms
• Distancia Máxima: 100-1000m
• Modo Shoot All: Dispara a todos

🎮 Controles:
• Botón flotante para abrir/cerrar
• Arrastra el botón rosa para mover
• Click en ⚙️ para configurar cada hack

📱 Compatible con:
✓ PC (Mouse y Teclado)
✓ Móvil (Touch optimizado)
✓ Tablet

⚠️ Nota:
El modo "Disparar a Todos" está en BETA
y puede causar lag en servidores grandes.

Creado con Paintball Library System
]]
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.TextWrapped = true
InfoText.Parent = InfoFrame

print("🎨 Auto Paintball cargado correctamente!")
print("📱 Compatible con PC y Móvil")
print("🔘 Usa el botón flotante rosa para abrir la GUI")
