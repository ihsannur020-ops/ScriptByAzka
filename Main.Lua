--[[
    Azka UI - Kustom UI seperti Kavo
    Dibuat oleh Azka
    Fitur: Drag, Minimize (kotak ☰), Close, Menu Slide, WalkSpeed slider, Inf Jump, Noclip
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Hapus UI lama jika ada
local existing = CoreGui:FindFirstChild("AzkaUI")
if existing then existing:Destroy() end

-- Buat ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AzkaUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

-- Variabel state
local isMinimized = false
local wsValue = 30
local infJumpEnabled = false
local noclipEnabled = false
local draggingSlider = false

-- ====================== PANEL UTAMA ======================
local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(600, 450)
panel.Position = UDim2.new(0.5, -300, 0.4, -225)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)  -- solid
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui

-- Sudut membulat
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

-- Stroke border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(80, 120, 255)
stroke.Parent = panel

-- ====================== TITLE BAR ======================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Judul
local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "Script BY Azka"
titleLabel.Parent = titleBar

-- Tombol Minimize ( - )
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(30, 24)
minBtn.Position = UDim2.new(1, -70, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 180)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.AutoButtonColor = false
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- Tombol Close ( X )
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30, 24)
closeBtn.Position = UDim2.new(1, -36, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- ====================== PANEL KIRI (MENU) ======================
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.fromOffset(130, 380)
leftPanel.Position = UDim2.fromOffset(10, 46)
leftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = panel

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 10)
leftCorner.Parent = leftPanel

-- Tombol Main
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -20, 0, 40)
mainBtn.Position = UDim2.fromOffset(10, 10)
mainBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 200)  -- aktif pertama
mainBtn.Text = "Main"
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 16
mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.AutoButtonColor = false
mainBtn.Parent = leftPanel

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainBtn

-- Tombol Teleport
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.fromOffset(10, 60)
tpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
tpBtn.Text = "Teleport"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.AutoButtonColor = false
tpBtn.Parent = leftPanel

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn

-- Tombol Setting
local settingBtn = Instance.new("TextButton")
settingBtn.Size = UDim2.new(1, -20, 0, 40)
settingBtn.Position = UDim2.fromOffset(10, 110)
settingBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
settingBtn.Text = "Setting"
settingBtn.Font = Enum.Font.GothamBold
settingBtn.TextSize = 16
settingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingBtn.AutoButtonColor = false
settingBtn.Parent = leftPanel

local settingCorner = Instance.new("UICorner")
settingCorner.CornerRadius = UDim.new(0, 8)
settingCorner.Parent = settingBtn

-- Garis pemisah vertikal
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.fromOffset(2, 350)
divider.Position = UDim2.fromOffset(145, 50)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BorderSizePixel = 0
divider.Parent = panel

-- ====================== PANEL KANAN (KONTEN) ======================
local contentPanel = Instance.new("Frame")
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.fromOffset(430, 380)
contentPanel.Position = UDim2.fromOffset(155, 46)
contentPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
contentPanel.BorderSizePixel = 0
contentPanel.Parent = panel

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentPanel

-- Konten Main
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, -20, 1, -20)
mainContent.Position = UDim2.fromOffset(10, 10)
mainContent.BackgroundTransparency = 1
mainContent.Visible = true
mainContent.Parent = contentPanel

-- Konten Teleport (placeholder)
local tpContent = Instance.new("Frame")
tpContent.Name = "TeleportContent"
tpContent.Size = UDim2.new(1, -20, 1, -20)
tpContent.Position = UDim2.fromOffset(10, 10)
tpContent.BackgroundTransparency = 1
tpContent.Visible = false
tpContent.Parent = contentPanel

local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(1, 0, 1, 0)
tpLabel.BackgroundTransparency = 1
tpLabel.Text = "Menu Teleport\n(Coming Soon)"
tpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 18
tpLabel.TextWrapped = true
tpLabel.Parent = tpContent

-- Konten Setting (placeholder)
local settingContent = Instance.new("Frame")
settingContent.Name = "SettingContent"
settingContent.Size = UDim2.new(1, -20, 1, -20)
settingContent.Position = UDim2.fromOffset(10, 10)
settingContent.BackgroundTransparency = 1
settingContent.Visible = false
settingContent.Parent = contentPanel

