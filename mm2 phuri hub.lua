-- ==================================================
--  🎯 PHURI MM2 HUB  |  UI FRAMEWORK
-- ==================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local VirtualUser      = game:GetService("VirtualUser")
local HttpService      = game:GetService("HttpService")
local LP               = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

pcall(function()
    local g = game.CoreGui:FindFirstChild("PHURI_MM2")
    if g then g:Destroy() end
end)

local THEME = {
    BG = Color3.fromRGB(18,18,24), SIDEBAR = Color3.fromRGB(24,24,32),
    CONTENT = Color3.fromRGB(22,22,30), ELEMENT = Color3.fromRGB(32,32,44),
    ACCENT = Color3.fromRGB(130,90,255), ACCENT_2 = Color3.fromRGB(90,180,255),
    TEXT = Color3.fromRGB(235,235,245), TEXT_DIM = Color3.fromRGB(150,150,170),
    STROKE = Color3.fromRGB(45,45,60), OFF = Color3.fromRGB(50,50,65),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PHURI_MM2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end
local function stroke(p, c, t)
    local s = Instance.new("UIStroke"); s.Color = c or THEME.STROKE; s.Thickness = t or 1; s.Parent = p; return s
end

-- Notification
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0, 280, 1, -40)
notifHolder.Position = UDim2.new(1, -300, 0, 20)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = ScreenGui
local nl = Instance.new("UIListLayout"); nl.Padding = UDim.new(0, 8); nl.Parent = notifHolder

local function notify(text, dur)
    dur = dur or 3
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 45)
    n.BackgroundColor3 = THEME.ELEMENT
    n.BackgroundTransparency = 1
    n.Parent = notifHolder
    corner(n, 8); stroke(n, THEME.ACCENT, 1.2)
    local a = Instance.new("Frame")
    a.Size = UDim2.new(0, 3, 1, -12); a.Position = UDim2.new(0, 6, 0, 6)
    a.BackgroundColor3 = THEME.ACCENT; a.BorderSizePixel = 0; a.Parent = n
    corner(a, 2)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -25, 1, 0); l.Position = UDim2.new(0, 20, 0, 0)
    l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = THEME.TEXT
    l.Font = Enum.Font.GothamMedium; l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true; l.Parent = n
    TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    task.delay(dur, function()
        TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        task.wait(0.3); n:Destroy()
    end)
end

-- ปุ่มเปิด UI
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 54, 0, 54)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenBtn.BackgroundColor3 = THEME.ACCENT
OpenBtn.Text = "MM2"; OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.TextSize = 15
OpenBtn.BorderSizePixel = 0; OpenBtn.Active = true; OpenBtn.ZIndex = 9999
OpenBtn.Parent = ScreenGui
corner(OpenBtn, 27); stroke(OpenBtn, THEME.ACCENT_2, 1.5)
ScreenGui.DisplayOrder = 999

-- หน้าต่างหลัก
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 640, 0, 420)
Main.Position = UDim2.new(0.5, -320, 0.5, -210)
Main.BackgroundColor3 = THEME.BG; Main.BorderSizePixel = 0
Main.Visible = false; Main.ClipsDescendants = true; Main.Parent = ScreenGui
corner(Main, 14); stroke(Main, THEME.STROKE, 1.2)

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = THEME.SIDEBAR; TopBar.BorderSizePixel = 0; TopBar.Parent = Main
local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1); topLine.Position = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = THEME.STROKE; topLine.BorderSizePixel = 0; topLine.Parent = TopBar
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 20, 0, 0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "PHURI  ·  MM2 HUB"
TitleLbl.TextColor3 = THEME.TEXT; TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 15; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.Parent = TopBar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230,70,90); CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14; CloseBtn.BorderSizePixel = 0; CloseBtn.Active = true; CloseBtn.Parent = TopBar
corner(CloseBtn, 13)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = THEME.SIDEBAR; Sidebar.BorderSizePixel = 0; Sidebar.Parent = Main
local sideDiv = Instance.new("Frame")
sideDiv.Size = UDim2.new(0, 1, 1, 0); sideDiv.Position = UDim2.new(1, -1, 0, 0)
sideDiv.BackgroundColor3 = THEME.STROKE; sideDiv.BorderSizePixel = 0; sideDiv.Parent = Sidebar
local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(1, -20, 0, 60); Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = THEME.ELEMENT; Logo.BorderSizePixel = 0; Logo.Parent = Sidebar
corner(Logo, 10)
local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.new(0, 10, 0, 10); logoDot.Position = UDim2.new(0, 14, 0.5, -5)
logoDot.BackgroundColor3 = THEME.ACCENT; logoDot.BorderSizePixel = 0; logoDot.Parent = Logo
corner(logoDot, 5)
local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, -40, 1, 0); LogoText.Position = UDim2.new(0, 32, 0, 0)
LogoText.BackgroundTransparency = 1; LogoText.Text = "PHURI HUB"
LogoText.TextColor3 = THEME.TEXT; LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 13; LogoText.TextXAlignment = Enum.TextXAlignment.Left; LogoText.Parent = Logo

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, -20, 1, -90); TabHolder.Position = UDim2.new(0, 10, 0, 80)
TabHolder.BackgroundTransparency = 1; TabHolder.Parent = Sidebar
local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6); tabLayout.Parent = TabHolder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -42); Content.Position = UDim2.new(0, 150, 0, 42)
Content.BackgroundColor3 = THEME.CONTENT; Content.BorderSizePixel = 0
Content.ClipsDescendants = true; Content.Parent = Main

local pages, tabBtns, currentTab = {}, {}, nil

local function createPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, -20, 1, -20); p.Position = UDim2.new(0, 10, 0, 10)
    p.BackgroundTransparency = 1; p.BorderSizePixel = 0
    p.ScrollBarThickness = 4; p.ScrollBarImageColor3 = THEME.ACCENT
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false; p.Parent = Content
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 10); lay.Parent = p
    pages[name] = p
    return p
end

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.ELEMENT; btn.BackgroundTransparency = 1
    btn.Text = "   " .. (icon or "") .. "  " .. name
    btn.TextColor3 = THEME.TEXT_DIM; btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = TabHolder
    corner(btn, 8)
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0, 0); ind.Position = UDim2.new(0, -1, 0.5, 0)
    ind.BackgroundColor3 = THEME.ACCENT; ind.BorderSizePixel = 0; ind.Parent = btn
    corner(ind, 2)
    tabBtns[name] = {btn = btn, ind = ind}
    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            btn.BackgroundTransparency = 0; btn.TextColor3 = THEME.TEXT
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            btn.BackgroundTransparency = 1; btn.TextColor3 = THEME.TEXT_DIM
        end
    end)
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for n, t in pairs(tabBtns) do
            local act = (n == name)
            t.btn.BackgroundTransparency = act and 0 or 1
            t.btn.TextColor3 = act and THEME.TEXT or THEME.TEXT_DIM
            t.ind.Size = act and UDim2.new(0, 3, 0, 18) or UDim2.new(0, 3, 0, 0)
        end
        for n, p in pairs(pages) do p.Visible = (n == name) end
    end)
