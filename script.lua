local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

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

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

local flightTask = nil

local DEFAULT_POSITIONS = {
	Laser = UDim2.new(1, -240, 0.5, -30),
	Upthrow = UDim2.new(1, -310, 0.5, -30),
	Overthrow = UDim2.new(1, -310, 0.5, 40),
	Flashstrike = UDim2.new(1, -310, 0.5, -110)
}

local function getSavedPosition(buttonName, defaultPos)
	local saved = LocalPlayer:GetAttribute(buttonName .. "Pos")
	if saved then
		local parts = {}
		for part in saved:gmatch("[^,]+") do table.insert(parts, part) end
		if #parts == 4 then
			local xScale = tonumber(parts[1])
			local xOffset = tonumber(parts[2])
			local yScale = tonumber(parts[3])
			local yOffset = tonumber(parts[4])
			if xScale and xOffset and yScale and yOffset then
				return UDim2.new(xScale, xOffset, yScale, yOffset)
			end
		end
	end
	return defaultPos
end

local function savePosition(buttonName, pos)
	LocalPlayer:SetAttribute(buttonName .. "Pos", string.format("%.4f,%.0f,%.4f,%.0f", pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset))
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DracoHubScannerV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 160, 0, 350)
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
Tab2.TextColor3 = Color3.fromRGB(180,180,180) Tab2.Font = Enum.Font.GothamBold Tab2.TextSize = 11 Tab2.Text = "Settings" Tab2.Parent = TabContainer
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

local LoopContainer1 = Instance.new("Frame")
LoopContainer1.Size = UDim2.new(1,-10,0,20) LoopContainer1.Position = UDim2.new(0,5,0,49) LoopContainer1.BackgroundColor3 = Color3.fromRGB(20,20,20) LoopContainer1.BorderSizePixel = 0 LoopContainer1.Parent = Page1
local LoopContainer1Corner = Instance.new("UICorner") LoopContainer1Corner.CornerRadius = UDim.new(0,4) LoopContainer1Corner.Parent = LoopContainer1

local LoopToggle1 = Instance.new("TextButton")
LoopToggle1.Size = UDim2.new(0,22,0,18) LoopToggle1.Position = UDim2.new(0,5,0,1) LoopToggle1.BackgroundColor3 = Color3.fromRGB(40,40,40)
LoopToggle1.TextColor3 = Color3.fromRGB(0,255,120) LoopToggle1.Font = Enum.Font.GothamBold LoopToggle1.TextSize = 11 LoopToggle1.Text = "" LoopToggle1.Parent = LoopContainer1
local Toggle1Corner = Instance.new("UICorner") Toggle1Corner.CornerRadius = UDim.new(0,3) Toggle1Corner.Parent = LoopToggle1

local LoopLabel1 = Instance.new("TextLabel")
LoopLabel1.Size = UDim2.new(1,-34,1,0) LoopLabel1.Position = UDim2.new(0,32,0,0) LoopLabel1.BackgroundTransparency = 1
LoopLabel1.TextColor3 = Color3.fromRGB(200,200,200) LoopLabel1.Font = Enum.Font.Gotham LoopLabel1.TextSize = 10 LoopLabel1.Text = "Loop 1s" LoopLabel1.TextXAlignment = Enum.TextXAlignment.Left LoopLabel1.Parent = LoopContainer1

local CustomLoopContainer = Instance.new("Frame")
CustomLoopContainer.Size = UDim2.new(1,-10,0,20) CustomLoopContainer.Position = UDim2.new(0,5,0,71) CustomLoopContainer.BackgroundColor3 = Color3.fromRGB(20,20,20) CustomLoopContainer.BorderSizePixel = 0 CustomLoopContainer.Parent = Page1
local CustomLoopContainerCorner = Instance.new("UICorner") CustomLoopContainerCorner.CornerRadius = UDim.new(0,4) CustomLoopContainerCorner.Parent = CustomLoopContainer

