-- Paintball GUI Library System
-- Sistema de librería modular para crear múltiples hacks

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables globales
local ESP_Objects = {}
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ==================== LIBRERÍA GUI ====================
local Library = {}
Library.Tabs = {}
Library.ActiveTab = nil

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PaintballLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Sombra
    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxasset://textures/ui/GUI/ShadowTexture.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 105, 180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Botón cerrar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Container de tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -45)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = TabContainer

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -150, 1, 0)
    ContentArea.Position = UDim2.new(0, 150, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = TabContainer

    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.ContentArea = ContentArea

    return self
end

function Library:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    
    -- Botón de tab
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    TabButton.BorderSizePixel = 0
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 13
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar

    -- Container de contenido
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    TabContent.Visible = false
    TabContent.Parent = self.ContentArea

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = TabContent

    TabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
            otherTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            otherTab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        self.ActiveTab = tab
    end)

    tab.Button = TabButton
    tab.Content = TabContent
    table.insert(self.Tabs, tab)
    
    -- Activar primera tab
    if #self.Tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        self.ActiveTab = tab
    end

    return tab
end

function Library:CreateToggle(tab, name, config, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.Content

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = toggleFrame

    -- Label
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -120, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = toggleFrame

    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 24)
    ToggleButton.Position = UDim2.new(1, -100, 0.5, -12)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = toggleFrame

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleButton

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    -- Settings Button
    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Size = UDim2.new(0, 35, 0, 35)
    SettingsButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    SettingsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SettingsButton.BorderSizePixel = 0
    SettingsButton.Text = "⚙️"
    SettingsButton.TextSize = 16
    SettingsButton.AutoButtonColor = false
    SettingsButton.Parent = toggleFrame

    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 8)
    SettingsCorner.Parent = SettingsButton

    local isEnabled = false

    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        config.Enabled = isEnabled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isEnabled then
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        
        if callback then callback(isEnabled) end
    end)

    -- Settings Panel
    if config.Settings then
        local SettingsPanel = Instance.new("Frame")
        SettingsPanel.Name = "SettingsPanel"
        SettingsPanel.Size = UDim2.new(1, 0, 0, 0)
        SettingsPanel.Position = UDim2.new(0, 0, 1, 5)
        SettingsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        SettingsPanel.BorderSizePixel = 0
        SettingsPanel.ClipsDescendants = true
        SettingsPanel.Visible = false
        SettingsPanel.Parent = toggleFrame

        local SettingsPanelCorner = Instance.new("UICorner")
        SettingsPanelCorner.CornerRadius = UDim.new(0, 8)
        SettingsPanelCorner.Parent = SettingsPanel

        local SettingsList = Instance.new("UIListLayout")
        SettingsList.Padding = UDim.new(0, 8)
        SettingsList.Parent = SettingsPanel

        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingBottom = UDim.new(0, 10)
        UIPadding.Parent = SettingsPanel

        local settingsOpen = false
        local totalHeight = 20

        -- Crear sliders
        for _, setting in ipairs(config.Settings) do
            if setting.Type == "Slider" then
                totalHeight = totalHeight + 68
                local slider = self:CreateSlider(SettingsPanel, setting.Name, setting.Min, setting.Max, setting.Default, setting.Suffix, config)
            elseif setting.Type == "Toggle" then
                totalHeight = totalHeight + 48
                local miniToggle = self:CreateMiniToggle(SettingsPanel, setting.Name, setting.Warning, config, setting.ConfigKey)
            end
        end

        SettingsButton.MouseButton1Click:Connect(function()
            settingsOpen = not settingsOpen
            
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if settingsOpen then
                SettingsPanel.Visible = true
                toggleFrame.Size = UDim2.new(1, 0, 0, 50)
                TweenService:Create(toggleFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 50 + totalHeight)}):Play()
                TweenService:Create(SettingsPanel, tweenInfo, {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                TweenService:Create(SettingsButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            else
                TweenService:Create(toggleFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 50)}):Play()
                TweenService:Create(SettingsPanel, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(SettingsButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                wait(0.3)
                SettingsPanel.Visible = false
            end
        end)
    end

    return toggleFrame
end

function Library:CreateSlider(parent, name, min, max, default, suffix, config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 18)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    SliderLabel.Font = Enum.Font.GothamBold
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 18)
    ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = default .. suffix
    ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, 0, 0, 8)
    SliderBG.Position = UDim2.new(0, 0, 0, 26)
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame

    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 18, 0, 18)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    SliderButton.Parent = SliderBG

    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
        ValueLabel.Text = value .. suffix
        
        -- Actualizar config
        if name:find("Velocidad") then
            config.FireRate = value / 100
        elseif name:find("Distancia") then
            config.MaxDistance = value
        end
        
        return value
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)

    return SliderFrame
end

