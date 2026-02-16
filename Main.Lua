-- Script Profesional untuk Delta Executor
-- GUI: Escape Tsunami For Phones (Versi Final dengan Drag dan Instant Collect yang diperbaiki)

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local localPlayer = players.LocalPlayer
local guiName = "EscapeTsunamiGUI"

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

-- Frame utama dengan ukuran tetap
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
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

-- Sudut header
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Judul
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Escape Tsunami For Phones"
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
-- 5. MEMBUAT KONTEN DALAM SCROLLINGFRAME
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

-- Mulai menempatkan konten
local yOffset = 0
local spacing = 5

-- Walkspeed Slider
createLabel("Walkspeed", yOffset)
yOffset = yOffset + 25 + spacing

-- Slider background
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 200, 0, 10)
sliderBg.Position = UDim2.new(0, 0, 0, yOffset)
sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = scrollingFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = sliderBg

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 15, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBg

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 4)
sliderButtonCorner.Parent = sliderButton

local wsValue = Instance.new("TextLabel")
wsValue.Size = UDim2.new(0, 50, 0, 25)
wsValue.Position = UDim2.new(0, 210, 0, yOffset)
wsValue.BackgroundTransparency = 1
wsValue.Text = "30"
wsValue.TextColor3 = Color3.fromRGB(255, 255, 255)
wsValue.TextScaled = true
wsValue.Font = Enum.Font.GothamBold
wsValue.Parent = scrollingFrame

yOffset = yOffset + 30 + spacing

-- Tombol VIP, Hapus Wave, Stop Loop
local vipBtn = createButton("VIP", yOffset, Color3.fromRGB(128, 0, 128))
yOffset = yOffset + 45 + spacing

local waveBtn = createButton("Hapus Wave", yOffset)
yOffset = yOffset + 45 + spacing

local stopBtn = createButton("Stop Loop", yOffset)
yOffset = yOffset + 45 + spacing * 2

-- Switch
local collectToggle = createSwitch("Instan Collect", yOffset)
yOffset = yOffset + 30 + spacing

local proxToggle = createSwitch("Instant Proximity", yOffset)
yOffset = yOffset + 30 + spacing

-- Set CanvasSize
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- ==================================================
-- 6. FUNGSIONALITAS WALKSPEED SLIDER
-- ==================================================
local minSpeed = 30
local maxSpeed = 200
local currentSpeed = 30

local function getCharacter()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
end

local function updateWalkspeed(value)
    value = math.clamp(value, minSpeed, maxSpeed)
    currentSpeed = value
    wsValue.Text = tostring(math.floor(value))
    local char = getCharacter()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
    local percent = (value - minSpeed) / (maxSpeed - minSpeed)
    sliderButton.Position = UDim2.new(percent, -7, 0.5, -10)
end

updateWalkspeed(30)

local sliderDragging = false
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)

sliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

userInput.InputChanged:Connect(function(input)
    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = userInput:GetMouseLocation()
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local relativeX = mousePos.X - absPos.X
        local percent = math.clamp(relativeX / absSize.X, 0, 1)
        local newSpeed = minSpeed + (maxSpeed - minSpeed) * percent
        updateWalkspeed(newSpeed)
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateWalkspeed(currentSpeed)
end)

-- ==================================================
-- 7. FUNGSIONALITAS TOMBOL VIP
-- ==================================================
vipBtn.MouseButton1Click:Connect(function()
    local vipWalls = workspace:FindFirstChild("VIPWalls")
    if vipWalls then
        vipWalls:Destroy()
        print("[VIP] VIPWalls dihapus")
    else
        print("[VIP] VIPWalls tidak ditemukan")
    end
    vipBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    task.wait(0.2)
    vipBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
end)

-- ==================================================
-- 8. FUNGSIONALITAS WAVE LOOP
-- ==================================================
local targetNames = {
    "SuperSlow", "Slow", "Medium", "Fast", "SuperFast", "Lightning"
}

local waveConnection = nil

local function deleteExistingModels()
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            if table.find(targetNames, child.Name) then
                child:Destroy()
            end
            if child.Name:upper():find("GOD") then
                child:Destroy()
            end
        end
    end
end

local function onChildAdded(child)
    if child:IsA("Model") then
        if table.find(targetNames, child.Name) or child.Name:upper():find("GOD") then
            child:Destroy()
        end
    end
end

