--[[
	Script BY Azka - Ultimate Controller (Final + TP UI tanpa minimize)
	- WalkSpeed slider (1-200) dengan nilai di pojok kanan
	- Boost slider (0-500) dengan nilai di pojok kanan
	- Inf Jump, Noclip toggle
	- Fly UI toggle (munculkan/sembunyikan panel fly)
	- TP UI toggle (munculkan/sembunyikan panel teleport)
	- Semua UI dapat di-drag, close
	- Fly UI memiliki minimize internal sendiri
	- Main menu menyesuaikan tinggi konten
	- Toggle bekerja benar: ON = tampil, OFF = sembunyi
	- Teleport UI: tanpa minimize, hanya close, layout: Save button, label, list, pagination
]]

-- Hapus GUI lama jika ada
local CoreGui = game:GetService("CoreGui")
local guiName = "ScriptBYAzka"
local flyGUIName = "AzkaFlyUI"
local tpGUIName = "AzkaTeleportUI"
local fpsGUIName = "AzkaFPSUI"
local scriptLibGUIName = "AzkaScriptLibUI"
local settingsGUIName = "AzkaSettingsUI"
for _, name in ipairs({guiName, flyGUIName, tpGUIName, fpsGUIName, scriptLibGUIName, settingsGUIName}) do
	local existing = CoreGui:FindFirstChild(name)
	if existing then existing:Destroy() end
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Helper: wait for humanoid
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

-- Draggable function
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

-- Fungsi untuk membuat toggle button dengan teks ON/OFF
local function createToggleButton(parent, text, width, initialColor)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, width or 110, 0, 28)
	btn.BackgroundColor3 = initialColor or Color3.fromRGB(40, 40, 48)
	btn.Text = text .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(210, 215, 230)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", btn).Color = Color3.fromRGB(80, 120, 255)
	btn.Parent = parent
	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = text .. (enabled and ": ON" or ": OFF")
		btn.BackgroundColor3 = enabled and Color3.fromRGB(35, 70, 45) or Color3.fromRGB(40, 40, 48)
	end)
	return btn, function() return enabled end
end

-- ========== MAIN MENU ==========
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(400, 0)  -- diperbesar
panel.Position = UDim2.new(0.5, -200, 0.4, -150)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
panel.Parent = gui
panel.AutomaticSize = Enum.AutomaticSize.Y

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", panel)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(80, 120, 255)
stroke.Transparency = 0.25

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
titleBar.Parent = panel
titleBar.AutomaticSize = Enum.AutomaticSize.None
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230, 235, 255)
title.Text = "Script BY Azka"
title.Parent = titleBar

-- Gear button (settings) di kiri
local gearBtn = Instance.new("TextButton")
gearBtn.Name = "Settings"
gearBtn.Size = UDim2.fromOffset(36, 24)
gearBtn.Position = UDim2.new(0, 12, 0.5, -12)
gearBtn.Text = "⚙"
gearBtn.Font = Enum.Font.GothamBold
gearBtn.TextSize = 20
gearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
gearBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(0, 8)
gearBtn.Parent = titleBar

-- Minimize button (for main menu)
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.fromOffset(36, 24)
minBtn.Position = UDim2.new(1, -84, 0.5, -12)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
minBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
minBtn.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(36, 24)
closeBtn.Position = UDim2.new(1, -44, 0.5, -12)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
closeBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.Parent = titleBar

-- Body container
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, -24, 1, -36)
body.Position = UDim2.new(0, 12, 0, 34)
body.BackgroundTransparency = 1
body.Parent = panel
body.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", body)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ===== WalkSpeed Slider =====
local wsContainer = Instance.new("Frame")
wsContainer.Size = UDim2.new(1, 0, 0, 40)
wsContainer.BackgroundTransparency = 1
wsContainer.Parent = body

local wsLabelIn = Instance.new("TextLabel")
wsLabelIn.BackgroundTransparency = 1
wsLabelIn.Size = UDim2.new(0.5, 0, 0, 24)
wsLabelIn.TextXAlignment = Enum.TextXAlignment.Left
wsLabelIn.Font = Enum.Font.Gotham
wsLabelIn.TextSize = 14
wsLabelIn.TextColor3 = Color3.fromRGB(210, 215, 230)
wsLabelIn.Text = "WalkSpeed"
wsLabelIn.Parent = wsContainer

local wsValueIn = Instance.new("TextLabel")
wsValueIn.BackgroundTransparency = 1
wsValueIn.Size = UDim2.new(0.5, 0, 0, 24)
wsValueIn.Position = UDim2.new(0.5, 0, 0, 0)
wsValueIn.TextXAlignment = Enum.TextXAlignment.Right
wsValueIn.Font = Enum.Font.GothamMedium
wsValueIn.TextSize = 14
wsValueIn.TextColor3 = Color3.fromRGB(180, 220, 255)
wsValueIn.Text = "30"
wsValueIn.Parent = wsContainer

local wsTrack = Instance.new("Frame")
wsTrack.Name = "WSTrack"
wsTrack.Size = UDim2.new(1, 0, 0, 8)
wsTrack.Position = UDim2.new(0, 0, 0, 28)
wsTrack.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
Instance.new("UICorner", wsTrack).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", wsTrack).Color = Color3.fromRGB(80, 120, 255)
wsTrack.Parent = wsContainer

local wsFill = Instance.new("Frame")
wsFill.Name = "WSFill"
wsFill.Size = UDim2.new(0, 0, 1, 0)
wsFill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
Instance.new("UICorner", wsFill).CornerRadius = UDim.new(0, 6)
wsFill.Parent = wsTrack

local wsKnob = Instance.new("Frame")
wsKnob.Name = "WSKnob"
wsKnob.Size = UDim2.fromOffset(16, 16)
wsKnob.Position = UDim2.new(0, -8, 0.5, -8)
wsKnob.BackgroundColor3 = Color3.fromRGB(220, 230, 255)
Instance.new("UICorner", wsKnob).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", wsKnob).Color = Color3.fromRGB(40, 70, 160)
wsKnob.Parent = wsTrack

-- ===== Boost Slider =====
local boostContainer = Instance.new("Frame")
boostContainer.Size = UDim2.new(1, 0, 0, 40)
boostContainer.BackgroundTransparency = 1
boostContainer.Parent = body

local boostLabelIn = Instance.new("TextLabel")
boostLabelIn.BackgroundTransparency = 1
boostLabelIn.Size = UDim2.new(0.5, 0, 0, 24)
boostLabelIn.TextXAlignment = Enum.TextXAlignment.Left
boostLabelIn.Font = Enum.Font.Gotham
boostLabelIn.TextSize = 14
boostLabelIn.TextColor3 = Color3.fromRGB(210, 215, 230)
boostLabelIn.Text = "Boost"
boostLabelIn.Parent = boostContainer

local boostValueIn = Instance.new("TextLabel")
boostValueIn.BackgroundTransparency = 1
boostValueIn.Size = UDim2.new(0.5, 0, 0, 24)
boostValueIn.Position = UDim2.new(0.5, 0, 0, 0)
boostValueIn.TextXAlignment = Enum.TextXAlignment.Right
boostValueIn.Font = Enum.Font.GothamMedium
boostValueIn.TextSize = 14
boostValueIn.TextColor3 = Color3.fromRGB(180, 220, 255)
boostValueIn.Text = "0"
boostValueIn.Parent = boostContainer

