-- ZL Finder GUI - ZL Auto Joiner (ScrollFrame)

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

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarImageTransparency = 0
ScrollFrame.Parent = MainFrame

-- Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- Función Kick
local function kickPlayer(nombre)
	player:Kick(
		"TONTO COMO PIENSAS QUE ZL ES TAN PENDEJO\n\n" ..
		"Intentaste unirte a: " .. nombre
	)
end

-- Crear items
for _, texto in ipairs(textos) do
	local ItemFrame = Instance.new("Frame")
	ItemFrame.Size = UDim2.new(1, -10, 0, 60)
	ItemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	ItemFrame.BorderSizePixel = 0
	ItemFrame.Parent = ScrollFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.6, 0, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = texto
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ItemFrame

	local JoinButton = Instance.new("TextButton")
	JoinButton.Size = UDim2.new(0, 100, 0, 35)
	JoinButton.Position = UDim2.new(1, -110, 0.5, -17)
	JoinButton.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
	JoinButton.Text = "Join"
	JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	JoinButton.Font = Enum.Font.GothamBold
	JoinButton.TextSize = 14
	JoinButton.Parent = ItemFrame

	JoinButton.MouseButton1Click:Connect(function()
		kickPlayer(texto)
	end)
end

-- Ajustar CanvasSize automáticamente
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)
