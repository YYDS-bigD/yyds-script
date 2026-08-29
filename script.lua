local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Clean old GUIs
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubScannerV7")
if oldGui then oldGui:Destroy() end
local oldLaserGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubLaserButton")
if oldLaserGui then oldLaserGui:Destroy() end
local oldUpthrowGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubUpthrowButton")
if oldUpthrowGui then oldUpthrowGui:Destroy() end
local oldOverthrowGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubOverthrowButton")
if oldOverthrowGui then oldOverthrowGui:Destroy() end
local oldFinalGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubFinalButton")
if oldFinalGui then oldFinalGui:Destroy() end
local oldKickGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubKickButton")
if oldKickGui then oldKickGui:Destroy() end
local oldComboGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubComboButton")
if oldComboGui then oldComboGui:Destroy() end
local oldFloating = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubFloatingButtons")
if oldFloating then oldFloating:Destroy() end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

-- Global variables
local flightTask = nil
local kickActive = false
local finisherEnabled = false
local finisherLoopThread = nil
local finisherActive = false
local upthrowCooldown = false
local aimActive = false
local aimTarget = nil
local aimLine = nil
local aimHighlight = nil
local aimUpdateConnection = nil
local laserActive = false
local laserThread = nil
local flashstrikeCooldown = 10
local flashstrikeCooldownActive = false
local simultaneousEnabled = false
local simultaneousCount = 20
local isCustomLoopActive = false
local loopInterval = 0
local moveUnlocked = false
local currentLoopThread = nil
local homelanderModActive = false
local mohawkModActive = false

local DEFAULT_POSITIONS = {
	Laser = UDim2.new(1, -240, 0.5, -100),
	Upthrow = UDim2.new(1, -310, 0.5, -30),
	Flashstrike = UDim2.new(1, -310, 0.5, -100),
	Kick = UDim2.new(1, -240, 0.5, -170),
	Combo = UDim2.new(1, -310, 0.5, -170),
	MoAim = UDim2.new(1, -240, 0.5, -100)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DracoHubScannerV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 160, 0, 380)
Main.Position = UDim2.new(1, -160, 0, 0)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0,8) MainCorner.Parent = Main
local uiScale = Instance.new("UIScale") uiScale.Scale = 1 uiScale.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,30)
TopBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
local TopBarCorner = Instance.new("UICorner") TopBarCorner.CornerRadius = UDim.new(0,8) TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,60,1,0) Title.Position = UDim2.new(0.5,-30,0,0) Title.BackgroundTransparency = 1
Title.Text = "YYDS" Title.TextColor3 = Color3.fromRGB(255,255,255) Title.Font = Enum.Font.GothamBold Title.TextSize = 14 Title.TextXAlignment = Enum.TextXAlignment.Center Title.Parent = TopBar

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0,18,0,18) MinusBtn.Position = UDim2.new(0,4,0,6) MinusBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinusBtn.TextColor3 = Color3.fromRGB(255,255,255) MinusBtn.Font = Enum.Font.GothamBold MinusBtn.TextSize = 14 MinusBtn.Text = "—" MinusBtn.ZIndex = 5 MinusBtn.Parent = TopBar
local MinusCorner = Instance.new("UICorner") MinusCorner.CornerRadius = UDim.new(0,4) MinusCorner.Parent = MinusBtn

local LockButtonTop = Instance.new("TextButton")
LockButtonTop.Size = UDim2.new(0,22,0,22) LockButtonTop.Position = UDim2.new(0,26,0,4) LockButtonTop.BackgroundColor3 = Color3.fromRGB(35,35,35)
LockButtonTop.TextColor3 = Color3.fromRGB(255,80,80) LockButtonTop.Font = Enum.Font.GothamBold LockButtonTop.TextSize = 14 LockButtonTop.Text = "🔒" LockButtonTop.ZIndex = 10 LockButtonTop.Parent = TopBar
local LockTopCorner = Instance.new("UICorner") LockTopCorner.CornerRadius = UDim.new(0,4) LockTopCorner.Parent = LockButtonTop

local MinimizeIcon = Instance.new("ImageButton")
MinimizeIcon.Name = "MinimizeIcon" MinimizeIcon.Size = UDim2.new(0,60,0,60) MinimizeIcon.Position = UDim2.new(0,12,0.10,0)
MinimizeIcon.BackgroundTransparency = 1 MinimizeIcon.Image = "rbxassetid://90728112297914" MinimizeIcon.ScaleType = Enum.ScaleType.Fit MinimizeIcon.AutoButtonColor = false MinimizeIcon.Visible = false MinimizeIcon.ZIndex = 20 MinimizeIcon.Parent = ScreenGui
local IconCorner = Instance.new("UICorner") IconCorner.CornerRadius = UDim.new(0,12) IconCorner.Parent = MinimizeIcon

MinusBtn.MouseButton1Click:Connect(function() Main.Visible = false MinimizeIcon.Visible = true end)
MinimizeIcon.MouseButton1Click:Connect(function() Main.Visible = true MinimizeIcon.Visible = false end)

local iconDragging = false local iconDragStart, iconStartPos
MinimizeIcon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = true iconDragStart = input.Position iconStartPos = MinimizeIcon.Position
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then iconDragging = false end
end)
UIS.InputChanged:Connect(function(input)
	if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - iconDragStart
		MinimizeIcon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
	end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1,0,0,32) TabContainer.Position = UDim2.new(0,0,0,30) TabContainer.BackgroundColor3 = Color3.fromRGB(18,18,18) TabContainer.BorderSizePixel = 0 TabContainer.Parent = Main

local Tab1 = Instance.new("TextButton")
Tab1.Size = UDim2.new(0.5,-2,1,-4) Tab1.Position = UDim2.new(0,2,0,2) Tab1.BackgroundColor3 = Color3.fromRGB(80,50,120)
Tab1.TextColor3 = Color3.fromRGB(255,255,255) Tab1.Font = Enum.Font.GothamBold Tab1.TextSize = 11 Tab1.Text = "Scanner" Tab1.Parent = TabContainer
local Tab1Corner = Instance.new("UICorner") Tab1Corner.CornerRadius = UDim.new(0,4) Tab1Corner.Parent = Tab1

local Tab2 = Instance.new("TextButton")
Tab2.Size = UDim2.new(0.5,-2,1,-4) Tab2.Position = UDim2.new(0.5,0,0,2) Tab2.BackgroundColor3 = Color3.fromRGB(35,35,35)
Tab2.TextColor3 = Color3.fromRGB(180,180,180) Tab2.Font = Enum.Font.GothamBold Tab2.TextSize = 11 Tab2.Text = "Extras"
Tab2.Parent = TabContainer
local Tab2Corner = Instance.new("UICorner") Tab2Corner.CornerRadius = UDim.new(0,4) Tab2Corner.Parent = Tab2

local Page1 = Instance.new("Frame")
Page1.Size = UDim2.new(1,0,1,-62) Page1.Position = UDim2.new(0,0,0,62) Page1.BackgroundTransparency = 1 Page1.Parent = Main

local Page2 = Instance.new("Frame")
Page2.Size = UDim2.new(1,0,1,-62) Page2.Position = UDim2.new(0,0,0,62) Page2.BackgroundTransparency = 1 Page2.Visible = false Page2.Parent = Main

Tab1.MouseButton1Click:Connect(function()
	Page1.Visible = true Page2.Visible = false Tab1.BackgroundColor3 = Color3.fromRGB(80,50,120) Tab1.TextColor3 = Color3.fromRGB(255,255,255)
	Tab2.BackgroundColor3 = Color3.fromRGB(35,35,35) Tab2.TextColor3 = Color3.fromRGB(180,180,180)
end)
Tab2.MouseButton1Click:Connect(function()
	Page1.Visible = false Page2.Visible = true Tab2.BackgroundColor3 = Color3.fromRGB(80,50,120) Tab2.TextColor3 = Color3.fromRGB(255,255,255)
	Tab1.BackgroundColor3 = Color3.fromRGB(35,35,35) Tab1.TextColor3 = Color3.fromRGB(180,180,180)
end)

-- ==================== Page 1 - Scanner ====================
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-10,0,22) SearchBox.Position = UDim2.new(0,5,0,3) SearchBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
SearchBox.TextColor3 = Color3.fromRGB(240,240,240) SearchBox.PlaceholderText = "Search..." SearchBox.Text = "" SearchBox.Font = Enum.Font.Gotham SearchBox.TextSize = 11 SearchBox.ClearTextOnFocus = false SearchBox.Parent = Page1
local SearchCorner = Instance.new("UICorner") SearchCorner.CornerRadius = UDim.new(0,5) SearchCorner.Parent = SearchBox

