--[[
	Script BY Azka - Ultimate Controller (Kavo UI)
	- Menggunakan library Kavo (backup)
	- Semua UI ditempatkan dalam folder "Main_Script_By_Azka" di CoreGui
	- Tab Main: slider, switch toggles, dan toggle Fly UI
	- Tab Teleport: live players, saved teleports (berfungsi penuh)
	- Tab Script Library: placeholder
	- Fly UI: panel terpisah dengan desain asli (UP/DOWN, minimize)
]]

-- Hapus folder lama jika ada
local CoreGui = game:GetService("CoreGui")
local folderName = "Main_Script_By_Azka"
local oldFolder = CoreGui:FindFirstChild(folderName)
if oldFolder then oldFolder:Destroy() end

-- Buat folder baru
local folder = Instance.new("Folder")
folder.Name = folderName
folder.Parent = CoreGui

-- Load library Kavo
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/ihsannur020-ops/SpeedControl-Azka/refs/heads/main/Kavo_UI_Library_Backup.Lua"))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- ========== VARIABEL GLOBAL ==========
_G.AzkaTeleports = _G.AzkaTeleports or {}  -- menyimpan teleport
local currentWS = 30
local currentBoost = 0
local godModeEnabled = false
local instantProxEnabled = false
local infiniteZoomEnabled = false
local freecamEnabled = false
local noclipEnabled = false
local infJumpEnabled = false
local flyUIEnabled = false

-- Freecam part & info
local freecamPart = Instance.new("Part")
freecamPart.Anchored = true
freecamPart.CanCollide = false
freecamPart.Transparency = 1
freecamPart.Size = Vector3.new(1,1,1)
freecamPart.Parent = workspace

local freecamInfo = Instance.new("TextLabel")
freecamInfo.Size = UDim2.fromOffset(200, 30)
freecamInfo.Position = UDim2.new(0, 10, 0, 10)
freecamInfo.BackgroundColor3 = Color3.fromRGB(20,20,24)
freecamInfo.TextColor3 = Color3.new(1,1,1)
freecamInfo.Text = "Freecam ON (WASD/SPACE/CTRL) - Shift to speed"
freecamInfo.Font = Enum.Font.GothamBold
freecamInfo.TextSize = 14
freecamInfo.Visible = false
freecamInfo.Parent = folder
makeDraggable(freecamInfo, freecamInfo)  -- fungsi draggable akan didefinisikan nanti

-- ========== FUNGSI UTILITY ==========
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

local function makeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	local dragging = false
	local dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
		                 input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

-- ========== FLY UI (DESAIN ASLI) ==========
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "FlyUI"
flyGui.ResetOnSpawn = false
flyGui.Parent = folder

local flyFrame = Instance.new("Frame")
flyFrame.Name = "FlyFrame"
flyFrame.Parent = flyGui
flyFrame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
flyFrame.BorderColor3 = Color3.fromRGB(103, 221, 213)
flyFrame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
flyFrame.Size = UDim2.new(0, 190, 0, 57)
flyFrame.Active = true
flyFrame.Draggable = true
flyFrame.Visible = false
makeDraggable(flyFrame, flyFrame)

-- Buttons
local up = Instance.new("TextButton")
up.Name = "up"
up.Parent = flyFrame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Position = UDim2.new(0, 5, 0, 5)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14
Instance.new("UICorner", up).CornerRadius = UDim.new(0, 4)

local down = Instance.new("TextButton")
down.Name = "down"
down.Parent = flyFrame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 5, 0, 28)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14
Instance.new("UICorner", down).CornerRadius = UDim.new(0, 4)

local onof = Instance.new("TextButton")
onof.Name = "onof"
onof.Parent = flyFrame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14
Instance.new("UICorner", onof).CornerRadius = UDim.new(0, 4)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = flyFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
titleLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
titleLabel.Size = UDim2.new(0, 100, 0, 28)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "AzkaFLY"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextScaled = true
Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 4)

local plus = Instance.new("TextButton")
plus.Name = "plus"
plus.Parent = flyFrame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 4)

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "speed"
speedLabel.Parent = flyFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedLabel.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = "1"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true
Instance.new("UICorner", speedLabel).CornerRadius = UDim.new(0, 4)

local mine = Instance.new("TextButton")
mine.Name = "mine"
mine.Parent = flyFrame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
Instance.new("UICorner", mine).CornerRadius = UDim.new(0, 4)

