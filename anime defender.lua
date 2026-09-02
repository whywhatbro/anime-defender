-- Load giao diện Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "📦 AD Bulk Booth",
   LoadingTitle = "Hệ thống đăng bán hàng loạt...",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local Tab = Window:CreateTab("Đăng Bán Hàng Loạt", nil)

-- Biến lưu dữ liệu
local targetName = ""
local targetPrice = 100
local listQuantity = 1

Tab:CreateInput({
   Name = "Tên Vật Phẩm / Unit",
   PlaceholderText = "Nhập chính xác tên (VD: Star Shard)...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) targetName = Text end,
})

Tab:CreateSlider({
   Name = "Giá mỗi món (Emeralds)",
   Range = {1, 10000},
   Increment = 1,
   Suffix = " Emeralds",
   CurrentValue = 100,
   Flag = "SetPrice",
   Callback = function(Value) targetPrice = Value end,
})

Tab:CreateSlider({
   Name = "Số lượng muốn đăng cùng lúc",
   Range = {1, 10}, -- Booth trong game thường có tối đa 10 ô
   Increment = 1,
   Suffix = " Ô",
   CurrentValue = 1,
   Flag = "SetQuantity",
   Callback = function(Value) listQuantity = Value end,
})

Tab:CreateButton({
   Name = "🚀 Thực Hiện Đăng Bán",
   Callback = function()
       -- Chạy ngầm để không làm đơ game
       task.spawn(function()
           for i = 1, listQuantity do
               pcall(function()
                   -- ❌ THAY MÃ REMOTE ĐĂNG BÁN VÀO DÒNG BÊN DƯỚI ❌
                   -- Ví dụ: game:GetService("ReplicatedStorage").RemoteEvent:FireServer("List", targetName, targetPrice)
               end)
               
               -- Nghỉ 0.5 giây giữa mỗi lần ném đồ lên booth để không bị game kick vì spam
               task.wait(0.5) 
           end
           
           Rayfield:Notify({
               Title = "Thành công",
               Content = "Đã đưa " .. listQuantity .. " " .. targetName .. " lên gian hàng.",
               Duration = 4
           })
       end)
   end,
})
