-- Auto Ping Pong Optimizado
-- Made by isme

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local vim = VirtualInputManager

-- Variables
local keyActivated = false
local anchorEnabled = false
local autoBuyEnabled = false
local healthConnection
local autoBuyConnection

-- Key válida
local VALID_KEY = "IsmeTheBest"

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoPingPongGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame de Key
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 280, 0, 180)
keyFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
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
submitButton.Size = UDim2.new(0, 140, 0, 32)
submitButton.Position = UDim2.new(0, 20, 0, 105)
submitButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
submitButton.Text = "Verificar"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 13
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = keyFrame

Instance.new("UICorner", submitButton).CornerRadius = UDim.new(0, 6)

local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0, 100, 0, 32)
getKeyButton.Position = UDim2.new(1, -120, 0, 105)
getKeyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 13
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = keyFrame

Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 6)

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0, 15)
errorLabel.Position = UDim2.new(0, 0, 0, 145)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
errorLabel.TextSize = 11
errorLabel.Font = Enum.Font.Gotham
errorLabel.Parent = keyFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 15)
statusLabel.Position = UDim2.new(0, 0, 0, 160)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = keyFrame

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 125)
mainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Auto Ping Pong"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local modifyButton = Instance.new("TextButton")
modifyButton.Size = UDim2.new(0, 160, 0, 25)
modifyButton.Position = UDim2.new(0.5, -80, 0, 35)
modifyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
modifyButton.Text = "Modificar Prompts"
modifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modifyButton.TextSize = 12
modifyButton.Font = Enum.Font.GothamBold
modifyButton.Parent = mainFrame

Instance.new("UICorner", modifyButton).CornerRadius = UDim.new(0, 6)

local anchorToggle = Instance.new("TextButton")
anchorToggle.Size = UDim2.new(0, 160, 0, 25)
anchorToggle.Position = UDim2.new(0.5, -80, 0, 65)
anchorToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
anchorToggle.Text = "Anchor: OFF"
anchorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
anchorToggle.TextSize = 12
anchorToggle.Font = Enum.Font.GothamBold
anchorToggle.Parent = mainFrame

Instance.new("UICorner", anchorToggle).CornerRadius = UDim.new(0, 6)

local autoBuyToggle = Instance.new("TextButton")
autoBuyToggle.Size = UDim2.new(0, 160, 0, 25)
autoBuyToggle.Position = UDim2.new(0.5, -80, 0, 95)
autoBuyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
autoBuyToggle.Text = "Auto Buy: OFF"
autoBuyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBuyToggle.TextSize = 12
autoBuyToggle.Font = Enum.Font.GothamBold
autoBuyToggle.Parent = mainFrame

Instance.new("UICorner", autoBuyToggle).CornerRadius = UDim.new(0, 6)

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

-- Botón Get Key
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/VcUJFcaV5g")
    statusLabel.Text = "✓ Discord copiado al portapapeles"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(2)
    statusLabel.Text = ""
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
end

local function restorePrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    
    local originalDuration = prompt:GetAttribute("OriginalHoldDuration")
    if originalDuration then
        prompt.HoldDuration = originalDuration
        prompt:SetAttribute("OriginalHoldDuration", nil)
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

local function modifyAllPrompts()
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
end

-- Botón para modificar prompts
modifyButton.MouseButton1Click:Connect(function()
    if not keyActivated then return end
    modifyAllPrompts()
    modifyButton.Text = "✓ Modificados"
    modifyButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    task.wait(1)
    modifyButton.Text = "Modificar Prompts"
    modifyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
end)

-- Toggle para anchor
anchorToggle.MouseButton1Click:Connect(function()
    if not keyActivated then return end
    
    anchorEnabled = not anchorEnabled
    
    if anchorEnabled then
        anchorToggle.Text = "Anchor: ON"
        anchorToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        setAnchored(true)
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            healthConnection = humanoid.HealthChanged:Connect(function(health)
                if anchorEnabled and health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
    else
        anchorToggle.Text = "Anchor: OFF"
        anchorToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        setAnchored(false)
        
        if healthConnection then
            healthConnection:Disconnect()
            healthConnection = nil
        end
    end
end)

-- Toggle para Auto Buy
autoBuyToggle.MouseButton1Click:Connect(function()
    if not keyActivated then return end
    
    autoBuyEnabled = not autoBuyEnabled
    
    if autoBuyEnabled then
        autoBuyToggle.Text = "Auto Buy: ON"
        autoBuyToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        
        autoBuyConnection = RunService.Heartbeat:Connect(function()
            if autoBuyEnabled then
                -- Simular presionar E
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end
        end)
    else
        autoBuyToggle.Text = "Auto Buy: OFF"
        autoBuyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        
        if autoBuyConnection then
            autoBuyConnection:Disconnect()
            autoBuyConnection = nil
        end
    end
end)

-- Cleanup
player.CharacterAdded:Connect(function(newChar)
    if anchorEnabled then
        if healthConnection then healthConnection:Disconnect() end
        anchorEnabled = false
    end
    
    if autoBuyEnabled then
        if autoBuyConnection then autoBuyConnection:Disconnect() end
        autoBuyEnabled = false
    end
    
    restoreAllPrompts()
    
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    anchorToggle.Text = "Anchor: OFF"
    anchorToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    autoBuyToggle.Text = "Auto Buy: OFF"
    autoBuyToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
end)