function Library:CreateMiniToggle(parent, name, warning, config, configKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "MiniToggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 105, 180)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    if warning then
        local WarningLabel = Instance.new("TextLabel")
        WarningLabel.Size = UDim2.new(1, 0, 0, 15)
        WarningLabel.Position = UDim2.new(0, 0, 0, 20)
        WarningLabel.BackgroundTransparency = 1
        WarningLabel.Text = warning
        WarningLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
        WarningLabel.Font = Enum.Font.Gotham
        WarningLabel.TextSize = 9
        WarningLabel.TextXAlignment = Enum.TextXAlignment.Left
        WarningLabel.Parent = ToggleFrame
    end

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 45, 0, 22)
    Toggle.Position = UDim2.new(1, -45, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Toggle.BorderSizePixel = 0
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    Toggle.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if config[configKey] then
            TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end)

    return ToggleFrame
end

-- ==================== SISTEMA AUTO PAINTBALL ====================

local PaintballConfig = {
    Enabled = false,
    FireRate = 0.1,
    MaxDistance = 500,
    ShootAllMode = false,
    ESPColor = Color3.fromRGB(255, 105, 180),
    ESPTransparency = 0.3
}

local LastFireTime = 0
local ClosestPlayer = nil

-- Funciones ESP
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
        if ESP_Objects[player].Highlight then ESP_Objects[player].Highlight:Destroy() end
        if ESP_Objects[player].Billboard then ESP_Objects[player].Billboard:Destroy() end
        ESP_Objects[player] = nil
    end
end

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
                    table.insert(validPlayers, {Player = player, Root = targetRoot, Distance = distance})
                end
            end
        end
    end

    return validPlayers
end

local function FireAtTarget(position)
    local args = {position}
    
    pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
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

-- Loop principal
RunService.Heartbeat:Connect(function()
    if not PaintballConfig.Enabled then
        ClosestPlayer = nil
        return
    end

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

-- Eventos de jugadores
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

local lastEnabled = PaintballConfig.Enabled
RunService.Heartbeat:Connect(function()
    if PaintballConfig.Enabled ~= lastEnabled then
        UpdateAllESP()
        lastEnabled = PaintballConfig.Enabled
    end
end)

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

local window = Library:CreateWindow("🎨 Paintball Library")

-- Tab Principal
local mainTab = window:CreateTab("Principal", "🏠")

-- Toggle Auto Paintball con configuración
window:CreateToggle(mainTab, "🎯 Auto Paintball", {
    Enabled = false,
    FireRate = 0.1,
    MaxDistance = 500,
    ShootAllMode = false,
    Settings = {
        {
            Type = "Slider",
            Name = "⚡ Velocidad de Disparo",
            Min = 5,
            Max = 100,
            Default = 10,
            Suffix = "ms"
        },
        {
            Type = "Slider",
            Name = "📏 Distancia Máxima",
            Min = 100,
            Max = 1000,
            Default = 500,
            Suffix = "m"
        },
        {
            Type = "Toggle",
            Name = "🎯 Disparar a Todos",
            Warning = "⚠️ BETA - Puede causar lag",
            ConfigKey = "ShootAllMode"
        }
    }
}, function(enabled)
    PaintballConfig.Enabled = enabled
end)

-- Tab de Otros (ejemplo de cómo crear más toggles)
local othersTab = window:CreateTab("Otros", "🔧")

-- Ejemplo de cómo crear más toggles fácilmente
window:CreateToggle(othersTab, "🏃 Speed Hack", {
    Enabled = false,
    Speed = 16,
    Settings = {
        {
            Type = "Slider",
            Name = "💨 Velocidad",
            Min = 16,
            Max = 100,
            Default = 16,
            Suffix = " studs"
        }
    }
}, function(enabled)
    -- Aquí iría la lógica del speed hack
    print("Speed Hack:", enabled)
end)

window:CreateToggle(othersTab, "🦘 Jump Power", {
    Enabled = false,
    JumpPower = 50,
    Settings = {
        {
            Type = "Slider",
            Name = "🔋 Poder de Salto",
            Min = 50,
            Max = 200,
            Default = 50,
            Suffix = " power"
        }
    }
}, function(enabled)
    -- Aquí iría la lógica del jump power
    print("Jump Power:", enabled)
end)

-- Tab de Info
local infoTab = window:CreateTab("Info", "ℹ️")

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(1, 0, 0, 150)
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
🎨 PAINTBALL LIBRARY v1.0

✨ Características:
• Sistema modular de toggles
• Configuración personalizable
• Compatible con móvil y PC
• ESP con marcadores visuales
• Modo disparar a todos (BETA)

📝 Cómo usar:
1. Activa el toggle principal
2. Usa ⚙️ para configurar
3. Ajusta velocidad y distancia
4. ¡Disfruta!

💡 Para crear nuevos hacks solo usa:
window:CreateToggle(tab, "Nombre", config, callback)
]]
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.TextWrapped = true
InfoText.Parent = InfoFrame

print("🎨 Paintball Library cargada!")
print("✨ Sistema modular activado")
print("📝 Usa CreateToggle para crear nuevos hacks")
