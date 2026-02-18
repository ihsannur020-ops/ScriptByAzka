-- Script UI untuk Delta Executor
-- GUI: [ Escape Getting Crushed For Brainrots ] - Library Version

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local virtualUser = game:GetService("VirtualUser")  -- Untuk simulasi input
local tweenService = game:GetService("TweenService")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local guiName = "EscapeGettingCrushed_ByAzka"

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
mainFrame.Size = UDim2.new(0, 400, 0, 450)  -- sedikit lebih besar untuk banyak konten
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
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
title.Text = "Escape Getting Crushed For Brainrots"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
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
-- 4. MEMBUAT KONTAINER (SLIDE, TOMBOL, SWITCH)
-- ==================================================
-- Fungsi untuk membuat container dengan background transparan
local function createContainer(name)
    local container = Instance.new("Frame")
    container.Name = name
    container.Size = UDim2.new(1, 0, 0, 0)  -- akan membesar otomatis
    container.BackgroundTransparency = 1
    container.Parent = scrollingFrame
    container.AutomaticSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    return container
end

-- Buat tiga container sesuai urutan: Slide, Tombol, Switch
local slideContainer = createContainer("SlideContainer")
local buttonContainer = createContainer("ButtonContainer")
local switchContainer = createContainer("SwitchContainer")

-- ==================================================
-- 5. FUNGSI-FUNGSI UNTUK MENAMBAH ELEMEN KE KONTAINER
-- ==================================================
local UI = {}

-- Fungsi untuk membuat slider (menggunakan track dan thumb sederhana)
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

    -- Label teks
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Nilai slider (angka)
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
            value = math.floor(value * 100) / 100  -- pembulatan 2 desimal
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

    -- Efek hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    return button
end

-- Fungsi untuk membuat switch
function UI.AddSwitch(config)
    local container = switchContainer
    local text = config.Text or "Switch"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Tombol switch
    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(0, 50, 0, 24)
    switchBtn.Position = UDim2.new(1, -50, 0.5, -12)
    switchBtn.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(80, 80, 80)
    switchBtn.Text = ""
    switchBtn.BorderSizePixel = 0
    switchBtn.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = switchBtn

    -- Lingkaran dalam
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switchBtn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 10)
    circleCorner.Parent = circle

    local state = default

    local function updateSwitch()
        switchBtn.BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(80, 80, 80)
        circle.Position = state and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    end

    switchBtn.MouseButton1Click:Connect(function()
        state = not state
        updateSwitch()
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
-- 8. PENAMBAHAN ELEMEN SESUAI PERMINTAAN
-- ==================================================

-- Variabel global untuk menyimpan plot player
local PlotPlayerSave = nil

-- Fungsi untuk mendapatkan plot player dari server
local function getPlayerPlot()
    local remoteBank = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteBank")
    if remoteBank then
        local getPlotFunc = remoteBank:FindFirstChild("GetPlot")
        if getPlotFunc and getPlotFunc:IsA("RemoteFunction") then
            local success, result = pcall(function()
                return getPlotFunc:InvokeServer()
            end)
            if success and result then
                PlotPlayerSave = result
                print("Plot player:", PlotPlayerSave)
                return result
            end
        end
    end
    warn("Gagal mendapatkan plot player")
    return nil
end

-- Panggil saat script dimuat
getPlayerPlot()

-- Data lokasi spawn berdasarkan plot
local plotSpawnLocations = {
    [1] = CFrame.new(131.375, 56, -117.251),
    [2] = CFrame.new(131.375, 56, -57.251),
    [3] = CFrame.new(131.375, 56, 2.749),
    [4] = CFrame.new(131.375, 56, 62.749),
    [5] = CFrame.new(131.375, 56, 122.749)
}

-- Fungsi teleport ke base sesuai plot
local function teleportToBase()
    if PlotPlayerSave and plotSpawnLocations[PlotPlayerSave] then
        rootPart.CFrame = plotSpawnLocations[PlotPlayerSave]
    else
        warn("Plot tidak diketahui, teleport ke plot 1")
        rootPart.CFrame = plotSpawnLocations[1]
    end
end

-- Fungsi untuk mengecek apakah ada pemain lain dalam radius 3 dari suatu posisi
local function isPlayerInRadius(position, radius)
    radius = radius or 3
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - position).Magnitude
                if dist <= radius then
                    return true
                end
            end
        end
    end
    return false
