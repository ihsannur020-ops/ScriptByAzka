--[[
    Azka UI - Custom UI seperti Kavo untuk Delta Executor
    Versi Instance (ScreenGui) dengan fitur lengkap
    Dibuat oleh Azka
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Hapus UI lama jika ada
local existingGui = CoreGui:FindFirstChild("AzkaUI")
if existingGui then
    existingGui:Destroy()
end

-- Variabel global untuk kontrol (opsional)
_G.AzkaUI = _G.AzkaUI or {}
if _G.AzkaUI.Cleanup then
    _G.AzkaUI.Cleanup()
end

-- =============================================
--              PEMBUATAN GUI
-- =============================================

local gui = Instance.new("ScreenGui")
gui.Name = "AzkaUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- Frame utama (panel)
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(600, 450)
panel.Position = UDim2.new(0.5, -300, 0.4, -225)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- solid gelap
panel.BorderSizePixel = 0
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 2
panelStroke.Color = Color3.fromRGB(80, 120, 255)
panelStroke.Transparency = 0
panelStroke.Parent = panel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Judul
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "Script BY Azka"
titleLabel.Parent = titleBar

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(30, 24)
closeBtn.Position = UDim2.new(1, -70, 0.5, -12)
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

-- Tombol Minimize (-)
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.fromOffset(30, 24)
minBtn.Position = UDim2.new(1, -36, 0.5, -12)
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

-- Panel kiri (menu)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.fromOffset(130, 380)
leftPanel.Position = UDim2.fromOffset(10, 46)
leftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = panel

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 10)
leftCorner.Parent = leftPanel

-- Tombol menu Main
local mainBtn = Instance.new("TextButton")
mainBtn.Name = "MainBtn"
mainBtn.Size = UDim2.new(1, -20, 0, 40)
mainBtn.Position = UDim2.fromOffset(10, 10)
mainBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
mainBtn.Text = "Main"
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 16
mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.AutoButtonColor = false
mainBtn.Parent = leftPanel

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainBtn

-- Tombol menu Teleport
local tpBtn = Instance.new("TextButton")
tpBtn.Name = "TeleportBtn"
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

-- Tombol menu Setting
local settingBtn = Instance.new("TextButton")
settingBtn.Name = "SettingBtn"
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

-- Panel konten kanan
local contentPanel = Instance.new("Frame")
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.fromOffset(430, 380)
contentPanel.Position = UDim2.fromOffset(155, 46)
contentPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
contentPanel.BorderSizePixel = 0
contentPanel.Parent = panel

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentPanel

-- Konten untuk menu Main (akan diisi nanti)
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, -20, 1, -20)
mainContent.Position = UDim2.fromOffset(10, 10)
mainContent.BackgroundTransparency = 1
mainContent.Visible = true
mainContent.Parent = contentPanel

-- Konten untuk menu Teleport (placeholder)
local tpContent = Instance.new("Frame")
tpContent.Name = "TeleportContent"
tpContent.Size = UDim2.new(1, -20, 1, -20)
tpContent.Position = UDim2.fromOffset(10, 10)
tpContent.BackgroundTransparency = 1
tpContent.Visible = false
tpContent.Parent = contentPanel

local tpPlaceholder = Instance.new("TextLabel")
tpPlaceholder.Size = UDim2.new(1, 0, 1, 0)
tpPlaceholder.BackgroundTransparency = 1
tpPlaceholder.Text = "Menu Teleport\n(Coming Soon)"
tpPlaceholder.TextColor3 = Color3.fromRGB(200, 200, 200)
tpPlaceholder.Font = Enum.Font.GothamBold
tpPlaceholder.TextSize = 18
tpPlaceholder.TextWrapped = true
tpPlaceholder.Parent = tpContent

-- Konten untuk menu Setting (placeholder)
local settingContent = Instance.new("Frame")
settingContent.Name = "SettingContent"
settingContent.Size = UDim2.new(1, -20, 1, -20)
settingContent.Position = UDim2.fromOffset(10, 10)
settingContent.BackgroundTransparency = 1
settingContent.Visible = false
settingContent.Parent = contentPanel

