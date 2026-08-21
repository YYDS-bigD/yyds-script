local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Clear old GUI if exists
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubScannerV7")
if oldGui then
	oldGui:Destroy()
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

---------------------------------------------------------------------
-- GUI Setup
---------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DracoHubScannerV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 210, 0, 340) -- 稍微加高一點放新按鈕
Main.Position = UDim2.new(1, -220, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Text = "YYDS"
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = Title

-- Minimize (-) Button
local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 18, 0, 18)
MinusBtn.Position = UDim2.new(0, 4, 0, 3)
MinusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 14
MinusBtn.Text = "-"
MinusBtn.ZIndex = 5
MinusBtn.Parent = Title

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 4)
MinusCorner.Parent = MinusBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -21, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.Text = "X"
CloseBtn.ZIndex = 5
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- ==================== Minimize Icon ====================
local MinimizeIcon = Instance.new("ImageButton")
MinimizeIcon.Name = "MinimizeIcon"
MinimizeIcon.Size = UDim2.new(0, 58, 0, 58)
MinimizeIcon.Position = UDim2.new(0, 12, 0.38, 0)
MinimizeIcon.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
MinimizeIcon.BackgroundTransparency = 0
MinimizeIcon.Image = "rbxassetid://79733047167022"
MinimizeIcon.ScaleType = Enum.ScaleType.Fit
MinimizeIcon.AutoButtonColor = false
MinimizeIcon.Visible = false
MinimizeIcon.ZIndex = 20
MinimizeIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = MinimizeIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 100, 100)
IconStroke.Thickness = 2
IconStroke.Parent = MinimizeIcon

-- Minimize / Restore
MinusBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	MinimizeIcon.Visible = true
end)

MinimizeIcon.MouseButton1Click:Connect(function()
	Main.Visible = true
	MinimizeIcon.Visible = false
end)

-- Draggable icon
local iconDragging = false
local iconDragStart, iconStartPos

MinimizeIcon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = true
		iconDragStart = input.Position
		iconStartPos = MinimizeIcon.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - iconDragStart
		MinimizeIcon.Position = UDim2.new(
			iconStartPos.X.Scale,
			iconStartPos.X.Offset + delta.X,
			iconStartPos.Y.Scale,
			iconStartPos.Y.Offset + delta.Y
		)
	end
end)

-- Search Input
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -8, 0, 22)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
SearchBox.PlaceholderText = "Search character or ability..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 10
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = Main

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

-- Loop variables
local loopInterval = 0
local isCustomLoopActive = false

-- God Mode + Reset
local ModeContainer = Instance.new("Frame")
ModeContainer.Size = UDim2.new(1, -8, 0, 26)
ModeContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
ModeContainer.BorderSizePixel = 0
ModeContainer.Parent = Main

local GodModeBtn = Instance.new("TextButton")
GodModeBtn.Size = UDim2.new(0, 90, 0, 20)
GodModeBtn.Position = UDim2.new(0, 8, 0, 3)
GodModeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
GodModeBtn.TextColor3 = Color3.fromRGB(240, 220, 255)
GodModeBtn.Font = Enum.Font.GothamBold
GodModeBtn.TextSize = 11
GodModeBtn.Text = "God Mode"
GodModeBtn.Parent = ModeContainer

local GodCorner = Instance.new("UICorner")
GodCorner.CornerRadius = UDim.new(0, 4)
GodCorner.Parent = GodModeBtn

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0, 90, 0, 20)
ResetBtn.Position = UDim2.new(1, -98, 0, 3)
ResetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 11
ResetBtn.Text = "Reset"
ResetBtn.Parent = ModeContainer

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 4)
ResetCorner.Parent = ResetBtn

ResetBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char then
		char:BreakJoints()
	end
end)