local boostTrack = Instance.new("Frame")
boostTrack.Name = "BoostTrack"
boostTrack.Size = UDim2.new(1, 0, 0, 8)
boostTrack.Position = UDim2.new(0, 0, 0, 28)
boostTrack.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
Instance.new("UICorner", boostTrack).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", boostTrack).Color = Color3.fromRGB(80, 120, 255)
boostTrack.Parent = boostContainer

local boostFill = Instance.new("Frame")
boostFill.Name = "BoostFill"
boostFill.Size = UDim2.new(0, 0, 1, 0)
boostFill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
Instance.new("UICorner", boostFill).CornerRadius = UDim.new(0, 6)
boostFill.Parent = boostTrack

local boostKnob = Instance.new("Frame")
boostKnob.Name = "BoostKnob"
boostKnob.Size = UDim2.fromOffset(16, 16)
boostKnob.Position = UDim2.new(0, -8, 0.5, -8)
boostKnob.BackgroundColor3 = Color3.fromRGB(220, 230, 255)
Instance.new("UICorner", boostKnob).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", boostKnob).Color = Color3.fromRGB(40, 70, 160)
boostKnob.Parent = boostTrack

-- ===== Slider Logic =====
local MIN_WS = 1
local MAX_WS = 200
local MIN_BOOST = 0
local MAX_BOOST = 500
local currentWS = 30
local currentBoost = 0

local draggingWS = false
local draggingBoost = false

local function setWSFromX(x)
	local absX = math.clamp(x - wsTrack.AbsolutePosition.X, 0, wsTrack.AbsoluteSize.X)
	local alpha = absX / wsTrack.AbsoluteSize.X
	local val = math.floor(MIN_WS + alpha * (MAX_WS - MIN_WS) + 0.5)
	currentWS = math.clamp(val, MIN_WS, MAX_WS)
	wsValueIn.Text = tostring(currentWS)
	wsFill.Size = UDim2.new(alpha, 0, 1, 0)
	wsKnob.Position = UDim2.new(alpha, -8, 0.5, -8)
end

local function setBoostFromX(x)
	local absX = math.clamp(x - boostTrack.AbsolutePosition.X, 0, boostTrack.AbsoluteSize.X)
	local alpha = absX / boostTrack.AbsoluteSize.X
	local val = math.floor(MIN_BOOST + alpha * (MAX_BOOST - MIN_BOOST) + 0.5)
	currentBoost = math.clamp(val, MIN_BOOST, MAX_BOOST)
	boostValueIn.Text = tostring(currentBoost)
	boostFill.Size = UDim2.new(alpha, 0, 1, 0)
	boostKnob.Position = UDim2.new(alpha, -8, 0.5, -8)
end

wsTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingWS = true
		setWSFromX(input.Position.X)
	end
end)

wsKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingWS = true
	end
end)

boostTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingBoost = true
		setBoostFromX(input.Position.X)
	end
end)

boostKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingBoost = true
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingWS and (input.UserInputType == Enum.UserInputType.MouseMovement or
	                   input.UserInputType == Enum.UserInputType.Touch) then
		setWSFromX(input.Position.X)
	end
	if draggingBoost and (input.UserInputType == Enum.UserInputType.MouseMovement or
	                      input.UserInputType == Enum.UserInputType.Touch) then
		setBoostFromX(input.Position.X)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingWS = false
		draggingBoost = false
	end
end)

-- Inisialisasi slider ke default
task.wait()
setWSFromX(wsTrack.AbsolutePosition.X + (currentWS - MIN_WS) / (MAX_WS - MIN_WS) * wsTrack.AbsoluteSize.X)
setBoostFromX(boostTrack.AbsolutePosition.X)

-- ===== ROW 1 ===== (Noclip, Inf Jump, Fly UI, TP UI)
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(1, 0, 0, 30)
row1.BackgroundTransparency = 1
row1.Parent = body

local layoutRow1 = Instance.new("UIListLayout", row1)
layoutRow1.FillDirection = Enum.FillDirection.Horizontal
layoutRow1.Padding = UDim.new(0, 8)
layoutRow1.HorizontalAlignment = Enum.HorizontalAlignment.Center
layoutRow1.VerticalAlignment = Enum.VerticalAlignment.Center

local noclipBtn, getNoclip = createToggleButton(row1, "Noclip", 90)
local infJumpBtn, getInfJump = createToggleButton(row1, "Inf Jump", 90)
local flyUIBtn, _ = createToggleButton(row1, "Fly UI", 90)
local tpUIBtn, _ = createToggleButton(row1, "TP UI", 90)

-- ===== ROW 2 ===== (God Mode, Instant Proximity, Infinite Zoom, Freecam)
local row2 = Instance.new("Frame")
row2.Size = UDim2.new(1, 0, 0, 30)
row2.BackgroundTransparency = 1
row2.Parent = body

local layoutRow2 = Instance.new("UIListLayout", row2)
layoutRow2.FillDirection = Enum.FillDirection.Horizontal
layoutRow2.Padding = UDim.new(0, 8)
layoutRow2.HorizontalAlignment = Enum.HorizontalAlignment.Center
layoutRow2.VerticalAlignment = Enum.VerticalAlignment.Center

local godModeBtn, getGodMode = createToggleButton(row2, "God Mode", 90)
local instantProxBtn, getInstantProx = createToggleButton(row2, "Instant Prox", 90)
local infiniteZoomBtn, getInfiniteZoom = createToggleButton(row2, "Infinite Zoom", 90)
local freecamBtn, getFreecam = createToggleButton(row2, "Freecam", 90)

-- ===== ROW 3 ===== (FPS UI, Script Library UI)
local row3 = Instance.new("Frame")
row3.Size = UDim2.new(1, 0, 0, 30)
row3.BackgroundTransparency = 1
row3.Parent = body

local layoutRow3 = Instance.new("UIListLayout", row3)
layoutRow3.FillDirection = Enum.FillDirection.Horizontal
layoutRow3.Padding = UDim.new(0, 8)
layoutRow3.HorizontalAlignment = Enum.HorizontalAlignment.Center
layoutRow3.VerticalAlignment = Enum.VerticalAlignment.Center

local fpsUIBtn, _ = createToggleButton(row3, "FPS UI", 90)
local scriptLibBtn, _ = createToggleButton(row3, "Script Lib", 90)

-- Minimized icon for main menu (shoe)
local shoe = Instance.new("TextButton")
shoe.Name = "ShoeIcon"
shoe.Visible = false
shoe.Text = "👟"
shoe.Font = Enum.Font.GothamBold
shoe.TextSize = 20
shoe.Size = UDim2.fromOffset(40, 40)
shoe.Position = UDim2.new(0.5, -20, 0.45, -20)
shoe.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
shoe.TextColor3 = Color3.fromRGB(220, 230, 255)
Instance.new("UICorner", shoe).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", shoe).Color = Color3.fromRGB(80, 120, 255)
shoe.Parent = gui

makeDraggable(panel, titleBar)
makeDraggable(shoe, shoe)

