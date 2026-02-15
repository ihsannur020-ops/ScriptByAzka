-- Script untuk Delta Executor
-- GUI dengan nama "ScriptByAzka_Deepseek" di CoreGui
-- Fitur: drag header, minimize konten dengan animasi, close

local coreGui = game:GetService("CoreGui")
local guiName = "ScriptByAzka_Deepseek"

-- Hapus GUI lama jika ada
local existingGui = coreGui:FindFirstChild(guiName)
if existingGui then existingGui:Destroy() end

-- Buat GUI baru
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama (dapat digerakkan)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true  -- Agar bisa menerima input

-- Sudut melengkung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Garis aksen hijau
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 4, 1, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

-- ===========================================
-- HEADER (bagian tetap yang tidak terminimize)
-- ===========================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -10, 0, 40)
header.Position = UDim2.new(0, 5, 0, 5)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

-- Ikon
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 5, 0.5, -15)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextColor3 = Color3.fromRGB(0, 255, 0)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Parent = header

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "WAVE LOOP CONTROL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol Minimize (—)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ===========================================
-- CONTENT FRAME (berisi container dan footer, bisa di-minimize)
-- ===========================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 0, 350)  -- Sisa tinggi (400 - 40 - 10 jarak?)
contentFrame.Position = UDim2.new(0, 5, 0, 50)  -- Di bawah header (5+40+5?)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame
contentFrame.ClipsDescendants = true  -- Untuk animasi minimize

-- Container untuk tombol utama
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 120)
buttonContainer.Position = UDim2.new(0, 0, 0, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = contentFrame

-- Tombol 1
local button1 = Instance.new("TextButton")
button1.Size = UDim2.new(1, 0, 0, 50)
button1.Position = UDim2.new(0, 0, 0, 0)
button1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button1.Text = "Hapus Wave Loop"
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.TextScaled = true
button1.Font = Enum.Font.GothamBold
button1.BorderSizePixel = 0
button1.Parent = buttonContainer

local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 8)
btn1Corner.Parent = button1

-- Tombol 2
local button2 = Instance.new("TextButton")
button2.Size = UDim2.new(1, 0, 0, 50)
button2.Position = UDim2.new(0, 0, 0, 60)
button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button2.Text = "Stop Loop"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.TextScaled = true
button2.Font = Enum.Font.GothamBold
button2.BorderSizePixel = 0
button2.Parent = buttonContainer

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = button2

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)  -- Di bagian bawah contentFrame
footer.BackgroundTransparency = 1
footer.Text = "Azka Script"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = contentFrame

-- Atur ulang posisi footer agar tidak menimpa tombol
-- Karena footer ditempatkan di bagian bawah contentFrame, dan contentFrame tingginya 350, sedangkan buttonContainer 120, footer 30, maka ada sisa ruang. Tapi kita ingin footer selalu di bawah. Sebenarnya kita bisa mengatur contentFrame secara otomatis menyesuaikan dengan isi? Lebih baik kita atur contentFrame tingginya = buttonContainer.Size.Y + footer.Size.Y + sedikit jarak. Atau kita set contentFrame.Size = UDim2.new(1, -10, 0, 150) (120+30). Tapi sebelumnya mainFrame tingginya 400, header 40, jadi sisa 360. Kita bisa atur contentFrame = UDim2.new(1, -10, 0, 360) lalu posisikan footer di bottom. Tapi jika minimize, kita ingin contentFrame tingginya 0. Maka kita atur contentFrame.Size = UDim2.new(1, -10, 0, 360) dan footer di dalamnya dengan Position = UDim2.new(0,0,1,-30). Itu akan membuat footer selalu di bawah contentFrame.

-- Perbaiki: contentFrame tingginya 360 (400-40)
contentFrame.Size = UDim2.new(1, -10, 0, 360)
-- Posisikan buttonContainer di atas (0,0) dan footer di bottom
buttonContainer.Position = UDim2.new(0, 0, 0, 0)
footer.Position = UDim2.new(0, 0, 1, -30)

-- ===========================================
-- DRAG FUNCTIONALITY (pada header, kecuali tombol)
-- ===========================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Cek apakah yang diklik adalah tombol (minimize/close) atau bukan
        local object = input.Target
        if object == minimizeBtn or object == closeBtn then
            return  -- Jangan mulai drag jika klik tombol
        end
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- ===========================================
-- MINIMIZE FUNCTION
-- ===========================================
local isMinimized = false

local function toggleMinimize()
    if isMinimized then
        -- Maximize: kembalikan tinggi contentFrame
        local tween = TweenService:Create(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 360)})
        tween:Play()
    else
        -- Minimize: kecilkan contentFrame hingga 0
        local tween = TweenService:Create(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 0)})
        tween:Play()
    end
    isMinimized = not isMinimized
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===========================================
-- WAVE DELETION FUNCTIONALITY
-- ===========================================
local workspace = game:GetService("Workspace")
local targetNames = {
    "SuperSlow", "Slow", "Medium", "Fast", "SuperFast", "Lightning"
}

local connection = nil

local function deleteExistingModels()
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") and table.find(targetNames, child.Name) then
            child:Destroy()
        end
    end
end

local function onChildAdded(child)
    if child:IsA("Model") and table.find(targetNames, child.Name) then
        child:Destroy()
    end
end

button1.MouseButton1Click:Connect(function()
    deleteExistingModels()
    if not connection then
        connection = workspace.ChildAdded:Connect(onChildAdded)
    end
    button1.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    wait(0.2)
    button1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

button2.MouseButton1Click:Connect(function()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    button2.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    wait(0.2)
    button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

print("GUI " .. guiName .. " berhasil dimuat dengan drag dan minimize animasi")
