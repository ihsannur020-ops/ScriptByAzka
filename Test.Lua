-- Script UI untuk Delta Executor
-- Game: Survive LAVA for Brainrots

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local localPlayer = players.LocalPlayer
local guiName = "[SurviveLAVA_ByAzka]"

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
mainFrame.Size = UDim2.new(0, 400, 0, 400)  -- diperbesar untuk konten
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
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

-- Judul UI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Survive LAVA Brainrots"
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
    layout.Padding = UDim.new(0, 8)

    return container
end

-- Buat container: Slider, Tombol, Switch
local slideContainer = createContainer("SlideContainer")
local buttonContainer = createContainer("ButtonContainer")
local switchContainer = createContainer("SwitchContainer")

-- ==================================================
-- 5. FUNGSI-FUNGSI UI
-- ==================================================
local UI = {}

-- Fungsi slider (sama seperti template, disesuaikan)
function UI.AddSlider(config)
    local container = slideContainer
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or (min + max) / 2
    local callback = config.Callback or function() end
    local unit = config.Unit or ""

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    -- Label teks
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Nilai slider
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default) .. unit
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    -- Track slider
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 1, -10)
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

    -- Sudut melingkar
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 6)
    thumbCorner.Parent = thumb
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = track

    -- Interaksi slider
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
            valueLabel.Text = tostring(value) .. unit
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -6, 0, -4)
            callback(value)
        end
    end)

    return frame
end

-- Fungsi tombol (sama seperti template)
function UI.AddButton(config)
    local container = buttonContainer
    local text = config.Text or "Button"
    local callback = config.Callback or function() end

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
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

-- Fungsi toggle (checkbox) untuk switch
function UI.AddToggle(config)
    local container = switchContainer
    local text = config.Text or "Toggle"
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

    -- Kotak toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 24, 0, 24)
    toggleBtn.Position = UDim2.new(1, -24, 0.5, -12)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn

    -- Centang (label)
    local checkLabel = Instance.new("TextLabel")
    checkLabel.Size = UDim2.new(1, 0, 1, 0)
    checkLabel.BackgroundTransparency = 1
    checkLabel.Text = default and "✓" or ""
    checkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkLabel.Font = Enum.Font.GothamBold
    checkLabel.TextSize = 18
    checkLabel.Visible = default
    checkLabel.Parent = toggleBtn

    local state = default

    local function updateState()
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
        checkLabel.Visible = state
        checkLabel.Text = state and "✓" or ""
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateState()
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
-- 8. LOGIKA GAME
-- ==================================================

-- Fungsi utilitas
local function getCharacter()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
end

local function teleportTo(position)
    local char = getCharacter()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
    end
end

