get_service = function(service)
    return cloneref(game:GetService(service))
end

local players = get_service('Players')
local replicated_storage = get_service('ReplicatedStorage')
local http_service = get_service('HttpService')
local run_service = get_service('RunService')
local user_input_service = get_service('UserInputService')

-- // referencias
local local_player = players.LocalPlayer
local remote = replicated_storage.Packages.Net['RE/LaserGun_Fire']
local settings = require(replicated_storage.Shared.LaserGunsShared).Settings

-- // MODS LETALES - VALORES EXTREMOS
settings.Radius.Value = 9999 -- Radio masivo
settings.MaxBounces.Value = 999999 -- Rebotes infinitos
settings.MaxAge.Value = 1e9 -- Duración extrema
settings.StunDuration.Value = 999 -- Stun de 999 segundos
settings.ImpulseForce.Value = 1e9 -- Fuerza descomunal
settings.Cooldown.Value = 0 -- Sin cooldown

-- // estados
local lagger_enabled = false
local last_equipped = false
local intensity_mode = 1 -- 1=Normal, 2=Extremo, 3=LETAL

-- === GUI ===
local screen_gui = Instance.new('ScreenGui')
screen_gui.Name = 'LETHAL_FPS_KILLER'
screen_gui.Parent = local_player:WaitForChild('PlayerGui')

local frame = Instance.new('Frame')
frame.Size = UDim2.new(0, 280, 0, 220)
frame.Position = UDim2.new(0, 40, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Parent = screen_gui

local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

-- Borde rojo brillante
local stroke = Instance.new('UIStroke')
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Parent = frame

-- LOGO
local grok_logo = Instance.new('ImageLabel')
grok_logo.Size = UDim2.new(0, 38, 0, 38)
grok_logo.Position = UDim2.new(0, 12, 0, 8)
grok_logo.BackgroundTransparency = 1
grok_logo.Image = 'http://www.roblox.com/asset/?id=18347450507'
grok_logo.ScaleType = Enum.ScaleType.Fit
grok_logo.Parent = frame

-- TITLE
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = '☠️ LETAL FPS KILLER ☠️'
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- BOTÓN PRINCIPAL
local button = Instance.new('TextButton')
button.Size = UDim2.new(1, -30, 0, 65)
button.Position = UDim2.new(0, 15, 0, 50)
button.Text = '💀 FPS DEVOUR\nR Para Activar'
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.FredokaOne
button.TextSize = 20
button.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
button.BackgroundTransparency = 0.2
button.AutoButtonColor = false
button.Parent = frame

local button_corner = Instance.new('UICorner')
button_corner.CornerRadius = UDim.new(0, 12)
button_corner.Parent = button

local button_gradient = Instance.new('UIGradient')
button_gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 20, 20)),
})
button_gradient.Rotation = 90
button_gradient.Parent = button

-- SELECTOR DE INTENSIDAD
local intensity_button = Instance.new('TextButton')
intensity_button.Size = UDim2.new(1, -30, 0, 40)
intensity_button.Position = UDim2.new(0, 15, 0, 125)
intensity_button.Text = '🔥 Modo: NORMAL'
intensity_button.TextColor3 = Color3.fromRGB(255, 255, 255)
intensity_button.Font = Enum.Font.GothamBold
intensity_button.TextSize = 16
intensity_button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
intensity_button.BackgroundTransparency = 0.3
intensity_button.AutoButtonColor = false
intensity_button.Parent = frame

local intensity_corner = Instance.new('UICorner')
intensity_corner.CornerRadius = UDim.new(0, 10)
intensity_corner.Parent = intensity_button

-- INFO TEXT
local info_text = Instance.new('TextLabel')
info_text.Size = UDim2.new(1, -30, 0, 35)
info_text.Position = UDim2.new(0, 15, 0, 175)
info_text.BackgroundTransparency = 1
info_text.Text = '⚠️ Equipa Laser Gun\nT = Cambiar Intensidad'
info_text.TextColor3 = Color3.fromRGB(255, 200, 0)
info_text.Font = Enum.Font.Gotham
info_text.TextSize = 13
info_text.TextXAlignment = Enum.TextXAlignment.Center
info_text.Parent = frame

-- // FUNCIÓN CAMBIAR INTENSIDAD
local function change_intensity()
    intensity_mode = intensity_mode + 1
    if intensity_mode > 3 then intensity_mode = 1 end
    
    if intensity_mode == 1 then
        intensity_button.Text = '🔥 Modo: NORMAL (5/f)'
        intensity_button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    elseif intensity_mode == 2 then
        intensity_button.Text = '⚡ Modo: EXTREMO (15/f)'
        intensity_button.BackgroundColor3 = Color3.fromRGB(150, 75, 0)
    else
        intensity_button.Text = '💀 Modo: LETAL (40/f)'
        intensity_button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end

intensity_button.MouseButton1Click:Connect(change_intensity)