waveBtn.MouseButton1Click:Connect(function()
    deleteExistingModels()
    if not waveConnection then
        waveConnection = workspace.ChildAdded:Connect(onChildAdded)
    end
    waveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    task.wait(0.2)
    waveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

stopBtn.MouseButton1Click:Connect(function()
    if waveConnection then
        waveConnection:Disconnect()
        waveConnection = nil
    end
    stopBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    task.wait(0.2)
    stopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- ==================================================
-- 9. FUNGSIONALITAS SWITCH
-- ==================================================
local collectEnabled = false
local proxEnabled = false
local collectConnection = nil
local proxConnections = {}

-- Instant Collect: ketika model masuk ke CarryPart, pindahkan ke CollectWall
local function setCollectEnabled(state)
    collectEnabled = state
    if state then
        local playerName = localPlayer.Name
        local carryPart = workspace:FindFirstChild(playerName) and workspace[playerName]:FindFirstChild("CarryPart")
        local collectWall = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Collect") and workspace.Map.Collect:FindFirstChild("CollectWall")
        
        if carryPart and collectWall then
            collectConnection = carryPart.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    print("[Instant Collect] Model detected in CarryPart: " .. child.Name)
                    local primary = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        child:SetPrimaryPartCFrame(collectWall.CFrame)
                        print("[Instant Collect] Model moved to CollectWall")
                    else
                        warn("[Instant Collect] No BasePart found in model")
                    end
                end
            end)
            print("[Instant Collect] Activated")
        else
            warn("[Instant Collect] CarryPart or CollectWall not found. Check paths.")
        end
    else
        if collectConnection then
            collectConnection:Disconnect()
            collectConnection = nil
            print("[Instant Collect] Deactivated")
        end
    end
end

-- Instant Proximity: set HoldDuration semua ProximityPrompt jadi 0
local function setProxEnabled(state)
    proxEnabled = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        local conn = workspace.DescendantAdded:Connect(function(desc)
            if desc:IsA("ProximityPrompt") then
                desc.HoldDuration = 0
            end
        end)
        table.insert(proxConnections, conn)
        print("[Instant Proximity] Activated")
    else
        for _, conn in ipairs(proxConnections) do
            conn:Disconnect()
        end
        proxConnections = {}
        print("[Instant Proximity] Deactivated")
    end
end

collectToggle.MouseButton1Click:Connect(function()
    collectEnabled = not collectEnabled
    setCollectEnabled(collectEnabled)
    if collectEnabled then
        collectToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        collectToggle.Text = "ON"
    else
        collectToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        collectToggle.Text = "OFF"
    end
end)

proxToggle.MouseButton1Click:Connect(function()
    proxEnabled = not proxEnabled
    setProxEnabled(proxEnabled)
    if proxEnabled then
        proxToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        proxToggle.Text = "ON"
    else
        proxToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        proxToggle.Text = "OFF"
    end
end)

-- ==================================================
-- 10. DRAG HEADER (diperbaiki)
-- ==================================================
local dragging = false
local dragInput
local dragStart
local startPos

-- Fungsi untuk memulai drag
local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
end

-- Fungsi untuk mengupdate posisi
local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

-- Fungsi untuk mengakhiri drag
local function stopDrag()
    dragging = false
end

-- Deteksi input di header
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Cek apakah target bukan tombol minimize/close
        local target = input.Target
        if target ~= minimizeBtn and target ~= closeBtn then
            startDrag(input)
        end
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDrag()
    end
end)

-- Juga tangani jika mouse meninggalkan header (opsional)
header.MouseLeave:Connect(function()
    stopDrag()
end)

-- ==================================================
-- 11. MINIMIZE ANIMASI
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
-- 12. CLOSE
-- ==================================================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================================================
-- 13. DEBUG: Cetak path untuk Instant Collect
-- ==================================================
print("=== Path Check ===")
local playerName = localPlayer.Name
local carryPart = workspace:FindFirstChild(playerName) and workspace[playerName]:FindFirstChild("CarryPart")
local collectWall = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Collect") and workspace.Map.Collect:FindFirstChild("CollectWall")
print("CarryPart found:", carryPart ~= nil)
print("CollectWall found:", collectWall ~= nil)
print("==================")

-- ==================================================
-- SELESAI
-- ==================================================
print("GUI Escape Tsunami For Phones berhasil dimuat. Drag header berfungsi.")
