-- ==========================================
-- PHURI HUB/BLADE BALL V3 (Safe Edition)
-- ซ่อน UI อย่างปลอดภัย + ไม่ Hook Kick
-- ==========================================

-- ⭐️ PART 1: Services & Setup
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- อัปเดตตัวละครเมื่อเกิดใหม่
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- ⭐️ PART 2: สร้าง UI และซ่อนอย่างปลอดภัย
local sg = Instance.new("ScreenGui")
sg.Name = "PHURI_HUB_BLADE_BALL_V3"
sg.ResetOnSpawn = false

-- วิธีซ่อน UI ที่ปลอดภัยที่สุด (ไม่ใช้ hookmetamethod)
if gethui then
    sg.Parent = gethui()
    print("✅ ซ่อน UI ด้วย gethui() สำเร็จ")
elseif syn and syn.protect_gui then
    syn.protect_gui(sg)
    sg.Parent = game:GetService("CoreGui")
    print("✅ ซ่อน UI ด้วย syn.protect_gui() สำเร็จ")
elseif protect_gui then
    protect_gui(sg)
    sg.Parent = game:GetService("CoreGui")
    print("✅ ซ่อน UI ด้วย protect_gui() สำเร็จ")
else
    sg.Parent = game:GetService("CoreGui")
    print("⚠️ ใช้วิธีสำรอง (CoreGui)")
end

-- ตัวแปรสถานะและค่าตั้งต้น
local F = {
    AutoParry = false,
    PrecisionMode = true,
    BallESP = false,
    PlayerESP = false,
}
local Settings = {
    HitboxSize = 10,
    PingBuffer = 0.08,
    ParryCooldown = 0.18,
    DetectionRadius = 50,
}
local LastParry = 0
local ESP_Objects = {}

-- ⭐️ PART 3: ระบบ Auto Parry (Precision + Ping Compensation)
local function GetBall()
    local balls = workspace:FindFirstChild("Balls")
    if balls then
        for _, ball in pairs(balls:GetChildren()) do
            if ball:IsA("BasePart") then return ball end
        end
    end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name:find("Ball")) then
            return obj
        end
    end
    return nil
end

local function FireParry()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.01)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

RunService.RenderStepped:Connect(function()
    if not F.AutoParry then return end
    if tick() - LastParry < Settings.ParryCooldown then return end

    local ball = GetBall()
    if not ball then return end

    -- ถ้าไม่เปิด Precision Mode ให้ใช้ระยะธรรมดา
    if not F.PrecisionMode then
        local distance = (ball.Position - RootPart.Position).Magnitude
        if distance < Settings.HitboxSize then
            LastParry = tick()
            task.wait(math.random(3, 8) / 100)
            FireParry()
        end
        return
    end

    -- ⭐️ Precision Logic (CPA + Ping)
    local ping = LocalPlayer:GetNetworkPing()
    local playerPos = RootPart.Position
    local playerVel = RootPart.AssemblyLinearVelocity
    local ballPos = ball.Position
    local ballVel = ball.AssemblyLinearVelocity

    local relPos = ballPos - playerPos
    local relVel = ballVel - playerVel

    local timeToClosest = -relPos:Dot(relVel) / math.max(relVel:Dot(relVel), 0.001)
    if timeToClosest < 0 then return end

    local closestPos = relPos + (relVel * timeToClosest)
    local closestDistance = closestPos.Magnitude

    if closestDistance > Settings.HitboxSize then return end

    local offset = math.sqrt(math.max(Settings.HitboxSize^2 - closestDistance^2, 0)) / math.max(relVel.Magnitude, 0.001)
    local timeToHit = timeToClosest - offset

    if timeToHit <= (ping + Settings.PingBuffer) and timeToHit > -0.1 then
        LastParry = tick()
        task.wait(math.random(3, 8) / 100)
        FireParry()
    end
end)

