-- Paintball Minimal GUI con Key System, Notificaciones y NoAnim
-- Sistema ultra minimalista con botón flotante

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ==================== VARIABLES GLOBALES ====================
local ESP_Objects = {}
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local KEY = "zzz" -- Clave de acceso
local IsAuthenticated = false

-- Variables NoAnim
local NoAnimEnabled = false
local NoAnimConnection = nil
local OriginalAnimations = {}

-- Variables NoAnimTools
local NoAnimToolsEnabled = false
local NoAnimToolsConnection = nil

-- ==================== SISTEMA DE NOTIFICACIONES ====================
local NotificationSystem = {}
NotificationSystem.Queue = {}
NotificationSystem.Active = {}

function NotificationSystem:Create(title, message, duration, type)
    duration = duration or 3
    type = type or "info"
    
    local sizes = GetResponsiveSize()
    
    local colors = {
        info = Color3.fromRGB(100, 150, 255),
        success = Color3.fromRGB(100, 255, 150),
        warning = Color3.fromRGB(255, 200, 100),
        error = Color3.fromRGB(255, 100, 100)
    }
    
    -- Sonido de notificación
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6647898270"
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
    
    -- Container de notificaciones
    local notifContainer = PlayerGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("ScreenGui")
        notifContainer.Name = "NotificationContainer"
        notifContainer.ResetOnSpawn = false
        notifContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notifContainer.Parent = PlayerGui
    end
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, sizes.NotifWidth, 0, 0)
    notif.Position = UDim2.new(1, -(sizes.NotifWidth + (sizes.IsMobile and 10 or 20)), 0, 20 + (#self.Active * (sizes.NotifHeight + 15)))
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = notifContainer
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 4, 1, 0)
    colorBar.BackgroundColor3 = colors[type]
    colorBar.BorderSizePixel = 0
    colorBar.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 0, sizes.IsMobile and 18 or 20)
    titleLabel.Position = UDim2.new(0, sizes.IsMobile and 12 or 15, 0, sizes.IsMobile and 8 or 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = sizes.IsMobile and 12 or 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -50, 0, sizes.IsMobile and 28 or 35)
    messageLabel.Position = UDim2.new(0, sizes.IsMobile and 12 or 15, 0, sizes.IsMobile and 26 or 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = sizes.IsMobile and 10 or 11
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = notif
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -30, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = notif
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = colors[type]
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notif
    
    table.insert(self.Active, notif)
    
    local tweenIn = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, sizes.NotifWidth, 0, sizes.NotifHeight)
    })
    tweenIn:Play()
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    })
    progressTween:Play()
    
    local function removeNotif()
        for i, n in ipairs(self.Active) do
            if n == notif then
                table.remove(self.Active, i)
                break
            end
        end
        
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, sizes.NotifWidth, 0, 0),
            Position = UDim2.new(1, -(sizes.NotifWidth + (sizes.IsMobile and 10 or 20)), 0, notif.Position.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notif:Destroy()
            
            for i, n in ipairs(self.Active) do
                TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -(sizes.NotifWidth + (sizes.IsMobile and 10 or 20)), 0, 20 + ((i-1) * (sizes.NotifHeight + 15)))
                }):Play()
            end
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(removeNotif)
    
    delay(duration, removeNotif)
end