end

local function createSection(parent, title)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, 0, 0, 28); s.BackgroundTransparency = 1; s.Parent = parent
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = "| " .. title:upper(); t.TextColor3 = THEME.ACCENT_2
    t.Font = Enum.Font.GothamBold; t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = s
    return s
end

local function createToggle(parent, text, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 36); holder.BackgroundColor3 = THEME.ELEMENT
    holder.BorderSizePixel = 0; holder.Parent = parent; corner(holder, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = THEME.TEXT
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = holder
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 20); track.Position = UDim2.new(1, -54, 0.5, -10)
    track.BackgroundColor3 = default and THEME.ACCENT or THEME.OFF
    track.BorderSizePixel = 0; track.Parent = holder; corner(track, 10)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1); knob.BorderSizePixel = 0
    knob.Parent = track; corner(knob, 8)
    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.Parent = holder
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
end

local function createSlider(parent, text, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 50); holder.BackgroundColor3 = THEME.ELEMENT
    holder.BorderSizePixel = 0; holder.Parent = parent; corner(holder, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 22); lbl.Position = UDim2.new(0, 14, 0, 4)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = THEME.TEXT
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = holder
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 60, 0, 22); valLbl.Position = UDim2.new(1, -70, 0, 4)
    valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(default)
    valLbl.TextColor3 = THEME.ACCENT_2; valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.Parent = holder
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -28, 0, 6); barBg.Position = UDim2.new(0, 14, 0, 34)
    barBg.BackgroundColor3 = THEME.OFF; barBg.BorderSizePixel = 0
    barBg.Parent = holder; corner(barBg, 3)
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    barFill.BackgroundColor3 = THEME.ACCENT; barFill.BorderSizePixel = 0
    barFill.Parent = barBg; corner(barFill, 3)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20); btn.Position = UDim2.new(0, 0, 0, 28)
    btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = holder
    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local v = min + (max - min) * rel
        v = math.floor(v * 100) / 100
        barFill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(v)
        if callback then callback(v) end
    end
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(input)
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
    btn.Text = text; btn.TextColor3 = THEME.TEXT
    btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.Parent = parent
    corner(btn, 8)
    local base = color or THEME.ELEMENT
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = base:Lerp(Color3.new(1,1,1), 0.1)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

local function createTextbox(parent, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 34); box.BackgroundColor3 = THEME.ELEMENT
    box.Text = ""; box.PlaceholderText = placeholder
    box.TextColor3 = THEME.TEXT; box.PlaceholderColor3 = THEME.TEXT_DIM
    box.Font = Enum.Font.GothamMedium; box.TextSize = 13
    box.BorderSizePixel = 0; box.ClearTextOnFocus = false; box.Parent = parent
    corner(box, 8)
    box.FocusLost:Connect(function(enter)
        if enter and callback then callback(box.Text) end
    end)
end

-- สร้างแท็บ
createPage("Combat");   createTab("Combat", "C")
createPage("Visual");   createTab("Visual", "V")
createPage("Player");   createTab("Player", "P")
createPage("Troll");    createTab("Troll", "T")
createPage("Teleport"); createTab("Teleport", "L")
createPage("Farm");     createTab("Farm", "F")
createPage("Misc");     createTab("Misc", "M")
createPage("Settings"); createTab("Settings", "S")

print("✅ Part 1 (UI) โหลดแล้ว")

-- ==================================================
--  🎯 PART 1.25  |  Remotes + Config + State + Utils
-- ==================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")

-- ===== Remotes =====
local remotes  = ReplicatedStorage:WaitForChild("Remotes", 10)
local gameplay = remotes and remotes:WaitForChild("Gameplay", 10)
local extras   = remotes and remotes:FindFirstChild("Extras")
local RF_PlayerData    = gameplay and gameplay:FindFirstChild("GetCurrentPlayerData")
local RE_CoinCollected = gameplay and gameplay:FindFirstChild("CoinCollected")
local RE_CoinsStarted  = gameplay and gameplay:FindFirstChild("CoinsStarted")
local RE_RoundStart    = gameplay and gameplay:FindFirstChild("RoundStart")
local RF_RedeemCode    = extras and extras:FindFirstChild("RedeemCode")

-- ===== Config =====
local MC = {
    RoleRefresh = 1,
    ShootStands = {
        Vector3.new(0,0,6), Vector3.new(0,0,-6),
        Vector3.new(6,0,0), Vector3.new(-6,0,0), Vector3.new(0,6,3),
    },
    ShootSettle = 0.25, ShootReturn = 0.3, ShootCooldown = 1.2,
    ShootConfirm = 0.8, ShootAttempts = 3,
    StabOffset = 2, StabCooldown = 0.9, KillAuraRange = 18,
    GunGrabHold = 0.35, BusyTimeout = 6,
    FarmSpeed = 25, FarmArrive = 1.5, FarmBrake = 20,
    FarmSkipTime = 4, FarmMurdererRadius = 30,
    DodgeRange = 22, DodgeCooldown = 2.5,
    FlingVelocityCap = 120, FlingForce = 9e4, FlingTime = 2.5,
    XRayTransparency = 0.6, FlySpeed = 70,
    SpeedDefault = 16, JumpDefault = 50,
    RoleColors = {
        Murderer = Color3.fromRGB(255,60,60),
        Sheriff  = Color3.fromRGB(60,160,255),
        Hero     = Color3.fromRGB(255,200,60),
        Innocent = Color3.fromRGB(120,240,150),
        Gun      = Color3.fromRGB(255,200,60),
    },
}

-- ===== State =====
local MS = {
    Alive = true, Conns = {}, Roles = {},
    LastRoleFetch = 0, LastShoot = 0, LastStab = 0,
    ActionBusy = false, BusySince = 0,
    ShootBusy = false, LastDodge = 0,
    FarmBusy = false, FarmHome = nil, FarmMover = nil,
    Bag = { Current = 0, Max = 0 },
    SkippedCoins = {},
    XRayMap = nil, XRayParts = {},
    KillBusy = false,
    NoclipConn = nil, NoclipSaved = {},
    FlyConn = nil, FlyVelocity = nil,
    StickTarget = nil, AimHook = nil,
    Esp = { Players = {}, Gun = nil, Folder = nil },
    LightingDefaults = nil,
    Opt = {
        Aimbot = false, AimSmooth = 70,
        SilentAim = false, KnifeAim = false,
        AutoShoot = false, AutoGrabGun = false,
        AutoKillAll = false, KillAura = false,
        EspPlayers = false, EspGun = false, RoleNotify = false,
        XRay = false, Fullbright = false, FovCircle = false,
        SpeedOn = false, WalkSpeed = 24,
        JumpOn = false, JumpPower = 70,
        InfJump = false, Noclip = false, Fly = false,
        AntiFling = false,
        AutoFarm = false, FarmSpeed = 25, ResetWhenFull = false,
        AutoDodge = false,
        AntiAfk = false,
        TrollTarget = nil, TeleportTarget = nil,
    },
}

