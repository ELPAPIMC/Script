-- ZL Finder GUI - LocalScript

local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ZL Finder GUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "ZL Auto Joiner"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = main

-- ScrollingFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = scroll

-- Textos falsos
local fakeTexts = {
	"La Grande Combi",
	"Garama",
	"Dragon",
	"Mewol"
	"Lavadoritp,
}

-- Crear entradas
for i = 1, 10 do
	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -10, 0, 40)
	entry.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	entry.Parent = scroll

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(0.7, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Text = fakeTexts[math.random(#fakeTexts)]
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.Font = Enum.Font.Gotham
	text.TextSize = 14
	text.Parent = entry

	local join = Instance.new("TextButton")
	join.Size = UDim2.new(0.3, -5, 0.8, 0)
	join.Position = UDim2.new(0.7, 5, 0.1, 0)
	join.Text = "Join"
	join.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	join.TextColor3 = Color3.fromRGB(255, 255, 255)
	join.Font = Enum.Font.GothamBold
	join.TextSize = 14
	join.Parent = entry

	join.MouseButton1Click:Connect(function()
		player:Kick("😂 ZL no existe bro\nGracias por intentar auto-join 😭")
	end)
end

-- Ajustar scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