local ModeContainer = Instance.new("Frame")
ModeContainer.Size = UDim2.new(1,-10,0,20) ModeContainer.Position = UDim2.new(0,5,0,27) ModeContainer.BackgroundColor3 = Color3.fromRGB(20,20,20) ModeContainer.BorderSizePixel = 0 ModeContainer.Parent = Page1
local ModeContainerCorner = Instance.new("UICorner") ModeContainerCorner.CornerRadius = UDim.new(0,4) ModeContainerCorner.Parent = ModeContainer

local GodModeBtn = Instance.new("TextButton")
GodModeBtn.Size = UDim2.new(0.5,-10,0,18) GodModeBtn.Position = UDim2.new(0,7,0,1) GodModeBtn.BackgroundColor3 = Color3.fromRGB(60,40,90)
GodModeBtn.TextColor3 = Color3.fromRGB(240,220,255) GodModeBtn.Font = Enum.Font.GothamBold GodModeBtn.TextSize = 10 GodModeBtn.Text = "God" GodModeBtn.Parent = ModeContainer
local GodCorner = Instance.new("UICorner") GodCorner.CornerRadius = UDim.new(0,4) GodCorner.Parent = GodModeBtn

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.5,-10,0,18) ResetBtn.Position = UDim2.new(0.5,3,0,1) ResetBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
ResetBtn.TextColor3 = Color3.fromRGB(255,255,255) ResetBtn.Font = Enum.Font.GothamBold ResetBtn.TextSize = 10 ResetBtn.Text = "Reset" ResetBtn.Parent = ModeContainer
local ResetCorner = Instance.new("UICorner") ResetCorner.CornerRadius = UDim.new(0,4) ResetCorner.Parent = ResetBtn

ResetBtn.MouseButton1Click:Connect(function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end)
GodModeBtn.MouseButton1Click:Connect(function()
	task.spawn(function()
		local currentCharacter = LocalPlayer.Character if not currentCharacter then return end
		local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart") if not currentRoot then return end
		local originalCFrame = currentRoot.CFrame
		currentRoot.CFrame = originalCFrame + Vector3.new(0, 2000, 0)
		task.wait(0.1)
		local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
		if charactersFolder then
			for _, folder in ipairs(charactersFolder:GetChildren()) do
				if folder.Name:lower() == "steve_h" then
					local remotesFolder = folder:FindFirstChild("Remotes")
					if remotesFolder then
						for _, remote in ipairs(remotesFolder:GetChildren()) do
							if remote:IsA("RemoteEvent") and remote.Name:lower():find("death") then
								task.wait(0.1) remote:FireServer() task.wait(0.1) break
							end
						end
					end
					break
				end
			end
		end
		task.wait(0.7)
		if currentCharacter and currentRoot then currentRoot.CFrame = originalCFrame end
	end)
end)

-- ==================== Controllers (mutually exclusive) ====================
local SimultaneousContainer = Instance.new("Frame")
SimultaneousContainer.Size = UDim2.new(1,-10,0,22)
SimultaneousContainer.Position = UDim2.new(0,5,0,49)
SimultaneousContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
SimultaneousContainer.BorderSizePixel = 0
SimultaneousContainer.Parent = Page1
local SimultaneousCorner = Instance.new("UICorner") SimultaneousCorner.CornerRadius = UDim.new(0,4) SimultaneousCorner.Parent = SimultaneousContainer

local SimultaneousToggle = Instance.new("TextButton")
SimultaneousToggle.Size = UDim2.new(0,18,0,18) SimultaneousToggle.Position = UDim2.new(0,5,0,2) SimultaneousToggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
SimultaneousToggle.TextColor3 = Color3.fromRGB(0,255,120) SimultaneousToggle.Font = Enum.Font.GothamBold SimultaneousToggle.TextSize = 11 SimultaneousToggle.Text = "" SimultaneousToggle.Parent = SimultaneousContainer
local SimultaneousToggleCorner = Instance.new("UICorner") SimultaneousToggleCorner.CornerRadius = UDim.new(0,3) SimultaneousToggleCorner.Parent = SimultaneousToggle

local SimultaneousLabel = Instance.new("TextLabel")
SimultaneousLabel.Size = UDim2.new(0,40,1,0) SimultaneousLabel.Position = UDim2.new(0,28,0,0) SimultaneousLabel.BackgroundTransparency = 1
SimultaneousLabel.TextColor3 = Color3.fromRGB(200,200,200) SimultaneousLabel.Font = Enum.Font.Gotham SimultaneousLabel.TextSize = 9 SimultaneousLabel.Text = "Simul." SimultaneousLabel.TextXAlignment = Enum.TextXAlignment.Left SimultaneousLabel.Parent = SimultaneousContainer

local SimultaneousSubBtn = Instance.new("TextButton")
SimultaneousSubBtn.Size = UDim2.new(0,16,0,16) SimultaneousSubBtn.Position = UDim2.new(0,72,0,3) SimultaneousSubBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
SimultaneousSubBtn.TextColor3 = Color3.fromRGB(220,220,220) SimultaneousSubBtn.Font = Enum.Font.GothamBold SimultaneousSubBtn.TextSize = 12 SimultaneousSubBtn.Text = "-" SimultaneousSubBtn.Parent = SimultaneousContainer
local SimultaneousSubCorner = Instance.new("UICorner") SimultaneousSubCorner.CornerRadius = UDim.new(0,3) SimultaneousSubCorner.Parent = SimultaneousSubBtn

local SimultaneousInput = Instance.new("TextBox")
SimultaneousInput.Size = UDim2.new(0,26,0,16) SimultaneousInput.Position = UDim2.new(0,90,0,3) SimultaneousInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
SimultaneousInput.TextColor3 = Color3.fromRGB(240,240,240) SimultaneousInput.Font = Enum.Font.Gotham SimultaneousInput.TextSize = 10 SimultaneousInput.Text = "20" SimultaneousInput.ClearTextOnFocus = false SimultaneousInput.Parent = SimultaneousContainer
local SimultaneousInputCorner = Instance.new("UICorner") SimultaneousInputCorner.CornerRadius = UDim.new(0,3) SimultaneousInputCorner.Parent = SimultaneousInput

local SimultaneousAddBtn = Instance.new("TextButton")
SimultaneousAddBtn.Size = UDim2.new(0,16,0,16) SimultaneousAddBtn.Position = UDim2.new(0,118,0,3) SimultaneousAddBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
SimultaneousAddBtn.TextColor3 = Color3.fromRGB(220,220,220) SimultaneousAddBtn.Font = Enum.Font.GothamBold SimultaneousAddBtn.TextSize = 12 SimultaneousAddBtn.Text = "+" SimultaneousAddBtn.Parent = SimultaneousContainer
local SimultaneousAddCorner = Instance.new("UICorner") SimultaneousAddCorner.CornerRadius = UDim.new(0,3) SimultaneousAddCorner.Parent = SimultaneousAddBtn

local CustomLoopContainer = Instance.new("Frame")
CustomLoopContainer.Size = UDim2.new(1,-10,0,22)
CustomLoopContainer.Position = UDim2.new(0,5,0,73)
CustomLoopContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
CustomLoopContainer.BorderSizePixel = 0
CustomLoopContainer.Parent = Page1
local CustomLoopContainerCorner = Instance.new("UICorner") CustomLoopContainerCorner.CornerRadius = UDim.new(0,4) CustomLoopContainerCorner.Parent = CustomLoopContainer

local CustomToggle = Instance.new("TextButton")
CustomToggle.Size = UDim2.new(0,18,0,18) CustomToggle.Position = UDim2.new(0,5,0,2) CustomToggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
CustomToggle.TextColor3 = Color3.fromRGB(0,255,120) CustomToggle.Font = Enum.Font.GothamBold CustomToggle.TextSize = 11 CustomToggle.Text = "" CustomToggle.Parent = CustomLoopContainer
local CustomToggleCorner = Instance.new("UICorner") CustomToggleCorner.CornerRadius = UDim.new(0,3) CustomToggleCorner.Parent = CustomToggle

local CustomLabel = Instance.new("TextLabel")
CustomLabel.Size = UDim2.new(0,40,1,0) CustomLabel.Position = UDim2.new(0,28,0,0) CustomLabel.BackgroundTransparency = 1
CustomLabel.TextColor3 = Color3.fromRGB(200,200,200) CustomLabel.Font = Enum.Font.Gotham CustomLabel.TextSize = 9 CustomLabel.Text = "Loop" CustomLabel.TextXAlignment = Enum.TextXAlignment.Left CustomLabel.Parent = CustomLoopContainer

local SubBtn = Instance.new("TextButton")
SubBtn.Size = UDim2.new(0,16,0,16) SubBtn.Position = UDim2.new(0,72,0,3) SubBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
SubBtn.TextColor3 = Color3.fromRGB(220,220,220) SubBtn.Font = Enum.Font.GothamBold SubBtn.TextSize = 12 SubBtn.Text = "-" SubBtn.Parent = CustomLoopContainer
local SubCorner = Instance.new("UICorner") SubCorner.CornerRadius = UDim.new(0,3) SubCorner.Parent = SubBtn