end

-- Fungsi untuk mencari entity dengan rarity tertentu
local function findEntityByRarity(rarityPattern, excludeRarities)
    local entitiesFolder = workspace:FindFirstChild("EntitiesFolder")
    if not entitiesFolder then return nil end

    for _, model in ipairs(entitiesFolder:GetChildren()) do
        if model:IsA("Model") then
            -- Cari MeshPart di dalam model (langsung, bukan di child lain)
            local meshPart = model:FindFirstChildOfClass("MeshPart") or model:FindFirstChildOfClass("Part")
            if meshPart then
                local billboard = meshPart:FindFirstChild("EntityBillboardTemplate")
                if billboard then
                    local rarityLabel = billboard:FindFirstChild("RarityLabel")
                    if rarityLabel and rarityLabel:IsA("TextLabel") then
                        local text = rarityLabel.Text
                        -- Cek apakah sesuai pattern
                        if rarityPattern == "Event" then
                            -- Event: selain common, uncommon, rare, epic, legendary, mythical, secret, celestial, OG, divine
                            local commonRarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Secret", "Celestial", "OG", "Divine"}
                            local isCommon = false
                            for _, r in ipairs(commonRarities) do
                                if text == r then
                                    isCommon = true
                                    break
                                end
                            end
                            if not isCommon then
                                return model
                            end
                        else
                            if text == rarityPattern then
                                return model
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Fungsi untuk interaksi dengan entity (tekan E selama 1.7 detik)
local function interactWithEntity(entity)
    if not entity then return end
    -- Cari proximity prompt di entity
    local prompt = entity:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        -- Simulasi hold E
        prompt:InputHold()
        wait(1.7)
        prompt:InputEnd()
    else
        -- Alternatif: coba cari di dalam mesh part
        for _, child in ipairs(entity:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                child:InputHold()
                wait(1.7)
                child:InputEnd()
                break
            end
        end
    end
end

-- Variabel untuk menyimpan state auto switches
local autoStates = {
    Secret = false,
    Celestial = false,
    OG = false,
    Divine = false,
    Event = false,
    CollectMoney = false,
    UpgradeAll = false
}

-- Urutan prioritas rarity
local rarityPriority = {"Event", "Divine", "OG", "Celestial", "Secret"}

-- Fungsi utama auto rarity
local function autoRarityLoop()
    while true do
        wait(0.5) -- cek setiap 0.5 detik
        local targetRarity = nil
        for _, rarity in ipairs(rarityPriority) do
            if autoStates[rarity] then
                targetRarity = rarity
                break
            end
        end
        if not targetRarity then
            wait(1)
            continue
        end

        -- Cari entity dengan rarity target
        local entity = findEntityByRarity(targetRarity)
        if entity then
            -- Cek apakah ada pemain lain dalam radius 3
            local entityPos = entity:GetPrimaryPartCFrame().Position or entity:FindFirstChildOfClass("MeshPart").Position
            if not isPlayerInRadius(entityPos, 3) then
                -- Teleport ke entity
                rootPart.CFrame = CFrame.new(entityPos)
                wait(0.5) -- tunggu sebentar
                -- Interaksi
                interactWithEntity(entity)
                -- Kembali ke base
                teleportToBase()
                -- Tunggu 1 detik sebelum loop berikutnya
                wait(1)
            else
                -- Ada pemain, coba cari entity lain dengan rarity yang sama atau prioritas berikutnya?
                -- Untuk sederhana, kita tunggu sebentar
                wait(1)
            end
        else
            wait(1)
        end
    end
end

-- Fungsi untuk Collect Money
local function collectMoneyLoop()
    while true do
        wait(0.5)
        if not autoStates.CollectMoney then
            wait(1)
            continue
        end

        -- Tentukan plot base berdasarkan posisi player saat ini
        local currentPos = rootPart.Position
        local plotBase = nil
        -- Koordinat FloorSpawn setiap plot (berdasarkan data)
        local floorSpawnCoords = {
            Vector3.new(123.879, 56, -117.25),
            Vector3.new(123.879, 56, -57.25),
            Vector3.new(123.879, 56, 2.75),
            Vector3.new(123.879, 56, 62.75),
            Vector3.new(123.879, 56, 122.75)
        }
        for i, coord in ipairs(floorSpawnCoords) do
            if (currentPos - coord).Magnitude < 5 then -- toleransi
                plotBase = i
                break
            end
        end

        if not plotBase then
            -- Jika tidak berada di base, mungkin perlu teleport ke base? Tapi tidak diinstruksikan.
            -- Kita asumsikan kita harus berada di base untuk mengumpulkan uang.
            wait(1)
            continue
        end

        -- Akses semua plot
        local plots = workspace:FindFirstChild("Plots")
        if not plots then
            wait(1)
            continue
        end

        -- Loop semua plot (1-5)
        for plotIndex = 1, 5 do
            local plot = plots:FindFirstChild(tostring(plotIndex))
            if plot then
                local floors = plot:FindFirstChild("Floors")
                if floors then
                    -- Loop semua floor (0-4)
                    for floorIndex = 0, 4 do
                        local floor = floors:FindFirstChild("Floor"..floorIndex)
                        if floor then
                            local stands = floor:FindFirstChild("Stands")
                            if stands then
                                -- Loop semua stand (1-10)
                                for standIndex = 1, 10 do
                                    local stand = stands:FindFirstChild(tostring(standIndex))
                                    if stand then
                                        local cashModel = stand:FindFirstChild("CashModel")
                                        if cashModel then
                                            local touchPart = cashModel:FindFirstChild("TouchPart")
                                            if touchPart then
                                                local touchInterest = touchPart:FindFirstChild("TouchInterest")
                                                if touchInterest then
                                                    -- Jika TouchInterest adalah RemoteEvent, fire
                                                    if touchInterest:IsA("RemoteEvent") then
                                                        touchInterest:FireServer()
                                                    elseif touchInterest:IsA("TouchTransmitter") then
                                                        -- Alternatif: simulasi touched dengan memindahkan part? Sulit.
                                                        -- Kita bisa coba memanggil method :Touch() jika ada
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(1) -- tunggu sebelum loop lagi
    end
end

-- Fungsi untuk Upgrade All
local function upgradeAllLoop()
    while true do
        wait(0.5)
        if not autoStates.UpgradeAll then
            wait(1)
            continue
        end

        -- Tentukan plot base (sama seperti collect money)
        local currentPos = rootPart.Position
        local plotBase = nil
        local floorSpawnCoords = {
            Vector3.new(123.879, 56, -117.25),
            Vector3.new(123.879, 56, -57.25),
            Vector3.new(123.879, 56, 2.75),
            Vector3.new(123.879, 56, 62.75),
            Vector3.new(123.879, 56, 122.75)
        }
        for i, coord in ipairs(floorSpawnCoords) do
            if (currentPos - coord).Magnitude < 5 then
                plotBase = i
                break
            end
        end

        if not plotBase then
            wait(1)
            continue
        end

        local plots = workspace:FindFirstChild("Plots")
        if not plots then
            wait(1)
            continue
        end

        for plotIndex = 1, 5 do
            local plot = plots:FindFirstChild(tostring(plotIndex))
            if plot then
                local floors = plot:FindFirstChild("Floors")
                if floors then
                    for floorIndex = 0, 4 do
                        local floor = floors:FindFirstChild("Floor"..floorIndex)
                        if floor then
                            local stands = floor:FindFirstChild("Stands")
                            if stands then
                                for standIndex = 1, 10 do
                                    local stand = stands:FindFirstChild(tostring(standIndex))
                                    if stand then
                                        local upgradeButton = stand:FindFirstChild("UpgradeButton")
                                        if upgradeButton then
                                            local template = upgradeButton:FindFirstChild("UpgradeButtonTemplate")
                                            if template then
                                                local imageButton = template:FindFirstChildOfClass("ImageButton")
                                                if imageButton then
                                                    -- Klik tombol
                                                    imageButton:Click()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(1)
    end
end

-- ==================================================
-- 9. MENAMBAHKAN ELEMEN UI
-- ==================================================

-- Container Slide: WalkSpeed
UI.AddSlider({
    Text = "Walkspeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(value)
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

-- Container Tombol
UI.AddButton({
    Text = "VIP",
    Callback = function()
        local paidArea = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Stages") and workspace.Map.Stages:FindFirstChild("PaidArea")
        if paidArea then
            paidArea:Destroy()
            print("PaidArea dihancurkan")
        else
            warn("PaidArea tidak ditemukan")
        end
    end
})

UI.AddButton({
    Text = "Remove Crushed",
    Callback = function()
        local crushers = workspace:FindFirstChild("Crushers")
        if crushers then crushers:Destroy() end
        local killCrushers = workspace:FindFirstChild("KillCrushers")
        if killCrushers then killCrushers:Destroy() end
        print("Crushers dihapus")
    end
})

UI.AddButton({
    Text = "Go To Base",
    Callback = function()
        teleportToBase()
    end
})

-- Container Switch
UI.AddSwitch({
    Text = "Auto Secret",
    Default = false,
    Callback = function(state)
        autoStates.Secret = state
    end
})

UI.AddSwitch({
    Text = "Auto Celestial",
    Default = false,
    Callback = function(state)
        autoStates.Celestial = state
    end
})

UI.AddSwitch({
    Text = "Auto OG",
    Default = false,
    Callback = function(state)
        autoStates.OG = state
    end
})

UI.AddSwitch({
    Text = "Auto Admin", -- Tidak ada logika, mungkin placeholder
    Default = false,
    Callback = function(state)
        -- Tidak ada implementasi
    end
})

UI.AddSwitch({
    Text = "Auto Exclusive", -- Placeholder
    Default = false,
    Callback = function(state)
    end
})

UI.AddSwitch({
    Text = "Auto Devine",
    Default = false,
    Callback = function(state)
        autoStates.Divine = state
    end
})

UI.AddSwitch({
    Text = "Auto Event",
    Default = false,
    Callback = function(state)
        autoStates.Event = state
    end
})

UI.AddSwitch({
    Text = "Collect Money",
    Default = false,
    Callback = function(state)
        autoStates.CollectMoney = state
    end
})

UI.AddSwitch({
    Text = "Upgrade All",
    Default = false,
    Callback = function(state)
        autoStates.UpgradeAll = state
    end
})

-- ==================================================
-- 10. MEMULAI LOOP UNTUK AUTO FITUR
-- ==================================================

-- Jalankan loop auto rarity di coroutine terpisah
coroutine.wrap(autoRarityLoop)()

-- Jalankan loop collect money
coroutine.wrap(collectMoneyLoop)()

-- Jalankan loop upgrade all
coroutine.wrap(upgradeAllLoop)()

-- ==================================================
-- 11. EXPOSE FUNGSI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI [Escape Getting Crushed For Brainrots] Library berhasil dimuat. Gunakan _G['" .. guiName .. "'] untuk menambahkan elemen.")
print("Contoh: _G['" .. guiName .. "'].AddButton({Text = 'Klik Saya', Callback = function() print('diklik') end})")