minBtn.MouseButton1Click:Connect(function()
	panel.Visible = false
	shoe.Visible = true
end)

shoe.MouseButton1Click:Connect(function()
	shoe.Visible = false
	panel.Visible = true
end)

-- ===== State untuk loop =====
local running = true

-- WalkSpeed enforcer (WS + Boost)
task.spawn(function()
	local hum = waitForHumanoid()
	player.CharacterAdded:Connect(function()
		hum = waitForHumanoid()
	end)
	while running do
		if hum and hum.Parent then
			hum.WalkSpeed = currentWS + currentBoost
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
		if getInfJump() and hum and hum.Parent then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			hum.Jump = true
		end
	end)
end)

-- Noclip
task.spawn(function()
	while running do
		if getNoclip() then
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

-- God Mode (Invincibility + regen cepat)
task.spawn(function()
	local hum = waitForHumanoid()
	player.CharacterAdded:Connect(function()
		hum = waitForHumanoid()
	end)
	while running do
		if getGodMode() and hum and hum.Parent then
			hum.MaxHealth = math.huge
			hum.Health = hum.MaxHealth
			-- Regen cepat
			hum.Health = hum.MaxHealth
		elseif hum and hum.Parent then
			-- Kembalikan max health normal jika perlu (tidak diimplementasikan)
		end
		task.wait(0.1)
	end
end)

-- Instant Proximity (mengatur HoldDuration ke 0 untuk semua ProximityPrompt)
task.spawn(function()
	while running do
		if getInstantProx() then
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
	while running do
		if getInfiniteZoom() then
			Camera.MaxAxisFieldOfView = 180
			Camera.FieldOfView = 120 -- contoh, bisa diatur
		else
			Camera.MaxAxisFieldOfView = 120 -- default
		end
		task.wait(0.5)
	end
end)

-- Freecam (sederhana)
local freecamActive = false
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
freecamInfo.Text = "Freecam ON (WASD/SPACE/CTRL)"
freecamInfo.Font = Enum.Font.GothamBold
freecamInfo.TextSize = 14
freecamInfo.Visible = false
freecamInfo.Parent = gui
makeDraggable(freecamInfo, freecamInfo)

local function updateFreecam()
	if freecamActive then
		local move = Vector3.new(
			(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
			(UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
			(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
		) * 0.5
		freecamPart.CFrame = freecamPart.CFrame + move
		Camera.CFrame = CFrame.new(freecamPart.Position, freecamPart.Position + Camera.CFrame.LookVector)
	end
end

RunService.RenderStepped:Connect(updateFreecam)

freecamBtn.MouseButton1Click:Connect(function()
	freecamActive = not freecamActive
	if freecamActive then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			freecamPart.CFrame = char.HumanoidRootPart.CFrame
		end
		freecamInfo.Visible = true
	else
		freecamInfo.Visible = false
		-- Kembalikan kamera ke karakter
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			Camera.CameraSubject = char.Humanoid
		end
	end
end)

-- ========== FLY UI ==========
local function createFlyUI()
	local flyGui = Instance.new("ScreenGui")
	flyGui.Name = flyGUIName
	flyGui.ResetOnSpawn = false
	flyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	flyGui.Parent = CoreGui

	local flyFrame = Instance.new("Frame")
	flyFrame.Name = "FlyFrame"
	flyFrame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
	flyFrame.BorderColor3 = Color3.fromRGB(103, 221, 213)
	flyFrame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
	flyFrame.Size = UDim2.new(0, 190, 0, 57)
	flyFrame.Active = true
	flyFrame.Draggable = true
	flyFrame.Parent = flyGui
	flyFrame.Visible = false

	-- Buttons
	local up = Instance.new("TextButton")
	up.Name = "up"
	up.Parent = flyFrame
	up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
	up.Size = UDim2.new(0, 44, 0, 28)
	up.Font = Enum.Font.SourceSans
	up.Text = "UP"
	up.TextColor3 = Color3.fromRGB(0, 0, 0)
	up.TextSize = 14

	local down = Instance.new("TextButton")
	down.Name = "down"
	down.Parent = flyFrame
	down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
	down.Position = UDim2.new(0, 0, 0.491228074, 0)
	down.Size = UDim2.new(0, 44, 0, 28)
	down.Font = Enum.Font.SourceSans
	down.Text = "DOWN"
	down.TextColor3 = Color3.fromRGB(0, 0, 0)
	down.TextSize = 14

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

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Parent = flyFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
	titleLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
	titleLabel.Size = UDim2.new(0, 100, 0, 28)
	titleLabel.Font = Enum.Font.SourceSans
	titleLabel.Text = "AzkaFLY"
	titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	titleLabel.TextScaled = true

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

	local closeFly = Instance.new("TextButton")
	closeFly.Name = "Close"
	closeFly.Parent = flyFrame
	closeFly.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
	closeFly.Font = Enum.Font.SourceSans
	closeFly.Size = UDim2.new(0, 45, 0, 28)
	closeFly.Text = "X"
	closeFly.TextSize = 30
	closeFly.Position = UDim2.new(0, 0, -1, 27)

	local mini = Instance.new("TextButton")
	mini.Name = "minimize"
	mini.Parent = flyFrame
	mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
	mini.Font = Enum.Font.SourceSans
	mini.Size = UDim2.new(0, 45, 0, 28)
	mini.Text = "-"
	mini.TextSize = 40
	mini.Position = UDim2.new(0, 44, -1, 27)

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

	-- Fly logic (sederhana)
	local speeds = 1
	local nowe = false
	local tpwalking = false
	local speaker = player

	onof.MouseButton1Click:Connect(function()
		if nowe then
			nowe = false
			-- matikan fly (kode asli bisa ditambahkan)
		else
			nowe = true
			-- hidupkan fly
		end
	end)

	-- Up/Down hold
	local tis, dis
	up.MouseButton1Down:Connect(function()
		tis = up.MouseEnter:Connect(function()
			while tis do
				task.wait()
				player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
			end
		end)
	end)
	up.MouseLeave:Connect(function()
		if tis then tis:Disconnect() tis = nil end
	end)

	down.MouseButton1Down:Connect(function()
		dis = down.MouseEnter:Connect(function()
			while dis do
				task.wait()
				player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
			end
		end)
	end)
	down.MouseLeave:Connect(function()
		if dis then dis:Disconnect() dis = nil end
	end)

	-- Speed controls
	plus.MouseButton1Click:Connect(function()
		speeds = speeds + 1
		speedLabel.Text = tostring(speeds)
	end)

	mine.MouseButton1Click:Connect(function()
		if speeds > 1 then
			speeds = speeds - 1
			speedLabel.Text = tostring(speeds)
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

	player.CharacterAdded:Connect(function()
		task.wait(0.7)
		player.Character.Humanoid.PlatformStand = false
		player.Character.Animate.Disabled = false
	end)

	return flyGui, flyFrame, closeFly
end

-- Buat fly UI
local flyGui, flyFrame, flyClose = createFlyUI()

-- Fungsi untuk mengatur visibilitas fly UI
local function setFlyUIVisible(flag)
	flyFrame.Visible = flag
	flyUIBtn.Text = "Fly UI" .. (flag and ": ON" or ": OFF")
	flyUIBtn.BackgroundColor3 = flag and Color3.fromRGB(35, 70, 45) or Color3.fromRGB(40, 40, 48)
end

-- Hubungkan tombol close fly dengan toggle
flyClose.MouseButton1Click:Connect(function()
	setFlyUIVisible(false)
end)

-- Hubungkan flyUIBtn
flyUIBtn.MouseButton1Click:Connect(function()
	local newState = not flyFrame.Visible
	setFlyUIVisible(newState)
end)

-- ========== TELEPORT UI (baru dengan minimize, gear, player list) ==========
_G.AzkaTeleports = _G.AzkaTeleports or {}

local function createTeleportUI()
	local tpGui = Instance.new("ScreenGui")
	tpGui.Name = tpGUIName
	tpGui.ResetOnSpawn = false
	tpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tpGui.Parent = CoreGui

	-- Main Teleport Panel
	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(400, 500)  -- diperbesar
	main.Position = UDim2.new(0.5, -200, 0.3, -250)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	main.Visible = false
	main.Parent = tpGui
	makeDraggable(main, main)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
	Instance.new("UIStroke", main).Color = Color3.fromRGB(80, 120, 255)

	-- Title bar
	local tbar = Instance.new("Frame")
	tbar.Size = UDim2.new(1, 0, 0, 36)
	tbar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	tbar.Parent = main
	Instance.new("UICorner", tbar).CornerRadius = UDim.new(0, 12)

	-- Gear button di kiri
	local tgear = Instance.new("TextButton")
	tgear.Size = UDim2.fromOffset(36, 24)
	tgear.Position = UDim2.new(0, 12, 0.5, -12)
	tgear.Text = "⚙"
	tgear.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	tgear.TextColor3 = Color3.fromRGB(200, 205, 220)
	tgear.Font = Enum.Font.GothamBold
	tgear.TextSize = 20
	Instance.new("UICorner", tgear).CornerRadius = UDim.new(0, 8)
	tgear.Parent = tbar

	local ttitle = Instance.new("TextLabel")
	ttitle.BackgroundTransparency = 1
	ttitle.Size = UDim2.new(1, -120, 1, 0)
	ttitle.Position = UDim2.new(0, 50, 0, 0)
	ttitle.Text = "Teleport Menu"
	ttitle.Font = Enum.Font.GothamBold
	ttitle.TextSize = 18
	ttitle.TextColor3 = Color3.fromRGB(230, 235, 255)
	ttitle.TextXAlignment = Enum.TextXAlignment.Center
	ttitle.Parent = tbar

	-- Minimize button (kiri dari close)
	local tmin = Instance.new("TextButton")
	tmin.Size = UDim2.fromOffset(36, 24)
	tmin.Position = UDim2.new(1, -84, 0.5, -12)
	tmin.Text = "—"
	tmin.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	tmin.TextColor3 = Color3.fromRGB(200, 205, 220)
	tmin.Font = Enum.Font.GothamBold
	tmin.TextSize = 20
	Instance.new("UICorner", tmin).CornerRadius = UDim.new(0, 8)
	tmin.Parent = tbar

	-- Close button
	local tpClose = Instance.new("TextButton")
	tpClose.Size = UDim2.fromOffset(36, 24)
	tpClose.Position = UDim2.new(1, -44, 0.5, -12)
	tpClose.Text = "X"
	tpClose.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
	tpClose.TextColor3 = Color3.fromRGB(255, 220, 220)
	Instance.new("UICorner", tpClose).CornerRadius = UDim.new(0, 8)
	tpClose.Parent = tbar

	-- Body dengan tab control (Saved Teleports dan Live Players)
	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, -20, 0, 40)
	tabFrame.Position = UDim2.new(0, 10, 0, 44)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Parent = main

	local tabLayout = Instance.new("UIListLayout", tabFrame)
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 10)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local savedTab = Instance.new("TextButton")
	savedTab.Size = UDim2.new(0, 150, 0, 30)
	savedTab.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
	savedTab.Text = "Saved Teleports"
	savedTab.TextColor3 = Color3.new(1,1,1)
	savedTab.Font = Enum.Font.GothamBold
	savedTab.TextSize = 14
	Instance.new("UICorner", savedTab).CornerRadius = UDim.new(0, 8)
	savedTab.Parent = tabFrame

	local playersTab = Instance.new("TextButton")
	playersTab.Size = UDim2.new(0, 150, 0, 30)
	playersTab.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	playersTab.Text = "Live Players"
	playersTab.TextColor3 = Color3.new(1,1,1)
	playersTab.Font = Enum.Font.GothamBold
	playersTab.TextSize = 14
	Instance.new("UICorner", playersTab).CornerRadius = UDim.new(0, 8)
	playersTab.Parent = tabFrame

	-- Kontainer untuk konten tab
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -20, 0, 350)
	contentFrame.Position = UDim2.new(0, 10, 0, 90)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = main
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y

	-- Tab Saved Teleports
	local savedContainer = Instance.new("ScrollingFrame")
	savedContainer.Size = UDim2.new(1, 0, 1, 0)
	savedContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	savedContainer.BackgroundTransparency = 0
	savedContainer.ScrollBarThickness = 6
	savedContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	savedContainer.Visible = true
	savedContainer.Parent = contentFrame
	Instance.new("UICorner", savedContainer).CornerRadius = UDim.new(0, 8)

	local savedLayout = Instance.new("UIListLayout", savedContainer)
	savedLayout.Padding = UDim.new(0, 8)
	savedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Tombol Save Teleport di dalam savedContainer
	local saveBtn = Instance.new("TextButton")
	saveBtn.Size = UDim2.new(1, -10, 0, 40)
	saveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	saveBtn.Text = "Save Teleport"
	saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveBtn.Font = Enum.Font.GothamBold
	saveBtn.TextSize = 16
	Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
	saveBtn.Parent = savedContainer

	-- List saved teleports
	local listSaved = Instance.new("ScrollingFrame")
	listSaved.Size = UDim2.new(1, -10, 0, 250)
	listSaved.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	listSaved.BackgroundTransparency = 0
	listSaved.ScrollBarThickness = 6
	listSaved.CanvasSize = UDim2.new(0, 0, 0, 0)
	listSaved.Parent = savedContainer
	Instance.new("UICorner", listSaved).CornerRadius = UDim.new(0, 8)

	local listSavedLayout = Instance.new("UIListLayout", listSaved)
	listSavedLayout.Padding = UDim.new(0, 5)
	listSavedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Pagination untuk saved teleports
	local savedPageFrame = Instance.new("Frame")
	savedPageFrame.Size = UDim2.new(1, -10, 0, 30)
	savedPageFrame.BackgroundTransparency = 1
	savedPageFrame.Parent = savedContainer

	local savedPageLayout = Instance.new("UIListLayout", savedPageFrame)
	savedPageLayout.FillDirection = Enum.FillDirection.Horizontal
	savedPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	savedPageLayout.Padding = UDim.new(0, 5)

	-- Tab Live Players
	local playersContainer = Instance.new("ScrollingFrame")
	playersContainer.Size = UDim2.new(1, 0, 1, 0)
	playersContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	playersContainer.BackgroundTransparency = 0
	playersContainer.ScrollBarThickness = 6
	playersContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	playersContainer.Visible = false
	playersContainer.Parent = contentFrame
	Instance.new("UICorner", playersContainer).CornerRadius = UDim.new(0, 8)

	local playersLayout = Instance.new("UIListLayout", playersContainer)
	playersLayout.Padding = UDim.new(0, 5)
	playersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Fungsi refresh saved teleports
	local savedItemsPerPage = 5
	local savedCurrentPage = 1
	local savedTotalPages = 1

	local function refreshSavedList()
		-- Hapus semua item di listSaved kecuali layout
		for _, child in ipairs(listSaved:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end
		for _, child in ipairs(savedPageFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		local teleports = _G.AzkaTeleports
		savedTotalPages = math.max(1, math.ceil(#teleports / savedItemsPerPage))
		savedCurrentPage = math.clamp(savedCurrentPage, 1, savedTotalPages)
		local start = (savedCurrentPage-1)*savedItemsPerPage + 1
		local finish = math.min(start + savedItemsPerPage - 1, #teleports)

		for i = start, finish do
			local data = teleports[i]
			local item = Instance.new("Frame")
			item.Size = UDim2.new(1, -10, 0, 40)
			item.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
			Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
			item.Parent = listSaved

			local name = Instance.new("TextLabel")
			name.Size = UDim2.new(0.5, -5, 1, 0)
			name.Position = UDim2.new(0, 5, 0, 0)
			name.BackgroundTransparency = 1
			name.Text = data.name
			name.TextColor3 = Color3.new(1,1,1)
			name.Font = Enum.Font.GothamBold
			name.TextSize = 14
			name.TextXAlignment = Enum.TextXAlignment.Left
			name.Parent = item

			local tp = Instance.new("TextButton")
			tp.Size = UDim2.new(0, 80, 0, 30)
			tp.Position = UDim2.new(0.5, 5, 0.5, -15)
			tp.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
			tp.Text = "Teleport"
			tp.TextColor3 = Color3.new(1,1,1)
			tp.Font = Enum.Font.GothamMedium
			tp.TextSize = 12
			Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 6)
			tp.Parent = item
			tp.MouseButton1Click:Connect(function()
				if data.pos then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						char.HumanoidRootPart.CFrame = CFrame.new(data.pos)
					end
				end
			end)

			local del = Instance.new("TextButton")
			del.Size = UDim2.new(0, 60, 0, 30)
			del.Position = UDim2.new(1, -65, 0.5, -15)
			del.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
			del.Text = "Delete"
			del.TextColor3 = Color3.new(1,1,1)
			del.Font = Enum.Font.GothamMedium
			del.TextSize = 12
			Instance.new("UICorner", del).CornerRadius = UDim.new(0, 6)
			del.Parent = item
			del.MouseButton1Click:Connect(function()
				table.remove(_G.AzkaTeleports, i)
				refreshSavedList()
			end)
		end

		-- Pagination buttons
		for p = 1, savedTotalPages do
			local pageBtn = Instance.new("TextButton")
			pageBtn.Size = UDim2.fromOffset(30, 30)
			pageBtn.BackgroundColor3 = (p == savedCurrentPage) and Color3.fromRGB(80,120,255) or Color3.fromRGB(50,50,60)
			pageBtn.Text = tostring(p)
			pageBtn.TextColor3 = Color3.new(1,1,1)
			pageBtn.Font = Enum.Font.GothamBold
			pageBtn.TextSize = 14
			Instance.new("UICorner", pageBtn).CornerRadius = UDim.new(0, 6)
			pageBtn.Parent = savedPageFrame
			pageBtn.MouseButton1Click:Connect(function()
				savedCurrentPage = p
				refreshSavedList()
			end)
		end

		-- Update canvas size listSaved
		local h = 0
		for _, ch in ipairs(listSaved:GetChildren()) do
			if ch:IsA("Frame") then
				h = h + ch.Size.Y.Offset + listSavedLayout.Padding.Offset
			end
		end
		listSaved.CanvasSize = UDim2.new(0,0,0,h)
	end

	-- Fungsi refresh live players
	local function refreshPlayersList()
		for _, child in ipairs(playersContainer:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				local item = Instance.new("Frame")
				item.Size = UDim2.new(1, -10, 0, 50)
				item.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
				Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
				item.Parent = playersContainer

				local name = Instance.new("TextLabel")
				name.Size = UDim2.new(1, -10, 0, 20)
				name.Position = UDim2.new(0, 5, 0, 2)
				name.BackgroundTransparency = 1
				name.Text = plr.Name .. (plr.DisplayName ~= plr.Name and " ("..plr.DisplayName..")" or "")
				name.TextColor3 = Color3.new(1,1,1)
				name.Font = Enum.Font.GothamBold
				name.TextSize = 14
				name.TextXAlignment = Enum.TextXAlignment.Left
				name.Parent = item

				local tpBtn = Instance.new("TextButton")
				tpBtn.Size = UDim2.new(0, 100, 0, 30)
				tpBtn.Position = UDim2.new(0.5, -50, 0, 25)
				tpBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
				tpBtn.Text = "Teleport"
				tpBtn.TextColor3 = Color3.new(1,1,1)
				tpBtn.Font = Enum.Font.GothamMedium
				tpBtn.TextSize = 14
				Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
				tpBtn.Parent = item
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

		local h = 0
		for _, ch in ipairs(playersContainer:GetChildren()) do
			if ch:IsA("Frame") then
				h = h + ch.Size.Y.Offset + playersLayout.Padding.Offset
			end
		end
		playersContainer.CanvasSize = UDim2.new(0,0,0,h)
	end

	-- Tab switching
	savedTab.MouseButton1Click:Connect(function()
		savedTab.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
		playersTab.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
		savedContainer.Visible = true
		playersContainer.Visible = false
		refreshSavedList()
	end)

	playersTab.MouseButton1Click:Connect(function()
		playersTab.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
		savedTab.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
		savedContainer.Visible = false
		playersContainer.Visible = true
		refreshPlayersList()
	end)

	-- Panel Save (sub)
	local saveSub = Instance.new("Frame")
	saveSub.Size = UDim2.fromOffset(300,220)
	saveSub.Position = UDim2.new(0.5,-150,0.5,-110)
	saveSub.BackgroundColor3 = Color3.fromRGB(20,20,24)
	saveSub.Visible = false
	saveSub.Parent = tpGui
	makeDraggable(saveSub, saveSub)
	Instance.new("UICorner", saveSub).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", saveSub).Color = Color3.fromRGB(80,120,255)

	local subTitle = Instance.new("TextLabel")
	subTitle.Size = UDim2.new(1,0,0,40)
	subTitle.BackgroundColor3 = Color3.fromRGB(28,28,34)
	subTitle.Text = "Save Teleport"
	subTitle.Font = Enum.Font.GothamBold
	subTitle.TextSize = 18
	subTitle.TextColor3 = Color3.fromRGB(230,235,255)
	Instance.new("UICorner", subTitle).CornerRadius = UDim.new(0,12)
	subTitle.Parent = saveSub

	local coord = Instance.new("TextLabel")
	coord.Size = UDim2.new(1,-20,0,30)
	coord.Position = UDim2.new(0,10,0,50)
	coord.BackgroundTransparency = 1
	coord.Text = "Position: 0, 0, 0"
	coord.TextColor3 = Color3.fromRGB(255,255,255)
	coord.Font = Enum.Font.GothamBold
	coord.TextSize = 16
	coord.Parent = saveSub

	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(1,-20,0,36)
	nameBox.Position = UDim2.new(0,10,0,90)
	nameBox.BackgroundColor3 = Color3.fromRGB(40,40,48)
	nameBox.PlaceholderText = "Nama"
	nameBox.Text = ""
	nameBox.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,8)
	nameBox.Parent = saveSub

	local saveSubBtn = Instance.new("TextButton")
	saveSubBtn.Size = UDim2.new(0,100,0,40)
	saveSubBtn.Position = UDim2.new(0,10,0,140)
	saveSubBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
	saveSubBtn.Text = "Save"
	saveSubBtn.TextColor3 = Color3.new(1,1,1)
	saveSubBtn.Font = Enum.Font.GothamBold
	saveSubBtn.TextSize = 16
	Instance.new("UICorner", saveSubBtn).CornerRadius = UDim.new(0,8)
	saveSubBtn.Parent = saveSub

	local closeSubBtn = Instance.new("TextButton")
	closeSubBtn.Size = UDim2.new(0,100,0,40)
	closeSubBtn.Position = UDim2.new(1,-110,0,140)
	closeSubBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
	closeSubBtn.Text = "Close"
	closeSubBtn.TextColor3 = Color3.new(1,1,1)
	closeSubBtn.Font = Enum.Font.GothamBold
	closeSubBtn.TextSize = 16
	Instance.new("UICorner", closeSubBtn).CornerRadius = UDim.new(0,8)
	closeSubBtn.Parent = saveSub

	saveBtn.MouseButton1Click:Connect(function()
		local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
		if pos then
			coord.Text = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
		end
		main.Visible = false
		saveSub.Visible = true
	end)

	saveSubBtn.MouseButton1Click:Connect(function()
		local name = nameBox.Text
		if name == "" then
			name = "Teleport " .. (#_G.AzkaTeleports + 1)
		end
		local pos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
		if pos then
			table.insert(_G.AzkaTeleports, {name = name, pos = pos})
			refreshSavedList()
			saveSub.Visible = false
			main.Visible = true
			nameBox.Text = ""
		end
	end)

	closeSubBtn.MouseButton1Click:Connect(function()
		saveSub.Visible = false
		main.Visible = true
		nameBox.Text = ""
	end)

	-- Minimize untuk TP UI
	local tpMinimized = false
	local tpMinimizedIcon = Instance.new("TextButton")
	tpMinimizedIcon.Name = "TPMinimized"
	tpMinimizedIcon.Size = UDim2.fromOffset(40, 40)
	tpMinimizedIcon.Position = UDim2.new(0.5, -20, 0.5, -20)
	tpMinimizedIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	tpMinimizedIcon.Text = "TP"
	tpMinimizedIcon.TextColor3 = Color3.fromRGB(220, 230, 255)
	tpMinimizedIcon.Font = Enum.Font.GothamBold
	tpMinimizedIcon.TextSize = 20
	tpMinimizedIcon.Visible = false
	Instance.new("UICorner", tpMinimizedIcon).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", tpMinimizedIcon).Color = Color3.fromRGB(80, 120, 255)
	tpMinimizedIcon.Parent = tpGui
	makeDraggable(tpMinimizedIcon, tpMinimizedIcon)

	tmin.MouseButton1Click:Connect(function()
		main.Visible = false
		tpMinimizedIcon.Visible = true
		tpMinimized = true
	end)

	tpMinimizedIcon.MouseButton1Click:Connect(function()
		tpMinimizedIcon.Visible = false
		main.Visible = true
		tpMinimized = false
	end)

	refreshSavedList()
	return tpGui, main, tpClose, tpMinimizedIcon
end

-- Buat TP UI
local tpGui, tpMain, tpClose, tpMinimizedIcon = createTeleportUI()

-- Fungsi untuk mengatur visibilitas TP UI (termasuk minimized icon)
local function setTPUIVisible(flag)
	tpMain.Visible = flag
	tpMinimizedIcon.Visible = false  -- jika di-off, sembunyikan juga icon
	tpUIBtn.Text = "TP UI" .. (flag and ": ON" or ": OFF")
	tpUIBtn.BackgroundColor3 = flag and Color3.fromRGB(35, 70, 45) or Color3.fromRGB(40, 40, 48)
end

-- Hubungkan tombol close TP
tpClose.MouseButton1Click:Connect(function()
	setTPUIVisible(false)
end)

-- Hubungkan tpUIBtn
tpUIBtn.MouseButton1Click:Connect(function()
	local newState = not tpMain.Visible and not tpMinimizedIcon.Visible
	setTPUIVisible(newState)
	if newState then
		tpMain.Visible = true
	end
end)

-- Update jika TP dalam keadaan minimized lalu di-off dari main menu, harus sembunyikan icon
-- Sudah di-handle oleh setTPUIVisible

-- ========== FPS UI (kerangka) ==========
local function createFPSUI()
	local fpsGui = Instance.new("ScreenGui")
	fpsGui.Name = fpsGUIName
	fpsGui.ResetOnSpawn = false
	fpsGui.Parent = CoreGui

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(350, 400)
	main.Position = UDim2.new(0.5, -175, 0.3, -200)
	main.BackgroundColor3 = Color3.fromRGB(20,20,24)
	main.Visible = false
	main.Parent = fpsGui
	makeDraggable(main, main)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", main).Color = Color3.fromRGB(80,120,255)

	-- Title bar
	local tbar = Instance.new("Frame")
	tbar.Size = UDim2.new(1,0,0,36)
	tbar.BackgroundColor3 = Color3.fromRGB(28,28,34)
	tbar.Parent = main
	Instance.new("UICorner", tbar).CornerRadius = UDim.new(0,12)

	local tgear = Instance.new("TextButton")
	tgear.Size = UDim2.fromOffset(36,24)
	tgear.Position = UDim2.new(0,12,0.5,-12)
	tgear.Text = "⚙"
	tgear.BackgroundColor3 = Color3.fromRGB(40,40,48)
	tgear.TextColor3 = Color3.fromRGB(200,205,220)
	tgear.Font = Enum.Font.GothamBold
	tgear.TextSize = 20
	Instance.new("UICorner", tgear).CornerRadius = UDim.new(0,8)
	tgear.Parent = tbar

	local ttitle = Instance.new("TextLabel")
	ttitle.BackgroundTransparency = 1
	ttitle.Size = UDim2.new(1,-120,1,0)
	ttitle.Position = UDim2.new(0,50,0,0)
	ttitle.Text = "FPS UI"
	ttitle.Font = Enum.Font.GothamBold
	ttitle.TextSize = 18
	ttitle.TextColor3 = Color3.fromRGB(230,235,255)
	ttitle.TextXAlignment = Enum.TextXAlignment.Center
	ttitle.Parent = tbar

	local tmin = Instance.new("TextButton")
	tmin.Size = UDim2.fromOffset(36,24)
	tmin.Position = UDim2.new(1,-84,0.5,-12)
	tmin.Text = "—"
	tmin.BackgroundColor3 = Color3.fromRGB(40,40,48)
	tmin.TextColor3 = Color3.fromRGB(200,205,220)
	tmin.Font = Enum.Font.GothamBold
	tmin.TextSize = 20
	Instance.new("UICorner", tmin).CornerRadius = UDim.new(0,8)
	tmin.Parent = tbar

	local tclose = Instance.new("TextButton")
	tclose.Size = UDim2.fromOffset(36,24)
	tclose.Position = UDim2.new(1,-44,0.5,-12)
	tclose.Text = "X"
	tclose.BackgroundColor3 = Color3.fromRGB(60,30,30)
	tclose.TextColor3 = Color3.fromRGB(255,220,220)
	Instance.new("UICorner", tclose).CornerRadius = UDim.new(0,8)
	tclose.Parent = tbar

	-- Body dengan scrolling
	local body = Instance.new("ScrollingFrame")
	body.Size = UDim2.new(1,-20,1,-50)
	body.Position = UDim2.new(0,10,0,44)
	body.BackgroundColor3 = Color3.fromRGB(30,30,36)
	body.ScrollBarThickness = 6
	body.CanvasSize = UDim2.new(0,0,0,0)
	body.Parent = main
	Instance.new("UICorner", body).CornerRadius = UDim.new(0,8)

	local layout = Instance.new("UIListLayout", body)
	layout.Padding = UDim.new(0,8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Row 1 FPS
	local row1 = Instance.new("Frame")
	row1.Size = UDim2.new(1,0,0,30)
	row1.BackgroundTransparency = 1
	row1.Parent = body
	local row1Layout = Instance.new("UIListLayout", row1)
	row1Layout.FillDirection = Enum.FillDirection.Horizontal
	row1Layout.Padding = UDim.new(0,5)
	row1Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local visTargetBtn, _ = createToggleButton(row1, "Vis Target", 100)
	local visibleCheckBtn, _ = createToggleButton(row1, "Visible Check", 100)
	local hitchanceBtn, _ = createToggleButton(row1, "Hitchance", 100)
	-- Infinite Zoom di sini sinkron dengan main menu? nanti diatur

	-- Row 2 FPS
	local row2 = Instance.new("Frame")
	row2.Size = UDim2.new(1,0,0,30)
	row2.BackgroundTransparency = 1
	row2.Parent = body
	local row2Layout = Instance.new("UIListLayout", row2)
	row2Layout.FillDirection = Enum.FillDirection.Horizontal
	row2Layout.Padding = UDim.new(0,5)
	row2Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local espBtn, _ = createToggleButton(row2, "ESP", 80)
	local espBoxesBtn, _ = createToggleButton(row2, "ESP Boxes", 90)
	local healthBtn, _ = createToggleButton(row2, "Health", 80)
	local dispNameBtn, _ = createToggleButton(row2, "DispName", 90)

	-- Row 3 FPS
	local row3 = Instance.new("Frame")
	row3.Size = UDim2.new(1,0,0,30)
	row3.BackgroundTransparency = 1
	row3.Parent = body
	local row3Layout = Instance.new("UIListLayout", row3)
	row3Layout.FillDirection = Enum.FillDirection.Horizontal
	row3Layout.Padding = UDim.new(0,5)
	row3Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local equipBtn, _ = createToggleButton(row3, "Equip", 70)
	local distanceBtn, _ = createToggleButton(row3, "Distance", 80)
	local tracersBtn, _ = createToggleButton(row3, "Tracers", 80)
	local teamColorBtn, _ = createToggleButton(row3, "Team Color", 90)

	-- Minimize icon
	local fpsMinimizedIcon = Instance.new("TextButton")
	fpsMinimizedIcon.Name = "FPSMinimized"
	fpsMinimizedIcon.Size = UDim2.fromOffset(40, 40)
	fpsMinimizedIcon.Position = UDim2.new(0.5, -20, 0.5, -20)
	fpsMinimizedIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	fpsMinimizedIcon.Text = "FPS"
	fpsMinimizedIcon.TextColor3 = Color3.fromRGB(220, 230, 255)
	fpsMinimizedIcon.Font = Enum.Font.GothamBold
	fpsMinimizedIcon.TextSize = 20
	fpsMinimizedIcon.Visible = false
	Instance.new("UICorner", fpsMinimizedIcon).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", fpsMinimizedIcon).Color = Color3.fromRGB(80, 120, 255)
	fpsMinimizedIcon.Parent = fpsGui
	makeDraggable(fpsMinimizedIcon, fpsMinimizedIcon)

	tmin.MouseButton1Click:Connect(function()
		main.Visible = false
		fpsMinimizedIcon.Visible = true
	end)

	fpsMinimizedIcon.MouseButton1Click:Connect(function()
		fpsMinimizedIcon.Visible = false
		main.Visible = true
	end)

	tclose.MouseButton1Click:Connect(function()
		fpsMinimizedIcon.Visible = false
		main.Visible = false
		-- Update toggle di main menu
		fpsUIBtn.Text = "FPS UI: OFF"
		fpsUIBtn.BackgroundColor3 = Color3.fromRGB(40,40,48)
	end)

	return fpsGui, main, fpsMinimizedIcon
end

local fpsGui, fpsMain, fpsMinimizedIcon = createFPSUI()

-- Fungsi untuk mengatur visibilitas FPS UI
local function setFPSUIVisible(flag)
	fpsMain.Visible = flag
	fpsMinimizedIcon.Visible = false
	fpsUIBtn.Text = "FPS UI" .. (flag and ": ON" or ": OFF")
	fpsUIBtn.BackgroundColor3 = flag and Color3.fromRGB(35, 70, 45) or Color3.fromRGB(40, 40, 48)
end

fpsUIBtn.MouseButton1Click:Connect(function()
	local newState = not fpsMain.Visible and not fpsMinimizedIcon.Visible
	setFPSUIVisible(newState)
	if newState then
		fpsMain.Visible = true
	end
end)

-- ========== SCRIPT LIBRARY UI (placeholder) ==========
local function createScriptLibUI()
	local libGui = Instance.new("ScreenGui")
	libGui.Name = scriptLibGUIName
	libGui.ResetOnSpawn = false
	libGui.Parent = CoreGui

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(300, 200)
	main.Position = UDim2.new(0.5, -150, 0.4, -100)
	main.BackgroundColor3 = Color3.fromRGB(20,20,24)
	main.Visible = false
	main.Parent = libGui
	makeDraggable(main, main)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", main).Color = Color3.fromRGB(80,120,255)

	local tbar = Instance.new("Frame")
	tbar.Size = UDim2.new(1,0,0,36)
	tbar.BackgroundColor3 = Color3.fromRGB(28,28,34)
	tbar.Parent = main
	Instance.new("UICorner", tbar).CornerRadius = UDim.new(0,12)

	local ttitle = Instance.new("TextLabel")
	ttitle.BackgroundTransparency = 1
	ttitle.Size = UDim2.new(1,-90,1,0)
	ttitle.Position = UDim2.new(0,12,0,0)
	ttitle.Text = "Script Library"
	ttitle.Font = Enum.Font.GothamBold
	ttitle.TextSize = 16
	ttitle.TextColor3 = Color3.fromRGB(230,235,255)
	ttitle.TextXAlignment = Enum.TextXAlignment.Left
	ttitle.Parent = tbar

	local tclose = Instance.new("TextButton")
	tclose.Size = UDim2.fromOffset(36,24)
	tclose.Position = UDim2.new(1,-44,0.5,-12)
	tclose.Text = "X"
	tclose.BackgroundColor3 = Color3.fromRGB(60,30,30)
	tclose.TextColor3 = Color3.fromRGB(255,220,220)
	Instance.new("UICorner", tclose).CornerRadius = UDim.new(0,8)
	tclose.Parent = tbar

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-20,1,-50)
	label.Position = UDim2.new(0,10,0,44)
	label.BackgroundTransparency = 1
	label.Text = "Script Library (coming soon)"
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Parent = main

	tclose.MouseButton1Click:Connect(function()
		main.Visible = false
		scriptLibBtn.Text = "Script Lib: OFF"
		scriptLibBtn.BackgroundColor3 = Color3.fromRGB(40,40,48)
	end)

	return libGui, main
end

local libGui, libMain = createScriptLibUI()

scriptLibBtn.MouseButton1Click:Connect(function()
	local newState = not libMain.Visible
	libMain.Visible = newState
	scriptLibBtn.Text = "Script Lib" .. (newState and ": ON" or ": OFF")
	scriptLibBtn.BackgroundColor3 = newState and Color3.fromRGB(35,70,45) or Color3.fromRGB(40,40,48)
end)

-- ========== SETTINGS UI (gear) ==========
local function createSettingsUI()
	local setGui = Instance.new("ScreenGui")
	setGui.Name = settingsGUIName
	setGui.ResetOnSpawn = false
	setGui.Parent = CoreGui

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(300, 200)
	main.Position = UDim2.new(0.5, -150, 0.4, -100)
	main.BackgroundColor3 = Color3.fromRGB(20,20,24)
	main.Visible = false
	main.Parent = setGui
	makeDraggable(main, main)
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", main).Color = Color3.fromRGB(80,120,255)

	local tbar = Instance.new("Frame")
	tbar.Size = UDim2.new(1,0,0,36)
	tbar.BackgroundColor3 = Color3.fromRGB(28,28,34)
	tbar.Parent = main
	Instance.new("UICorner", tbar).CornerRadius = UDim.new(0,12)

	local ttitle = Instance.new("TextLabel")
	ttitle.BackgroundTransparency = 1
	ttitle.Size = UDim2.new(1,-90,1,0)
	ttitle.Position = UDim2.new(0,12,0,0)
	ttitle.Text = "Settings"
	ttitle.Font = Enum.Font.GothamBold
	ttitle.TextSize = 16
	ttitle.TextColor3 = Color3.fromRGB(230,235,255)
	ttitle.TextXAlignment = Enum.TextXAlignment.Left
	ttitle.Parent = tbar

	local tclose = Instance.new("TextButton")
	tclose.Size = UDim2.fromOffset(36,24)
	tclose.Position = UDim2.new(1,-44,0.5,-12)
	tclose.Text = "X"
	tclose.BackgroundColor3 = Color3.fromRGB(60,30,30)
	tclose.TextColor3 = Color3.fromRGB(255,220,220)
	Instance.new("UICorner", tclose).CornerRadius = UDim.new(0,8)
	tclose.Parent = tbar

	local body = Instance.new("Frame")
	body.Size = UDim2.new(1,-20,1,-50)
	body.Position = UDim2.new(0,10,0,44)
	body.BackgroundTransparency = 1
	body.Parent = main

	local layout = Instance.new("UIListLayout", body)
	layout.Padding = UDim.new(0,8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Anti-AFK toggle
	local afkBtn, getAfk = createToggleButton(body, "Anti-AFK", 150)

	-- Server Hop & Rejoin button
	local hopBtn = Instance.new("TextButton")
	hopBtn.Size = UDim2.new(1, -10, 0, 40)
	hopBtn.BackgroundColor3 = Color3.fromRGB(40,40,48)
	hopBtn.Text = "Server Hop & Rejoin"
	hopBtn.TextColor3 = Color3.fromRGB(255,255,255)
	hopBtn.Font = Enum.Font.GothamBold
	hopBtn.TextSize = 14
	Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0,8)
	hopBtn.Parent = body
	hopBtn.MouseButton1Click:Connect(function()
		-- Rejoin ke server yang sama
		local ts = game:GetService("TeleportService")
		local placeId = game.PlaceId
		local jobId = game.JobId
		ts:Teleport(placeId, player, nil, jobId)
	end)

	-- Character Respawn
	local respawnBtn = Instance.new("TextButton")
	respawnBtn.Size = UDim2.new(1, -10, 0, 40)
	respawnBtn.BackgroundColor3 = Color3.fromRGB(40,40,48)
	respawnBtn.Text = "Character Respawn"
	respawnBtn.TextColor3 = Color3.fromRGB(255,255,255)
	respawnBtn.Font = Enum.Font.GothamBold
	respawnBtn.TextSize = 14
	Instance.new("UICorner", respawnBtn).CornerRadius = UDim.new(0,8)
	respawnBtn.Parent = body
	respawnBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if char then
			char:BreakJoints()
		end
	end)

	-- Anti-AFK loop
	task.spawn(function()
		local vu = game:GetService("VirtualUser")
		player.Idled:Connect(function()
			if getAfk() then
				vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(1)
				vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end
		end)
	end)

	return setGui, main
end

local setGui, setMain = createSettingsUI()

-- Hubungkan semua gear button
gearBtn.MouseButton1Click:Connect(function()
	setMain.Visible = not setMain.Visible
end)
-- Untuk TP UI gear
local tgear = tpGui:FindFirstChild("Frame"):FindFirstChild("TitleBar"):FindFirstChild("Settings", true)
if tgear then
	tgear.MouseButton1Click:Connect(function()
		setMain.Visible = not setMain.Visible
	end)
end
-- Untuk FPS UI gear
local fgear = fpsGui:FindFirstChild("Frame"):FindFirstChild("TitleBar"):FindFirstChild("Settings", true)
if fgear then
	fgear.MouseButton1Click:Connect(function()
		setMain.Visible = not setMain.Visible
	end)
end

-- Close main menu
closeBtn.MouseButton1Click:Connect(function()
	running = false
	gui:Destroy()
	flyGui:Destroy()
	tpGui:Destroy()
	fpsGui:Destroy()
	libGui:Destroy()
	setGui:Destroy()
	freecamPart:Destroy()
	freecamInfo:Destroy()
end)

-- Notifikasi
local notif = Instance.new("TextLabel")
notif.Size = UDim2.fromOffset(200,36)
notif.Position = UDim2.new(0.5,-100,0,20)
notif.BackgroundColor3 = Color3.fromRGB(28,28,34)
notif.BackgroundTransparency = 0.2
notif.Text = "Script BY Azka - Loaded"
notif.TextColor3 = Color3.fromRGB(220,230,255)
notif.Font = Enum.Font.Gotham
notif.TextSize = 14
notif.Parent = gui
Instance.new("UICorner", notif).CornerRadius = UDim.new(0,8)

task.wait(2)
TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
task.wait(0.5)
notif:Destroy()