local closeFly = Instance.new("TextButton")
closeFly.Name = "Close"
closeFly.Parent = flyFrame
closeFly.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closeFly.Font = Enum.Font.SourceSans
closeFly.Size = UDim2.new(0, 45, 0, 28)
closeFly.Text = "X"
closeFly.TextSize = 30
closeFly.Position = UDim2.new(0, 0, -1, 27)
Instance.new("UICorner", closeFly).CornerRadius = UDim.new(0, 4)

local mini = Instance.new("TextButton")
mini.Name = "minimize"
mini.Parent = flyFrame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = Enum.Font.SourceSans
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 4)

local mini2 = Instance.new("TextButton")
mini2.Name = "minimize2"
mini2.Parent = flyFrame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = Enum.Font.SourceSans
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false
Instance.new("UICorner", mini2).CornerRadius = UDim.new(0, 4)

-- Fly logic
local flyActive = false
local flySpeed = 1

onof.MouseButton1Click:Connect(function()
	flyActive = not flyActive
	onof.Text = flyActive and "stop" or "fly"
end)

-- Up/Down hold
local upConnection, downConnection
up.MouseButton1Down:Connect(function()
	upConnection = RunService.RenderStepped:Connect(function()
		if flyActive then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, flySpeed, 0)
			end
		end
	end)
end)
up.MouseButton1Up:Connect(function()
	if upConnection then upConnection:Disconnect() end
end)

down.MouseButton1Down:Connect(function()
	downConnection = RunService.RenderStepped:Connect(function()
		if flyActive then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -flySpeed, 0)
			end
		end
	end)
end)
down.MouseButton1Up:Connect(function()
	if downConnection then downConnection:Disconnect() end
end)

-- Speed controls
plus.MouseButton1Click:Connect(function()
	flySpeed = flySpeed + 1
	speedLabel.Text = tostring(flySpeed)
end)

mine.MouseButton1Click:Connect(function()
	if flySpeed > 1 then
		flySpeed = flySpeed - 1
		speedLabel.Text = tostring(flySpeed)
	else
		speedLabel.Text = "min 1"
		task.wait(0.5)
		speedLabel.Text = "1"
	end
end)

-- Minimize
mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speedLabel.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	flyFrame.BackgroundTransparency = 1
	closeFly.Position = UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speedLabel.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	flyFrame.BackgroundTransparency = 0
	closeFly.Position = UDim2.new(0, 0, -1, 27)
end)

closeFly.MouseButton1Click:Connect(function()
	flyFrame.Visible = false
	flyUIEnabled = false
	-- update toggle di main menu nanti
end)

-- ========== BUAT WINDOW UTAMA DENGAN KAVO ==========
local Window = Kavo.CreateLib("Script BY Azka", "Ocean")  -- pilih tema Ocean
local MainTab = Window:NewTab("Main")
local TeleportTab = Window:NewTab("Teleport")
local ScriptLibTab = Window:NewTab("Script Library")

-- ========== TAB MAIN ==========
local MainSection = MainTab:NewSection("Controls")

-- WalkSpeed Slider
MainSection:NewSlider("WalkSpeed", "Kecepatan jalan (1-200)", 200, 1, function(val)
	currentWS = val
end)

-- Boost Slider
MainSection:NewSlider("Boost", "Tambahan kecepatan (0-500)", 500, 0, function(val)
	currentBoost = val
end)

-- Switch toggles (kita buat sendiri karena Kavo toggle bentuknya kurang sesuai)
-- Fungsi membuat switch custom
local function createSwitch(parent, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Parent = parent
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	frame.Size = UDim2.new(1, -10, 0, 35)
	frame.BackgroundTransparency = 1
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Parent = frame
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.Text = text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local switchBg = Instance.new("Frame")
	switchBg.Parent = frame
	switchBg.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
	switchBg.Size = UDim2.new(0, 50, 0, 25)
	switchBg.Position = UDim2.new(1, -55, 0.5, -12.5)
	Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

	local switchThumb = Instance.new("Frame")
	switchThumb.Parent = switchBg
	switchThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	switchThumb.Size = UDim2.new(0, 23, 0, 23)
	switchThumb.Position = default and UDim2.new(1, -24, 0.5, -11.5) or UDim2.new(0, 2, 0.5, -11.5)
	Instance.new("UICorner", switchThumb).CornerRadius = UDim.new(1, 0)

	local state = default
	local function updateUI()
		switchBg.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
		switchThumb.Position = state and UDim2.new(1, -24, 0.5, -11.5) or UDim2.new(0, 2, 0.5, -11.5)
	end

	switchBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			updateUI()
			if callback then callback(state) end
		end
	end)

	updateUI()
	return function() return state end