GodModeBtn.MouseButton1Click:Connect(function()
	task.spawn(function()
		local currentCharacter = LocalPlayer.Character
		if not currentCharacter then return end
		local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
		if not currentRoot then return end

		local originalCFrame = currentRoot.CFrame
		currentRoot.CFrame = originalCFrame + Vector3.new(0, 2000, 0)

		task.wait(0.1)

		local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
		if charactersFolder then
			local targetFolder = nil
			for _, folder in ipairs(charactersFolder:GetChildren()) do
				if folder.Name:lower() == "steve_h" then
					targetFolder = folder
					break
				end
			end

			if targetFolder then
				local remotesFolder = targetFolder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower():find("death") then
							task.wait(0.1)
							remote:FireServer()
							task.wait(0.1)
							break
						end
					end
				end
			end
		end

		task.wait(0.7)

		if currentCharacter and currentRoot then
			currentRoot.CFrame = originalCFrame
		end
	end)
end)

-- ==================== Laser Eyes Button ====================
local LaserContainer = Instance.new("Frame")
LaserContainer.Size = UDim2.new(1, -8, 0, 26)
LaserContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
LaserContainer.BorderSizePixel = 0
LaserContainer.Parent = Main

local LaserBtn = Instance.new("TextButton")
LaserBtn.Size = UDim2.new(1, -8, 0, 20)
LaserBtn.Position = UDim2.new(0, 4, 0, 3)
LaserBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 90)
LaserBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
LaserBtn.Font = Enum.Font.GothamBold
LaserBtn.TextSize = 11
LaserBtn.Text = "Laser Eyes"
LaserBtn.Parent = LaserContainer

local LaserCorner = Instance.new("UICorner")
LaserCorner.CornerRadius = UDim.new(0, 4)
LaserCorner.Parent = LaserBtn

-- ==================== Laser Floating Panel ====================
local laserActive = false
local laserThread = nil

local LaserPanel = Instance.new("Frame")
LaserPanel.Size = UDim2.new(0, 140, 0, 50)
LaserPanel.Position = UDim2.new(0.5, -70, 0.4, 0)
LaserPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LaserPanel.BorderSizePixel = 0
LaserPanel.Visible = false
LaserPanel.ZIndex = 30
LaserPanel.Parent = ScreenGui

local LaserPanelCorner = Instance.new("UICorner")
LaserPanelCorner.CornerRadius = UDim.new(0, 8)
LaserPanelCorner.Parent = LaserPanel

local LaserPanelStroke = Instance.new("UIStroke")
LaserPanelStroke.Color = Color3.fromRGB(80, 80, 180)
LaserPanelStroke.Thickness = 2
LaserPanelStroke.Parent = LaserPanel

local LaserStatus = Instance.new("TextLabel")
LaserStatus.Size = UDim2.new(1, 0, 1, 0)
LaserStatus.BackgroundTransparency = 1
LaserStatus.Text = "Laser Eyes OFF"
LaserStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
LaserStatus.Font = Enum.Font.GothamBold
LaserStatus.TextSize = 14
LaserStatus.Parent = LaserPanel

-- Lock button for Laser Panel (bottom left)
local laserPanelLocked = false

local LaserLockBtn = Instance.new("TextButton")
LaserLockBtn.Size = UDim2.new(0, 20, 0, 20)
LaserLockBtn.Position = UDim2.new(0, 4, 1, -24)
LaserLockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LaserLockBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
LaserLockBtn.Font = Enum.Font.GothamBold
LaserLockBtn.TextSize = 11
LaserLockBtn.Text = "🔓"
LaserLockBtn.ZIndex = 31
LaserLockBtn.Parent = LaserPanel

local LaserLockCorner = Instance.new("UICorner")
LaserLockCorner.CornerRadius = UDim.new(0, 4)
LaserLockCorner.Parent = LaserLockBtn

LaserLockBtn.MouseButton1Click:Connect(function()
	laserPanelLocked = not laserPanelLocked
	if laserPanelLocked then
		LaserLockBtn.Text = "🔒"
		LaserLockBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
	else
		LaserLockBtn.Text = "🔓"
		LaserLockBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	end
end)

-- Drag Laser Panel
local laserDragging = false
local laserDragStart, laserStartPos

LaserPanel.InputBegan:Connect(function(input)
	if laserPanelLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		laserDragging = true
		laserDragStart = input.Position
		laserStartPos = LaserPanel.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		laserDragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if laserPanelLocked then return end
	if laserDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - laserDragStart
		LaserPanel.Position = UDim2.new(
			laserStartPos.X.Scale,
			laserStartPos.X.Offset + delta.X,
			laserStartPos.Y.Scale,
			laserStartPos.Y.Offset + delta.Y
		)
	end
end)

