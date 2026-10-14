local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Lighting          = game:GetService("Lighting")
local VirtualUser       = game:GetService("VirtualUser")
local HttpService       = game:GetService("HttpService")

local LP     = Players.LocalPlayer
local Camera = workspace.CurrentCamera

pcall(function()
    if game.CoreGui:FindFirstChild("PHURI_MM2") then
        game.CoreGui.PHURI_MM2:Destroy()
    end
end)

local THEME = {
    BG          = Color3.fromRGB(18, 18, 24),
    SIDEBAR     = Color3.fromRGB(24, 24, 32),
    CONTENT     = Color3.fromRGB(22, 22, 30),
    ELEMENT     = Color3.fromRGB(32, 32, 44),
    ACCENT      = Color3.fromRGB(130, 90, 255),
    ACCENT_2    = Color3.fromRGB(90, 180, 255),
    TEXT        = Color3.fromRGB(235, 235, 245),
    TEXT_DIM    = Color3.fromRGB(150, 150, 170),
    STROKE      = Color3.fromRGB(45, 45, 60),
    ON          = Color3.fromRGB(80, 200, 130),
    OFF         = Color3.fromRGB(50, 50, 65),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHURI_MM2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.STROKE
    s.Thickness = thick or 1
    s.Parent = parent
    return s
end

local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0, 280, 1, -40)
notifHolder.Position = UDim2.new(1, -300, 0, 20)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = ScreenGui

local nl = Instance.new("UIListLayout")
nl.SortOrder = Enum.SortOrder.LayoutOrder
nl.Padding = UDim.new(0, 8)
nl.Parent = notifHolder

local function notify(text, dur)
    dur = dur or 3
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 45)
    n.BackgroundColor3 = THEME.ELEMENT
    n.BackgroundTransparency = 1
    n.Parent = notifHolder
    corner(n, 8)
    stroke(n, THEME.ACCENT, 1.2)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -12)
    accent.Position = UDim2.new(0, 6, 0, 6)
    accent.BackgroundColor3 = THEME.ACCENT
    accent.BorderSizePixel = 0
    accent.Parent = n
    corner(accent, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -25, 1, 0)
    lbl.Position = UDim2.new(0, 20, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.TEXT
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = n

    TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    task.delay(dur, function()
        TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        n:Destroy()
    end)
end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 54, 0, 54)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenBtn.BackgroundColor3 = THEME.ACCENT
OpenBtn.Text = "MM2"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 15
OpenBtn.BorderSizePixel = 0
OpenBtn.Parent = ScreenGui
corner(OpenBtn, 27)
stroke(OpenBtn, THEME.ACCENT_2, 1.5)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 640, 0, 420)
Main.Position = UDim2.new(0.5, -320, 0.5, -210)
Main.BackgroundColor3 = THEME.BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main, 14)
stroke(Main, THEME.STROKE, 1.2)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = THEME.SIDEBAR
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Position = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = THEME.STROKE
topLine.BorderSizePixel = 0
topLine.Parent = TopBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 300, 1, 0)
TitleLbl.Position = UDim2.new(0, 20, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "PHURI  ·  MM2 HUB"
TitleLbl.TextColor3 = THEME.TEXT
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 15
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 70, 90)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
corner(CloseBtn, 13)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = THEME.SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local sideDiv = Instance.new("Frame")
sideDiv.Size = UDim2.new(0, 1, 1, 0)
sideDiv.Position = UDim2.new(1, -1, 0, 0)
sideDiv.BackgroundColor3 = THEME.STROKE
sideDiv.BorderSizePixel = 0
sideDiv.Parent = Sidebar

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(1, -20, 0, 60)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = THEME.ELEMENT
Logo.BorderSizePixel = 0
Logo.Parent = Sidebar
corner(Logo, 10)