local function findBrainrotByName(name)
    -- Cari di semua folder di workspace.GameFolder.Brainrots
    local brainrotsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
    if not brainrotsFolder then return nil end

    for _, folder in ipairs(brainrotsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            local target = folder:FindFirstChild(name)
            if target then
                return target
            end
        end
    end
    return nil
end

local function interactWithProximity(model)
    -- Coba cari ProximityPrompt di model
    local prompt = model:FindFirstChildOfClass("ProximityPrompt") or model:FindFirstChild("ProximityPrompt", true)
    if prompt then
        prompt:Fire()
        return true
    end
    return false
end

local function waitForCarry(timeout)
    local char = getCharacter()
    local start = tick()
    while tick() - start < timeout do
        if char:GetAttribute("CarryingBrainrot") then
            return true
        end
        task.wait(0.1)
    end
    return false
end

local function getPlayerPlot()
    return localPlayer:GetAttribute("Plot") -- misal "Plot1", "Plot2", dll
end

local plotCoordinates = {
    ["1"] = Vector3.new(100.205, 7, 83.222),
    ["2"] = Vector3.new(50.205, 7, 83.221),
    ["3"] = Vector3.new(0.205, 7, 83.221),
    ["4"] = Vector3.new(-49.795, 7, 83.221),
    ["5"] = Vector3.new(-99.795, 7, 83.221)
}

local rebirthData = {
    [1] = "BonecaAmbalabu",
    [2] = "CactoHipopotamo",
    [3] = "BallerinaCappuccina",
    [4] = "CocofantoElefanto",
    [5] = "Garama",
    [6] = "UdinDinDinDun",
    [7] = "LaVaccaSaturnoSatunita",
    [8] = "LasVaquitasSaturnitas",
    [9] = "GorilloWatermelondrillo",
    [10] = "CompactaroniDiskaloni",
    [11] = "ChillinChilli",
    [12] = "CrazylonePizaione"
}

-- Fungsi untuk tombol Rebirths Need
local function rebirthsNeed()
    local leaderstats = localPlayer:FindFirstChild("leaderstats")
    if not leaderstats then
        warn("leaderstats tidak ditemukan")
        return
    end
    local rebirthsVal = leaderstats:FindFirstChild("Rebirths")
    if not rebirthsVal then
        warn("Rebirths tidak ditemukan di leaderstats")
        return
    end
    local rebirths = rebirthsVal.Value
    local brainrotName = rebirthData[rebirths]
    if not brainrotName then
        warn("Tidak ada brainrot untuk rebirths " .. tostring(rebirths))
        return
    end

    local brainrot = findBrainrotByName(brainrotName)
    if not brainrot then
        warn("Brainrot " .. brainrotName .. " tidak ditemukan di folder")
        return
    end

    -- Teleport ke brainrot
    teleportTo(brainrot:GetPivot().Position)

    -- Tunggu sebentar sampai dekat
    task.wait(1)

    -- Interaksi
    if not interactWithProximity(brainrot) then
        warn("Tidak dapat menemukan ProximityPrompt")
    end

    -- Tunggu carrying
    local carried = waitForCarry(6)
    if not carried then
        warn("Gagal membawa brainrot dalam 6 detik")
    end

    -- Teleport ke titik kumpul
    teleportTo(Vector3.new(-153, 28, 34))
    task.wait(1)

    -- Dapatkan plot
    local plot = getPlayerPlot()
    if plot and plotCoordinates[plot] then
        teleportTo(plotCoordinates[plot])
    else
        warn("Plot tidak valid: " .. tostring(plot))
    end
end

-- Fungsi untuk To Home
local function toHome()
    local plot = getPlayerPlot()
    if plot and plotCoordinates[plot] then
        teleportTo(plotCoordinates[plot])
    else
        warn("Plot tidak valid")
    end
end

-- Fungsi untuk auto farm berdasarkan tipe
local autoFarmRunning = false
local autoFarmState = {
    godly = false,
    celestial = false,
    secret = false
}

local function getRandomBrainrotFromFolder(folderName)
    local brainrotsFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
    if not brainrotsFolder then return nil end
    local targetFolder = brainrotsFolder:FindFirstChild(folderName)
    if not targetFolder then return nil end
    local children = targetFolder:GetChildren()
    if #children == 0 then return nil end
    return children[math.random(1, #children)]
end

local function processAutoFarm(typeName)
    local folderName = typeName == "godly" and "Godly" or (typeName == "celestial" and "Celestial" or "Secret")
    local brainrot = getRandomBrainrotFromFolder(folderName)
    if not brainrot then
        return false -- tidak ada brainrot
    end

    teleportTo(brainrot:GetPivot().Position)
    task.wait(1)
    interactWithProximity(brainrot)
    waitForCarry(6) -- abaikan hasil, lanjut
    teleportTo(Vector3.new(-153, 28, 34))
    task.wait(1)
    local plot = getPlayerPlot()
    if plot and plotCoordinates[plot] then
        teleportTo(plotCoordinates[plot])
    end
    task.wait(1)
    return true
end

local function autoFarmLoop()
    while autoFarmRunning do
        -- Urutan prioritas: godly -> celestial -> secret
        local types = {}
        if autoFarmState.godly then table.insert(types, "godly") end
        if autoFarmState.celestial then table.insert(types, "celestial") end
        if autoFarmState.secret then table.insert(types, "secret") end

        local anySuccess = false
        for _, t in ipairs(types) do
            if not autoFarmRunning then break end
            local success = pcall(processAutoFarm, t)
            if success then
                anySuccess = true
                -- Jika berhasil, kita lanjut ke akhir loop (istirahat sebentar)
                break
            end
        end

        if not anySuccess then
            -- Tidak ada brainrot yang tersedia, tunggu sebentar
            task.wait(5)
        else
            task.wait(1) -- jeda antar siklus
        end
    end
end

-- ==================================================
-- 9. MEMBUAT ELEMEN UI SESUAI PERMINTAAN
-- ==================================================

-- Slider WalkSpeed
UI.AddSlider({
    Text = "WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Unit = "",
    Callback = function(value)
        local char = getCharacter()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

-- Tombol Remove Lava
UI.AddButton({
    Text = "Remove Lava",
    Callback = function()
        local lavas = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Lavas")
        if lavas then
            lavas:Destroy()
            print("Lavas dihapus")
        else
            warn("Folder Lavas tidak ditemukan")
        end
    end
})

-- Tombol Remove VIP
UI.AddButton({
    Text = "Remove VIP",
    Callback = function()
        local vipDoors = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VIPDoors")
        if vipDoors then
            vipDoors:Destroy()
            print("VIPDoors dihapus")
        else
            warn("Folder VIPDoors tidak ditemukan")
        end
    end
})

-- Tombol Rebirths Need
UI.AddButton({
    Text = "Rebirths Need",
    Callback = rebirthsNeed
})

-- Tombol To Home
UI.AddButton({
    Text = "To Home",
    Callback = toHome
})

-- Toggle Auto Godly
UI.AddToggle({
    Text = "Auto Godly",
    Default = false,
    Callback = function(state)
        autoFarmState.godly = state
        if state and not autoFarmRunning then
            autoFarmRunning = true
            task.spawn(autoFarmLoop)
        elseif not state and not autoFarmState.godly and not autoFarmState.celestial and not autoFarmState.secret then
            autoFarmRunning = false
        end
    end
})

-- Toggle Auto Celestial
UI.AddToggle({
    Text = "Auto Celestial",
    Default = false,
    Callback = function(state)
        autoFarmState.celestial = state
        if state and not autoFarmRunning then
            autoFarmRunning = true
            task.spawn(autoFarmLoop)
        elseif not state and not autoFarmState.godly and not autoFarmState.celestial and not autoFarmState.secret then
            autoFarmRunning = false
        end
    end
})

-- Toggle Auto Secret
UI.AddToggle({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state)
        autoFarmState.secret = state
        if state and not autoFarmRunning then
            autoFarmRunning = true
            task.spawn(autoFarmLoop)
        elseif not state and not autoFarmState.godly and not autoFarmState.celestial and not autoFarmState.secret then
            autoFarmRunning = false
        end
    end
})

-- ==================================================
-- 10. EXPOSE FUNGSI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI [SurviveLAVA] berhasil dimuat. Gunakan _G['" .. guiName .. "'] untuk menambahkan elemen tambahan.")
print("Contoh: _G['" .. guiName .. "'].AddButton({Text = 'Tes', Callback = function() print('ok') end})")
