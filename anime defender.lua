-- PART 1: STRIKE REPLICATED SERVICES, VARIABLES & RE-CODED ANTI-AFK Core
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CONFIG_FILE = "AD_DaiTayTruong_V45_Config.json"
local config = {
    autoPlace = false,
    autoUpgrade = false,
    autoSpeed = false,
    autoLoop = false,
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
    end)
end
loadConfig()

-- ANTI-AFK CẤP PHẦN CỨNG GIÚP TREO MÁY QUA ĐÊM KHÔNG BỊ DISCONNECT
pcall(function()
    Player.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DaiTayTruongStrikeEditionV45"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end
-- PART 2: UI BUTTON LAYOUT & DRAGGABLE TOGGLE PRESETS
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
Title.Text = "FREE HACK BY ĐẠI TÀY TRƯỞNG - STRIKE HUB CORE V45"
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

local AutoPlaceBtn = createMenuButton("Smart Auto Place (Đặt Tháp): TẮT", LeftColumn, 0, Color3.fromRGB(200, 50, 50))
local AutoUpgradeBtn = createMenuButton("Smart Auto Upgrade (Nâng Cấp): TẮT", LeftColumn, 40, Color3.fromRGB(200, 50, 50))
local AutoSpeedBtn = createMenuButton("Auto Speed X3 Tốc Độ Trận: TẮT", LeftColumn, 80, Color3.fromRGB(200, 50, 50))
local AutoLoopBtn = createMenuButton("Auto Loop Match (Cày Vòng Lặp): TẮT", LeftColumn, 120, Color3.fromRGB(200, 50, 50))

local TextureBox = createMenuTextBox("Dán ID ảnh nền Menu...", RightColumn, 0)
local ToggleTextureBox = createMenuTextBox("Dán ID ảnh Nút Tròn...", RightColumn, 40)
local SaveCustomGuiBtn = createMenuButton("💾 Áp Dụng Hình Nền Mới", RightColumn, 80, Color3.fromRGB(140, 20, 180))
-- PART 3: ADVANCED DETECTORS FOR PLACEMENTS & UPGRADES BYPASS
local networkFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Network") or ReplicatedStorage:FindFirstChild("Remote")

local function getUnitsFolder()
    return Workspace:FindFirstChild("PlacedTowers") or Workspace:FindFirstChild("Units") or Workspace:FindFirstChild("Towers")
end

-- 1. THUẬT TOÁN TỰ ĐỘNG DÒ Ô TRỐNG ĐỂ ĐẶT THÁP (SMART AUTO PLACE)
task.spawn(function()
    while task.wait(1) do
        if config.autoPlace and networkFolder then
            local placeRemote = networkFolder:FindFirstChild("PlaceTower") or networkFolder:FindFirstChild("SpawnUnit") or networkFolder:FindFirstChild("PlaceUnit")
            local map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("ActiveMap")
            
            if placeRemote and map then
                -- Quét lấy tên Unit đầu tiên có sẵn trong túi đồ của người chơi
                local bag = Player:FindFirstChild("Bag") or Player:FindFirstChild("Inventory")
                local targetUnit = "Gojo"
                if bag and #bag:GetChildren() > 0 then targetUnit = bag:GetChildren()[1].Name end
                
                -- Tìm kiếm các ô đất hợp pháp (Placeholders) trên bản đồ hiện tại
                local placeholders = map:FindFirstChild("Placeholders") or map:FindFirstChild("Ground") or map:FindFirstChild("Grass")
                if placeholders then
                    for _, slot in pairs(placeholders:GetChildren()) do
                        if config.autoPlace and slot:IsA("BasePart") and not slot:FindFirstChild("V45Occupied") then
                            -- Gửi sóng dữ liệu ép đập tháp thành công
                            placeRemote:InvokeServer(targetUnit, slot.CFrame)
                            
                            -- Ghim nhãn đánh dấu ô đất này đã có tháp, không đặt đè tháp khác lên
                            local tag = Instance.new("BoolValue", slot) tag.Name = "V45Occupied"
                            task.wait(0.4)
                        end
                    end
                end
            end
        end
    end
end)

-- 2. THUẬT TOÁN TỰ ĐỘNG NÂNG CẤP THÁP KHI ĐỦ TIỀN TRẬN ĐẤU (SMART AUTO UPGRADE)
task.spawn(function()
    while task.wait(1) do
        if config.autoUpgrade and networkFolder then
            local upgradeRemote = networkFolder:FindFirstChild("UpgradeTower") or networkFolder:FindFirstChild("UpgradeUnit")
            local activeUnits = getUnitsFolder()
            
            if upgradeRemote and activeUnits then
                for _, tower in pairs(activeUnits:GetChildren()) do
                    -- Xác thực tháp đó thuộc quyền sở hữu của bạn thì mới gửi lệnh nâng cấp liên tục
                    if config.autoUpgrade and tower:FindFirstChild("Owner") and tower.Owner.Value == Player.Name then
                        upgradeRemote:InvokeServer(tower)
                        task.wait(0.15) -- Tốc độ nâng cấp thần tốc tối ưu
                    end
                end
            end
        end
    end
end)
-- PART 4: LOBBY VÒNG LẶP ENGINE, TELEPORT BUTTON RECOVERY & VISUAL SYNC
task.spawn(function()
    while task.wait(1.5) do
        if networkFolder then
            -- Tự động bật tốc độ X3 trận đấu
            if config.autoSpeed then
                local speedRemote = networkFolder:FindFirstChild("ChangeSpeed") or networkFolder:FindFirstChild("ToggleVoteSpeed") or networkFolder:FindFirstChild("VoteSpeed")
                if speedRemote then speedRemote:FireServer(true) end
            end
            
            -- VÒNG LẶP LẶP TRẬN ĐẤU VĨNH CỬU KHI KẾT THÚC MÀN
            if config.autoLoop then
                -- Tự động gửi lệnh Sẵn sàng/Vào phòng đấu từ sảnh chính
                local startRemote = networkFolder:FindFirstChild("StartGame") or networkFolder:FindFirstChild("ReadyMatch") or networkFolder:FindFirstChild("TeleportToStory")
                if startRemote then startRemote:FireServer() end
                
                -- Tự động bấm nút Chơi Lại (Play Again / Replay)
                local replayRemote = networkFolder:FindFirstChild("ReplayMatch") or networkFolder:FindFirstChild("PlayAgain")
                if replayRemote then replayRemote:FireServer() end
                
                -- Tự động nhận quà và Thoát trận (Leave) ra sảnh khi phát hiện trận đấu kết thúc
                local claimRemote = networkFolder:FindFirstChild("ClaimRewards") or networkFolder:FindFirstChild("ClaimMatch") or networkFolder:FindFirstChild("LeaveMatch")
                if claimRemote then claimRemote:FireServer() end
            end
        end
    end
end)

SaveCustomGuiBtn.MouseButton1Click:Connect(function()
    local id = tonumber(TextureBox.Text) if id then MainFrame.Image = "rbxassetid://" .. id config.menuTextureId = "rbxassetid://" .. id saveConfig() end
    local btnId = tonumber(ToggleTextureBox.Text) if btnId then ToggleMenuButton.Image = "rbxassetid://" .. btnId config.toggleTextureId = "rbxassetid://" .. btnId saveConfig() end
end)

local function refreshVisuals()
    AutoPlaceBtn.Text = config.autoPlace and "Smart Auto Place: BẬT" or "Smart Auto Place: TẮT"
    AutoPlaceBtn.BackgroundColor3 = config.autoPlace and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AutoUpgradeBtn.Text = config.autoUpgrade and "Smart Auto Upgrade: BẬT" or "Smart Auto Upgrade: TẮT"
    AutoUpgradeBtn.BackgroundColor3 = config.autoUpgrade and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AutoSpeedBtn.Text = config.autoSpeed and "Auto Speed X3: BẬT" or "Auto Speed X3: TẮT"
    AutoSpeedBtn.BackgroundColor3 = config.autoSpeed and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    
    AutoLoopBtn.Text = config.autoLoop and "Auto Loop Match: BẬT" or "Auto Loop Match: TẮT"
    AutoLoopBtn.BackgroundColor3 = config.autoLoop and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
end

AutoPlaceBtn.MouseButton1Click:Connect(function() config.autoPlace = not config.autoPlace saveConfig() refreshVisuals() end)
AutoUpgradeBtn.MouseButton1Click:Connect(function() config.autoUpgrade = not config.autoUpgrade saveConfig() refreshVisuals() end)
AutoSpeedBtn.MouseButton1Click:Connect(function() config.autoSpeed = not config.autoSpeed saveConfig() refreshVisuals() end)
AutoLoopBtn.MouseButton1Click:Connect(function() config.autoLoop = not config.autoLoop saveConfig() refreshVisuals() end)

ToggleMenuButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = MainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
MainFrame.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

refreshVisuals()
print("free hack by dai tay truong V45 Strike Core Loaded successfully!")
