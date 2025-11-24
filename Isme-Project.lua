-- Isme | Project - Script Hub
-- Created by: Isme
-- Version: 1.0

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- CONFIGURACIÓN DE SCRIPTS
-- ============================================
-- Aquí puedes agregar más scripts fácilmente
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
    -- ⬇️ AGREGA MÁS SCRIPTS AQUÍ ⬇️
    -- {
    --     Name = "Nombre del Script",
    --     Category = "Categoria",
    --     Code = [[tu código aquí]]
    -- },
}

-- ============================================
-- CREAR GUI
-- ============================================

-- Screen GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IsmeProjectHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protección
if syn then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 60)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Parent = Header

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Isme | Project"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Botón Cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseButton.Position = UDim2.new(1, -50, 0, 15)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Botón Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
MinimizeButton.Position = UDim2.new(1, -90, 0, 15)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 700, 0, 60) or UDim2.new(0, 700, 0, 500)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
end)

-- Container de Scripts
local ScriptsContainer = Instance.new("ScrollingFrame")
ScriptsContainer.Name = "ScriptsContainer"
ScriptsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ScriptsContainer.BorderSizePixel = 0
ScriptsContainer.Position = UDim2.new(0, 10, 0, 70)
ScriptsContainer.Size = UDim2.new(1, -20, 1, -80)
ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsContainer.ScrollBarThickness = 6
ScriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ScriptsContainer.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = ScriptsContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScriptsContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = ScriptsContainer
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)

-- ============================================
-- FUNCIONES
-- ============================================

local function CreateNotification(text, color)
    local Notification = Instance.new("Frame")
    Notification.BackgroundColor3 = color or Color3.fromRGB(40, 167, 69)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(1, 10, 0, 70)
    Notification.Size = UDim2.new(0, 300, 0, 60)
    Notification.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    local NotifText = Instance.new("TextLabel")
    NotifText.BackgroundTransparency = 1
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.Font = Enum.Font.Gotham
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.TextWrapped = true
    NotifText.Parent = Notification
    
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 0, 70)}):Play()
    
    wait(3)
    
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 70)}):Play()
    wait(0.3)
    Notification:Destroy()
end

local function ExecuteScript(code)
    local success, err = pcall(function()
        loadstring(code)()
    end)
    
    if success then
        CreateNotification("✅ Script ejecutado correctamente", Color3.fromRGB(40, 167, 69))
    else
        CreateNotification("❌ Error al ejecutar: " .. tostring(err), Color3.fromRGB(220, 53, 69))
    end
end

local function CreateScriptCard(scriptData)
    local Card = Instance.new("Frame")
    Card.Name = scriptData.Name
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Card.BorderSizePixel = 0
    Card.Size = UDim2.new(1, -12, 0, 80)
    Card.Parent = ScriptsContainer
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    -- Nombre del Script
    local ScriptName = Instance.new("TextLabel")
    ScriptName.Name = "ScriptName"
    ScriptName.BackgroundTransparency = 1
    ScriptName.Position = UDim2.new(0, 15, 0, 10)
    ScriptName.Size = UDim2.new(0, 300, 0, 25)
    ScriptName.Font = Enum.Font.GothamBold
    ScriptName.Text = scriptData.Name
    ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptName.TextSize = 16
    ScriptName.TextXAlignment = Enum.TextXAlignment.Left
    ScriptName.Parent = Card
    
    -- Categoría
    local Category = Instance.new("TextLabel")
    Category.Name = "Category"
    Category.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Category.Position = UDim2.new(0, 15, 0, 40)
    Category.Size = UDim2.new(0, 80, 0, 25)
    Category.Font = Enum.Font.Gotham
    Category.Text = scriptData.Category
    Category.TextColor3 = Color3.fromRGB(255, 255, 255)
    Category.TextSize = 12
    Category.Parent = Card
    
    local CatCorner = Instance.new("UICorner")
    CatCorner.CornerRadius = UDim.new(0, 6)
    CatCorner.Parent = Category
    
    -- Botón Ejecutar
    local ExecuteButton = Instance.new("TextButton")
    ExecuteButton.Name = "ExecuteButton"
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    ExecuteButton.Position = UDim2.new(1, -110, 0, 25)
    ExecuteButton.Size = UDim2.new(0, 95, 0, 30)
    ExecuteButton.Font = Enum.Font.GothamBold
    ExecuteButton.Text = "▶ Ejecutar"
    ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteButton.TextSize = 14
    ExecuteButton.Parent = Card
    
    local ExecCorner = Instance.new("UICorner")
    ExecCorner.CornerRadius = UDim.new(0, 6)
    ExecCorner.Parent = ExecuteButton
    
    ExecuteButton.MouseButton1Click:Connect(function()
        ExecuteScript(scriptData.Code)
    end)
    
    -- Hover effect
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
    CopyButton.Position = UDim2.new(1, -210, 0, 25)
    CopyButton.Size = UDim2.new(0, 95, 0, 30)
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.Text = "📋 Copiar"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 14
    CopyButton.Parent = Card
    
    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 6)
    CopyCorner.Parent = CopyButton
    
    CopyButton.MouseButton1Click:Connect(function()
        setclipboard(scriptData.Code)
        CreateNotification("📋 Código copiado al portapapeles", Color3.fromRGB(23, 162, 184))
    end)
    
    CopyButton.MouseEnter:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 138, 145)}):Play()
    end)
    
    CopyButton.MouseLeave:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(108, 117, 125)}):Play()
    end)
end

-- ============================================
-- CARGAR TODOS LOS SCRIPTS
-- ============================================

for _, scriptData in ipairs(Scripts) do
    CreateScriptCard(scriptData)
end

-- Ajustar tamaño del canvas
ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- ============================================
-- ANIMACIÓN DE ENTRADA
-- ============================================

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 700, 0, 500)}):Play()

-- Notificación de bienvenida
wait(0.3)
CreateNotification("🎮 Isme Project cargado correctamente", Color3.fromRGB(138, 43, 226))

print("✅ Isme | Project - Script Hub cargado correctamente")
print("📝 Total de scripts: " .. #Scripts)