local CustomToggle = Instance.new("TextButton")
CustomToggle.Size = UDim2.new(0,22,0,18) CustomToggle.Position = UDim2.new(0,5,0,1) CustomToggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
CustomToggle.TextColor3 = Color3.fromRGB(0,255,120) CustomToggle.Font = Enum.Font.GothamBold CustomToggle.TextSize = 11 CustomToggle.Text = "" CustomToggle.Parent = CustomLoopContainer
local CustomToggleCorner = Instance.new("UICorner") CustomToggleCorner.CornerRadius = UDim.new(0,3) CustomToggleCorner.Parent = CustomToggle

local SubBtn = Instance.new("TextButton")
SubBtn.Size = UDim2.new(0,20,0,16) SubBtn.Position = UDim2.new(0,32,0,2) SubBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
SubBtn.TextColor3 = Color3.fromRGB(220,220,220) SubBtn.Font = Enum.Font.GothamBold SubBtn.TextSize = 12 SubBtn.Text = "-" SubBtn.Parent = CustomLoopContainer
local SubCorner = Instance.new("UICorner") SubCorner.CornerRadius = UDim.new(0,3) SubCorner.Parent = SubBtn

local CustomInput = Instance.new("TextBox")
CustomInput.Size = UDim2.new(0,40,0,16) CustomInput.Position = UDim2.new(0,52,0,2) CustomInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
CustomInput.TextColor3 = Color3.fromRGB(240,240,240) CustomInput.Font = Enum.Font.Gotham CustomInput.TextSize = 10 CustomInput.Text = "0.05" CustomInput.ClearTextOnFocus = false CustomInput.Parent = CustomLoopContainer
local InputCorner = Instance.new("UICorner") InputCorner.CornerRadius = UDim.new(0,3) InputCorner.Parent = CustomInput

local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(0,20,0,16) AddBtn.Position = UDim2.new(0,96,0,2) AddBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
AddBtn.TextColor3 = Color3.fromRGB(220,220,220) AddBtn.Font = Enum.Font.GothamBold AddBtn.TextSize = 12 AddBtn.Text = "+" AddBtn.Parent = CustomLoopContainer
local AddCorner = Instance.new("UICorner") AddCorner.CornerRadius = UDim.new(0,3) AddCorner.Parent = AddBtn

local CustomLabel = Instance.new("TextLabel")
CustomLabel.Size = UDim2.new(1,-120,1,0) CustomLabel.Position = UDim2.new(0,120,0,0) CustomLabel.BackgroundTransparency = 1
CustomLabel.TextColor3 = Color3.fromRGB(200,200,200) CustomLabel.Font = Enum.Font.Gotham CustomLabel.TextSize = 8 CustomLabel.Text = "Loop" CustomLabel.TextXAlignment = Enum.TextXAlignment.Left CustomLabel.Parent = CustomLoopContainer

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-4,1,-95) Scroll.Position = UDim2.new(0,2,0,93) Scroll.CanvasSize = UDim2.new(0,0,0,0) Scroll.ScrollBarThickness = 4 Scroll.BackgroundTransparency = 1 Scroll.Parent = Page1
local List = Instance.new("UIListLayout") List.SortOrder = Enum.SortOrder.LayoutOrder List.Padding = UDim.new(0,3) List.Parent = Scroll-- ==================== 第二頁 Settings ====================
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

local HomelanderHintLabel = Instance.new("TextLabel")
HomelanderHintLabel.Size = UDim2.new(1, -10, 0, 14)
HomelanderHintLabel.Position = UDim2.new(0, 5, 0, 36)
HomelanderHintLabel.BackgroundTransparency = 1
HomelanderHintLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
HomelanderHintLabel.Font = Enum.Font.Gotham
HomelanderHintLabel.TextSize = 9
HomelanderHintLabel.Text = "Please use Homelander"
HomelanderHintLabel.TextXAlignment = Enum.TextXAlignment.Left
HomelanderHintLabel.Parent = Page2