local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.new(0, 10, 0, 10)
logoDot.Position = UDim2.new(0, 14, 0.5, -5)
logoDot.BackgroundColor3 = THEME.ACCENT
logoDot.BorderSizePixel = 0
logoDot.Parent = Logo
corner(logoDot, 5)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, -40, 1, 0)
LogoText.Position = UDim2.new(0, 32, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "PHURI HUB"
LogoText.TextColor3 = THEME.TEXT
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 13
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = Logo

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, -20, 1, -90)
TabHolder.Position = UDim2.new(0, 10, 0, 80)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Sidebar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = TabHolder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -42)
Content.Position = UDim2.new(0, 150, 0, 42)
Content.BackgroundColor3 = THEME.CONTENT
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

local pages = {}
local tabBtns = {}
local currentTab = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.ACCENT
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = Content

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 10)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = page

    pages[name] = page
    return page
end

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.ELEMENT
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. (icon or "") .. "  " .. name
    btn.TextColor3 = THEME.TEXT_DIM
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TabHolder
    corner(btn, 8)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, -1, 0.5, 0)
    indicator.BackgroundColor3 = THEME.ACCENT
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    corner(indicator, 2)

    tabBtns[name] = {btn = btn, ind = indicator}

    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            btn.BackgroundTransparency = 0
            btn.BackgroundColor3 = THEME.ELEMENT
            btn.TextColor3 = THEME.TEXT
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            btn.BackgroundTransparency = 1
            btn.TextColor3 = THEME.TEXT_DIM
        end
    end)
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for n, t in pairs(tabBtns) do
            local active = (n == name)
            t.btn.BackgroundTransparency = active and 0 or 1
            t.btn.BackgroundColor3 = active and THEME.ELEMENT or THEME.ELEMENT
            t.btn.TextColor3 = active and THEME.TEXT or THEME.TEXT_DIM
            t.ind.Size = active and UDim2.new(0, 3, 0, 18) or UDim2.new(0, 3, 0, 0)
        end
        for n, p in pairs(pages) do
            p.Visible = (n == name)
        end
    end)
end

local function createSection(parent, title)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, 0, 0, 28)
    s.BackgroundTransparency = 1
    s.Parent = parent

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = "| " .. title:upper()
    t.TextColor3 = THEME.ACCENT_2
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = s

    return s
end

local function createToggle(parent, text, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundColor3 = THEME.ELEMENT
    holder.BorderSizePixel = 0
    holder.Parent = parent
    corner(holder, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.TEXT
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 20)
    track.Position = UDim2.new(1, -54, 0.5, -10)
    track.BackgroundColor3 = default and THEME.ACCENT or THEME.OFF
    track.BorderSizePixel = 0
    track.Parent = holder
    corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = holder

    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.2), {
            BackgroundColor3 = state and THEME.ACCENT or THEME.OFF
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        if callback then callback(state) end
    end)

    return {set = function(v)
        state = v
        track.BackgroundColor3 = v and THEME.ACCENT or THEME.OFF
        knob.Position = v and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if callback then callback(v) end
    end}
end

local function createSlider(parent, text, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 50)
    holder.BackgroundColor3 = THEME.ELEMENT
    holder.BorderSizePixel = 0
    holder.Parent = parent
    corner(holder, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 22)
    lbl.Position = UDim2.new(0, 14, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.TEXT
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 60, 0, 22)
    valLbl.Position = UDim2.new(1, -70, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = THEME.ACCENT_2
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = holder

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -28, 0, 6)
    barBg.Position = UDim2.new(0, 14, 0, 34)
    barBg.BackgroundColor3 = THEME.OFF
    barBg.BorderSizePixel = 0
    barBg.Parent = holder
    corner(barBg, 3)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    barFill.BackgroundColor3 = THEME.ACCENT
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    corner(barFill, 3)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20)
    btn.Position = UDim2.new(0, 0, 0, 28)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = holder

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * rel
        value = math.floor(value * 100) / 100
        barFill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(value)
        if callback then callback(value) end
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function createButton(parent, text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or THEME.ELEMENT
    btn.Text = text
    btn.TextColor3 = THEME.TEXT
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    corner(btn, 8)

    local baseColor = color or THEME.ELEMENT
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = baseColor:Lerp(Color3.new(1,1,1), 0.1)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = baseColor}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local function createTextbox(parent, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 34)
    box.BackgroundColor3 = THEME.ELEMENT
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = THEME.TEXT
    box.PlaceholderColor3 = THEME.TEXT_DIM
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 13
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = parent
    corner(box, 8)

    box.FocusLost:Connect(function(enter)
        if enter and callback then callback(box.Text) end
    end)
