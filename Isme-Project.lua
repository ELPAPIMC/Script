-- Isme | Project - Script Hub MINIMAL MOBILE
-- Version: 2.1 - Bug Fixes & Ultra Responsive

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- CONFIGURACIÓN DE SCRIPTS
-- ============================================
local Scripts = {
    {
        Name = "Infinite Yield",
        Category = "Admin",
        Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()]]
    },
    {
        Name = "Dex Explorer",
        Category = "Explorer",
        Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()]]
    },
    {
        Name = "Remote Spy",
        Category = "Dev",
        Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()]]
    },
    {
        Name = "FE Animations",
        Category = "Fun",
        Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Cokka-GUI-V2/main/Cokka-Gui-V2.lua"))()]]
    },
}

-- ============================================
-- DETECCIÓN DE DISPOSITIVO MEJORADA
-- ============================================
local function getDeviceType()
    local hasTouch = UserInputService.TouchEnabled
    local hasKeyboard = UserInputService.KeyboardEnabled
    local hasMouse = UserInputService.MouseEnabled
    
    if hasTouch and not hasKeyboard then
        return "Mobile"
    elseif hasKeyboard or hasMouse then
        return "Desktop"
    else
        return "Mobile"
    end
end

local deviceType = getDeviceType()
local isMobile = (deviceType == "Mobile")
local screenSize = workspace.CurrentCamera.ViewportSize

-- ============================================
-- CREAR GUI RESPONSIVA
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IsmeMinimalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Protección del GUI
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Tamaños dinámicos según dispositivo
local mainWidth = isMobile and math.min(screenSize.X * 0.92, 380) or 600
local mainHeight = isMobile and math.min(screenSize.Y * 0.80, 650) or 500
local headerHeight = isMobile and 55 or 60
local buttonSize = isMobile and 36 or 40
local cardHeight = isMobile and 95 or 100

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -mainWidth/2, 0.5, -mainHeight/2)
MainFrame.Size = UDim2.new(0, mainWidth, 0, mainHeight)
MainFrame.Active = true
MainFrame.Draggable = not isMobile
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, isMobile and 16 or 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Header Minimalista
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, headerHeight)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, isMobile and 16 or 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Parent = Header

-- Título
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, isMobile and 15 or 20, 0, isMobile and 8 or 10)
Title.Size = UDim2.new(0, mainWidth * 0.5, 0, isMobile and 20 or 24)
Title.Font = Enum.Font.GothamBold
Title.Text = "Isme Hub"
Title.TextColor3 = Color3.fromRGB(138, 43, 226)
Title.TextSize = isMobile and 18 or 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Contador de Scripts
local Counter = Instance.new("TextLabel")
Counter.BackgroundTransparency = 1
Counter.Position = UDim2.new(0, isMobile and 15 or 20, 0, isMobile and 30 or 35)
Counter.Size = UDim2.new(0, 200, 0, 18)
Counter.Font = Enum.Font.Gotham
Counter.Text = #Scripts .. " scripts disponibles"
Counter.TextColor3 = Color3.fromRGB(150, 150, 160)
Counter.TextSize = isMobile and 11 or 12
Counter.TextXAlignment = Enum.TextXAlignment.Left
Counter.Parent = Header

-- Botón Cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseButton.Position = UDim2.new(1, -(buttonSize + (isMobile and 10 or 15)), 0.5, -buttonSize/2)
CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = isMobile and 24 or 28
CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Botón Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
MinimizeButton.Position = UDim2.new(1, -(buttonSize * 2 + (isMobile and 18 or 23)), 0.5, -buttonSize/2)
MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = isMobile and 18 or 22
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeButton

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, mainWidth, 0, headerHeight) or UDim2.new(0, mainWidth, 0, mainHeight)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    MinimizeButton.Text = isMinimized and "+" or "−"
end)

