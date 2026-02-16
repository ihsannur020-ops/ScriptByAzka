-- Script untuk Delta Executor
-- GUI: Escape Tsunami For Phones (Versi Perbaikan dengan Scroll dan Tombol Fungsional)

-- ===========================================
-- HAPUS GUI LAMA JIKA ADA
-- ===========================================
local coreGui = game:GetService("CoreGui")
local guiName = "EscapeTsunamiGUI"
local existing = coreGui:FindFirstChild(guiName)
if existing then existing:Destroy() end

-- ===========================================
-- BUAT GUI BARU
-- ===========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama (lebar 300)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.ClipsDescendants = true

-- Sudut melengkung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- ===========================================
-- HEADER (tinggi 30, tanpa ikon)
-- ===========================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -10, 0, 30)
header.Position = UDim2.new(0, 5, 0, 5)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Escape Tsunami For Phones"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol Minimize (transparan)
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

-- Tombol Close (transparan)
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

-- ===========================================
-- SCROLLING KONTEN (menggantikan contentContainer)
-- ===========================================
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -55)  -- sisakan ruang untuk header
scrollingFrame.Position = UDim2.new(0, 10, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 340)  -- total tinggi konten + spasi
scrollingFrame.Parent = mainFrame
scrollingFrame.ClipsDescendants = true

-- ===========================================
-- 1. SLIDER WALKSPEED
-- ===========================================
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, 0, 0, 70)
sliderContainer.Position = UDim2.new(0, 0, 0, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = scrollingFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, 0, 0, 25)
wsLabel.Position = UDim2.new(0, 0, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Walkspeed"
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.TextScaled = true
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = sliderContainer

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 200, 0, 10)
sliderBg.Position = UDim2.new(0, 0, 0, 35)
sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = sliderContainer

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

local sliderCorner2 = Instance.new("UICorner")
sliderCorner2.CornerRadius = UDim.new(0, 4)
sliderCorner2.Parent = sliderButton

local wsValue = Instance.new("TextLabel")
wsValue.Size = UDim2.new(0, 50, 0, 25)
wsValue.Position = UDim2.new(0, 210, 0, 30)
wsValue.BackgroundTransparency = 1
wsValue.Text = "30"
wsValue.TextColor3 = Color3.fromRGB(255, 255, 255)
wsValue.TextScaled = true
wsValue.Font = Enum.Font.GothamBold
wsValue.Parent = sliderContainer

-- Logika slider
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local minSpeed = 30
local maxSpeed = 200
local currentSpeed = 30

local function updateWalkspeed(value)
    value = math.clamp(value, minSpeed, maxSpeed)
    currentSpeed = value
    wsValue.Text = tostring(math.floor(value))
    if humanoid then
        humanoid.WalkSpeed = value
    end
    local percent = (value - minSpeed) / (maxSpeed - minSpeed)
    sliderButton.Position = UDim2.new(percent, -7, 0.5, -10)
end

updateWalkspeed(30)

local dragging = false
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

sliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local relativeX = mousePos.X - absPos.X
        local percent = math.clamp(relativeX / absSize.X, 0, 1)
        local newSpeed = minSpeed + (maxSpeed - minSpeed) * percent
        updateWalkspeed(newSpeed)
    end
end)

-- ===========================================
-- 2. TOMBOL UTAMA
-- ===========================================
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 160)
buttonContainer.Position = UDim2.new(0, 0, 0, 80)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = scrollingFrame

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
    btn.Parent = buttonContainer
    btn.ZIndex = 5
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

local vipBtn = createButton("VIP", 0, Color3.fromRGB(128, 0, 128))
local waveBtn = createButton("Hapus Wave", 55, Color3.fromRGB(40, 40, 40))
local stopBtn = createButton("Stop Loop", 110, Color3.fromRGB(40, 40, 40))

-- ===========================================
-- 3. SWITCH CONTAINER
-- ===========================================
local switchContainer = Instance.new("Frame")
switchContainer.Size = UDim2.new(1, 0, 0, 70)
switchContainer.Position = UDim2.new(0, 0, 0, 250)
switchContainer.BackgroundTransparency = 1
switchContainer.Parent = scrollingFrame

