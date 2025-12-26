-- ZL Finder GUI - LocalScript Mejorado Hecho con ia me dio paja xd
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "ZL Finder GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame con bordes redondeados
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 500)
main.Position = UDim2.new(0.5, -225, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Sombra/Borde brillante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔍 ZL AUTO FINDER"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 70)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 Servidores encontrados: 10 | Estado: ACTIVO"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = main

-- ScrollingFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0, 10, 0, 110)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scroll.BorderSizePixel = 0
scroll.Parent = main

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scroll

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = scroll

-- Textos personalizados
local fakeTexts = {
	{name = "La Grande Combi", players = "12/50", ping = "45ms"},
	{name = "Garama", players = "8/30", ping = "23ms"},
	{name = "Dragon", players = "25/50", ping = "67ms"},
	{name = "Mewol", players = "35/50", ping = "38ms"},
	{name = "Lavadorit0", players = "5/20", ping = "19ms"},
	{name = "La Grande Combi", players = "18/40", ping = "52ms"},
	{name = "Garama", players = "10/25", ping = "31ms"},
	{name = "Dragon", players = "3/15", ping = "28ms"},
	{name = "Mewol", players = "42/50", ping = "71ms"},
	{name = "Lavadorit0", players = "7/20", ping = "26ms"}
}

-- Función para crear entradas
local function createEntry(data, index)
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -16, 0, 70)
	entry.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	entry.BorderSizePixel = 0
	entry.LayoutOrder = index
	entry.Parent = scroll
	
	local entryCorner = Instance.new("UICorner")
	entryCorner.CornerRadius = UDim.new(0, 8)
	entryCorner.Parent = entry
	
	local entryStroke = Instance.new("UIStroke")
	entryStroke.Color = Color3.fromRGB(50, 50, 50)
	entryStroke.Thickness = 1
	entryStroke.Transparency = 0.5
	entryStroke.Parent = entry
	
	-- Nombre del servidor
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.55, 0, 0, 25)
	nameLabel.Position = UDim2.new(0, 12, 0, 8)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = data.name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = entry
	
	-- Jugadores
	local playersLabel = Instance.new("TextLabel")
	playersLabel.Size = UDim2.new(0, 80, 0, 18)
	playersLabel.Position = UDim2.new(0, 12, 0, 35)
	playersLabel.BackgroundTransparency = 1
	playersLabel.Text = "👥 " .. data.players
	playersLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	playersLabel.Font = Enum.Font.Gotham
	playersLabel.TextSize = 12
	playersLabel.TextXAlignment = Enum.TextXAlignment.Left
	playersLabel.Parent = entry
	
	-- Ping
	local pingLabel = Instance.new("TextLabel")
	pingLabel.Size = UDim2.new(0, 80, 0, 18)
	pingLabel.Position = UDim2.new(0, 100, 0, 35)
	pingLabel.BackgroundTransparency = 1
	pingLabel.Text = "📡 " .. data.ping
	pingLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	pingLabel.Font = Enum.Font.Gotham
	pingLabel.TextSize = 12
	pingLabel.TextXAlignment = Enum.TextXAlignment.Left
	pingLabel.Parent = entry
	
	-- Botón Join
	local joinBtn = Instance.new("TextButton")
	joinBtn.Size = UDim2.new(0, 90, 0, 50)
	joinBtn.Position = UDim2.new(1, -100, 0.5, -25)
	joinBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
	joinBtn.Text = "JOIN"
	joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	joinBtn.Font = Enum.Font.GothamBold
	joinBtn.TextSize = 16
	joinBtn.Parent = entry
	
	local joinCorner = Instance.new("UICorner")
	joinCorner.CornerRadius = UDim.new(0, 6)
	joinCorner.Parent = joinBtn
	
	-- Efecto hover
	joinBtn.MouseEnter:Connect(function()
		TweenService:Create(joinBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(255, 30, 30)
		}):Play()
	end)
	
	joinBtn.MouseLeave:Connect(function()
		TweenService:Create(joinBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(220, 20, 20)
		}):Play()
	end)
	
	-- Click del botón
	joinBtn.MouseButton1Click:Connect(function()
		joinBtn.Text = "..."
		wait(0.5)
		player:Kick("😂 ZL NO EXISTE BRO\n\n❌ Caíste en la trampa\n💀 Gracias por intentar auto-join 😭\n\n¡No hay ZL aquí campeón!")
	end)
end

-- Crear todas las entradas
for i, data in ipairs(fakeTexts) do
	createEntry(data, i)
	wait(0.05) -- Pequeña animación de aparición
end

-- Ajustar canvas del scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
end)

-- Hacer el GUI arrastrable
local dragging = false
local dragInput, mousePos, framePos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = main.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		main.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

-- Animación de entrada
main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 450, 0, 500)
}):Play()