local settingPlaceholder = Instance.new("TextLabel")
settingPlaceholder.Size = UDim2.new(1, 0, 1, 0)
settingPlaceholder.BackgroundTransparency = 1
settingPlaceholder.Text = "Menu Setting\n(Coming Soon)"
settingPlaceholder.TextColor3 = Color3.fromRGB(200, 200, 200)
settingPlaceholder.Font = Enum.Font.GothamBold
settingPlaceholder.TextSize = 18
settingPlaceholder.TextWrapped = true
settingPlaceholder.Parent = settingContent

-- =============================================
--       KONTEN UNTUK MENU MAIN
-- =============================================

-- Label WalkSpeed
local wsLabel = Instance.new("TextLabel")
wsLabel.Name = "WSLabel"
wsLabel.Size = UDim2.fromOffset(100, 30)
wsLabel.Position = UDim2.fromOffset(10, 10)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed"
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextSize = 18
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = mainContent

-- Label nilai
local wsValue = Instance.new("TextLabel")
wsValue.Name = "WSValue"
wsValue.Size = UDim2.fromOffset(60, 30)
wsValue.Position = UDim2.fromOffset(350, 10)
wsValue.BackgroundTransparency = 1
wsValue.Text = "30"
wsValue.TextColor3 = Color3.fromRGB(100, 200, 255)
wsValue.Font = Enum.Font.GothamBold
wsValue.TextSize = 18
wsValue.TextXAlignment = Enum.TextXAlignment.Right
wsValue.Parent = mainContent

-- Slider track
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

-- Slider fill
local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.fromOffset(0, 8)
sliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = sliderFill

-- Slider knob (bulat)
local sliderKnob = Instance.new("ImageButton")
sliderKnob.Name = "SliderKnob"
sliderKnob.Size = UDim2.fromOffset(18, 18)
sliderKnob.Position = UDim2.fromOffset(-9, -5)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BackgroundTransparency = 1
sliderKnob.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- lingkaran putih
sliderKnob.ImageColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.ImageTransparency = 0
sliderKnob.Parent = sliderTrack

-- Tombol Inf Jump
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Name = "InfJumpBtn"
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
noclipBtn.Name = "NoclipBtn"
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

-- =============================================
--      FRAME MINIMIZE (kotak emoji)
-- =============================================
local minimizeFrame = Instance.new("Frame")
minimizeFrame.Name = "MinimizeFrame"
minimizeFrame.Size = UDim2.fromOffset(200, 100)
minimizeFrame.Position = panel.Position -- ikuti posisi panel awal
minimizeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeFrame.Visible = false
minimizeFrame.Parent = gui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 12)
minFrameCorner.Parent = minimizeFrame

local minFrameStroke = Instance.new("UIStroke")
minFrameStroke.Thickness = 2
minFrameStroke.Color = Color3.fromRGB(80, 120, 255)
minFrameStroke.Parent = minimizeFrame

local emojiLabel = Instance.new("TextLabel")
emojiLabel.Name = "Emoji"
emojiLabel.Size = UDim2.new(1, 0, 1, 0)
emojiLabel.BackgroundTransparency = 1
emojiLabel.Text = "✌︎㋡"
emojiLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
emojiLabel.Font = Enum.Font.GothamBold
emojiLabel.TextSize = 40
emojiLabel.Parent = minimizeFrame

-- =============================================
--              FUNGSI-FUNGSI
-- =============================================

-- Variabel state
local isMinimized = false
local currentMenu = "Main" -- Main, Teleport, Setting
local wsValueNum = 30
local minWS = 30
local maxWS = 100
local infJumpEnabled = false
local noclipEnabled = false
local draggingSlider = false
local draggingWindow = false
local dragOffset = Vector2.new()

-- Fungsi untuk mengganti menu
local function setMenu(menu)
    currentMenu = menu
    mainContent.Visible = (menu == "Main")
    tpContent.Visible = (menu == "Teleport")
    settingContent.Visible = (menu == "Setting")
    
    -- Ubah warna tombol menu (opsional)
    mainBtn.BackgroundColor3 = (menu == "Main") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
    tpBtn.BackgroundColor3 = (menu == "Teleport") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
    settingBtn.BackgroundColor3 = (menu == "Setting") and Color3.fromRGB(70, 100, 200) or Color3.fromRGB(50, 50, 60)
end

