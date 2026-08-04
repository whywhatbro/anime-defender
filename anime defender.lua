-- PART 1: AD STABLE MACRO EXECUTOR & STORAGE INTERFACE
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CONFIG_FILE = "AD_DaiTayTruong_V38_Config.json"
local MACRO_FILE = "AD_DaiTayTruong_MacroV38.json"

local macroData = {}
local isRecording = false
local isReplaying = false

local config = {
    autoUpgrade = false,
    autoSpeed = false,
    menuTextureId = "rbxassetid://0",
    toggleTextureId = "rbxassetid://0"
}

local function saveConfig()
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end end)
end
local function loadConfig()
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(saved) do config[k] = v end
        end
        if isfile and readfile and isfile(MACRO_FILE) then
            macroData = HttpService:JSONDecode(readfile(MACRO_FILE))
        end
    end)
end
loadConfig()

pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0,0)) end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DaiTayTruongAnimeDefendersV38"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end
-- PART 2: HARD-CODED INTERFACE & ALL FUNCTION BUTTONS PRESET
local ToggleMenuButton = Instance.new("ImageButton")
ToggleMenuButton.Size = UDim2.new(0, 55, 0, 55)
ToggleMenuButton.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
ToggleMenuButton.ZIndex = 10
ToggleMenuButton.Parent = ScreenGui
if config.toggleTextureId ~= "rbxassetid://0" then ToggleMenuButton.Image = config.toggleTextureId end
local UICornerBtn = Instance.new("UICorner") UICornerBtn.CornerRadius = UDim.new(0, 28) UICornerBtn.Parent = ToggleMenuButton

local tDragging, tDragInput, tDragStart, tStartPos
ToggleMenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = true tDragStart = input.Position tStartPos = ToggleMenuButton.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then tDragging = false end end)
    end
end)
ToggleMenuButton.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then tDragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == tDragInput and tDragging then
        local delta = input.Position - tDragStart
        ToggleMenuButton.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
    end
end)

local MainFrame = Instance.new("ImageLabel")
MainFrame.Size = UDim2.new(0, 540, 0, 240)
MainFrame.Position = UDim2.new(0.5, -270, 0.4, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 18)
MainFrame.Active = true
MainFrame.ScaleType = Enum.ScaleType.Slice
MainFrame.Parent = ScreenGui
if config.menuTextureId ~= "rbxassetid://0" then MainFrame.Image = config.menuTextureId end
local UICornerMain = Instance.new("UICorner") UICornerMain.CornerRadius = UDim.new(0, 10) UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 20, 55)
Title.BackgroundTransparency = 0.2
Title.Text = "FREE HACK BY ĐẠI TÀY TRƯỞNG - V38 MACRO RECORD"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame
local UICornerTitle = Instance.new("UICorner") UICornerTitle.CornerRadius = UDim.new(0, 10) UICornerTitle.Parent = Title

local LeftColumn = Instance.new("Frame") LeftColumn.Size = UDim2.new(0.46, 0, 0.8, 0) LeftColumn.Position = UDim2.new(0.02, 0, 0.18, 0) LeftColumn.BackgroundTransparency = 1 LeftColumn.Parent = MainFrame
local RightColumn = Instance.new("Frame") RightColumn.Size = UDim2.new(0.46, 0, 0.8, 0) RightColumn.Position = UDim2.new(0.52, 0, 0.18, 0) RightColumn.BackgroundTransparency = 1 RightColumn.Parent = MainFrame

local function createMenuButton(text, parent, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = parent
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 5) corner.Parent = btn
    return btn
end

local function createMenuTextBox(placeholder, parent, posY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 32)
    box.Position = UDim2.new(0, 0, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 12
    box.Parent = parent
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 5) corner.Parent = box
    return box
end

local RecordBtn = createMenuButton("🔴 Bắt Đầu Ghi (Record Map)", LeftColumn, 0, Color3.fromRGB(180, 20, 20))
local ReplayBtn = createMenuButton("▶️ Đặt Lại Vị Trí Cũ (Replay Macro)", LeftColumn, 40, Color3.fromRGB(0, 120, 200))
local AutoUpgradeBtn = createMenuButton("Auto Nâng Cấp (Upgrade): TẮT", LeftColumn, 80, Color3.fromRGB(200, 50, 50))
local AutoSpeedBtn = createMenuButton("Auto Bật Tốc Độ X3 Trận: TẮT", LeftColumn, 120, Color3.fromRGB(200, 50, 50))

local TextureBox = createMenuTextBox("Dán ID ảnh nền Menu...", RightColumn, 0)
local ToggleTextureBox = createMenuTextBox("Dán ID ảnh Nút Tròn...", RightColumn, 40)
local SaveCustomGuiBtn = createMenuButton("💾 Áp Dụng Hình Nền Mới", RightColumn, 80, Color3.fromRGB(140, 20, 180))
-- PART 3: ADVANCED HOOKING PLACEMENT EVENTS & MACRO EXECUTOR
local networkFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Network") or ReplicatedStorage:FindFirstChild("Remote")
local placeRemote = networkFolder and (networkFolder:FindFirstChild("PlaceTower") or networkFolder:FindFirstChild("SpawnUnit") or networkFolder:FindFirstChild("PlaceUnit"))