end

createPage("Combat");    createTab("Combat", "C")
createPage("Visual");    createTab("Visual", "V")
createPage("Player");    createTab("Player", "P")
createPage("Misc");      createTab("Misc", "M")
createPage("Settings");  createTab("Settings", "S")

-- =========================================
-- ============ แท็บ COMBAT =================
-- =========================================
do
    local p = pages["Combat"]
    createSection(p, "Aimbot")

    local aimEnabled, aimSmooth, aimFOV = false, 0.15, 120
    local aimPart = "Head"

    createToggle(p, "เปิด Aimbot", false, function(v) aimEnabled = v; notify("Aimbot: " .. (v and "ON" or "OFF")) end)
    createSlider(p, "Smoothness", 0.01, 1, 0.15, function(v) aimSmooth = v end)
    createSlider(p, "FOV Radius", 30, 400, 120, function(v) aimFOV = v end)
    createToggle(p, "Target Head (off = Body)", true, function(v) aimPart = v and "Head" or "UpperTorso" end)

    createSection(p, "Silent Aim")
    local silentAim = false
    createToggle(p, "Silent Aim", false, function(v) silentAim = v end)

    createSection(p, "Kill Aura")
    local killAura, killRange = false, 15
    createToggle(p, "Kill Aura (Murderer)", false, function(v) killAura = v end)
    createSlider(p, "Kill Range", 5, 50, 15, function(v) killRange = v end)

    createSection(p, "Auto Shoot")
    local autoShoot = false
    createToggle(p, "Auto Shoot (Sheriff)", false, function(v) autoShoot = v end)

    local function getRole(plr)
        if not plr.Character then return "Innocent" end
        local bp = plr:FindFirstChild("Backpack")
        local ch = plr.Character
        if ch:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
        if ch:FindFirstChild("Gun") or ch:FindFirstChild("Revolver") or (bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver"))) then return "Sheriff" end
        return "Innocent"
    end

    local function getClosestTarget()
        local closest, dist = nil, aimFOV
        local myRole = getRole(LP)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                if plr.Character.Humanoid.Health > 0 then
                    local role = getRole(plr)
                    local isEnemy = (myRole == "Murderer" and role == "Sheriff")
                                 or (myRole == "Sheriff" and role == "Murderer")
                                 or (myRole == "Innocent" and role == "Murderer")
                    if isEnemy then
                        local sp, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                        if vis then
                            local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                            if d < dist then
                                dist = d
                                closest = plr
                            end
                        end
                    end
                end
            end
        end
        return closest
    end

    RunService.RenderStepped:Connect(function()
        if aimEnabled then
            local t = getClosestTarget()
            if t and t.Character then
                local target = t.Character:FindFirstChild(aimPart) or t.Character:FindFirstChild("HumanoidRootPart")
                if target then
                    local goal = CFrame.new(Camera.CFrame.Position, target.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(goal, aimSmooth)
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.15)
            if killAura and LP.Character and LP.Character:FindFirstChildOfClass("Tool") then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LP.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= killRange then
                            pcall(function() LP.Character:FindFirstChildOfClass("Tool"):Activate() end)
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.3)
            if autoShoot then
                local t = getClosestTarget()
                if t and t.Character then
                    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                end
            end
        end
    end)
end

