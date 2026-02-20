-- Script UI untuk Delta Executor
-- GUI: Speed Escape for Brainrots - Final (Tanpa Auto Rarity, dengan Claim Manual)

-- ==================================================
-- 1. KONFIGURASI AWAL
-- ==================================================
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")

local localPlayer = players.LocalPlayer
local guiName = "SpeedEscapeforBrainrots"

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

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
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
title.Text = "Speed Escape for Brainrots"
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

-- ==================================================
-- 3. SCROLLING FRAME
-- ==================================================
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -55)
scrollingFrame.Position = UDim2.new(0, 10, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.Parent = mainFrame
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

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
local buttonContainer = createContainer("ButtonContainer")
local switchContainer = createContainer("SwitchContainer")

-- ==================================================
-- 5. FUNGSI-FUNGSI UI
-- ==================================================
local UI = {}

-- Slider
function UI.AddSlider(config)
    local container = slideContainer
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.5, -5, 0, 20)
    valueLabel.Position = UDim2.new(0.5, 5, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(math.floor(default))
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local trackContainer = Instance.new("Frame")
    trackContainer.Size = UDim2.new(1, -20, 0, 10)
    trackContainer.Position = UDim2.new(0, 10, 0, 25)
    trackContainer.BackgroundTransparency = 1
    trackContainer.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0.5, -2)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.BorderSizePixel = 0
    track.Parent = trackContainer

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.BorderSizePixel = 0
    thumb.Parent = trackContainer

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
            value = math.floor(value + 0.5)
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -6, 0.5, -6)
            callback(value)
        end
    end)

    return frame
end

-- Tombol
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

-- Checkbox
function UI.AddCheckbox(config)
    local container = switchContainer
    local text = config.Text or "Checkbox"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

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

-- Drag logic
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

-- State untuk switch
local autoStates = {
    AlwaysGround = false,
    RemoveConveyor = false,
    RemoveBall = false,
    RemoveWave = false,
    RemoveLavas = false,
    RemoveMovingPart = false,
    RemoveFallPart = false,
    LoadAll = false
    -- AutoSecret, AutoDivine, AutoSupreme, InstantClaim dihapus
}

local loops = {}
local function stopLoop(name)
    if loops[name] then
        loops[name]:Disconnect()
        loops[name] = nil
    end
end

local function startLoop(name, func)
    if autoStates[name] then
        stopLoop(name)
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

-- Fungsi teleport aman
local function teleportTo(pos)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
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
            groundPart.Size = Vector3.new(8, 1, 8)
            groundPart.Anchored = true
            groundPart.CanCollide = true
            groundPart.Transparency = 1
            groundPart.Parent = workspace
        end
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
-- 8.2 Remove Conveyor
-- ==================================================
local function removeConveyorLoop()
    local conveyors = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby2") and workspace.Map.Obbies.Obby2:FindFirstChild("Conveyors")
    if conveyors then
        for _, folder in ipairs(conveyors:GetChildren()) do
            if folder:IsA("Folder") then
                for _, part in ipairs(folder:GetChildren()) do
                    if part:IsA("Part") then
                        part:SetAttribute("speed", "0")
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
-- 8.3 Remove Ball
-- ==================================================
local function removeBallLoop()
    local ball = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby3") and workspace.Map.Obbies.Obby3:FindFirstChild("Ball")
    if ball then
        ball:Destroy()
    end
end

-- ==================================================
-- 8.4 Remove Wave
-- ==================================================
local function removeWaveLoop()
    local wave = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby4") and workspace.Map.Obbies.Obby4:FindFirstChild("Wave")
    if wave and wave:IsA("Model") then
        wave:Destroy()
    end
end

-- ==================================================
-- 8.5 Remove Lavas
-- ==================================================
local function removeLavasLoop()
    local lavas = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby5") and workspace.Map.Obbies.Obby5:FindFirstChild("Lavas")
    if lavas and lavas:IsA("Model") then
        lavas:Destroy()
    end
end

-- ==================================================
-- 8.6 Remove MovingPart
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
-- 8.7 Remove FallPart
-- ==================================================
local function removeFallPartLoop()
    local fallParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Obbies") and workspace.Map.Obbies:FindFirstChild("Obby8") and workspace.Map.Obbies.Obby8:FindFirstChild("FallParts")
    if fallParts then
        for _, part in ipairs(fallParts:GetChildren()) do
            if part:IsA("Part") then
                part.CanTouch = false
                local touchInterest = part:FindFirstChildOfClass("TouchTransmitter")
                if touchInterest then
                    touchInterest:Destroy()
                end
            end
        end
    end
end

-- ==================================================
-- 8.8 Load All
-- ==================================================
local loadAllRunning = false
local function startLoadAll()
    if loadAllRunning then return end
    loadAllRunning = true

    while autoStates.LoadAll do
        local caches = workspace:FindFirstChild("Caches")
        if caches then
            local clientEntities = caches:FindFirstChild("ClientEntities")
            if clientEntities then
                for _, model in ipairs(clientEntities:GetChildren()) do
                    if model:IsA("Model") then
                        model:GetDescendants()
                    end
                end
            end
        end
        workspace:GetDescendants()
        task.wait(2)
    end
    loadAllRunning = false
end

-- ==================================================
-- 9. MENAMBAHKAN ELEMEN KE GUI
-- ==================================================
-- Slide: Walkspeed
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

-- Tombol Claim Manual (tambah di awal buttonContainer)
UI.AddButton({
    Text = "Claim Manual",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local savedPos = Player.Character.HumanoidRootPart.Position
            teleportTo(Vector3.new(-1111.943, 63, -1194.301)) -- Home
            task.wait(0.5)
            teleportTo(savedPos)
            -- savedPos akan hilang setelah fungsi selesai (tidak perlu dihapus secara eksplisit)
        end
    end
})

-- Tombol Teleport lainnya
UI.AddButton({
    Text = "Home",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, -1194.301))
    end
})
UI.AddButton({
    Text = "Obby 2",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, -857.503))
    end
})
UI.AddButton({
    Text = "Obby 3",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, -490.799))
    end
})
UI.AddButton({
    Text = "Obby 4",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, -132.559))
    end
})
UI.AddButton({
    Text = "Obby 5",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 341.683))
    end
})
UI.AddButton({
    Text = "Obby 6",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 863.872))
    end
})
UI.AddButton({
    Text = "Obby 7",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 1468.275))
    end
})
UI.AddButton({
    Text = "Obby 8",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 2200.812))
    end
})
UI.AddButton({
    Text = "Obby 9",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 3233.783))
    end
})
UI.AddButton({
    Text = "Obby 10",
    Callback = function()
        teleportTo(Vector3.new(-1111.943, 63, 4246.001))
    end
})

-- Switch (checkbox)
UI.AddCheckbox({
    Text = "Always Ground",
    Default = false,
    Callback = function(state)
        autoStates.AlwaysGround = state
        if state then
            startLoop("AlwaysGround", updateAlwaysGround)
        else
            stopLoop("AlwaysGround")
            updateAlwaysGround()
        end
    end
})

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

UI.AddCheckbox({
    Text = "Load All",
    Default = false,
    Callback = function(state)
        autoStates.LoadAll = state
        if state then
            coroutine.wrap(startLoadAll)()
        end
    end
})

-- ==================================================
-- 10. EXPOSE FUNGSI KE GLOBAL
-- ==================================================
_G[guiName] = UI

print("GUI Speed Escape for Brainrots berhasil dimuat (versi final).")
