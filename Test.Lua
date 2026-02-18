-- Script UI untuk Delta Executor
-- Game: Survive LAVA for Brainrots
-- GUI: SurviveLAVA_ByAzka

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = players.LocalPlayer
local guiName = "SurviveLAVA_ByAzka"

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
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
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
title.Text = "Survive LAVA For Brainrot"
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

-- Scrolling frame untuk konten
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

-- Fungsi membuat container
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
local switchContainer = createContainer("SwitchContainer")

-- ==================================================
-- 3. FUNGSI-FUNGSI UI
-- ==================================================
local UI = {}

function UI.AddSlider(config)
    local container = slideContainer
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or (min + max) / 2
    local callback = config.Callback or function() end

    -- Frame dengan margin kiri dan kanan agar tidak terlalu mepet
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)  -- kurangi 20 pixel total (10 kiri, 10 kanan)
    frame.Position = UDim2.new(0, 10, 0, 0) -- geser 10 ke kanan
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
            value = math.floor(value + 0.5) -- pembulatan ke integer terdekat
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

-- Fungsi untuk membuat checkbox (kotak centang)
local function createCheckbox(config)
    local container = switchContainer
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
-- 4. MINIMIZED FRAME
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

-- Minimize dan Close
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================================================
-- 5. VARIABEL GLOBAL DAN FUNGSI GAME
-- ==================================================

-- Data Rebirths (index dimulai dari 1 untuk rebirth 0)
local rebirthData = {
    [1] = "BonecaAmbalabu",      -- rebirth 0
    [2] = "CactoHipopotamo",      -- rebirth 1
    [3] = "BallerinaCappuccina",  -- rebirth 2
    [4] = "CocofantoElefanto",    -- rebirth 3
    [5] = "Garama",                -- rebirth 4
    [6] = "UdinDinDinDun",         -- rebirth 5
    [7] = "LaVaccaSaturnoSatunita", -- rebirth 6
    [8] = "LasVaquitasSaturnitas",  -- rebirth 7
    [9] = "GorilloWatermelondrillo", -- rebirth 8
    [10] = "CompactaroniDiskaloni",  -- rebirth 9
    [11] = "ChillinChilli",          -- rebirth 10
    [12] = "CrazylonePizaione",      -- rebirth 11
    -- rebirth 12 -> "Tunggu Update"
}

-- Data Plot
local plotPositions = {
    [1] = Vector3.new(100.205, 7, 83.222),
    [2] = Vector3.new(50.205, 7, 83.221),
    [3] = Vector3.new(0.205, 7, 83.221),
    [4] = Vector3.new(-49.795, 7, 83.221),
    [5] = Vector3.new(-99.795, 7, 83.221)
}

-- Titik teleport setelah interaksi (tempat meletakkan brainrot)
local afterInteractPoint = Vector3.new(-127.503, 5, -1.24)

-- Variabel plot number yang disimpan (diisi pertama kali)
local currentPlotNumber = nil

-- Fungsi untuk mendapatkan plot number dari atribut player, dan menyimpannya
local function getPlotNumber()
    if currentPlotNumber then return currentPlotNumber end
    local plotAttr = localPlayer:GetAttribute("Plot")
    if plotAttr then
        local num = tonumber(plotAttr:match("%d+"))
        if num and num >= 1 and num <= 5 then
            currentPlotNumber = num
            return num
        end
    end
    return nil
end

-- Fungsi untuk mendapatkan model player
local function getPlayerModel()
    return workspace:FindFirstChild(localPlayer.Name)
end

-- Fungsi teleport
local function teleport(position)
    local character = localPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Fungsi teleport ke plot berdasarkan nomor
local function teleportToPlot(plotNumber)
    if plotNumber and plotPositions[plotNumber] then
        teleport(plotPositions[plotNumber])
    end
end

-- Fungsi teleport ke plot player saat ini
local function teleportToHome()
    local plot = getPlotNumber()
    if plot then
        teleportToPlot(plot)
    else
        warn("Tidak dapat menemukan plot player")
    end
end

-- Fungsi interaksi dengan brainrot (hold selama durasi tertentu)
local function interactWithBrainrot(brainrotModel, holdDuration)
    if not brainrotModel then return false end
    holdDuration = holdDuration or 1.5
    -- Cari ProximityPrompt
    local prompt = brainrotModel:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        prompt:InputHoldBegin()
        task.wait(holdDuration)
        prompt:InputHoldEnd()
        return true
    else
        local clickDetector = brainrotModel:FindFirstChildWhichIsA("ClickDetector", true)
        if clickDetector then
            fireclickdetector(clickDetector)
            return true
        end
    end
    return false