-- Fungsi update slider berdasarkan nilai
local function updateSliderFromValue(value)
    value = math.floor(value + 0.5) -- pembulatan ke integer terdekat
    wsValueNum = math.clamp(value, minWS, maxWS)
    wsValue.Text = tostring(wsValueNum)
    local alpha = (wsValueNum - minWS) / (maxWS - minWS)
    local trackWidth = sliderTrack.AbsoluteSize.X
    local fillWidth = trackWidth * alpha
    sliderFill.Size = UDim2.fromOffset(fillWidth, 8)
    sliderKnob.Position = UDim2.fromOffset(fillWidth - 9, -5)
end

-- Fungsi update slider berdasarkan posisi mouse
local function updateSliderFromMouse(mouseX)
    local trackPos = sliderTrack.AbsolutePosition.X
    local trackWidth = sliderTrack.AbsoluteSize.X
    local relX = math.clamp(mouseX - trackPos, 0, trackWidth)
    local alpha = relX / trackWidth
    local newValue = minWS + alpha * (maxWS - minWS)
    updateSliderFromValue(newValue)
end

-- Fungsi toggle minimize
local function toggleMinimize()
    isMinimized = not isMinimized
    panel.Visible = not isMinimized
    minimizeFrame.Visible = isMinimized
    if isMinimized then
        minimizeFrame.Position = panel.Position -- sinkronkan posisi
    else
        panel.Position = minimizeFrame.Position
    end
end

-- =============================================
--              EVENT HANDLING
-- =============================================

-- Menu click
mainBtn.MouseButton1Click:Connect(function() setMenu("Main") end)
tpBtn.MouseButton1Click:Connect(function() setMenu("Teleport") end)
settingBtn.MouseButton1Click:Connect(function() setMenu("Setting") end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    _G.AzkaUI = nil
end)

-- Minimize
minBtn.MouseButton1Click:Connect(toggleMinimize)
minimizeFrame.MouseButton1Click:Connect(toggleMinimize) -- klik pada minimize frame untuk membuka

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

-- Slider logic
local function onSliderInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        updateSliderFromMouse(input.Position.X)
    end
end

sliderTrack.InputBegan:Connect(onSliderInputBegan)
sliderKnob.InputBegan:Connect(onSliderInputBegan)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateSliderFromMouse(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

-- =============================================
--              DRAG WINDOW
-- =============================================

local function makeDraggable(dragHandle, targetFrame)
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingWindow = true
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = targetFrame.AbsolutePosition
            dragOffset = Vector2.new(mousePos.X - framePos.X, mousePos.Y - framePos.Y)
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if draggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local newPos = UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
        if panel.Visible then
            panel.Position = newPos
        else
            minimizeFrame.Position = newPos
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWindow = false
    end
end)

-- Drag handles
makeDraggable(titleBar, panel)
makeDraggable(minimizeFrame, minimizeFrame)

-- =============================================
--              LOOP FITUR
-- =============================================

-- Humanoid helper
local function waitForHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    while not hum do
        char = player.Character or player.CharacterAdded:Wait()
        hum = char:FindFirstChildWhichIsA("Humanoid")
        task.wait(0.05)
    end
    return hum
end

-- WalkSpeed loop
task.spawn(function()
    local hum = waitForHumanoid()
    player.CharacterAdded:Connect(function()
        hum = waitForHumanoid()
    end)
    while gui and gui.Parent do
        if hum and hum.Parent then
            hum.WalkSpeed = wsValueNum
        else
            hum = waitForHumanoid()
        end
        task.wait(0.01)
    end
end)

-- Inf Jump
task.spawn(function()
    local hum = waitForHumanoid()
    player.CharacterAdded:Connect(function()
        hum = waitForHumanoid()
    end)
    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and hum and hum.Parent then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hum.Jump = true
        end
    end)
end)

-- Noclip
task.spawn(function()
    while gui and gui.Parent do
        if noclipEnabled then
            local char = player.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = false
                    end
                end
            end
        end
        RunService.Stepped:Wait()
    end
end)

-- Inisialisasi slider dan menu
updateSliderFromValue(30)
setMenu("Main")

-- Cleanup function untuk dipanggil dari luar
_G.AzkaUI.Cleanup = function()
    gui:Destroy()
end

print("Azka UI (Instance) berhasil dimuat. Tekan X untuk menutup.")