local MoveModeBtn = Instance.new("TextButton")
MoveModeBtn.Size = UDim2.new(1, -10, 0, 20)
MoveModeBtn.Position = UDim2.new(0, 5, 0, 52)
MoveModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MoveModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveModeBtn.Font = Enum.Font.GothamBold
MoveModeBtn.TextSize = 10
MoveModeBtn.Text = "Move Skills Mode: Locked"
MoveModeBtn.TextScaled = true
MoveModeBtn.Parent = Page2
local MoveModeCorner = Instance.new("UICorner") MoveModeCorner.CornerRadius = UDim.new(0,4) MoveModeCorner.Parent = MoveModeBtn

local ResetPosBtn = Instance.new("TextButton")
ResetPosBtn.Size = UDim2.new(0.5, -8, 0, 20)
ResetPosBtn.Position = UDim2.new(0, 5, 0, 74)
ResetPosBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ResetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetPosBtn.Font = Enum.Font.GothamBold
ResetPosBtn.TextSize = 10
ResetPosBtn.Text = "Reset"
ResetPosBtn.Visible = false
ResetPosBtn.Parent = Page2
local ResetPosCorner = Instance.new("UICorner") ResetPosCorner.CornerRadius = UDim.new(0,4) ResetPosCorner.Parent = ResetPosBtn

local SavePosBtn = Instance.new("TextButton")
SavePosBtn.Size = UDim2.new(0.5, -8, 0, 20)
SavePosBtn.Position = UDim2.new(0.5, 3, 0, 74)
SavePosBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
SavePosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SavePosBtn.Font = Enum.Font.GothamBold
SavePosBtn.TextSize = 10
SavePosBtn.Text = "Save"
SavePosBtn.Visible = false
SavePosBtn.Parent = Page2
local SavePosCorner = Instance.new("UICorner") SavePosCorner.CornerRadius = UDim.new(0,4) SavePosCorner.Parent = SavePosBtn

local FlightToggleBtn = Instance.new("TextButton")
FlightToggleBtn.Size = UDim2.new(1, -10, 0, 20)
FlightToggleBtn.Position = UDim2.new(0, 5, 0, 98)
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
FlightLoadLabel.Position = UDim2.new(0, 5, 0, 120)
FlightLoadLabel.BackgroundTransparency = 1
FlightLoadLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FlightLoadLabel.Font = Enum.Font.Gotham
FlightLoadLabel.TextSize = 10
FlightLoadLabel.Text = "(Max load 20s)"
FlightLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
FlightLoadLabel.Parent = Page2

local SettingsFoldBtn = Instance.new("TextButton")
SettingsFoldBtn.Size = UDim2.new(1, -10, 0, 24)
SettingsFoldBtn.Position = UDim2.new(0, 5, 0, 138)
SettingsFoldBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsFoldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsFoldBtn.Font = Enum.Font.GothamBold
SettingsFoldBtn.TextSize = 12
SettingsFoldBtn.Text = "Settings ▼"
SettingsFoldBtn.Parent = Page2
local SettingsFoldCorner = Instance.new("UICorner") SettingsFoldCorner.CornerRadius = UDim.new(0,4) SettingsFoldCorner.Parent = SettingsFoldBtn

local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, -10, 0, 120)
SettingsContent.Position = UDim2.new(0, 5, 0, 164)
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
end)-- ==================== 浮動按鈕容器 ====================
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
LaserButton.Size = UDim2.new(0, 60, 0, 60)
LaserButton.Position = getSavedPosition("Laser", DEFAULT_POSITIONS.Laser)
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
UpthrowButton.Position = getSavedPosition("Upthrow", DEFAULT_POSITIONS.Upthrow)
UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
UpthrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpthrowButton.Font = Enum.Font.GothamBold
UpthrowButton.Text = "Upthrow"
UpthrowButton.Visible = false
applyButtonAutoScale(UpthrowButton)
UpthrowButton.Parent = FloatingGui
local UpthrowCorner = Instance.new("UICorner") UpthrowCorner.CornerRadius = UDim.new(0, 8) UpthrowCorner.Parent = UpthrowButton

