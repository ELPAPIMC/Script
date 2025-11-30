-- Wiky Spamer GUI Optimizado - Sistema de Acciones Múltiples

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== CONFIGURACIÓN ====================
local CONFIG = {
    cooldown_balloon = 30,
    cooldown_jail = 60,
    cooldown_rocket = 120,
    cooldown_combo = 80
}

local COMBO_ACTIONS = {
    "ragdoll",
    "jail",
    "rocket",
    "balloon",
    "tiny",
    "inverse",
    "morph",
    "jumpscare"
}

local activeCooldowns = {}
local cooldownTimers = {}

-- ==================== CREAR GUI RESPONSIVE ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WikySpamer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "WIKY SPAMER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local PlayerCount = Instance.new("TextLabel")
PlayerCount.Name = "PlayerCount"
PlayerCount.Size = UDim2.new(1, -100, 1, 0)
PlayerCount.Position = UDim2.new(0, 20, 0, 0)
PlayerCount.BackgroundTransparency = 1
PlayerCount.Text = "0"
PlayerCount.TextColor3 = Color3.fromRGB(120, 120, 130)
PlayerCount.TextSize = 13
PlayerCount.Font = Enum.Font.Gotham
PlayerCount.TextXAlignment = Enum.TextXAlignment.Left
PlayerCount.TextYAlignment = Enum.TextYAlignment.Bottom
PlayerCount.Parent = Header

-- Botón Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
MinimizeButton.Position = UDim2.new(1, -78, 0, 9)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(160, 160, 170)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Botón Cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -42, 0, 9)
CloseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(160, 160, 170)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Efectos hover botones
MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    }):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    }):Play()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 50, 60)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    }):Play()
end)

-- Acción minimizar
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 320, 0, 50)
        }):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 320, 0, 440)
        }):Play()
        MinimizeButton.Text = "−"
    end
end)

-- Acción cerrar
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 50)
Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, -40, 1, -70)
PlayerList.Position = UDim2.new(0, 20, 0, 60)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
PlayerList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = PlayerList

-- ==================== FUNCIONES DE COOLDOWN ====================
local function startCooldown(playerId, actionType)
    local cooldownKey = playerId .. "_" .. actionType
    local cooldownTime = CONFIG["cooldown_" .. actionType] or 10
    
    activeCooldowns[cooldownKey] = true
    cooldownTimers[cooldownKey] = cooldownTime
    
    task.spawn(function()
        for i = cooldownTime, 0, -1 do
            cooldownTimers[cooldownKey] = i
            task.wait(1)
        end
        activeCooldowns[cooldownKey] = nil
        cooldownTimers[cooldownKey] = nil
    end)
end

local function isOnCooldown(playerId, actionType)
    local cooldownKey = playerId .. "_" .. actionType
    return activeCooldowns[cooldownKey] == true
end

local function getCooldownTime(playerId, actionType)
    local cooldownKey = playerId .. "_" .. actionType
    return cooldownTimers[cooldownKey] or 0
end

