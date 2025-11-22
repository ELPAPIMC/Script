-- QUESTION HUB - NoAnim Toggle (GUI ARRASTRABLE + OPTIMIZADO 2025)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- === GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "QH_NoAnimGUI"
gui.ResetOnSpawn = false
gui.Parent = pgui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 90)
frame.Position = UDim2.new(0.5, -140, 0.5, -45)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "QUESTION HUB"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 220, 0, 40)
btn.Position = UDim2.new(0.5, -110, 0.5, 5)
btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btn.Text = "NoAnim: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

-- === SISTEMA DE ARRASTRE PERFECTO ===
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- === ANIMACIÓN BOTÓN ===
local function setState(on)
    btn.Text = "NoAnim: " .. (on and "ON" or "OFF")
    TweenService:Create(btn, TweenInfo.new(0.25), {
        BackgroundColor3 = on and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    }):Play()
end

-- === NOANIM (MISMA LÓGICA OPTIMIZADA) ===
local noAnimActive = false
local connection

local function enableNoAnim()
    if connection then return end
    local hum = player.Character:WaitForChild("Humanoid")
    local anim = hum:FindFirstChildOfClass("Animator")
    if anim then anim:Destroy() end
    
    local fake = Instance.new("Animator", hum)
    
    hum.ChildAdded:Connect(function(child)
        if child:IsA("Animator") and child ~= fake then
            task.defer(child.Destroy, child)
        end
    end)
    
    connection = RunService.Heartbeat:Connect(function()
        for _, track in hum:GetPlayingAnimationTracks() do
            track:Stop()
        end
    end)
    
    noAnimActive = true
    setState(true)
end

local function disableNoAnim()
    if connection then connection:Disconnect() connection = nil end
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum and not hum:FindFirstChildOfClass("Animator") then
        Instance.new("Animator", hum)
    end
    noAnimActive = false
    setState(false)
end

btn.MouseButton1Click:Connect(function()
    if noAnimActive then disableNoAnim() else enableNoAnim() end
end)

-- Reaplicar al respawn
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if noAnimActive then task.spawn(enableNoAnim) end
end)

print("QUESTION HUB - NoAnim + GUI ARRASTRABLE cargado 🔥")
