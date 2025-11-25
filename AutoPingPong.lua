-- Auto Ping Pong Optimizado
-- Made by isme

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local autoPingPongEnabled = false
local keyActivated = false
local connection, healthConnection, descendantConnection
local promptConnections = {}
local modifiedCount = 0

-- Key válida
local VALID_KEY = "IsmeTheBest"

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoPingPongGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame de Key
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 280, 0, 160)
keyFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = screenGui

Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 10)

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 35)
keyTitle.Position = UDim2.new(0, 0, 0, 15)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔐 Auto Ping Pong"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 17
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 240, 0, 32)
keyInput.Position = UDim2.new(0.5, -120, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "Ingresa tu key..."
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyInput.TextSize = 13
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame

Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0, 240, 0, 32)
submitButton.Position = UDim2.new(0.5, -120, 0, 100)
submitButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
submitButton.Text = "Verificar"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 13
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = keyFrame

Instance.new("UICorner", submitButton).CornerRadius = UDim.new(0, 6)

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0, 15)
errorLabel.Position = UDim2.new(0, 0, 0, 140)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
errorLabel.TextSize = 11
errorLabel.Font = Enum.Font.Gotham
errorLabel.Parent = keyFrame

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 80)
mainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Auto Ping Pong"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -10, 0, 15)
counterLabel.Position = UDim2.new(0, 5, 0, 30)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Prompts: 0"
counterLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
counterLabel.TextSize = 11
counterLabel.Font = Enum.Font.Gotham
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 25)
toggleButton.Position = UDim2.new(0.5, -70, 1, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- Verificar key
local function verifyKey()
    if keyInput.Text == VALID_KEY then
        keyActivated = true
        errorLabel.Text = "✓ Correcto"
        errorLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        task.wait(0.5)
        keyFrame:TweenSize(UDim2.new(0, 280, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true)
        task.wait(0.3)
        keyFrame.Visible = false
        mainFrame.Visible = true
    else
        errorLabel.Text = "✗ Incorrecta"
        errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        keyInput.Text = ""
    end
end

submitButton.MouseButton1Click:Connect(verifyKey)
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then verifyKey() end
end)

-- Funciones core
local function setAnchored(anchored)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = anchored
        end
    end
end

local function modifyPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    
    if not prompt:GetAttribute("OriginalHoldDuration") then
        prompt:SetAttribute("OriginalHoldDuration", prompt.HoldDuration)
    end
    
    prompt.HoldDuration = 0
    
    local promptId = tostring(prompt)
    if not promptConnections[promptId] then
        promptConnections[promptId] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
            if autoPingPongEnabled and prompt.HoldDuration ~= 0 then
                prompt.HoldDuration = 0
            end
        end)
        
        modifiedCount = modifiedCount + 1
        counterLabel.Text = "Prompts: " .. modifiedCount
    end
end

local function restorePrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    
    local originalDuration = prompt:GetAttribute("OriginalHoldDuration")
    if originalDuration then
        prompt.HoldDuration = originalDuration
        prompt:SetAttribute("OriginalHoldDuration", nil)
    end
    
    local promptId = tostring(prompt)
    if promptConnections[promptId] then
        promptConnections[promptId]:Disconnect()
        promptConnections[promptId] = nil
    end
end

local function getPromptPosition(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Model") then
        local part = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
        if part then return part.Position end
    end
    if parent:IsA("Attachment") then return parent.WorldPosition end
end

local function modifyNearbyPrompts()
    if not humanoidRootPart then return end
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local pos = getPromptPosition(prompt)
            if pos and (humanoidRootPart.Position - pos).Magnitude <= prompt.MaxActivationDistance + 10 then
                modifyPrompt(prompt)
            end
        end
    end
end

local function modifyAllPrompts()
    modifiedCount = 0
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            modifyPrompt(prompt)
        end
    end
end

local function restoreAllPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            restorePrompt(prompt)
        end
    end
    for _, conn in pairs(promptConnections) do
        conn:Disconnect()
    end
    promptConnections = {}
    modifiedCount = 0
    counterLabel.Text = "Prompts: 0"
end

-- Toggle
local function toggleAutoPingPong()
    if not keyActivated then return end
    
    autoPingPongEnabled = not autoPingPongEnabled
    
    if autoPingPongEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        setAnchored(true)
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            healthConnection = humanoid.HealthChanged:Connect(function(health)
                if autoPingPongEnabled and health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
        
        modifyAllPrompts()
        connection = RunService.Heartbeat:Connect(modifyNearbyPrompts)
        descendantConnection = workspace.DescendantAdded:Connect(function(descendant)
            if autoPingPongEnabled and descendant:IsA("ProximityPrompt") then
                task.wait(0.1)
                modifyPrompt(descendant)
            end
        end)
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        setAnchored(false)
        
        if healthConnection then
            healthConnection:Disconnect()
            healthConnection = nil
        end
        if connection then
            connection:Disconnect()
            connection = nil
        end
        if descendantConnection then
            descendantConnection:Disconnect()
            descendantConnection = nil
        end
        
        restoreAllPrompts()
    end
end

toggleButton.MouseButton1Click:Connect(toggleAutoPingPong)

-- Cleanup
player.CharacterAdded:Connect(function(newChar)
    if autoPingPongEnabled then
        restoreAllPrompts()
        if connection then connection:Disconnect() end
        if healthConnection then healthConnection:Disconnect() end
        if descendantConnection then descendantConnection:Disconnect() end
        autoPingPongEnabled = false
    end
    
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    toggleButton.Text = "OFF"
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
end)
