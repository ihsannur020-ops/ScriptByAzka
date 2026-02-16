-- Script UI untuk Delta Executor
-- GUI: Survive LAVA for Brainrots (dengan fitur lengkap)
-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")

local localPlayer = players.LocalPlayer
local guiName = "SurviveLAVAforBrainrots_ScriptByAzka.UI_Utama"

-- Hapus GUI lama jika ada
if coreGui:FindFirstChild(guiName) then
    coreGui:FindFirstChild(guiName):Destroy()
end

-- Variabel global untuk fitur
local proxEnabled = false
local proxConnections = {}
local currentWalkSpeed = 30  -- default

-- ==================================================
-- 2. MEMBUAT ELEMEN DASAR GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama dengan ukuran tetap
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 380)  -- sedikit lebih tinggi untuk 2 tombol + 1 switch
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
mainFrame.Active = true

-- Sudut melengkung
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- ==================================================
-- 3. HEADER (dapat digeser)
-- ==================================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -10, 0, 30)
header.Position = UDim2.new(0, 5, 0, 5)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Judul (diubah)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Survive LAVA for Brainrots"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Tombol Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

-- ==================================================
-- 4. SCROLLING FRAME UNTUK KONTEN
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

-- ==================================================
-- 5. FUNGSI PEMBUAT ELEMEN
-- ==================================================
local function createLabel(text, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = scrollingFrame
    return label
end

local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = scrollingFrame
    btn.AutoButtonColor = true
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

local function createSwitch(text, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = scrollingFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = container
    toggle.AutoButtonColor = true
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggle
    
    return toggle
end

-- ==================================================
-- 6. MEMBUAT KONTEN SESUAI PERMINTAAN
-- ==================================================
local yOffset = 0
local spacing = 5

-- [Container Slide] Walkspeed
createLabel("Walkspeed", yOffset)
yOffset = yOffset + 25 + spacing

-- Container untuk slider dan angka
local sliderRow = Instance.new("Frame")
sliderRow.Size = UDim2.new(1, 0, 0, 30)
sliderRow.Position = UDim2.new(0, 0, 0, yOffset)
sliderRow.BackgroundTransparency = 1
sliderRow.Parent = scrollingFrame

-- Slider background
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 200, 0, 10)
sliderBg.Position = UDim2.new(0, 0, 0.5, -5)
sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = sliderRow

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = sliderBg

-- Tombol slider (yang bisa digeser)
local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 15, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)  -- Awal di 0
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBg
sliderButton.AutoButtonColor = false

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 4)
sliderButtonCorner.Parent = sliderButton

-- Label nilai walkspeed
local wsValueLabel = Instance.new("TextLabel")
wsValueLabel.Size = UDim2.new(0, 50, 1, 0)
wsValueLabel.Position = UDim2.new(0, 210, 0, 0)
wsValueLabel.BackgroundTransparency = 1
wsValueLabel.Text = "30"
wsValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsValueLabel.TextScaled = true
wsValueLabel.Font = Enum.Font.GothamBold
wsValueLabel.Parent = sliderRow

yOffset = yOffset + 30 + spacing

-- [Container Tombol] VIP dan Nonaktif Lava
local vipBtn = createButton("VIP", yOffset, Color3.fromRGB(255, 255, 0))  -- Kuning
yOffset = yOffset + 45 + spacing

local nonaktifLavaBtn = createButton("Nonaktif Lava", yOffset, Color3.fromRGB(255, 140, 0))  -- Oranye
yOffset = yOffset + 45 + spacing * 2

-- [Container Switch] Instant Proximity
local proxToggle = createSwitch("Instant Proximity", yOffset)
yOffset = yOffset + 30 + spacing

-- Set CanvasSize
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- ==================================================
-- 7. FUNGSIONALITAS SLIDER WALKSPEED
-- ==================================================
local minSpeed = 30
local maxSpeed = 300
local sliderWidth = 200
local draggingSlider = false

-- Fungsi mengatur walkspeed karakter
local function setWalkSpeed(value)
    currentWalkSpeed = value
    wsValueLabel.Text = tostring(math.floor(value))
    local char = localPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