-- ==================== FUNCIÓN PARA EJECUTAR COMANDO ====================
local function executeCommand(targetPlayer, actionName)
    local success, err = pcall(function()
        local args = {targetPlayer, actionName}
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
            :WaitForChild("RE/AdminPanelService/ExecuteCommand"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("⚠️ Error ejecutando comando: " .. tostring(err))
    end
end

-- ==================== EJECUTAR COMBO DE ACCIONES ====================
local function executeCombo(targetPlayer)
    for i, actionName in ipairs(COMBO_ACTIONS) do
        executeCommand(targetPlayer, actionName)
        
        if i < #COMBO_ACTIONS then
            task.wait(0.3)
        end
    end
end

-- ==================== CREAR ENTRADA DE JUGADOR ====================
local function createPlayerEntry(player)
    local EntryFrame = Instance.new("Frame")
    EntryFrame.Name = player.Name
    EntryFrame.Size = UDim2.new(1, 0, 0, 72)
    EntryFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    EntryFrame.BorderSizePixel = 0
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 10)
    EntryCorner.Parent = EntryFrame
    
    local PlayerClickButton = Instance.new("TextButton")
    PlayerClickButton.Name = "PlayerClickButton"
    PlayerClickButton.Size = UDim2.new(1, -135, 1, 0)
    PlayerClickButton.Position = UDim2.new(0, 0, 0, 0)
    PlayerClickButton.BackgroundTransparency = 1
    PlayerClickButton.Text = ""
    PlayerClickButton.ZIndex = 5
    PlayerClickButton.Parent = EntryFrame
    
    local PlayerSection = Instance.new("Frame")
    PlayerSection.Name = "PlayerSection"
    PlayerSection.Size = UDim2.new(1, -135, 1, 0)
    PlayerSection.Position = UDim2.new(0, 0, 0, 0)
    PlayerSection.BackgroundTransparency = 1
    PlayerSection.Parent = EntryFrame
    
    local HoverOverlay = Instance.new("Frame")
    HoverOverlay.Name = "HoverOverlay"
    HoverOverlay.Size = UDim2.new(1, 0, 1, 0)
    HoverOverlay.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    HoverOverlay.BackgroundTransparency = 1
    HoverOverlay.BorderSizePixel = 0
    HoverOverlay.ZIndex = 1
    HoverOverlay.Parent = PlayerSection
    
    local HoverCorner = Instance.new("UICorner")
    HoverCorner.CornerRadius = UDim.new(0, 10)
    HoverCorner.Parent = HoverOverlay
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 48, 0, 48)
    Avatar.Position = UDim2.new(0, 12, 0, 12)
    Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Avatar.BorderSizePixel = 0
    Avatar.ZIndex = 2
    Avatar.Parent = PlayerSection
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar
    
    local success, thumbnailUrl = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    
    if success and thumbnailUrl then
        Avatar.Image = thumbnailUrl
    end
    
    local DisplayName = Instance.new("TextLabel")
    DisplayName.Name = "DisplayName"
    DisplayName.Size = UDim2.new(1, -72, 0, 18)
    DisplayName.Position = UDim2.new(0, 68, 0, 14)
    DisplayName.BackgroundTransparency = 1
    DisplayName.Text = player.DisplayName
    DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisplayName.TextSize = 13
    DisplayName.Font = Enum.Font.GothamSemibold
    DisplayName.TextXAlignment = Enum.TextXAlignment.Left
    DisplayName.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayName.ZIndex = 2
    DisplayName.Parent = PlayerSection
    
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Size = UDim2.new(1, -72, 0, 16)
    PlayerName.Position = UDim2.new(0, 68, 0, 32)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = "@" .. player.Name
    PlayerName.TextColor3 = Color3.fromRGB(120, 120, 130)
    PlayerName.TextSize = 11
    PlayerName.Font = Enum.Font.Gotham
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.TextTruncate = Enum.TextTruncate.AtEnd
    PlayerName.ZIndex = 2
    PlayerName.Parent = PlayerSection
    
    -- Contador de cooldown del combo sobre el avatar
    local ComboTimer = Instance.new("TextLabel")
    ComboTimer.Name = "ComboTimer"
    ComboTimer.Size = UDim2.new(0, 48, 0, 48)
    ComboTimer.Position = UDim2.new(0, 12, 0, 12)
    ComboTimer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ComboTimer.BackgroundTransparency = 0.4
    ComboTimer.Text = ""
    ComboTimer.TextColor3 = Color3.fromRGB(255, 255, 255)
    ComboTimer.TextSize = 14
    ComboTimer.Font = Enum.Font.GothamBold
    ComboTimer.ZIndex = 3
    ComboTimer.Visible = false
    ComboTimer.Parent = PlayerSection
    
    local TimerCorner = Instance.new("UICorner")
    TimerCorner.CornerRadius = UDim.new(1, 0)
    TimerCorner.Parent = ComboTimer
    
    -- Actualizar timer visualmente
    task.spawn(function()
        while EntryFrame and EntryFrame.Parent do
            local timeLeft = getCooldownTime(player.UserId, "combo")
            if timeLeft > 0 then
                ComboTimer.Visible = true
                ComboTimer.Text = timeLeft .. "s"
            else
                ComboTimer.Visible = false
            end
            task.wait(0.5)
        end
    end)
    
    PlayerClickButton.MouseEnter:Connect(function()
        if not isOnCooldown(player.UserId, "combo") then
            TweenService:Create(HoverOverlay, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.94
            }):Play()
        end
    end)
    
    PlayerClickButton.MouseLeave:Connect(function()
        TweenService:Create(HoverOverlay, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        }):Play()
    end)
    
    PlayerClickButton.MouseButton1Click:Connect(function()
        if isOnCooldown(player.UserId, "combo") then
            for i = 1, 2 do
                TweenService:Create(PlayerSection, TweenInfo.new(0.05), {Position = UDim2.new(0, 3, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(PlayerSection, TweenInfo.new(0.05), {Position = UDim2.new(0, -3, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(PlayerSection, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            return
        end
        
        TweenService:Create(HoverOverlay, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 120),
            BackgroundTransparency = 0.7
        }):Play()
        
        TweenService:Create(Avatar, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 52, 0, 52),
            Position = UDim2.new(0, 10, 0, 10)
        }):Play()
        
        executeCombo(player)
        startCooldown(player.UserId, "combo")
        
        task.wait(0.15)
        
        TweenService:Create(Avatar, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 48, 0, 48),
            Position = UDim2.new(0, 12, 0, 12)
        }):Play()
        
        TweenService:Create(HoverOverlay, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        }):Play()
    end)
    
    local EntryDivider = Instance.new("Frame")
    EntryDivider.Name = "Divider"
    EntryDivider.Size = UDim2.new(0, 1, 1, -20)
    EntryDivider.Position = UDim2.new(1, -130, 0, 10)
    EntryDivider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    EntryDivider.BorderSizePixel = 0
    EntryDivider.Parent = EntryFrame
    
    local ActionsSection = Instance.new("Frame")
    ActionsSection.Name = "ActionsSection"
    ActionsSection.Size = UDim2.new(0, 125, 1, 0)
    ActionsSection.Position = UDim2.new(1, -125, 0, 0)
    ActionsSection.BackgroundTransparency = 1
    ActionsSection.Parent = EntryFrame
    
    local buttonData = {
        {emoji = "🎈", color = Color3.fromRGB(255, 90, 90), name = "balloon", pos = 0},
        {emoji = "🔒", color = Color3.fromRGB(140, 140, 150), name = "jail", pos = 1},
        {emoji = "🚀", color = Color3.fromRGB(90, 150, 255), name = "rocket", pos = 2}
    }
    
    for i, data in ipairs(buttonData) do
        local ActionButton = Instance.new("TextButton")
        ActionButton.Name = "ActionButton" .. i
        ActionButton.Size = UDim2.new(0, 32, 0, 32)
        ActionButton.Position = UDim2.new(0, 8 + (38 * data.pos), 0, 20)
        ActionButton.BackgroundColor3 = data.color
        ActionButton.Text = data.emoji
        ActionButton.TextSize = 15
        ActionButton.Font = Enum.Font.GothamBold
        ActionButton.AutoButtonColor = false
        ActionButton.ZIndex = 2
        ActionButton.Parent = ActionsSection
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = ActionButton
        
        local CooldownOverlay = Instance.new("Frame")
        CooldownOverlay.Name = "CooldownOverlay"
        CooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
        CooldownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        CooldownOverlay.BackgroundTransparency = 1
        CooldownOverlay.BorderSizePixel = 0
        CooldownOverlay.ZIndex = 3
        CooldownOverlay.Parent = ActionButton
        
        local CooldownCorner = Instance.new("UICorner")
        CooldownCorner.CornerRadius = UDim.new(0, 8)
        CooldownCorner.Parent = CooldownOverlay
        
        local CooldownText = Instance.new("TextLabel")
        CooldownText.Name = "CooldownText"
        CooldownText.Size = UDim2.new(1, 0, 1, 0)
        CooldownText.BackgroundTransparency = 1
        CooldownText.Text = ""
        CooldownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        CooldownText.TextSize = 11
        CooldownText.Font = Enum.Font.GothamBold
        CooldownText.ZIndex = 4
        CooldownText.Visible = false
        CooldownText.Parent = ActionButton
        
        ActionButton.MouseEnter:Connect(function()
            if not isOnCooldown(player.UserId, data.name) then
                TweenService:Create(ActionButton, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 34, 0, 34)
                }):Play()
            end
        end)
        
        ActionButton.MouseLeave:Connect(function()
            TweenService:Create(ActionButton, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 32, 0, 32)
            }):Play()
        end)
        
        ActionButton.MouseButton1Click:Connect(function()
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
            
            executeCommand(player, data.name)
            startCooldown(player.UserId, data.name)
            
            CooldownOverlay.BackgroundTransparency = 0.7
            CooldownText.Visible = true
            ActionButton.Text = ""
            
            TweenService:Create(ActionButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 28, 0, 28)}):Play()
            task.wait(0.1)
            TweenService:Create(ActionButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 32, 0, 32)}):Play()
            
            local cooldownTime = CONFIG["cooldown_" .. data.name]
            for k = cooldownTime, 0, -1 do
                if not ActionButton or not ActionButton.Parent then break end
                CooldownText.Text = tostring(k)
                task.wait(1)
            end
            
            if ActionButton and ActionButton.Parent then
                CooldownOverlay.BackgroundTransparency = 1
                CooldownText.Visible = false
                ActionButton.Text = data.emoji
                
                TweenService:Create(ActionButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                task.wait(0.2)
                TweenService:Create(ActionButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = data.color
                }):Play()
            end
        end)
    end
    
    return EntryFrame
end

-- ==================== ACTUALIZAR LISTA ====================
local function updatePlayerList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local playerCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local entry = createPlayerEntry(player)
            entry.Parent = PlayerList
            playerCount = playerCount + 1
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    PlayerCount.Text = playerCount .. " jugadores"
end

-- ==================== EVENTOS ====================
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- ==================== HACER DRAGGABLE ====================
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ==================== RESPONSIVE DESIGN ====================
local ViewportSize = workspace.CurrentCamera.ViewportSize
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    ViewportSize = workspace.CurrentCamera.ViewportSize
    local scale = math.min(ViewportSize.X / 1920, ViewportSize.Y / 1080)
    scale = math.clamp(scale, 0.7, 1.2)
end)

-- ==================== INICIALIZAR ====================
updatePlayerList()

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    Size = UDim2.new(0, 320, 0, 440)
}):Play()