local settingLabel = Instance.new("TextLabel")
settingLabel.Size = UDim2.new(1, 0, 1, 0)
settingLabel.BackgroundTransparency = 1
settingLabel.Text = "Menu Setting\n(Coming Soon)"
settingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
settingLabel.Font = Enum.Font.GothamBold
settingLabel.TextSize = 18
settingLabel.TextWrapped = true
settingLabel.Parent = settingContent

-- ====================== KONTEN MAIN (FITUR) ======================
-- Label WalkSpeed
local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.fromOffset(100, 30)
wsLabel.Position = UDim2.fromOffset(10, 10)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed"
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextSize = 18
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = mainContent

-- Nilai WalkSpeed
local wsValueLabel = Instance.new("TextLabel")
wsValueLabel.Size = UDim2.fromOffset(60, 30)
wsValueLabel.Position = UDim2.fromOffset(350, 10)
wsValueLabel.BackgroundTransparency = 1
wsValueLabel.Text = "30"
wsValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
wsValueLabel.Font = Enum.Font.GothamBold
wsValueLabel.TextSize = 18
wsValueLabel.TextXAlignment = Enum.TextXAlignment.Right
wsValueLabel.Parent = mainContent

-- Slider Track
local sliderTrack = Instance.new("Frame")
sliderTrack.Name = "SliderTrack"
sliderTrack.Size = UDim2.fromOffset(380, 8)
sliderTrack.Position = UDim2.fromOffset(10, 50)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = mainContent

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(0, 4)
trackCorner.Parent = sliderTrack

-- Slider Fill
local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.fromOffset(0, 8)
sliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = sliderFill

-- Slider Knob (bulat)
local sliderKnob = Instance.new("Frame")
sliderKnob.Name = "SliderKnob"
sliderKnob.Size = UDim2.fromOffset(18, 18)
sliderKnob.Position = UDim2.fromOffset(-9, -5)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

-- Tombol Inf Jump
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.fromOffset(160, 40)
infJumpBtn.Position = UDim2.fromOffset(10, 80)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
infJumpBtn.Text = "Inf Jump: OFF"
infJumpBtn.Font = Enum.Font.GothamBold
infJumpBtn.TextSize = 16
infJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpBtn.AutoButtonColor = false
infJumpBtn.Parent = mainContent

local infCorner = Instance.new("UICorner")
infCorner.CornerRadius = UDim.new(0, 8)
infCorner.Parent = infJumpBtn

-- Tombol Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.fromOffset(160, 40)
noclipBtn.Position = UDim2.fromOffset(190, 80)
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 16
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.AutoButtonColor = false
noclipBtn.Parent = mainContent

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipBtn

-- ====================== FRAME MINIMIZE ======================
local minimizeFrame = Instance.new("Frame")
minimizeFrame.Name = "MinimizeFrame"
minimizeFrame.Size = UDim2.fromOffset(40, 40)
minimizeFrame.Position = panel.Position
minimizeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeFrame.Visible = false
minimizeFrame.Active = true
minimizeFrame.Parent = gui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 8)
minFrameCorner.Parent = minimizeFrame

local minFrameStroke = Instance.new("UIStroke")
minFrameStroke.Thickness = 2
minFrameStroke.Color = Color3.fromRGB(80, 120, 255)
minFrameStroke.Parent = minimizeFrame

local menuIcon = Instance.new("TextLabel")
menuIcon.Size = UDim2.new(1, 0, 1, 0)
menuIcon.BackgroundTransparency = 1
menuIcon.Text = "☰"
menuIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
menuIcon.Font = Enum.Font.GothamBold
menuIcon.TextSize = 24
menuIcon.Parent = minimizeFrame

-- ====================== FUNGSI-FUNGSI ======================

-- Fungsi ganti menu
local function setMenu(menu)
    mainContent.Visible = (menu == "Main")
    tpContent.Visible = (menu == "Teleport")
    settingContent.Visible = (menu == "Setting")
    
    mainBtn.BackgroundColor3 = (menu == "Main") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
    tpBtn.BackgroundColor3 = (menu == "Teleport") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
    settingBtn.BackgroundColor3 = (menu == "Setting") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
