-- Script UI untuk Delta Executor
-- GUI: Jump to Steal Brainrots - Library Version (dengan prioritas auto)

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local teleportService = game:GetService("TeleportService")

local localPlayer = players.LocalPlayer
local guiName = "JumpToStealBrainrots_ByAzka"
local displayName = "Jump to Steal Brainrots"

-- Hapus GUI lama jika ada
if coreGui:FindFirstChild(guiName) then
    coreGui:FindFirstChild(guiName):Destroy()
end

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

-- Buat container
local slideContainer = createContainer("SlideContainer")
local buttonContainer = createContainer("ButtonContainer")
local checkboxContainer = createContainer("CheckboxContainer")  -- Ganti dari switchContainer

-- ==================================================
-- 5. FUNGSI-FUNGSI UNTUK MENAMBAH ELEMEN
-- ==================================================
local UI = {}

-- Fungsi untuk membuat slider (opsional, tetap disediakan)
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
            value = math.floor(value * 100) / 100
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -6, 0, -4)
            callback(value)
        end
    end)

    return frame
end

-- Fungsi untuk membuat tombol
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

-- Fungsi untuk membuat checkbox (menggantikan switch)
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
-- 8. INISIALISASI DATA PLOTPLAYER BERDASARKAN BASEID
-- ==================================================
local PlotPlayer = nil  -- akan diisi string "Base 1", "Base 2", dll.

-- Fungsi untuk mendapatkan BaseId dari player
local function getBaseId()
    local baseIdAttr = localPlayer:GetAttribute("BaseId")
    if baseIdAttr and type(baseIdAttr) == "string" then
        return baseIdAttr
    end
    return nil
end

-- Mapping baseId ke nama base yang ada di workspace.Bases
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

-- Koordinat untuk setiap base
local baseCoordinates = {
    ["Base 1"] = Vector3.new(-13.896, 5, -120.056),
    ["Base 2"] = Vector3.new(-14.193, 5, -60.192),
    ["Base 3"] = Vector3.new(-13.609, 5, -0.075),
    ["Base 4"] = Vector3.new(-13.91, 5, 59.939),
    ["Base 5"] = Vector3.new(-13.907, 5, 119.951),
}

-- Koordinat intermediate setelah interaksi
local intermediatePos = Vector3.new(56.818, 3.935, 31.258)

-- ==================================================
-- 9. FUNGSI TELEPORT
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
-- 10. FUNGSI-FUNGSI UNTUK TOMBOL
-- ==================================================

-- Tombol VIP: Hancurkan ScriptedPart di semua zona VIP
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

-- Tombol Go To Home
UI.AddButton({
    Text = "Go To Home",
    Callback = function()
        if PlotPlayer and baseCoordinates[PlotPlayer] then
            teleportTo(baseCoordinates[PlotPlayer])
        else
            warn("PlotPlayer tidak valid")
        end
    end
})

-- Tombol Go To Sell
UI.AddButton({
    Text = "Go To Sell",
    Callback = function()
        teleportTo(Vector3.new(42.287, 4, 139.483))
    end
})

-- Tombol Go To Jump
UI.AddButton({
    Text = "Go To Jump",
    Callback = function()
        teleportTo(Vector3.new(42.96, 3.915, 1.243))
    end
})

-- ==================================================
-- 11. CHECKBOX UNTUK AUTO FITUR DENGAN PRIORITAS
-- ==================================================

-- Variabel status auto
local autoSecretEnabled = false
local autoGodEnabled = false
local autoCelestialEnabled = false
local infJumpEnabled = false

-- Fungsi umum untuk mencari model dalam zone dengan prioritas
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

-- Fungsi cek player lain dalam radius
local function isPlayerNearby(model, radius)
    radius = radius or 3
    if not model then return false end
    local modelPos = model:GetPivot().Position
    
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - modelPos).Magnitude
                if distance <= radius then
                    return true
                end
            end
        end
    end
    return false
end

-- Fungsi mencari model yang tersedia (tanpa player di dekatnya) dalam daftar
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

