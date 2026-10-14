-- PHURI V32.1 (FIXED UI ORDER)
local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local VIM=game:GetService("VirtualInputManager")
local TW=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local SS=game:GetService("SoundService")
local LP=Players.LocalPlayer

local HR=nil
local function bindChar(c)
    HR=c:WaitForChild("HumanoidRootPart")
end
if LP.Character then bindChar(LP.Character) end
LP.CharacterAdded:Connect(bindChar)

local F={Parry=false,Spin=false,FPS=false}
local fps,fc,ft=60,0,tick()
local PC=0
local RZ="-"
local Dbg=nil
local SpinIdx=4
local CurTheme="Galaxy"
local SpinSp={180,360,720,1440}
local SpinNm={"Slow","Mid","Fast","Insane"}
local LastFire=0
local VelH={}
local PingH={}
local TuneSt="idle"
local TuneS={}
local TuneStart=0
local TuneScore=0
local PAR={HB=20,SB=10,SC=0.16,JB=0.06,MI=0.10,RHB=7,RS=0.4}
local Gen=0
local LastGen=-1
local LastV=nil
local LastP=nil
local LastBall=nil
local RBAct=false
local RBTime=0
local ATD=0.03
local MainSG=nil
local SpA,SpAV=nil,nil

local TH={
    Galaxy={A=Color3.fromRGB(255,105,180),B=Color3.fromRGB(138,43,226),C=Color3.fromRGB(0,255,255),ON=Color3.fromRGB(0,120,80)},
    Cyber={A=Color3.fromRGB(255,0,128),B=Color3.fromRGB(255,215,0),C=Color3.fromRGB(0,255,255),ON=Color3.fromRGB(180,0,90)}
}
local TN={"Galaxy","Cyber"}
local GL={}
local TL={}

-- ⭐️ Forward declaration สำคัญมาก!
local BuildUI

local function ApplyTheme()
    local t=TH[CurTheme]
    for _,g in ipairs(GL)do
        g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,t.A),ColorSequenceKeypoint.new(0.5,t.B),ColorSequenceKeypoint.new(1,t.C)})
    end
    for _,x in ipairs(TL)do
        if F[x.key] then x.btn.BackgroundColor3=t.ON
        else x.btn.BackgroundColor3=Color3.fromRGB(30,30,45) end
    end
end

local function StartTune()
    TuneSt="sampling" TuneStart=tick() TuneS={} TuneScore=0
end

