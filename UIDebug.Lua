-- Script untuk Delta Executor
-- Menampilkan Place ID dan posisi player real-time, dengan tombol salin

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then
    warn("Tidak dapat menemukan pemain lokal.")
    return
end

-- Fungsi menyalin teks ke clipboard (khusus executor dengan setclipboard)
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    else
        warn("setclipboard tidak tersedia di executor ini.")
        return false
    end
end

-- Membuat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GameIDandPosition"
gui.ResetOnSpawn = false

-- Tempatkan di CoreGui jika memungkinkan
local parentGui = CoreGui
pcall(function() gui.Parent = parentGui end)
if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Frame utama (dapat digeser)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 25)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Game ID & Posisi Player"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Tombol tutup (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Label Place ID (statis)
local placeIdLabel = Instance.new("TextLabel")
placeIdLabel.Size = UDim2.new(1, -20, 0, 25)
placeIdLabel.Position = UDim2.new(0, 10, 0, 35)
placeIdLabel.BackgroundTransparency = 0.5
placeIdLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
placeIdLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
placeIdLabel.Font = Enum.Font.SourceSans
placeIdLabel.TextSize = 16
placeIdLabel.Text = "Place ID: " .. tostring(game.PlaceId or "Tidak tersedia")
placeIdLabel.TextXAlignment = Enum.TextXAlignment.Left
placeIdLabel.Parent = frame

-- Tombol salin Place ID
local copyPlaceBtn = Instance.new("TextButton")
copyPlaceBtn.Size = UDim2.new(0, 120, 0, 25)
copyPlaceBtn.Position = UDim2.new(0, 10, 0, 65)
copyPlaceBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
copyPlaceBtn.Text = "Salin ID Game"
copyPlaceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyPlaceBtn.Font = Enum.Font.SourceSans
copyPlaceBtn.TextSize = 16
copyPlaceBtn.Parent = frame
copyPlaceBtn.MouseButton1Click:Connect(function()
    local success = copyToClipboard(tostring(game.PlaceId))
    if success then
        copyPlaceBtn.Text = "Tersalin!"
        task.wait(1)
        copyPlaceBtn.Text = "Salin ID Game"
    end
end)

-- Label posisi (diperbarui real-time)
local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(1, -20, 0, 25)
posLabel.Position = UDim2.new(0, 10, 0, 100)
posLabel.BackgroundTransparency = 0.5
posLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
posLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
posLabel.Font = Enum.Font.SourceSans
posLabel.TextSize = 16
posLabel.Text = "Posisi: (menunggu karakter...)"
posLabel.TextXAlignment = Enum.TextXAlignment.Left
posLabel.Parent = frame

-- Tombol Save Teleport (menyalin format posisi)
local saveTeleportBtn = Instance.new("TextButton")
saveTeleportBtn.Size = UDim2.new(0, 120, 0, 25)
saveTeleportBtn.Position = UDim2.new(0, 140, 0, 65)  -- Sejajar dengan tombol pertama
saveTeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
saveTeleportBtn.Text = "Save Teleport"
saveTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveTeleportBtn.Font = Enum.Font.SourceSans
saveTeleportBtn.TextSize = 16
saveTeleportBtn.Parent = frame
saveTeleportBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
    if root then
        local pos = root.Position
        -- Format sesuai permintaan: [ X ] = [nilai] ,[ Y ] = [nilai] ,[ Z ] = [nilai]
        local formatText = string.format("[ X ] = [%s] ,[ Y ] = [%s] ,[ Z ] = [%s]",
            tostring(math.floor(pos.X * 1000) / 1000),  -- pembulatan 3 desimal
            tostring(math.floor(pos.Y * 1000) / 1000),
            tostring(math.floor(pos.Z * 1000) / 1000))
        local success = copyToClipboard(formatText)
        if success then
            saveTeleportBtn.Text = "Tersalin!"
            task.wait(1)
            saveTeleportBtn.Text = "Save Teleport"
        end
    else
        saveTeleportBtn.Text = "Tidak ada karakter"
        task.wait(1)
        saveTeleportBtn.Text = "Save Teleport"
    end
end)

-- Fungsi untuk update posisi secara berkala
local function updatePosition()
    local character = player.Character
    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
    if root then
        local pos = root.Position
        posLabel.Text = string.format("Posisi: X=%.3f Y=%.3f Z=%.3f", pos.X, pos.Y, pos.Z)
    else
        posLabel.Text = "Posisi: (karakter tidak ditemukan)"
    end
end

-- Loop update setiap 0.5 detik (real-time)
spawn(function()
    while gui and gui.Parent do
        updatePosition()
        task.wait(0.5)
    end
end)

-- Update pertama
updatePosition()