-- Fungsi interaksi dengan brainrot
local function interactWithBrainrot(brainrotModel)
    if not brainrotModel then return false end
    local holdDuration = 0.25
    
    local rootPart = brainrotModel:FindFirstChild("RootPart")
    if rootPart then
        local prompt = rootPart:FindFirstChild("CollectPrompt")
        if prompt and prompt:IsA("ProximityPrompt") then
            prompt:InputHoldBegin()
            task.wait(holdDuration)
            prompt:InputHoldEnd()
            return true
        end
    end
    
    local clickDetector = brainrotModel:FindFirstChildWhichIsA("ClickDetector", true)
    if clickDetector then
        fireclickdetector(clickDetector)
        return true
    end
    
    return false
end

-- Loop utama prioritas
coroutine.wrap(function()
    while true do
        -- Jika tidak ada auto yang aktif, tunggu sebentar
        if not (autoCelestialEnabled or autoGodEnabled or autoSecretEnabled) then
            task.wait(1)
            goto continue
        end

        -- Prioritas 1: Celestial
        if autoCelestialEnabled then
            local zones = {"Zone16", "Zone15"}
            local models = getModelsFromZones(zones)
            local target = findAvailableModel(models)
            if target then
                local rootPart = target:FindFirstChild("RootPart")
                if rootPart then
                    teleportTo(rootPart.Position)
                    task.wait(0.5)  -- sedikit waktu untuk stabil
                    local success = interactWithBrainrot(target)
                    if success then
                        task.wait(0.25)  -- tunggu 0.25 detik setelah interaksi
                        teleportTo(intermediatePos)  -- ke intermediate
                        -- langsung ke plot
                        if PlotPlayer and baseCoordinates[PlotPlayer] then
                            teleportTo(baseCoordinates[PlotPlayer])
                        end
                    end
                end
                -- Selesai siklus Celestial, tunggu 1 detik lalu ulang prioritas
                task.wait(1)
                goto continue
            end
            -- jika tidak ada target, lanjut ke prioritas berikutnya
        end

        -- Prioritas 2: God
        if autoGodEnabled then
            local zones = {"Zone14", "Zone13"}
            local models = getModelsFromZones(zones)
            local target = findAvailableModel(models)
            if target then
                local rootPart = target:FindFirstChild("RootPart")
                if rootPart then
                    teleportTo(rootPart.Position)
                    task.wait(0.5)
                    local success = interactWithBrainrot(target)
                    if success then
                        task.wait(0.25)
                        teleportTo(intermediatePos)
                        if PlotPlayer and baseCoordinates[PlotPlayer] then
                            teleportTo(baseCoordinates[PlotPlayer])
                        end
                    end
                end
                task.wait(1)
                goto continue
            end
        end

        -- Prioritas 3: Secret
        if autoSecretEnabled then
            local zones = {"Zone12", "Zone11"}
            local models = getModelsFromZones(zones)
            local target = findAvailableModel(models)
            if target then
                local rootPart = target:FindFirstChild("RootPart")
                if rootPart then
                    teleportTo(rootPart.Position)
                    task.wait(0.5)
                    local success = interactWithBrainrot(target)
                    if success then
                        task.wait(0.25)
                        teleportTo(intermediatePos)
                        if PlotPlayer and baseCoordinates[PlotPlayer] then
                            teleportTo(baseCoordinates[PlotPlayer])
                        end
                    end
                end
                task.wait(1)
                goto continue
            end
        end

        -- Jika tidak ada target sama sekali, tunggu sebentar lalu ulang
        task.wait(2)

        ::continue::
    end
end)()

-- Checkbox Auto Secret
UI.AddCheckbox({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state)
        autoSecretEnabled = state
    end
})

-- Checkbox Auto God
UI.AddCheckbox({
    Text = "Auto God",
    Default = false,
    Callback = function(state)
        autoGodEnabled = state
    end
})

-- Checkbox Auto Celestial
UI.AddCheckbox({
    Text = "Auto Celestial",
    Default = false,
    Callback = function(state)
        autoCelestialEnabled = state
    end
})

-- ==================================================
-- 12. INFINITE JUMP
-- ==================================================
local function setupInfiniteJump(enabled)
    if enabled then
        local jumpConnection
        jumpConnection = userInput.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local character = localPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
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
-- 13. EXPOSE FUNGSI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI [Jump to Steal Brainrots] berhasil dimuat dengan prioritas auto.")
print("PlotPlayer saat ini: " .. tostring(PlotPlayer))
