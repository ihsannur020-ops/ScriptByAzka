-- Script untuk Delta Executor (client-side)
-- Membuat GUI di CoreGui dengan tombol hapus wave loop dan stop loop

-- Hapus GUI lama jika ada
local coreGui = game:GetService("CoreGui")
local existing = coreGui:FindFirstChild("WaveControlGUI")
if existing then existing:Destroy() end

-- Buat ScreenGui baru
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WaveControlGUI"
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false -- tetap ada saat respawn

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- #141414
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
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- hijau neon
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

-- Header dengan ikon dan judul
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -10, 0, 40)
header.Position = UDim2.new(0, 5, 0, 5)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 6)
headerCorner.Parent = header

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 5, 0.5, -15)
icon.BackgroundTransparency = 1
icon.Text = "⚡"  -- ikon petir
icon.TextColor3 = Color3.fromRGB(0, 255, 0)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "WAVE LOOP CONTROL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Container untuk tombol
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 0, 120)
buttonContainer.Position = UDim2.new(0, 10, 0, 55)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

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

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -35)
footer.BackgroundTransparency = 1
footer.Text = "Azka Script"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame

-- ===========================================
-- Bagian fungsionalitas penghapusan (client-side)
-- ===========================================
local workspace = game:GetService("Workspace")
local targetNames = {
    "SuperSlow", "Slow", "Medium", "Fast", "SuperFast", "Lightning"
}

local connection = nil -- menyimpan koneksi ChildAdded

-- Fungsi untuk menghapus model yang sudah ada
local function deleteExistingModels()
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") and table.find(targetNames, child.Name) then
            child:Destroy()
        end
    end
end

-- Fungsi yang dipanggil setiap ada model baru
local function onChildAdded(child)
    if child:IsA("Model") and table.find(targetNames, child.Name) then
        child:Destroy()
    end
end

-- Event tombol 1: Mulai loop
button1.MouseButton1Click:Connect(function()
    deleteExistingModels() -- hapus yang sudah ada
    if not connection then
        connection = workspace.ChildAdded:Connect(onChildAdded)
    end
    -- Feedback visual (opsional)
    button1.BackgroundColor3 = Color3.fromRGB(0, 100, 0) -- hijau gelap
    wait(0.2)
    button1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Event tombol 2: Stop loop
button2.MouseButton1Click:Connect(function()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    -- Feedback visual (opsional)
    button2.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- merah gelap
    wait(0.2)
    button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

print("Wave Control GUI loaded di CoreGui")