-- Update posisi slider berdasarkan nilai
local function updateSliderPosition(value)
    local percent = (value - minSpeed) / (maxSpeed - minSpeed)
    local xPos = percent * (sliderWidth - sliderButton.AbsoluteSize.X)
    sliderButton.Position = UDim2.new(0, xPos, 0.5, -10)
end

-- Hitung nilai dari posisi mouse
local function getValueFromMouse(input)
    local absPos = sliderBg.AbsolutePosition
    local x = input.Position.X - absPos.X
    -- Batasi
    x = math.clamp(x, 0, sliderWidth - sliderButton.AbsoluteSize.X)
    local percent = x / (sliderWidth - sliderButton.AbsoluteSize.X)
    local value = minSpeed + (maxSpeed - minSpeed) * percent
    return math.floor(value)
end

-- Event drag slider
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

userInput.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local value = getValueFromMouse(input)
        setWalkSpeed(value)
        updateSliderPosition(value)
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

-- Set default
setWalkSpeed(30)
updateSliderPosition(30)

-- Update saat karakter respawn
local function onCharacterAdded(char)
    repeat wait() until char:FindFirstChild("Humanoid")
    setWalkSpeed(currentWalkSpeed)
end
localPlayer.CharacterAdded:Connect(onCharacterAdded)
if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

-- ==================================================
-- 8. FUNGSI TOMOL VIP (Hapus VIPDoors)
-- ==================================================
vipBtn.MouseButton1Click:Connect(function()
    local vipFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VIPDoors")
    if vipFolder then
        vipFolder:Destroy()
        print("VIPDoors telah dihapus")
    else
        print("Folder VIPDoors tidak ditemukan")
    end
end)

-- ==================================================
-- 9. FUNGSI TOMOL NONAKTIF LAVA (Hapus Lavas)
-- ==================================================
nonaktifLavaBtn.MouseButton1Click:Connect(function()
    local lavaFolder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Lavas")
    if lavaFolder then
        lavaFolder:Destroy()
        print("Lavas telah dihapus")
    else
        print("Folder Lavas tidak ditemukan")
    end
end)

-- ==================================================
-- 10. FUNGSI SWITCH INSTANT PROXIMITY
-- ==================================================
local function setProxEnabled(state)
    proxEnabled = state
    if state then
        -- Terapkan ke semua ProximityPrompt yang sudah ada
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        -- Pantau descendant baru
        local conn = workspace.DescendantAdded:Connect(function(desc)
            if desc:IsA("ProximityPrompt") then
                desc.HoldDuration = 0
            end
        end)
        table.insert(proxConnections, conn)
        proxToggle.Text = "ON"
        proxToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        print("[Instant Proximity] Activated")
    else
        -- Putuskan semua koneksi
        for _, conn in ipairs(proxConnections) do
            conn:Disconnect()
        end
        proxConnections = {}
        proxToggle.Text = "OFF"
        proxToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        print("[Instant Proximity] Deactivated")
    end
end

proxToggle.MouseButton1Click:Connect(function()
    setProxEnabled(not proxEnabled)
end)

-- Inisialisasi dalam keadaan OFF
setProxEnabled(false)

-- ==================================================
-- 11. FUNGSIONALITAS DRAG HEADER
-- ==================================================
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ==================================================
-- 12. MINIMIZE ANIMASI
-- ==================================================
local isMinimized = false
local originalHeight = mainFrame.Size.Y.Offset
local minimizedHeight = 45

local function animateMinimize()
    if isMinimized then
        scrollingFrame.Visible = true
        tweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, originalHeight)}):Play()
    else
        scrollingFrame.Visible = false
        tweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, minimizedHeight)}):Play()
    end
    isMinimized = not isMinimized
end

minimizeBtn.MouseButton1Click:Connect(animateMinimize)

-- ==================================================
-- 13. CLOSE
-- ==================================================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    -- Matikan koneksi proximity jika aktif
    if proxEnabled then
        setProxEnabled(false)
    end
end)

-- ==================================================
-- SELESAI
-- ==================================================
print("GUI Survive LAVA for Brainrots (dengan fitur lengkap) berhasil dimuat.")
