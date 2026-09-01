-- Tối ưu hóa hiệu suất & Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Load UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 Anime Defenders VIP - Trade & Booth",
   LoadingTitle = "Đang tải Script VIP...",
   LoadingSubtitle = "By YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "AD_VIP_Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = true 
   },
   KeySystem = false
})

-- ==========================================
-- TAB 1: QUẢN LÝ GIAN HÀNG (BOOTH MANAGER)
-- ==========================================
local BoothTab = Window:CreateTab("🏪 Gian Hàng", nil)

local sellPrice = 100
local unitToSell = "Gems"
local autoListEnabled = false
local snipeEnabled = false
local maxSnipePrice = 50

BoothTab:CreateSection("Cài đặt Đăng bán")

BoothTab:CreateInput({
   Name = "Tên Unit/Vật phẩm cần bán",
   PlaceholderText = "Nhập tên...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       unitToSell = Text
   end,
})

BoothTab:CreateSlider({
   Name = "Giá bán mặc định (Gems)",
   Range = {10, 100000},
   Increment = 10,
   Suffix = " Gems",
   CurrentValue = 100,
   Flag = "SellPrice",
   Callback = function(Value)
       sellPrice = Value
   end,
})

BoothTab:CreateToggle({
   Name = "Tự động đăng bán (Auto List)",
   CurrentValue = false,
   Flag = "AutoList",
   Callback = function(Value)
       autoListEnabled = Value
       if autoListEnabled then
           task.spawn(function()
               while autoListEnabled do
                   task.wait(2)
                   -- THAY THẾ REMOTE EVENT TẠI ĐÂY
                   -- Ví dụ: game:GetService("ReplicatedStorage").Remotes.ListBooth:FireServer(unitToSell, sellPrice)
               end
           end)
       end
   end,
})

BoothTab:CreateSection("Săn hàng rẻ (Sniper)")

BoothTab:CreateSlider({
   Name = "Giá mua tối đa",
   Range = {1, 5000},
   Increment = 1,
   Suffix = " Gems",
   CurrentValue = 50,
   Flag = "SnipePrice",
   Callback = function(Value)
       maxSnipePrice = Value
   end,
})

BoothTab:CreateToggle({
   Name = "Kích hoạt Auto Snipe",
   CurrentValue = false,
   Flag = "AutoSnipe",
   Callback = function(Value)
       snipeEnabled = Value
       if snipeEnabled then
           task.spawn(function()
               while snipeEnabled do
                   task.wait(0.5)
                   -- THAY THẾ REMOTE GET BOOTH TẠI ĐÂY
                   -- Logic: Lấy data booth -> Check tên item -> Check giá < maxSnipePrice -> FireServer Buy
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 2: GIAO DỊCH (TRADE MANAGER)
-- ==========================================
local TradeTab = Window:CreateTab("🤝 Giao Dịch", nil)

local targetPlayer = ""
local autoAccept = false

TradeTab:CreateInput({
   Name = "Tên người chơi (Username)",
   PlaceholderText = "Nhập tên người muốn trade...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       targetPlayer = Text
   end,
})

TradeTab:CreateButton({
   Name = "Gửi yêu cầu Trade liên tục",
   Callback = function()
       -- THAY THẾ REMOTE TRADE TẠI ĐÂY
       -- Ví dụ: game:GetService("ReplicatedStorage").Remotes.SendTrade:FireServer(targetPlayer)
       Rayfield:Notify({
           Title = "Đã gửi",
           Content = "Đã gửi yêu cầu trade đến " .. targetPlayer,
           Duration = 3,
       })
   end,
})

TradeTab:CreateToggle({
   Name = "Tự động chấp nhận Trade (Auto Accept)",
   CurrentValue = false,
   Flag = "AutoAccept",
   Callback = function(Value)
       autoAccept = Value
       if autoAccept then
           task.spawn(function()
               while autoAccept do
                   task.wait(1)
                   -- THAY THẾ REMOTE ACCEPT TẠI ĐÂY
                   -- game:GetService("ReplicatedStorage").Remotes.AcceptTrade:FireServer()
               end
           end)
       end
   end,
})

-- ==========================================
-- TAB 3: CÀI ĐẶT NÂNG CAO & WEBHOOK
-- ==========================================
local SettingsTab = Window:CreateTab("⚙️ Cài đặt", nil)

local webhookURL = ""

SettingsTab:CreateInput({
   Name = "Discord Webhook URL (Báo cáo bán hàng)",
   PlaceholderText = "https://discord.com/api/webhooks/...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       webhookURL = Text
   end,
})

SettingsTab:CreateButton({
   Name = "Test Webhook",
   Callback = function()
       if webhookURL ~= "" then
           local data = {
               ["content"] = "",
               ["embeds"] = {{
                   ["title"] = "🛒 Anime Defenders - Báo cáo Booth",
                   ["description"] = "Script VIP đang hoạt động tốt!",
                   ["color"] = tonumber(0x00ff00)
               }}
           }
           local newdata = game:GetService("HttpService"):JSONEncode(data)
           local headers = {["content-type"] = "application/json"}
           request = http_request or request or HttpPost or syn.request
           local abcdef = {Url = webhookURL, Body = newdata, Method = "POST", Headers = headers}
           request(abcdef)
       else
           Rayfield:Notify({Title = "Lỗi", Content = "Vui lòng nhập Webhook URL trước!", Duration = 3})
       end
   end,
})

SettingsTab:CreateParagraph({Title = "Anti-AFK", Content = "Hệ thống Anti-AFK đã được tự động kích hoạt ngầm. Bạn sẽ không bị kick khi treo máy."})