-- Laser Eyes Toggle Logic
local function FindMoveOneRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end

	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder.Name:lower():find("homelander") then
			local remotes = folder:FindFirstChild("Remotes")
			if remotes then
				local moveOne = remotes:FindFirstChild("MoveOne")
				if moveOne and moveOne:IsA("RemoteEvent") then
					return moveOne
				end
			end
		end
	end
	return nil
end

local function StartLaserLoop()
	if laserThread then
		task.cancel(laserThread)
		laserThread = nil
	end

	laserThread = task.spawn(function()
		while laserActive do
			local remote = FindMoveOneRemote()
			if remote then
				remote:FireServer()
			end
			task.wait() -- 最快速度循環
		end
	end)
end

local function StopLaserLoop()
	laserActive = false
	if laserThread then
		task.cancel(laserThread)
		laserThread = nil
	end
end

LaserBtn.MouseButton1Click:Connect(function()
	laserActive = not laserActive

	if laserActive then
		LaserPanel.Visible = true
		LaserStatus.Text = "Laser Eyes ON"
		LaserStatus.TextColor3 = Color3.fromRGB(80, 255, 120)
		LaserBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
		StartLaserLoop()
	else
		LaserPanel.Visible = false
		LaserStatus.Text = "Laser Eyes OFF"
		LaserStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
		LaserBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 90)
		StopLaserLoop()
	end
end)

-- Loop (1.0s)
local LoopContainer1 = Instance.new("Frame")
LoopContainer1.Size = UDim2.new(1, -8, 0, 24)
LoopContainer1.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
LoopContainer1.BorderSizePixel = 0
LoopContainer1.Parent = Main

local LoopToggle1 = Instance.new("TextButton")
LoopToggle1.Size = UDim2.new(0, 16, 0, 16)
LoopToggle1.Position = UDim2.new(0, 4, 0, 4)
LoopToggle1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LoopToggle1.TextColor3 = Color3.fromRGB(0, 255, 120)
LoopToggle1.Font = Enum.Font.GothamBold
LoopToggle1.TextSize = 11
LoopToggle1.Text = ""
LoopToggle1.Parent = LoopContainer1

local Toggle1Corner = Instance.new("UICorner")
Toggle1Corner.CornerRadius = UDim.new(0, 3)
Toggle1Corner.Parent = LoopToggle1

local LoopLabel1 = Instance.new("TextLabel")
LoopLabel1.Size = UDim2.new(1, -24, 1, 0)
LoopLabel1.Position = UDim2.new(0, 24, 0, 0)
LoopLabel1.BackgroundTransparency = 1
LoopLabel1.TextColor3 = Color3.fromRGB(200, 200, 200)
LoopLabel1.Font = Enum.Font.Gotham
LoopLabel1.TextSize = 10
LoopLabel1.Text = "Loop (1.0s)"
LoopLabel1.TextXAlignment = Enum.TextXAlignment.Left
LoopLabel1.Parent = LoopContainer1

-- Custom Loop
local CustomLoopContainer = Instance.new("Frame")
CustomLoopContainer.Size = UDim2.new(1, -8, 0, 26)
CustomLoopContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
CustomLoopContainer.BorderSizePixel = 0
CustomLoopContainer.Parent = Main

local CustomToggle = Instance.new("TextButton")
CustomToggle.Size = UDim2.new(0, 16, 0, 16)
CustomToggle.Position = UDim2.new(0, 4, 0, 5)
CustomToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CustomToggle.TextColor3 = Color3.fromRGB(0, 255, 120)
CustomToggle.Font = Enum.Font.GothamBold
CustomToggle.TextSize = 11
CustomToggle.Text = ""
CustomToggle.Parent = CustomLoopContainer

local CustomToggleCorner = Instance.new("UICorner")
CustomToggleCorner.CornerRadius = UDim.new(0, 3)
CustomToggleCorner.Parent = CustomToggle

local SubBtn = Instance.new("TextButton")
SubBtn.Size = UDim2.new(0, 18, 0, 16)
SubBtn.Position = UDim2.new(0, 24, 0, 5)
SubBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SubBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
SubBtn.Font = Enum.Font.GothamBold
SubBtn.TextSize = 10
SubBtn.Text = "-"
SubBtn.Parent = CustomLoopContainer

