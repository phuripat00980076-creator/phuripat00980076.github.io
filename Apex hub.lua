-- =========================================================================
--  🩸 APEX HUB  |  ULTIMATE V3 (CINEMATIC COOLDOWN + GLASS UI + FUNCTIONS)
-- =========================================================================

-- 1. ตั้งค่าเริ่มต้น
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ล้างค่าเก่า
pcall(function()
    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == "APEX_ULTIMATE" or v.Name == "APEX_HUB" then v:Destroy() end
    end
end)

-- =========================================================================
-- 2. ระบบ COOLDOWN (3 วินาทีแรก)
-- =========================================================================
local CooldownGui = Instance.new("ScreenGui")
CooldownGui.Name = "APEX_ULTIMATE"
CooldownGui.IgnoreGuiInset = true
CooldownGui.DisplayOrder = 20000
CooldownGui.Parent = game.CoreGui

local DarkScreen = Instance.new("Frame", CooldownGui)
DarkScreen.Size = UDim2.new(1, 0, 1, 0)
DarkScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkScreen.BorderSizePixel = 0

local SecureText = Instance.new("TextLabel", DarkScreen)
SecureText.Size = UDim2.new(1, 0, 1, 0)
SecureText.BackgroundTransparency = 1
SecureText.Text = "SECURING CONNECTION..."
SecureText.TextColor3 = Color3.fromRGB(200, 20, 30)
SecureText.Font = Enum.Font.GothamBlack
SecureText.TextSize = 20
SecureText.TextTransparency = 0.5