local CustomInput = Instance.new("TextBox")
CustomInput.Size = UDim2.new(0,26,0,16) CustomInput.Position = UDim2.new(0,90,0,3) CustomInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
CustomInput.TextColor3 = Color3.fromRGB(240,240,240) CustomInput.Font = Enum.Font.Gotham CustomInput.TextSize = 10 CustomInput.Text = "0.05" CustomInput.ClearTextOnFocus = false CustomInput.Parent = CustomLoopContainer
local InputCorner = Instance.new("UICorner") InputCorner.CornerRadius = UDim.new(0,3) InputCorner.Parent = CustomInput

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0,16,0,16) AddBtn.Position = UDim2.new(0,118,0,3) AddBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
AddBtn.TextColor3 = Color3.fromRGB(220,220,220) AddBtn.Font = Enum.Font.GothamBold AddBtn.TextSize = 12 AddBtn.Text = "+" AddBtn.Parent = CustomLoopContainer
local AddCorner = Instance.new("UICorner") AddCorner.CornerRadius = UDim.new(0,3) AddCorner.Parent = AddBtn

local function updateControllerUI()
	SimultaneousToggle.BackgroundColor3 = simultaneousEnabled and Color3.fromRGB(80,50,120) or Color3.fromRGB(40,40,40)
	SimultaneousToggle.Text = simultaneousEnabled and "✓" or ""
	CustomToggle.BackgroundColor3 = isCustomLoopActive and Color3.fromRGB(80,50,120) or Color3.fromRGB(40,40,40)
	CustomToggle.Text = isCustomLoopActive and "✓" or ""
end

SimultaneousToggle.MouseButton1Click:Connect(function()
	if simultaneousEnabled then
		simultaneousEnabled = false
	else
		simultaneousEnabled = true
		if isCustomLoopActive then
			isCustomLoopActive = false
			loopInterval = 0
		end
	end
	updateControllerUI()
end)

CustomToggle.MouseButton1Click:Connect(function()
	if isCustomLoopActive then
		isCustomLoopActive = false
		loopInterval = 0
	else
		isCustomLoopActive = true
		if simultaneousEnabled then
			simultaneousEnabled = false
		end
		local val = tonumber(CustomInput.Text) or 0.05
		loopInterval = math.max(0.001, val)
	end
	updateControllerUI()
end)

SimultaneousSubBtn.MouseButton1Click:Connect(function()
	local val = tonumber(SimultaneousInput.Text) or simultaneousCount
	val = math.max(1, val - 1)
	simultaneousCount = val
	SimultaneousInput.Text = tostring(val)
end)
SimultaneousAddBtn.MouseButton1Click:Connect(function()
	local val = tonumber(SimultaneousInput.Text) or simultaneousCount
	val = val + 1
	simultaneousCount = val
	SimultaneousInput.Text = tostring(val)
end)
SimultaneousInput:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(SimultaneousInput.Text)
	if val and val > 0 then
		simultaneousCount = val
	else
		simultaneousCount = 20
		SimultaneousInput.Text = "20"
	end
end)

SubBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05
	val = math.max(0.001, val - 0.01)
	CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then loopInterval = tonumber(CustomInput.Text) or 0.05 end
end)
AddBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05
	val = val + 0.01
	CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then loopInterval = tonumber(CustomInput.Text) or 0.05 end
end)
CustomInput:GetPropertyChangedSignal("Text"):Connect(function()
	if isCustomLoopActive then
		local val = tonumber(CustomInput.Text)
		if val and val > 0 then loopInterval = val end
	end
end)

updateControllerUI()

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-4,1,-97)
Scroll.Position = UDim2.new(0,2,0,95)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.Parent = Page1
local List = Instance.new("UIListLayout") List.SortOrder = Enum.SortOrder.LayoutOrder List.Padding = UDim.new(0,3) List.Parent = Scroll

-- ==================== Page 2 - Extras ====================
local HomelanderModBtn = Instance.new("TextButton")
HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
HomelanderModBtn.Position = UDim2.new(0, 5, 0, 10)
HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
HomelanderModBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomelanderModBtn.Font = Enum.Font.GothamBold
HomelanderModBtn.TextSize = 12
HomelanderModBtn.Text = "Homelanders Mod"
HomelanderModBtn.TextScaled = true
HomelanderModBtn.Parent = Page2
local HomelanderModCorner = Instance.new("UICorner") HomelanderModCorner.CornerRadius = UDim.new(0,4) HomelanderModCorner.Parent = HomelanderModBtn

local FinisherButton = Instance.new("TextButton")
FinisherButton.Size = UDim2.new(0.5, -8, 0, 24)
FinisherButton.Position = UDim2.new(0.5, 2, 0, 10)
FinisherButton.BackgroundColor3 = Color3.fromRGB(30, 100, 60)
FinisherButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FinisherButton.Font = Enum.Font.GothamBold
FinisherButton.TextSize = 10
FinisherButton.Text = "Auto Finisher OFF"
FinisherButton.TextScaled = true
FinisherButton.Visible = false
FinisherButton.Parent = Page2
local FinisherCorner = Instance.new("UICorner") FinisherCorner.CornerRadius = UDim.new(0,4) FinisherCorner.Parent = FinisherButton

local LaserCompatibilityLabel = Instance.new("TextLabel")
LaserCompatibilityLabel.Size = UDim2.new(1, -10, 0, 14)
LaserCompatibilityLabel.Position = UDim2.new(0, 5, 0, 36)
LaserCompatibilityLabel.BackgroundTransparency = 1
LaserCompatibilityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LaserCompatibilityLabel.Font = Enum.Font.Gotham
LaserCompatibilityLabel.TextSize = 6
LaserCompatibilityLabel.Text = "(Laser: Homelander & Superman)"
LaserCompatibilityLabel.TextXAlignment = Enum.TextXAlignment.Left
LaserCompatibilityLabel.Parent = Page2

-- ==================== Mohawk Button (TEST centered, Mohawk mode moved to right, icon slightly bigger) ====================
local MohawkModBtn = Instance.new("TextButton")
MohawkModBtn.Size = UDim2.new(1, -10, 0, 30)
MohawkModBtn.Position = UDim2.new(0, 5, 0, 54)
MohawkModBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
MohawkModBtn.Text = ""
MohawkModBtn.Parent = Page2
local MohawkModCorner = Instance.new("UICorner") MohawkModCorner.CornerRadius = UDim.new(0,4) MohawkModCorner.Parent = MohawkModBtn

-- Left icon (slightly bigger: 24x24)
local MohawkIcon = Instance.new("ImageLabel")
MohawkIcon.Name = "MohawkIcon"
MohawkIcon.Size = UDim2.new(0, 24, 0, 24)
MohawkIcon.Position = UDim2.new(0, 4, 0.5, -12)
MohawkIcon.BackgroundTransparency = 1
MohawkIcon.Image = "rbxassetid://126354613074842"
MohawkIcon.ScaleType = Enum.ScaleType.Fit
MohawkIcon.Parent = MohawkModBtn

-- TEST label (centered at top)
local TestLabel = Instance.new("TextLabel")
TestLabel.Name = "TestLabel"
TestLabel.Size = UDim2.new(1, -30, 0, 15)
TestLabel.Position = UDim2.new(0, 28, 0, 2)
TestLabel.BackgroundTransparency = 1
TestLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
TestLabel.Font = Enum.Font.GothamBold
TestLabel.TextSize = 10
TestLabel.Text = "TEST"
TestLabel.TextXAlignment = Enum.TextXAlignment.Center
TestLabel.TextYAlignment = Enum.TextYAlignment.Top
TestLabel.Parent = MohawkModBtn

-- Mohawk mode label (right-aligned at bottom)
local ModeLabel = Instance.new("TextLabel")
ModeLabel.Name = "ModeLabel"
ModeLabel.Size = UDim2.new(1, -30, 0, 13)
ModeLabel.Position = UDim2.new(0, 28, 0, 15)
ModeLabel.BackgroundTransparency = 1
ModeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.TextSize = 9
ModeLabel.Text = "Mohawk mode"
ModeLabel.TextXAlignment = Enum.TextXAlignment.Right
ModeLabel.TextYAlignment = Enum.TextYAlignment.Bottom
ModeLabel.Parent = MohawkModBtn