-- ==================== KEY SYSTEM ====================
local function CreateKeySystem()
    local sizes = GetResponsiveSize()
    
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyGui.Parent = PlayerGui
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 20}):Play()
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.Parent = keyGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    keyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = overlay
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 15)
    keyCorner.Parent = keyFrame
    
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.ZIndex = 0
    glow.Image = "rbxasset://textures/ui/GUI/ShadowTexture.png"
    glow.ImageColor3 = Color3.fromRGB(100, 150, 255)
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.Parent = keyFrame
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 30)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.TextSize = 40
    icon.Parent = keyFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 100)
    title.BackgroundTransparency = 1
    title.Text = "KEY SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = keyFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 130)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Ingresa la clave para continuar"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.Parent = keyFrame
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -60, 0, 45)
    inputFrame.Position = UDim2.new(0, 30, 0, 170)
    inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = keyFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Ingresa la clave..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 14
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputFrame
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -60, 0, 45)
    submitBtn.Position = UDim2.new(0, 30, 0, 230)
    submitBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "VERIFICAR"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14
    submitBtn.AutoButtonColor = false
    submitBtn.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 10)
    submitCorner.Parent = submitBtn
    
    local keyInfo = Instance.new("TextLabel")
    keyInfo.Size = UDim2.new(1, -40, 0, 30)
    keyInfo.Position = UDim2.new(0, 20, 0, 290)
    keyInfo.BackgroundTransparency = 1
    keyInfo.Text = '💡 Clave actual: "zzz"'
    keyInfo.TextColor3 = Color3.fromRGB(100, 150, 255)
    keyInfo.Font = Enum.Font.Gotham
    keyInfo.TextSize = 11
    keyInfo.Parent = keyFrame
    
    TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, sizes.KeyPanelWidth, 0, sizes.KeyPanelHeight)
    }):Play()
    
    local function checkKey()
        local enteredKey = keyInput.Text
        
        if enteredKey == KEY then
            IsAuthenticated = true
            
            NotificationSystem:Create("✅ Acceso Concedido", "Clave correcta! Iniciando...", 2, "success")
            
            TweenService:Create(keyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            
            wait(0.5)
            keyGui:Destroy()
            blur:Destroy()
            
            CreateMainGUI()
        else
            NotificationSystem:Create("❌ Acceso Denegado", "Clave incorrecta. Intenta de nuevo.", 2, "error")
            
            local originalPos = keyFrame.Position
            for i = 1, 3 do
                TweenService:Create(keyFrame, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, 10, 0, 0)}):Play()
                wait(0.05)
                TweenService:Create(keyFrame, TweenInfo.new(0.05), {Position = originalPos - UDim2.new(0, 10, 0, 0)}):Play()
                wait(0.05)
            end
            TweenService:Create(keyFrame, TweenInfo.new(0.05), {Position = originalPos}):Play()
            
            keyInput.Text = ""
        end
    end
    
    submitBtn.MouseButton1Click:Connect(checkKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkKey()
        end
    end)
    
    submitBtn.MouseEnter:Connect(function()
        TweenService:Create(submitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 170, 255)}):Play()
    end)
    
    submitBtn.MouseLeave:Connect(function()
        TweenService:Create(submitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
    end)
end

-- ==================== SISTEMA DE RESPONSIVIDAD ====================
function GetResponsiveSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local isSmallScreen = viewportSize.X < 600 or viewportSize.Y < 500
    
    return {
        PanelWidth = isSmallScreen and math.min(viewportSize.X - 40, 350) or 400,
        PanelHeight = isSmallScreen and math.min(viewportSize.Y - 100, 450) or 500,
        ButtonSize = isSmallScreen and 50 or 60,
        ButtonTextSize = isSmallScreen and 24 or 28,
        TitleSize = isSmallScreen and 14 or 16,
        ToggleTextSize = isSmallScreen and 11 or 13,
        ToggleHeight = isSmallScreen and 45 or 50,
        ToggleButtonWidth = isSmallScreen and 45 or 50,
        ToggleButtonHeight = isSmallScreen and 24 or 28,
        KeyPanelWidth = isSmallScreen and math.min(viewportSize.X - 60, 320) or 400,
        KeyPanelHeight = isSmallScreen and 300 or 340,
        NotifWidth = isSmallScreen and math.min(viewportSize.X - 40, 280) or 300,
        NotifHeight = isSmallScreen and 65 or 75,
        IsMobile = isSmallScreen
    }
end

-- ==================== SISTEMA NO ANIM ====================
local function StopAllAnimations()
    if not Character or not Humanoid then return end
    
    pcall(function()
        -- Detener todas las animaciones del Animator
        local animator = Humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
                track:Destroy()
            end
        end
        
        -- Detener animaciones del Humanoid directamente
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            track:Stop(0)
            track:Destroy()
        end
    end)
end

local function EnableNoAnim()
    if NoAnimEnabled then return end
    NoAnimEnabled = true
    
    -- Guardar animaciones originales
    pcall(function()
        local animator = Humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                table.insert(OriginalAnimations, track)
            end
        end
    end)
    
    -- Detener todas las animaciones inmediatamente
    StopAllAnimations()
    
    -- Conexión para detener animaciones continuamente
    NoAnimConnection = RunService.Heartbeat:Connect(function()
        if NoAnimEnabled then
            StopAllAnimations()
        end
    end)
    
    NotificationSystem:Create("🚫 NoAnim Activado", "Todas las animaciones eliminadas", 2, "success")
end

local function DisableNoAnim()
    if not NoAnimEnabled then return end
    NoAnimEnabled = false
    
    -- Desconectar el loop
    if NoAnimConnection then
        NoAnimConnection:Disconnect()
        NoAnimConnection = nil
    end
    
    -- Limpiar la tabla de animaciones originales
    OriginalAnimations = {}
    
    NotificationSystem:Create("✅ NoAnim Desactivado", "Animaciones restauradas", 2, "info")
end

-- ==================== SISTEMA NO ANIM TOOLS ====================
local function EnableNoAnimTools()
    if NoAnimToolsEnabled then return end
    NoAnimToolsEnabled = true
    
    -- Función para eliminar todas las tools
    local function RemoveAllTools()
        if not Character then return end
        
        pcall(function()
            -- Eliminar tools del character
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = nil
                end
            end
            
            -- Eliminar tools del backpack
            if LocalPlayer:FindFirstChild("Backpack") then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = nil
                    end
                end
            end
        end)
    end
    
    -- Eliminar tools inmediatamente
    RemoveAllTools()
    
    -- Conexión para mantener sin tools
    NoAnimToolsConnection = RunService.Heartbeat:Connect(function()
        if NoAnimToolsEnabled then
            RemoveAllTools()
        end
    end)
    
    NotificationSystem:Create("🔧 NoAnimTools Activado", "Tools eliminadas de tu inventario", 2, "success")
end

local function DisableNoAnimTools()
    if not NoAnimToolsEnabled then return end
    NoAnimToolsEnabled = false
    
    -- Desconectar el loop
    if NoAnimToolsConnection then
        NoAnimToolsConnection:Disconnect()
        NoAnimToolsConnection = nil
    end
    
    NotificationSystem:Create("✅ NoAnimTools Desactivado", "Tools restauradas", 2, "info")
end

-- ==================== CHARACTER RESET HANDLER ====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    
    -- Re-aplicar NoAnim si estaba activado
    if NoAnimEnabled then
        wait(0.5) -- Esperar a que cargue el personaje
        NoAnimEnabled = false -- Resetear para poder re-activar
        EnableNoAnim()
    end
    
    -- Re-aplicar NoAnimTools si estaba activado
    if NoAnimToolsEnabled then
        wait(0.5)
        NoAnimToolsEnabled = false
        EnableNoAnimTools()
    end
end)