-- =========================================
-- ============ แท็บ VISUAL =================
-- =========================================
do
    local p = pages["Visual"]
    createSection(p, "ESP")

    local espEnabled, espName, espDist = false, true, true
    local espList = {}

    createToggle(p, "ESP บทบาท", false, function(v) espEnabled = v end)
    createToggle(p, "แสดงชื่อ", true, function(v) espName = v end)
    createToggle(p, "แสดงระยะ", true, function(v) espDist = v end)

    createSection(p, "Highlight")
    local highlightEnabled = false
    createToggle(p, "Highlight ผู้เล่น", false, function(v)
        highlightEnabled = v
        if not v then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Highlight") and d.Name == "PHURI_HL" then d:Destroy() end
            end
        end
    end)

    createSection(p, "FOV Circle")
    local fovCircle = false
    createToggle(p, "แสดง FOV Circle", false, function(v) fovCircle = v end)

    createSection(p, "แสงสว่าง")
    local origLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
    }

    createToggle(p, "Fullbright", false, function(v)
        if v then
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = origLighting.Ambient
            Lighting.Brightness = origLighting.Brightness
            Lighting.ClockTime = origLighting.ClockTime
            Lighting.FogEnd = origLighting.FogEnd
            Lighting.GlobalShadows = true
        end
        notify("Fullbright: " .. (v and "ON" or "OFF"))
    end)

    createToggle(p, "No Fog", false, function(v)
        Lighting.FogEnd = v and 100000 or origLighting.FogEnd
    end)

    RunService.RenderStepped:Connect(function()
        if highlightEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local role = "Innocent"
                    if plr.Character:FindFirstChild("Knife") then role = "Murderer"
                    elseif plr.Character:FindFirstChild("Gun") or plr.Character:FindFirstChild("Revolver") then role = "Sheriff" end

                    if not plr.Character:FindFirstChild("PHURI_HL") then
                        local h = Instance.new("Highlight")
                        h.Name = "PHURI_HL"
                        h.Parent = plr.Character
                    end
                    local h = plr.Character:FindFirstChild("PHURI_HL")
                    if h then
                        if role == "Murderer" then
                            h.FillColor = Color3.fromRGB(255, 40, 40)
                            h.OutlineColor = Color3.fromRGB(255, 100, 100)
                        elseif role == "Sheriff" then
                            h.FillColor = Color3.fromRGB(40, 150, 255)
                            h.OutlineColor = Color3.fromRGB(100, 200, 255)
                        else
                            h.FillColor = Color3.fromRGB(80, 255, 130)
                            h.OutlineColor = Color3.fromRGB(200, 255, 220)
                        end
                        h.FillTransparency = 0.6
                        h.OutlineTransparency = 0
                    end
                end
            end
        end
    end)

    local function makeESP(plr)
        if plr == LP then return end
        if espList[plr] then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "PHURI_ESP"
        bb.Size = UDim2.new(0, 220, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.Enabled = false

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, 0, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name
        nameLbl.TextStrokeTransparency = 0
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.Parent = bb

        local distLbl = Instance.new("TextLabel")
        distLbl.Size = UDim2.new(1, 0, 0, 14)
        distLbl.Position = UDim2.new(0, 0, 0, 18)
        distLbl.BackgroundTransparency = 1
        distLbl.Text = ""
        distLbl.TextStrokeTransparency = 0
        distLbl.Font = Enum.Font.GothamMedium
        distLbl.TextSize = 12
        distLbl.Parent = bb

        espList[plr] = {bb = bb, name = nameLbl, dist = distLbl}
    end

    for _, plr in ipairs(Players:GetPlayers()) do makeESP(plr) end
    Players.PlayerAdded:Connect(makeESP)
    Players.PlayerRemoving:Connect(function(plr)
        if espList[plr] then espList[plr].bb:Destroy(); espList[plr] = nil end
    end)

    RunService.RenderStepped:Connect(function()
        for plr, data in pairs(espList) do
            if espEnabled and plr.Character and plr.Character:FindFirstChild("Head") then
                data.bb.Adornee = plr.Character.Head
                data.bb.Enabled = true

                local role, col = "Innocent", Color3.fromRGB(255, 255, 255)
                if plr.Character:FindFirstChild("Knife") then
                    role, col = "Murderer", Color3.fromRGB(255, 70, 70)
                elseif plr.Character:FindFirstChild("Gun") or plr.Character:FindFirstChild("Revolver") then
                    role, col = "Sheriff", Color3.fromRGB(80, 180, 255)
                end

                data.name.Text = espName and ("["..role.."] "..plr.Name) or ""
                data.name.TextColor3 = col
                if espDist and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LP.Character.HumanoidRootPart.Position - plr.Character.Head.Position).Magnitude
                    data.dist.Text = string.format("%d studs", math.floor(d))
                    data.dist.TextColor3 = THEME.TEXT_DIM
                else
                    data.dist.Text = ""
                end
            else
                data.bb.Enabled = false
            end
        end
    end)

    pcall(function()
        local fovDrawing = Drawing.new("Circle")
        fovDrawing.Thickness = 1.5
        fovDrawing.Color = THEME.ACCENT
        fovDrawing.NumSides = 60
        fovDrawing.Transparency = 1
        fovDrawing.Visible = false
        fovDrawing.Filled = false

        RunService.RenderStepped:Connect(function()
            fovDrawing.Visible = fovCircle
            if fovCircle then
                fovDrawing.Position = Camera.ViewportSize / 2
                fovDrawing.Radius = 120
            end
        end)
    end)