end

-- Noclip switch
createSwitch(MainSection.sectionInners, "Noclip", false, function(state)
	noclipEnabled = state
end)

-- Inf Jump switch
createSwitch(MainSection.sectionInners, "Inf Jump", false, function(state)
	infJumpEnabled = state
end)

-- God Mode switch
createSwitch(MainSection.sectionInners, "God Mode", false, function(state)
	godModeEnabled = state
end)

-- Instant Proximity switch
createSwitch(MainSection.sectionInners, "Instant Proximity", false, function(state)
	instantProxEnabled = state
end)

-- Infinite Zoom switch
createSwitch(MainSection.sectionInners, "Infinite Zoom", false, function(state)
	infiniteZoomEnabled = state
end)

-- Freecam switch
createSwitch(MainSection.sectionInners, "Freecam", false, function(state)
	freecamEnabled = state
	freecamInfo.Visible = state
	if state then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			freecamPart.CFrame = char.HumanoidRootPart.CFrame
		end
	else
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			Camera.CameraSubject = char.Humanoid
		end
	end
end)

-- Fly UI switch
createSwitch(MainSection.sectionInners, "Fly UI", false, function(state)
	flyFrame.Visible = state
	flyUIEnabled = state
end)

-- ========== TAB TELEPORT ==========
local TPSection = TeleportTab:NewSection("Live Players")
local SavedSection = TeleportTab:NewSection("Saved Teleports")

-- Variabel untuk menyimpan teleport
local savedList = _G.AzkaTeleports
local selectedPlayer = nil

-- Fungsi refresh live players
local function refreshLivePlayers()
	-- Hapus semua elemen di dalam section (kecuali header)
	for _, child in ipairs(TPSection.sectionInners:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local frame = Instance.new("Frame")
			frame.Parent = TPSection.sectionInners
			frame.BackgroundColor3 = Color3.fromRGB(40,40,48)
			frame.Size = UDim2.new(1, -10, 0, 50)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Parent = frame
			nameLabel.BackgroundTransparency = 1
			nameLabel.Size = UDim2.new(0.5, -5, 1, 0)
			nameLabel.Position = UDim2.new(0, 5, 0, 0)
			nameLabel.Text = plr.Name .. (plr.DisplayName ~= plr.Name and " ("..plr.DisplayName..")" or "")
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextSize = 14
			nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left

			local tpCameraBtn = Instance.new("TextButton")
			tpCameraBtn.Parent = frame
			tpCameraBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)
			tpCameraBtn.Size = UDim2.new(0, 80, 0, 30)
			tpCameraBtn.Position = UDim2.new(0.5, -40, 0.5, -15)
			tpCameraBtn.Text = "TP Camera"
			tpCameraBtn.Font = Enum.Font.GothamMedium
			tpCameraBtn.TextSize = 12
			tpCameraBtn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", tpCameraBtn).CornerRadius = UDim.new(0, 6)
			tpCameraBtn.MouseButton1Click:Connect(function()
				-- Teleport camera ke player dan ikuti
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local camPart = Instance.new("Part")
					camPart.Anchored = true
					camPart.CanCollide = false
					camPart.Transparency = 1
					camPart.Size = Vector3.new(1,1,1)
					camPart.Parent = workspace
					camPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 5)
					Camera.CameraSubject = camPart
					-- Freeze player? Tidak diimplementasikan di sini
					task.wait(0.1)
					-- Sederhana: kamera mengikuti part yang mengikuti player
					RunService.RenderStepped:Connect(function()
						if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
							camPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 5)
						end
					end)
				end
			end)

			local tpBtn = Instance.new("TextButton")
			tpBtn.Parent = frame
			tpBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
			tpBtn.Size = UDim2.new(0, 60, 0, 30)
			tpBtn.Position = UDim2.new(1, -65, 0.5, -15)
			tpBtn.Text = "TP"
			tpBtn.Font = Enum.Font.GothamMedium
			tpBtn.TextSize = 12
			tpBtn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
			tpBtn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						char.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
					end
				end
			end)
		end
	end
end

-- Tombol Refresh
TPSection:NewButton("Refresh Players", "Perbarui daftar pemain", refreshLivePlayers)

-- Panggil pertama kali
refreshLivePlayers()