-- Container de Scripts con ScrollingFrame
local ScriptsContainer = Instance.new("ScrollingFrame")
ScriptsContainer.Name = "ScriptsContainer"
ScriptsContainer.BackgroundTransparency = 1
ScriptsContainer.Position = UDim2.new(0, 0, 0, headerHeight + (isMobile and 5 or 10))
ScriptsContainer.Size = UDim2.new(1, 0, 1, -(headerHeight + (isMobile and 10 or 15)))
ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsContainer.ScrollBarThickness = isMobile and 4 or 6
ScriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ScriptsContainer.BorderSizePixel = 0
ScriptsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
ScriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptsContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScriptsContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, isMobile and 8 or 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = ScriptsContainer
UIPadding.PaddingTop = UDim.new(0, isMobile and 8 or 10)
UIPadding.PaddingBottom = UDim.new(0, isMobile and 8 or 10)
UIPadding.PaddingLeft = UDim.new(0, isMobile and 10 or 12)
UIPadding.PaddingRight = UDim.new(0, isMobile and 10 or 12)

-- ============================================
-- FUNCIONES
-- ============================================
local function CreateNotification(text, color)
    local Notification = Instance.new("Frame")
    Notification.BackgroundColor3 = color or Color3.fromRGB(40, 167, 69)
    Notification.BorderSizePixel = 0
    Notification.Size = UDim2.new(0, isMobile and 280 or 320, 0, isMobile and 50 or 60)
    Notification.Parent = ScreenGui
    
    if isMobile then
        Notification.Position = UDim2.new(0.5, -140, 0, 20)
    else
        Notification.Position = UDim2.new(1, 10, 0, 70)
    end
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notification
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(255, 255, 255)
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 0.8
    NotifStroke.Parent = Notification
    
    local NotifText = Instance.new("TextLabel")
    NotifText.BackgroundTransparency = 1
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.Font = Enum.Font.GothamBold
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = isMobile and 12 or 14
    NotifText.TextWrapped = true
    NotifText.Parent = Notification
    
    local targetPos
    if isMobile then
        targetPos = UDim2.new(0.5, -140, 0, 20)
    else
        targetPos = UDim2.new(1, -330, 0, 70)
    end
    
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = targetPos}):Play()
    
    task.wait(2.5)
    
    local exitPos
    if isMobile then
        exitPos = UDim2.new(0.5, -140, 0, -70)
    else
        exitPos = UDim2.new(1, 10, 0, 70)
    end
    
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = exitPos}):Play()
    task.wait(0.3)
    Notification:Destroy()
end

local function ExecuteScript(code)
    local success, err = pcall(function()
        loadstring(code)()
    end)
    
    if success then
        CreateNotification("✓ Script ejecutado", Color3.fromRGB(40, 167, 69))
    else
        local errorMsg = tostring(err):sub(1, 40)
        CreateNotification("✗ Error: " .. errorMsg, Color3.fromRGB(220, 53, 69))
        warn("Script Error:", err)
    end
end