local OverthrowButton = Instance.new("TextButton")
OverthrowButton.Size = UDim2.new(0, 60, 0, 60)
OverthrowButton.Position = getSavedPosition("Overthrow", DEFAULT_POSITIONS.Overthrow)
OverthrowButton.BackgroundColor3 = Color3.fromRGB(80, 50, 30)
OverthrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OverthrowButton.Font = Enum.Font.GothamBold
OverthrowButton.Text = "Overthrow"
OverthrowButton.Visible = false
applyButtonAutoScale(OverthrowButton)
OverthrowButton.Parent = FloatingGui
local OverthrowCorner = Instance.new("UICorner") OverthrowCorner.CornerRadius = UDim.new(0, 8) OverthrowCorner.Parent = OverthrowButton

local FlashstrikeButton = Instance.new("TextButton")
FlashstrikeButton.Size = UDim2.new(0, 60, 0, 60)
FlashstrikeButton.Position = getSavedPosition("Flashstrike", DEFAULT_POSITIONS.Flashstrike)
FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
FlashstrikeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlashstrikeButton.Font = Enum.Font.GothamBold
FlashstrikeButton.Text = "Flashstrike"
FlashstrikeButton.Visible = false
applyButtonAutoScale(FlashstrikeButton)
FlashstrikeButton.Parent = FloatingGui
local FlashstrikeCorner = Instance.new("UICorner") FlashstrikeCorner.CornerRadius = UDim.new(0, 8) FlashstrikeCorner.Parent = FlashstrikeButton-- ==================== 雷射眼邏輯 ====================
local laserActive = false
local laserThread = nil

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
	setLaserActive(not laserActive)
end)

-- Upthrow 邏輯
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

UpthrowButton.MouseButton1Click:Connect(function()
	local remote = findHomelanderThrowDownRemote()
	if remote then
		remote:FireServer()
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		task.wait(0.2)
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	else
		UpthrowButton.Text = "No Remote"
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		task.wait(0.5)
		UpthrowButton.Text = "Upthrow"
		UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	end
end)

-- Overthrow 邏輯
local function findVecnaOverheadThrowRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
		if folder:IsA("Folder") or folder:IsA("Model") then
			if folder.Name:lower():find("vecna") then
				local remotesFolder = folder:FindFirstChild("Remotes")
				if remotesFolder then
					for _, remote in ipairs(remotesFolder:GetChildren()) do
						if remote:IsA("RemoteEvent") and remote.Name:lower() == "overheadthrow" then
							return remote
						end
					end
				end
			end
		end
	end
	return nil
end

OverthrowButton.MouseButton1Click:Connect(function()
	local remote = findVecnaOverheadThrowRemote()
	if remote then
		remote:FireServer()
		OverthrowButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		task.wait(0.2)
		OverthrowButton.BackgroundColor3 = Color3.fromRGB(80, 50, 30)
	else
		OverthrowButton.Text = "No Remote"
		OverthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		task.wait(0.5)
		OverthrowButton.Text = "Overthrow"
		OverthrowButton.BackgroundColor3 = Color3.fromRGB(80, 50, 30)
	end
end)

-- Flashstrike 邏輯
local flashstrikeCooldown = 10
local flashstrikeCooldownActive = false

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
	if flashstrikeCooldownActive then return end
	local remote = findTheFlashCwFinalRemote()
	if remote then
		remote:FireServer()
		startFlashstrikeCooldown()
	else
		FlashstrikeButton.Text = "No Remote"
		FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		task.wait(0.5)
		FlashstrikeButton.Text = "Flashstrike"
		FlashstrikeButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
	end
