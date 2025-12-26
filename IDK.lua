-- CONFIGURACIÓN
local IMAGE_ID = "rbxassetid://109211928331150"
local SOUND_ID = "rbxassetid://6754147732"
local DURATION = 1.5

-- SERVICIOS
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1, 0, 1, 0)
image.Position = UDim2.new(0, 0, 0, 0)
image.BackgroundTransparency = 1
image.Image = IMAGE_ID
image.ImageTransparency = 1
image.Parent = gui

-- SONIDO
local sound = Instance.new("Sound")
sound.SoundId = SOUND_ID
sound.Volume = 10
sound.PlaybackSpeed = 1
sound.Parent = camera

-- JUMPSCARE
local function jumpscare()
	-- Imagen instantánea
	TweenService:Create(
		image,
		TweenInfo.new(0.06),
		{ImageTransparency = 0}
	):Play()

	-- Sonido
	sound:Play()

	-- Shake cámara
	local original = camera.CFrame
	for i = 1, 14 do
		camera.CFrame = original * CFrame.new(
			math.random(-4,4)/20,
			math.random(-4,4)/20,
			0
		)
		task.wait(0.03)
	end
	camera.CFrame = original

	task.wait(DURATION)

	-- Desaparece
	TweenService:Create(
		image,
		TweenInfo.new(0.25),
		{ImageTransparency = 1}
	):Play()
end

-- EJECUTAR
jumpscare()
