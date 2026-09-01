-- Load giao diện Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "📦 AD Auto Booth",
   LoadingTitle = "Tải hệ thống quản lý Booth...",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local Tab = Window:CreateTab("Tự Động", nil)

-- Biến lưu trữ dữ liệu
local isAutoListing = false
local isAutoDelisting = false
local targetItemName = "Star Shard (Yellow)"
local targetPrice = 100

Tab:CreateParagraph({
    Title = "⚠️ LƯU Ý QUAN TRỌNG",
    Content = "Hãy bật SimpleSpy, tự đăng bán/hủy bán 1 lần bằng tay để lấy đường dẫn Remote, sau đó dán vào code để script có thể chạy thật."
})

Tab:CreateSection("Cài đặt vật phẩm")

Tab:CreateInput({
   Name = "Tên Vật Phẩm (Chính xác)",
   PlaceholderText = "Ví dụ: Star Shard (Yellow)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) targetItemName = Text end,
})

Tab:CreateSlider({
   Name = "Giá Emeralds",
   Range = {1, 10000},
   Increment = 1,
   Suffix = " Emeralds",
   CurrentValue = 100,
   Flag = "SetPrice",
   Callback = function(Value) targetPrice = Value end,
})

Tab:CreateSection("Chức năng tự động")

-- 1. CHỨC NĂNG TỰ ĐĂNG BÁN (AUTO LIST)
Tab:CreateToggle({
   Name = "BẬT Tự Động Đăng Bán",
   CurrentValue = false,
   Flag = "AutoList",
   Callback = function(Value)
       isAutoListing = Value
       if isAutoListing then
           task.spawn(function()
               while isAutoListing do
                   task.wait(2) -- Thời gian delay giữa mỗi lần đăng (chỉnh số này nếu muốn nhanh/chậm)
                   pcall(function()
                       
                       -- ❌ THAY MÃ REMOTE ĐĂNG BÁN CỦA GAME VÀO DÒNG BÊN DƯỚI ❌
                       -- Ví dụ cấu trúc chuẩn: game:GetService("ReplicatedStorage").RemoteEvent:FireServer("List", targetItemName, targetPrice)
                       
                   end)
               end
           end)
       end
   end,
})

-- 2. CHỨC NĂNG TỰ HỦY BÁN (AUTO DELIST)
Tab:CreateToggle({
   Name = "BẬT Tự Động Hủy Bán",
   CurrentValue = false,
   Flag = "AutoDelist",
   Callback = function(Value)
       isAutoDelisting = Value
       if isAutoDelisting then
           task.spawn(function()
               while isAutoDelisting do
                   task.wait(2)
                   pcall(function()
                       
                       -- ❌ THAY MÃ REMOTE HỦY BÁN CỦA GAME VÀO DÒNG BÊN DƯỚI ❌
                       -- Ví dụ cấu trúc chuẩn: game:GetService("ReplicatedStorage").RemoteEvent:FireServer("Unlist", targetItemName)
                       
                   end)
               end
           end)
       end
   end,
})