-- Fungsi membuat switch dengan tombol di pojok kanan
local function createSwitch(text, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = switchContainer
    
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
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)  -- pojok kanan
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    toggleBtn.ZIndex = 5
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local state = false
    local function updateToggle()
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleBtn.Text = "OFF"
        end
    end
    updateToggle()
    
    return toggleBtn, function() return state end
end

local collectToggle, getCollectState = createSwitch("Instan Collect", 0)
local proxToggle, getProxState = createSwitch("Instant Proximity", 35)

-- ===========================================
-- FUNGSIONALITAS SWITCH
-- ===========================================
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local collectionService = game:GetService("CollectionService")

local collectConnection = nil
local proxConnections = {}

local function toggleInstantCollect(enabled)
    if enabled then
        local playerName = localPlayer.Name
        local carryPart = workspace:FindFirstChild(playerName) and workspace[playerName]:FindFirstChild("CarryPart")
        local collectWall = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Collect") and workspace.Map.Collect:FindFirstChild("CollectWall")
        
        if carryPart and collectWall then
            collectConnection = carryPart.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    local primary = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        child:SetPrimaryPartCFrame(collectWall.CFrame)
                        print("Instant Collect: Model dipindahkan ke CollectWall")
                    end
                end
            end)
        else
            warn("CarryPart atau CollectWall tidak ditemukan")
        end
    else
        if collectConnection then
            collectConnection:Disconnect()
            collectConnection = nil
        end
    end
end

local function setAllProximityPrompts(value)
    for _, obj in ipairs(collectionService:GetTagged("ProximityPrompt")) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = value
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = value
        end
    end
end

local function toggleInstantProximity(enabled)
    if enabled then
        setAllProximityPrompts(0)
        local conn = workspace.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("ProximityPrompt") then
                descendant.HoldDuration = 0
            end
        end)
        table.insert(proxConnections, conn)
    else
        for _, conn in ipairs(proxConnections) do
            conn:Disconnect()
        end
        proxConnections = {}
    end
end

collectToggle.MouseButton1Click:Connect(function()
    local state = getCollectState()
    state = not state
    -- Simpan state secara manual karena closure getCollectState tidak mutable
    -- Kita akan gunakan atribut State pada tombol
    collectToggle.State = state
    if state then
        collectToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        collectToggle.Text = "ON"
    else
        collectToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        collectToggle.Text = "OFF"
    end
    toggleInstantCollect(state)
end)

proxToggle.MouseButton1Click:Connect(function()
    local state = proxToggle.State or false
    state = not state
    proxToggle.State = state
    if state then
        proxToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        proxToggle.Text = "ON"
    else
        proxToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        proxToggle.Text = "OFF"
    end
    toggleInstantProximity(state)
end)

collectToggle.State = false
proxToggle.State = false

-- ===========================================
-- TOMBOL VIP
-- ===========================================
vipBtn.MouseButton1Click:Connect(function()
    local vipWalls = workspace:FindFirstChild("VIPWalls")
    if vipWalls then
        vipWalls:Destroy()
        print("VIPWalls dihapus")
    else
        print("VIPWalls tidak ditemukan")
    end
end)

-- ===========================================
-- TOMBOL WAVE LOOP
-- ===========================================
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

-- ===========================================
-- DRAG HEADER (hanya jika klik di area non-tombol)
-- ===========================================
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Cek apakah yang diklik adalah header sendiri (bukan tombol)
        local target = input.Target
        if target == header or target == title or target == icon then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
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

-- ===========================================
-- MINIMIZE ANIMASI
-- ===========================================
local TweenService = game:GetService("TweenService")
local isMinimized = false
local originalMainHeight = mainFrame.Size.Y.Offset
local originalContentHeight = scrollingFrame.Size.Y.Offset
local minimizedMainHeight = 45

local function toggleMinimize()
    if isMinimized then
        local tweenMain = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, originalMainHeight)})
        local tweenContent = TweenService:Create(scrollingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 1, -55)})
        tweenMain:Play()
        tweenContent:Play()
    else
        local tweenMain = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, minimizedMainHeight)})
        local tweenContent = TweenService:Create(scrollingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
        tweenMain:Play()
        tweenContent:Play()
    end
    isMinimized = not isMinimized
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- ===========================================
-- CLOSE
-- ===========================================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===========================================
-- SELESAI
-- ===========================================
print("GUI Escape Tsunami For Phones berhasil dimuat dengan perbaikan")
