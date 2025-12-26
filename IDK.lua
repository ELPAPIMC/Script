-- ZL Finder GUI - ZL Auto Joiner (Multi Tabs)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local textos = {
	"La grande",
	"Garama",
	"Dragon",
	"Meowl"
}

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZLFinderGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "ZL Auto Joiner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Barra de Tabs
local TabsBar = Instance.new("Frame")
TabsBar.Size = UDim2.new(1, 0, 0, 35)
TabsBar.Position = UDim2.new(0, 0, 0, 40)
TabsBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabsBar.BorderSizePixel = 0
TabsBar.Parent = MainFrame

-- Contenedor de contenido
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -95)
ContentFrame.Position = UDim2.new(0, 10, 0, 85)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Layout Tabs
local UIList = Instance.new("UIListLayout")
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.Padding = UDim.new(0, 5)
UIList.Parent = TabsBar

local pages = {}

-- Función Kick
local function kickPlayer(nombre)
	player:Kick(
		"JAJAJA 🤡\n" ..
		"Intentaste unirte a: " .. nombre .. "\n" ..
		"ZL Auto Joiner te troleó."
	)
end

-- Crear Tabs
for i, texto in ipairs(textos) do
	-- Botón Tab
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(0, 100, 1, 0)
	TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TabButton.Text = texto
	TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 14
	TabButton.Parent = TabsBar

	-- Página
	local Page = Instance.new("Frame")
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = ContentFrame
	pages[i] = Page

	-- Texto
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.6, 0, 0, 50)
	Label.Position = UDim2.new(0.05, 0, 0.3, 0)
	Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Label.Text = texto
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 16
	Label.Parent = Page

	-- Botón Join
	local JoinButton = Instance.new("TextButton")
	JoinButton.Size = UDim2.new(0.25, 0, 0, 50)
	JoinButton.Position = UDim2.new(0.7, 0, 0.3, 0)
	JoinButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
	JoinButton.Text = "Join"
	JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	JoinButton.Font = Enum.Font.GothamBold
	JoinButton.TextSize = 15
	JoinButton.Parent = Page

	JoinButton.MouseButton1Click:Connect(function()
		kickPlayer(texto)
	end)

	-- Cambiar tab
	TabButton.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do
			p.Visible = false
		end
		Page.Visible = true
	end)
end

-- Mostrar primer tab por defecto
pages[1].Visible = true
