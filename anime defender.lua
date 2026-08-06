local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetParent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- 1. KHỞI TẠO HỆ THỐNG GIAO DIỆN CHÍNH (V2)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AD_V2_Framework"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false

-- Nút khởi động tròn (Floating Action Button)
local MainToggle = Instance.new("TextButton")
local CornerToggle = Instance.new("UICorner")
local StrokeToggle = Instance.new("UIStroke")

MainToggle.Size = UDim2.new(0, 55, 0, 55)
MainToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
MainToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainToggle.Text = "⚡"
MainToggle.TextSize = 24
MainToggle.TextColor3 = Color3.fromRGB(0, 255, 200)
MainToggle.ZIndex = 10
MainToggle.Parent = ScreenGui

CornerToggle.CornerRadius = UDim.new(1, 0)
CornerToggle.Parent = MainToggle
StrokeToggle.Color = Color3.fromRGB(0, 255, 200)
StrokeToggle.Thickness = 2
StrokeToggle.Parent = MainToggle

-- Khung Menu V2 (Bảng điều khiển chính)
local MainFrame = Instance.new("Frame")
local CornerMain = Instance.new("UICorner")
local StrokeMain = Instance.new("UIStroke")
local TabContainer = Instance.new("Frame")
local ContentContainer = Instance.new("Frame")
local UIPOngan = Instance.new("UIListLayout")

MainFrame.Size = UDim2.new(0, 0, 0, 220) -- Hiệu ứng mở rộng chiều ngang
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

CornerMain.CornerRadius = UDim.new(0, 10)
CornerMain.Parent = MainFrame
StrokeMain.Color = Color3.fromRGB(40, 40, 55)
StrokeMain.Parent = MainFrame

-- Thanh chứa các Tab phân loại
TabContainer.Size = UDim2.new(0, 100, 1, 0)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TabContainer.Parent = MainFrame

UIPOngan.FillDirection = Enum.FillDirection.Vertical
UIPOngan.Padding = UDim.new(0, 5)
UIPOngan.Parent = TabContainer

-- Khung chứa nội dung của từng Tab
ContentContainer.Size = UDim2.new(1, -110, 1, -10)
ContentContainer.Position = UDim2.new(0, 105, 0, 5)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- 2. HỆ THỐNG QUẢN LÝ TAB VÀ NỘI DUNG (TAB SYSTEM)
local tabs = {}
local activeTab = nil

local function CreateTab(tabName, order)
    local tabBtn = Instance.new("TextButton")
    local tabCorner = Instance.new("UICorner")
    
    tabBtn.Size = UDim2.new(1, -10, 0, 35)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 14
    tabBtn.Parent = TabContainer
    
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    page.Visible = false
    page.Parent = ContentContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page
    
    tabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            activeTab.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            activeTab.Btn.TextColor3 = Color3.fromRGB(150, 150, 160)
            activeTab.Page.Visible = false
        end
        activeTab = {Btn = tabBtn, Page = page}
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        tabBtn.TextColor3 = Color3.fromRGB(15, 15, 22)
        page.Visible = true
    end)
    
    return page
end

-- Khởi tạo các trang Tab chuyên dụng
local Page_Main = CreateTab("Trận Đấu", 1)
local Page_Macro = CreateTab("Tự Động", 2)
local Page_Settings = CreateTab("Cài Đặt", 3)

-- 3. HÀM TẠO CÁC NÚT TÍNH NĂNG CAO CẤP (V2 COMPONENTS)
local function AddToggle(parentPage, text, callback)
    local toggleFrame = Instance.new("Frame")
    local toggleBtn = Instance.new("TextButton")
    local toggleLabel = Instance.new("TextLabel")
    local btnCorner = Instance.new("UICorner")
    
    toggleFrame.Size = UDim2.new(1, -10, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parentPage
    
    toggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 16
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Parent = toggleFrame
    
    toggleBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggleBtn.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleBtn.Text = "TẮT"
    toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = toggleFrame
    
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 200), TextColor3 = Color3.fromRGB(15, 15, 22)}):Play()
            toggleBtn.Text = "BẬT"
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            toggleBtn.Text = "TẮT"
        end
        callback(state)
    end)
end

-- 4. TÍCH HỢP LOGIC ĐIỀU KHIỂN HỢP PHÁP
AddToggle(Page_Main, "Tự động Chơi lại / Tiếp tục", function(state)
    _G.AutoPlay = state
    print("Trạng thái Auto Play:", state)
end)

AddToggle(Page_Macro, "Chống ngắt kết nối (Anti-AFK)", function(state)
    _G.AntiAFK = state
    print("Trạng thái Anti-AFK V2:", state)
end)

AddToggle(Page_Settings, "Lưu cấu hình tự động", function(state)
    print("Tính năng lưu dữ liệu cấu hình đám mây:", state)
end)

-- Kích hoạt Tab đầu tiên mặc định
TabContainer:GetChildren()[2]:Click() -- Tự động chọn Tab "Trận Đấu" khi mở

-- 5. LOGIC DRAGGABLE & TWEEN OPEN MƯỢT MÀ
local isOpen = false
MainToggle.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 220)}):Play()
    else
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 220)})
        t:Play()
        t.Completed:Connect(function() if not isOpen then MainFrame.Visible = false end end)
    end
end)

-- Đồng bộ vị trí kéo thả cho nút di động
local dragStart, startPos, dragging
MainToggle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = MainToggle.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        MainToggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = UDim2.new(MainToggle.Position.X.Scale, MainToggle.Position.X.Offset + 65, MainToggle.Position.Y.Scale, MainToggle.Position.Y.Offset)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
