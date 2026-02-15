-- Script untuk Delta Executor
-- Membuat GUI dengan nama "ScriptByAzka_Deepseek" di CoreGui
-- Dilengkapi tombol minimize (animasi gulung ke atas) dan close

-- ===========================================
-- CEK DAN HAPUS GUI LAMA JIKA ADA
-- ===========================================
local coreGui = game:GetService("CoreGui")
local guiName = "ScriptByAzka_Deepseek"  -- Nama GUI sesuai instruksi

-- Cari GUI lama dengan nama yang sama
local existingGui = coreGui:FindFirstChild(guiName)
if existingGui then
    existingGui:Destroy()  -- Hapus jika sudah ada
end

-- ===========================================
-- MEMBUAT GUI BARU
-- ===========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false  -- Agar tidak hilang saat respawn

-- Frame utama (panel)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)  -- Lebar sedikit lebih besar untuk menampung tombol
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)  -- Tengah layar
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- #141414
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Sudut melengkung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Garis aksen hijau neon di kiri
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 4, 1, 0)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Hijau neon
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

-- ===========================================
-- HEADER (dengan ikon, judul, dan tombol minimize/close)
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

-- Ikon petir
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
title.Size = UDim2.new(1, -100, 1, 0)  -- Beri ruang untuk tombol di kanan
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "WAVE LOOP CONTROL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "—"  -- Simbol minus
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.Text = "✕"  -- Simbol X
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ===========================================
-- CONTAINER UNTUK TOMBOL UTAMA (akan di-minimize)
-- ===========================================
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 0, 120)  -- Tinggi 120 untuk dua tombol
buttonContainer.Position = UDim2.new(0, 10, 0, 55)  -- Di bawah header
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame
buttonContainer.ClipsDescendants = true  -- Agar anak-anaknya terpotong saat dikecilkan

-- Tombol 1: Hapus Wave Loop
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

-- Tombol 2: Stop Loop
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

-- ===========================================
-- FOOTER (tetap di bawah)
-- ===========================================
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -35)  -- Posisi absolut di mainFrame
footer.BackgroundTransparency = 1
footer.Text = "Azka Script"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame

-- ===========================================
-- FUNGSIONALITAS TOMBOL
-- ===========================================
local TweenService = game:GetService("TweenService")

-- State minimize: false = terbuka, true = tertutup
local isMinimized = false

-- Fungsi untuk animate minimize/maximize
local function toggleMinimize()
    if isMinimized then
        -- Maximize: kembalikan ukuran container ke 120
        local tween = TweenService:Create(buttonContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 120)})
        tween:Play()
    else
        -- Minimize: kecilkan container hingga tinggi 0
        local tween = TweenService:Create(buttonContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
        tween:Play()
    end
    isMinimized = not isMinimized
end

-- Event tombol minimize
minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Event tombol close
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()  -- Hapus seluruh GUI
end)

-- ===========================================
-- FUNGSIONALITAS PENGHAPUSAN WAVE (client-side)
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
    -- Feedback visual
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

print("GUI " .. guiName .. " berhasil dimuat di CoreGui")
