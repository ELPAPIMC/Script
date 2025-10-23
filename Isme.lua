--[[ 
    ⚔️ SAB PVP UTILITIES
    Full System: Player (Movement), Visual (ESP), Keybinds (PC Only)
]]

-- Cargar la librería
local IS = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/LIBRARYS/refs/heads/main/IS.lua"))()

-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════
-- CREAR VENTANA PRINCIPAL
-- ═══════════════════════════════════════════════════════════
local Window = IS:CreateWindow({
    Title = "⚔️ SAB PVP UTILITIES",
    MobileButton = true
})

IS:Notify("Welcome!", "SAB PVP UTILITIES loaded successfully!", "success", 4)

-- ═══════════════════════════════════════════════════════════
-- CREAR TABS (Keybinds solo para PC)
-- ═══════════════════════════════════════════════════════════
local PlayerTab = Window:CreateTab("Player", "rbxassetid://7733674079")
local CombatTab = Window:CreateTab("Combat", "rbxassetid://7733954760")
local VisualTab = Window:CreateTab("Visual", "rbxassetid://7733919505")
local MiscTab = Window:CreateTab("Misc", "rbxassetid://7733920644")

local KeybindTab = nil
if UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled then
	KeybindTab = Window:CreateTab("Keybinds", "rbxassetid://7734053495")
	KeybindTab:AddSection("⌨️ PC Keybinds")
	IS:Notify("System", "PC detected - Keybinds tab loaded", "info", 2)
else
	IS:Notify("System", "Mobile detected - Keybinds tab hidden", "info", 2)
end

-- ═══════════════════════════════════════════════════════════
-- 🏃 PLAYER MOVEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════

PlayerTab:AddSection("🏃 Movement")

local humanoid = nil
local wsEnabled = false
local wsValue = 16
local jpEnabled = false
local jpValue = 50
local infiniteJump = false

local function getHumanoid()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	humanoid = getHumanoid()
end)

humanoid = getHumanoid()

-- WalkSpeed
PlayerTab:AddToggle("WalkSpeed", false, function(enabled)
	wsEnabled = enabled
	humanoid = getHumanoid()
	if humanoid then
		if enabled then
			humanoid.WalkSpeed = wsValue
			IS:Notify("Speed", "WalkSpeed set to " .. wsValue, "success", 2)
		else
			humanoid.WalkSpeed = 16
			IS:Notify("Speed", "WalkSpeed reset to default", "info", 2)
		end
	end
end)

PlayerTab:AddSlider("WalkSpeed Value", 16, 200, 16, function(value)
	wsValue = value
	if wsEnabled and getHumanoid() then
		getHumanoid().WalkSpeed = wsValue
	end
end)

-- JumpPower
PlayerTab:AddToggle("JumpPower", false, function(enabled)
	jpEnabled = enabled
	humanoid = getHumanoid()
	if humanoid then
		if enabled then
			humanoid.JumpPower = jpValue
			IS:Notify("Jump", "JumpPower set to " .. jpValue, "success", 2)
		else
			humanoid.JumpPower = 50
			IS:Notify("Jump", "JumpPower reset to default", "info", 2)
		end
	end
end)

PlayerTab:AddSlider("JumpPower Value", 50, 200, 50, function(value)
	jpValue = value
	if jpEnabled and getHumanoid() then
		getHumanoid().JumpPower = jpValue
	end
end)

-- Infinite Jump
PlayerTab:AddToggle("Infinite Jump", false, function(enabled)
	infiniteJump = enabled
	if enabled then
		IS:Notify("Infinite Jump", "Infinite Jump activated!", "success", 2)
	else
		IS:Notify("Infinite Jump", "Infinite Jump disabled", "info", 2)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if infiniteJump and getHumanoid() then
		getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ═══════════════════════════════════════════════════════════
-- 👁️ VISUAL TAB - ESP SYSTEM
-- ═══════════════════════════════════════════════════════════

local ESP_ENABLED = false
local ESP_OPTIONS = { "Box", "Name", "Health", "Distance", "Skeleton" }
local SELECTED_ESP = { "Box", "Name" }
local ESP_DRAWINGS = {}

local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	if ESP_DRAWINGS[player] then return end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = player.Character
	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
	highlight.Parent = player.Character
	ESP_DRAWINGS[player] = highlight
end

local function removeESP(player)
	if ESP_DRAWINGS[player] then
		ESP_DRAWINGS[player]:Destroy()
		ESP_DRAWINGS[player] = nil
	end
end

local function updateESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if ESP_ENABLED then
				if not ESP_DRAWINGS[player] then
					createESP(player)
				end
			else
				removeESP(player)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	if ESP_ENABLED then
		player.CharacterAdded:Connect(function()
			task.wait(1)
			createESP(player)
		end)
	end
end)

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
	if not ESP_ENABLED then return end
	for player, esp in pairs(ESP_DRAWINGS) do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			if table.find(SELECTED_ESP, "Health") then
				local hp = player.Character.Humanoid.Health
				esp.OutlineColor = Color3.fromRGB(255 - hp * 2, hp * 2, 0)
			else
				esp.OutlineColor = Color3.fromRGB(255, 0, 0)
			end
		end
	end
end)

VisualTab:AddSection("👁️ ESP System")

VisualTab:AddToggle("Enable ESP", false, function(enabled)
	ESP_ENABLED = enabled
	if enabled then
		IS:Notify("ESP", "ESP enabled!", "success", 2)
		updateESP()
	else
		IS:Notify("ESP", "ESP disabled!", "info", 2)
		for _, p in ipairs(Players:GetPlayers()) do
			removeESP(p)
		end
	end
end)

VisualTab:AddDropdown("ESP Elements", ESP_OPTIONS, true, SELECTED_ESP, function(selected)
	SELECTED_ESP = selected
	IS:Notify("ESP Config", "Selected: " .. table.concat(selected, ", "), "info", 2)
end)

-- ═══════════════════════════════════════════════════════════
-- ⌨️ KEYBINDS TAB (solo PC)
-- ═══════════════════════════════════════════════════════════
if KeybindTab then
	local keybinds = {}

	KeybindTab:AddKeybind("Toggle ESP", Enum.KeyCode.E, function()
		ESP_ENABLED = not ESP_ENABLED
		updateESP()
		IS:Notify("Keybind", "ESP " .. (ESP_ENABLED and "enabled" or "disabled"), "info", 2)
	end)

	KeybindTab:AddKeybind("Toggle Infinite Jump", Enum.KeyCode.F, function()
		infiniteJump = not infiniteJump
		IS:Notify("Keybind", "Infinite Jump " .. (infiniteJump and "on" or "off"), "info", 2)
	end)

	KeybindTab:AddKeybind("Boost Speed", Enum.KeyCode.LeftShift, function()
		if getHumanoid() then
			getHumanoid().WalkSpeed = wsValue + 20
			task.wait(0.2)
			getHumanoid().WalkSpeed = wsValue
		end
	end)
end

-- ═══════════════════════════════════════════════════════════
-- SETTINGS TAB Y FIN
-- ═══════════════════════════════════════════════════════════
Window:CreateSettingsTab()

print("═══════════════════════════════════════════════════════")
print("⚔️ SAB PVP UTILITIES - FULL SYSTEM LOADED")
print("═══════════════════════════════════════════════════════")
