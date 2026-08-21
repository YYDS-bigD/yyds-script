local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- 清理舊 GUI
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

-- 飛行外部腳本任務
local flightTask = nil

-- 預設技能按鈕位置
local DEFAULT_POSITIONS = {
	Laser = UDim2.new(1, -240, 0.5, -30),
	Upthrow = UDim2.new(1, -310, 0.5, -30),
	Overthrow = UDim2.new(1, -310, 0.5, 40),
	Flashstrike = UDim2.new(1, -310, 0.5, -110)
}

-- 讀取保存的位置
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

-- 儲存位置
local function savePosition(buttonName, pos)
	LocalPlayer:SetAttribute(buttonName .. "Pos", string.format("%.4f,%.0f,%.4f,%.0f", pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset))
end

-- ==================== 主菜單 GUI ====================
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

-- 最小化圖標
local MinimizeIcon = Instance.new("ImageButton")
MinimizeIcon.Name = "MinimizeIcon" MinimizeIcon.Size = UDim2.new(0,60,0,60) MinimizeIcon.Position = UDim2.new(0,12,0.10,0)
MinimizeIcon.BackgroundTransparency = 1 MinimizeIcon.Image = "rbxassetid://90728112297914" MinimizeIcon.ScaleType = Enum.ScaleType.Fit MinimizeIcon.AutoButtonColor = false MinimizeIcon.Visible = false MinimizeIcon.ZIndex = 20 MinimizeIcon.Parent = ScreenGui
local IconCorner = Instance.new("UICorner") IconCorner.CornerRadius = UDim.new(0,12) IconCorner.Parent = MinimizeIcon

MinusBtn.MouseButton1Click:Connect(function() Main.Visible = false MinimizeIcon.Visible = true end)
MinimizeIcon.MouseButton1Click:Connect(function() Main.Visible = true MinimizeIcon.Visible = false end)

-- 最小化圖標拖動
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

-- 頁籤
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

-- ==================== 第一頁 Scanner ====================
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
local List = Instance.new("UIListLayout") List.SortOrder = Enum.SortOrder.LayoutOrder List.Padding = UDim.new(0,3) List.Parent = Scroll

-- ==================== 第二頁 Settings ====================
-- Homelanders Mod 按鈕
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

-- 提示文字
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

-- Move Skills Mode 按鈕
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

-- Reset 與 Save 按鈕（預設隱藏，解鎖時顯示）
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

-- Homelander Fly 按鈕（位置下移）
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

-- 加載時間標籤
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

-- Settings 折疊按鈕
local SettingsFoldBtn = Instance.new("TextButton")
SettingsFoldBtn.Size = UDim2.new(1, -10, 0, 24)
SettingsFoldBtn.Position = UDim2.new(0, 5, 0, 138)
SettingsFoldBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsFoldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsFoldBtn.Font = Enum.Font.GothamBold
SettingsFoldBtn.TextSize = 12
SettingsFoldBtn.Text = "Settings ▼"
SettingsFoldBtn.Parent = Page2
local SettingsFoldCorner = Instance.new("UICorner") SettingsFo