end)-- ==================== Homelander Fly 執行邏輯 ====================
FlightToggleBtn.MouseButton1Click:Connect(function()
	if flightTask then return end
	flightTask = task.spawn(function()
		loadstring(game:HttpGet("https://obj.wearedevs.net/197198/scripts/invincible%20flight%20animation.lua"))()
	end)
	FlightToggleBtn.Text = "Homelander Fly (ON)"
	FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ==================== 浮動按鈕移動鎖定開關（Move Skills Mode） ====================
local moveUnlocked = false

local function updateMoveModeButton()
	if moveUnlocked then
		MoveModeBtn.Text = "Move Skills Mode: Unlocked"
		MoveModeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		ResetPosBtn.Visible = true
		SavePosBtn.Visible = true
	else
		MoveModeBtn.Text = "Move Skills Mode: Locked"
		MoveModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		ResetPosBtn.Visible = false
		SavePosBtn.Visible = false
	end
end

MoveModeBtn.MouseButton1Click:Connect(function()
	moveUnlocked = not moveUnlocked
	updateMoveModeButton()
end)

updateMoveModeButton()

-- Reset 位置
ResetPosBtn.MouseButton1Click:Connect(function()
	LaserButton.Position = DEFAULT_POSITIONS.Laser
	UpthrowButton.Position = DEFAULT_POSITIONS.Upthrow
	OverthrowButton.Position = DEFAULT_POSITIONS.Overthrow
	FlashstrikeButton.Position = DEFAULT_POSITIONS.Flashstrike
	LocalPlayer:SetAttribute("LaserPos", nil)
	LocalPlayer:SetAttribute("UpthrowPos", nil)
	LocalPlayer:SetAttribute("OverthrowPos", nil)
	LocalPlayer:SetAttribute("FlashstrikePos", nil)
end)

-- 儲存位置
SavePosBtn.MouseButton1Click:Connect(function()
	savePosition("Laser", LaserButton.Position)
	savePosition("Upthrow", UpthrowButton.Position)
	savePosition("Overthrow", OverthrowButton.Position)
	savePosition("Flashstrike", FlashstrikeButton.Position)
	SavePosBtn.Text = "Saved!"
	task.wait(1)
	SavePosBtn.Text = "Save"
end)

-- ==================== 浮動按鈕拖動邏輯 ====================
local laserDragging = false
local laserDragStart, laserStartPos

LaserButton.InputBegan:Connect(function(input)
	if not moveUnlocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		laserDragging = true
		laserDragStart = input.Position
		laserStartPos = LaserButton.Position
	end
end)

local upthrowDragging = false
local upthrowDragStart, upthrowStartPos

UpthrowButton.InputBegan:Connect(function(input)
	if not moveUnlocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		upthrowDragging = true
		upthrowDragStart = input.Position
		upthrowStartPos = UpthrowButton.Position
	end
end)

local overthrowDragging = false
local overthrowDragStart, overthrowStartPos

OverthrowButton.InputBegan:Connect(function(input)
	if not moveUnlocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		overthrowDragging = true
		overthrowDragStart = input.Position
		overthrowStartPos = OverthrowButton.Position
	end
end)

local flashstrikeDragging = false
local flashstrikeDragStart, flashstrikeStartPos

FlashstrikeButton.InputBegan:Connect(function(input)
	if not moveUnlocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		flashstrikeDragging = true
		flashstrikeDragStart = input.Position
		flashstrikeStartPos = FlashstrikeButton.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		laserDragging = false
		upthrowDragging = false
		overthrowDragging = false
		flashstrikeDragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if laserDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - laserDragStart
		LaserButton.Position = UDim2.new(
			laserStartPos.X.Scale,
			laserStartPos.X.Offset + delta.X,
			laserStartPos.Y.Scale,
			laserStartPos.Y.Offset + delta.Y
		)
	end
	if upthrowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - upthrowDragStart
		UpthrowButton.Position = UDim2.new(
			upthrowStartPos.X.Scale,
			upthrowStartPos.X.Offset + delta.X,
			upthrowStartPos.Y.Scale,
			upthrowStartPos.Y.Offset + delta.Y
		)
	end
	if overthrowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - overthrowDragStart
		OverthrowButton.Position = UDim2.new(
			overthrowStartPos.X.Scale,
			overthrowStartPos.X.Offset + delta.X,
			overthrowStartPos.Y.Scale,
			overthrowStartPos.Y.Offset + delta.Y
		)
	end
	if flashstrikeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - flashstrikeDragStart
		FlashstrikeButton.Position = UDim2.new(
			flashstrikeStartPos.X.Scale,
			flashstrikeStartPos.X.Offset + delta.X,
			flashstrikeStartPos.Y.Scale,
			flashstrikeStartPos.Y.Offset + delta.Y
		)
	end
end)-- Homelanders Mod 按鈕切換四個浮動按鈕可見性
local homelanderModActive = false
local function updateHomelanderModButton()
	if homelanderModActive then
		HomelanderModBtn.Text = "Cancel Mod"
		HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	else
		HomelanderModBtn.Text = "Homelanders Mod"
		HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
	end
end

HomelanderModBtn.MouseButton1Click:Connect(function()
	homelanderModActive = not homelanderModActive
	LaserButton.Visible = homelanderModActive
	UpthrowButton.Visible = homelanderModActive
	OverthrowButton.Visible = homelanderModActive
	FlashstrikeButton.Visible = homelanderModActive
	updateHomelanderModButton()
end)

updateHomelanderModButton()

-- ==================== UI Scale 滑條邏輯 ====================
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

-- ==================== Cancel Script 功能 ====================
local function CancelScript()
	loopInterval = 0
	isCustomLoopActive = false
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
	ScreenGui:Destroy()
	FloatingGui:Destroy()
end

CancelScriptBtn.MouseButton1Click:Connect(CancelScript)

-- ==================== 主菜單拖動與鎖定 ====================
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

-- ==================== Loop 邏輯 ====================
local loopInterval = 0 local isCustomLoopActive = false local currentLoopThread = nil

LoopToggle1.MouseButton1Click:Connect(function()
	if loopInterval == 1 and not isCustomLoopActive then loopInterval = 0 LoopToggle1.Text = ""
	else loopInterval = 1 isCustomLoopActive = false LoopToggle1.Text = "✓" CustomToggle.Text = "" end
end)
CustomToggle.MouseButton1Click:Connect(function()
	if isCustomLoopActive then isCustomLoopActive = false loopInterval = 0 CustomToggle.Text = ""
	else isCustomLoopActive = true local val = tonumber(CustomInput.Text) or 0.05 loopInterval = math.max(0.001, val) CustomToggle.Text = "✓" LoopToggle1.Text = "" end
end)
SubBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05 val = math.max(0.001, val - 0.01) CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then loopInterval = tonumber(CustomInput.Text) or 0.05 end
end)
AddBtn.MouseButton1Click:Connect(function()
	local val = tonumber(CustomInput.Text) or 0.05 val = val + 0.01 CustomInput.Text = string.format("%.3f", val):gsub("%.?0+$", "")
	if isCustomLoopActive then loopInterval = tonumber(CustomInput.Text) or 0.05 end
end)
CustomInput:GetPropertyChangedSignal("Text"):Connect(function()
	if isCustomLoopActive then local val = tonumber(CustomInput.Text) if val and val > 0 then loopInterval = val end end
end)

-- ==================== 刷新技能列表 ====================
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
						if loopInterval > 0 then
							if currentLoopThread then task.cancel(currentLoopThread) currentLoopThread = nil end
							local interval = loopInterval
							currentLoopThread = task.spawn(function() while loopInterval > 0 do data.remote:FireServer() task.wait(interval) end end)
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

RunService.RenderStepped:Connect(function()
	if ScreenGui.Enabled then UIS.MouseBehavior = Enum.MouseBehavior.Default UIS.MouseIconEnabled = true end
	if FloatingGui.Enabled then UIS.MouseBehavior = Enum.MouseBehavior.Default UIS.MouseIconEnabled = true end
end)