-- ====== Modified Hint text (two lines) ======
local HintLabel = Instance.new("TextLabel")
HintLabel.Name = "HintLabel"
HintLabel.Size = UDim2.new(1, -10, 0, 20)  -- increased height
HintLabel.Position = UDim2.new(0, 5, 0, 86)
HintLabel.BackgroundTransparency = 1
HintLabel.TextColor3 = Color3.fromRGB(255, 255, 0)  -- Yellow
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextSize = 8
HintLabel.Text = "Warehouse: Air slam\nless effective with ceiling"  -- two lines
HintLabel.TextXAlignment = Enum.TextXAlignment.Left
HintLabel.TextYAlignment = Enum.TextYAlignment.Top
HintLabel.TextWrapped = true
HintLabel.Parent = Page2

-- ==================== Move Mode & Reset Pos (shifted down further) ====================
local MoveModeBtn = Instance.new("TextButton")
MoveModeBtn.Size = UDim2.new(1, -10, 0, 20)
MoveModeBtn.Position = UDim2.new(0, 5, 0, 110)  -- was 104, now 110
MoveModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MoveModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveModeBtn.Font = Enum.Font.GothamBold
MoveModeBtn.TextSize = 10
MoveModeBtn.Text = "Move Skills Mode: Locked"
MoveModeBtn.TextScaled = true
MoveModeBtn.Parent = Page2
local MoveModeCorner = Instance.new("UICorner") MoveModeCorner.CornerRadius = UDim.new(0,4) MoveModeCorner.Parent = MoveModeBtn

local ResetPosBtn = Instance.new("TextButton")
ResetPosBtn.Size = UDim2.new(1, -10, 0, 20)
ResetPosBtn.Position = UDim2.new(0, 5, 0, 132)  -- was 126, now 132
ResetPosBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ResetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetPosBtn.Font = Enum.Font.GothamBold
ResetPosBtn.TextSize = 10
ResetPosBtn.Text = "Reset"
ResetPosBtn.Visible = false
ResetPosBtn.Parent = Page2
local ResetPosCorner = Instance.new("UICorner") ResetPosCorner.CornerRadius = UDim.new(0,4) ResetPosCorner.Parent = ResetPosBtn

local FlightToggleBtn = Instance.new("TextButton")
FlightToggleBtn.Size = UDim2.new(1, -10, 0, 20)
FlightToggleBtn.Position = UDim2.new(0, 5, 0, 156)  -- was 150, now 156
FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 100)
FlightToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlightToggleBtn.Font = Enum.Font.GothamBold
FlightToggleBtn.TextSize = 12
FlightToggleBtn.Text = "Homelander Fly"
FlightToggleBtn.TextScaled = true
FlightToggleBtn.Parent = Page2
local FlightToggleCorner = Instance.new("UICorner") FlightToggleCorner.CornerRadius = UDim.new(0,4) FlightToggleCorner.Parent = FlightToggleBtn

local FlightLoadLabel = Instance.new("TextLabel")
FlightLoadLabel.Size = UDim2.new(1, -10, 0, 16)
FlightLoadLabel.Position = UDim2.new(0, 5, 0, 178)  -- was 172, now 178
FlightLoadLabel.BackgroundTransparency = 1
FlightLoadLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FlightLoadLabel.Font = Enum.Font.Gotham
FlightLoadLabel.TextSize = 10
FlightLoadLabel.Text = "(Max load 20s)"
FlightLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
FlightLoadLabel.Parent = Page2

local SettingsFoldBtn = Instance.new("TextButton")
SettingsFoldBtn.Size = UDim2.new(1, -10, 0, 24)
SettingsFoldBtn.Position = UDim2.new(0, 5, 0, 196)  -- was 190, now 196
SettingsFoldBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsFoldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsFoldBtn.Font = Enum.Font.GothamBold
SettingsFoldBtn.TextSize = 12
SettingsFoldBtn.Text = "Settings ▼"
SettingsFoldBtn.Parent = Page2
local SettingsFoldCorner = Instance.new("UICorner") SettingsFoldCorner.CornerRadius = UDim.new(0,4) SettingsFoldCorner.Parent = SettingsFoldBtn

local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, -10, 0, 110)
SettingsContent.Position = UDim2.new(0, 5, 0, 222)  -- was 216, now 222
SettingsContent.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsContent.BorderSizePixel = 0
SettingsContent.Visible = false
SettingsContent.Parent = Page2
local SettingsContentCorner = Instance.new("UICorner") SettingsContentCorner.CornerRadius = UDim.new(0,4) SettingsContentCorner.Parent = SettingsContent

local SliderTitle = Instance.new("TextLabel")
SliderTitle.Size = UDim2.new(1,-10,0,18) SliderTitle.Position = UDim2.new(0,5,0,5) SliderTitle.BackgroundTransparency = 1
SliderTitle.TextColor3 = Color3.fromRGB(220,220,220) SliderTitle.Font = Enum.Font.GothamBold SliderTitle.TextSize = 11 SliderTitle.Text = "UI Scale" SliderTitle.TextXAlignment = Enum.TextXAlignment.Left SliderTitle.Parent = SettingsContent

local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack" SliderTrack.Size = UDim2.new(1,-30,0,8) SliderTrack.Position = UDim2.new(0,15,0,30) SliderTrack.BackgroundColor3 = Color3.fromRGB(50,50,50) SliderTrack.BorderSizePixel = 0 SliderTrack.Parent = SettingsContent
local SliderTrackCorner = Instance.new("UICorner") SliderTrackCorner.CornerRadius = UDim.new(0,4) SliderTrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill" SliderFill.Size = UDim2.new(0.5,0,1,0) SliderFill.BackgroundColor3 = Color3.fromRGB(80,50,120) SliderFill.BorderSizePixel = 0 SliderFill.Parent = SliderTrack
local SliderFillCorner = Instance.new("UICorner") SliderFillCorner.CornerRadius = UDim.new(0,4) SliderFillCorner.Parent = SliderFill

local SliderThumb = Instance.new("TextButton")
SliderThumb.Name = "SliderThumb" SliderThumb.Size = UDim2.new(0,16,0,16) SliderThumb.Position = UDim2.new(0.5,-8,0.5,-8) SliderThumb.BackgroundColor3 = Color3.fromRGB(255,255,255) SliderThumb.Text = "" SliderThumb.AutoButtonColor = false SliderThumb.Parent = SliderTrack
local SliderThumbCorner = Instance.new("UICorner") SliderThumbCorner.CornerRadius = UDim.new(1,0) SliderThumbCorner.Parent = SliderThumb

local PercentageLabel = Instance.new("TextLabel")
PercentageLabel.Size = UDim2.new(0,50,0,18) PercentageLabel.Position = UDim2.new(1,-55,0,40) PercentageLabel.BackgroundTransparency = 1
PercentageLabel.TextColor3 = Color3.fromRGB(255,255,255) PercentageLabel.Font = Enum.Font.GothamBold PercentageLabel.TextSize = 11 PercentageLabel.Text = "100%" PercentageLabel.TextXAlignment = Enum.TextXAlignment.Right PercentageLabel.Parent = SettingsContent

local CancelScriptBtn = Instance.new("TextButton")
CancelScriptBtn.Size = UDim2.new(1, -10, 0, 22)
CancelScriptBtn.Position = UDim2.new(0, 5, 0, 70)
CancelScriptBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CancelScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelScriptBtn.Font = Enum.Font.GothamBold
CancelScriptBtn.TextSize = 11
CancelScriptBtn.Text = "Cancel Script"
CancelScriptBtn.Parent = SettingsContent
local CancelScriptCorner = Instance.new("UICorner") CancelScriptCorner.CornerRadius = UDim.new(0,4) CancelScriptCorner.Parent = CancelScriptBtn

local settingsOpen = false
SettingsFoldBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	SettingsContent.Visible = settingsOpen
	SettingsFoldBtn.Text = settingsOpen and "Settings ▲" or "Settings ▼"
end)

-- ==================== Floating Buttons ====================
local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "DracoHubFloatingButtons"
FloatingGui.ResetOnSpawn = false
FloatingGui.IgnoreGuiInset = true
FloatingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function applyButtonAutoScale(button)
	button.TextScaled = true
	button.TextWrapped = true
	button.TextSize = 14
end

local LaserButton = Instance.new("TextButton")
LaserButton.Size = UDim2.new(0, 60, 0, 30)
LaserButton.Position = DEFAULT_POSITIONS.Laser
LaserButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
LaserButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaserButton.Font = Enum.Font.GothamBold
LaserButton.Text = "Laser"
LaserButton.Visible = false
applyButtonAutoScale(LaserButton)
LaserButton.Parent = FloatingGui
local LaserCorner = Instance.new("UICorner") LaserCorner.CornerRadius = UDim.new(0, 8) LaserCorner.Parent = LaserButton

local UpthrowButton = Instance.new("TextButton")
UpthrowButton.Size = UDim2.new(0, 60, 0, 60)
UpthrowButton.Position = DEFAULT_POSITIONS.Upthrow
UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
UpthrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpthrowButton.Font = Enum.Font.GothamBold
UpthrowButton.Text = "Upthrow"
UpthrowButton.Visible = false
applyButtonAutoScale(UpthrowButton)
UpthrowButton.Parent = FloatingGui
local UpthrowCorner = Instance.new("UICorner") UpthrowCorner.CornerRadius = UDim.new(0, 8) UpthrowCorner.Parent = UpthrowButton

