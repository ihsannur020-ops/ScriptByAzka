-- Script untuk Delta Executor
-- GUI: ScriptByAzka_Deepseek dengan draggable header, minimize animasi, dan close

-- ===========================================
-- HAPUS GUI LAMA JIKA ADA
-- ===========================================
local coreGui = game:GetService("CoreGui")
local guiName = "ScriptByAzka_Deepseek"
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

-- Frame utama (bisa digerakkan)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 220)  -- Tinggi cukup untuk header + 2 tombol + footer
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = false  -- Kita akan buat draggable manual via header

-- Sudut melengkung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Garis aksen hijau neon di kiri
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 4, 1, 0)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

-- ===========================================
-- HEADER (dengan icon, judul, tombol minimize & close)
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
-- KONTEN UTAMA (akan dianimasikan saat minimize)
-- ===========================================
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 0, 140)  -- Tinggi total: 50+50+30 + spasi
contentContainer.Position = UDim2.new(0, 10, 0, 55)  -- Di bawah header
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
contentContainer.ClipsDescendants = true  -- Agar animasi memotong anak-anaknya

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
button1.Parent = contentContainer

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
button2.Parent = contentContainer

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = button2

-- Footer (Azka Script)
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 0, 120)  -- Di bawah tombol kedua
footer.BackgroundTransparency = 1
footer.Text = "Azka Script"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = contentContainer

-- ===========================================
-- FUNGSIONALITAS DRAG (header bisa digerakkan)
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
-- FUNGSIONALITAS MINIMIZE (animasi naik/turun)
-- ===========================================
local TweenService = game:GetService("TweenService")
local isMinimized = false
local originalHeight = contentContainer.Size.Y.Offset

local function toggleMinimize()
	if isMinimized then
		-- Maximize: kembalikan ke tinggi semula
		local tween = TweenService:Create(contentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, originalHeight)})
		tween:Play()
	else
		-- Minimize: kecilkan hingga 0
		local tween = TweenService:Create(contentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)})
		tween:Play()
	end
	isMinimized = not isMinimized
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- ===========================================
-- FUNGSIONALITAS CLOSE
-- ===========================================
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
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
	task.wait(0.2)
	button1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

button2.MouseButton1Click:Connect(function()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	button2.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	task.wait(0.2)
	button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

print("GUI " .. guiName .. " berhasil dimuat dengan draggable header dan minimize animasi")
