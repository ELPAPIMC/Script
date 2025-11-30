-- Wiky Spamer GUI Optimizado - Solo usuarios en WHITELIST pueden usar las acciones
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== WHITELIST (AGREGA AQUÍ LOS USUARIOS AUTORIZADOS) ====================
local WHITELIST = {
    "gerardo19547",
    "zWEkito",
}

-- Verificar si el LocalPlayer está en la whitelist
local function isWhitelisted()
    if table.find(WHITELIST, LocalPlayer.UserId) then
        return true
    end
    if table.find(WHITELIST, LocalPlayer.Name) then
        return true
    end
    return false
end

local playerWhitelisted = isWhitelisted()

-- ==================== CONFIGURACIÓN ====================
local CONFIG = {
    cooldown_balloon = 30,
    cooldown_jail = 60,
    cooldown_rocket = 120,
    cooldown_combo = 80
}

local COMBO_ACTIONS = {
    "ragdoll", "jail", "rocket", "balloon", "tiny", "inverse", "morph", "jumpscare"
}

local activeCooldowns = {}
local cooldownTimers = {}

-- ==================== CREAR GUI (igual que antes, solo se añade bloqueo visual si no está en whitelist) ====================
-- ... [Todo el código de creación de GUI permanece igual hasta la función createPlayerEntry] ...

-- Dentro de createPlayerEntry, modificamos los botones para bloquear si no está en whitelist
local function createPlayerEntry(player)
    -- ... [Todo el código anterior de creación de EntryFrame, Avatar, etc. permanece igual] ...

    -- === BOTÓN PRINCIPAL (COMBO) ===
    PlayerClickButton.MouseButton1Click:Connect(function()
        if not playerWhitelisted then
            -- Feedback visual de "no autorizado"
            TweenService:Create(HoverOverlay, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60), BackgroundTransparency = 0.8}):Play()
            task.wait(0.3)
            TweenService:Create(HoverOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            return
        end

        if isOnCooldown(player.UserId, "combo") then
            -- Animación de cooldown (shake)
            for i = 1, 2 do
                TweenService:Create(PlayerSection, TweenInfo.new(0.05), {Position = UDim2.new(0, 3, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(PlayerSection, TweenInfo.new(0.05), {Position = UDim2.new(0, -3, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(PlayerSection, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            return
        end

        -- Ejecutar combo solo si está autorizado y sin cooldown
        TweenService:Create(HoverOverlay, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 255, 120), BackgroundTransparency = 0.7}):Play()
        TweenService:Create(Avatar, TweenInfo.new(0.1), {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 10, 0, 10)}):Play()

        executeCombo(player)
        startCooldown(player.UserId, "combo")

        task.wait(0.15)
        TweenService:Create(Avatar, TweenInfo.new(0.1), {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 12, 0, 12)}):Play()
        TweenService:Create(HoverOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end)

    -- === BOTONES INDIVIDUALES (balloon, jail, rocket) ===
    for i, data in ipairs(buttonData) do
        local ActionButton = Instance.new("TextButton")
        -- ... [creación del botón igual] ...

        -- Si no está en whitelist, atenuar el botón
        if not playerWhitelisted then
            ActionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
            ActionButton.TextColor3 = Color3.fromRGB(120, 120, 130)
            ActionButton.Text = "🔒"
        end

        ActionButton.MouseButton1Click:Connect(function()
            if not playerWhitelisted then
                -- Feedback de bloqueo
                TweenService:Create(ActionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
                task.wait(0.2)
                TweenService:Create(ActionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
                return
            end

            if isOnCooldown(player.UserId, data.name) then
                for j = 1, 2 do
                    TweenService:Create(ActionButton, TweenInfo.new(0.05), {Rotation = 8}):Play()
                    task.wait(0.05)
                    TweenService:Create(ActionButton, TweenInfo.new(0.05), {Rotation = -8}):Play()
                    task.wait(0.05)
                end
                TweenService:Create(ActionButton, TweenInfo.new(0.1), {Rotation = 0}):Play()
                return
            end

            -- Acción normal si está autorizado
            executeCommand(player, data.name)
            startCooldown(player.UserId, data.name)
            -- ... [resto del cooldown visual igual] ...
        end)
    end

    -- Si no está en whitelist, también bloquear hover del botón principal
    if not playerWhitelisted then
        PlayerClickButton.MouseEnter:Connect(function() end) -- No hacer nada
        HoverOverlay.BackgroundTransparency = 0.95
        HoverOverlay.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    end

    return EntryFrame
end

-- Opcional: Mostrar mensaje en la GUI si no está autorizado
if not playerWhitelisted then
    local WarningLabel = Instance.new("TextLabel")
    WarningLabel.Size = UDim2.new(1, -40, 0, 30)
    WarningLabel.Position = UDim2.new(0, 20, 0, 60)
    WarningLabel.BackgroundTransparency = 1
    WarningLabel.Text = "⚠️ No tienes permiso para usar este panel"
    WarningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    WarningLabel.TextSize = 14
    WarningLabel.Font = Enum.Font.GothamBold
    WarningLabel.Parent = MainFrame
end

-- ==================== INICIALIZACIÓN ====================
updatePlayerList()

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    Size = UDim2.new(0, 320, 0, 440)
}):Play()