local FlashstrikeButton = Instance.new("TextButton")
FlashstrikeButton.Size = UDim2.new(0, 60, 0, 60)
FlashstrikeButton.Position = DEFAULT_POSITIONS.Flashstrike
FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
FlashstrikeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlashstrikeButton.Font = Enum.Font.GothamBold
FlashstrikeButton.Text = "Flashstrike"
FlashstrikeButton.Visible = false
applyButtonAutoScale(FlashstrikeButton)
FlashstrikeButton.Parent = FloatingGui
local FlashstrikeCorner = Instance.new("UICorner") FlashstrikeCorner.CornerRadius = UDim.new(0, 8) FlashstrikeCorner.Parent = FlashstrikeButton

local KickButton = Instance.new("TextButton")
KickButton.Size = UDim2.new(0, 60, 0, 60)
KickButton.Position = DEFAULT_POSITIONS.Kick
KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
KickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KickButton.Font = Enum.Font.GothamBold
KickButton.Text = "One punch"
KickButton.Visible = false
applyButtonAutoScale(KickButton)
KickButton.Parent = FloatingGui
local KickCorner = Instance.new("UICorner") KickCorner.CornerRadius = UDim.new(0, 8) KickCorner.Parent = KickButton

local ComboButton = Instance.new("TextButton")
ComboButton.Size = UDim2.new(0, 60, 0, 60)
ComboButton.Position = DEFAULT_POSITIONS.Combo
ComboButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ComboButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ComboButton.Font = Enum.Font.GothamBold
ComboButton.Text = "Donut"
ComboButton.Visible = false
applyButtonAutoScale(ComboButton)
ComboButton.Parent = FloatingGui
local ComboCorner = Instance.new("UICorner") ComboCorner.CornerRadius = UDim.new(0, 8) ComboCorner.Parent = ComboButton

-- tp Button
local MoAimButton = Instance.new("TextButton")
MoAimButton.Size = UDim2.new(0, 60, 0, 30)
MoAimButton.Position = DEFAULT_POSITIONS.MoAim
MoAimButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
MoAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoAimButton.Font = Enum.Font.GothamBold
MoAimButton.Text = "tp\n(Hold)"
MoAimButton.TextScaled = false
MoAimButton.TextWrapped = true
MoAimButton.TextSize = 11
MoAimButton.TextYAlignment = Enum.TextYAlignment.Center
MoAimButton.Visible = false
MoAimButton.Parent = FloatingGui
local MoAimCorner = Instance.new("UICorner") MoAimCorner.CornerRadius = UDim.new(0, 8) MoAimCorner.Parent = MoAimButton

-- ==================== Remote Finders ====================
local function findHomelanderMoveOneRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("homelander") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name == "MoveOne" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findClosestPlayer(maxDistance)
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	local closestPlayer = nil
	local closestDistance = maxDistance or 4
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local targetCharacter = player.Character
			if targetCharacter then
				local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					local distance = (root.Position - targetRoot.Position).Magnitude
					if distance <= closestDistance then
						closestPlayer = player
						closestDistance = distance
					end
				end
			end
		end
	end
	return closestPlayer
end

local function findLuffyGatlingRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("luffy") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "gatling" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findTheBatmanSkydiveRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("thebatman") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "skydive" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findHomelanderEagleStrikeRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("homelander") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "eaglestrike" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findMohawkMoveOneRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("mohawk") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "moveone" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findHomelanderThrowDownRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("homelander") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name == "ThrowDown" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findTheFlashCwFinalRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("theflashcw") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name == "Final" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findZodiacKickRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("zodiac") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "kick" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findSteveHShieldCounterRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower() == "steve_h" then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name == "ShieldCounter" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findSpiderManWebBlossomRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("spiderman") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower():find("webbloss") then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findTheBatmanMoveOneRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("thebatman") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "moveone" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findTheFlashCwVibrateArmRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("theflashcw") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "vibratearm" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

local function findAmazoFinisherRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("amazo") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "finisher" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

-- ==================== View Tracking Aim System ====================
local function getPlayerFromScreenCenter()
	local camera = workspace.CurrentCamera
	if not camera then return nil end

	local viewportSize = camera.ViewportSize
	local screenCenterX = viewportSize.X / 2
	local detectionWidth = viewportSize.X / 4

	local closestPlayer = nil
	local closestDepth = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local targetCharacter = player.Character
			if targetCharacter then
				local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					local screenPos, onScreen = camera:WorldToScreenPoint(targetRoot.Position)
					if onScreen then
						local screenX = screenPos.X
						if math.abs(screenX - screenCenterX) <= detectionWidth / 2 then
							if screenPos.Z < closestDepth then
								closestDepth = screenPos.Z
								closestPlayer = player
							end
						end
					end
				end
			end
		end
	end
	return closestPlayer
end

local function startAiming()
	if aimActive then return end
	
	local targetPlayer = getPlayerFromScreenCenter()
	if not targetPlayer then return end

	aimActive = true
	aimTarget = targetPlayer
	MoAimButton.Text = "tp▶\n(Hold)"
	MoAimButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

	local targetChar = targetPlayer.Character
	if targetChar then
		local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			aimLine = Instance.new("Part")
			aimLine.Size = Vector3.new(0.3, 10, 0.3)
			aimLine.Color = Color3.fromRGB(255, 0, 0)
			aimLine.Material = Enum.Material.Neon
			aimLine.Anchored = true
			aimLine.CanCollide = false
			aimLine.Parent = workspace
			aimLine.Position = targetRoot.Position + Vector3.new(0, 3, 0)

			aimHighlight = Instance.new("Highlight")
			aimHighlight.FillColor = Color3.fromRGB(255, 0, 0)
			aimHighlight.FillTransparency = 0.7
			aimHighlight.OutlineColor = Color3.fromRGB(255, 0, 0)
			aimHighlight.OutlineTransparency = 0
			aimHighlight.Parent = targetChar
		end
	end

	if aimUpdateConnection then aimUpdateConnection:Disconnect() end
	aimUpdateConnection = RunService.Heartbeat:Connect(function()
		if not aimActive then return end
		
		local newTarget = getPlayerFromScreenCenter()
		if newTarget and newTarget ~= aimTarget then
			aimTarget = newTarget
			
			if aimHighlight then aimHighlight:Destroy() end
			if aimLine then aimLine:Destroy() end
			
			local newChar = newTarget.Character
			if newChar then
				local newRoot = newChar:FindFirstChild("HumanoidRootPart")
				if newRoot then
					aimLine = Instance.new("Part")
					aimLine.Size = Vector3.new(0.3, 10, 0.3)
					aimLine.Color = Color3.fromRGB(255, 0, 0)
					aimLine.Material = Enum.Material.Neon
					aimLine.Anchored = true
					aimLine.CanCollide = false
					aimLine.Parent = workspace
					aimLine.Position = newRoot.Position + Vector3.new(0, 3, 0)

					aimHighlight = Instance.new("Highlight")
					aimHighlight.FillColor = Color3.fromRGB(255, 0, 0)
					aimHighlight.FillTransparency = 0.7
					aimHighlight.OutlineColor = Color3.fromRGB(255, 0, 0)
					aimHighlight.OutlineTransparency = 0
					aimHighlight.Parent = newChar
				end
			end
		end
		
		if aimLine and aimTarget then
			local targetChar = aimTarget.Character
			if targetChar then
				local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					aimLine.Position = targetRoot.Position + Vector3.new(0, 3, 0)
				end
			end
		end
	end)
end

local function stopAiming()
	if aimActive and aimTarget then
		local targetPlayer = aimTarget
		local targetChar = targetPlayer.Character
		local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		
		if targetRoot then
			local myChar = LocalPlayer.Character
			local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
			
			if myRoot then
				local targetLookVector = targetRoot.CFrame.LookVector
				local behindPos = targetRoot.Position - targetLookVector * 3
				behindPos = Vector3.new(behindPos.X, targetRoot.Position.Y + 1, behindPos.Z)
				
				myRoot.CFrame = CFrame.lookAt(behindPos, targetRoot.Position)
				myRoot.Velocity = Vector3.new(0, 0, 0)
				myRoot.RotVelocity = Vector3.new(0, 0, 0)
				
				local camera = workspace.CurrentCamera
				if camera then
					local lookAtPos = targetRoot.Position
					local newCamCFrame = CFrame.lookAt(behindPos, lookAtPos)
					camera.CFrame = newCamCFrame
					
					task.delay(0.1, function()
						local head = myChar and myChar:FindFirstChild("Head")
						if head and camera then
							camera.CFrame = CFrame.lookAt(camera.CFrame.Position, head.Position)
						end
					end)
				end
			end
		end
	end
	
	aimActive = false
	aimTarget = nil
	MoAimButton.Text = "tp\n(Hold)"
	MoAimButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)

	if aimUpdateConnection then
		aimUpdateConnection:Disconnect()
		aimUpdateConnection = nil
	end

	if aimLine then
		aimLine:Destroy()
		aimLine = nil
	end
	if aimHighlight then
		aimHighlight:Destroy()
		aimHighlight = nil
	end