local function CreateScriptCard(scriptData)
    local cardWidth = mainWidth - (isMobile and 20 or 24)
    
    local Card = Instance.new("Frame")
    Card.Name = scriptData.Name
    Card.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Card.BorderSizePixel = 0
    Card.Size = UDim2.new(0, cardWidth, 0, cardHeight)
    Card.Parent = ScriptsContainer
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 12)
    CardCorner.Parent = Card
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(40, 40, 50)
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.7
    CardStroke.Parent = Card
    
    -- Contenedor de Información
    local InfoContainer = Instance.new("Frame")
    InfoContainer.BackgroundTransparency = 1
    InfoContainer.Position = UDim2.new(0, 12, 0, 10)
    InfoContainer.Size = UDim2.new(1, -24, 0, 45)
    InfoContainer.Parent = Card
    
    -- Nombre del Script
    local ScriptName = Instance.new("TextLabel")
    ScriptName.BackgroundTransparency = 1
    ScriptName.Size = UDim2.new(1, 0, 0, isMobile and 20 or 22)
    ScriptName.Font = Enum.Font.GothamBold
    ScriptName.Text = scriptData.Name
    ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptName.TextSize = isMobile and 15 or 16
    ScriptName.TextXAlignment = Enum.TextXAlignment.Left
    ScriptName.TextTruncate = Enum.TextTruncate.AtEnd
    ScriptName.Parent = InfoContainer
    
    -- Categoría
    local Category = Instance.new("TextLabel")
    Category.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Category.Position = UDim2.new(0, 0, 0, isMobile and 24 or 26)
    Category.Size = UDim2.new(0, isMobile and 70 or 75, 0, isMobile and 18 or 20)
    Category.Font = Enum.Font.GothamBold
    Category.Text = scriptData.Category
    Category.TextColor3 = Color3.fromRGB(255, 255, 255)
    Category.TextSize = isMobile and 10 or 11
    Category.Parent = InfoContainer
    
    local CatCorner = Instance.new("UICorner")
    CatCorner.CornerRadius = UDim.new(0, 6)
    CatCorner.Parent = Category
    
    -- Contenedor de Botones
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(0, 12, 1, -(isMobile and 38 or 40))
    ButtonContainer.Size = UDim2.new(1, -24, 0, isMobile and 32 or 34)
    ButtonContainer.Parent = Card
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.Parent = ButtonContainer
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Padding = UDim.new(0, 8)
    
    -- Botón Ejecutar
    local ExecuteButton = Instance.new("TextButton")
    ExecuteButton.Name = "ExecuteButton"
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    ExecuteButton.Size = UDim2.new(0, isMobile and 90 or 100, 1, 0)
    ExecuteButton.Font = Enum.Font.GothamBold
    ExecuteButton.Text = isMobile and "▶ Run" or "▶ Ejecutar"
    ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteButton.TextSize = isMobile and 12 or 13
    ExecuteButton.AutoButtonColor = false
    ExecuteButton.LayoutOrder = 2
    ExecuteButton.Parent = ButtonContainer
    
    local ExecCorner = Instance.new("UICorner")
    ExecCorner.CornerRadius = UDim.new(0, 8)
    ExecCorner.Parent = ExecuteButton
    
    ExecuteButton.MouseButton1Click:Connect(function()
        ExecuteScript(scriptData.Code)
    end)
    
    ExecuteButton.MouseEnter:Connect(function()
        TweenService:Create(ExecuteButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 80)}):Play()
    end)
    
    ExecuteButton.MouseLeave:Connect(function()
        TweenService:Create(ExecuteButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 167, 69)}):Play()
    end)
    
    -- Botón Copiar
    local CopyButton = Instance.new("TextButton")
    CopyButton.Name = "CopyButton"
    CopyButton.BackgroundColor3 = Color3.fromRGB(108, 117, 125)
    CopyButton.Size = UDim2.new(0, isMobile and 75 or 85, 1, 0)
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.Text = isMobile and "📋" or "📋 Copy"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = isMobile and 16 or 13
    CopyButton.AutoButtonColor = false
    CopyButton.LayoutOrder = 1
    CopyButton.Parent = ButtonContainer
    
    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 8)
    CopyCorner.Parent = CopyButton
    
    CopyButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(scriptData.Code)
            CreateNotification("📋 Código copiado", Color3.fromRGB(23, 162, 184))
        end)
    end)
    
    CopyButton.MouseEnter:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 138, 145)}):Play()
    end)
    
    CopyButton.MouseLeave:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(108, 117, 125)}):Play()
    end)
end

-- ============================================
-- CARGAR SCRIPTS
-- ============================================
for _, scriptData in ipairs(Scripts) do
    CreateScriptCard(scriptData)
end

-- ============================================
-- ANIMACIÓN DE ENTRADA
-- ============================================
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, mainWidth, 0, mainHeight)
}):Play()

task.wait(0.3)
CreateNotification("🎮 Hub cargado exitosamente", Color3.fromRGB(138, 43, 226))

print("✅ Isme Hub v2.1 - Fixed & Responsive")
print("📱 Dispositivo detectado: " .. deviceType)
print("📐 Resolución: " .. math.floor(screenSize.X) .. "x" .. math.floor(screenSize.Y))
print("📝 Scripts cargados: " .. #Scripts)