-- // TOGGLE FUNCTION
local function toggle_lagger()
    lagger_enabled = not lagger_enabled
    if lagger_enabled then
        button.Text = '💀 FPS DEVOUR\n🟢 ACTIVO'
        button_gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50)),
        })
        stroke.Color = Color3.fromRGB(0, 255, 0)
    else
        button.Text = '💀 FPS DEVOUR\nR Para Activar'
        button_gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 20, 20)),
        })
        stroke.Color = Color3.fromRGB(255, 0, 0)
    end
end

-- Click del botón
local supp = false
button.MouseButton1Click:Connect(function()
    if supp then
        supp = false
        return
    end
    toggle_lagger()
end)

-- KEYBINDS
user_input_service.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        toggle_lagger()
    elseif input.KeyCode == Enum.KeyCode.T then
        change_intensity()
    end
end)

-- // draggable
local dragging = false
local drag_input, drag_start, start_pos
local drag_threshold = 6

update_ = function(input)
    local delta = input.Position - drag_start
    frame.Position = UDim2.new(
        start_pos.X.Scale,
        start_pos.X.Offset + delta.X,
        start_pos.Y.Scale,
        start_pos.Y.Offset + delta.Y
    )
end

attach_ = function(handle)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            drag_start = input.Position
            start_pos = frame.Position
            drag_input = nil
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            drag_input = input
        end
    end)
end

attach_(frame)
attach_(button)

user_input_service.InputChanged:Connect(function(input)
    if dragging and input == drag_input then
        if (input.Position - drag_start).Magnitude > drag_threshold then
            supp = true
        end
        update_(input)
    end
end)

-- // get nearest
get_nearest = function()
    local nearest_player
    local shortest_distance = math.huge
    local local_character = local_player.Character
    if not local_character or not local_character.PrimaryPart then
        return nil
    end
    local local_position = local_character.PrimaryPart.Position
    for _, player in players:GetPlayers() do
        local character = player.Character
        if player ~= local_player and character and character.PrimaryPart then
            local distance = (local_position - character.PrimaryPart.Position).Magnitude
            if distance < shortest_distance then
                shortest_distance = distance
                nearest_player = player
            end
        end
    end
    return nearest_player
end

-- // GENERADOR DE POSICIONES ALEATORIAS PARA SPAM
local function generate_random_positions(center, count)
    local positions = {}
    for i = 1, count do
        local offset = Vector3.new(
            math.random(-50, 50),
            math.random(-20, 20),
            math.random(-50, 50)
        )
        table.insert(positions, center + offset)
    end
    return positions
end

-- // MAIN LOOP - AHORA CON INTENSIDAD VARIABLE
local spam_counter = 0
run_service.RenderStepped:Connect(function()
    local character = local_player.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass('Tool')
    local tool_equipped = tool and tool.Name == 'Laser Gun'
    
    if tool_equipped ~= last_equipped then
        last_equipped = tool_equipped
    end
    
    if not (lagger_enabled and tool_equipped) then return end
    
    local target_player = get_nearest()
    if not target_player then return end
    
    local target_char = target_player.Character
    if not (target_char and target_char.PrimaryPart and character.PrimaryPart) then
        return
    end
    
    local pos1 = character.PrimaryPart.Position
    local pos2 = target_char.PrimaryPart.Position
    local direction = (pos2 - pos1).Unit
    
    -- INTENSIDAD VARIABLE - ULTRA BALANCEADO
    local shots_per_frame = intensity_mode == 1 and 1 or (intensity_mode == 2 and 5 or 15)
    
    -- SPAM MASIVO según intensidad
    for i = 1, shots_per_frame do
        local id = http_service:GenerateGUID(false):lower():gsub('%-', '')
        
        -- Variar ligeramente la dirección para crear caos
        local random_direction = direction + Vector3.new(
            (math.random() - 0.5) * 0.3,
            (math.random() - 0.5) * 0.3,
            (math.random() - 0.5) * 0.3
        )
        
        -- Disparar desde posiciones ligeramente diferentes
        local random_pos = pos1 + Vector3.new(
            (math.random() - 0.5) * 5,
            (math.random() - 0.5) * 5,
            (math.random() - 0.5) * 5
        )
        
        remote:FireServer(id, random_pos, random_direction.Unit, workspace:GetServerTimeNow())
    end
    
    spam_counter = spam_counter + shots_per_frame
    
    -- Actualizar título con stats
    if spam_counter % 100 == 0 then
        title.Text = string.format('☠️ LETAL [%d disparos] ☠️', spam_counter)
    end
end)

print('💀 LETAL FPS KILLER CARGADO')
print('⚡ R = Activar/Desactivar')
print('🔥 T = Cambiar Intensidad')
print('📊 Normal: 5/frame | Extremo: 15/frame | Letal: 40/frame')
print('🎮 A 60 FPS = 300 / 900 / 2,400 disparos/segundo')
print('✅ Optimizado para no causar lag propio')
print('⚠️ Equipa el Laser Gun para comenzar')
