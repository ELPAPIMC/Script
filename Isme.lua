--[[
    EJEMPLO COMPLETO DE USO - IS UI LIBRARY
    Demuestra todas las funcionalidades disponibles
]]

-- Cargar la librería (reemplaza con tu método de carga)
local IS = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/LIBRARYS/refs/heads/main/IS.lua"))()
-- O si está en un ModuleScript: local IS = require(script.Parent.ISLibrary)

-- Servicios necesarios para el ejemplo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════
-- CREAR VENTANA PRINCIPAL
-- ═══════════════════════════════════════════════════════════
local Window = IS:CreateWindow({
    Title = "🎮 IS Library - Complete Demo",
    MobileButton = true -- Botón flotante para móvil
})

-- Notificación de bienvenida
IS:Notify("Welcome!", "IS Library loaded successfully!", "success", 4)

-- ═══════════════════════════════════════════════════════════
-- TAB 1: PLAYER MODIFICATIONS
-- ═══════════════════════════════════════════════════════════
local PlayerTab = Window:CreateTab("Player", "rbxassetid://7733674079")

PlayerTab:AddSection("🏃 Movement")

-- Toggle para velocidad
local speedToggle = PlayerTab:AddToggle("Speed Boost", false, function(enabled)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if enabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
            IS:Notify("Speed", "Speed boost enabled!", "success", 2)
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            IS:Notify("Speed", "Speed boost disabled", "info", 2)
        end
    end
end)