end

-- ==================================================
-- 6. FUNGSI UNTUK REBIRTH NEED (dengan durasi 1.5 detik)
-- ==================================================
local function processRebirthNeed()
    local rebirths = localPlayer.leaderstats and localPlayer.leaderstats:FindFirstChild("Rebirths")
    if not rebirths then
        warn("Tidak menemukan leaderstats.Rebirths")
        return
    end
    local value = tonumber(rebirths.Value)
    if not value then
        warn("Nilai rebirths bukan angka")
        return
    end
    -- Index = value + 1
    local index = value + 1
    if index > 12 then
        warn("Rebirths " .. value .. " -> Tunggu Update")
        return
    end
    local brainrotName = rebirthData[index]
    if not brainrotName then
        warn("Tidak ada data brainrot untuk rebirths " .. tostring(value))
        return
    end

    local brainrotsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
    if not brainrotsFolder then
        warn("Tidak menemukan folder Brainrots")
        return
    end

    -- Cari di semua subfolder (rarity)
    local targetModel = nil
    for _, folder in ipairs(brainrotsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            local model = folder:FindFirstChild(brainrotName)
            if model then
                targetModel = model
                break
            end
        end
    end

    if not targetModel then
        warn("Brainrot " .. brainrotName .. " tidak ditemukan")
        return
    end

    -- 1. Teleport ke brainrot
    teleport(targetModel:GetPivot().Position + Vector3.new(0, 3, 0))
    task.wait(0.5)

    -- 2. Interaksi hold 1.5 detik
    interactWithBrainrot(targetModel, 1.5)

    -- 3. Tunggu 1.5 detik setelah interaksi
    task.wait(1.5)

    -- 4. Teleport ke titik afterInteractPoint
    teleport(afterInteractPoint)
    task.wait(0.5)

    -- 5. Teleport ke plot player
    local plot = getPlotNumber()
    if plot then
        teleportToPlot(plot)
    else
        warn("Tidak bisa mendapatkan plot, teleport ke plot 1")
        teleport(plotPositions[1])
    end
end

-- ==================================================
-- 7. AUTO GODLY, CELESTIAL, SECRET (dengan durasi 1.5 detik)
-- ==================================================
local autoStates = {
    Godly = false,
    Celestial = false,
    Secret = false
}

-- Fungsi auto collect berdasarkan tipe (satu siklus)
local function autoCollect(typeName)
    local folderName = typeName
    local brainrotsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
    if not brainrotsFolder then return false end

    local targetFolder = brainrotsFolder:FindFirstChild(folderName)
    if not targetFolder then return false end

    local models = {}
    for _, child in ipairs(targetFolder:GetChildren()) do
        if child:IsA("Model") then
            table.insert(models, child)
        end
    end
    if #models == 0 then return false end

    local targetModel = models[math.random(1, #models)]

    teleport(targetModel:GetPivot().Position + Vector3.new(0, 3, 0))
    task.wait(0.5)

    interactWithBrainrot(targetModel, 1.5)

    task.wait(1.5)

    teleport(afterInteractPoint)
    task.wait(0.5)

    local plot = getPlotNumber()
    if plot then
        teleportToPlot(plot)
    else
        teleport(plotPositions[1])
    end

    return true
end

-- Loop utama auto
local function startAutoLoop()
    while true do
        local order = {}
        if autoStates.Godly then table.insert(order, "Godly") end
        if autoStates.Celestial then table.insert(order, "Celestial") end
        if autoStates.Secret then table.insert(order, "Secret") end

        if #order == 0 then
            task.wait(1)
            continue
        end

        for _, typeName in ipairs(order) do
            if autoStates[typeName] then
                autoCollect(typeName)
                task.wait(1) -- jeda antar tipe
            end
        end
        task.wait(1) -- jeda sebelum loop ulang
    end
end

-- ==================================================
-- 8. FUNGSI UNTUK COLLECT CASH DAN UPGRADE ALL
-- ==================================================
local collectCashEnabled = false
local upgradeAllEnabled = false
local instantProximityEnabled = false

local placesCache = nil

local function getPlacesData()
    if placesCache then return placesCache end
    local plotNum = getPlotNumber()
    if not plotNum then return nil end

    local plotsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Plots")
    if not plotsFolder then return nil end

    local plotFolder = plotsFolder:FindFirstChild(tostring(plotNum))
    if not plotFolder then return nil end

    local places = plotFolder:FindFirstChild("Places")
    if not places then return nil end

    local touchParts = {}
    local upgradeParts = {}

    for i = 1, 30 do
        local model = places:FindFirstChild(tostring(i))
        if model then
            local claim = model:FindFirstChild("Claim")
            if claim then
                local touchInterest = claim:FindFirstChildWhichIsA("TouchTransmitter")
                if touchInterest then
                    table.insert(touchParts, claim)
                end
            end
            local upgrade = model:FindFirstChild("Upgrade")
            if upgrade then
                local clickDetector = upgrade:FindFirstChildWhichIsA("ClickDetector")
                if clickDetector then
                    table.insert(upgradeParts, upgrade)
                end
            end
        end
    end

    placesCache = {
        touchParts = touchParts,
        upgradeParts = upgradeParts
    }
    return placesCache
end

local function fireAllTouchInterests()
    local data = getPlacesData()
    if not data then return end

    local character = localPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    for _, part in ipairs(data.touchParts) do
        firetouchinterest(rootPart, part, 0)
        firetouchinterest(rootPart, part, 1)
        task.wait()
    end
end

local function clickAllUpgrades()
    local data = getPlacesData()
    if not data then return end

    for _, part in ipairs(data.upgradeParts) do
        local clickDetector = part:FindFirstChildWhichIsA("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
        end
        task.wait()
    end
end

local function startCollectCashLoop()
    while true do
        if collectCashEnabled then
            fireAllTouchInterests()
        end
        task.wait(1)
    end
end

local function startUpgradeAllLoop()
    while true do
        if upgradeAllEnabled then
            clickAllUpgrades()
        end
        task.wait(1)
    end
end

-- ==================================================
-- 9. MENAMBAH ELEMEN UI
-- ==================================================

-- Slider Walkspeed (dengan integer dan margin)
UI.AddSlider({
    Text = "Walkspeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(value)
        local character = localPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
})

-- Tombol Remove Lava
UI.AddButton({
    Text = "Remove Lava",
    Callback = function()
        local lavasFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Lavas")
        if lavasFolder then
            lavasFolder:Destroy()
            print("Lava dihapus")
        else
            warn("Folder Lavas tidak ditemukan")
        end
    end
})

-- Tombol Remove VIP
UI.AddButton({
    Text = "Remove VIP",
    Callback = function()
        local vipFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VIPDoors")
        if vipFolder then
            vipFolder:Destroy()
            print("VIP Doors dihapus")
        else
            warn("Folder VIPDoors tidak ditemukan")
        end
    end
})

-- Tombol Rebirths Need (dengan logika baru)
UI.AddButton({
    Text = "Rebirths Need",
    Callback = processRebirthNeed
})

-- Tombol To Home
UI.AddButton({
    Text = "To Home",
    Callback = teleportToHome
})

-- Switch Auto Godly
createCheckbox({
    Text = "Auto Godly",
    Default = false,
    Callback = function(state)
        autoStates.Godly = state
        print("Auto Godly:", state)
    end
})

-- Switch Auto Celestial
createCheckbox({
    Text = "Auto Celestial",
    Default = false,
    Callback = function(state)
        autoStates.Celestial = state
        print("Auto Celestial:", state)
    end
})

-- Switch Auto Secret
createCheckbox({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state)
        autoStates.Secret = state
        print("Auto Secret:", state)
    end
})

-- Switch Instant Proximity
createCheckbox({
    Text = "Instant Proximity",
    Default = false,
    Callback = function(state)
        instantProximityEnabled = state
        print("Instant Proximity:", state)
    end
})

-- Switch Collect Cash
createCheckbox({
    Text = "Collect Cash",
    Default = false,
    Callback = function(state)
        collectCashEnabled = state
        if state then
            getPlacesData()
        end
        print("Collect Cash:", state)
    end
})

-- Switch Upgrade All
createCheckbox({
    Text = "Upgrade All",
    Default = false,
    Callback = function(state)
        upgradeAllEnabled = state
        if state then
            getPlacesData()
        end
        print("Upgrade All:", state)
    end
})

-- ==================================================
-- 10. MEMULAI LOOP
-- ==================================================
task.spawn(startAutoLoop)
task.spawn(startCollectCashLoop)
task.spawn(startUpgradeAllLoop)

-- ==================================================
-- 11. EXPOSE UI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI Survive LAVA For Brainrot berhasil dimuat.")
print("Gunakan _G['" .. guiName .. "'] untuk akses fungsi UI.")