local function FinishTune()
    if #TuneS<10 then TuneScore=50
    else
        local sF,sP=0,0
        for _,s in ipairs(TuneS)do sF=sF+s.f sP=sP+s.p end
        local af=sF/#TuneS
        local ap=(sP/#TuneS)*1000
        local fS=math.clamp(af/60,0,1)
        local pS=math.clamp(1-(ap-30)/200,0,1)
        TuneScore=math.floor((fS*0.6+pS*0.4)*100)
    end
    if TuneScore>=85 then PAR.HB=18 PAR.SB=8 PAR.SC=0.14 ATD=0.022
    elseif TuneScore>=70 then PAR.HB=19 PAR.SB=9 PAR.SC=0.13 ATD=0.028
    elseif TuneScore>=50 then PAR.HB=20 PAR.SB=10 PAR.SC=0.12 ATD=0.035
    else PAR.HB=21 PAR.SB=11 PAR.SC=0.11 ATD=0.045 end
    TuneSt="done"
end

local function SetSpin(on)
    if not HR or not HR.Parent then return end
    if on then
        if not SpA or not SpA.Parent then SpA=Instance.new("Attachment",HR)end
        if not SpAV or not SpAV.Parent then
            SpAV=Instance.new("AngularVelocity",HR)
            SpAV.Attachment0=SpA
            SpAV.MaxTorque=150000
            SpAV.RelativeTo=Enum.ActuatorRelativeTo.World
        end
        SpAV.AngularVelocity=Vector3.new(0,math.rad(SpinSp[SpinIdx]),0)
    else
        if SpAV and SpAV.Parent then SpAV:Destroy()end
        if SpA and SpA.Parent then SpA:Destroy()end
        SpAV,SpA=nil,nil
    end
end

local Orig={}
local function FPSOn()
    pcall(function()Orig.sh=Lighting.GlobalShadows Lighting.GlobalShadows=false end)
    pcall(function()Orig.fog=Lighting.FogEnd Lighting.FogEnd=1000 end)
end
local function FPSOff()
    pcall(function()Lighting.GlobalShadows=Orig.sh Lighting.FogEnd=Orig.fog end)
end

-- ⭐️ MAIN UI (ประกาศก่อน Loader)
BuildUI=function()
    if MainSG then MainSG:Destroy() end
    GL={} TL={}
    local SG=Instance.new("ScreenGui",LP:WaitForChild("PlayerGui"))
    SG.Name="PHURI_MAIN_"..math.random(1,10000)
    SG.ResetOnSpawn=false
    SG.DisplayOrder=9999
    SG.IgnoreGuiInset=true
    MainSG=SG

    local MF=Instance.new("Frame",SG)
    MF.Size=UDim2.new(0,320,0,290)
    MF.Position=UDim2.new(0.5,-160,0.5,-145)
    MF.BackgroundColor3=Color3.fromRGB(12,12,20)
    MF.Active=true
    MF.Draggable=true
    Instance.new("UICorner",MF).CornerRadius=UDim.new(0,10)
    local SK=Instance.new("UIStroke",MF)
    SK.Thickness=2.5
    local SK2=Instance.new("UIGradient",SK)
    table.insert(GL,SK2)
    task.spawn(function()
        while SG.Parent do
            SK2.Rotation=(SK2.Rotation+5)%360
            task.wait(0.08)
        end
    end)

    local HD=Instance.new("Frame",MF)
    HD.Size=UDim2.new(1,0,0,35)
    HD.BackgroundColor3=Color3.fromRGB(18,18,28)
    Instance.new("UICorner",HD).CornerRadius=UDim.new(0,10)
    local TL2=Instance.new("TextLabel",HD)
    TL2.Size=UDim2.new(1,-70,1,0)
    TL2.Position=UDim2.new(0,12,0,0)
    TL2.BackgroundTransparency=1
    TL2.Text="PHURI V32.1"
    TL2.TextColor3=Color3.fromRGB(255,255,255)
    TL2.Font=Enum.Font.GothamBold
    TL2.TextSize=14
    TL2.TextXAlignment=Enum.TextXAlignment.Left
    local TLG=Instance.new("UIGradient",TL2)
    table.insert(GL,TLG)

    local CB=Instance.new("TextButton",HD)
    CB.Size=UDim2.new(0,28,0,28)
    CB.Position=UDim2.new(1,-33,0,4)
    CB.BackgroundColor3=Color3.fromRGB(200,50,80)
    CB.Text="X"
    CB.TextColor3=Color3.fromRGB(255,255,255)
    CB.Font=Enum.Font.GothamBold
    CB.TextSize=14
    Instance.new("UICorner",CB).CornerRadius=UDim.new(0,6)
    CB.MouseButton1Click:Connect(function()SG:Destroy()end)

    local MinBtn=Instance.new("TextButton",HD)
    MinBtn.Size=UDim2.new(0,28,0,28)
    MinBtn.Position=UDim2.new(1,-65,0,4)
    MinBtn.BackgroundColor3=Color3.fromRGB(60,60,90)
    MinBtn.Text="-"
    MinBtn.TextColor3=Color3.fromRGB(255,255,255)
    MinBtn.Font=Enum.Font.GothamBold
    MinBtn.TextSize=16
    Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,6)

    local SC=Instance.new("ScrollingFrame",MF)
    SC.Size=UDim2.new(1,-16,1,-46)
    SC.Position=UDim2.new(0,8,0,40)
    SC.BackgroundTransparency=1
    SC.BorderSizePixel=0
    SC.ScrollBarThickness=4
    local LY=Instance.new("UIListLayout",SC)
    LY.Padding=UDim.new(0,6)
    LY:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SC.CanvasSize=UDim2.new(0,0,0,LY.AbsoluteContentSize.Y+10)
    end)

    local isMin=false
    MinBtn.MouseButton1Click:Connect(function()
        isMin=not isMin
        if isMin then
            MinBtn.Text="+"
            TW:Create(MF,TweenInfo.new(0.3),{Size=UDim2.new(0,320,0,35)}):Play()
            SC.Visible=false
        else
            MinBtn.Text="-"
            TW:Create(MF,TweenInfo.new(0.3),{Size=UDim2.new(0,320,0,290)}):Play()
            task.wait(0.1)
            SC.Visible=true
        end
    end)

    local function Tog(txt,key,def,cb)
        local b=Instance.new("TextButton",SC)
        b.Size=UDim2.new(1,-6,0,36)
        b.BackgroundColor3=def and TH[CurTheme].ON or Color3.fromRGB(30,30,45)
        b.Text=txt..(def and ": ON" or ": OFF")
        b.TextColor3=Color3.fromRGB(255,255,255)
        b.Font=Enum.Font.GothamBold
        b.TextSize=12
        b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        local on=def or false
        F[key]=on
        table.insert(TL,{btn=b,key=key})
        b.MouseButton1Click:Connect(function()
            on=not on
            F[key]=on
            b.Text=txt..(on and ": ON" or ": OFF")
            b.BackgroundColor3=on and TH[CurTheme].ON or Color3.fromRGB(30,30,45)
            if cb then cb(on)end
        end)
    end

    Tog("AUTO PARRY (AI)","Parry",false,function(on)
        if on then StartTune() else TuneSt="idle" TuneS={} end
    end)

    Dbg=Instance.new("TextLabel",SC)
    Dbg.Size=UDim2.new(1,-6,0,110)
    Dbg.BackgroundColor3=Color3.fromRGB(20,20,35)
    Dbg.Text="AUTO PARRY\n0 | FPS: -- | Ping: --\ntEntry: -- | HB: --\nGen: 0\nReason: --"
    Dbg.TextColor3=Color3.fromRGB(255,200,100)
    Dbg.Font=Enum.Font.GothamBold
    Dbg.TextSize=10
    Dbg.BorderSizePixel=0
    Dbg.TextWrapped=true
    Instance.new("UICorner",Dbg).CornerRadius=UDim.new(0,6)

    Tog("FPS Boost","FPS",false,function(on)if on then FPSOn()else FPSOff()end end)
    Tog("Spin","Spin",false,function(on)SetSpin(on)end)

    local SB=Instance.new("TextButton",SC)
    SB.Size=UDim2.new(1,-6,0,36)
    SB.BackgroundColor3=Color3.fromRGB(80,40,120)
    SB.Text="Spin Speed: "..SpinNm[SpinIdx]
    SB.TextColor3=Color3.fromRGB(255,255,255)
    SB.Font=Enum.Font.GothamBold
    SB.TextSize=12
    Instance.new("UICorner",SB).CornerRadius=UDim.new(0,6)
    SB.MouseButton1Click:Connect(function()
        SpinIdx=(SpinIdx%#SpinSp)+1
        SB.Text="Spin Speed: "..SpinNm[SpinIdx]
        if SpAV and SpAV.Parent then SpAV.AngularVelocity=Vector3.new(0,math.rad(SpinSp[SpinIdx]),0)end
    end)

    local TB=Instance.new("TextButton",SC)
    TB.Size=UDim2.new(1,-6,0,36)
    TB.BackgroundColor3=Color3.fromRGB(50,30,70)
    TB.Text="Theme: "..CurTheme
    TB.TextColor3=Color3.fromRGB(255,255,255)
    TB.Font=Enum.Font.GothamBold
    TB.TextSize=12
    Instance.new("UICorner",TB).CornerRadius=UDim.new(0,6)
    TB.MouseButton1Click:Connect(function()
        local i=table.find(TN,CurTheme)or 1
        i=(i%#TN)+1
        CurTheme=TN[i]
        TB.Text="Theme: "..CurTheme
        ApplyTheme()
    end)

    ApplyTheme()
end

-- ⭐️ LOADER (ประกาศหลัง BuildUI — เรียกใช้ได้เลย)
local function BuildLoader()
    local lg=Instance.new("ScreenGui",LP:WaitForChild("PlayerGui"))
    lg.Name="PHURI_LOAD_"..math.random(1,10000)
    lg.ResetOnSpawn=false
    lg.DisplayOrder=9999
    lg.IgnoreGuiInset=true
    local lbox=Instance.new("Frame",lg)
    lbox.Size=UDim2.new(0,320,0,115)
    lbox.Position=UDim2.new(0.5,-160,0.5,-58)
    lbox.BackgroundColor3=Color3.fromRGB(12,12,20)
    lbox.BackgroundTransparency=0.15
    lbox.BorderSizePixel=0
    Instance.new("UICorner",lbox).CornerRadius=UDim.new(0,12)
    local lstk=Instance.new("UIStroke",lbox)
    lstk.Thickness=2
    lstk.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local lgrd=Instance.new("UIGradient",lstk)
    lgrd.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,TH[CurTheme].A),ColorSequenceKeypoint.new(1,TH[CurTheme].C)})

    local ltxt=Instance.new("TextLabel",lbox)
    ltxt.Size=UDim2.new(1,0,0,25)
    ltxt.Position=UDim2.new(0,0,0,6)
    ltxt.BackgroundTransparency=1
    ltxt.Text="PHURI HUB"
    ltxt.TextColor3=TH[CurTheme].A
    ltxt.Font=Enum.Font.GothamBlack
    ltxt.TextSize=16

    local lbt=Instance.new("TextLabel",lbox)
    lbt.Size=UDim2.new(1,-10,0,22)
    lbt.Position=UDim2.new(0,5,0,32)
    lbt.BackgroundTransparency=1
    lbt.Text="Welcome to PHURI HUB"
    lbt.TextColor3=Color3.fromRGB(200,220,255)
    lbt.Font=Enum.Font.GothamBold
    lbt.TextSize=10

    local lbt2=Instance.new("TextLabel",lbox)
    lbt2.Size=UDim2.new(1,-10,0,18)
    lbt2.Position=UDim2.new(0,5,0,52)
    lbt2.BackgroundTransparency=1
    lbt2.Text="Thank you for using our script"
    lbt2.TextColor3=Color3.fromRGB(180,200,220)
    lbt2.Font=Enum.Font.Gotham
    lbt2.TextSize=9

    local lbb=Instance.new("Frame",lbox)
    lbb.Size=UDim2.new(0,280,0,5)
    lbb.Position=UDim2.new(0.5,-140,0,95)
    lbb.BackgroundColor3=Color3.fromRGB(30,30,45)
    Instance.new("UICorner",lbb).CornerRadius=UDim.new(1,0)
    local lbf=Instance.new("Frame",lbb)
    lbf.Size=UDim2.new(0,0,1,0)
    lbf.BackgroundColor3=TH[CurTheme].A
    Instance.new("UICorner",lbf).CornerRadius=UDim.new(1,0)

    local ws=Instance.new("Sound",SS)
    ws.SoundId="rbxassetid://9118025346"
    ws.Volume=4
    ws.PlayOnRemove=false
    task.spawn(function()
        local t=0
        while not ws.IsLoaded and t<3 do task.wait(0.1) t=t+0.1 end
        local ok=pcall(function()ws:Play()end)
        if not ok or not ws.IsPlaying then pcall(function()SS:PlayLocalSound(ws)end)end
        task.wait(0.3)
        if not ws.IsPlaying then
            ws.Parent=workspace
            pcall(function()ws:Play()end)
        end
    end)

    task.spawn(function()
        TW:Create(lbf,TweenInfo.new(2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,1,0)}):Play()
        task.wait(2.5)
        pcall(function()ws:Stop()ws:Destroy()end)
        for _,v in ipairs(lbox:GetDescendants())do
            pcall(function()
                if v:IsA("Frame")then TW:Create(v,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
                elseif v:IsA("TextLabel")then TW:Create(v,TweenInfo.new(0.4),{TextTransparency=1}):Play()
                elseif v:IsA("UIStroke")then TW:Create(v,TweenInfo.new(0.4),{Transparency=1}):Play()end
            end)
        end
        TW:Create(lbox,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        task.wait(0.5)
        lg:Destroy()
        BuildUI()
    end)
end

-- ========== ENGINE ==========
local function GetBall()
    local bs=workspace:FindFirstChild("Balls")
    if bs then
        for _,b in pairs(bs:GetChildren())do
            if b:IsA("BasePart")then return b end
        end
    end
    for _,o in pairs(workspace:GetChildren())do
        if o:IsA("BasePart")and o.Name:find("Ball")then return o end
    end
end

local function SmoothV(b)
    table.insert(VelH,b.AssemblyLinearVelocity)
    if #VelH>6 then table.remove(VelH,1)end
    local s=Vector3.new(0,0,0)
    for _,v in ipairs(VelH)do s=s+v end
    return s/math.max(#VelH,1)
end

local function SmoothP(rp)
    table.insert(PingH,rp)
    if #PingH>12 then table.remove(PingH,1)end
    local s=0
    for _,p in ipairs(PingH)do s=s+p end
    return s/math.max(#PingH,1)
end

local function Track(b)
    if not b then
        LastV=nil LastP=nil LastBall=nil RBAct=false
        return
    end
    local v=b.AssemblyLinearVelocity
    local p=b.Position
    if b~=LastBall then
        Gen=Gen+1 LastGen=-1 LastBall=b LastV=v LastP=p RBAct=false
        return
    end
    if LastV then
        local d=v:Dot(LastV)
        if d<0 and v.Magnitude>50 and LastV.Magnitude>50 then
            local tu=HR.Position-p
            if tu.Magnitude>0.1 and v.Unit:Dot(tu.Unit)>0.4 then
                Gen=Gen+1 LastGen=-1 RBAct=true RBTime=tick()
            end
        end
    end
    if LastP and (p-LastP).Magnitude>50 then
        Gen=Gen+1 LastGen=-1 RBAct=true RBTime=tick()
    end
    LastV=v LastP=p
    if RBAct and tick()-RBTime>1.5 then RBAct=false end
end

local function Predict(b,sv)
    if not HR or not HR.Parent then return nil end
    local rp=b.Position-HR.Position
    local rv=sv-HR.AssemblyLinearVelocity
    local sp=rv.Magnitude
    if sp<10 then return nil end
    local hb=PAR.HB+math.min(sp/150,PAR.SB)
    if RBAct then hb=hb+PAR.RHB end
    local a=sp*sp
    local bb=2*rp:Dot(rv)
    local cc=rp:Dot(rp)-hb*hb
    if bb>=0 then return nil,hb,sp end
    if cc<=0 then return 0,hb,sp end
    local d=bb*bb-4*a*cc
    if d<0 then return nil,hb,sp end
    local te=(-bb-math.sqrt(d))/(2*a)
    if te<0 or te>1.5 then return nil,hb,sp end
    local vc=0
    for _,r in ipairs({0.5,0.7,0.85,1.0})do
        local fp=rp+rv*(te*r)
        if fp.Magnitude<=hb*1.35 then vc=vc+1 end
    end
    if vc<3 then return nil,hb,sp end
    return te,hb,sp
end

local function ShouldFire(te,sp,pg,ds)
    if RBAct then
        local td=pg*PAR.RS+ATD*0.6+0.05
        if te<=td+0.06 then return true,"REBOUND" end
        return false
    end
    if ds<=14 and te and te<=0.05 then return true,"EMERG" end
    local td=pg*0.5+ATD+PAR.JB
    local sc=math.clamp((sp-300)/1200,0,PAR.SC)
    if te<=td+sc then return true,"PREDICT" end
    return false
end

local function Fire(b)
    local n=tick()
    local mi=RBAct and 0.08 or PAR.MI
    if n-LastFire<mi then return end
    if b==LastBall and LastGen==Gen then return end
    if not b or not b.Parent or not HR or not HR.Parent then return end
    LastFire=n LastGen=Gen
    task.spawn(function()
        pcall(function()
            VIM:SendKeyEvent(true,Enum.KeyCode.F,false,game)
            task.wait(0.02)
            VIM:SendKeyEvent(false,Enum.KeyCode.F,false,game)
        end)
    end)
end

RS.Heartbeat:Connect(function()
    fc=fc+1
    if tick()-ft>=1 then
        fps=fc fc=0 ft=tick()
        if TuneSt=="sampling" then
            table.insert(TuneS,{f=fps,p=LP:GetNetworkPing()or 0.05})
            if tick()-TuneStart>=3 then FinishTune()end
        end
    end
end)

RS.Heartbeat:Connect(function()
    if not HR or not HR.Parent then return end
    local rp=LP:GetNetworkPing()
    if not rp or rp<=0 then rp=0.05 end
    local pg=SmoothP(rp)
    local b=GetBall()
    if b then
        Track(b)
        local sv=SmoothV(b)
        local te,hb,sp=Predict(b,sv)
        local ds=(b.Position-HR.Position).Magnitude
        if Dbg and tick()-(Dbg:GetAttribute("u")or 0)>0.15 then
            local ts=te and string.format("%.3fs",te)or "miss"
            local ai
            if TuneSt=="sampling" then ai="AI Scanning: "..math.floor(tick()-TuneStart).."/3s"
            elseif TuneSt=="done" then ai=string.format("AI Score: %d/100",TuneScore)
            else ai="AI: Ready" end
            Dbg.Text=string.format("%s\nParries: %d | FPS: %d | Ping: %.0fms\ntEntry: %s | HB: %.0f\nGen: %d | Rebound: %s\nReason: %s",ai,PC,fps,pg*1000,ts,hb or 0,Gen,RBAct and "YES"or "No",RZ)
            Dbg:SetAttribute("u",tick())
        end
        if F.Parry and te then
            local fire,reason=ShouldFire(te,sp,pg,ds)
            if fire then
                RZ=reason
                PC=PC+1
                Fire(b)
            end
        end
    else
        VelH={}
        Track(nil)
    end
end)

BuildLoader()
print("PHURI V32.1 OK")
