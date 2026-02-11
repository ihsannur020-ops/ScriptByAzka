--[[
	Speed Control Universal - Delta Executor Ready + Loading Animation
	Oleh: Azka
	Desain: Minimalis, background hitam, tombol biru, switch biru/putih, text putih tebal
	Loading: Full screen hitam 40% opacity, teks "Script By Azka" di tengah
--]]

-- Gunakan task.spawn agar tidak memblokir executor
task.spawn(function()
	-- Panggil pcall untuk menangkap error
	local success, err = pcall(function()
		-- ========== LOADING SCREEN ==========
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		if not player then
			player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		end

		-- Buat loading GUI
		local loadingGui = Instance.new("ScreenGui")
		loadingGui.Name = "LoadingScreen"
		loadingGui.Parent = player:WaitForChild("PlayerGui")
		loadingGui.ResetOnSpawn = false
		loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		loadingGui.DisplayOrder = 999

		local blackFrame = Instance.new("Frame")
		blackFrame.Size = UDim2.new(1, 0, 1, 0)
		blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		blackFrame.BackgroundTransparency = 0.6 -- 40% opacity (solid 40%)
		blackFrame.BorderSizePixel = 0
		blackFrame.Parent = loadingGui

		local loadingText = Instance.new("TextLabel")
		loadingText.Size = UDim2.new(0, 400, 0, 100)
		loadingText.Position = UDim2.new(0.5, -200, 0.5, -50)
		loadingText.BackgroundTransparency = 1
		loadingText.Text = "Script By Azka"
		loadingText.TextColor3 = Color3.new(1, 1, 1)
		loadingText.Font = Enum.Font.GothamBold
		loadingText.TextSize = 48
		loadingText.TextScaled = true
		loadingText.Parent = blackFrame

		-- Efek animasi sederhana (fade in/out teks)
		local tweenService = game:GetService("TweenService")
		local fadeOut = tweenService:Create(loadingText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0.5})
		local fadeIn = tweenService:Create(loadingText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 0})
		local animLoop
		animLoop = game:GetService("RunService").Heartbeat:Connect(function()
			fadeOut:Play()
			fadeOut.Completed:Connect(function()
				fadeIn:Play()
				fadeIn.Completed:Connect(function()
					-- repeat
				end)
			end)
		end)
		
		-- ========== INISIALISASI GLOBAL ==========
		if _G.SpeedControlLoaded then 
			loadingGui:Destroy()
			return 
		end
		_G.SpeedControlLoaded = true

		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")

		-- Data teleport (lokal, hanya untuk sesi)
		local teleportSpots = {}

		-- State fitur
		local flyEnabled = false
		local flySpeed = 20
		local flyConnection = nil
		local flyBodyVelocity = nil

		local noclipEnabled = false
		local noclipConnection = nil

		local infJumpEnabled = false
		local infJumpConnection = nil

		local lastWalkSpeed = 16 -- default

		-- GUI Utama
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "SpeedControlGUI"
		screenGui.Parent = player:WaitForChild("PlayerGui")
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		-- ========== FUNGSI PEMBUAT ELEMEN UI ==========
		local function createSwitch(parent, defaultOn, callback)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 50, 0, 25)
			frame.BackgroundColor3 = defaultOn and Color3.new(0, 0.5, 1) or Color3.new(1,1,1)
			frame.BorderSizePixel = 0

			local toggle = Instance.new("TextButton")
			toggle.Size = UDim2.new(1,0,1,0)
			toggle.Text = defaultOn and "ON" or "OFF"
			toggle.TextColor3 = Color3.new(0,0,0)
			toggle.BackgroundTransparency = 1
			toggle.Font = Enum.Font.GothamBold
			toggle.TextSize = 14
			toggle.Parent = frame

			local state = defaultOn

			local function updateVisual()
				if state then
					frame.BackgroundColor3 = Color3.new(0, 0.5, 1)
					toggle.Text = "ON"
				else
					frame.BackgroundColor3 = Color3.new(1,1,1)
					toggle.Text = "OFF"
				end
			end
			updateVisual()

			toggle.MouseButton1Click:Connect(function()
				state = not state
				updateVisual()
				if callback then task.spawn(callback, state) end
			end)

			frame.Parent = parent
			return frame, function() return state end
		end

		local function createSlider(parent, min, max, defaultValue, callback)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(0, 200, 0, 30)
			container.BackgroundTransparency = 1
			container.Parent = parent

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Size = UDim2.new(0, 40, 1, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.TextColor3 = Color3.new(1,1,1)
			valueLabel.Text = tostring(defaultValue)
			valueLabel.Font = Enum.Font.GothamBold
			valueLabel.TextSize = 16
			valueLabel.Parent = container

			local sliderFrame = Instance.new("Frame")
			sliderFrame.Size = UDim2.new(1, -45, 0, 5)
			sliderFrame.Position = UDim2.new(0, 45, 0.5, -2.5)
			sliderFrame.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
			sliderFrame.BorderSizePixel = 0
			sliderFrame.Parent = container

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.new(0,0.5,1)
			fill.BorderSizePixel = 0
			fill.Parent = sliderFrame

			local drag = Instance.new("TextButton")
			drag.Size = UDim2.new(0, 10, 0, 10)
			drag.Position = UDim2.new(fill.Size.X.Scale, -5, 0.5, -5)
			drag.BackgroundColor3 = Color3.new(1,1,1)
			drag.BorderSizePixel = 0
			drag.Text = ""
			drag.Parent = sliderFrame

			local currentValue = defaultValue
			local dragging = false

			local function updateSliderPosition()
				local percent = (currentValue - min) / (max - min)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				drag.Position = UDim2.new(percent, -5, 0.5, -5)
				valueLabel.Text = tostring(math.floor(currentValue))
			end

			drag.MouseButton1Down:Connect(function()
				dragging = true
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			RunService.RenderStepped:Connect(function()
				if dragging then
					local mousePos = UserInputService:GetMouseLocation()
					local absPos = sliderFrame.AbsolutePosition
					local absSize = sliderFrame.AbsoluteSize
					local relativeX = math.clamp(mousePos.X - absPos.X, 0, absSize.X)
					local percent = relativeX / absSize.X
					currentValue = min + percent * (max - min)
					currentValue = math.clamp(currentValue, min, max)
					updateSliderPosition()
					if callback then callback(currentValue) end
					lastWalkSpeed = currentValue
				end
			end)

			updateSliderPosition()
			return container, function() return currentValue end
		end

		local function createButton(parent, text, size, color, callback)
			local btn = Instance.new("TextButton")
			btn.Size = size or UDim2.new(0, 80, 0, 30)
			btn.BackgroundColor3 = color or Color3.new(0,0.5,1)
			btn.BorderSizePixel = 0
			btn.Text = text
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.Parent = parent
			btn.MouseButton1Click:Connect(function()
				if callback then task.spawn(callback) end
			end)
			return btn
		end

		local function createBoldLabel(parent, text, size)
			local label = Instance.new("TextLabel")
			label.Size = size or UDim2.new(0, 100, 0, 30)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.new(1,1,1)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 16
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = parent
			return label
		end

		local function createTextBox(parent, placeholder, defaultText, maxLength)
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0, 200, 0, 30)
			box.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
			box.BorderSizePixel = 0
			box.TextColor3 = Color3.new(1,1,1)
			box.PlaceholderColor3 = Color3.new(0.7,0.7,0.7)
			box.Font = Enum.Font.Gotham
			box.TextSize = 14
			box.Text = defaultText or ""
			box.PlaceholderText = placeholder
			box.ClearTextOnFocus = false
			box.Parent = parent

			if maxLength then
				box:GetPropertyChangedSignal("Text"):Connect(function()
					if #box.Text > maxLength then
						box.Text = box.Text:sub(1, maxLength)
					end
				end)
			end
			return box
		end

		-- ========== MENU UTAMA ==========
		local function createMainMenu()
			if screenGui:FindFirstChild("MainMenu") then return end

			local mainFrame = Instance.new("Frame")
			mainFrame.Name = "MainMenu"
			mainFrame.Size = UDim2.new(0, 420, 0, 550)
			mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
			mainFrame.BackgroundColor3 = Color3.new(0,0,0)
			mainFrame.BorderSizePixel = 0
			mainFrame.Parent = screenGui

			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 40)
			header.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
			header.BorderSizePixel = 0
			header.Parent = mainFrame

			local title = createBoldLabel(header, "Speed Control By Azka", UDim2.new(0.8, 0, 1, 0))
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Position = UDim2.new(0, 10, 0, 0)

			local minimizeBtn = Instance.new("TextButton")
			minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
			minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
			minimizeBtn.BackgroundTransparency = 1
			minimizeBtn.Text = "-"
			minimizeBtn.TextColor3 = Color3.new(1,1,1)
			minimizeBtn.Font = Enum.Font.GothamBold
			minimizeBtn.TextSize = 20
			minimizeBtn.Parent = header
			minimizeBtn.MouseButton1Click:Connect(function()
				local body = mainFrame:FindFirstChild("Body")
				if body then body.Visible = not body.Visible end
			end)

			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 30, 0, 30)
			closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
			closeBtn.BackgroundTransparency = 1
			closeBtn.Text = "X"
			closeBtn.TextColor3 = Color3.new(1,1,1)
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 20
			closeBtn.Parent = header
			closeBtn.MouseButton1Click:Connect(function()
				if screenGui:FindFirstChild("ConfirmMenu") then return end
				local confirm = Instance.new("Frame")
				confirm.Name = "ConfirmMenu"
				confirm.Size = UDim2.new(0, 300, 0, 150)
				confirm.Position = UDim2.new(0.5, -150, 0.5, -75)
				confirm.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
				confirm.BorderSizePixel = 0
				confirm.Parent = screenGui

				local confirmTitle = createBoldLabel(confirm, "Speed Control By Azka", UDim2.new(1,0,0,40))
				confirmTitle.TextXAlignment = Enum.TextXAlignment.Center

				local noBtn = createButton(confirm, "NO", UDim2.new(0, 80, 0, 40), Color3.new(0,1,0), function()
					confirm:Destroy()
				end)
				noBtn.Position = UDim2.new(0.2, -40, 0.7, -20)

				local yesBtn = createButton(confirm, "YES", UDim2.new(0, 80, 0, 40), Color3.new(1,0,0), function()
					confirm:Destroy()
					screenGui.Enabled = false
					local mainBtn = screenGui:FindFirstChild("MainButton")
					if mainBtn then mainBtn.Visible = false end
					-- Matikan semua fitur
					flyEnabled = false
					if flyConnection then flyConnection:Disconnect() flyConnection = nil end
					if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
					noclipEnabled = false
					if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
					infJumpEnabled = false
					if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
					_G.SpeedControlLoaded = false
				end)
				yesBtn.Position = UDim2.new(0.8, -40, 0.7, -20)
			end)

			local body = Instance.new("ScrollingFrame")
			body.Name = "Body"
			body.Size = UDim2.new(1, 0, 1, -40)
			body.Position = UDim2.new(0, 0, 0, 40)
			body.BackgroundTransparency = 1
			body.BorderSizePixel = 0
			body.ScrollBarThickness = 5
			body.Parent = mainFrame

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 12)
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Parent = body

			local padding = Instance.new("UIPadding")
			padding.PaddingTop = UDim.new(0, 10)
			padding.PaddingBottom = UDim.new(0, 10)
			padding.PaddingLeft = UDim.new(0, 10)
			padding.PaddingRight = UDim.new(0, 10)
			padding.Parent = body

			createBoldLabel(body, "[ Script ]", UDim2.new(1, -20, 0, 25)).LayoutOrder = 1
			createBoldLabel(body, "[ Bagian Utama Script ]", UDim2.new(1, -20, 0, 25)).LayoutOrder = 2

			createBoldLabel(body, "Walkspeed", UDim2.new(1, -20, 0, 25)).LayoutOrder = 3
			local wsSlider, getWS = createSlider(body, 1, 200, lastWalkSpeed, function(val)
				lastWalkSpeed = val
				local char = player.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then hum.WalkSpeed = val end
				end
			end)
			wsSlider.LayoutOrder = 4

			createBoldLabel(body, "Umum", UDim2.new(1, -20, 0, 25)).LayoutOrder = 5

			local noclipRow = Instance.new("Frame")
			noclipRow.Size = UDim2.new(1, -20, 0, 30)
			noclipRow.BackgroundTransparency = 1
			noclipRow.LayoutOrder = 6
			noclipRow.Parent = body
			createBoldLabel(noclipRow, "No Clip", UDim2.new(0, 100, 1, 0)).TextXAlignment = Enum.TextXAlignment.Left
			local noclipSwitch, getNoclip = createSwitch(noclipRow, false, function(state)
				noclipEnabled = state
				if state then
					if noclipConnection then noclipConnection:Disconnect() end
					noclipConnection = RunService.Stepped:Connect(function()
						if not noclipEnabled then return end
						local char = player.Character
						if char then
							for _, part in pairs(char:GetDescendants()) do
								if part:IsA("BasePart") then
									part.CanCollide = false
								end
							end
						end
					end)
				else
					if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
				end
			end)
			noclipSwitch.Position = UDim2.new(1, -55, 0, 0)
			noclipSwitch.Parent = noclipRow

			local infRow = Instance.new("Frame")
			infRow.Size = UDim2.new(1, -20, 0, 30)
			infRow.BackgroundTransparency = 1
			infRow.LayoutOrder = 7
			infRow.Parent = body
			createBoldLabel(infRow, "Inf Jump", UDim2.new(0, 100, 1, 0)).TextXAlignment = Enum.TextXAlignment.Left
			local infSwitch, getInf = createSwitch(infRow, false, function(state)
				infJumpEnabled = state
				if state then
					if infJumpConnection then infJumpConnection:Disconnect() end
					infJumpConnection = UserInputService.JumpRequest:Connect(function()
						if infJumpEnabled then
							local char = player.Character
							if char then
								local hum = char:FindFirstChildOfClass("Humanoid")
								if hum then
									hum:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							end
						end
					end)
				else
					if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
				end
			end)
			infSwitch.Position = UDim2.new(1, -55, 0, 0)
			infSwitch.Parent = infRow

			local flyRow = Instance.new("Frame")
			flyRow.Size = UDim2.new(1, -20, 0, 30)
			flyRow.BackgroundTransparency = 1
			flyRow.LayoutOrder = 8
			flyRow.Parent = body
			createBoldLabel(flyRow, "Fly V3", UDim2.new(0, 100, 1, 0)).TextXAlignment = Enum.TextXAlignment.Left
			local flySwitch, getFly = createSwitch(flyRow, false, function(state)
				flyEnabled = state
				if state then
					createFlyMenu()
				else
					local flyMenu = screenGui:FindFirstChild("FlyMenu")
					if flyMenu then flyMenu:Destroy() end
					if flyConnection then flyConnection:Disconnect() flyConnection = nil end
					if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
				end
			end)
			flySwitch.Position = UDim2.new(1, -55, 0, 0)
			flySwitch.Parent = flyRow

			createBoldLabel(body, "Teleport", UDim2.new(1, -20, 0, 25)).LayoutOrder = 9
			local saveBtn = createButton(body, "Save Teleport", UDim2.new(0, 150, 0, 35), Color3.new(0,0.5,1), function()
				createSaveTeleportMenu()
			end)
			saveBtn.LayoutOrder = 10

			local teleportContainer = Instance.new("Frame")
			teleportContainer.Size = UDim2.new(1, -20, 0, 0)
			teleportContainer.BackgroundTransparency = 1
			teleportContainer.LayoutOrder = 11
			teleportContainer.Parent = body
			local teleportLayout = Instance.new("UIListLayout")
			teleportLayout.Padding = UDim.new(0, 5)
			teleportLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			teleportLayout.SortOrder = Enum.SortOrder.LayoutOrder
			teleportLayout.Parent = teleportContainer

			local function refreshTeleportList()
				for _, child in pairs(teleportContainer:GetChildren()) do
					if not child:IsA("UIListLayout") then child:Destroy() end
				end
				for i, spot in ipairs(teleportSpots) do
					local entry = Instance.new("Frame")
					entry.Size = UDim2.new(1, 0, 0, 35)
					entry.BackgroundTransparency = 1
					entry.Parent = teleportContainer

					local nameLabel = createBoldLabel(entry, spot.name, UDim2.new(0, 120, 1, 0))
					nameLabel.TextXAlignment = Enum.TextXAlignment.Left

					local tpBtn = createButton(entry, "Teleport", UDim2.new(0, 80, 0, 30), Color3.new(0,0.5,1), function()
						local char = player.Character
						if char then
							local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
							if root then root.CFrame = CFrame.new(spot.position) end
						end
					end)
					tpBtn.Position = UDim2.new(0, 130, 0.5, -15)

					local setBtn = createButton(entry, "⚙", UDim2.new(0, 30, 0, 30), Color3.new(0.3,0.3,0.3), function()
						createSettingTeleportMenu(spot, i)
					end)
					setBtn.Position = UDim2.new(0, 220, 0.5, -15)
				end
			end

			mainFrame:SetAttribute("RefreshTeleportList", refreshTeleportList)
			refreshTeleportList()
		end

		-- ========== FLY V3 MENU ==========
		function createFlyMenu()
			if screenGui:FindFirstChild("FlyMenu") then return end
			local flyFrame = Instance.new("Frame")
			flyFrame.Name = "FlyMenu"
			flyFrame.Size = UDim2.new(0, 320, 0, 160)
			flyFrame.Position = UDim2.new(0.5, -160, 0.8, -80)
			flyFrame.BackgroundColor3 = Color3.new(0,0,0)
			flyFrame.BorderSizePixel = 0
			flyFrame.Parent = screenGui

			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 40)
			header.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
			header.Parent = flyFrame

			local title = createBoldLabel(header, "[ FLY V3 ]", UDim2.new(1,0,1,0))
			title.TextXAlignment = Enum.TextXAlignment.Center

			local body = Instance.new("Frame")
			body.Size = UDim2.new(1, 0, 1, -40)
			body.Position = UDim2.new(0, 0, 0, 40)
			body.BackgroundTransparency = 1
			body.Parent = flyFrame

			local speedPanel = Instance.new("Frame")
			speedPanel.Size = UDim2.new(1, 0, 0, 50)
			speedPanel.BackgroundTransparency = 1
			speedPanel.Parent = body

			local minusBtn = createButton(speedPanel, "-", UDim2.new(0, 45, 0, 45), Color3.new(0.3,0.3,0.3), function()
				flySpeed = math.max(1, flySpeed - 1)
				speedLabel.Text = tostring(flySpeed)
			end)
			minusBtn.Position = UDim2.new(0, 20, 0.5, -22.5)

			local speedLabel = createBoldLabel(speedPanel, tostring(flySpeed), UDim2.new(0, 70, 0, 45))
			speedLabel.Position = UDim2.new(0, 75, 0.5, -22.5)
			speedLabel.TextXAlignment = Enum.TextXAlignment.Center
			speedLabel.TextSize = 20

			local plusBtn = createButton(speedPanel, "+", UDim2.new(0, 45, 0, 45), Color3.new(0.3,0.3,0.3), function()
				flySpeed = flySpeed + 1
				speedLabel.Text = tostring(flySpeed)
			end)
			plusBtn.Position = UDim2.new(0, 155, 0.5, -22.5)

			local toggleFlyBtn = createButton(body, "FLY", UDim2.new(0, 120, 0, 45), Color3.new(0,0.5,1), function()
				if flyConnection then
					if flyConnection then flyConnection:Disconnect() flyConnection = nil end
					if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
					toggleFlyBtn.BackgroundColor3 = Color3.new(0,0.5,1)
					toggleFlyBtn.Text = "FLY"
				else
					local char = player.Character
					if not char then return end
					local root = char:FindFirstChild("HumanoidRootPart")
					if not root then return end

					flyBodyVelocity = Instance.new("BodyVelocity")
					flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
					flyBodyVelocity.P = 1250
					flyBodyVelocity.Parent = root

					flyConnection = RunService.Heartbeat:Connect(function()
						if flyEnabled and char and char.Parent then
							local camera = workspace.CurrentCamera
							local move = Vector3.new(0,0,0)
							if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
							if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
							if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
							if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
							if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
							if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then move = move + Vector3.new(0,-1,0) end

							if move.Magnitude > 0 then
								move = move.Unit * flySpeed
							end
							flyBodyVelocity.Velocity = move
						else
							if flyConnection then flyConnection:Disconnect() flyConnection = nil end
							if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
						end
					end)

					char.Humanoid.Died:Connect(function()
						if flyConnection then flyConnection:Disconnect() flyConnection = nil end
						if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
						toggleFlyBtn.BackgroundColor3 = Color3.new(0,0.5,1)
						toggleFlyBtn.Text = "FLY"
					end)

					toggleFlyBtn.BackgroundColor3 = Color3.new(1,0,0)
					toggleFlyBtn.Text = "STOP"
				end
			end)
			toggleFlyBtn.Position = UDim2.new(0.5, -60, 0.8, -22.5)
			toggleFlyBtn.Parent = body
		end

		-- ========== SAVE TELEPORT MENU ==========
		function createSaveTeleportMenu()
			if screenGui:FindFirstChild("SaveTeleportMenu") then return end
			local menu = Instance.new("Frame")
			menu.Name = "SaveTeleportMenu"
			menu.Size = UDim2.new(0, 360, 0, 220)
			menu.Position = UDim2.new(0.5, -180, 0.5, -110)
			menu.BackgroundColor3 = Color3.new(0,0,0)
			menu.BorderSizePixel = 0
			menu.Parent = screenGui

			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 40)
			header.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
			header.Parent = menu

			local title = createBoldLabel(header, "Save Teleport", UDim2.new(1,0,1,0))
			title.TextXAlignment = Enum.TextXAlignment.Center

			local body = Instance.new("Frame")
			body.Size = UDim2.new(1, 0, 1, -40)
			body.Position = UDim2.new(0, 0, 0, 40)
			body.BackgroundTransparency = 1
			body.Parent = menu

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 12)
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.Parent = body
			local pad = Instance.new("UIPadding")
			pad.PaddingTop = UDim.new(0, 10)
			pad.PaddingLeft = UDim.new(0, 10)
			pad.PaddingRight = UDim.new(0, 10)
			pad.Parent = body

			local char = player.Character
			local pos = char and char.PrimaryPart and char.PrimaryPart.Position or Vector3.new(0,0,0)
			local coordLabel = createBoldLabel(body, "Lokasi: " .. string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z), UDim2.new(1, -20, 0, 25))
			coordLabel.TextXAlignment = Enum.TextXAlignment.Left
			coordLabel.LayoutOrder = 1

			local nameBox = createTextBox(body, "Nama teleport (max 20)", "", 20)
			nameBox.Size = UDim2.new(1, -20, 0, 35)
			nameBox.LayoutOrder = 2

			local btnFrame = Instance.new("Frame")
			btnFrame.Size = UDim2.new(1, -20, 0, 40)
			btnFrame.BackgroundTransparency = 1
			btnFrame.LayoutOrder = 3
			btnFrame.Parent = body

			local saveBtn = createButton(btnFrame, "Save", UDim2.new(0, 100, 0, 35), Color3.new(0,0.5,1), function()
				local name = nameBox.Text
				if name == "" then name = "Teleport " .. (#teleportSpots + 1) end
				local pos = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position or Vector3.new(0,0,0)
				table.insert(teleportSpots, { name = name, position = pos })
				local main = screenGui:FindFirstChild("MainMenu")
				if main then
					local refresh = main:GetAttribute("RefreshTeleportList")
					if refresh then refresh() end
				end
				menu:Destroy()
			end)
			saveBtn.Position = UDim2.new(0, 0, 0.5, -17.5)

			local closeBtn = createButton(btnFrame, "Close", UDim2.new(0, 100, 0, 35), Color3.new(0.3,0.3,0.3), function()
				menu:Destroy()
			end)
			closeBtn.Position = UDim2.new(1, -100, 0.5, -17.5)
		end

		-- ========== SETTING TELEPORT MENU ==========
		function createSettingTeleportMenu(spot, index)
			if screenGui:FindFirstChild("SettingTeleportMenu") then return end
			local menu = Instance.new("Frame")
			menu.Name = "SettingTeleportMenu"
			menu.Size = UDim2.new(0, 380, 0, 260)
			menu.Position = UDim2.new(0.5, -190, 0.5, -130)
			menu.BackgroundColor3 = Color3.new(0,0,0)
			menu.BorderSizePixel = 0
			menu.Parent = screenGui

			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 40)
			header.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
			header.Parent = menu

			local title = createBoldLabel(header, "Setting Teleport [" .. spot.name .. "]", UDim2.new(1,0,1,0))
			title.TextXAlignment = Enum.TextXAlignment.Center
			title.TextScaled = true

			local body = Instance.new("Frame")
			body.Size = UDim2.new(1, 0, 1, -40)
			body.Position = UDim2.new(0, 0, 0, 40)
			body.BackgroundTransparency = 1
			body.Parent = menu

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 12)
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.Parent = body
			local pad = Instance.new("UIPadding")
			pad.PaddingTop = UDim.new(0, 10)
			pad.PaddingLeft = UDim.new(0, 10)
			pad.PaddingRight = UDim.new(0, 10)
			pad.Parent = body

			local coordLabel = createBoldLabel(body, "Koordinat: " .. string.format("%.1f, %.1f, %.1f", spot.position.X, spot.position.Y, spot.position.Z), UDim2.new(1, -20, 0, 25))
			coordLabel.TextXAlignment = Enum.TextXAlignment.Left
			coordLabel.LayoutOrder = 1

			local nameBox = createTextBox(body, "Ubah nama", spot.name, 20)
			nameBox.Size = UDim2.new(1, -20, 0, 35)
			nameBox.LayoutOrder = 2

			local btnFrame = Instance.new("Frame")
			btnFrame.Size = UDim2.new(1, -20, 0, 40)
			btnFrame.BackgroundTransparency = 1
			btnFrame.LayoutOrder = 3
			btnFrame.Parent = body

			local saveBtn = createButton(btnFrame, "Save", UDim2.new(0, 90, 0, 35), Color3.new(0,0.5,1), function()
				if nameBox.Text ~= "" then spot.name = nameBox.Text end
				local main = screenGui:FindFirstChild("MainMenu")
				if main then
					local refresh = main:GetAttribute("RefreshTeleportList")
					if refresh then refresh() end
				end
				menu:Destroy()
			end)
			saveBtn.Position = UDim2.new(0, 0, 0.5, -17.5)

			local closeBtn = createButton(btnFrame, "Close", UDim2.new(0, 90, 0, 35), Color3.new(0.3,0.3,0.3), function()
				menu:Destroy()
			end)
			closeBtn.Position = UDim2.new(0.5, -45, 0.5, -17.5)

			local deleteBtn = createButton(btnFrame, "Delete", UDim2.new(0, 90, 0, 35), Color3.new(1,0,0), function()
				table.remove(teleportSpots, index)
				local main = screenGui:FindFirstChild("MainMenu")
				if main then
					local refresh = main:GetAttribute("RefreshTeleportList")
					if refresh then refresh() end
				end
				menu:Destroy()
			end)
			deleteBtn.Position = UDim2.new(1, -90, 0.5, -17.5)
		end

		-- ========== TOMBOL BULAT UTAMA (👟) ==========
		local mainButton = Instance.new("TextButton")
		mainButton.Name = "MainButton"
		mainButton.Size = UDim2.new(0, 65, 0, 65)
		mainButton.Position = UDim2.new(0, 25, 0.5, -32.5)
		mainButton.BackgroundColor3 = Color3.new(0,0,0)
		mainButton.BorderSizePixel = 0
		mainButton.Text = "👟"
		mainButton.TextColor3 = Color3.new(1,1,1)
		mainButton.Font = Enum.Font.GothamBold
		mainButton.TextSize = 45
		mainButton.Parent = screenGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = mainButton

		mainButton.MouseButton1Click:Connect(function()
			if not screenGui:FindFirstChild("MainMenu") then
				createMainMenu()
			else
				local menu = screenGui:FindFirstChild("MainMenu")
				if menu then menu.Visible = not menu.Visible end
			end
		end)

		-- ========== HANDLE RESPAWN ==========
		local function applyWalkSpeed(char)
			local hum = char:WaitForChild("Humanoid")
			hum.WalkSpeed = lastWalkSpeed
		end

		player.CharacterAdded:Connect(applyWalkSpeed)
		if player.Character then applyWalkSpeed(player.Character) end

		-- ========== CLEANUP ==========
		screenGui.Destroying:Connect(function()
			_G.SpeedControlLoaded = nil
		end)

		-- ========== LOADING SELESAI ==========
		animLoop:Disconnect() -- hentikan animasi loop
		loadingGui:Destroy()   -- hilangkan loading screen
		print("✅ Speed Control By Azka loaded. Tekan 👟 untuk menu.")
	end) -- akhir pcall

	if not success then
		warn("⚠️ Speed Control Error: " .. tostring(err))
		-- Coba tampilkan pesan error di layar
		local player = game:GetService("Players").LocalPlayer
		if player then
			local errorGui = Instance.new("ScreenGui")
			errorGui.Name = "SpeedControlError"
			errorGui.Parent = player:WaitForChild("PlayerGui")
			errorGui.ResetOnSpawn = false
			local errorLabel = Instance.new("TextLabel")
			errorLabel.Size = UDim2.new(0, 600, 0, 100)
			errorLabel.Position = UDim2.new(0.5, -300, 0.5, -50)
			errorLabel.BackgroundColor3 = Color3.new(0,0,0)
			errorLabel.BackgroundTransparency = 0.3
			errorLabel.Text = "Error: " .. tostring(err)
			errorLabel.TextColor3 = Color3.new(1,1,1)
			errorLabel.Font = Enum.Font.GothamBold
			errorLabel.TextSize = 20
			errorLabel.Parent = errorGui
			task.wait(5)
			errorGui:Destroy()
		end
	end
end) -- akhir task.spawn