end

-- =========================================
-- ============ แท็บ PLAYER =================
-- =========================================
do
    local p = pages["Player"]
    createSection(p, "การเคลื่อนไหว")

    local speedEnabled, speedVal = false, 25
    createToggle(p, "Speed Hack", false, function(v)
        speedEnabled = v
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v and speedVal or 16
        end
    end)
    createSlider(p, "ความเร็ว", 16, 150, 25, function(v)
        speedVal = v
        if speedEnabled and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end)

    local jumpEnabled, jumpVal = false, 80
    createToggle(p, "Jump Power", false, function(v)
        jumpEnabled = v
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = v and jumpVal or 50
        end
    end)
    createSlider(p, "พลังกระโดด", 50, 300, 80, function(v)
        jumpVal = v
        if jumpEnabled and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
        end
    end)

    createSection(p, "พิเศษ")

    local infJump = false
    createToggle(p, "Infinite Jump", false, function(v) infJump = v end)

    local flyEnabled, flySpeed = false, 60
    createToggle(p, "Fly", false, function(v)
        flyEnabled = v
        if not v and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.Velocity = Vector3.zero
            if LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            end
        end
    end)
    createSlider(p, "Fly Speed", 20, 300, 60, function(v) flySpeed = v end)

    local noclip = false
    createToggle(p, "Noclip", false, function(v) noclip = v end)

    createSection(p, "ร่างกาย")
    createButton(p, "รีเซ็ตตัวละคร", function()
        if LP.Character then LP.Character:BreakJoints() end
    end, Color3.fromRGB(200, 80, 80))

    RunService.Stepped:Connect(function()
        if noclip and LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if infJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    local bodyVel, bodyGyro
    RunService.RenderStepped:Connect(function()
        if flyEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end

            if not bodyVel or bodyVel.Parent ~= hrp then
                if bodyVel then bodyVel:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                bodyVel = Instance.new("BodyVelocity", hrp)
                bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro = Instance.new("BodyGyro", hrp)
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.P = 1000
            end

            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

            if move.Magnitude > 0 then
                bodyVel.Velocity = move.Unit * flySpeed
            else
                bodyVel.Velocity = Vector3.zero
            end
            bodyGyro.CFrame = Camera.CFrame
        else
            if bodyVel then bodyVel:Destroy(); bodyVel = nil end
            if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        end
    end)
end

-- =========================================
-- ============ แท็บ MISC ===================
-- =========================================
do
    local p = pages["Misc"]
    createSection(p, "ไอเทม")

    local autoGun = false
    createToggle(p, "Auto เก็บ Gun (Sheriff)", false, function(v) autoGun = v end)

    local autoCoin = false
    createToggle(p, "Auto เก็บ Coin", false, function(v) autoCoin = v end)

    createSection(p, "เซิร์ฟเวอร์")

    createButton(p, "Server Hop", function()
        notify("กำลังหาเซิร์ฟเวอร์ใหม่...")
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local req = game:HttpGet(url)
            local data = HttpService:JSONDecode(req)
            for _, srv in ipairs(data.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                    return
                end
            end
            notify("ไม่พบเซิร์ฟเวอร์ว่าง")
        end)
    end, Color3.fromRGB(70, 130, 200))

    createButton(p, "Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end, Color3.fromRGB(80, 160, 100))

    createButton(p, "Copy Job ID", function()
        pcall(function()
            if setclipboard then setclipboard(game.JobId) end
            notify("คัดลอก Job ID แล้ว")
        end)
    end)

    createSection(p, "อื่นๆ")

    local antiAFK = false
    createToggle(p, "Anti-AFK", false, function(v) antiAFK = v end)

    createButton(p, "ดึงผู้เล่นทั้งหมดมาหาเรา", function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
            notify("ดึงผู้เล่นแล้ว")
        end
    end, Color3.fromRGB(180, 80, 180))

    task.spawn(function()
        while true do
            task.wait(0.5)
            if autoGun and LP.Character then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Revolver") then
                        pcall(function()
                            LP.Character:FindFirstChildOfClass("Humanoid"):EquipTool(obj)
                        end)
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            if autoCoin and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
                        pcall(function()
                            LP.Character.HumanoidRootPart.CFrame = obj.CFrame
                        end)
                    end
                end
            end
        end
    end)

    LP.Idled:Connect(function()
        if antiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- =========================================
-- ============ แท็บ SETTINGS ===============
-- =========================================
do
    local p = pages["Settings"]
    createSection(p, "การตั้งค่า UI")

    createTextbox(p, "พิมพ์คีย์ลัดเปิด/ปิด UI (เช่น K)", function(txt)
        local key = txt:upper()
        notify("ตั้งคีย์ลัดเป็น: " .. key)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode[key] then
                Main.Visible = not Main.Visible
            end
        end)
    end)

    createSection(p, "ธีม")

    createButton(p, "ธีมม่วง (ค่าเริ่มต้น)", function()
        THEME.ACCENT = Color3.fromRGB(130, 90, 255)
        THEME.ACCENT_2 = Color3.fromRGB(90, 180, 255)
        notify("เปลี่ยนธีมเป็นม่วง")
    end, Color3.fromRGB(80, 60, 160))

    createButton(p, "ธีมฟ้า", function()
        THEME.ACCENT = Color3.fromRGB(60, 150, 255)
        THEME.ACCENT_2 = Color3.fromRGB(100, 200, 255)
        notify("เปลี่ยนธีมเป็นฟ้า")
    end, Color3.fromRGB(50, 100, 180))

    createButton(p, "ธีมแดง", function()
        THEME.ACCENT = Color3.fromRGB(230, 60, 80)
        THEME.ACCENT_2 = Color3.fromRGB(255, 130, 130)
        notify("เปลี่ยนธีมเป็นแดง")
    end, Color3.fromRGB(160, 50, 60))

    createButton(p, "ธีมเขียว", function()
        THEME.ACCENT = Color3.fromRGB(60, 200, 130)
        THEME.ACCENT_2 = Color3.fromRGB(120, 240, 170)
        notify("เปลี่ยนธีมเป็นเขียว")
    end, Color3.fromRGB(50, 140, 90))

    createSection(p, "อื่นๆ")

    createButton(p, "ปิดสคริปต์ทั้งหมด", function()
        ScreenGui:Destroy()
    end, Color3.fromRGB(200, 60, 60))
end

-- =========================================
-- ====== เลือกแท็บเริ่มต้น + แสดง UI ======
-- =========================================
tabBtns["Combat"].btn.MouseButton1Click:Fire()
Main.Visible = true

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

notify("PHURI MM2 HUB โหลดสำเร็จ!", 5)
print("PHURI MM2 HUB | VX-Style Loaded")
