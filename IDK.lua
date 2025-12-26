-- Sistema de Notificaciones con Franja Azul
-- Coloca este script en StarterGui > ScreenGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui si no existe
local screenGui = playerGui:FindFirstChild("NotificationGui") or Instance.new("ScreenGui")
screenGui.Name = "NotificationGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Contenedor para las notificaciones
local container = Instance.new("Frame")
container.Name = "NotificationContainer"
container.Size = UDim2.new(0, 300, 1, 0)
container.Position = UDim2.new(1, -320, 0, 20)
container.BackgroundTransparency = 1
container.Parent = screenGui

-- Lista de notificaciones de ejemplo (puedes cambiar estos textos)
local notificationTexts = {
	"Garama and Madundung",
	"Tang Tang Keletang",
	"Dragon Cannelloni",
	"La Supreme Combinasion",
	"Secret Lucky Block",
	"Capitano Moby",
}

local currentIndex = 1
local activeNotifications = {}
local maxNotifications = 5

-- Función para crear una notificación
local function createNotification(text)
	-- Crear frame principal
	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(1, 0, 0, 70)
	notifFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	notifFrame.BorderSizePixel = 0
	notifFrame.ClipsDescendants = true
	
	-- Esquinas redondeadas
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notifFrame
	
	-- Franja azul lateral
	local blueStripe = Instance.new("Frame")
	blueStripe.Size = UDim2.new(0, 6, 1, 0)
	blueStripe.Position = UDim2.new(0, 0, 0, 0)
	blueStripe.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	blueStripe.BorderSizePixel = 0
	blueStripe.Parent = notifFrame
	
	-- Texto de la notificación
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 1, 0)
	textLabel.Position = UDim2.new(0, 15, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 16
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextWrapped = true
	textLabel.Parent = notifFrame
	
	return notifFrame
end

-- Función para reorganizar notificaciones
local function repositionNotifications()
	for i, notif in ipairs(activeNotifications) do
		local targetPos = UDim2.new(0, 0, 0, (i - 1) * 80)
		local tween = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = targetPos})
		tween:Play()
	end
end

-- Función para mostrar notificación
local function showNotification(text)
	-- Crear notificación
	local notif = createNotification(text)
	notif.Position = UDim2.new(1, 0, 0, #activeNotifications * 80)
	notif.Parent = container
	
	-- Agregar a la lista al final (abajo)
	table.insert(activeNotifications, notif)
	
	-- Eliminar notificaciones antiguas si hay demasiadas
	if #activeNotifications > maxNotifications then
		local oldNotif = activeNotifications[1]
		table.remove(activeNotifications, 1)
		local fadeOut = TweenService:Create(oldNotif, TweenInfo.new(0.3), {BackgroundTransparency = 1})
		fadeOut:Play()
		fadeOut.Completed:Connect(function()
			oldNotif:Destroy()
			repositionNotifications()
		end)
	end
	
	-- Animar entrada
	local slideIn = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, (#activeNotifications - 1) * 80)})
	slideIn:Play()
	
	-- Eliminar después de 5 segundos
	task.wait(5)
	if notif and notif.Parent then
		for i, n in ipairs(activeNotifications) do
			if n == notif then
				table.remove(activeNotifications, i)
				break
			end
		end
		
		local fadeOut = TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1})
		fadeOut:Play()
		fadeOut.Completed:Connect(function()
			notif:Destroy()
			repositionNotifications()
		end)
	end
end

-- Loop principal para mostrar notificaciones cada 1 segundo con textos aleatorios
while true do
	-- Seleccionar un texto aleatorio
	local randomIndex = math.random(1, #notificationTexts)
	showNotification(notificationTexts[randomIndex])
	
	task.wait(1)
end
