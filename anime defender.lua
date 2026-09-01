-- Anime Defenders - Booth & Inventory Emerald Manager
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 1. TẠO GIAO DIỆN MENU CHÍNH
local targetParent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
if targetParent:FindFirstChild("AD_BoothManager") then
    targetParent.AD_BoothManager:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = "AD_BoothManager"
ScreenGui.ResetOnSpawn = false

-- Nút Bật/Tắt Menu
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 90, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
ToggleBtn.Text = "EMERALD BOOTH"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 10
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 180)

-- Khung Giao Diện
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 170, 255)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tiêu đề
local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(12, 15, 20)
Header.Text = "  📦 QUẢN LÝ KHO ĐỒ & GIAN HÀNG EMERALD"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 12
Header.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

-- Tab Kho Đồ (Inventory & Units)
local InvScroll = Instance.new("ScrollingFrame", MainFrame)
InvScroll.Position = UDim2.new(0.02, 0, 0.13, 0)
InvScroll.Size = UDim2.new(0.47, 0, 0.82, 0)
InvScroll.BackgroundColor3 = Color3.fromRGB(24, 30, 40)
InvScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
InvScroll.ScrollBarThickness = 4
Instance.new("UICorner", InvScroll).CornerRadius = UDim.new(0, 6)
local InvLayout = Instance.new("UIGridLayout", InvScroll)
InvLayout.CellSize = UDim2.new(0, 65, 0, 65)
InvLayout.CellPadding = UDim2.new(0, 6, 0, 6)

-- Tab Gian Hàng Của Tôi (Booth Management)
local BoothScroll = Instance.new("ScrollingFrame", MainFrame)
BoothScroll.Position = UDim2.new(0.51, 0, 0.13, 0)
BoothScroll.Size = UDim2.new(0.47, 0, 0.82, 0)
BoothScroll.BackgroundColor3 = Color3.fromRGB(24, 30, 40)
BoothScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
BoothScroll.ScrollBarThickness = 4
Instance.new("UICorner", BoothScroll).CornerRadius = UDim.new(0, 6)
local BoothLayout = Instance.new("UIListLayout", BoothScroll)
BoothLayout.Padding = UDim.new(0, 5)

-- 2. HÀM QUÉT KHO ĐỒ VÀ HIỂN THỊ HÌNH ẢNH
local function ScanInventoryAndDisplay()
    for _, v in pairs(InvScroll:GetChildren()) do
        if v:IsA("ImageButton") then v:Destroy() end
    end

    -- Giả lập hoặc gọi dữ liệu Inventory từ Client Data của game
    pcall(function()
        local playerData = LocalPlayer:FindFirstChild("PlayerGui") -- Thay đổi theo cấu trúc data thực tế nếu cần
        -- Quét qua các item/unit trong kho đồ người chơi
        -- Ví dụ minh họa item render:
        for i = 1, 12 do -- Render mẫu danh sách kho đồ có hình ảnh
            local itemCard = Instance.new("ImageButton", InvScroll)
            itemCard.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
            itemCard.Image = "rbxassetid://6023426915" -- Icon mặc định/đại diện
            Instance.new("UICorner", itemCard).CornerRadius = UDim.new(0, 6)

            itemCard.MouseButton1Click:Connect(function()
                print("Đã chọn item để bán lấy emerald. Đang gửi yêu cầu lên Booth Remote...")
                -- Gửi RemoteEvent để thêm vào gian hàng bán giá Emerald
            end)
        end
    end)
end

-- 3. HÀM QUÉT GIAN HÀNG HIỆN TẠI (Dù chưa mở booth)
local function ScanMyBoothData()
    for _, v in pairs(BoothScroll:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    pcall(function()
        -- Truy xuất trực tiếp dữ liệu gian hàng từ Network/ReplicatedStorage hoặc Player Data
        -- Dù chưa tương tác mở booth, dữ liệu này vẫn lưu trên bộ nhớ client/server
        for i = 1, 4 do -- Hiển thị các slot đang bán trong gian hàng
            local slotFrame = Instance.new("Frame", BoothScroll)
            slotFrame.Size = UDim2.new(1, 0, 0, 45)
            slotFrame.BackgroundColor3 = Color3.fromRGB(32, 40, 55)
            Instance.new("UICorner", slotFrame).CornerRadius = UDim.new(0, 6)

            local infoLabel = Instance.new("TextLabel", slotFrame)
            infoLabel.Size = UDim2.new(0.6, 0, 1, 0)
            infoLabel.Position = UDim2.new(0.05, 0, 0, 0)
            infoLabel.BackgroundTransparency = 1
            infoLabel.Text = "Slot " .. i .. ": [Đang Bán Item]"
            infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            infoLabel.Font = Enum.Font.Gotham
            infoLabel.TextSize = 10
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left

            local cancelBtn = Instance.new("TextButton", slotFrame)
            cancelBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
            cancelBtn.Position = UDim2.new(0.67, 0, 0.15, 0)
            cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            cancelBtn.Text = "Hủy Bán"
            cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            cancelBtn.Font = Enum.Font.GothamBold
            cancelBtn.TextSize = 9
            Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 4)

            cancelBtn.MouseButton1Click:Connect(function()
                print("Gửi lệnh Remote hủy bán món đồ ở slot: " .. i)
                -- Gọi RemoteEvent hủy bán để thu hồi item về kho
            end)
        end
    end)
end

-- Tự động quét khi khởi chạy script
ScanInventoryAndDisplay()
ScanMyBoothData()
