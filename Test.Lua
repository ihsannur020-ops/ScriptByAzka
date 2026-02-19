-- Script UI untuk Semua Executor
-- GUI: Jump to Steal Brainrots (Versi Stabil + Collect Cash via TouchTransmitter)

-- ==================================================
-- 1. KONFIGURASI AWAL (Kompatibel Semua Executor)
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local guiName = "JumpToStealBrainrots_ByAzka"
local displayName = "Jump to Steal Brainrots"

-- Hapus GUI lama jika ada
pcall(function() coreGui:FindFirstChild(guiName):Destroy() end)

-- ==================================================
-- 2. MEMBUAT ELEMEN DASAR GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama (dapat digeser)
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

-- Sudut melengkung
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Judul UI
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

-- Tombol Minimize
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

-- Tombol Close
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

-- ==================================================
-- 3. SCROLLING FRAME UNTUK KONTEN
-- ==================================================
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

-- Layout vertikal
local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Parent = scrollingFrame
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0, 10)

-- ==================================================
-- 4. MEMBUAT KONTAINER
-- ==================================================
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
-- 5. FUNGSI-FUNGSI UNTUK MENAMBAH ELEMEN
-- ==================================================
local UI = {}

function UI.AddSlider(config)
    local container = slideContainer
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or (min + max) / 2
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 1, -8)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.BorderSizePixel = 0
    track.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new((default - min) / (max - min), -6, 0, -4)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.BorderSizePixel = 0
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 6)
    thumbCorner.Parent = thumb
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = track

    local dragging = false
    thumb.MouseButton1Down:Connect(function()
        dragging = true
    end)

    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    userInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = userInput:GetMouseLocation()
            local trackAbsPos, trackSize = track.AbsolutePosition, track.AbsoluteSize
            local relativeX = math.clamp(mousePos.X - trackAbsPos.X, 0, trackSize.X)
            local percent = relativeX / trackSize.X
            local value = min + (max - min) * percent
            value = math.floor(value)  -- integer
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -6, 0, -4)
            callback(value)
        end
    end)

    return frame
end

function UI.AddButton(config)
    local container = buttonContainer
    local text = config.Text or "Button"
    local callback = config.Callback or function() end

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(callback)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    return button
end

function UI.AddCheckbox(config)
    local container = checkboxContainer
    local text = config.Text or "Checkbox"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0, 24, 0, 24)
    checkBtn.Position = UDim2.new(1, -30, 0.5, -12)
    checkBtn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    checkBtn.Text = ""
    checkBtn.BorderSizePixel = 0
    checkBtn.Parent = frame

    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 4)
    checkCorner.Parent = checkBtn

    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = default and "✓" or ""
    checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkMark.TextSize = 18
    checkMark.Font = Enum.Font.GothamBold
    checkMark.Parent = checkBtn

    local state = default

    local function updateCheck()
        checkBtn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
        checkMark.Text = state and "✓" or ""
    end

    checkBtn.MouseButton1Click:Connect(function()
        state = not state
        updateCheck()
        callback(state)
    end)

    return frame
end

-- ==================================================
-- 6. MINIMIZED FRAME
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

-- Drag untuk minimizedFrame
local dragging = false
local dragStartPos
local frameStartPos
local isDragging = false
local dragThreshold = 5

miniButton.MouseButton1Down:Connect(function()
    dragging = true
    dragStartPos = userInput:GetMouseLocation()
    frameStartPos = minimizedFrame.Position
    isDragging = false
end)

userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local currentPos = userInput:GetMouseLocation()
        local delta = currentPos - dragStartPos
        if not isDragging and (delta.X^2 + delta.Y^2) > dragThreshold^2 then
            isDragging = true
        end
        if isDragging then
            minimizedFrame.Position = UDim2.new(
                frameStartPos.X.Scale,
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale,
                frameStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        if not isDragging then
            minimizedFrame.Visible = false
            mainFrame.Visible = true
        end
        dragging = false
    end
end)