-- กระพริบข้อความรอ 3 วิ
task.spawn(function()
    for i = 1, 6 do
        TweenService:Create(SecureText, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
        task.wait(0.25)
        TweenService:Create(SecureText, TweenInfo.new(0.25), {TextTransparency = 0.8}):Play()
        task.wait(0.25)
    end
end)

-- =========================================================================
-- 3. CINEMATIC LOADER (หลังผ่าน 3 วิ)
-- =========================================================================
task.delay(3, function()
    TweenService:Create(DarkScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    SecureText:Destroy()
    task.wait(0.5)

    -- พื้นหลังหลักของ Loader
    local LoaderBg = Instance.new("Frame", CooldownGui)
    LoaderBg.Size = UDim2.new(1, 0, 1, 0)
    LoaderBg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    LoaderBg.BorderSizePixel = 0
    
    -- Grid พื้นหลัง (เส้นสาย Sci-Fi)
    local Grid = Instance.new("ImageLabel", LoaderBg)
    Grid.Size = UDim2.new(1.5, 0, 1.5, 0)
    Grid.Position = UDim2.new(-0.25, 0, -0.25, 0)
    Grid.BackgroundTransparency = 1
    Grid.Image = "rbxassetid://9968344105" -- Image ของ Roblox Grid
    Grid.ImageTransparency = 0.8
    Grid.ImageColor3 = Color3.fromRGB(200, 20, 30)
    
    TweenService:Create(Grid, TweenInfo.new(3, Enum.EasingStyle.Linear), {
        Position = UDim2.new(-0.3, 0, -0.3, 0),
        ImageTransparency = 0.5
    }):Play()

    -- จุดศูนย์กลาง (Wormhole effect)
    local Hole = Instance.new("Frame", LoaderBg)
    Hole.Size = UDim2.new(0, 10, 0, 10)
    Hole.Position = UDim2.new(0.5, -5, 0.5, -5)
    Hole.BackgroundColor3 = Color3.new(1, 1, 1)
    Hole.BorderSizePixel = 0
    Instance.new("UICorner", Hole).CornerRadius = UDim.new(1, 0)
    
    local HoleGlow = Instance.new("UIStroke", Hole)
    HoleGlow.Color = Color3.fromRGB(200, 20, 30)
    HoleGlow.Thickness = 5
    HoleGlow.Transparency = 0.2

    TweenService:Create(Hole, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 800, 0, 800),
        Position = UDim2.new(0.5, -400, 0.5, -400),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(HoleGlow, TweenInfo.new(2.5), {Thickness = 0, Transparency = 1}):Play()

    -- ระบบดาวและเส้นแทง
    local StarHolder = Instance.new("Frame", LoaderBg)
    StarHolder.Size = UDim2.new(1, 0, 1, 0)
    StarHolder.BackgroundTransparency = 1

    local starConn = RunService.Heartbeat:Connect(function()
        if math.random() < 0.4 then
            local star = Instance.new("Frame", StarHolder)
            star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 4))
            star.BackgroundColor3 = Color3.new(1, 1, 1)
            star.BorderSizePixel = 0
            star.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            local randomX = math.random(-800, 800)
            local randomY = math.random(-800, 800)
            
            TweenService:Create(star, TweenInfo.new(math.random(5, 15)/10, Enum.EasingStyle.Linear), {
                Position = UDim2.new(0.5, randomX, 0.5, randomY),
                BackgroundTransparency = 1
            }):Play()
            task.delay(1.5, function() star:Destroy() end)
        end
    end)

    -- ข้อความ APEX
    local Title = Instance.new("TextLabel", LoaderBg)
    Title.Size = UDim2.new(1, 0, 0, 80)
    Title.Position = UDim2.new(0, 0, 0.5, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "APEX"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 60
    Title.TextTransparency = 1
    
    local TitleSub = Instance.new("TextLabel", LoaderBg)
    TitleSub.Size = UDim2.new(1, 0, 0, 30)
    TitleSub.Position = UDim2.new(0, 0, 0.5, 120)
    TitleSub.BackgroundTransparency = 1
    TitleSub.Text = "H  U  B"
    TitleSub.TextColor3 = Color3.fromRGB(200, 20, 30)
    TitleSub.Font = Enum.Font.GothamBold
    TitleSub.TextSize = 20
    TitleSub.TextTransparency = 1

    TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0, Position = UDim2.new(0, 0, 0.5, -60)}):Play()
    TweenService:Create(TitleSub, TweenInfo.new(1), {TextTransparency = 0, Position = UDim2.new(0, 0, 0.5, 20)}):Play()

    task.wait(3) -- รอโหลด 3 วิ
    starConn:Disconnect()

    -- แฟลชขาวก่อนจบ
    local flash = Instance.new("Frame", CooldownGui)
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.new(1, 1, 1)
    flash.BackgroundTransparency = 1
    TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    task.wait(0.3)
    TweenService:Create(flash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    CooldownGui:Destroy()

    -- =========================================================================
    -- 4. MAIN UI (GLASSMORPHISM & FUNCTIONS)
    -- =========================================================================
    local C = {
        BG = Color3.fromRGB(10, 10, 12), SIDE = Color3.fromRGB(15, 15, 18), CON = Color3.fromRGB(12, 12, 14),
        EL = Color3.fromRGB(22, 22, 26), EL_HOVER = Color3.fromRGB(32, 32, 38), ACCENT = Color3.fromRGB(200, 20, 30),
        ACCENT_2 = Color3.fromRGB(255, 50, 60), TEXT = Color3.fromRGB(240, 240, 245), TEXT_DIM = Color3.fromRGB(120, 120, 130),
        STROKE = Color3.fromRGB(50, 15, 20), OFF = Color3.fromRGB(35, 35, 40), GLOW = Color3.fromRGB(255, 40, 40),
    }

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "APEX_HUB"
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.DisplayOrder = 999
    Gui.Parent = game.CoreGui

    local function corner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c end
    local function stroke(p, c, t) local s = Instance.new("UIStroke"); s.Color = c or C.STROKE; s.Thickness = t or 1; s.Parent = p; return s end
    local function click(btn, fn)
        local db = false
        btn.InputBegan:Connect(function(i)
            if db then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                db = true; fn(); task.delay(0.15, function() db = false end)
            end
        end)
    end

    -- State & Config
    local Opt = { Speed=false, SpeedValue=50, Jump=false, JumpValue=100, InfJump=false, Noclip=false, Fullbright=false, Aimbot=false, EspPlayers=false }
    local State = { EspFolder=nil, LightingDefaults={Ambient=Lighting.Ambient, Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime} }
    local function getHum() local ch = LP.Character; return ch and ch:FindFirstChildOfClass("Humanoid") end
    local function getRoot() local ch = LP.Character; return ch and ch:FindFirstChild("HumanoidRootPart") end

    -- Core Systems
    RunService.Heartbeat:Connect(function()
        local h = getHum(); if not h then return end
        if Opt.Speed then h.WalkSpeed = Opt.SpeedValue end
        if Opt.Jump then h.UseJumpPower = true; h.JumpPower = Opt.JumpValue end
        if Opt.Noclip and LP.Character then for _, p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
    end)
    
    UIS.JumpRequest:Connect(function() if Opt.InfJump then local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
    
    local function setFullbright(on)
        if on then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 1e9; Lighting.GlobalShadows = false
        else Lighting.Ambient = State.LightingDefaults.Ambient; Lighting.Brightness = State.LightingDefaults.Brightness; Lighting.ClockTime = State.LightingDefaults.ClockTime; Lighting.GlobalShadows = true end
    end

    local function getRole(plr)
        if not plr.Character then return "Innocent" end
        if plr.Character:FindFirstChild("Knife") then return "Murderer" end
        if plr.Character:FindFirstChild("Gun") then return "Sheriff" end
        return "Innocent"
    end

    RunService.RenderStepped:Connect(function()
        if Opt.Aimbot then
            local m = nil
            for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character and getRole(plr) == "Murderer" then m = plr; break end end
            if m and m.Character and m.Character:FindFirstChild("Head") then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, m.Character.Head.Position) end
        end
        if Opt.EspPlayers and State.EspFolder then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                    local hl = State.EspFolder:FindFirstChild(plr.Name .. "_HL")
                    if not hl then hl = Instance.new("Highlight", State.EspFolder); hl.Name = plr.Name .. "_HL"; hl.Adornee = plr.Character end
                    local r = getRole(plr)
                    if r == "Murderer" then hl.FillColor = Color3.new(1,0,0) elseif r == "Sheriff" then hl.FillColor = Color3.new(0,0.5,1) else hl.FillColor = Color3.new(0,1,0) end
                    hl.OutlineColor = hl.FillColor
                end
            end
        elseif not Opt.EspPlayers and State.EspFolder then State.EspFolder:ClearAllChildren() end
    end)

    local function TpLobby() if getRoot() then getRoot().CFrame = CFrame.new(0, 10, 0) end end
    local function TpMurderer()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Knife") and getRoot() then getRoot().CFrame = p.Character.HumanoidRootPart.CFrame; break end
        end
    end

    -- UI Components
    local notifHolder = Instance.new("Frame", Gui); notifHolder.Size = UDim2.new(0, 260, 1, -40); notifHolder.Position = UDim2.new(1, -280, 0, 20); notifHolder.BackgroundTransparency = 1
    local nl = Instance.new("UIListLayout", notifHolder); nl.Padding = UDim.new(0, 8)
    local function notify(text)
        local n = Instance.new("Frame", notifHolder); n.Size = UDim2.new(1, 0, 0, 42); n.BackgroundColor3 = C.EL; n.BackgroundTransparency = 1; corner(n, 6); stroke(n, C.ACCENT, 1.5)
        local a = Instance.new("Frame", n); a.Size = UDim2.new(0, 4, 1, -12); a.Position = UDim2.new(0, 6, 0, 6); a.BackgroundColor3 = C.ACCENT; corner(a, 2)
        local l = Instance.new("TextLabel", n); l.Size = UDim2.new(1, -22, 1, 0); l.Position = UDim2.new(0, 18, 0, 0); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = C.TEXT; l.Font = Enum.Font.GothamMedium; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
        task.delay(3, function() TweenService:Create(n, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play(); task.wait(0.3); n:Destroy() end)
    end

    local OpenBtn = Instance.new("TextButton", Gui); OpenBtn.Size = UDim2.new(0, 55, 0, 55); OpenBtn.Position = UDim2.new(0, 15, 0.5, -27); OpenBtn.BackgroundColor3 = C.BG; OpenBtn.Text = "APEX"; OpenBtn.TextColor3 = C.ACCENT; OpenBtn.Font = Enum.Font.GothamBlack; OpenBtn.BorderSizePixel = 0; OpenBtn.ZIndex = 9999; corner(OpenBtn, 27); local openStroke = stroke(OpenBtn, C.ACCENT, 2)
    
    task.spawn(function() while OpenBtn.Parent do TweenService:Create(openStroke, TweenInfo.new(1), {Color = C.GLOW}):Play(); task.wait(1); TweenService:Create(openStroke, TweenInfo.new(1), {Color = C.ACCENT}):Play(); task.wait(1) end end)

    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 680, 0, 460); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = C.BG; Main.BorderSizePixel = 0; Main.Visible = false; Main.ClipsDescendants = true; corner(Main, 12); stroke(Main, C.STROKE, 1.5)
    
    -- พื้นหลังแบบ Glass (โปร่งแสงนิดๆ)
    local GlassBg = Instance.new("Frame", Main)
    GlassBg.Size = UDim2.new(1, 0, 1, 0)
    GlassBg.BackgroundColor3 = Color3.new(1, 1, 1)
    GlassBg.BackgroundTransparency = 0.98
    GlassBg.ZIndex = 0
    
    local UIScale = Instance.new("UIScale", Main); local function UpdateScale() local vp = Camera.ViewportSize; UIScale.Scale = math.min(1, (vp.X*0.94)/680, (vp.Y*0.90)/460) end; UpdateScale(); Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

    local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 48); TopBar.BackgroundColor3 = C.SIDE; TopBar.ZIndex = 2
    local topLine = Instance.new("Frame", TopBar); topLine.Size = UDim2.new(1, 0, 0, 2); topLine.Position = UDim2.new(0, 0, 1, -2); topLine.BackgroundColor3 = C.ACCENT
    local TitleLbl = Instance.new("TextLabel", TopBar); TitleLbl.Size = UDim2.new(0, 300, 1, 0); TitleLbl.Position = UDim2.new(0, 24, 0, 0); TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "APEX  <font color='#c8141e'>HUB</font>"; TitleLbl.RichText = true; TitleLbl.TextColor3 = C.TEXT; TitleLbl.Font = Enum.Font.GothamBlack; TitleLbl.TextSize = 18; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local CloseBtn = Instance.new("TextButton", TopBar); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -42, 0.5, -15); CloseBtn.BackgroundColor3 = C.ACCENT; CloseBtn.Text = "X"; CloseBtn.TextColor3 = C.TEXT; CloseBtn.Font = Enum.Font.GothamBold; corner(CloseBtn, 8)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 170, 1, -48); Sidebar.Position = UDim2.new(0, 0, 0, 48); Sidebar.BackgroundColor3 = C.SIDE; Sidebar.ZIndex = 2
    local sideDiv = Instance.new("Frame", Sidebar); sideDiv.Size = UDim2.new(0, 1, 1, 0); sideDiv.Position = UDim2.new(1, -1, 0, 0); sideDiv.BackgroundColor3 = C.STROKE

    local Profile = Instance.new("Frame", Sidebar); Profile.Size = UDim2.new(1, -20, 0, 50); Profile.Position = UDim2.new(0, 10, 1, -60); Profile.BackgroundColor3 = C.EL; corner(Profile, 8); stroke(Profile, C.STROKE, 1)
    local pAvatar = Instance.new("ImageLabel", Profile); pAvatar.Size = UDim2.new(0, 34, 0, 34); pAvatar.Position = UDim2.new(0, 8, 0.5, -17); pAvatar.BackgroundColor3 = C.BG; pAvatar.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=48&h=48"; corner(pAvatar, 17)
    local pName = Instance.new("TextLabel", Profile); pName.Size = UDim2.new(1, -50, 0, 18); pName.Position = UDim2.new(0, 48, 0, 8); pName.BackgroundTransparency = 1; pName.Text = LP.DisplayName; pName.TextColor3 = C.TEXT; pName.Font = Enum.Font.GothamBold; pName.TextSize = 12; pName.TextXAlignment = Enum.TextXAlignment.Left
    local pRole = Instance.new("TextLabel", Profile); pRole.Size = UDim2.new(1, -50, 0, 14); pRole.Position = UDim2.new(0, 48, 0, 26); pRole.BackgroundTransparency = 1; pRole.Text = "PREMIUM USER"; pRole.TextColor3 = C.ACCENT_2; pRole.Font = Enum.Font.GothamBold; pRole.TextSize = 10; pRole.TextXAlignment = Enum.TextXAlignment.Left

    local TabHolder = Instance.new("Frame", Sidebar); TabHolder.Size = UDim2.new(1, -16, 1, -140); TabHolder.Position = UDim2.new(0, 8, 0, 10); TabHolder.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", TabHolder); tabLayout.Padding = UDim.new(0, 5)

    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -170, 1, -48); Content.Position = UDim2.new(0, 170, 0, 48); Content.BackgroundColor3 = C.CON; Content.ZIndex = 2
    local pages, tabBtns, currentTab = {}, {}, nil
    local function createPage(name)
        local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, -24, 1, -24); p.Position = UDim2.new(0, 12, 0, 12); p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 3; p.ScrollBarImageColor3 = C.ACCENT; p.CanvasSize = UDim2.new(0, 0, 0, 0); p.AutomaticCanvasSize = Enum.AutomaticSize.Y; p.Visible = false
        local lay = Instance.new("UIListLayout", p); lay.Padding = UDim.new(0, 10); pages[name] = p; return p
    end
    local function switchTab(name)
        currentTab = name
        for n, t in pairs(tabBtns) do local act = (n == name); TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundTransparency = act and 0 or 1, TextColor3 = act and C.TEXT or C.TEXT_DIM}):Play(); TweenService:Create(t.ind, TweenInfo.new(0.2), {Size = act and UDim2.new(0, 3, 0, 18) or UDim2.new(0, 3, 0, 0)}):Play() end
        for n, p in pairs(pages) do p.Visible = (n == name) end
    end
    local function createTab(name)
        local btn = Instance.new("TextButton", TabHolder); btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundColor3 = C.EL_HOVER; btn.BackgroundTransparency = 1; btn.Text = "   " .. name; btn.TextColor3 = C.TEXT_DIM; btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.AutoButtonColor = false; corner(btn, 6)
        local ind = Instance.new("Frame", btn); ind.Size = UDim2.new(0, 3, 0, 0); ind.Position = UDim2.new(0, -1, 0.5, 0); ind.BackgroundColor3 = C.ACCENT; corner(ind, 2); tabBtns[name] = {btn = btn, ind = ind}
        btn.MouseEnter:Connect(function() if currentTab ~= name then btn.BackgroundTransparency = 0 end end); btn.MouseLeave:Connect(function() if currentTab ~= name then btn.BackgroundTransparency = 1 end end)
        click(btn, function() switchTab(name) end)
    end

    local function createSection(parent, title) local s = Instance.new("Frame", parent); s.Size = UDim2.new(1, 0, 0, 26); s.BackgroundTransparency = 1; local t = Instance.new("TextLabel", s); t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Text = "◤ " .. title:upper(); t.TextColor3 = C.ACCENT; t.Font = Enum.Font.GothamBold; t.TextSize = 12; t.TextXAlignment = Enum.TextXAlignment.Left end)
    
    local function createToggle(parent, text, default, callback)
        local holder = Instance.new("Frame", parent); holder.Size = UDim2.new(1, 0, 0, 38); holder.BackgroundColor3 = C.EL; corner(holder, 6); local hStroke = stroke(holder, C.STROKE, 1)
        local lbl = Instance.new("TextLabel", holder); lbl.Size = UDim2.new(1, -70, 1, 0); lbl.Position = UDim2.new(0, 14, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = C.TEXT; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
        local track = Instance.new("Frame", holder); track.Size = UDim2.new(0, 42, 0, 20); track.Position = UDim2.new(1, -56, 0.5, -10); track.BackgroundColor3 = default and C.ACCENT or C.OFF; corner(track, 10)
        local knob = Instance.new("Frame", track); knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); knob.BackgroundColor3 = default and Color3.new(1,1,1) or C.TEXT_DIM; corner(knob, 8)
        local state = default; local btn = Instance.new("TextButton", holder); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
        click(btn, function() state = not state; TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = state and C.ACCENT or C.OFF}):Play(); TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = state and Color3.new(1,1,1) or C.TEXT_DIM}):Play(); TweenService:Create(hStroke, TweenInfo.new(0.2), {Color = state and C.ACCENT or C.STROKE}):Play(); if callback then callback(state) end end)
    end

    local function createSlider(parent, text, min, max, default, callback)
        local holder = Instance.new("Frame", parent); holder.Size = UDim2.new(1, 0, 0, 50); holder.BackgroundColor3 = C.EL; corner(holder, 6)
        local lbl = Instance.new("TextLabel", holder); lbl.Size = UDim2.new(1, -20, 0, 20); lbl.Position = UDim2.new(0, 14, 0, 4); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = C.TEXT; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
        local valLbl = Instance.new("TextLabel", holder); valLbl.Size = UDim2.new(0, 60, 0, 20); valLbl.Position = UDim2.new(1, -74, 0, 4); valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(default); valLbl.TextColor3 = C.ACCENT_2; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 13; valLbl.TextXAlignment = Enum.TextXAlignment.Right
        local bg = Instance.new("Frame", holder); bg.Size = UDim2.new(1, -28, 0, 6); bg.Position = UDim2.new(0, 14, 0, 32); bg.BackgroundColor3 = C.OFF; corner(bg, 3)
        local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fl.BackgroundColor3 = C.ACCENT; corner(fl, 3)
        local btn = Instance.new("TextButton", holder); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 5
        local dragging = false
        local function update(i) local rel = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1); local v = math.floor((min + (max - min) * rel) * 100) / 100; fl.Size = UDim2.new(rel, 0, 1, 0); valLbl.Text = tostring(v); if callback then callback(v) end end
        btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; update(i) end end)
        UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    end

    local function createButton(parent, text, callback, color)
        local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundColor3 = color or C.EL; btn.Text = text; btn.TextColor3 = C.TEXT; btn.Font = Enum.Font.GothamBold; btn.TextSize = 13; btn.AutoButtonColor = false; corner(btn, 6)
        local base = color or C.EL
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base:Lerp(C.ACCENT, 0.4)}):Play() end); btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play() end)
        click(btn, function() if callback then callback() end end)
    end

    -- สร้างแท็บ
    createPage("Combat"); createTab("Combat"); createPage("Visual"); createTab("Visual"); createPage("Player"); createTab("Player"); createPage("Misc"); createTab("Misc"); createPage("Settings"); createTab("Settings")

    -- ใส่ฟังก์ชัน
    local pC = pages["Combat"]; createSection(pC, "Aimbot"); createToggle(pC, "Aimbot (ล็อกเป้าฆาตกร)", false, function(v) Opt.Aimbot = v end); createSection(pC, "Combat"); createButton(pC, "วาร์ปไปหาฆาตกร", function() TpMurderer(); notify("วาร์ปแล้ว") end, C.ACCENT)
    local pV = pages["Visual"]; createSection(pV, "ESP"); createToggle(pV, "Highlight ผู้เล่น", false, function(v) Opt.EspPlayers = v; if not v and State.EspFolder then State.EspFolder:ClearAllChildren() end end); createSection(pV, "Lighting"); createToggle(pV, "Fullbright", false, function(v) Opt.Fullbright = v; setFullbright(v) end)
    local pP = pages["Player"]; createSection(pP, "Speed"); createToggle(pP, "WalkSpeed", false, function(v) Opt.Speed = v; if not v then local h = getHum(); if h then h.WalkSpeed = 16 end end end); createSlider(pP, "ความเร็ว", 16, 150, 50, function(v) Opt.SpeedValue = v; if Opt.Speed then local h = getHum(); if h then h.WalkSpeed = v end end end); createSection(pP, "Jump"); createToggle(pP, "JumpPower", false, function(v) Opt.Jump = v; if not v then local h = getHum(); if h then h.JumpPower = 50 end end end); createSlider(pP, "แรงกระโดด", 50, 300, 100, function(v) Opt.JumpValue = v; if Opt.Jump then local h = getHum(); if h then h.JumpPower = v end end end); createSection(pP, "พิเศษ"); createToggle(pP, "Infinite Jump", false, function(v) Opt.InfJump = v end); createToggle(pP, "Noclip", false, function(v) Opt.Noclip = v; if not v and LP.Character then for _, p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
    local pM = pages["Misc"]; createSection(pM, "Teleport"); createButton(pM, "วาร์ปไป Lobby", function() TpLobby(); notify("วาร์ป Lobby") end); createButton(pM, "รีเซ็ตตัวละคร", function() local h = getHum(); if h then h.Health = 0 end end, C.ACCENT)
    local pS = pages["Settings"]; createSection(pS, "ระบบ"); createButton(pS, "ปิด UI", function() Gui:Destroy() end, C.ACCENT)

    -- UI Toggle
    local CENTER_POS = UDim2.new(0.5, 0, 0.5, 0)
    local function toggleUI()
        if Main.Visible then local tw = TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 680, 0, 0)}); tw:Play(); tw.Completed:Wait(); Main.Visible = false; Main.Size = UDim2.new(0, 680, 0, 460)
        else Main.Position = CENTER_POS; Main.Size = UDim2.new(0, 680, 0, 0); Main.Visible = true; TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 680, 0, 460)}):Play() end
    end
    do
        local p0, pb0, t0, dg
        OpenBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then p0 = i.Position; pb0 = OpenBtn.Position; t0 = tick(); dg = false end end)
        UIS.InputChanged:Connect(function(i) if not p0 then return end; if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then local d = i.Position - p0; if d.Magnitude > 6 then dg = true; OpenBtn.Position = UDim2.new(pb0.X.Scale, pb0.X.Offset + d.X, pb0.Y.Scale, pb0.Y.Offset + d.Y) end end end)
        UIS.InputEnded:Connect(function(i) if not p0 then return end; if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then if not dg and tick() - t0 < 0.6 then toggleUI() end; p0 = nil; dg = false end end)
    end
    click(CloseBtn, toggleUI)
    do
        local dr, ds, sp
        TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true; ds = i.Position; sp = Main.Position end end)
        UIS.InputChanged:Connect(function(i) if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = false end end)
    end

    switchTab("Combat"); Main.Position = CENTER_POS; Main.Size = UDim2.new(0, 680, 0, 460); Main.Visible = true
    notify("APEX HUB ULTIMATE พร้อมใช้งาน")
end)