-- ===== Util =====
local function Try(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[MM2]", err) end
    return ok, err
end

local function Connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(MS.Conns, c)
    return c
end

local function RootOf(plr)
    local ch = (plr or LP).Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function HumOf(plr)
    local ch = (plr or LP).Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local function ToolOf(plr, name)
    local ch = plr.Character
    local bp = plr:FindFirstChild("Backpack")
    return (ch and ch:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end

local function Busy()
    return MS.ActionBusy and os.clock() - MS.BusySince < MC.BusyTimeout
end

local function SetBusy(v)
    MS.ActionBusy = v
    MS.BusySince = os.clock()
end

local function WarpAndReturn(cframe, action)
    local root = RootOf()
    if not root or not cframe or Busy() then return false end
    SetBusy(true)
    local home = root.CFrame
    local ok = Try(function()
        root.CFrame = cframe
        root.AssemblyLinearVelocity = Vector3.zero
        action()
    end)
    local cur = RootOf()
    if cur then cur.CFrame = home end
    SetBusy(false)
    return ok
end

local function IsDead(plr)
    local h = HumOf(plr)
    return not h or h.Health <= 0
end

-- ===== Round =====
local function RefreshRoles()
    if os.clock() - MS.LastRoleFetch < MC.RoleRefresh then return end
    MS.LastRoleFetch = os.clock()
    if not RF_PlayerData then return end
    local ok, roster = pcall(RF_PlayerData.InvokeServer, RF_PlayerData)
    if ok and type(roster) == "table" then MS.Roles = roster end
end

local function RoleOf(plr)
    local entry = MS.Roles[plr.Name]
    if entry and not entry.Dead and entry.Role then return entry.Role end
    if ToolOf(plr, "Knife") then return "Murderer" end
    if ToolOf(plr, "Gun") then return "Sheriff" end
    return entry and entry.Dead and "Dead" or "Innocent"
end

local function FindByRole(role)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and RoleOf(plr) == role and RootOf(plr) then
            return plr
        end
    end
    return nil
end

local function Map()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name ~= "RegularLobby" and child:IsA("Model") and child:FindFirstChild("CoinContainer") then
            return child
        end
    end
    return nil
end

local function Lobby()
    local l = workspace:FindFirstChild("RegularLobby")
    if l then return l end
    for _, c in ipairs(workspace:GetChildren()) do
        if c:IsA("Model") and c.Name:find("Lobby") then return c end
    end
    return nil
end

local function IAmPlaying()
    local entry = MS.Roles[LP.Name]
    local h = HumOf()
    return Map() ~= nil and h ~= nil and h.Health > 0 and entry ~= nil and not entry.Dead
end

local function GunDrop()
    local m = Map()
    return (m and m:FindFirstChild("GunDrop", true)) or workspace:FindFirstChild("GunDrop")
end

print("✅ Part 1.25 (Remotes + Config + Utils) โหลดแล้ว")

-- ==================================================
--  🎯 PART 1.5  |  Combat Systems
-- ==================================================

-- ===== Sheriff =====
local function Gun() return ToolOf(LP, "Gun") end

local function Equip(tool)
    local h = HumOf()
    if h and tool.Parent ~= LP.Character then
        h:EquipTool(tool)
    end
end

local function ClearStand(target, targetRoot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LP.Character, target.Character }
    for _, offset in ipairs(MC.ShootStands) do
        local pos = (targetRoot.CFrame * CFrame.new(offset)).Position
        if not workspace:Raycast(pos, targetRoot.Position - pos, params) then
            return CFrame.lookAt(pos, targetRoot.Position)
        end
    end
    return CFrame.lookAt((targetRoot.CFrame * CFrame.new(MC.ShootStands[1])).Position, targetRoot.Position)
end

local function ShootTarget(target)
    local g, tRoot = Gun(), RootOf(target)
    if not g or not tRoot or os.clock() - MS.LastShoot < MC.ShootCooldown then
        return false
    end
    MS.LastShoot = os.clock()
    Equip(g)
    return WarpAndReturn(ClearStand(target, tRoot), function()
        task.wait(MC.ShootSettle)
        local root = RootOf()
        local att = root and root:FindFirstChild("GunRaycastAttachment")
        local aimRoot = RootOf(target) or tRoot
        g.Shoot:FireServer(att and att.WorldCFrame or root.CFrame, aimRoot.CFrame)
        task.wait(MC.ShootReturn)
    end)
end

local function ShootMurderer()
    RefreshRoles()
    local m = FindByRole("Murderer")
    if not m then return false, "ไม่พบฆาตกร" end
    for _ = 1, MC.ShootAttempts do
        if not Gun() then break end
        ShootTarget(m)
        task.wait(MC.ShootConfirm)
        if IsDead(m) then return true, m.Name end
        task.wait(math.max(0, MC.ShootCooldown - MC.ShootConfirm))
    end
    return false, m.Name .. " รอด"
end

local function AutoShootStep()
    if not MS.Opt.AutoShoot or MS.ShootBusy or not Gun() or not IAmPlaying() then
        return
    end
    MS.ShootBusy = true
    task.spawn(function()
        Try(ShootMurderer)
        MS.ShootBusy = false
    end)
end

local function GrabGun()
    local drop = GunDrop()
    if not drop or Gun() or not IAmPlaying() then return false end
    local part = drop:IsA("BasePart") and drop or drop:FindFirstChildWhichIsA("BasePart", true)
    if not part then return false end
    return WarpAndReturn(part.CFrame, function()
        local root = RootOf()
        if root and firetouchinterest then
            firetouchinterest(root, part, 0)
            firetouchinterest(root, part, 1)
        end
        task.wait(MC.GunGrabHold)
    end)
end

local function AutoGrabStep()
    if MS.Opt.AutoGrabGun and RoleOf(LP) ~= "Murderer" and GunDrop() then
        task.spawn(GrabGun)
    end
end

-- ===== Murderer =====
local function Knife() return ToolOf(LP, "Knife") end

local function Stab(target)
    local k, tRoot = Knife(), RootOf(target)
    if not k or not tRoot then return false end
    Equip(k)
    local ev = k:FindFirstChild("Events")
    if not ev then return false end
    local stand = tRoot.CFrame * CFrame.new(0, 0, MC.StabOffset)
    return WarpAndReturn(stand, function()
        ev.KnifeStabbed:FireServer()
        task.wait()
        local aimRoot = RootOf(target) or tRoot
        ev.HandleTouched:FireServer(aimRoot)
        task.wait(MC.StabCooldown)
    end)
end

local function Victims()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local h = HumOf(plr)
        local entry = MS.Roles[plr.Name]
        local inRound = entry == nil or not entry.Dead
        if plr ~= LP and h and h.Health > 0 and inRound and RootOf(plr) then
            table.insert(list, plr)
        end
    end
    return list
end

local function KillAll()
    if not Knife() then return 0 end
    local n = 0
    for _, v in ipairs(Victims()) do
        if not MS.Alive or not Knife() then break end
        if Stab(v) then n = n + 1 end
    end
    return n
end

local function AutoKillStep()
    if not MS.Opt.AutoKillAll or MS.KillBusy or not Knife() or not IAmPlaying() then
        return
    end
    MS.KillBusy = true
    task.spawn(function()
        Try(KillAll)
        MS.KillBusy = false
    end)
end

local function KillAuraStep()
    local k, root = Knife(), RootOf()
    if not MS.Opt.KillAura or not k or not root
        or os.clock() - MS.LastStab < MC.StabCooldown then
        return
    end
    local ev = k:FindFirstChild("Events")
    for _, v in ipairs(Victims()) do
        local vRoot = RootOf(v)
        if ev and vRoot
            and (vRoot.Position - root.Position).Magnitude <= MC.KillAuraRange then
            MS.LastStab = os.clock()
            Equip(k)
            ev.KnifeStabbed:FireServer()
            ev.HandleTouched:FireServer(vRoot)
            return
        end
    end
end

local function NearestVictimRoot(origin)
    local best, bestD
    for _, v in ipairs(Victims()) do
        local vRoot = RootOf(v)
        local d = vRoot and (vRoot.Position - origin).Magnitude
        if d and (not bestD or d < bestD) then
            best, bestD = vRoot, d
        end
    end
    return best
end

-- ===== Aim Hook (Silent Aim / Knife Throw Aim) =====
local function InstallAimHook()
    if not hookmetamethod or not getnamecallmethod or not checkcaller then return end
    local original, restore
    original, restore = hookmetamethod(game, "__namecall", function(self, ...)
        if not MS.Alive or getnamecallmethod() ~= "FireServer" or checkcaller() then
            return original(self, ...)
        end
        local parent = self.Parent
        local opt = MS.Opt
        if opt.SilentAim and self.Name == "Shoot" and parent and parent.Name == "Gun" then
            local m = FindByRole("Murderer")
            local mRoot = m and RootOf(m)
            if mRoot then
                local origin = ...
                return original(self, origin, mRoot.CFrame)
            end
        elseif opt.KnifeAim and self.Name == "KnifeThrown"
            and parent and parent.Name == "Events" then
            local origin = ...
            local vRoot = NearestVictimRoot(origin.Position)
            if vRoot then
                return original(self, origin, vRoot.Position)
            end
        end
        return original(self, ...)
    end)
    MS.AimHook = restore
end

local function SyncAimHook()
    local wanted = MS.Alive and (MS.Opt.SilentAim or MS.Opt.KnifeAim)
    if wanted and not MS.AimHook then
        Try(InstallAimHook)
    elseif not wanted and MS.AimHook then
        local restore = MS.AimHook
        MS.AimHook = nil
        Try(restore)
    end
end

-- ===== Aimbot (Camera) =====
local function AimTarget()
    if Knife() then
        local v = Victims()
        return v[1]
    end
    return FindByRole("Murderer")
end

local function AimStep(dt)
    if not MS.Opt.Aimbot then return end
    local t = AimTarget()
    local head = t and t.Character and t.Character:FindFirstChild("Head")
    if not head then return end
    local cam = workspace.CurrentCamera
    local goal = CFrame.lookAt(cam.CFrame.Position, head.Position)
    local alpha = 1 - (MS.Opt.AimSmooth / 100) ^ (dt * 60)
    cam.CFrame = cam.CFrame:Lerp(goal, math.clamp(alpha, 0, 1))
end

-- ===== Auto Dodge =====
local function SafestSpot(threatPos)
    local m = Map()
    local best, bestD
    for _, coin in ipairs(m and m.CoinContainer:GetChildren() or {}) do
        if coin:IsA("BasePart") then
            local d = (coin.Position - threatPos).Magnitude
            if not bestD or d > bestD then best, bestD = coin, d end
        end
    end
    return best and CFrame.new(best.Position + Vector3.new(0, 3, 0))
end

local function DodgeStep()
    local root = RootOf()
    local m = FindByRole("Murderer")
    local threat = m and RootOf(m)
    if not MS.Opt.AutoDodge or not root or not threat or Knife() or Busy() then
        return
    end
    if os.clock() - MS.LastDodge < MC.DodgeCooldown
        or (threat.Position - root.Position).Magnitude > MC.DodgeRange then
        return
    end
    local spot = SafestSpot(threat.Position)
    if spot then
        MS.LastDodge = os.clock()
        root.CFrame = spot
        root.AssemblyLinearVelocity = Vector3.zero
    end
end

print("✅ Part 1.5 (Combat) โหลดแล้ว")

-- ==================================================
--  🎯 PART 1.75  |  Farm + Movement + Visual
-- ==================================================

-- ===== Farm =====
local function NearestCoin(map, origin)
    local m = not Knife() and FindByRole("Murderer")
    local threat = m and RootOf(m)
    local best, bestD
    for _, coin in ipairs(map.CoinContainer:GetChildren()) do
        local vis = coin:FindFirstChild("CoinVisual")
        local skippedAt = MS.SkippedCoins[coin]
        local skipped = skippedAt and os.clock() - skippedAt < MC.FarmSkipTime
        local danger = threat and (coin.Position - threat.Position).Magnitude < MC.FarmMurdererRadius
        if coin:IsA("BasePart") and vis
            and not vis:GetAttribute("Collected")
            and not skipped and not danger then
            local d = (coin.Position - origin).Magnitude
            if not bestD or d < bestD then best, bestD = coin, d end
        end
    end
    return best
end

local function BagFull()
    return MS.Bag.Max > 0 and MS.Bag.Current >= MS.Bag.Max
end

local function FarmCanRun()
    return MS.Alive and MS.Opt.AutoFarm and IAmPlaying() and not BagFull()
end

local function AttachMover(root)
    local att = Instance.new("Attachment")
    att.Parent = root
    local mover = Instance.new("LinearVelocity")
    mover.Attachment0 = att
    mover.MaxForce = math.huge
    mover.RelativeTo = Enum.ActuatorRelativeTo.World
    mover.VectorVelocity = Vector3.zero
    mover.Parent = root
    MS.FarmMover = { Attachment = att, Velocity = mover }
    return mover
end

local function DetachMover()
    local m = MS.FarmMover
    if m then
        m.Velocity:Destroy()
        m.Attachment:Destroy()
        MS.FarmMover = nil
    end
end

local function GlideTo(pos)
    local root = RootOf()
    local mover = MS.FarmMover
    if not root or not mover or mover.Velocity.Parent ~= root then
        DetachMover()
        mover = root and { Velocity = AttachMover(root) }
    end
    while mover and FarmCanRun() and root.Parent do
        local delta = pos - root.Position
        if delta.Magnitude <= MC.FarmArrive then break end
        mover.Velocity.VectorVelocity = delta.Unit * math.min(MS.Opt.FarmSpeed, delta.Magnitude * MC.FarmBrake)
        RunService.Heartbeat:Wait()
    end
    if mover then mover.Velocity.VectorVelocity = Vector3.zero end
end

local function FarmRun()
    local root = RootOf()
    if root then AttachMover(root) end
    RefreshNoclip()
    MS.FarmHome = root and root.CFrame
    while FarmCanRun() do
        local map, hrp = Map(), RootOf()
        local coin = map and hrp and NearestCoin(map, hrp.Position)
        if coin and not Busy() then
            GlideTo(coin.Position)
            task.wait(0.15)
            MS.SkippedCoins[coin] = os.clock()
        else
            local m = MS.FarmMover
            if m then m.Velocity.VectorVelocity = Vector3.zero end
            task.wait(0.3)
        end
    end
end

local function FarmSettle()
    local root, home = RootOf(), MS.FarmHome
    MS.FarmHome = nil
    if not root then return end
    root.AssemblyLinearVelocity = Vector3.zero
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LP.Character }
    local ground = workspace:Raycast(root.Position + Vector3.new(0, 4, 0), Vector3.new(0, -400, 0), params)
    if ground or not home then return end
    root.CFrame = home
end

local function FarmStep()
    if MS.FarmBusy or not FarmCanRun() then return end
    MS.FarmBusy = true
    task.spawn(function()
        local ok = Try(FarmRun)
        DetachMover()
        FarmSettle()
        MS.FarmBusy = false
        RefreshNoclip()
        local h = HumOf()
        if ok and h and MS.Opt.ResetWhenFull and BagFull() then
            h.Health = 0
        end
    end)
end

local function InitBagTracking()
    if RE_CoinCollected then
        Connect(RE_CoinCollected.OnClientEvent, function(_, cur, max)
            MS.Bag.Current = tonumber(cur) or 0
            MS.Bag.Max = tonumber(max) or 0
        end)
    end
    if RE_CoinsStarted then
        Connect(RE_CoinsStarted.OnClientEvent, function()
            MS.Bag.Current, MS.Bag.Max = 0, 0
            table.clear(MS.SkippedCoins)
        end)
    end
    if not RE_RoundStart then return end
    Connect(RE_RoundStart.OnClientEvent, function()
        MS.Bag.Current, MS.Bag.Max = 0, 0
        table.clear(MS.Roles)
    end)
end

-- ===== Movement =====
local function SetNoclip(enabled)
    if MS.NoclipConn then
        MS.NoclipConn:Disconnect()
        MS.NoclipConn = nil
    end
    if not enabled then
        for part, cc in pairs(MS.NoclipSaved) do
            if part.Parent then part.CanCollide = cc end
        end
        table.clear(MS.NoclipSaved)
        return
    end
    MS.NoclipConn = Connect(RunService.Stepped, function()
        local ch = LP.Character
        if not ch then return end
        for _, part in ipairs(ch:GetChildren()) do
            if part:IsA("BasePart") then
                if MS.NoclipSaved[part] == nil then
                    MS.NoclipSaved[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end)
end

function RefreshNoclip()
    SetNoclip(MS.Opt.Noclip or MS.FarmBusy)
end

local function MovementApply()
    local h = HumOf()
    if not h then return end
    if MS.Opt.SpeedOn then h.WalkSpeed = MS.Opt.WalkSpeed end
    if MS.Opt.JumpOn then
        h.UseJumpPower = true
        h.JumpPower = MS.Opt.JumpPower
    end
end

local function RestoreSpeed()
    local h = HumOf()
    if h then h.WalkSpeed = MC.SpeedDefault end
end

local function RestoreJump()
    local h = HumOf()
    if h then h.JumpPower = MC.JumpDefault end
end

local function InitInfJump()
    Connect(UserInputService.JumpRequest, function()
        local h = HumOf()
        if MS.Opt.InfJump and h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function SetFly(enabled)
    if MS.FlyConn then MS.FlyConn:Disconnect(); MS.FlyConn = nil end
    if MS.FlyVelocity then MS.FlyVelocity:Destroy(); MS.FlyVelocity = nil end
    local h = HumOf()
    if h then h.PlatformStand = false end
    if not enabled then return end
    local mover = Instance.new("BodyVelocity")
    mover.MaxForce = Vector3.one * 1e9
    mover.Velocity = Vector3.zero
    MS.FlyVelocity = mover
    MS.FlyConn = Connect(RunService.RenderStepped, function()
        local root, hum = RootOf(), HumOf()
        if not root or not hum then return end
        mover.Parent = root
        hum.PlatformStand = true
        local v = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0)
                - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0)
        mover.Velocity = (hum.MoveDirection + Vector3.yAxis * v) * MC.FlySpeed
    end)
end

local function AntiFlingStep()
    if not MS.Opt.AntiFling then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        local ch = plr ~= LP and plr.Character
        if ch then
            for _, part in ipairs(ch:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
    local root = RootOf()
    if root and not Busy() and not MS.Opt.Fly
        and root.AssemblyLinearVelocity.Magnitude > MC.FlingVelocityCap then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ===== Visual =====
local function SetFullbright(enabled)
    if enabled and not MS.LightingDefaults then
        MS.LightingDefaults = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows,
        }
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e9
        Lighting.GlobalShadows = false
    elseif not enabled and MS.LightingDefaults then
        for k, v in pairs(MS.LightingDefaults) do Lighting[k] = v end
        MS.LightingDefaults = nil
    end
end

local function ClearXRay()
    for part, orig in pairs(MS.XRayParts) do
        if part.Parent then part.Transparency = orig end
    end
    table.clear(MS.XRayParts)
    MS.XRayMap = nil
end

local function XRayStep()
    if not MS.Opt.XRay then
        if MS.XRayMap then ClearXRay() end
        return
    end
    local map = Map() or Lobby()
    if not map or MS.XRayMap == map then return end
    ClearXRay()
    MS.XRayMap = map
    local coins = map:FindFirstChild("CoinContainer")
    for _, part in ipairs(map:GetDescendants()) do
        if part:IsA("BasePart") and not (coins and part:IsDescendantOf(coins)) then
            MS.XRayParts[part] = part.Transparency
            part.Transparency = math.max(part.Transparency, MC.XRayTransparency)
        end
    end
end

-- ===== ESP =====
local function EspInit()
    MS.Esp.Folder = Instance.new("Folder")
    MS.Esp.Folder.Name = "\0PHURI_ESP"
    pcall(function() MS.Esp.Folder.Parent = game:GetService("CoreGui") end)
    if not MS.Esp.Folder.Parent then
        MS.Esp.Folder.Parent = LP:WaitForChild("PlayerGui")
    end
end

local function MakeHighlight(adornee, color)
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.65
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = adornee
    h.Parent = MS.Esp.Folder
    return h
end

local function MakeLabel(adornee, color)
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.fromOffset(180, 36)
    gui.StudsOffset = Vector3.new(0, 3.5, 0)
    gui.AlwaysOnTop = true
    gui.Adornee = adornee
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.4
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = gui
    gui.Parent = MS.Esp.Folder
    return gui, label
end

local function DropEntry(entry)
    if entry then
        entry.Highlight:Destroy()
        entry.Gui:Destroy()
    end
end

local function RefreshPlayers()
    local entries = MS.Esp.Players
    local myRoot = RootOf()
    for _, plr in ipairs(Players:GetPlayers()) do
        local ch, root = plr.Character, RootOf(plr)
        local entry = entries[plr]
        local role = RoleOf(plr)
        local visible = MS.Opt.EspPlayers and plr ~= LP and ch and root and role ~= "Dead"
        if not visible then
            DropEntry(entry)
            entries[plr] = nil
        else
            if not entry or entry.Character ~= ch then
                DropEntry(entry)
                local gui, label = MakeLabel(root, Color3.new(1, 1, 1))
                entry = {
                    Character = ch,
                    Highlight = MakeHighlight(ch, Color3.new(1, 1, 1)),
                    Gui = gui,
                    Label = label,
                }
                entries[plr] = entry
            end
            local color = MC.RoleColors[role] or MC.RoleColors.Innocent
            local dist = myRoot and math.floor((root.Position - myRoot.Position).Magnitude) or 0
            entry.Highlight.FillColor = color
            entry.Highlight.OutlineColor = color
            entry.Label.TextColor3 = color
            entry.Label.Text = string.format("%s [%s] %dm", plr.DisplayName, role, dist)
        end
    end
    for plr, entry in pairs(entries) do
        if not plr.Parent then
            DropEntry(entry)
            entries[plr] = nil
        end
    end
end

local function RefreshGun()
    local drop = MS.Opt.EspGun and GunDrop()
    local entry = MS.Esp.Gun
    if entry and entry.Adornee == drop then return end
    DropEntry(entry)
    MS.Esp.Gun = nil
    if drop then
        local gui, label = MakeLabel(drop, MC.RoleColors.Gun)
        label.Text = "GUN DROP"
        MS.Esp.Gun = {
            Adornee = drop,
            Highlight = MakeHighlight(drop, MC.RoleColors.Gun),
            Gui = gui,
        }
    end
end

local function EspDestroy()
    if MS.Esp.Folder then MS.Esp.Folder:Destroy() end
    table.clear(MS.Esp.Players)
    MS.Esp.Gun = nil
end

print("✅ Part 1.75 (Farm + Movement + Visual) โหลดแล้ว")

-- ==================================================
--  🎯 PART 2  |  Troll + Teleport + Session + Scheduler
-- ==================================================

-- ===== Troll =====
local function TrollTarget()
    return MS.Opt.TrollTarget and Players:FindFirstChild(MS.Opt.TrollTarget)
end

local function Fling(target)
    local root, tRoot = RootOf(), RootOf(target)
    if not root or not tRoot or Busy() then return false end
    SetBusy(true)
    local home = root.CFrame
    local spin = Instance.new("BodyAngularVelocity")
    spin.MaxTorque = Vector3.one * math.huge
    spin.AngularVelocity = Vector3.new(0, MC.FlingForce, 0)
    spin.Parent = root
    SetNoclip(true)
    local started = os.clock()
    while os.clock() - started < MC.FlingTime do
        local cur = RootOf(target)
        if not cur or not root.Parent then break end
        root.CFrame = cur.CFrame
        root.AssemblyLinearVelocity = Vector3.zero
        RunService.Heartbeat:Wait()
    end
    spin:Destroy()
    if root.Parent then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = home
    end
    SetBusy(false)
    RefreshNoclip()
    return true
end

local function Spectate(target)
    local h = target and HumOf(target) or HumOf()
    if h then workspace.CurrentCamera.CameraSubject = h end
end

local function StickStep()
    local target = MS.StickTarget and Players:FindFirstChild(MS.StickTarget)
    local root, tRoot = RootOf(), target and RootOf(target)
    if root and tRoot and not Busy() then
        root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2)
    end