-- ==================================================
-- 7. FUNGSI MINIMIZE DAN CLOSE
-- ==================================================
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================================================
-- 8. INISIALISASI DATA PLOTPLAYER
-- ==================================================
local PlotPlayer = nil
local function getBaseId()
    local baseIdAttr = localPlayer:GetAttribute("BaseId")
    if baseIdAttr and type(baseIdAttr) == "string" then
        return baseIdAttr
    end
    return nil
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
-- 9. FUNGSI TELEPORT (Kompatibel)
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
-- 10. TOMBOL-Tombol
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
                    if scriptedPart then
                        scriptedPart:Destroy()
                    end
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
-- 11. SLIDER JUMP POWER
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
            if humanoid then
                humanoid.JumpPower = val
            end
        end
    end
})

-- ==================================================
-- 12. AUTO FITUR DENGAN PRIORITAS (1 SIKLUS 1 MODEL)
-- ==================================================
math.randomseed(os.time())

local autoSecretEnabled = false
local autoGodEnabled = false
local autoCelestialEnabled = false
local infJumpEnabled = false
local collectCashEnabled = false

-- Fungsi umum
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

local function isPlayerNearby(model, radius)
    radius = radius or 3
    if not model then return false end
    local rootPart = model:FindFirstChild("RootPart")
    if not rootPart then return false end
    local modelPos = rootPart.Position
    
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if (char.HumanoidRootPart.Position - modelPos).Magnitude <= radius then
                    return true
                end
            end
        end
    end
    return false
end

local function findAvailableModel(models)
    if #models == 0 then return nil end
    local shuffled = {}
    for i, v in ipairs(models) do shuffled[i] = v end
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    for _, model in ipairs(shuffled) do
        if not isPlayerNearby(model) then
            return model
        end
    end
    return nil
end

local function interactWithBrainrot(brainrotModel)
    if not brainrotModel then return false end
    local holdDuration = 0.25
    
    -- Cari ProximityPrompt
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
            warn("fireclickdetector tidak tersedia di executor ini")
        end
    end
    return false
end

-- Loop utama prioritas (hanya 1 model per siklus)
coroutine.wrap(function()
    while true do
        if autoCelestialEnabled or autoGodEnabled or autoSecretEnabled then
            local targetModel = nil
            local source = ""

            -- Prioritas 1: Celestial
            if autoCelestialEnabled then
                local models = getModelsFromZones({"Zone16", "Zone15"})
                targetModel = findAvailableModel(models)
                if targetModel then source = "Celestial" end
            end

            -- Prioritas 2: God
            if not targetModel and autoGodEnabled then
                local models = getModelsFromZones({"Zone14", "Zone13"})
                targetModel = findAvailableModel(models)
                if targetModel then source = "God" end
            end

            -- Prioritas 3: Secret
            if not targetModel and autoSecretEnabled then
                local models = getModelsFromZones({"Zone12", "Zone11"})
                targetModel = findAvailableModel(models)
                if targetModel then source = "Secret" end
            end

            if targetModel then
                local rootPart = targetModel:FindFirstChild("RootPart")
                if rootPart then
                    teleportTo(rootPart.Position)
                    wait(0.5)
                    local success = interactWithBrainrot(targetModel)
                    if success then
                        wait(0.25)
                        teleportTo(intermediatePos)
                        wait(0.1)
                        if PlotPlayer and baseCoordinates[PlotPlayer] then
                            teleportTo(baseCoordinates[PlotPlayer])
                        end
                    end
                end
                wait(1)
            else
                wait(2)
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
-- 13. INFINITE JUMP
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
-- 14. COLLECT CASH (Fire TouchTransmitter)
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
                                        wait(0.05)  -- jeda ringan agar tidak overload
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(10)  -- interval 10 detik
    end
end)()

UI.AddCheckbox({
    Text = "Collect Cash",
    Default = false,
    Callback = function(state) collectCashEnabled = state end
})

-- ==================================================
-- 15. EXPOSE KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("=== GUI [Jump to Steal Brainrots] Dimuat ===")
print("PlotPlayer:", PlotPlayer)
print("Gunakan _G['" .. guiName .. "'] untuk akses manual")