-- ⭐️ PART 4: ระบบ ESP
local function UpdateESP()
    if F.BallESP then
        local ball = GetBall()
        if ball and not ball:FindFirstChild("PHURI_ESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "PHURI_ESP"
            hl.FillColor = Color3.fromRGB(255, 0, 100)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.3
            hl.Parent = ball
        end
    end
    if F.PlayerESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("PHURI_ESP_P") then
                local hl = Instance.new("Highlight")
                hl.Name = "PHURI_ESP_P"
                hl.FillColor = Color3.fromRGB(255, 100, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
            end
        end
    end
end
RunService.Heartbeat:Connect(UpdateESP)

-- ⭐️ PART 5: สร้าง UI (Tabs + Toggles + Sliders)
local mf = Instance.new("Frame", sg)
mf.Size = UDim2.new(0, 480, 0, 320)
mf.Position = UDim2.new(0.5, -240, 0.5, -160)
mf.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mf)
stroke.Color = Color3.fromRGB(255, 72, 92)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mf)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "⚔️ PHURI HUB/BLADE BALL V3"
title.TextColor3 = Color3.fromRGB(255, 72, 92)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local sidebar = Instance.new("Frame", mf)
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.new(0, 10, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)
local sideLayout = Instance.new("UIListLayout", sidebar)
sideLayout.Padding = UDim.new(0, 8)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local content = Instance.new("Frame", mf)
content.Size = UDim2.new(1, -140, 1, -50)
content.Position = UDim2.new(0, 130, 0, 45)
content.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("Frame", content)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    return page
end

local pageMain = createPage("Main")
local pageSettings = createPage("Settings")
local pageVisual = createPage("Visual")

local function switchTab(pageToShow)
    pageMain.Visible = false
    pageSettings.Visible = false
    pageVisual.Visible = false
    pageToShow.Visible = true
end

local function createSidebarButton(text, page)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 31, 39)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() switchTab(page) end)
end

createSidebarButton("⚔️ Main", pageMain)
createSidebarButton("⚙️ Settings", pageSettings)
createSidebarButton("👁️ Visual", pageVisual)

-- ฟังก์ชันสร้าง Toggle
local function createToggle(parent, text, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 45)
    btn.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    btn.Text = text .. ": ปิด"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        F[key] = isOn
        btn.Text = text .. (isOn and ": เปิด" or ": ปิด")
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 120, 80) or Color3.fromRGB(30, 20, 50)
        if callback then callback(isOn) end
    end)
end

-- ⭐️ ฟังก์ชันสร้าง Slider (พร้อมแก้ปัญหาลาก UI)
local function createSlider(parent, text, key, min, max, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 55)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    track.Active = true -- ⭐️ ให้รับ Input ได้
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", fill)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(1, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mf.Active = false -- ⭐️ ปิดการลาก UI หลัก
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            mf.Active = true -- ⭐️ เปิดการลาก UI คืน
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = min + ((max - min) * pos)
            label.Text = text .. ": " .. string.format("%.2f", value)
            Settings[key] = value
        end
    end)
end

-- ⭐️ ใส่ของในแต่ละหน้า
createToggle(pageMain, "🛡️ Auto Parry", "AutoParry")
createToggle(pageMain, "⚡ Precision Mode", "PrecisionMode", function(state)
    F.PrecisionMode = state
end)

-- ตั้งค่าเริ่มต้น Precision Mode เป็นเปิด
F.PrecisionMode = true
local precisionBtn = pageMain:GetChildren()[2]
if precisionBtn then
    precisionBtn.Text = "⚡ Precision Mode: เปิด"
    precisionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
    local isPrecisionOn = true
    -- ล้าง Event เก่าและใส่ใหม่
    for _, conn in pairs(getconnections and getconnections(precisionBtn.MouseButton1Click) or {}) do
        pcall(function() conn:Disconnect() end)
    end
    precisionBtn.MouseButton1Click:Connect(function()
        isPrecisionOn = not isPrecisionOn
        F.PrecisionMode = isPrecisionOn
        precisionBtn.Text = "⚡ Precision Mode" .. (isPrecisionOn and ": เปิด" or ": ปิด")
        precisionBtn.BackgroundColor3 = isPrecisionOn and Color3.fromRGB(0, 120, 80) or Color3.fromRGB(30, 20, 50)
    end)
end

createSlider(pageSettings, "🎯 Hitbox Size", "HitboxSize", 5, 25, 10)
createSlider(pageSettings, "📡 Ping Buffer", "PingBuffer", 0.02, 0.3, 0.08)
createSlider(pageSettings, "⏱️ Parry Cooldown", "ParryCooldown", 0.05, 0.5, 0.18)

createToggle(pageVisual, "⚽ Ball ESP", "BallESP")
createToggle(pageVisual, "👤 Player ESP", "PlayerESP")

switchTab(pageMain)

print("PHURI HUB/BLADE BALL V3 โหลดสำเร็จ!")
print("✅ ลบ Bypass Hook Kick แล้ว (ปลอดภัยขึ้น)")
print("✅ ซ่อน UI อย่างปลอดภัยแล้ว")
