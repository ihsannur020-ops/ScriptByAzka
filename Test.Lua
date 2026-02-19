-- Script UI untuk Semua Executor
-- GUI: Jump to Steal Brainrots (Perbaikan Deteksi Radius)

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local guiName = "JumpToStealBrainrots_ByAzka"
local displayName = "Jump to Steal Brainrots"

-- Hapus GUI lama jika ada
pcall(function() coreGui:FindFirstChild(guiName):Destroy() end)

-- ==================================================
-- 2. MEMBUAT ELEMEN DASAR GUI (Sama seperti sebelumnya)
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = displayName
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0, 5)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

-- ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -55)
scrollingFrame.Position = UDim2.new(0, 10, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Parent = scrollingFrame
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0, 10)

-- Container
local function createContainer(name)
    local container = Instance.new("Frame")
    container.Name = name
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = scrollingFrame
    container.AutomaticSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    return container
end

local slideContainer = createContainer("SlideContainer")
local buttonContainer = createContainer("ButtonContainer")
local checkboxContainer = createContainer("CheckboxContainer")

-- ==================================================
-- 3. FUNGSI UI (Sama seperti sebelumnya)
-- ==================================================
local UI = {}

function UI.AddSlider(config)
    -- (kode slider tidak diubah, sama seperti sebelumnya)
    -- ... (saya akan menyingkat untuk kejelasan, tetapi dalam implementasi sebenarnya tetap sama)
end

function UI.AddButton(config)
    -- (sama)
end

function UI.AddCheckbox(config)
    -- (sama)
end

-- ==================================================
-- 4. MINIMIZED FRAME (Sama)
-- ==================================================
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Size = UDim2.new(0, 50, 0, 50)
minimizedFrame.Position = UDim2.new(1, -70, 1, -70)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizedFrame.BorderSizePixel = 1
minimizedFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
minimizedFrame.Active = true
minimizedFrame.Visible = false
minimizedFrame.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 10)
miniCorner.Parent = minimizedFrame

local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Text = "+"
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.TextSize = 24
miniLabel.Font = Enum.Font.GothamBold
miniLabel.Parent = minimizedFrame

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(1, 0, 1, 0)
miniButton.BackgroundTransparency = 1
miniButton.Text = ""
miniButton.Parent = minimizedFrame

-- Drag logic (sama)
-- ... (saya singkat)

-- ==================================================
-- 5. MINIMIZE DAN CLOSE
-- ==================================================
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================================================
-- 6. INISIALISASI PLOTPLAYER
-- ==================================================
local PlotPlayer = nil
local function getBaseId()
    return localPlayer:GetAttribute("BaseId")
end

local baseMapping = {
    ["Base 1"] = "Base 1",
    ["Base 2"] = "Base 2",
    ["Base 3"] = "Base 3",
    ["Base 4"] = "Base 4",
    ["Base 5"] = "Base 5",
}

local baseId = getBaseId()
if baseId and baseMapping[baseId] then
    PlotPlayer = baseMapping[baseId]
else
    PlotPlayer = "Base 1"
    warn("BaseId tidak ditemukan, menggunakan default Base 1")
end

_G.PlotPlayer = PlotPlayer

local baseCoordinates = {
    ["Base 1"] = Vector3.new(-13.896, 5, -120.056),
    ["Base 2"] = Vector3.new(-14.193, 5, -60.192),
    ["Base 3"] = Vector3.new(-13.609, 5, -0.075),
    ["Base 4"] = Vector3.new(-13.91, 5, 59.939),
    ["Base 5"] = Vector3.new(-13.907, 5, 119.951),
}

local intermediatePos = Vector3.new(56.818, 3.935, 31.258)

-- ==================================================
-- 7. FUNGSI TELEPORT
-- ==================================================
local function teleportTo(position)
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    else
        localPlayer.CharacterAdded:Wait()
        teleportTo(position)
    end
end