-- ==================== GUI PRINCIPAL ====================
function CreateMainGUI()
    NotificationSystem:Create("🎨 Bienvenido", "Paintball GUI cargada correctamente", 3, "success")
    
    local sizes = GetResponsiveSize()
    
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "PaintballMinimalGUI"
    mainGui.ResetOnSpawn = false
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = PlayerGui
    
    local floatBtn = Instance.new("TextButton")
    floatBtn.Size = UDim2.new(0, sizes.ButtonSize, 0, sizes.ButtonSize)
    floatBtn.Position = UDim2.new(0, sizes.IsMobile and 10 or 20, 0.5, -sizes.ButtonSize/2)
    floatBtn.AnchorPoint = Vector2.new(0, 0.5)
    floatBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    floatBtn.BorderSizePixel = 0
    floatBtn.Text = "🎨"
    floatBtn.TextSize = sizes.ButtonTextSize
    floatBtn.Font = Enum.Font.GothamBold
    floatBtn.AutoButtonColor = false
    floatBtn.Active = true
    floatBtn.Draggable = true
    floatBtn.Parent = mainGui
    
    local floatCorner = Instance.new("UICorner")
    floatCorner.CornerRadius = UDim.new(1, 0)
    floatCorner.Parent = floatBtn
    
    local btnGlow = Instance.new("ImageLabel")
    btnGlow.BackgroundTransparency = 1
    btnGlow.Position = UDim2.new(0, -10, 0, -10)
    btnGlow.Size = UDim2.new(1, 20, 1, 20)
    btnGlow.ZIndex = 0
    btnGlow.Image = "rbxasset://textures/ui/GUI/ShadowTexture.png"
    btnGlow.ImageColor3 = Color3.fromRGB(100, 150, 255)
    btnGlow.ImageTransparency = 0.5
    btnGlow.ScaleType = Enum.ScaleType.Slice
    btnGlow.SliceCenter = Rect.new(10, 10, 118, 118)
    btnGlow.Parent = floatBtn
    
    local mainPanel = Instance.new("Frame")
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    mainPanel.Position = UDim2.new(0.5, -sizes.PanelWidth/2, 0.5, -sizes.PanelHeight/2)
    mainPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainPanel.BorderSizePixel = 0
    mainPanel.Visible = false
    mainPanel.ClipsDescendants = true
    mainPanel.Parent = mainGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 15)
    panelCorner.Parent = mainPanel
    
    local panelGlow = Instance.new("ImageLabel")
    panelGlow.BackgroundTransparency = 1
    panelGlow.Position = UDim2.new(0, -20, 0, -20)
    panelGlow.Size = UDim2.new(1, 40, 1, 40)
    panelGlow.ZIndex = 0
    panelGlow.Image = "rbxasset://textures/ui/GUI/ShadowTexture.png"
    panelGlow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    panelGlow.ImageTransparency = 0.3
    panelGlow.ScaleType = Enum.ScaleType.Slice
    panelGlow.SliceCenter = Rect.new(10, 10, 118, 118)
    panelGlow.Parent = mainPanel
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, sizes.IsMobile and 45 or 50)
    header.BackgroundTransparency = 1
    header.Parent = mainPanel
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, sizes.IsMobile and 15 or 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎨 PAINTBALL"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = sizes.TitleSize
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, sizes.IsMobile and 32 or 35, 0, sizes.IsMobile and 32 or 35)
    closeBtn.Position = UDim2.new(1, sizes.IsMobile and -40 or -45, 0, sizes.IsMobile and 6 or 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = sizes.IsMobile and 16 or 18
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, sizes.IsMobile and -20 or -30, 1, sizes.IsMobile and -60 or -70)
    content.Position = UDim2.new(0, sizes.IsMobile and 10 or 15, 0, sizes.IsMobile and 50 or 55)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = sizes.IsMobile and 2 or 3
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    content.Parent = mainPanel
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.Parent = content
    
    -- Función para crear toggles
    local function createToggle(name, emoji, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, sizes.ToggleHeight)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = content
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, sizes.IsMobile and 12 or 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = emoji .. " " .. name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = sizes.ToggleTextSize
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, sizes.ToggleButtonWidth, 0, sizes.ToggleButtonHeight)
        toggle.Position = UDim2.new(1, -(sizes.ToggleButtonWidth + (sizes.IsMobile and 8 or 10)), 0.5, -sizes.ToggleButtonHeight/2)
        toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        toggle.BorderSizePixel = 0
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = toggleFrame
        
        local toggleBtnCorner = Instance.new("UICorner")
        toggleBtnCorner.CornerRadius = UDim.new(1, 0)
        toggleBtnCorner.Parent = toggle
        
        local knobSize = sizes.ToggleButtonHeight - 8
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, knobSize, 0, knobSize)
        knob.Position = UDim2.new(0, 4, 0.5, -knobSize/2)
        knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        knob.BorderSizePixel = 0
        knob.Parent = toggle
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local isEnabled = false
        
        toggle.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if isEnabled then
                TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
                TweenService:Create(knob, tweenInfo, {
                    Position = UDim2.new(1, -(knobSize + 4), 0.5, -knobSize/2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                NotificationSystem:Create("✅ Activado", name .. " activado correctamente", 2, "success")
            else
                TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                TweenService:Create(knob, tweenInfo, {
                    Position = UDim2.new(0, 4, 0.5, -knobSize/2),
                    BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
                NotificationSystem:Create("⭕ Desactivado", name .. " desactivado", 2, "info")
            end
            
            if callback then callback(isEnabled) end
        end)
        
        return toggleFrame
    end
    
    -- Sección: Animaciones
    local sectionAnim = Instance.new("TextLabel")
    sectionAnim.Size = UDim2.new(1, 0, 0, 30)
    sectionAnim.BackgroundTransparency = 1
    sectionAnim.Text = "⚙️ CONFIGURACIÓN ANIMACIONES"
    sectionAnim.TextColor3 = Color3.fromRGB(100, 150, 255)
    sectionAnim.Font = Enum.Font.GothamBold
    sectionAnim.TextSize = sizes.IsMobile and 11 or 12
    sectionAnim.TextXAlignment = Enum.TextXAlignment.Left
    sectionAnim.Parent = content
    
    -- Toggle NoAnim
    createToggle("No Animations", "🚫", function(enabled)
        if enabled then
            EnableNoAnim()
        else
            DisableNoAnim()
        end
    end)
    
    -- Toggle NoAnimTools
    createToggle("No Anim Tools", "🔧", function(enabled)
        if enabled then
            EnableNoAnimTools()
        else
            DisableNoAnimTools()
        end
    end)
    
    -- Sección: Funciones
    local sectionFeatures = Instance.new("TextLabel")
    sectionFeatures.Size = UDim2.new(1, 0, 0, 30)
    sectionFeatures.BackgroundTransparency = 1
    sectionFeatures.Text = "🎯 FUNCIONES"
    sectionFeatures.TextColor3 = Color3.fromRGB(100, 150, 255)
    sectionFeatures.Font = Enum.Font.GothamBold
    sectionFeatures.TextSize = sizes.IsMobile and 11 or 12
    sectionFeatures.TextXAlignment = Enum.TextXAlignment.Left
    sectionFeatures.Parent = content
    
    -- Crear toggles de funciones
    createToggle("Auto Paintball", "🎯", function(enabled)
        print("Auto Paintball:", enabled)
    end)
    
    createToggle("ESP Players", "👁️", function(enabled)
        print("ESP:", enabled)
    end)
    
    createToggle("Speed Boost", "⚡", function(enabled)
        print("Speed:", enabled)
    end)
    
    createToggle("Jump Power", "🦘", function(enabled)
        print("Jump:", enabled)
    end)
    
    -- Sistema de abrir/cerrar
    local isOpen = false
    
    floatBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            mainPanel.Visible = true
            TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, sizes.PanelWidth, 0, sizes.PanelHeight)
            }):Play()
            TweenService:Create(floatBtn, TweenInfo.new(0.3), {Rotation = 90}):Play()
        else
            TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            TweenService:Create(floatBtn, TweenInfo.new(0.3), {Rotation = 0}):Play()
            wait(0.3)
            mainPanel.Visible = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        isOpen = false
        TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(floatBtn, TweenInfo.new(0.3), {Rotation = 0}):Play()
        wait(0.3)
        mainPanel.Visible = false
    end)
    
    -- Efectos hover
    floatBtn.MouseEnter:Connect(function()
        local hoverSize = sizes.ButtonSize + 5
        TweenService:Create(floatBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, hoverSize, 0, hoverSize),
            BackgroundColor3 = Color3.fromRGB(120, 170, 255)
        }):Play()
    end)
    
    floatBtn.MouseLeave:Connect(function()
        TweenService:Create(floatBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, sizes.ButtonSize, 0, sizes.ButtonSize),
            BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        }):Play()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 80, 80),
            Rotation = 90
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            Rotation = 0
        }):Play()
    end)
    
    -- Animación de pulso en el botón flotante
    spawn(function()
        while floatBtn and floatBtn.Parent do
            TweenService:Create(btnGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.2
            }):Play()
            wait(1.5)
            TweenService:Create(btnGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.7
            }):Play()
            wait(1.5)
        end
    end)
end

-- ==================== INICIALIZACIÓN ====================

-- Mostrar notificación de bienvenida
NotificationSystem:Create("🎮 Paintball GUI", "Inicializando sistema...", 2, "info")

wait(1)

-- Iniciar Key System
CreateKeySystem()

print("🎨 Paintball Minimal GUI Loaded!")
print("🔐 Key System Activated")
print("🔔 Notification System Ready")
print("✨ Drag & Drop Button Enabled")
print("🚫 NoAnim System Ready")
print("🔧 NoAnimTools System Ready")
