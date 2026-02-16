-- Script untuk Delta Executor
-- GUI: Escape Tsunami For Phones dengan fitur lengkap

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

-- Frame utama (lebih lebar, semua sudut melengkung)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 280)  -- Lebar 400, tinggi menyesuaikan konten nanti
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.ClipsDescendants = true

-- Sudut melengkung untuk semua sisi
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- ===========================================
-- HEADER (lebih pendek: 30px, tanpa ikon, hanya judul dan tombol)
-- ===========================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -10, 0, 30)  -- Tinggi 30 (3/4 dari 40)
header.Position = UDim2.new(0, 5, 0, 5)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)  -- Beri ruang untuk tombol
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Escape Tsunami For Phones"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol Minimize (—) dengan background transparan
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

-- Tombol Close (X) dengan background transparan
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
-- KONTEN UTAMA (akan dianimasikan saat minimize)
-- ===========================================
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 0, 230)  -- Tinggi total konten
contentContainer.Position = UDim2.new(0, 10, 0, 45)  -- Di bawah header
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
contentContainer.ClipsDescendants = true

-- ===========================================
-- 1. SLIDER WALKSPEED
-- ===========================================
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, 0, 0, 50)
sliderContainer.Position = UDim2.new(0, 0, 0, 0)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = contentContainer

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0, 100, 1, 0)
wsLabel.Position = UDim2.new(0, 0, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Walkspeed"
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.TextScaled = true
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = sliderContainer

-- Slider sederhana (Frame dengan button yang bisa digeser)
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0, 200, 0, 10)
sliderBg.Position = UDim2.new(0, 110, 0.5, -5)
sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = sliderContainer

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = sliderBg

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 15, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBg

local sliderCorner2 = Instance.new("UICorner")
sliderCorner2.CornerRadius = UDim.new(0, 4)
sliderCorner2.Parent = sliderButton

local wsValue = Instance.new("TextLabel")
wsValue.Size = UDim2.new(0, 50, 1, 0)
wsValue.Position = UDim2.new(0, 320, 0, 0)
wsValue.BackgroundTransparency = 1
wsValue.Text = "30"
wsValue.TextColor3 = Color3.fromRGB(0, 255, 0)
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
    -- Posisi slider button
    local percent = (value - minSpeed) / (maxSpeed - minSpeed)
    sliderButton.Position = UDim2.new(percent, -7, 0.5, -10)  -- -7 agar center
end

updateWalkspeed(30)

-- Drag slider
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
-- 2. TOMBOL UTAMA (VIP, Hapus Wave, Stop Loop)
-- ===========================================
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 160)  -- 3 tombol masing2 50, spasi 10
buttonContainer.Position = UDim2.new(0, 0, 0, 60)  -- di bawah slider
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = contentContainer

-- Fungsi untuk membuat tombol
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
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

-- Tombol VIP
local vipBtn = createButton("VIP", 0, Color3.fromRGB(128, 0, 128))
-- Tombol Hapus Wave
local waveBtn = createButton("Hapus Wave", 55, Color3.fromRGB(40, 40, 40))
-- Tombol Stop Loop
local stopBtn = createButton("Stop Loop", 110, Color3.fromRGB(40, 40, 40))

-- ===========================================
-- 3. SWITCH CONTAINER (Instan Collect, Instant Proximity)
-- ===========================================
local switchContainer = Instance.new("Frame")
switchContainer.Size = UDim2.new(1, 0, 0, 70)
switchContainer.Position = UDim2.new(0, 0, 0, 230)  -- di bawah tombol
switchContainer.BackgroundTransparency = 1
switchContainer.Parent = contentContainer

