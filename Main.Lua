--[[
	Speed Control Universal - Delta Executor Ready (FIXED V2)
	Oleh: Azka
	Desain: Modern, Minimalis, Simple - Background hitam, Accent biru, Text putih
--]]

task.spawn(function()
	local success, err = pcall(function()
		-- ========== SERVICES ==========
		local Players = game:GetService("Players")
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")
		
		local player = Players.LocalPlayer
		if not player then
			player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		end

		-- ========== LOADING SCREEN ==========
		local loadingGui = Instance.new("ScreenGui")
		loadingGui.Name = "LoadingScreen"
		loadingGui.Parent = player:WaitForChild("PlayerGui")
		loadingGui.ResetOnSpawn = false
		loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		loadingGui.DisplayOrder = 999

		local blackFrame = Instance.new("Frame")
		blackFrame.Size = UDim2.new(1, 0, 1, 0)
		blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		blackFrame.BackgroundTransparency = 0.4
		blackFrame.BorderSizePixel = 0
		blackFrame.Parent = loadingGui

		local loadingText = Instance.new("TextLabel")
		loadingText.Size = UDim2.new(0, 400, 0, 100)
		loadingText.Position = UDim2.new(0.5, -200, 0.5, -50)
		loadingText.BackgroundTransparency = 1
		loadingText.Text = "Speed Control By Azka"
		loadingText.TextColor3 = Color3.new(1, 1, 1)
		loadingText.Font = Enum.Font.GothamBold
		loadingText.TextSize = 48
		loadingText.TextTransparency = 1
		loadingText.Parent = blackFrame

		-- Fade in animation
		local fadeIn = TweenService:Create(loadingText, TweenInfo.new(0.5), {TextTransparency = 0})
		fadeIn:Play()
		fadeIn.Completed:Wait()

		-- ========== GLOBAL VARIABLES ==========
		if _G.SpeedControlLoaded then loadingGui:Destroy(); return end
		_G.SpeedControlLoaded = true

		-- State
		local flyEnabled = false
		local flySpeed = 1 -- Default 1 (16 walkspeed equivalent)
		local flyConnection = nil
		local flyBodyVelocity = nil
		local flyGui = nil

		local noclipEnabled = false
		local noclipConnection = nil

		local infJumpEnabled = false
		local infJumpConnection = nil

		local lastWalkSpeed = 30

		-- ========== GUI UTAMA ==========
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "SpeedControlGUI"
		screenGui.Parent = player:WaitForChild("PlayerGui")
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		-- ========== FUNGSI UTILITAS ==========
		local function makeDraggable(frame, handle)
			handle = handle or frame
			local dragging = false
			local dragStart, startPos

			handle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = frame.Position
					TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local delta = input.Position - dragStart
					frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
					TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
				end
			end)
		end

		local function createShadow(parent, size)
			local shadow = Instance.new("ImageLabel")
			shadow.Name = "Shadow"
			shadow.AnchorPoint = Vector2.new(0.5, 0.5)
			shadow.BackgroundTransparency = 1
			shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			shadow.Size = UDim2.new(1, 30, 1, 30)
			shadow.ZIndex = -1
			shadow.Image = "rbxassetid://5554236805"
			shadow.ImageColor3 = Color3.new(0, 0, 0)
			shadow.ImageTransparency = 0.6
			shadow.ScaleType = Enum.ScaleType.Slice
			shadow.SliceCenter = Rect.new(23, 23, 277, 277)
			shadow.Parent = parent
		end

		-- ========== KOMPONEN UI ==========
		local function createModernSwitch(parent, defaultOn, callback)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(0, 44, 0, 24)
			container.BackgroundTransparency = 1

			local bg = Instance.new("Frame")
			bg.Name = "Background"
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundColor3 = defaultOn and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
			bg.BorderSizePixel = 0
			bg.Parent = container

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = bg

			local knob = Instance.new("Frame")
			knob.Name = "Knob"
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = defaultOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			knob.Parent = bg

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.Parent = container

			local state = defaultOn

			btn.MouseButton1Click:Connect(function()
				state = not state
				local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
				local targetColor = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
				
				TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
				TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
				
				if callback then task.spawn(callback, state) end
			end)

			container.Parent = parent
			return container
		end

		local function createModernSlider(parent, min, max, default, callback)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, -20, 0, 40)
			container.BackgroundTransparency = 1

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Size = UDim2.new(0, 50, 0, 20)
			valueLabel.Position = UDim2.new(0, 0, 0, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Text = tostring(math.floor(default))
			valueLabel.TextColor3 = Color3.new(1, 1, 1)
			valueLabel.Font = Enum.Font.GothamBold
			valueLabel.TextSize = 16
			valueLabel.TextXAlignment = Enum.TextXAlignment.Left
			valueLabel.Parent = container

			local track = Instance.new("Frame")
			track.Name = "Track"
			track.Size = UDim2.new(1, 0, 0, 6)
			track.Position = UDim2.new(0, 0, 0, 28)
			track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			track.BorderSizePixel = 0
			track.Parent = container

			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1, 0)
			trackCorner.Parent = track

			local fill = Instance.new("Frame")
			fill.Name = "Fill"
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
			fill.BorderSizePixel = 0
			fill.Parent = track

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = fill

			local knob = Instance.new("Frame")
			knob.Name = "Knob"
			knob.Size = UDim2.new(0, 16, 0, 16)
			knob.Position = UDim2.new(fill.Size.X.Scale, -8, 0.5, -8)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			knob.Parent = track

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob

			local currentValue = default
			local dragging = false

			local function updateValue(newVal)
				currentValue = math.clamp(math.floor(newVal + 0.5), min, max)
				local percent = (currentValue - min) / (max - min)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				knob.Position = UDim2.new(percent, -8, 0.5, -8)
				valueLabel.Text = tostring(currentValue)
				if callback then callback(currentValue) end
			end

			knob.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local absPos = track.AbsolutePosition.X
					local absSize = track.AbsoluteSize.X
					local mouseX = input.Position.X
					local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
					updateValue(min + percent * (max - min))
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play()
				end
			end)

			container.Parent = parent
			return container, function() return currentValue end
		end

		local function createModernButton(parent, text, width, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, width, 0, 32)
			btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
			btn.BorderSizePixel = 0
			btn.Text = text
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.AutoButtonColor = false

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = btn

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
			end)

			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
			end)

			btn.MouseButton1Down:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, width - 2, 0, 30)}):Play()
			end)

			btn.MouseButton1Up:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, width, 0, 32)}):Play()
			end)

			btn.MouseButton1Click:Connect(function()
				if callback then task.spawn(callback) end
			end)

			btn.Parent = parent
			return btn
		end

		-- ========== FLY MENU (MODERN) ==========
		local function createFlyMenu()
			if flyGui then flyGui:Destroy() end
			
			flyGui = Instance.new("Frame")
			flyGui.Name = "FlyMenu"
			flyGui.Size = UDim2.new(0, 220, 0, 140)
			flyGui.Position = UDim2.new(0.5, -110, 0.7, -70)
			flyGui.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			flyGui.BorderSizePixel = 0
			flyGui.Parent = screenGui
			createShadow(flyGui)
			makeDraggable(flyGui)

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = flyGui

			-- Header
			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 36)
			header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			header.BorderSizePixel = 0
			header.Parent = flyGui

			local headerCorner = Instance.new("UICorner")
			headerCorner.CornerRadius = UDim.new(0, 8)
			headerCorner.Parent = header

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, 0, 1, 0)
			title.BackgroundTransparency = 1
			title.Text = "[ FLY V3 ]"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 16
			title.Parent = header

			-- Body
			local body = Instance.new("Frame")
			body.Size = UDim2.new(1, -20, 1, -46)
			body.Position = UDim2.new(0, 10, 0, 41)
			body.BackgroundTransparency = 1
			body.Parent = flyGui

			-- Speed Control Row
			local speedRow = Instance.new("Frame")
			speedRow.Size = UDim2.new(1, 0, 0, 40)
			speedRow.BackgroundTransparency = 1
			speedRow.Parent = body

			local minusBtn = Instance.new("TextButton")
			minusBtn.Size = UDim2.new(0, 36, 0, 36)
			minusBtn.Position = UDim2.new(0, 0, 0.5, -18)
			minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			minusBtn.BorderSizePixel = 0
			minusBtn.Text = "-"
			minusBtn.TextColor3 = Color3.new(1, 1, 1)
			minusBtn.Font = Enum.Font.GothamBold
			minusBtn.TextSize = 20
			minusBtn.Parent = speedRow

			local minusCorner = Instance.new("UICorner")
			minusCorner.CornerRadius = UDim.new(0, 6)
			minusCorner.Parent = minusBtn

			local speedLabel = Instance.new("TextLabel")
			speedLabel.Size = UDim2.new(0, 80, 0, 36)
			speedLabel.Position = UDim2.new(0.5, -40, 0.5, -18)
			speedLabel.BackgroundTransparency = 1
			speedLabel.Text = tostring(flySpeed)
			speedLabel.TextColor3 = Color3.new(1, 1, 1)
			speedLabel.Font = Enum.Font.GothamBold
			speedLabel.TextSize = 24
			speedLabel.Parent = speedRow

			local plusBtn = Instance.new("TextButton")
			plusBtn.Size = UDim2.new(0, 36, 0, 36)
			plusBtn.Position = UDim2.new(1, -36, 0.5, -18)
			plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			plusBtn.BorderSizePixel = 0
			plusBtn.Text = "+"
			plusBtn.TextColor3 = Color3.new(1, 1, 1)
			plusBtn.Font = Enum.Font.GothamBold
			plusBtn.TextSize = 20
			plusBtn.Parent = speedRow

			local plusCorner = UICorner.new()
			plusCorner.CornerRadius = UDim.new(0, 6)
			plusCorner.Parent = plusBtn

			-- Fly Toggle Button
			local flyBtn = Instance.new("TextButton")
			flyBtn.Size = UDim2.new(1, 0, 0, 38)
			flyBtn.Position = UDim2.new(0, 0, 1, -38)
			flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
			flyBtn.BorderSizePixel = 0
			flyBtn.Text = "ENABLE FLY"
			flyBtn.TextColor3 = Color3.new(1, 1, 1)
			flyBtn.Font = Enum.Font.GothamBold
			flyBtn.TextSize = 14
			flyBtn.Parent = body

			local flyBtnCorner = Instance.new("UICorner")
			flyBtnCorner.CornerRadius = UDim.new(0, 6)
			flyBtnCorner.Parent = flyBtn

			-- Logic: Update speed label function
			local function updateSpeedLabel()
				speedLabel.Text = tostring(flySpeed)
				-- Calculate actual speed (1 = 16, 2 = 32, etc)
				local actualSpeed = flySpeed * 16
				if flyBodyVelocity then
					flyBodyVelocity.Velocity = flyBodyVelocity.Velocity.Unit * actualSpeed
				end
			end

			-- Minus button logic
			minusBtn.MouseButton1Click:Connect(function()
				if flySpeed > 1 then
					flySpeed = flySpeed - 1
					updateSpeedLabel()
				end
				TweenService:Create(minusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				task.wait(0.1)
				TweenService:Create(minusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
			end)

			-- Plus button logic
			plusBtn.MouseButton1Click:Connect(function()
				if flySpeed < 255 then -- Max 255
					flySpeed = flySpeed + 1
					updateSpeedLabel()
				end
				TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
				task.wait(0.1)
				TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
			end)

			-- Fly toggle logic
			local isFlying = false
			flyBtn.MouseButton1Click:Connect(function()
				isFlying = not isFlying
				
				if isFlying then
					-- Enable fly
					flyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
					flyBtn.Text = "DISABLE FLY"
					
					local char = player.Character
					if not char then return end
					local root = char:FindFirstChild("HumanoidRootPart")
					if not root then return end

					flyBodyVelocity = Instance.new("BodyVelocity")
					flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
					flyBodyVelocity.P = 1250
					flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
					flyBodyVelocity.Parent = root

					flyConnection = RunService.Heartbeat:Connect(function()
						if not isFlying or not char or not char.Parent then
							if flyConnection then flyConnection:Disconnect() end
							if flyBodyVelocity then flyBodyVelocity:Destroy() end
							flyConnection = nil
							flyBodyVelocity = nil
							return
						end
						
						local camera = workspace.CurrentCamera
						local move = Vector3.new(0, 0, 0)
						
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
						if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end

						if move.Magnitude > 0 then
							move = move.Unit * (flySpeed * 16) -- Convert to actual speed
						end
						flyBodyVelocity.Velocity = move
					end)

					char.Humanoid.Died:Connect(function()
						isFlying = false
						if flyConnection then flyConnection:Disconnect() end
						if flyBodyVelocity then flyBodyVelocity:Destroy() end
						flyConnection = nil
						flyBodyVelocity = nil
						flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
						flyBtn.Text = "ENABLE FLY"
					end)
				else
					-- Disable fly
					flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
					flyBtn.Text = "ENABLE FLY"
					if flyConnection then flyConnection:Disconnect() end
					if flyBodyVelocity then flyBodyVelocity:Destroy() end
					flyConnection = nil
					flyBodyVelocity = nil
				end
			end)
		end

		-- ========== MAIN MENU (MODERN & AUTO RESIZE) ==========
		local mainFrame = nil

		local function createMainMenu()
			if mainFrame then mainFrame:Destroy() end

			mainFrame = Instance.new("Frame")
			mainFrame.Name = "MainMenu"
			mainFrame.Size = UDim2.new(0, 320, 0, 0) -- Height auto
			mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
			mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			mainFrame.BorderSizePixel = 0
			mainFrame.ClipsDescendants = true
			mainFrame.Parent = screenGui
			createShadow(mainFrame)
			makeDraggable(mainFrame)

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 10)
			corner.Parent = mainFrame

			-- Header
			local header = Instance.new("Frame")
			header.Name = "Header"
			header.Size = UDim2.new(1, 0, 0, 42)
			header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			header.BorderSizePixel = 0
			header.Parent = mainFrame
			makeDraggable(mainFrame, header)

			local headerCorner = Instance.new("UICorner")
			headerCorner.CornerRadius = UDim.new(0, 10)
			headerCorner.Parent = header

			local title = Instance.new("TextLabel")
			title.Size = UDim2.new(1, -80, 1, 0)
			title.Position = UDim2.new(0, 15, 0, 0)
			title.BackgroundTransparency = 1
			title.Text = "Speed Control By Azka"
			title.TextColor3 = Color3.new(1, 1, 1)
			title.Font = Enum.Font.GothamBold
			title.TextSize = 16
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Parent = header

			-- Close button
			local closeBtn = Instance.new("TextButton")
			closeBtn.Size = UDim2.new(0, 30, 0, 30)
			closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
			closeBtn.BackgroundTransparency = 1
			closeBtn.Text = "×"
			closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 24
			closeBtn.Parent = header

			closeBtn.MouseButton1Click:Connect(function()
				mainFrame.Visible = false
			end)

			-- Content Container
			local content = Instance.new("Frame")
			content.Name = "Content"
			content.Size = UDim2.new(1, -20, 0, 0) -- Auto height
			content.Position = UDim2.new(0, 10, 0, 52)
			content.BackgroundTransparency = 1
			content.Parent = mainFrame

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 12)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Parent = content

			-- Walkspeed Section
			local wsLabel = Instance.new("TextLabel")
			wsLabel.Size = UDim2.new(1, 0, 0, 20)
			wsLabel.BackgroundTransparency = 1
			wsLabel.Text = "Walkspeed"
			wsLabel.TextColor3 = Color3.new(1, 1, 1)
			wsLabel.Font = Enum.Font.GothamBold
			wsLabel.TextSize = 14
			wsLabel.TextXAlignment = Enum.TextXAlignment.Left
			wsLabel.LayoutOrder = 1
			wsLabel.Parent = content

			local wsSlider = createModernSlider(content, 1, 500, lastWalkSpeed, function(val)
				lastWalkSpeed = val
				local char = player.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then hum.WalkSpeed = val end
				end
			end)
			wsSlider.LayoutOrder = 2

			-- Divider
			local divider1 = Instance.new("Frame")
			divider1.Size = UDim2.new(1, 0, 0, 1)
			divider1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			divider1.BorderSizePixel = 0
			divider1.LayoutOrder = 3
			divider1.Parent = content

			-- General Section
			local genLabel = Instance.new("TextLabel")
			genLabel.Size = UDim2.new(1, 0, 0, 20)
			genLabel.BackgroundTransparency = 1
			genLabel.Text = "General"
			genLabel.TextColor3 = Color3.new(1, 1, 1)
			genLabel.Font = Enum.Font.GothamBold
			genLabel.TextSize = 14
			genLabel.TextXAlignment = Enum.TextXAlignment.Left
			genLabel.LayoutOrder = 4
			genLabel.Parent = content

			-- No Clip Row
			local noclipRow = Instance.new("Frame")
			noclipRow.Size = UDim2.new(1, 0, 0, 30)
			noclipRow.BackgroundTransparency = 1
			noclipRow.LayoutOrder = 5
			noclipRow.Parent = content

			local noclipText = Instance.new("TextLabel")
			noclipText.Size = UDim2.new(1, -60, 1, 0)
			noclipText.BackgroundTransparency = 1
			noclipText.Text = "No Clip"
			noclipText.TextColor3 = Color3.new(1, 1, 1)
			noclipText.Font = Enum.Font.Gotham
			noclipText.TextSize = 14
			noclipText.TextXAlignment = Enum.TextXAlignment.Left
			noclipText.Parent = noclipRow

			createModernSwitch(noclipRow, false, function(state)
				noclipEnabled = state
				if state then
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
					if noclipConnection then noclipConnection:Disconnect() end
				end
			end)

			-- Inf Jump Row
			local infRow = Instance.new("Frame")
			infRow.Size = UDim2.new(1, 0, 0, 30)
			infRow.BackgroundTransparency = 1
			infRow.LayoutOrder = 6
			infRow.Parent = content

			local infText = Instance.new("TextLabel")
			infText.Size = UDim2.new(1, -60, 1, 0)
			infText.BackgroundTransparency = 1
			infText.Text = "Infinite Jump"
			infText.TextColor3 = Color3.new(1, 1, 1)
			infText.Font = Enum.Font.Gotham
			infText.TextSize = 14
			infText.TextXAlignment = Enum.TextXAlignment.Left
			infText.Parent = infRow

			createModernSwitch(infRow, false, function(state)
				infJumpEnabled = state
				if state then
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
					if infJumpConnection then infJumpConnection:Disconnect() end
				end
			end)

			-- Fly Row
			local flyRow = Instance.new("Frame")
			flyRow.Size = UDim2.new(1, 0, 0, 30)
			flyRow.BackgroundTransparency = 1
			flyRow.LayoutOrder = 7
			flyRow.Parent = content

			local flyText = Instance.new("TextLabel")
			flyText.Size = UDim2.new(1, -60, 1, 0)
			flyText.BackgroundTransparency = 1
			flyText.Text = "Fly V3"
			flyText.TextColor3 = Color3.new(1, 1, 1)
			flyText.Font = Enum.Font.Gotham
			flyText.TextSize = 14
			flyText.TextXAlignment = Enum.TextXAlignment.Left
			flyText.Parent = flyRow

			createModernSwitch(flyRow, false, function(state)
				flyEnabled = state
				if state then
					createFlyMenu()
				else
					if flyGui then flyGui:Destroy() end
					if flyConnection then flyConnection:Disconnect() end
					if flyBodyVelocity then flyBodyVelocity:Destroy() end
					flyConnection = nil
					flyBodyVelocity = nil
				end
			end)

			-- Update frame size based on content
			task.wait()
			local contentHeight = layout.AbsoluteContentSize.Y
			content.Size = UDim2.new(1, -20, 0, contentHeight)
			mainFrame.Size = UDim2.new(0, 320, 0, contentHeight + 62)
		end

		-- ========== MAIN BUTTON (KECIL 25x25) ==========
		local mainButton = Instance.new("TextButton")
		mainButton.Name = "MainButton"
		mainButton.Size = UDim2.new(0, 25, 0, 25) -- 1/2 dari 50
		mainButton.Position = UDim2.new(0, 15, 0.5, -12.5)
		mainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		mainButton.BorderSizePixel = 0
		mainButton.Text = "👟"
		mainButton.TextColor3 = Color3.new(1, 1, 1)
		mainButton.Font = Enum.Font.GothamBold
		mainButton.TextSize = 14 -- Smaller text
		mainButton.Parent = screenGui
		makeDraggable(mainButton)

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(1, 0)
		btnCorner.Parent = mainButton

		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = Color3.fromRGB(0, 120, 255)
		btnStroke.Thickness = 1.5
		btnStroke.Parent = mainButton

		-- Hover effect
		mainButton.MouseEnter:Connect(function()
			TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
		end)

		mainButton.MouseLeave:Connect(function()
			TweenService:Create(mainButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
		end)

		mainButton.MouseButton1Click:Connect(function()
			if not mainFrame or not mainFrame.Parent then
				createMainMenu()
			else
				mainFrame.Visible = not mainFrame.Visible
				if mainFrame.Visible then
					-- Recalculate size when showing
					local content = mainFrame:FindFirstChild("Content")
					if content then
						local layout = content:FindFirstChildOfClass("UIListLayout")
						if layout then
							local contentHeight = layout.AbsoluteContentSize.Y
							content.Size = UDim2.new(1, -20, 0, contentHeight)
							mainFrame.Size = UDim2.new(0, 320, 0, contentHeight + 62)
						end
					end
				end
			end
		end)

		-- ========== CHARACTER HANDLING ==========
		local function onCharacterAdded(char)
			local hum = char:WaitForChild("Humanoid")
			hum.WalkSpeed = lastWalkSpeed
			
			-- Reconnect fly if enabled
			if flyEnabled and flyGui then
				createFlyMenu()
			end
		end

		player.CharacterAdded:Connect(onCharacterAdded)
		if player.Character then
			onCharacterAdded(player.Character)
		end

		-- ========== CLEANUP ==========
		screenGui.Destroying:Connect(function()
			_G.SpeedControlLoaded = nil
			if flyConnection then flyConnection:Disconnect() end
			if noclipConnection then noclipConnection:Disconnect() end
			if infJumpConnection then infJumpConnection:Disconnect() end
		end)

		-- ========== FINISH LOADING ==========
		TweenService:Create(loadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		TweenService:Create(blackFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		task.wait(0.5)
		loadingGui:Destroy()
		
		print("✅ Speed Control By Azka loaded!")
	end)

	if not success then
		warn("⚠️ Error: " .. tostring(err))
	end
end)