-- ==================================================
-- 8. TOMBOL
-- ==================================================
UI.AddButton({
    Text = "VIP",
    Callback = function()
        local vipZones = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Walls") and workspace.Map.Walls:FindFirstChild("VIPsZones")
        if vipZones then
            for i = 1, 7 do
                local zone = vipZones:FindFirstChild(tostring(i))
                if zone then
                    local scriptedPart = zone:FindFirstChild("ScriptedPart")
                    if scriptedPart then scriptedPart:Destroy() end
                end
            end
        end
    end
})

UI.AddButton({
    Text = "Go To Home",
    Callback = function()
        if PlotPlayer and baseCoordinates[PlotPlayer] then
            teleportTo(baseCoordinates[PlotPlayer])
        end
    end
})

UI.AddButton({
    Text = "Go To Sell",
    Callback = function()
        teleportTo(Vector3.new(42.287, 4, 139.483))
    end
})

UI.AddButton({
    Text = "Go To Jump",
    Callback = function()
        teleportTo(Vector3.new(42.96, 3.915, 1.243))
    end
})

-- ==================================================
-- 9. SLIDER JUMP POWER
-- ==================================================
_G.JumpPower = 100
UI.AddSlider({
    Text = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 100,
    Callback = function(val)
        val = math.floor(val)
        _G.JumpPower = val
        local char = localPlayer.Character
        if char then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then humanoid.JumpPower = val end
        end
    end
})

-- ==================================================
-- 10. AUTO FITUR DENGAN DETEKSI RADIUS YANG BENAR
-- ==================================================
math.randomseed(os.time())

local autoSecretEnabled = false
local autoGodEnabled = false
local autoCelestialEnabled = false
local infJumpEnabled = false
local collectCashEnabled = false

-- Fungsi mendapatkan model dari zone
local function getModelsFromZones(zones)
    local models = {}
    for _, zoneName in ipairs(zones) do
        local zone = workspace:FindFirstChild("Zones") and workspace.Zones:FindFirstChild(zoneName)
        if zone then
            for _, child in ipairs(zone:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChild("RootPart") then
                    table.insert(models, child)
                end
            end
        end
    end
    return models
end

-- Fungsi cek apakah ada pemain lain dalam radius tertentu dari posisi model
local function isPlayerNearby(model, radius)
    radius = radius or 3
    -- Dapatkan posisi model dari RootPart
    local rootPart = model:FindFirstChild("RootPart")
    if not rootPart then return false end
    local modelPos = rootPart.Position

    -- Loop semua pemain kecuali localPlayer
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - modelPos).Magnitude
                    if dist <= radius then
                        return true  -- ada pemain lain di dekat model
                    end
                end
            end
        end
    end
    return false
end

-- Fungsi mencari model yang tersedia (tidak ada pemain di dekatnya)
local function findAvailableModel(models)
    if #models == 0 then return nil end
    -- Acak urutan agar tidak selalu model yang sama
    local shuffled = {}
    for i, v in ipairs(models) do shuffled[i] = v end
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    -- Cari model pertama yang tidak memiliki pemain di dekatnya
    for _, model in ipairs(shuffled) do
        if not isPlayerNearby(model) then
            return model
        end
    end
    return nil  -- semua model memiliki pemain di dekatnya
end

-- Fungsi interaksi dengan brainrot
local function interactWithBrainrot(brainrotModel)
    if not brainrotModel then return false end
    local holdDuration = 0.25
    
    -- Cari ProximityPrompt di RootPart.CollectPrompt
    local rootPart = brainrotModel:FindFirstChild("RootPart")
    if rootPart then
        local prompt = rootPart:FindFirstChild("CollectPrompt")
        if prompt and prompt:IsA("ProximityPrompt") then
            prompt:InputHoldBegin()
            wait(holdDuration)
            prompt:InputHoldEnd()
            return true
        end
    end
    
    -- Coba ClickDetector
    local clickDetector = brainrotModel:FindFirstChildWhichIsA("ClickDetector", true)
    if clickDetector then
        if fireclickdetector then
            fireclickdetector(clickDetector)
            return true
        else
            warn("fireclickdetector tidak tersedia")
        end
    end
    return false