end

-- ===== Teleport =====
local function TpTo(cframe)
    local root = RootOf()
    if root and cframe then
        root.CFrame = cframe + Vector3.new(0, 3, 0)
        return true
    end
    return false
end

local function TpToPlayer(name)
    local plr = name and Players:FindFirstChild(name)
    local root = plr and RootOf(plr)
    return TpTo(root and root.CFrame)
end

local function TpToLobby()
    local l = Lobby()
    local sp = l and (l:FindFirstChild("Spawns", true)
        or l:FindFirstChildWhichIsA("SpawnLocation", true))
    local part = sp and (sp:IsA("BasePart") and sp
        or sp:FindFirstChildWhichIsA("BasePart"))
    if not part and l then
        part = l:FindFirstChildWhichIsA("BasePart", true)
    end
    return TpTo(part and part.CFrame)
end

local function TpToMap()
    local m = Map()
    local sp = m and m:FindFirstChild("Spawns")
    local part = sp and sp:FindFirstChildWhichIsA("BasePart")
        or (m and m.CoinContainer:FindFirstChildWhichIsA("BasePart"))
    return TpTo(part and part.CFrame)
end

-- ===== Session =====
local function RedeemCode(code)
    if not RF_RedeemCode then return "ไม่พบ remote โค้ด" end
    local ok, msg = pcall(RF_RedeemCode.InvokeServer, RF_RedeemCode, code)
    return ok and tostring(msg) or "คำขอล้มเหลว"
