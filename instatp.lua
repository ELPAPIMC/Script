--[[
    INSTA STEAL - Smart Auto Delivery Script
    + Remote Whitelist (GitHub JSON)
    (NO NOTIFICATIONS)
]]

-- SERVICES
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ======================
-- WHITELIST CONFIG
-- ======================
local WHITELIST_URL = "https://raw.githubusercontent.com/ELPAPIMC/whitelist/refs/heads/main/whitelist.json"

local function isWhitelisted()
    local success, response = pcall(function()
        return HttpService:GetAsync(WHITELIST_URL)
    end)
    if not success then return false end

    local data
    success, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if not success or not data or not data.whitelist then return false end

    for _, name in ipairs(data.whitelist) do
        if string.lower(name) == string.lower(player.Name) then
            return true
        end
    end
    return false
end

-- CHECK WHITELIST
if not isWhitelisted() then
    player:Kick("No estás autorizado")
    return
end

-- ======================
-- CONFIG
-- ======================
local CONFIG = {
    TeleportDelay = 0.05,
    CheckRadius = 20
}

-- STATE
local teleportEnabled = false
local isTeleporting = false

-- HRP
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "InstaStealGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- FIND OBJECTS
local function findObjectsWithOrder(order)
    local objs = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:GetAttribute("order") == order then
            table.insert(objs, v)
        end
    end
    return objs
end

local function getObjectPosition(obj)
    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if p then return p.Position end
    end
end

local function findDeliveryHitbox(parent)
    for _, v in ipairs(parent:GetDescendants()) do
        if v.Name:lower():find("deliveryhitbox") and v:IsA("BasePart") then
            return v.CFrame
        end
    end
    if parent:IsA("BasePart") then return parent.CFrame end
    if parent:IsA("Model") and parent.PrimaryPart then return parent.PrimaryPart.CFrame end
end

-- DETECT CURRENT ORDER
local function getCurrentOrder()
    local hrp = getHRP()
    local pos = hrp.Position

    for _, order in ipairs({1, 2}) do
        for _, obj in ipairs(findObjectsWithOrder(order)) do
            local p = getObjectPosition(obj)
            if p and (p - pos).Magnitude < CONFIG.CheckRadius then
                return order
            end
        end
    end
end

-- TELEPORT
local function executeTeleport()
    if isTeleporting or not teleportEnabled then return end
    isTeleporting = true

    local currentOrder = getCurrentOrder()
    if not currentOrder then
        isTeleporting = false
        return
    end

    local targetOrder = currentOrder == 1 and 2 or 1
    local targets = findObjectsWithOrder(targetOrder)

    for _, obj in ipairs(targets) do
        local cf = findDeliveryHitbox(obj)
        if cf then
            task.wait(CONFIG.TeleportDelay)
            getHRP().CFrame = cf
            break
        end
    end

    task.wait(0.5)
    isTeleporting = false
end

-- UI FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 20, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 170, 255)
title.Text = "📦 INSTA STEAL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 50)
toggle.Position = UDim2.new(0.05, 0, 0, 40)
toggle.Text = "🔴 Auto TP: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.BorderSizePixel = 0
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

toggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    if teleportEnabled then
        toggle.Text = "🟢 Auto TP: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
    else
        toggle.Text = "🔴 Auto TP: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

-- PROMPT
ProximityPromptService.PromptTriggered:Connect(function(_, plr)
    if plr == player then
        executeTeleport()
    end
end)