end

MoAimButton.InputBegan:Connect(function(input)
	if moveUnlocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		startAiming()
	end
end)

MoAimButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		stopAiming()
	end
end)

-- ==================== Laser Logic ====================
local function setLaserActive(active)
	laserActive = active
	if active then
		local remote = findHomelanderMoveOneRemote()
		if not remote then
			laserActive = false
			LaserButton.Text = "No Remote"
			LaserButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			return
		end
		LaserButton.Text = "ON"
		LaserButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		laserThread = task.spawn(function()
			while laserActive do
				remote:FireServer()
				task.wait()
			end
		end)
	else
		if laserThread then
			task.cancel(laserThread)
			laserThread = nil
		end
		LaserButton.Text = "Laser"
		LaserButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	end
end

LaserButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	setLaserActive(not laserActive)
end)

-- ==================== Upthrow / Air slam Logic ====================
UpthrowButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if upthrowCooldown then return end

	if mohawkModActive then
		-- ===== Mohawk mode: Air slam (full combo) =====
		local remote = findHomelanderThrowDownRemote()
		if not remote then
			UpthrowButton.Text = "No Remote"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			task.wait(0.5)
			UpthrowButton.Text = "Air slam"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			return
		end

		local targetPlayer = findClosestPlayer(4)
		if not targetPlayer then
			UpthrowButton.Text = "No Target"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			task.wait(0.5)
			UpthrowButton.Text = "Air slam"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			return
		end

		upthrowCooldown = true
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		UpthrowButton.BackgroundTransparency = 0.5
		UpthrowButton.Text = "2"
		task.delay(1, function() UpthrowButton.Text = "1" end)
		task.delay(2, function()
			upthrowCooldown = false
			UpthrowButton.Text = "Air slam"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			UpthrowButton.BackgroundTransparency = 0
		end)

		local targetCharacter = targetPlayer.Character
		local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
		if not targetRoot then
			UpthrowButton.Text = "No Target"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			UpthrowButton.BackgroundTransparency = 0
			upthrowCooldown = false
			task.wait(0.5)
			UpthrowButton.Text = "Air slam"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			return
		end

		local myCharacter = LocalPlayer.Character
		local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
		if not myRoot then return end

		local lookVector = targetRoot.CFrame.LookVector
		local horizontalDir = Vector3.new(lookVector.X, 0, lookVector.Z)
		if horizontalDir.Magnitude < 0.01 then horizontalDir = Vector3.new(1,0,0) else horizontalDir = horizontalDir.Unit end
		local targetPos = targetRoot.Position + horizontalDir * 2.5
		targetPos = Vector3.new(targetPos.X, targetRoot.Position.Y + 3, targetPos.Z)
		myRoot.CFrame = CFrame.lookAt(targetPos, targetRoot.Position)
		myRoot.Velocity = Vector3.new(0,0,0)
		myRoot.RotVelocity = Vector3.new(0,0,0)

		local humanoid = myCharacter:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid.AutoRotate = false
		end

		if simultaneousEnabled then
			for i = 1, simultaneousCount do remote:FireServer() end
		elseif loopInterval > 0 then
			task.spawn(function()
				while loopInterval > 0 do
					remote:FireServer()
					task.wait(loopInterval)
				end
			end)
		else
			remote:FireServer()
		end

		task.delay(0.9, function()
			local skydiveRemote = findTheBatmanSkydiveRemote()
			if skydiveRemote then skydiveRemote:FireServer() end
			local eagleRemote = findHomelanderEagleStrikeRemote()
			if eagleRemote then eagleRemote:FireServer() end
		end)

		local tpDelay = 0.9
		local gatlingDelay = 0.8
		local mohawkDelay = 2.05

		local bodyVel = nil
		local bodyGyro = nil
		local freezeConnection = nil
		local isCleanedUp = false

		local function cleanup()
			if isCleanedUp then return end
			isCleanedUp = true
			if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
			if bodyVel then bodyVel:Destroy() bodyVel = nil end
			if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
			local currentChar = LocalPlayer.Character
			local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
			if currentHumanoid then
				currentHumanoid.WalkSpeed = 16
				currentHumanoid.JumpPower = 50
				currentHumanoid.AutoRotate = true
			end
			local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
			if currentRoot then
				currentRoot.Velocity = Vector3.new(0, 0, 0)
				currentRoot.RotVelocity = Vector3.new(0, 0, 0)
			end
		end

		task.delay(tpDelay, function()
			local lockActive = true
			local myCharacter2 = LocalPlayer.Character
			local myRoot2 = myCharacter2 and myCharacter2:FindFirstChild("HumanoidRootPart")
			if not myRoot2 then cleanup() return end

			local humanoid2 = myCharacter2:FindFirstChildOfClass("Humanoid")
			if humanoid2 then
				humanoid2.WalkSpeed = 0
				humanoid2.JumpPower = 0
				humanoid2.AutoRotate = false
			end

			local newStartX = myRoot2.Position.X
			local newStartZ = myRoot2.Position.Z

			bodyVel = Instance.new("BodyVelocity")
			bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
			bodyVel.Velocity = Vector3.new(0, 80, 0)
			bodyVel.Parent = myRoot2

			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
			bodyGyro.CFrame = myRoot2.CFrame
			bodyGyro.Parent = myRoot2

			freezeConnection = RunService.Heartbeat:Connect(function()
				if not lockActive then
					freezeConnection:Disconnect()
					return
				end
				if myRoot2 and myRoot2.Parent then
					myRoot2.Position = Vector3.new(newStartX, myRoot2.Position.Y, newStartZ)
					myRoot2.Velocity = Vector3.new(0, myRoot2.Velocity.Y, 0)
					myRoot2.RotVelocity = Vector3.new(0, 0, 0)
				end
			end)

			task.delay(gatlingDelay + mohawkDelay, function()
				lockActive = false
				if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
				if bodyVel then bodyVel:Destroy() bodyVel = nil end
				if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

				local targetRoot2 = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
				local myRoot3 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if targetRoot2 and myRoot3 then
					local lookVector2 = targetRoot2.CFrame.LookVector
					local horizontalDir2 = Vector3.new(lookVector2.X, 0, lookVector2.Z)
					if horizontalDir2.Magnitude < 0.01 then horizontalDir2 = Vector3.new(1,0,0) else horizontalDir2 = horizontalDir2.Unit end
					local targetPos2 = targetRoot2.Position + horizontalDir2 * 2.5
					targetPos2 = Vector3.new(targetPos2.X, targetRoot2.Position.Y + 3, targetPos2.Z)
					myRoot3.CFrame = CFrame.lookAt(targetPos2, targetRoot2.Position)
					myRoot3.Velocity = Vector3.new(0,0,0)
					myRoot3.RotVelocity = Vector3.new(0,0,0)
				end

				local mohawkRemote = findMohawkMoveOneRemote()
				if mohawkRemote then
					for i = 1, 8 do
						mohawkRemote:FireServer()
					end
				end

				task.delay(0.5, function()
					cleanup()
				end)
			end)

			task.delay(gatlingDelay, function()
				lockActive = false
				if freezeConnection then freezeConnection:Disconnect() freezeConnection = nil end
				if bodyVel then bodyVel:Destroy() bodyVel = nil end
				if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

				local targetRootTP = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
				local myRootTP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if targetRootTP and myRootTP then
					local lookVectorTP = targetRootTP.CFrame.LookVector
					local horizontalDirTP = Vector3.new(lookVectorTP.X, 0, lookVectorTP.Z)
					if horizontalDirTP.Magnitude < 0.01 then horizontalDirTP = Vector3.new(1,0,0) else horizontalDirTP = horizontalDirTP.Unit end
					local targetPosTP = targetRootTP.Position + horizontalDirTP * 2.5
					targetPosTP = Vector3.new(targetPosTP.X, targetRootTP.Position.Y + 3, targetPosTP.Z)
					myRootTP.CFrame = CFrame.lookAt(targetPosTP, targetRootTP.Position)
					myRootTP.Velocity = Vector3.new(0,0,0)
					myRootTP.RotVelocity = Vector3.new(0,0,0)
				end

				local gatlingRemote = findLuffyGatlingRemote()
				if gatlingRemote then
					gatlingRemote:FireServer()
				end

				local trackActive = true
				task.spawn(function()
					while trackActive do
						local targetRootTrack = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
						local myRootTrack = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						if targetRootTrack and myRootTrack then
							local lookVectorTrack = targetRootTrack.CFrame.LookVector
							local horizontalDirTrack = Vector3.new(lookVectorTrack.X, 0, lookVectorTrack.Z)
							if horizontalDirTrack.Magnitude < 0.01 then horizontalDirTrack = Vector3.new(1,0,0) else horizontalDirTrack = horizontalDirTrack.Unit end
							local targetPosTrack = targetRootTrack.Position + horizontalDirTrack * 2.5
							targetPosTrack = Vector3.new(targetPosTrack.X, targetRootTrack.Position.Y + 1.5, targetPosTrack.Z)
							myRootTrack.CFrame = CFrame.lookAt(targetPosTrack, targetRootTrack.Position)
							myRootTrack.Velocity = Vector3.new(0,0,0)
							myRootTrack.RotVelocity = Vector3.new(0,0,0)
						end
						task.wait(0.03)
					end
				end)

				task.delay(0.7, function()
					trackActive = false
				end)

				if humanoid2 then
					humanoid2.WalkSpeed = 16
					humanoid2.JumpPower = 50
					humanoid2.AutoRotate = true
				end
			end)
		end)

		task.delay(tpDelay + gatlingDelay + mohawkDelay + 1, function()
			cleanup()
		end)

	else
		-- ===== Homelanders mode: Upthrow (only 1x ThrowDown) =====
		local remote = findHomelanderThrowDownRemote()
		if not remote then
			UpthrowButton.Text = "No Remote"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			task.wait(0.5)
			UpthrowButton.Text = "Upthrow"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			return
		end

		local targetPlayer = findClosestPlayer(4)
		if not targetPlayer then
			UpthrowButton.Text = "No Target"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			task.wait(0.5)
			UpthrowButton.Text = "Upthrow"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			return
		end

		upthrowCooldown = true
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		UpthrowButton.BackgroundTransparency = 0.5
		UpthrowButton.Text = "2"
		task.delay(1, function() UpthrowButton.Text = "1" end)
		task.delay(2, function()
			upthrowCooldown = false
			UpthrowButton.Text = "Upthrow"
			UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
			UpthrowButton.BackgroundTransparency = 0
		end)

		remote:FireServer()
	end