-- Fungsi membuat switch toggle
local function createSwitch(text, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = switchContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
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
    toggleBtn.Position = UDim2.new(0, 160, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    
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
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        -- Panggil fungsi sesuai switch
        if text == "Instan Collect" then
            toggleInstantCollect(state)
        elseif text == "Instant Proximity" then
            toggleInstantProximity(state)
        end
    end)
    
    return toggleBtn, function() return state end
end

local collectSwitch, getCollectState = createSwitch("Instan Collect", 0)
local proxSwitch, getProxState = createSwitch("Instant Proximity", 35)

-- ===========================================
-- FUNGSIONALITAS SWITCH
-- ===========================================
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local userInput = game:GetService("UserInputService")

-- Variabel untuk koneksi
local collectConnection = nil
local proxConnection = nil

-- Fungsi untuk Instant Collect
local function toggleInstantCollect(enabled)
    if enabled then
        -- Cari CarryPart dan CollectWall
        local playerName = localPlayer.Name
        local carryPart = workspace:FindFirstChild(playerName) and workspace[playerName]:FindFirstChild("CarryPart")
        local collectWall = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Collect") and workspace.Map.Collect:FindFirstChild("CollectWall")
        
        if carryPart and collectWall then
            collectConnection = carryPart.ChildAdded:Connect(function(child)
                if child:IsA("Model") then
                    -- Pindahkan model ke posisi CollectWall agar terkena TouchInterest
                    child:SetPrimaryPartCFrame(collectWall.CFrame)
                    -- Atau langsung destroy (jika game menghapus saat terkoleksi)
                    -- child:Destroy()
                    print("Instant Collect: Model dipindahkan ke CollectWall")
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

-- Fungsi untuk Instant Proximity (ambil item dari jarak jauh dengan tekan E)
local function toggleInstantProximity(enabled)
    if enabled then
        proxConnection = userInput.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.E then
                -- Cari ActiveThings folder
                local activeThings = workspace:FindFirstChild("ActiveThings")
                if not activeThings then return end
                
                -- Cari model terdekat dengan player
                local character = localPlayer.Character
                if not character then return end
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                local closestDist = math.huge
                local closestModel = nil
                for _, model in ipairs(activeThings:GetChildren()) do
                    if model:IsA("Model") then
                        local prim = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                        if prim then
                            local dist = (prim.Position - root.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestModel = model
                            end
                        end
                    end
                end
                
                if closestModel then
                    -- Pindahkan ke CollectWall atau langsung koleksi
                    local collectWall = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Collect") and workspace.Map.Collect:FindFirstChild("CollectWall")
                    if collectWall then
                        closestModel:SetPrimaryPartCFrame(collectWall.CFrame)
                        print("Instant Proximity: Model dipindahkan ke CollectWall")
                    else
                        closestModel:Destroy()
                        print("Instant Proximity: Model dihancurkan (asumsi terkoleksi)")
                    end
                end
            end
        end)
    else
        if proxConnection then
            proxConnection:Disconnect()
            proxConnection = nil
        end
    end
end

-- ===========================================
-- FUNGSIONALITAS TOMBOL
-- ===========================================
-- Tombol VIP: hapus folder VIPWalls
vipBtn.MouseButton1Click:Connect(function()
    local vipWalls = workspace:FindFirstChild("VIPWalls")
    if vipWalls then
        vipWalls:Destroy()
        print("VIPWalls dihapus")
    else
        print("VIPWalls tidak ditemukan")
    end
end)

-- Daftar nama target untuk Wave Loop
local targetNames = {
    "SuperSlow", "Slow", "Medium", "Fast", "SuperFast", "Lightning"
    -- Tambahkan "God" untuk model yang mengandung kata God di Workspace langsung
}

local waveConnection = nil

local function deleteExistingModels()
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            -- Cek apakah nama child termasuk dalam targetNames
            if table.find(targetNames, child.Name) then
                child:Destroy()
            end
            -- Cek juga jika nama mengandung "God" (case insensitive)
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
    -- Feedback visual
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
-- DRAG HEADER
-- ===========================================
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

-- ===========================================
-- MINIMIZE ANIMASI (tinggi mainFrame menyusut)
-- ===========================================
local TweenService = game:GetService("TweenService")
local isMinimized = false
local originalMainHeight = mainFrame.Size.Y.Offset
local originalContentHeight = contentContainer.Size.Y.Offset
local minimizedMainHeight = 45  -- Header (30) + padding atas/bawah

local function toggleMinimize()
    if isMinimized then
        -- Maximize
        local tweenMain = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, originalMainHeight)})
        local tweenContent = TweenService:Create(contentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, originalContentHeight)})
        tweenMain:Play()
        tweenContent:Play()
    else
        -- Minimize
        local tweenMain = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, minimizedMainHeight)})
        local tweenContent = TweenService:Create(contentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
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
-- INITIAL SETUP
-- ===========================================
print("GUI Escape Tsunami For Phones berhasil dimuat")