end

-- Loop utama prioritas (hanya satu model per siklus)
coroutine.wrap(function()
    while true do
        if autoCelestialEnabled or autoGodEnabled or autoSecretEnabled then
            local targetModel = nil

            -- Prioritas 1: Celestial
            if autoCelestialEnabled then
                local models = getModelsFromZones({"Zone16", "Zone15"})
                targetModel = findAvailableModel(models)
            end

            -- Prioritas 2: God
            if not targetModel and autoGodEnabled then
                local models = getModelsFromZones({"Zone14", "Zone13"})
                targetModel = findAvailableModel(models)
            end

            -- Prioritas 3: Secret
            if not targetModel and autoSecretEnabled then
                local models = getModelsFromZones({"Zone12", "Zone11"})
                targetModel = findAvailableModel(models)
            end

            if targetModel then
                local rootPart = targetModel:FindFirstChild("RootPart")
                if rootPart then
                    teleportTo(rootPart.Position)
                    wait(0.5)  -- tunggu sebentar agar posisi stabil
                    local success = interactWithBrainrot(targetModel)
                    if success then
                        wait(0.25)  -- jeda setelah interaksi
                        teleportTo(intermediatePos)
                        wait(0.1)
                        if PlotPlayer and baseCoordinates[PlotPlayer] then
                            teleportTo(baseCoordinates[PlotPlayer])
                        end
                    end
                end
                wait(1)  -- tunggu 1 detik sebelum siklus berikutnya
            else
                wait(2)  -- tidak ada target, tunggu lebih lama
            end
        else
            wait(1)
        end
    end
end)()

UI.AddCheckbox({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state) autoSecretEnabled = state end
})

UI.AddCheckbox({
    Text = "Auto God",
    Default = false,
    Callback = function(state) autoGodEnabled = state end
})

UI.AddCheckbox({
    Text = "Auto Celestial",
    Default = false,
    Callback = function(state) autoCelestialEnabled = state end
})

-- ==================================================
-- 11. INFINITE JUMP
-- ==================================================
local function setupInfiniteJump(enabled)
    if enabled then
        local jumpConnection
        jumpConnection = userInput.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local char = localPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
        _G.InfJumpConnection = jumpConnection
    else
        if _G.InfJumpConnection then
            _G.InfJumpConnection:Disconnect()
            _G.InfJumpConnection = nil
        end
    end
end

UI.AddCheckbox({
    Text = "INF Jump",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
        setupInfiniteJump(state)
    end
})

-- ==================================================
-- 12. COLLECT CASH (Fire TouchTransmitter)
-- ==================================================
coroutine.wrap(function()
    while true do
        if collectCashEnabled and PlotPlayer then
            local base = workspace:FindFirstChild("Bases") and workspace.Bases:FindFirstChild(PlotPlayer)
            if base then
                local spots = base:FindFirstChild("Spots")
                if spots then
                    for i = 1, 30 do
                        local spot = spots:FindFirstChild(tostring(i))
                        if spot then
                            local button = spot:FindFirstChild("Button")
                            if button then
                                local hitbox = button:FindFirstChild("ButtonHitbox")
                                if hitbox then
                                    local touchTransmitter = hitbox:FindFirstChildWhichIsA("TouchTransmitter")
                                    if touchTransmitter then
                                        touchTransmitter:Fire()
                                        wait(0.05)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(10)
    end
end)()

UI.AddCheckbox({
    Text = "Collect Cash",
    Default = false,
    Callback = function(state) collectCashEnabled = state end
})

-- ==================================================
-- 13. EXPOSE KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("=== GUI [Jump to Steal Brainrots] Dimuat ===")
print("PlotPlayer:", PlotPlayer)
print("Deteksi radius pemain menggunakan player.Character.HumanoidRootPart")