local SubCorner = Instance.new("UICorner")
SubCorner.CornerRadius = UDim.new(0, 3)
SubCorner.Parent = SubBtn

local CustomInput = Instance.new("TextBox")
CustomInput.Size = UDim2.new(0, 45, 0, 16)
CustomInput.Position = UDim2.new(0, 45, 0, 5)
CustomInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CustomInput.TextColor3 = Color3.fromRGB(240, 240, 240)
CustomInput.Font = Enum.Font.Gotham
CustomInput.TextSize = 10
CustomInput.Text = "0.05"
CustomInput.ClearTextOnFocus = false
CustomInput.Parent = CustomLoopContainer

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 3)
InputCorner.Parent = CustomInput

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0, 18, 0, 16)
AddBtn.Position = UDim2.new(0, 93, 0, 5)
AddBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AddBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 10
AddBtn.Text = "+"
AddBtn.Parent = CustomLoopContainer

local AddCorner = Instance.new("UICorner")
AddCorner.CornerRadius = UDim.new(0, 3)
AddCorner.Parent = AddBtn

local CustomLabel = Instance.new("TextLabel")
CustomLabel.Size = UDim2.new(1, -116, 1, 0)
CustomLabel.Position = UDim2.new(0, 114, 0, 0)
CustomLabel.BackgroundTransparency = 1
CustomLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CustomLabel.Font = Enum.Font.Gotham
CustomLabel.TextSize = 9
CustomLabel.Text = "Custom Loop"
CustomLabel.TextXAlignment = Enum.TextXAlignment.Left
CustomLabel.Parent = CustomLoopContainer

-- Logic
LoopToggle1.MouseButton1Click:Connect(function()
	if loopInterval == 1 and not isCustomLoopActive then
		loopInterval = 0
		LoopToggle1.Text = ""
	else
		loopInterval = 1
		isCustomLoopActive = false
		LoopToggle1.Text = "✓"
		CustomToggle.Text = ""
	end
end)

CustomToggle.MouseButton1Click:Connect(function()
	if isCustomLoopActive then
		isCustomLoopActive = false
		loopInterval = 0
		CustomToggle.Text = ""
	else
		isCustomLoopActive = true
		local val = tonumber(CustomInput.Text) or 0.05
		loopInterval = math.max(0.001, val)
		CustomToggle.Text = "✓"
		LoopToggle1.Text = ""
	end
end)

SubBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05
	val = math.max(0.001, val - 0.01)
	CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then
		loopInterval = tonumber(CustomInput.Text) or 0.05
	end
end)

AddBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05
	val = val + 0.01
	CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then
		loopInterval = tonumber(CustomInput.Text) or 0.05
	end
end)

CustomInput:GetPropertyChangedSignal("Text"):Connect(function()
	if isCustomLoopActive then
		local val = tonumber(CustomInput.Text)
		if val and val > 0 then
			loopInterval = val
		end
	end
end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -130) -- 調整高度
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.Parent = Main

local List = Instance.new("UIListLayout")
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 2)
List.Parent = Scroll

-- Lock Button
local isWindowLocked = false

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 24, 0, 24)
LockButton.Position = UDim2.new(0, 4, 1, -28)
LockButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LockButton.TextColor3 = Color3.fromRGB(220, 220, 220)
LockButton.Font = Enum.Font.GothamBold
LockButton.TextSize = 12
LockButton.Text = "🔓"
LockButton.ZIndex = 10
LockButton.Parent = Main

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 4)
LockCorner.Parent = LockButton

LockButton.MouseButton1Click:Connect(function()
	isWindowLocked = not isWindowLocked
	if isWindowLocked then
		LockButton.Text = "🔒"
		LockButton.TextColor3 = Color3.fromRGB(255, 80, 80)
	else
		LockButton.Text = "🔓"
		LockButton.TextColor3 = Color3.fromRGB(220, 220, 220)
	end
end)

-- Draggable Main
local dragging = false
local dragStart, startPos

Main.InputBegan:Connect(function(input)
	if isWindowLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