-- Bagian Saved Teleports
local function refreshSavedList()
	for _, child in ipairs(SavedSection.sectionInners:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for i, data in ipairs(savedList) do
		local frame = Instance.new("Frame")
		frame.Parent = SavedSection.sectionInners
		frame.BackgroundColor3 = Color3.fromRGB(40,40,48)
		frame.Size = UDim2.new(1, -10, 0, 40)
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Parent = frame
		nameLabel.BackgroundTransparency = 1
		nameLabel.Size = UDim2.new(0.5, -5, 1, 0)
		nameLabel.Position = UDim2.new(0, 5, 0, 0)
		nameLabel.Text = data.name
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 14
		nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left

		local tpBtn = Instance.new("TextButton")
		tpBtn.Parent = frame
		tpBtn.BackgroundColor3 = Color3.fromRGB(60,120,200)
		tpBtn.Size = UDim2.new(0, 80, 0, 30)
		tpBtn.Position = UDim2.new(0.5, -40, 0.5, -15)
		tpBtn.Text = "Teleport"
		tpBtn.Font = Enum.Font.GothamMedium
		tpBtn.TextSize = 12
		tpBtn.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
		tpBtn.MouseButton1Click:Connect(function()
			if data.pos then
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.CFrame = CFrame.new(data.pos)
				end
			end
		end)

		local delBtn = Instance.new("TextButton")
		delBtn.Parent = frame
		delBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
		delBtn.Size = UDim2.new(0, 60, 0, 30)
		delBtn.Position = UDim2.new(1, -65, 0.5, -15)
		delBtn.Text = "Delete"
		delBtn.Font = Enum.Font.GothamMedium
		delBtn.TextSize = 12
		delBtn.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
		delBtn.MouseButton1Click:Connect(function()
			table.remove(savedList, i)
			refreshSavedList()
		end)
	end
end

-- Tombol Save
SavedSection:NewButton("Save Current Position", "Simpan posisi sekarang", function()
	local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
	if pos then
		local name = "Teleport " .. (#savedList + 1)
		table.insert(savedList, {name = name, pos = pos})
		refreshSavedList()
	end
end)

-- Inisialisasi list
refreshSavedList()

-- ========== TAB SCRIPT LIBRARY ==========
local LibSection = ScriptLibTab:NewSection("Scripts")
LibSection:NewLabel("Script Library (coming soon)")
-- Bisa ditambahkan tombol-tombol script nanti

-- ========== FEATURE LOOPS ==========
-- WalkSpeed enforcer
task.spawn(function()
	local hum = waitForHumanoid()
	player.CharacterAdded:Connect(function()
		hum = waitForHumanoid()
	end)
	while true do
		if hum and hum.Parent then
			hum.WalkSpeed = currentWS + currentBoost
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
	while true do
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

-- God Mode
task.spawn(function()
	local hum = waitForHumanoid()
	player.CharacterAdded:Connect(function()
		hum = waitForHumanoid()
	end)
	while true do
		if godModeEnabled and hum and hum.Parent then
			hum.MaxHealth = math.huge
			hum.Health = hum.MaxHealth
		end
		task.wait(0.1)
	end
end)

-- Instant Proximity
task.spawn(function()
	while true do
		if instantProxEnabled then
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("ProximityPrompt") then
					v.HoldDuration = 0
				end
			end
		end
		task.wait(2)
	end
end)

-- Infinite Zoom
task.spawn(function()
	while true do
		if infiniteZoomEnabled then
			Camera.MaxAxisFieldOfView = 180
			Camera.FieldOfView = 120
		else
			Camera.MaxAxisFieldOfView = 120
		end
		task.wait(0.5)
	end
end)

-- Freecam
local freecamSpeed = 0.5
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		freecamSpeed = 2
	end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		freecamSpeed = 0.5
	end
end)

RunService.RenderStepped:Connect(function()
	if freecamEnabled then
		local move = Vector3.new(
			(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
			(UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
			(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
		) * freecamSpeed
		freecamPart.CFrame = freecamPart.CFrame + move
		Camera.CFrame = CFrame.new(freecamPart.Position, freecamPart.Position + Camera.CFrame.LookVector)
	end
end)

-- Notifikasi load
local notif = Instance.new("TextLabel")
notif.Parent = folder
notif.Size = UDim2.fromOffset(200, 36)
notif.Position = UDim2.new(0.5, -100, 0, 20)
notif.BackgroundColor3 = Color3.fromRGB(28,28,34)
notif.BackgroundTransparency = 0.2
notif.Text = "Script BY Azka - Loaded"
notif.TextColor3 = Color3.fromRGB(220,230,255)
notif.Font = Enum.Font.Gotham
notif.TextSize = 14
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

task.wait(2)
TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
task.wait(0.5)
notif:Destroy()