-- 1. THUẬT TOÁN TỰ ĐỘNG GHI (RECORD) TỌA ĐỘ THÁP KHI BẠN ĐẶT XUỐNG
if placeRemote and placeRemote:IsA("RemoteFunction") then
    local oldInvokeServer = placeRemote.InvokeServer
    placeRemote.InvokeServer = function(self, ...)
        local args = {...}
        if isRecording then
            local unitName = args[1]
            local cframeVal = args[2]
            if unitName and typeof(cframeVal) == "CFrame" then
                table.insert(macroData, {
                    name = unitName,
                    x = cframeVal.X,
                    y = cframeVal.Y,
                    z = cframeVal.Z
                })
                pcall(function() if writefile then writefile(MACRO_FILE, HttpService:JSONEncode(macroData)) end end)
                print("Đã ghi nhận tọa độ tháp: " .. unitName)
            end
        end
        return oldInvokeServer(self, ...)
    end
end

-- 2. THUẬT TOÁN TỰ ĐỘNG ĐẶT THÁP (REPLAY) THEO MỐC VỊ TRÍ CŨ TRẬN TRƯỚC
task.spawn(function()
    while task.wait(1.2) do
        if isReplaying and #macroData > 0 and placeRemote then
            for _, info in pairs(macroData) do
                if not isReplaying then break end
                local targetCFrame = CFrame.new(info.x, info.y, info.z)
                pcall(function()
                    placeRemote:InvokeServer(info.name, targetCFrame)
                end)
                task.wait(0.5) -- Nhịp trễ an toàn chống anti-cheat
            end
        end
    end
end)

-- Vòng lặp bổ trợ Auto Upgrade và Auto Speed X3
task.spawn(function()
    while task.wait(1.5) do
        if networkFolder then
            if config.autoSpeed then
                local speedRemote = networkFolder:FindFirstChild("ChangeSpeed") or networkFolder:FindFirstChild("ToggleVoteSpeed")
                if speedRemote then speedRemote:FireServer(true) end
            end
            if config.autoUpgrade then
                local upgradeRemote = networkFolder:FindFirstChild("UpgradeTower") or networkFolder:FindFirstChild("UpgradeUnit")
                local activeUnits = Workspace:FindFirstChild("PlacedTowers") or Workspace:FindFirstChild("Units")
                if upgradeRemote and activeUnits then
                    for _, tower in pairs(activeUnits:GetChildren()) do
                        if config.autoUpgrade and tower:FindFirstChild("Owner") and tower.Owner.Value == Player.Name then
                            upgradeRemote:InvokeServer(tower) task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)

SaveCustomGuiBtn.MouseButton1Click:Connect(function()
    local id = tonumber(TextureBox.Text) if id then MainFrame.Image = "rbxassetid://" .. id config.menuTextureId = "rbxassetid://" .. id saveConfig() end
    local btnId = tonumber(ToggleTextureBox.Text) if btnId then ToggleMenuButton.Image = "rbxassetid://" .. btnId config.toggleTextureId = "rbxassetid://" .. btnId saveConfig() end
end)

local function refreshVisuals()
    RecordBtn.Text = isRecording and "⏸️ Đang Ghi Thao Tác Vị Trí..." or "🔴 Bắt Đầu Ghi (Record Map)"
    RecordBtn.BackgroundColor3 = isRecording and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 20, 20)
    
    ReplayBtn.Text = isReplaying and "⏸️ Đang Tự Động Thả Units..." or "▶️ Đặt Lại Vị Trí Cũ (Replay Macro)"
    ReplayBtn.BackgroundColor3 = isReplaying and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(0, 120, 200)
    
    AutoUpgradeBtn.Text = config.autoUpgrade and "Auto Nâng Cấp: BẬT" or "Auto Nâng Cấp: TẮT"
    AutoUpgradeBtn.BackgroundColor3 = config.autoUpgrade and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AutoSpeedBtn.Text = config.autoSpeed and "Auto Bật Tốc Độ X3: BẬT" or "Auto Bật Tốc Độ X3: TẮT"
    AutoSpeedBtn.BackgroundColor3 = config.autoSpeed and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
end

RecordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then macroData = {} pcall(function() if delfile then delfile(MACRO_FILE) end end) end
    refreshVisuals()
end)

ReplayBtn.MouseButton1Click:Connect(function() isReplaying = not isReplaying refreshVisuals() end)
AutoUpgradeBtn.MouseButton1Click:Connect(function() config.autoUpgrade = not config.autoUpgrade saveConfig() refreshVisuals() end)
AutoSpeedBtn.MouseButton1Click:Connect(function() config.autoSpeed = not config.autoSpeed saveConfig() refreshVisuals() end)

ToggleMenuButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

refreshVisuals()
print("free hack by dai tay truong V38 Macro Engine Completed!")
