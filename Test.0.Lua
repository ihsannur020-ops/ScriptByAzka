-- Script UI untuk Delta Executor
-- GUI: Speed Escape for Brainrots - Library Version

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")

local localPlayer = players.LocalPlayer
local guiName = "SpeedEscapeforBrainrots"  -- Tanpa spasi untuk global variable

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
mainFrame.Size = UDim2.new(0, 350, 0, 400)  -- lebih besar untuk menampung banyak elemen
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Sudut melengkung untuk frame utama
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Judul UI (pojok kiri)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Speed Escape for Brainrots"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Tombol Minimize ( - ) di pojok kanan
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

-- Tombol Close ( X ) di pojok kanan
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

-- Layout untuk menyusun container secara vertikal
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
local buttonContainer = createContainer("ButtonContainer")  -- tidak dipakai, tapi tetap ada
local switchContainer = createContainer("SwitchContainer")

-- ==================================================
-- 5. FUNGSI-FUNGSI UI (Slider, Button, Checkbox)
-- ==================================================
local UI = {}

-- Fungsi slider (integer)
function UI.AddSlider(config)
    local container = slideContainer
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    -- Label teks
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Nilai slider (angka)
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(math.floor(default))
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    -- Track slider
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
            value = math.floor(value + 0.5)  -- pembulatan integer
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -6, 0, -4)
            callback(value)
        end
    end)

    return frame
end