-- Slider para velocidad personalizada
local speedValue = PlayerTab:AddSlider("Custom Speed", 16, 200, 16, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- Toggle para salto alto
local jumpToggle = PlayerTab:AddToggle("Jump Power", false, function(enabled)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if enabled then
            LocalPlayer.Character.Humanoid.JumpPower = 100
        else
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
end)

-- Slider para altura de salto
PlayerTab:AddSlider("Jump Height", 50, 200, 50, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

PlayerTab:AddSection("💪 Character Mods")

-- Mini Toggle para fly
local flyEnabled = false
PlayerTab:AddMiniToggle("Fly Mode", false, function(enabled)
    flyEnabled = enabled
    if enabled then
        IS:Notify("Fly", "Fly mode activated! Use Space/Shift", "info", 3)
        -- Aquí iría el código de fly
    else
        IS:Notify("Fly", "Fly mode deactivated", "warning", 2)
    end
end)

-- Mini Toggle para noclip
PlayerTab:AddMiniToggle("NoClip", false, function(enabled)
    if enabled then
        IS:Notify("NoClip", "NoClip enabled!", "success", 2)
    else
        IS:Notify("NoClip", "NoClip disabled", "info", 2)
    end
end)

-- Mini Toggle para infinite jump
PlayerTab:AddMiniToggle("Infinite Jump", false, function(enabled)
    -- Código de infinite jump aquí
end)

-- Botón para resetear personaje
PlayerTab:AddButton("Reset Character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
        IS:Notify("Reset", "Character reset!", "warning", 2)
    end
end)

-- Botón para teletransporte a spawn
PlayerTab:AddButton("Teleport to Spawn", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        IS:Notify("Teleport", "Teleported to spawn!", "success", 2)
    end
end)

-- Textbox para nombre personalizado
PlayerTab:AddTextbox("Display Name", "Enter your name...", function(text)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        -- Cambiar nombre sobre la cabeza
        IS:Notify("Name Changed", "Display name set to: " .. text, "info", 2)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 2: COMBAT & WEAPONS
-- ═══════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", "rbxassetid://7733954760")

CombatTab:AddSection("⚔️ Combat Features")

-- Toggle para aimbot
local aimbotToggle = CombatTab:AddToggle("Aimbot", false, function(enabled)
    if enabled then
        IS:Notify("Aimbot", "Aimbot activated!", "success", 2)
    else
        IS:Notify("Aimbot", "Aimbot deactivated", "info", 2)
    end
end)

-- Slider para FOV del aimbot
CombatTab:AddSlider("Aimbot FOV", 50, 500, 200, function(value)
    print("Aimbot FOV set to:", value)
end)

-- Toggle para ESP
local espToggle = CombatTab:AddToggle("ESP (Wallhack)", false, function(enabled)
    if enabled then
        IS:Notify("ESP", "ESP enabled! Players visible through walls", "success", 3)
    else
        IS:Notify("ESP", "ESP disabled", "info", 2)
    end
end)

-- Dropdown para tipo de ESP
CombatTab:AddDropdown("ESP Type", {
    "Box",
    "Name",
    "Health",
    "Distance",
    "Skeleton"
}, true, {"Box", "Name"}, function(selected)
    print("ESP Types selected:", table.concat(selected, ", "))
    IS:Notify("ESP Config", "Selected: " .. table.concat(selected, ", "), "info", 2)
end)

CombatTab:AddSection("🔫 Weapon Mods")

-- Toggle para infinite ammo
CombatTab:AddMiniToggle("Infinite Ammo", false, function(enabled)
    if enabled then
        IS:Notify("Ammo", "Infinite ammo enabled!", "success", 2)
    end
end)

-- Toggle para no recoil
CombatTab:AddMiniToggle("No Recoil", false, function(enabled)
    -- Código de no recoil
end)

-- Toggle para rapid fire
CombatTab:AddMiniToggle("Rapid Fire", false, function(enabled)
    -- Código de rapid fire
end)

-- Dropdown para seleccionar arma
CombatTab:AddDropdown("Select Weapon", {
    "Pistol",
    "Rifle",
    "Shotgun",
    "Sniper",
    "Rocket Launcher"
}, false, nil, function(selected)
    IS:Notify("Weapon", "Selected: " .. tostring(selected), "info", 2)
end)

-- Slider para daño de arma
CombatTab:AddSlider("Weapon Damage", 10, 100, 25, function(value)
    print("Weapon damage:", value)
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 3: VISUAL & UI
-- ═══════════════════════════════════════════════════════════
local VisualTab = Window:CreateTab("Visual", "rbxassetid://7733919505")

VisualTab:AddSection("👁️ Visual Effects")

-- Toggle para fullbright
VisualTab:AddToggle("FullBright", false, function(enabled)
    local Lighting = game:GetService("Lighting")
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        IS:Notify("Visual", "FullBright enabled!", "success", 2)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        IS:Notify("Visual", "FullBright disabled", "info", 2)
    end
end)

-- Slider para hora del día
VisualTab:AddSlider("Time of Day", 0, 24, 12, function(value)
    game:GetService("Lighting").ClockTime = value
end)

-- Toggle para eliminar fog
VisualTab:AddMiniToggle("Remove Fog", false, function(enabled)
    local Lighting = game:GetService("Lighting")
    if enabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 500
    end
end)

VisualTab:AddSection("🎨 UI Customization")

-- Dropdown para tema de colores
VisualTab:AddDropdown("Color Theme", {
    "Blue (Default)",
    "Red",
    "Green",
    "Purple",
    "Orange"
}, false, "Blue (Default)", function(selected)
    IS:Notify("Theme", "Theme changed to: " .. selected, "info", 2)
    -- Aquí cambiarías los colores de la UI
end)

-- Slider para transparencia de la UI
VisualTab:AddSlider("UI Transparency", 0, 90, 0, function(value)
    print("UI Transparency:", value)
    -- Aplicar transparencia a MainFrame
end)

-- Toggle para animaciones
VisualTab:AddToggle("Smooth Animations", true, function(enabled)
    -- Activar/desactivar animaciones
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 4: TELEPORTS
-- ═══════════════════════════════════════════════════════════
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://7733920644")

TeleportTab:AddSection("🌍 Locations")

-- Textbox para coordenadas X
local coordX = TeleportTab:AddTextbox("Coordinate X", "0", function(text) end)

-- Textbox para coordenadas Y
local coordY = TeleportTab:AddTextbox("Coordinate Y", "50", function(text) end)

-- Textbox para coordenadas Z
local coordZ = TeleportTab:AddTextbox("Coordinate Z", "0", function(text) end)

-- Botón para teletransportarse a coordenadas
TeleportTab:AddButton("Teleport to Coordinates", function()
    local x = tonumber(coordX:GetValue()) or 0
    local y = tonumber(coordY:GetValue()) or 50
    local z = tonumber(coordZ:GetValue()) or 0
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        IS:Notify("Teleport", string.format("Teleported to (%.0f, %.0f, %.0f)", x, y, z), "success", 3)
    end
end)

TeleportTab:AddSection("📍 Quick Teleports")

-- Dropdown para ubicaciones predefinidas
TeleportTab:AddDropdown("Quick Locations", {
    "Spawn",
    "Shop",
    "Arena",
    "Secret Area",
    "Boss Room"
}, false, nil, function(selected)
    local locations = {
        ["Spawn"] = Vector3.new(0, 50, 0),
        ["Shop"] = Vector3.new(100, 50, 100),
        ["Arena"] = Vector3.new(-100, 50, -100),
        ["Secret Area"] = Vector3.new(500, 100, 500),
        ["Boss Room"] = Vector3.new(-500, 50, -500)
    }
    
    local pos = locations[selected]
    if pos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        IS:Notify("Teleport", "Teleported to " .. selected, "success", 2)
    end
end)

-- Botón para teleportarse a jugador aleatorio
TeleportTab:AddButton("Teleport to Random Player", function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            IS:Notify("Teleport", "Teleported to " .. randomPlayer.Name, "success", 2)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 5: MISCELLANEOUS
-- ═══════════════════════════════════════════════════════════
local MiscTab = Window:CreateTab("Misc", "rbxassetid://7733920644")

MiscTab:AddSection("🎮 Game Features")

-- Toggle para auto farm
local autoFarmToggle = MiscTab:AddToggle("Auto Farm", false, function(enabled)
    if enabled then
        IS:Notify("Auto Farm", "Auto farm started!", "success", 2)
        -- Loop de auto farm aquí
    else
        IS:Notify("Auto Farm", "Auto farm stopped", "warning", 2)
    end
end)

-- Slider para velocidad de farm
MiscTab:AddSlider("Farm Speed", 1, 10, 5, function(value)
    print("Farm speed:", value)
end)

-- Toggle para auto collect
MiscTab:AddMiniToggle("Auto Collect Coins", false, function(enabled)
    -- Código de auto collect
end)

-- Toggle para anti-afk
MiscTab:AddMiniToggle("Anti-AFK", false, function(enabled)
    if enabled then
        IS:Notify("Anti-AFK", "Anti-AFK enabled!", "success", 2)
    end
end)

MiscTab:AddSection("💬 Chat & Social")

-- Textbox para mensaje personalizado
local chatMessage = MiscTab:AddTextbox("Chat Message", "Hello World!", function(text) end)

-- Botón para enviar mensaje
MiscTab:AddButton("Send Chat Message", function()
    local msg = chatMessage:GetValue()
    if msg and msg ~= "" then
        -- game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        IS:Notify("Chat", "Message sent: " .. msg, "info", 2)
    end
end)

-- Dropdown para spam de mensajes
MiscTab:AddDropdown("Spam Messages", {
    "gg",
    "easy",
    "too ez",
    "noob",
    "pro player here"
}, false, nil, function(selected)
    IS:Notify("Spam", "Spamming: " .. selected, "warning", 2)
end)

MiscTab:AddSection("⚙️ Script Options")

-- Toggle para mostrar FPS
MiscTab:AddToggle("Show FPS Counter", false, function(enabled)
    -- Mostrar contador de FPS
end)

-- Toggle para reducir lag
MiscTab:AddToggle("Reduce Lag", false, function(enabled)
    if enabled then
        -- Optimizaciones
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        IS:Notify("Performance", "Lag reduction enabled", "success", 2)
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        IS:Notify("Performance", "Normal quality restored", "info", 2)
    end
end)

-- Botón para limpiar workspace
MiscTab:AddButton("Clear Workspace", function()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and not obj:IsDescendantOf(LocalPlayer.Character) then
            obj:Destroy()
            count = count + 1
        end
    end
    IS:Notify("Cleanup", "Removed " .. count .. " objects", "success", 2)
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 6: KEYBINDS
-- ═══════════════════════════════════════════════════════════
local KeybindTab = Window:CreateTab("Keybinds", "rbxassetid://7734053495")

KeybindTab:AddSection("⌨️ Keyboard Shortcuts")

-- Keybind para speed boost (vinculado al toggle)
KeybindTab:AddKeybind("Toggle Speed", "R", function()
    print("Speed keybind pressed!")
    IS:Notify("Keybind", "Speed toggled with R key", "info", 2)
end, speedToggle)

-- Keybind para aimbot (vinculado al toggle)
KeybindTab:AddKeybind("Toggle Aimbot", "T", function()
    print("Aimbot keybind pressed!")
end, aimbotToggle)

-- Keybind para ESP (vinculado al toggle)
KeybindTab:AddKeybind("Toggle ESP", "Y", function()
    print("ESP keybind pressed!")
end, espToggle)

-- Keybind para fly
KeybindTab:AddKeybind("Toggle Fly", "F", function()
    IS:Notify("Keybind", "Fly toggled with F key", "info", 2)
end)

-- Keybind para teleport spawn
KeybindTab:AddKeybind("Teleport Spawn", "H", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        IS:Notify("Keybind", "Teleported to spawn!", "success", 2)
    end
end)

-- Keybind para mostrar/ocultar UI
KeybindTab:AddKeybind("Toggle UI", "RightShift", function()
    IS:Notify("Keybind", "UI visibility toggled", "info", 1)
    -- El toggle de UI se maneja automáticamente
end)

KeybindTab:AddSection("ℹ️ Instructions")

-- Botón de ayuda
KeybindTab:AddButton("How to use Keybinds", function()
    IS:Notify(
        "Keybinds Help",
        "Click on a keybind button, then press any key to bind it. Press the key to activate the function!",
        "info",
        5
    )
end)

-- ═══════════════════════════════════════════════════════════
-- TAB 7: CREDITS & INFO
-- ═══════════════════════════════════════════════════════════
local CreditsTab = Window:CreateTab("Credits", "rbxassetid://7733955511")

CreditsTab:AddSection("📝 Script Information")

-- Botón para mostrar versión
CreditsTab:AddButton("Script Version", function()
    IS:Notify("Version", "IS Library v1.0 - Full Demo", "info", 3)
end)

-- Botón para Discord
CreditsTab:AddButton("Join Discord", function()
    IS:Notify("Discord", "Discord link copied to clipboard!", "success", 3)
    -- setclipboard("https://discord.gg/yourserver")
end)

-- Botón para GitHub
CreditsTab:AddButton("GitHub Repository", function()
    IS:Notify("GitHub", "GitHub link copied to clipboard!", "success", 3)
end)

CreditsTab:AddSection("👥 Credits")

-- Botón de créditos
CreditsTab:AddButton("Developer", function()
    IS:Notify("Credits", "Created by: YourName", "info", 3)
end)

CreditsTab:AddButton("UI Library", function()
    IS:Notify("Credits", "IS UI Library - Made with ❤️", "success", 3)
end)

CreditsTab:AddSection("⚠️ Disclaimer")

-- Botones informativos
CreditsTab:AddButton("Terms of Use", function()
    IS:Notify(
        "Terms",
        "Use at your own risk. We are not responsible for bans or account issues.",
        "warning",
        5
    )
end)

CreditsTab:AddButton("Report Bugs", function()
    IS:Notify("Support", "Report bugs on our Discord server!", "info", 3)
end)

-- ═══════════════════════════════════════════════════════════
-- CREAR TAB DE SETTINGS (AUTOMÁTICO)
-- ═══════════════════════════════════════════════════════════
Window:CreateSettingsTab()

-- ═══════════════════════════════════════════════════════════
-- NOTIFICACIONES DE DEMOSTRACIÓN
-- ═══════════════════════════════════════════════════════════
wait(1)
IS:Notify("Demo Script", "All features loaded successfully!", "success", 3)

wait(2)
IS:Notify("Tip", "Try the Settings tab to save your configuration!", "info", 4)

wait(3)
IS:Notify("Reminder", "Use keybinds for quick access to features", "warning", 3)

-- ═══════════════════════════════════════════════════════════
-- EJEMPLO DE AUTO-GUARDADO
-- ═══════════════════════════════════════════════════════════
spawn(function()
    while wait(60) do -- Auto-guardar cada 60 segundos
        -- Aquí podrías implementar auto-save si lo deseas
        print("Auto-save checkpoint")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- ═══════════════════════════════════════════════════════════
print("═══════════════════════════════════════════════════════")
print("IS UI LIBRARY - COMPLETE DEMO LOADED")
print("All features and components demonstrated")
print("═══════════════════════════════════════════════════════")