end)

-- ==================== Flashstrike Logic ====================
local function startFlashstrikeCooldown()
	flashstrikeCooldownActive = true
	FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
	FlashstrikeButton.BackgroundTransparency = 0.5
	FlashstrikeButton.Text = tostring(flashstrikeCooldown)
	
	task.spawn(function()
		for i = flashstrikeCooldown, 1, -1 do
			task.wait(1)
			if not flashstrikeCooldownActive then break end
			if i > 1 then
				FlashstrikeButton.Text = tostring(i - 1)
			end
		end
		flashstrikeCooldownActive = false
		FlashstrikeButton.Text = "Flashstrike"
		FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
		FlashstrikeButton.BackgroundTransparency = 0
	end)
end

FlashstrikeButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if flashstrikeCooldownActive then return end
	local remote = findTheFlashCwFinalRemote()
	if remote then
		if simultaneousEnabled then
			for i = 1, simultaneousCount do remote:FireServer() end
		elseif loopInterval > 0 then
			task.spawn(function()
				while loopInterval > 0 do
					remote:FireServer()
					task.wait(loopInterval)
				end
			end)
		else
			remote:FireServer()
		end
		startFlashstrikeCooldown()
	else
		FlashstrikeButton.Text = "No Remote"
		FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		task.wait(0.5)
		FlashstrikeButton.Text = "Flashstrike"
		FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
	end
end)

-- ==================== Kick Logic ====================
KickButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	local kickRemote = findZodiacKickRemote()
	local shieldRemote = findSteveHShieldCounterRemote()
	local webBlossomRemote = findSpiderManWebBlossomRemote()
	
	kickActive = true
	
	task.spawn(function()
		while kickActive and webBlossomRemote do
			webBlossomRemote:FireServer()
			task.wait(0.1)
		end
	end)
	
	if shieldRemote then
		shieldRemote:FireServer()
	end
	
	task.wait(0.5)
	
	if kickRemote then
		for i = 1, 40 do
			kickRemote:FireServer()
		end
		kickActive = false
		
		KickButton.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
		task.wait(0.1)
		KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
	else
		kickActive = false
		KickButton.Text = "No Kick"
		KickButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		task.wait(0.5)
		KickButton.Text = "One punch"
		KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
	end
end)

-- ==================== Combo Logic ====================
ComboButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	
	local batmanMoveOne = findTheBatmanMoveOneRemote()
	
	if batmanMoveOne then batmanMoveOne:FireServer() end
	
	task.spawn(function()
		task.wait(2.7)
		local vibrateRemote = findTheFlashCwVibrateArmRemote()
		if vibrateRemote then
			for i = 1, 40 do
				vibrateRemote:FireServer()
			end
		end
	end)
	
	ComboButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	task.wait(0.1)
	ComboButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