-- Fungsi checkbox (seperti yang diminta: kotak dengan centang)
function UI.AddCheckbox(config)
    local container = switchContainer
    local text = config.Text or "Checkbox"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Kotak checkbox
    local checkBox = Instance.new("TextButton")
    checkBox.Size = UDim2.new(0, 24, 0, 24)
    checkBox.Position = UDim2.new(1, -30, 0.5, -12)
    checkBox.BackgroundColor3 = default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    checkBox.Text = ""
    checkBox.BorderSizePixel = 0
    checkBox.Parent = frame

    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 4)
    checkCorner.Parent = checkBox

    -- Tanda centang
    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = default and "✓" or ""
    checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkMark.Font = Enum.Font.GothamBold
    checkMark.TextSize = 18
    checkMark.Parent = checkBox

    local state = default

    local function updateCheck()
        checkBox.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
        checkMark.Text = state and "✓" or ""
    end

    checkBox.MouseButton1Click:Connect(function()
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
-- 8. IMPLEMENTASI FITUR GAME
-- ==================================================
local Player = localPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Data prioritas mutation (dari yang tertinggi ke terendah)
local MutationPriority = {
    Hacker = 1,
    Valentine = 2,
    Radioactive = 3,
    Rainbow = 4,
    Diamond = 5,
    Gold = 6,
    Common = 7
}

-- State untuk setiap switch
local autoStates = {
    AlwaysGround = false,
    RemoveConveyor = false,
    RemoveBall = false,
    RemoveWave = false,
    RemoveLavas = false,
    RemoveMovingPart = false,
    RemoveFallPart = false,
    AutoSecret = false,
    AutoDivine = false,
    AutoSupreme = false
}

-- Thread handles untuk loop
local loops = {}

-- Fungsi untuk menghentikan loop berdasarkan nama
local function stopLoop(name)
    if loops[name] then
        loops[name]:Disconnect()
        loops[name] = nil
    end
end

-- Fungsi untuk memulai loop jika state true
local function startLoop(name, func)
    if autoStates[name] then
        stopLoop(name) -- hentikan yang lama jika ada
        local thread
        thread = runService.Heartbeat:Connect(function()
            if not autoStates[name] then
                thread:Disconnect()
                return
            end
            func()
        end)
        loops[name] = thread
    end
end

-- ==================================================
-- 8.1 Always Ground
-- ==================================================
local groundPart = nil
local function updateAlwaysGround()
    if autoStates.AlwaysGround then
        if not groundPart or not groundPart.Parent then
            groundPart = Instance.new("Part")
            groundPart.Name = "AlwaysGroundByAzka"
            groundPart.Size = Vector3.new(5, 1, 5) -- ukuran sesuai
            groundPart.Position = Vector3.new(0, 58.0631103515625, 0)
            groundPart.Anchored = true
            groundPart.CanCollide = false
            groundPart.Transparency = 1
            groundPart.Parent = workspace
        end
        -- Update posisi X dan Z mengikuti player
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local root = Player.Character.HumanoidRootPart
            groundPart.Position = Vector3.new(root.Position.X, 58.0631103515625, root.Position.Z)
        end
    else
        if groundPart then
            groundPart:Destroy()
            groundPart = nil
        end
    end
end

-- ==================================================
-- 8.2 Remove Conveyor (Obby2)
-- ==================================================
local function removeConveyorLoop()
    local conveyors = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby2") and workspace.Map.Obbies.Obby2:FindFirstChild("Convenyors")
    if conveyors then
        for _, folder in ipairs(conveyors:GetChildren()) do
            if folder:IsA("Folder") then
                for _, part in ipairs(folder:GetChildren()) do
                    if part:IsA("Part") then
                        -- Set attribute "speed" ke 0
                        part:SetAttribute("speed", 0)
                        -- Jika ada properti Velocity, set juga
                        if part:FindFirstChild("Velocity") then
                            part.Velocity = Vector3.new()
                        end
                    end
                end
            end
        end
    end
end

-- ==================================================
-- 8.3 Remove Ball (Obby3)
-- ==================================================
local function removeBallLoop()
    local ball = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby3") and workspace.Map.Obbies.Obby3:FindFirstChild("Ball")
    if ball then
        ball:Destroy()
    end
end

-- ==================================================
-- 8.4 Remove Wave (Obby4)
-- ==================================================
local function removeWaveLoop()
    local wave = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby4") and workspace.Map.Obbies.Obby4:FindFirstChild("Wave")
    if wave and wave:IsA("Model") then
        wave:Destroy()
    end
end

-- ==================================================
-- 8.5 Remove Lavas (Obby5)
-- ==================================================
local function removeLavasLoop()
    local lavas = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby5") and workspace.Map.Obbies.Obby5:FindFirstChild("Lavas")
    if lavas and lavas:IsA("Model") then
        lavas:Destroy()
    end
end

-- ==================================================
-- 8.6 Remove MovingPart (Obby6)
-- ==================================================
local function removeMovingPartLoop()
    local movingParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby6") and workspace.Map.Obbies.Obby6:FindFirstChild("MovingParts")
    if movingParts and movingParts:IsA("Model") then
        movingParts:Destroy()
    end
    local killPart = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby6") and workspace.Map.Obbies.Obby6:FindFirstChild("KillPart")
    if killPart and killPart:IsA("Part") then
        killPart:Destroy()
    end
end

-- ==================================================
-- 8.7 Remove FallPart (Obby8)
-- ==================================================
local function removeFallPartLoop()
    local fallParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby8") and workspace.Map.Obbies.Obby8:FindFirstChild("FallParts")
    if fallParts then
        for _, part in ipairs(fallParts:GetChildren()) do
            if part:IsA("Part") then
                -- Hapus semua TouchInterest (TouchTransmitter)
                for _, touch in ipairs(part:GetTouchingParts()) do
                    -- Tidak bisa langsung hapus TouchInterest, tapi kita bisa set CanTouch = false?
                    -- Alternatif: hapus event dengan memutus koneksi? Tidak mudah.
                    -- Cara paling ampuh: clone part tanpa TouchInterest, lalu ganti.
                    -- Tapi untuk simplicity, kita set part.CanTouch = false
                    part.CanTouch = false
                end
                -- Atau jika ingin benar-benar menghapus TouchInterest:
                local touchInterest = part:FindFirstChildOfClass("TouchTransmitter")
                if touchInterest then
                    touchInterest:Destroy()
                end
            end
        end
    end
end

-- ==================================================
-- 8.8 Auto Secret, Divine, Supreme
-- ==================================================
-- Fungsi untuk mendapatkan mutation priority dari sebuah model brainrot
local function getMutationPriority(model)
    local mutationLabel = model:FindFirstChild("BillboardAttachment") and
                          model.BillboardAttachment:FindFirstChild("EntityBillboardTemplate") and
                          model.BillboardAttachment.EntityBillboardTemplate:FindFirstChild("MutationLabel")
    if mutationLabel and mutationLabel:IsA("TextLabel") then
        local text = mutationLabel.Text
        return MutationPriority[text] or 999 -- jika tidak dikenal, prioritas rendah
    end
    return 999
end

-- Fungsi untuk mendapatkan rarity dari model
local function getRarity(model)
    local rarityLabel = model:FindFirstChild("BillboardAttachment") and
                        model.BillboardAttachment:FindFirstChild("EntityBillboardTemplate") and
                        model.BillboardAttachment.EntityBillboardTemplate:FindFirstChild("RarityLabel")
    if rarityLabel and rarityLabel:IsA("TextLabel") then
        return rarityLabel.Text
    end
    return nil
end

-- Fungsi untuk mencari model brainrot dengan rarity tertentu dan mutation prioritas tertinggi
local function findBestBrainrot(targetRarity)
    local bestModel = nil
    local bestPriority = 999
    local caches = workspace:FindFirstChild("Caches")
    if not caches then return nil end
    local clientEntities = caches:FindFirstChild("ClientEntities")
    if not clientEntities then return nil end

    for _, model in ipairs(clientEntities:GetChildren()) do
        if model:IsA("Model") then
            local rarity = getRarity(model)
            if rarity == targetRarity then
                local priority = getMutationPriority(model)
                if priority < bestPriority then
                    bestPriority = priority
                    bestModel = model
                end
            end
        end
    end
    return bestModel
end

-- Fungsi untuk berinteraksi dengan brainrot (simulasi proximity)
local function interactWithBrainrot(model)
    -- Cari ProximityPrompt di dalam model
    local prompt = nil
    for _, child in ipairs(model:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            prompt = child
            break
        end
    end
    if not prompt then return false end

    -- Pindahkan player ke dekat model
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        root.CFrame = model:GetPrimaryPartCFrame() or model:GetPivot() * CFrame.new(0, 0, -3) -- di depan model
    end
    task.wait(0.5)

    -- Simulasi tahan E
    -- Metode 1: Gunakan VirtualInput
    virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(1.6)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, nil)

    -- Metode 2: jika ada prompt, bisa juga panggil prompt:InputHoldBegin() dan InputHoldEnd()
    -- prompt:InputHoldBegin()
    -- task.wait(1.6)
    -- prompt:InputHoldEnd()

    return true
end

-- Fungsi untuk teleport ke titik kembali
local function teleportBack()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        root.CFrame = CFrame.new(-1107.992, 62.500, -1193.344)
    end
end

-- Loop utama untuk auto collect
local autoCollectRunning = false
local function startAutoCollect()
    if autoCollectRunning then return end
    autoCollectRunning = true

    -- Urutan prioritas rarity
    local rarityOrder = {"Supreme", "Divine", "Secret"}

    while autoCollectRunning do
        -- Cek apakah ada switch yang aktif
        local anyActive = autoStates.AutoSupreme or autoStates.AutoDivine or autoStates.AutoSecret
        if not anyActive then
            autoCollectRunning = false
            break
        end

        for _, rarity in ipairs(rarityOrder) do
            if autoStates["Auto" .. rarity] then
                local model = findBestBrainrot(rarity)
                if model then
                    -- Interaksi
                    local success = interactWithBrainrot(model)
                    if success then
                        task.wait(1.6) -- waktu interaksi
                        teleportBack()
                        task.wait(1) -- jeda sebelum mencari lagi
                    end
                end
            end
        end
        task.wait(1) -- jeda siklus
    end
end

-- Fungsi untuk mengontrol auto collect
local function updateAutoCollect()
    if autoStates.AutoSupreme or autoStates.AutoDivine or autoStates.AutoSecret then
        if not autoCollectRunning then
            coroutine.wrap(startAutoCollect)()
        end
    else
        autoCollectRunning = false
    end
end

-- ==================================================
-- 9. MENAMBAHKAN ELEMEN KE GUI
-- ==================================================
-- Slider Walkspeed
UI.AddSlider({
    Text = "Walkspeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Checkbox Always Ground
UI.AddCheckbox({
    Text = "Always Ground",
    Default = false,
    Callback = function(state)
        autoStates.AlwaysGround = state
        if state then
            startLoop("AlwaysGround", updateAlwaysGround)
        else
            stopLoop("AlwaysGround")
            updateAlwaysGround() -- untuk menghapus part
        end
    end
})

-- Remove Conveyor
UI.AddCheckbox({
    Text = "Remove Conveyor (Obby2)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveConveyor = state
        if state then
            startLoop("RemoveConveyor", removeConveyorLoop)
        else
            stopLoop("RemoveConveyor")
        end
    end
})

-- Remove Ball
UI.AddCheckbox({
    Text = "Remove Ball (Obby3)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveBall = state
        if state then
            startLoop("RemoveBall", removeBallLoop)
        else
            stopLoop("RemoveBall")
        end
    end
})

-- Remove Wave
UI.AddCheckbox({
    Text = "Remove Wave (Obby4)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveWave = state
        if state then
            startLoop("RemoveWave", removeWaveLoop)
        else
            stopLoop("RemoveWave")
        end
    end
})

-- Remove Lavas
UI.AddCheckbox({
    Text = "Remove Lavas (Obby5)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveLavas = state
        if state then
            startLoop("RemoveLavas", removeLavasLoop)
        else
            stopLoop("RemoveLavas")
        end
    end
})

-- Remove MovingPart
UI.AddCheckbox({
    Text = "Remove MovingPart (Obby6)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveMovingPart = state
        if state then
            startLoop("RemoveMovingPart", removeMovingPartLoop)
        else
            stopLoop("RemoveMovingPart")
        end
    end
})

-- Remove FallPart
UI.AddCheckbox({
    Text = "Remove FallPart (Obby8)",
    Default = false,
    Callback = function(state)
        autoStates.RemoveFallPart = state
        if state then
            startLoop("RemoveFallPart", removeFallPartLoop)
        else
            stopLoop("RemoveFallPart")
        end
    end
})

-- Auto Secret
UI.AddCheckbox({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state)
        autoStates.AutoSecret = state
        updateAutoCollect()
    end
})

-- Auto Divine
UI.AddCheckbox({
    Text = "Auto Divine",
    Default = false,
    Callback = function(state)
        autoStates.AutoDivine = state
        updateAutoCollect()
    end
})

-- Auto Supreme
UI.AddCheckbox({
    Text = "Auto Supreme",
    Default = false,
    Callback = function(state)
        autoStates.AutoSupreme = state
        updateAutoCollect()
    end
})

-- ==================================================
-- 10. EXPOSE FUNGSI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI Speed Escape for Brainrots berhasil dimuat. Gunakan _G['" .. guiName .. "'] untuk menambahkan elemen secara manual.")
print("Contoh: _G['" .. guiName .. "'].AddCheckbox({Text = 'Test', Callback = function(s) print(s) end})")
