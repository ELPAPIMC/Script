local IS = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/LIBRARYS/refs/heads/main/IS.lua"))()

-- Crear ventana
local Window = IS:CreateWindow({
    Title = "SAB PVP UTILIES",
    MobileButton = true
})

-- Crear tabs
local MainTab = Window:CreateTab("Main", "main")
local CombatTab = Window:CreateTab("Combat", "sword")

-- Agregar componentes
MainTab:AddSection("⚡ Features")

local toggle = MainTab:AddToggle("Speed Boost", false, function(val)
    print("Speed:", val)
end)

MainTab:AddSlider("WalkSpeed", 16, 100, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

MainTab:AddKeybind("Toggle Speed", "R", function()
    print("Keybind pressed!")
end, toggle)

MainTab:AddDropdown("Weapons", {"Bat", "???", "???"}, true, {}, function(val)
    print("Selected:", val)
end)

local Aimbot = MainTab:AddToggle("Aimbot", false, function()
	--Logica
end)

-- Notificaciones
IS:Notify("Welcome!", "Script loaded successfully", "success", 3)

-- Tab de Settings se crea automáticamente
Window:CreateSettingsTab()