-- ==================== Homelander Fly ====================
FlightToggleBtn.MouseButton1Click:Connect(function()
	if flightTask then return end
	flightTask = task.spawn(function()
		loadstring(game:HttpGet("https://obj.wearedevs.net/197198/scripts/invincible%20flight%20animation.lua"))()
	end)
	FlightToggleBtn.Text = "Homelander Fly (ON)"
	FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ==================== Move Skills Mode ====================
local function updateMoveModeButton()
	if moveUnlocked then
		MoveModeBtn.Text = "Move Skills Mode: Unlocked"
		MoveModeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		ResetPosBtn.Visible = true
	else
		MoveModeBtn.Text = "Move Skills Mode: Locked"
		MoveModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		ResetPosBtn.Visible = false
	end
end

MoveModeBtn.MouseButton1Click:Connect(function()
	moveUnlocked = not moveUnlocked
	updateMoveModeButton()
end)

updateMoveModeButton()

ResetPosBtn.MouseButton1Click:Connect(function()
	LaserButton.Position = DEFAULT_POSITIONS.Laser
	UpthrowButton.Position = DEFAULT_POSITIONS.Upthrow
	FlashstrikeButton.Position = DEFAULT_POSITIONS.Flashstrike
	KickButton.Position = DEFAULT_POSITIONS.Kick
	ComboButton.Position = DEFAULT_POSITIONS.Combo
	MoAimButton.Position = DEFAULT_POSITIONS.MoAim
end)

-- ==================== Drag Logic for Floating Buttons ====================
local function setupDrag(button)
	local dragging = false
	local dragStart, startPos
	button.InputBegan:Connect(function(input)
		if not moveUnlocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = button.Position
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

setupDrag(LaserButton)
setupDrag(UpthrowButton)
setupDrag(FlashstrikeButton)
setupDrag(KickButton)
setupDrag(ComboButton)
setupDrag(MoAimButton)

-- ==================== Homelanders Mod / Mohawk mode mutual exclusion ====================
local function startFinisherLoop()
	if finisherActive then return end
	local remote = findAmazoFinisherRemote()
	if not remote then return end
	finisherActive = true
	finisherLoopThread = task.spawn(function()
		while finisherActive do
			remote:FireServer()
			task.wait(0.1)
		end
	end)
end

local function stopFinisherLoop()
	finisherActive = false
	if finisherLoopThread then
		task.cancel(finisherLoopThread)
		finisherLoopThread = nil
	end
end

local function updateAllButtonsVisibility()
	if homelanderModActive then
		LaserButton.Visible = true
		UpthrowButton.Visible = true
		FlashstrikeButton.Visible = true
		KickButton.Visible = true
		ComboButton.Visible = true
		MoAimButton.Visible = false
		UpthrowButton.Text = "Upthrow"
	elseif mohawkModActive then
		LaserButton.Visible = false
		UpthrowButton.Visible = true
		FlashstrikeButton.Visible = true
		KickButton.Visible = true
		ComboButton.Visible = true
		MoAimButton.Visible = true
		UpthrowButton.Text = "Air slam"
	else
		LaserButton.Visible = false
		UpthrowButton.Visible = false
		FlashstrikeButton.Visible = false
		KickButton.Visible = false
		ComboButton.Visible = false
		MoAimButton.Visible = false
		UpthrowButton.Text = "Upthrow"
	end
end

local function updateHomelanderModButton()
	if homelanderModActive then
		HomelanderModBtn.Text = "Cancel Mod"
		HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
		HomelanderModBtn.Size = UDim2.new(0.5, -8, 0, 24)
		FinisherButton.Visible = true
		FinisherButton.Text = finisherEnabled and "Auto Finisher ON" or "Auto Finisher OFF"
		FinisherButton.BackgroundColor3 = finisherEnabled and Color3.fromRGB(30, 100, 60) or Color3.fromRGB(100, 40, 40)
		if finisherEnabled then
			startFinisherLoop()
		else
			stopFinisherLoop()
		end
	else
		HomelanderModBtn.Text = "Homelanders Mod"
		HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
		HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
		FinisherButton.Visible = false
		stopFinisherLoop()
	end
end

local function updateMohawkModButton()
	if mohawkModActive then
		MohawkModBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 60)
		TestLabel.Text = "TEST"
		ModeLabel.Text = "Mohawk mode ON"
	else
		MohawkModBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
		TestLabel.Text = "TEST"
		ModeLabel.Text = "Mohawk mode"
	end
end

HomelanderModBtn.MouseButton1Click:Connect(function()
	homelanderModActive = not homelanderModActive
	if homelanderModActive and mohawkModActive then
		mohawkModActive = false
		updateMohawkModButton()
	end
	updateHomelanderModButton()
	updateAllButtonsVisibility()
end)

MohawkModBtn.MouseButton1Click:Connect(function()
	mohawkModActive = not mohawkModActive
	if mohawkModActive and homelanderModActive then
		homelanderModActive = false
		updateHomelanderModButton()
	end
	updateMohawkModButton()
	updateAllButtonsVisibility()
end)

FinisherButton.MouseButton1Click:Connect(function()
	finisherEnabled = not finisherEnabled
	FinisherButton.Text = finisherEnabled and "Auto Finisher ON" or "Auto Finisher OFF"
	FinisherButton.BackgroundColor3 = finisherEnabled and Color3.fromRGB(30, 100, 60) or Color3.fromRGB(100, 40, 40)
	if finisherEnabled then
		if homelanderModActive then
			startFinisherLoop()
		end
	else
		stopFinisherLoop()
	end
end)

updateHomelanderModButton()
updateMohawkModButton()
updateAllButtonsVisibility()

-- ==================== UI Scale Slider ====================
local minScale = 0.5 local maxScale = 1.5 local currentScale = uiScale.Scale
local function UpdateFromScale(scale)
	currentScale = math.clamp(scale, minScale, maxScale) uiScale.Scale = currentScale
	local ratio = (currentScale - minScale) / (maxScale - minScale)
	SliderFill.Size = UDim2.new(ratio,0,1,0) SliderThumb.Position = UDim2.new(ratio,-8,0.5,-8)
	PercentageLabel.Text = string.format("%d%%", math.floor(currentScale * 100 + 0.5))
end
UpdateFromScale(1)
local isDraggingSlider = false
local function GetSliderRatio(inputPosition)
	local trackAbsolutePos = SliderTrack.AbsolutePosition
	local trackAbsoluteSize = SliderTrack.AbsoluteSize
	local relativeX = inputPosition.X - trackAbsolutePos.X
	return math.clamp(relativeX / trackAbsoluteSize.X, 0, 1)
end
local function StartSliderDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingSlider = true
		local ratio = GetSliderRatio(input.Position)
		local newScale = minScale + ratio * (maxScale - minScale)
		UpdateFromScale(newScale)
	end
end
local function StopSliderDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingSlider = false
	end
end
local function DragSlider(input)
	if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local ratio = GetSliderRatio(input.Position)
		local newScale = minScale + ratio * (maxScale - minScale)
		UpdateFromScale(newScale)
	end
end
SliderTrack.InputBegan:Connect(StartSliderDrag)
SliderThumb.InputBegan:Connect(StartSliderDrag)
UIS.InputEnded:Connect(StopSliderDrag)
UIS.InputChanged:Connect(DragSlider)

-- ==================== Cancel Script ====================
local function CancelScript()
	loopInterval = 0
	isCustomLoopActive = false
	simultaneousEnabled = false
	kickActive = false
	stopFinisherLoop()
	stopAiming()
	if currentLoopThread then
		task.cancel(currentLoopThread)
		currentLoopThread = nil
	end
	if laserThread then
		task.cancel(laserThread)
		laserThread = nil
	end
	laserActive = false
	flashstrikeCooldownActive = false
	upthrowCooldown = false
	ScreenGui:Destroy()
	FloatingGui:Destroy()
end

CancelScriptBtn.MouseButton1Click:Connect(CancelScript)

-- ==================== Main Window Drag & Lock ====================
local isWindowLocked = true
local function UpdateLockVisuals()
	if isWindowLocked then LockButtonTop.Text = "🔒" LockButtonTop.TextColor3 = Color3.fromRGB(255,80,80)
	else LockButtonTop.Text = "🔓" LockButtonTop.TextColor3 = Color3.fromRGB(220,220,220) end
end
local function ToggleLock() isWindowLocked = not isWindowLocked UpdateLockVisuals() end
LockButtonTop.MouseButton1Click:Connect(ToggleLock) UpdateLockVisuals()

local dragging = false local dragStart, startPos
Main.InputBegan:Connect(function(input)
	if isWindowLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true dragStart = input.Position startPos = Main.Position
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UIS.InputChanged:Connect(function(input)
	if isWindowLocked then return end
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ==================== Refresh Skill List ====================
local function Refresh()
	for _, child in ipairs(Scroll:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
	end
	local searchText = SearchBox.Text:lower()
	local function MakeButton(text, callback)
		local B = Instance.new("TextButton") B.Size = UDim2.new(1,-6,0,22) B.BackgroundColor3 = Color3.fromRGB(32,32,32) B.TextColor3 = Color3.fromRGB(230,230,230) B.Font = Enum.Font.Gotham B.TextSize = 11 B.Text = text B.Parent = Scroll
		local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0,4) BC.Parent = B
		B.MouseButton1Click:Connect(callback or function() end) return B
	end
	local function MakeCategory(label)
		local L = Instance.new("TextLabel") L.Size = UDim2.new(1,-6,0,20) L.BackgroundColor3 = Color3.fromRGB(45,25,70) L.TextColor3 = Color3.fromRGB(240,220,255) L.Font = Enum.Font.GothamBold L.TextSize = 11 L.Text = "▸ " .. label L.Parent = Scroll
		local LC = Instance.new("UICorner") LC.CornerRadius = UDim.new(0,4) LC.Parent = L return L
	end
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then MakeButton("[ERROR] No Characters folder", function() end) return end
	for _, characterFolder in ipairs(charactersFolder:GetChildren()) do
		if characterFolder:IsA("Folder") or characterFolder:IsA("Model") then
			local charName = characterFolder.Name local remotesFolder = characterFolder:FindFirstChild("Remotes") local matchedAbilities = {}
			if remotesFolder then
				for _, remote in ipairs(remotesFolder:GetChildren()) do
					if remote:IsA("RemoteEvent") then local abilityName = remote.Name
						if searchText == "" or charName:lower():find(searchText) or abilityName:lower():find(searchText) then
							table.insert(matchedAbilities, {remote = remote, name = abilityName})
						end
					end
				end
			end
			if searchText == "" or charName:lower():find(searchText) or #matchedAbilities > 0 then
				MakeCategory(charName)
				if #matchedAbilities == 0 then MakeButton("[NO REMOTES] " .. charName, function() end)
				else for _, data in ipairs(matchedAbilities) do
					MakeButton("⚡ " .. data.name, function()
						if simultaneousEnabled then
							for i = 1, simultaneousCount do
								data.remote:FireServer()
							end
						elseif loopInterval > 0 then
							if currentLoopThread then task.cancel(currentLoopThread) currentLoopThread = nil end
							local interval = loopInterval
							currentLoopThread = task.spawn(function()
								while loopInterval > 0 do
									data.remote:FireServer()
									task.wait(interval)
								end
							end)
						else
							if currentLoopThread then task.cancel(currentLoopThread) currentLoopThread = nil end
							data.remote:FireServer()
						end
					end)
				end end
			end
		end
	end
	task.wait() Scroll.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y + 10)
end

local function AutoDetectCharacter()
	local char = LocalPlayer.Character
	if char then local charName = char.Name local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
		if charactersFolder then for _, folder in ipairs(charactersFolder:GetChildren()) do
			if folder.Name:lower() == charName:lower() then SearchBox.Text = folder.Name return end
		end end
	end
end
LocalPlayer.CharacterAdded:Connect(function(newChar) Character = newChar task.wait(1) AutoDetectCharacter() end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(Refresh)

AutoDetectCharacter() Refresh()

print("✅ Full script loaded!")
print("🎯 tp: Hold tp(Hold) → rotate view to switch target → release = teleport behind target + 0.1s visual focus")
print("🔥 Upthrow: Homelanders mode = 1x ThrowDown | Mohawk mode = Air slam (full combo)")
print("🔥 Skills: Laser / Flashstrike / One punch / Donut")
print("🛡️ God Mode / Reset / Homelanders Mod / Mohawk mode / Fly - all intact")