end

local function SessionRejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end

local function SessionHop()
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100",
        game.PlaceId)
    local ok, body = pcall(game.HttpGet, game, url)
    if not ok or not body then return end
    local ok2, servers = pcall(HttpService.JSONDecode, HttpService, body)
    if not ok2 or type(servers) ~= "table" then return end
    for _, s in ipairs(servers.data or {}) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
            return
        end
    end
end

local function InitAntiAfk()
    Connect(LP.Idled, function()
        if MS.Opt.AntiAfk then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

local function InitRoleNotify()
    if not RE_RoundStart then return end
    Connect(RE_RoundStart.OnClientEvent, function()
        task.wait(2)
        MS.LastRoleFetch = 0
        RefreshRoles()
        if not MS.Opt.RoleNotify then return end
        local m, s = FindByRole("Murderer"), FindByRole("Sheriff")
        notify(string.format("🔪 %s  |  🔫 %s  |  You: %s",
            m and m.Name or "?",
            s and s.Name or "?",
            RoleOf(LP)))
    end)
end

-- ===== Scheduler =====
local function RunJob(name, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[MM2] " .. name .. ":", err) end
end

local function SchedulerBoot()
    EspInit()
    InitBagTracking()
    InitInfJump()
    InitAntiAfk()
    InitRoleNotify()

    -- Tick lane (ทุก 0.5 วิ)
    task.spawn(function()
        while MS.Alive do
            RunJob("Roles", RefreshRoles)
            RunJob("Farm", FarmStep)
            RunJob("XRay", XRayStep)
            RunJob("Movement", MovementApply)
            RunJob("AutoGrab", AutoGrabStep)
            RunJob("AutoShoot", AutoShootStep)
            RunJob("AutoKill", AutoKillStep)
            RunJob("ESP-Players", RefreshPlayers)
            RunJob("ESP-Gun", RefreshGun)
            task.wait(0.5)
        end
    end)

    -- Stepped lane (ทุกเฟรม)
    Connect(RunService.Stepped, function()
        RunJob("AntiFling", AntiFlingStep)
    end)

    -- Render lane
    Connect(RunService.RenderStepped, function(dt)
        RunJob("Aimbot", AimStep, dt)
    end)

    -- Heartbeat lane
    Connect(RunService.Heartbeat, function()
        RunJob("KillAura", KillAuraStep)
        RunJob("Dodge", DodgeStep)
        RunJob("Stick", StickStep)
    end)
end

local function SchedulerStop()
    MS.Alive = false
    SyncAimHook()
    MS.StickTarget = nil
    SetFly(false)
    SetNoclip(false)
    for _, c in ipairs(MS.Conns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(MS.Conns)
    if MS.Opt.SpeedOn then RestoreSpeed() end
    if MS.Opt.JumpOn then RestoreJump() end
    Spectate(nil)
    SetFullbright(false)
    ClearXRay()
    DetachMover()
    EspDestroy()
end

print("✅ Part 2 (Troll + Teleport + Session + Scheduler) โหลดแล้ว")

-- ==================================================
--  🎯 PART 3  |  UI Tabs ทั้งหมด
-- ==================================================

-- ===== COMBAT TAB =====
do
    local p = pages["Combat"]
    createSection(p, "Aimbot (ล็อกกล้อง)")
    createToggle(p, "Aimbot", false, function(v) MS.Opt.Aimbot = v end)
    createSlider(p, "Smoothness", 0, 95, 70, function(v) MS.Opt.AimSmooth = v end)

    createSection(p, "Silent Aim (ยิงล็อกเป้า)")
    createToggle(p, "Silent Aim (Murderer)", false, function(v)
        MS.Opt.SilentAim = v; SyncAimHook()
    end)
    createToggle(p, "Knife Throw Aim", false, function(v)
        MS.Opt.KnifeAim = v; SyncAimHook()
    end)

    createSection(p, "Sheriff")
    createToggle(p, "Auto Shoot Murderer", false, function(v) MS.Opt.AutoShoot = v end)
    createToggle(p, "Auto Grab Gun", false, function(v) MS.Opt.AutoGrabGun = v end)
    createButton(p, "Shoot Murderer Now", function()
        local ok, detail = ShootMurderer()
        notify(ok and ("ยิงโดน " .. tostring(detail)) or tostring(detail), ok and 3 or 4)
    end, Color3.fromRGB(80,60,160))
    createButton(p, "Grab Gun Now", function()
        local got = GrabGun()
        notify(got and "เก็บปืนแล้ว" or "ไม่พบปืนตก", 3)
    end)

    createSection(p, "Murderer")
    createToggle(p, "Auto Kill All", false, function(v) MS.Opt.AutoKillAll = v end)
    createToggle(p, "Kill Aura", false, function(v) MS.Opt.KillAura = v end)
    createButton(p, "Kill All Now", function()
        task.spawn(function()
            notify("ฆ่าไป " .. KillAll() .. " คน", 3)
        end)
    end, Color3.fromRGB(180,60,60))

    createSection(p, "Survive")
    createToggle(p, "Auto Dodge Murderer", false, function(v) MS.Opt.AutoDodge = v end)
end

-- ===== VISUAL TAB =====
do
    local p = pages["Visual"]
    createSection(p, "ESP")
    createToggle(p, "Role ESP", false, function(v) MS.Opt.EspPlayers = v end)
    createToggle(p, "Gun Drop ESP", false, function(v) MS.Opt.EspGun = v end)
    createToggle(p, "Role Notify", false, function(v) MS.Opt.RoleNotify = v end)

    createSection(p, "World")
    createToggle(p, "X-Ray (มองทะลุกำแพง)", false, function(v) MS.Opt.XRay = v end)
    createToggle(p, "Fullbright", false, function(v)
        MS.Opt.Fullbright = v
        SetFullbright(v)
        notify("Fullbright: " .. (v and "ON" or "OFF"))
    end)
    createToggle(p, "FOV Circle", false, function(v) MS.Opt.FovCircle = v end)
end

-- ===== PLAYER TAB =====
do
    local p = pages["Player"]
    createSection(p, "การเคลื่อนไหว")
    createToggle(p, "Walk Speed", false, function(v)
        MS.Opt.SpeedOn = v
        if not v then RestoreSpeed() end
    end)
    createSlider(p, "Speed", 16, 120, 24, function(v) MS.Opt.WalkSpeed = v end)

    createToggle(p, "Jump Power", false, function(v)
        MS.Opt.JumpOn = v
        if not v then RestoreJump() end
    end)
    createSlider(p, "Power", 50, 200, 70, function(v) MS.Opt.JumpPower = v end)

    createSection(p, "พิเศษ")
    createToggle(p, "Infinite Jump", false, function(v) MS.Opt.InfJump = v end)
    createToggle(p, "Noclip", false, function(v)
        MS.Opt.Noclip = v
        RefreshNoclip()
    end)
    createToggle(p, "Fly (Space=ขึ้น, L.Ctrl=ลง)", false, function(v)
        MS.Opt.Fly = v
        SetFly(v)
    end)
    createToggle(p, "Anti-Fling", false, function(v) MS.Opt.AntiFling = v end)
end

-- ===== TROLL TAB =====
do
    local p = pages["Troll"]
    createSection(p, "เลือกเป้าหมาย")
    local selectedTarget = nil
    createTextbox(p, "พิมพ์ชื่อผู้เล่น", function(txt)
        selectedTarget = txt
        MS.Opt.TrollTarget = txt
        MS.Opt.TeleportTarget = txt
        notify("เลือก: " .. txt)
    end)
    createButton(p, "Fling เป้าหมาย", function()
        if selectedTarget then
            task.spawn(Fling, Players:FindFirstChild(selectedTarget))
        else
            notify("ยังไม่ได้เลือกเป้าหมาย")
        end
    end, Color3.fromRGB(180,80,180))
    createButton(p, "Fling ฆาตกร", function()
        task.spawn(Fling, FindByRole("Murderer"))
    end)
    createButton(p, "Fling ทุกคน", function()
        task.spawn(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and RootOf(plr) then Fling(plr) end
            end
        end)
    end, Color3.fromRGB(200,60,60))

    createSection(p, "ติดตาม")
    createToggle(p, "Stick To Target", false, function(v)
        MS.StickTarget = v and selectedTarget or nil
    end)
    createToggle(p, "Spectate Target", false, function(v)
        Spectate(v and Players:FindFirstChild(selectedTarget) or nil)
    end)
end

-- ===== TELEPORT TAB =====
do
    local p = pages["Teleport"]
    createSection(p, "สถานที่")
    createButton(p, "ไป Lobby", function()
        TpToLobby()
        notify("วาร์ปไป Lobby")
    end, Color3.fromRGB(60,120,180))
    createButton(p, "ไป Map", function()
        TpToMap()
        notify("วาร์ปไป Map")
    end, Color3.fromRGB(60,140,180))
    createButton(p, "ไปหาฆาตกร", function()
        local t = FindByRole("Murderer")
        if t then TpToPlayer(t.Name); notify("วาร์ปไปหา " .. t.Name)
        else notify("ไม่พบฆาตกร") end
    end)
    createButton(p, "ไปหานายอำเภอ", function()
        local t = FindByRole("Sheriff")
        if t then TpToPlayer(t.Name); notify("วาร์ปไปหา " .. t.Name)
        else notify("ไม่พบนายอำเภอ") end
    end)

    createSection(p, "ไปหาผู้เล่น")
    createTextbox(p, "พิมพ์ชื่อผู้เล่น", function(txt)
        local ok = TpToPlayer(txt)
        notify(ok and ("วาร์ปไปหา " .. txt) or "ไม่พบผู้เล่น")
    end)
end

-- ===== FARM TAB =====
do
    local p = pages["Farm"]
    createSection(p, "Coin Farm")
    createToggle(p, "Auto Farm Coins", false, function(v) MS.Opt.AutoFarm = v end)
    createSlider(p, "Farm Speed", 16, 28, 25, function(v) MS.Opt.FarmSpeed = v end)
    createToggle(p, "Reset When Bag Full", false, function(v) MS.Opt.ResetWhenFull = v end)

    createSection(p, "สถานะ")
    local bagLbl = Instance.new("TextLabel")
    bagLbl.Size = UDim2.new(1, 0, 0, 28)
    bagLbl.BackgroundColor3 = THEME.ELEMENT
    bagLbl.Text = "Bag: 0 / 0"
    bagLbl.TextColor3 = THEME.TEXT
    bagLbl.Font = Enum.Font.GothamMedium
    bagLbl.TextSize = 13
    bagLbl.BorderSizePixel = 0
    bagLbl.Parent = p
    corner(bagLbl, 8)

    task.spawn(function()
        while MS.Alive do
            bagLbl.Text = string.format("Bag: %d / %d", MS.Bag.Current, MS.Bag.Max)
            task.wait(0.5)
        end
    end)
end

-- ===== MISC TAB =====
do
    local p = pages["Misc"]
    createSection(p, "Session")
    createToggle(p, "Anti-AFK", false, function(v) MS.Opt.AntiAfk = v end)
    createButton(p, "Rejoin เซิร์ฟเดิม", function()
        notify("กำลัง Rejoin...")
        SessionRejoin()
    end, Color3.fromRGB(80,160,100))
    createButton(p, "Server Hop (ย้ายเซิร์ฟ)", function()
        notify("กำลังหาเซิร์ฟใหม่...")
        SessionHop()
    end, Color3.fromRGB(70,130,200))
    createButton(p, "Copy Job ID", function()
        pcall(function()
            if setclipboard then setclipboard(game.JobId) end
            notify("คัดลอก Job ID แล้ว")
        end)
    end)

    createSection(p, "ใช้โค้ด")
    local codeText = ""
    createTextbox(p, "ใส่โค้ด MM2", function(txt) codeText = txt end)
    createButton(p, "Redeem Code", function()
        if codeText == "" then notify("ยังไม่ได้ใส่โค้ด") return end
        notify("ผลลัพธ์: " .. RedeemCode(codeText))
    end, Color3.fromRGB(80,60,160))

    createSection(p, "ฉุกเฉิน")
    createButton(p, "ปิดทุกฟีเจอร์", function()
        for k in pairs(MS.Opt) do
            if type(MS.Opt[k]) == "boolean" then MS.Opt[k] = false end
        end
        SyncAimHook()
        SetFly(false)
        SetNoclip(false)
        SetFullbright(false)
        ClearXRay()
        notify("ปิดทุกฟีเจอร์แล้ว")
    end, Color3.fromRGB(200,60,60))
end

-- ===== SETTINGS TAB =====
do
    local p = pages["Settings"]
    createSection(p, "คีย์ลัด")
    createTextbox(p, "พิมพ์คีย์ (เช่น K)", function(txt)
        local key = txt:upper()
        notify("ตั้งคีย์ลัด: " .. key)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode[key] then
                Main.Visible = not Main.Visible
            end
        end)
    end)

    createSection(p, "ธีม")
    createButton(p, "ธีมม่วง", function()
        THEME.ACCENT = Color3.fromRGB(130,90,255)
        notify("ธีมม่วง")
    end, Color3.fromRGB(80,60,160))
    createButton(p, "ธีมฟ้า", function()
        THEME.ACCENT = Color3.fromRGB(60,150,255)
        notify("ธีมฟ้า")
    end, Color3.fromRGB(50,100,180))
    createButton(p, "ธีมแดง", function()
        THEME.ACCENT = Color3.fromRGB(230,60,80)
        notify("ธีมแดง")
    end, Color3.fromRGB(160,50,60))

    createSection(p, "อื่นๆ")
    createButton(p, "ปิดสคริปต์", function()
        SchedulerStop()
        ScreenGui:Destroy()
    end, Color3.fromRGB(200,60,60))
end

-- ==================================================
--  ปุ่มเปิด/ปิด UI + ลาก + เริ่มระบบ
-- ==================================================
local CENTER_POS = UDim2.new(0.5, -320, 0.5, -210)

local function toggleUI()
    if Main.Visible then
        Main.Visible = false
    else
        Main.Position = CENTER_POS
        Main.Visible = true
    end
end

OpenBtn.MouseButton1Click:Connect(toggleUI)
OpenBtn.Activated:Connect(toggleUI)
pcall(function() OpenBtn.TouchTap:Connect(toggleUI) end)

CloseBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.Activated:Connect(toggleUI)
pcall(function() CloseBtn.TouchTap:Connect(toggleUI) end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then toggleUI() end
end)

do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- เลือกแท็บเริ่มต้น + เริ่ม Scheduler
tabBtns["Combat"].btn.MouseButton1Click:Fire()
Main.Position = CENTER_POS
Main.Visible = true
SchedulerBoot()

notify("✅ PHURI MM2 HUB โหลดสำเร็จ!", 5)
print("✅ PHURI MM2 HUB | Mario-Style Engine Loaded")