end

-- Update slider dari nilai
local function updateSlider(value)
    value = math.floor(value + 0.5)
    wsValue = math.clamp(value, 30, 100)
    wsValueLabel.Text = tostring(wsValue)
    
    local trackWidth = sliderTrack.AbsoluteSize.X
    if trackWidth > 0 then
        local alpha = (wsValue - 30) / 70
        local fillWidth = trackWidth * alpha
        sliderFill.Size = UDim2.fromOffset(fillWidth, 8)
        sliderKnob.Position = UDim2.fromOffset(fillWidth - 9, -5)
    end
end

-- Update slider dari posisi mouse
local function updateSliderFromMouse(mouseX)
    local trackPos = sliderTrack.AbsolutePosition.X
    local trackWidth = sliderTrack.AbsoluteSize.X
    if trackWidth > 0 then
        local relX = math.clamp(mouseX - trackPos, 0, trackWidth)
        local alpha = relX / trackWidth
        local newValue = 30 + alpha * 70
        updateSlider(newValue)
    end
end

-- Toggle minimize
local function toggleMinimize()
    isMinimized = not isMinimized
    panel.Visible = not isMinimized
    minimizeFrame.Visible = isMinimized
    if isMinimized then
        minimizeFrame.Position = panel.Position
    else
        panel.Position = minimizeFrame.Position
    end
end

-- ====================== EVENT HANDLING ======================

-- Menu buttons
mainBtn.MouseButton1Click:Connect(function() setMenu("Main") end)
tpBtn.MouseButton1Click:Connect(function() setMenu("Teleport") end)
settingBtn.MouseButton1Click:Connect(function() setMenu("Setting") end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
minBtn.MouseButton1Click:Connect(toggleMinimize)

-- Minimize frame click (restore)
minimizeFrame.MouseButton1Click:Connect(toggleMinimize)

-- Inf Jump toggle
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "Inf Jump: " .. (infJumpEnabled and "ON" or "OFF")
    infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(50, 50, 60)
end)

-- Noclip toggle
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(50, 50, 60)
end)

-- Slider drag
local function startSliderDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        updateSliderFromMouse(input.Position.X)
    end
end

sliderTrack.InputBegan:Connect(startSliderDrag)
sliderKnob.InputBegan:Connect(startSliderDrag)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSliderFromMouse(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

-- ====================== DRAG WINDOW (REVISI) ======================
-- Kita buat fungsi drag sendiri untuk masing-masing frame
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = Vector2.new()
    local frameStartPos = UDim2.new()
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            frameStartPos = frame.Position
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X - dragStart.X, input.Position.Y - dragStart.Y)
            frame.Position = UDim2.new(
                frameStartPos.X.Scale,
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale,
                frameStartPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Terapkan drag
makeDraggable(panel, titleBar)
makeDraggable(minimizeFrame, minimizeFrame)

-- ====================== LOOP FITUR ======================
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    while not hum do
        char = player.Character or player.CharacterAdded:Wait()
        hum = char:FindFirstChildWhichIsA("Humanoid")
        task.wait()
    end
    return hum
end

-- WalkSpeed
task.spawn(function()
    local hum = getHumanoid()
    player.CharacterAdded:Connect(function()
        hum = getHumanoid()
    end)
    while gui.Parent do
        if hum and hum.Parent then
            hum.WalkSpeed = wsValue
        else
            hum = getHumanoid()
        end
        task.wait(0.03)
    end
end)

-- Inf Jump
task.spawn(function()
    local hum = getHumanoid()
    player.CharacterAdded:Connect(function()
        hum = getHumanoid()
    end)
    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and hum and hum.Parent then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

-- Noclip
task.spawn(function()
    while gui.Parent do
        if noclipEnabled then
            local char = player.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
        RunService.Stepped:Wait()
    end
end)

-- Inisialisasi
updateSlider(30)
setMenu("Main")

print("Azka UI siap digunakan!")
