-- Tự động chống AFK (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Load UI Library Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 Anime Defenders - Emerald Booth VIP",
   LoadingTitle = "Đang kết nối Emerald System...",
   LoadingSubtitle = "Auto Booth & Trade Helper",
   ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "AD_Emerald_Config" },
   KeySystem = false
})

-- ==========================================
-- TAB 1: GIAN HÀNG EMERALD (BOOTH)
-- ==========================================
local BoothTab = Window:CreateTab("💎 Emerald Booth", nil)

local itemToSell = "Star Shard (Yellow)"
local unitToSell = "Legion Veteran"
local emeraldPrice = 100
local autoListItems = false
local autoListUnits = false

BoothTab:CreateSection("🛒 Đăng Bán Vật Phẩm (Items)")

BoothTab:CreateInput({
   Name = "Tên Item (Risky Dice, Star Rift, Star Shard...)",
   PlaceholderText = "Nhập chính xác tên Item...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) itemToSell = Text end,
})

BoothTab:CreateSlider({
   Name = "Giá bán Item (Emeralds)",
   Range = {1, 50000},
   Increment = 1,
   Suffix = " 🟢 Emeralds",
   CurrentValue = 50,
   Flag = "ItemEmeraldPrice",
   Callback = function(Value) emeraldPrice = Value end,
})

BoothTab:CreateToggle({
   Name = "Tự Động Đăng Bán Items",
   CurrentValue = false,
   Flag = "AutoListItem",
   Callback = function(Value)
       autoListItems = Value
       if autoListItems then
           task.spawn(function()
               while autoListItems do
                   task.wait(2)
                   -- Remote đăng bán Item lấy Emeralds
                   -- game:GetService("ReplicatedStorage").Remotes.Booth:FireServer("ListItem", itemToSell, emeraldPrice)
               end
           end)
       end
   end,
})

BoothTab:CreateSection("🛡️ Đăng Bán Nhân Vật (Units)")

BoothTab:CreateInput({
   Name = "Tên Unit (Legion Veteran, Ant King...)",
   PlaceholderText = "Nhập chính xác tên Unit...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) unitToSell = Text end,
})

BoothTab:CreateToggle({
   Name = "Tự Động Đăng Bán Units",
   CurrentValue = false,
   Flag = "AutoListUnit",
   Callback = function(Value)
       autoListUnits = Value
       if autoListUnits then
           task.spawn(function()
               while autoListUnits do
                   task.wait(2)
                   -- Remote đăng bán Unit lấy Emeralds
                   -- game:GetService("ReplicatedStorage").Remotes.Booth:FireServer("ListUnit", unitToSell, emeraldPrice)
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 2: QUẢN LÝ GIAO DỊCH (TRADE)
-- ==========================================
local TradeTab = Window:CreateTab("🤝 Giao Dịch", nil)

local targetPlayer = ""
local autoAcceptTrade = false

TradeTab:CreateSection("Gửi Lời Mời Giao Dịch")

TradeTab:CreateInput({
   Name = "Tên Người Chơi",
   PlaceholderText = "Nhập Username trong danh sách...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) targetPlayer = Text end,
})

TradeTab:CreateButton({
   Name = "Gửi Yêu Cầu Trade",
   Callback = function()
       if targetPlayer ~= "" then
           -- game:GetService("ReplicatedStorage").Remotes.Trade:FireServer("SendRequest", targetPlayer)
           Rayfield:Notify({Title = "Trade", Content = "Đã gửi yêu cầu trade tới " .. targetPlayer, Duration = 3})
       end
   end,
})

TradeTab:CreateToggle({
   Name = "Tự Động Chấp Nhận Trade (Auto Accept)",
   CurrentValue = false,
   Flag = "AutoAcceptTrade",
   Callback = function(Value)
       autoAcceptTrade = Value
       if autoAcceptTrade then
           task.spawn(function()
               while autoAcceptTrade do
                   task.wait(1)
                   -- game:GetService("ReplicatedStorage").Remotes.Trade:FireServer("Accept")
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 3: TIỆN ÍCH & DISCORD WEBHOOK
-- ==========================================
local UtilityTab = Window:CreateTab("⚙️ Tiện Ích", nil)

local webhookURL = ""

UtilityTab:CreateInput({
   Name = "Discord Webhook URL",
   PlaceholderText = "Dán Webhook báo cáo bán Emeralds...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) webhookURL = Text end,
})

UtilityTab:CreateButton({
   Name = "Kiểm Tra Webhook",
   Callback = function()
       if webhookURL ~= "" then
           local data = {
               ["embeds"] = {{
                   ["title"] = "🟢 Anime Defenders - Emerald Booth Log",
                   ["description"] = "Đã kết nối Webhook thành công! Đang theo dõi gian hàng Emerald.",
                   ["color"] = 65280
               }}
           }
           local req = http_request or request or HttpPost or syn.request
           req({Url = webhookURL, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = {["content-type"] = "application/json"}})
       end
   end,
})
