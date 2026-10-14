-- PHURI V34.2 (CYBER ONLY)
local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local VIM=game:GetService("VirtualInputManager")
local TW=game:GetService("TweenService")
local SS=game:GetService("SoundService")
local LP=Players.LocalPlayer

local HR=nil
local function bindChar(c) HR=c:WaitForChild("HumanoidRootPart") end
if LP.Character then bindChar(LP.Character) end
LP.CharacterAdded:Connect(bindChar)

local F={Parry=false,Spin=false}
local fps,fc,ft=60,0,tick()
local PC=0
local RZ="-"
local Dbg=nil
local SpinIdx=4
local SpinSp={180,360,720,1440}
local SpinNm={"Slow","Mid","Fast","Insane"}
local LastFire=0
local VelH={}
local PingH={}
local TuneSt="idle"
local TuneS={}
local TuneStart=0
local TuneScore=0
local PAR={HB=20,SB=12,SC=0.18,JB=0.05,MI=0.08,RHB=8,RS=0.35}
local Gen=0
local LastGen=-1
local LastV=nil
local LastP=nil
local LastBall=nil
local RBAct=false
local RBTime=0
local ATD=0.025
local MainSG=nil
local SpA,SpAV=nil,nil

local Frozen=false
local FrozenTime=0
local LastSpeed=0
local SpeedJump=false
local PositionJump=false
local TargetUs=false

-- ⭐️ Cyber Theme Only
local CY={A=Color3.fromRGB(255,0,128),B=Color3.fromRGB(255,215,0),C=Color3.fromRGB(0,255,255),ON=Color3.fromRGB(180,0,90)}
local GL={}
local TL={}

local BuildUI

local function StartTune() TuneSt="sampling" TuneStart=tick() TuneS={} TuneScore=0 end

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
    if TuneScore>=85 then PAR.HB=20 PAR.SB=14 PAR.SC=0.20 ATD=0.018
    elseif TuneScore>=70 then PAR.HB=20 PAR.SB=13 PAR.SC=0.19 ATD=0.022
    elseif TuneScore>=50 then PAR.HB=21 PAR.SB=12 PAR.SC=0.18 ATD=0.028
    else PAR.HB=22 PAR.SB=11 PAR.SC=0.16 ATD=0.035 end
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

BuildUI=function()
    if MainSG then MainSG:Destroy() end
    GL={} TL={}
    local SG=Instance.new("ScreenGui",LP:WaitForChild("PlayerGui"))
    SG.Name="PHURI_"..math.random(1,10000)
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
    SK2.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CY.A),ColorSequenceKeypoint.new(0.5,CY.B),ColorSequenceKeypoint.new(1,CY.C)})
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
    TL2.Text="PHURI V34.2 CYBER"
    TL2.TextColor3=Color3.fromRGB(255,255,255)
    TL2.Font=Enum.Font.GothamBold
    TL2.TextSize=13
    TL2.TextXAlignment=Enum.TextXAlignment.Left
    local TLG=Instance.new("UIGradient",TL2)
    TLG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CY.A),ColorSequenceKeypoint.new(1,CY.C)})

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
        b.BackgroundColor3=def and CY.ON or Color3.fromRGB(30,30,45)
        b.Text=txt..(def and ": ON" or ": OFF")
        b.TextColor3=Color3.fromRGB(255,255,255)
        b.Font=Enum.Font.GothamBold
        b.TextSize=12
        b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        local on=def or false
        F[key]=on
        b.MouseButton1Click:Connect(function()
            on=not on F[key]=on
            b.Text=txt..(on and ": ON" or ": OFF")
            b.BackgroundColor3=on and CY.ON or Color3.fromRGB(30,30,45)
            if cb then cb(on)end
        end)
    end

    Tog("AUTO PARRY (AI)","Parry",false,function(on)
        if on then StartTune() else TuneSt="idle" TuneS={} end
    end)

    Dbg=Instance.new("TextLabel",SC)
    Dbg.Size=UDim2.new(1,-6,0,120)
    Dbg.BackgroundColor3=Color3.fromRGB(20,20,35)
    Dbg.Text="AUTO PARRY\n0 | FPS: -- | Ping: --\ntEntry: -- | HB: --\nGen: 0 | State: --\nReason: --"
    Dbg.TextColor3=Color3.fromRGB(255,200,100)
    Dbg.Font=Enum.Font.GothamBold
    Dbg.TextSize=10
    Dbg.BorderSizePixel=0
    Dbg.TextWrapped=true
    Instance.new("UICorner",Dbg).CornerRadius=UDim.new(0,6)

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
end

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
    lgrd.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CY.A),ColorSequenceKeypoint.new(1,CY.C)})

    local ltxt=Instance.new("TextLabel",lbox)
    ltxt.Size=UDim2.new(1,0,0,25)
    ltxt.Position=UDim2.new(0,0,0,6)
    ltxt.BackgroundTransparency=1
    ltxt.Text="PHURI HUB"
    ltxt.TextColor3=CY.A
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
    lbf.BackgroundColor3=CY.A
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
        if not ws.IsPlaying then ws.Parent=workspace pcall(function()ws:Play()end) end
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

local function GetBall()
    local bs=workspace:FindFirstChild("Balls")
    if bs then for _,b in pairs(bs:GetChildren())do if b:IsA("BasePart")then return b end end end
    for _,o in pairs(workspace:GetChildren())do if o:IsA("BasePart")and o.Name:find("Ball")then return o end end
end

local function SmoothV(b)
    table.insert(VelH,b.AssemblyLinearVelocity)
    if #VelH>5 then table.remove(VelH,1)end
    local s=Vector3.new(0,0,0)
    for _,v in ipairs(VelH)do s=s+v end
    return s/math.max(#VelH,1)
end

local function SmoothP(rp)
    table.insert(PingH,rp)
    if #PingH>10 then table.remove(PingH,1)end
    local s=0
    for _,p in ipairs(PingH)do s=s+p end
    return s/math.max(#PingH,1)
end

local function AnalyzeBall(b)
    if not b then
        Frozen=false FrozenTime=0 SpeedJump=false PositionJump=false TargetUs=false
        LastV=nil LastP=nil LastBall=nil RBAct=false LastSpeed=0
        return
    end
    local v=b.AssemblyLinearVelocity
    local p=b.Position
    local spd=v.Magnitude
    local now=tick()
    if b~=LastBall then
        Gen=Gen+1 LastGen=-1 LastBall=b LastV=v LastP=p LastSpeed=spd
        Frozen=false FrozenTime=0 SpeedJump=false PositionJump=false RBAct=false
        return
    end
    if spd<20 and LastSpeed>50 then
        if not Frozen then Frozen=true FrozenTime=now end
    elseif spd>50 then
        if Frozen then Frozen=false Gen=Gen+1 LastGen=-1 end
    end
    if LastSpeed>0 and spd>LastSpeed*2.5 and spd>200 then
        SpeedJump=true Gen=Gen+1 LastGen=-1
    else SpeedJump=false end
    if LastP and (p-LastP).Magnitude>40 then
        PositionJump=true Gen=Gen+1 LastGen=-1
    else PositionJump=false end
    if LastV then
        local dot=v:Dot(LastV)
        if dot<0 and spd>50 and LastV.Magnitude>50 then
            local toUs=HR.Position-p
            if toUs.Magnitude>0.1 and v.Unit:Dot(toUs.Unit)>0.4 then
                Gen=Gen+1 LastGen=-1 RBAct=true RBTime=now
            end
        end
    end
    if RBAct and now-RBTime>1.5 then RBAct=false end
    local toUs=HR.Position-p
    if toUs.Magnitude>0.1 then
        local ang=v.Unit:Dot(toUs.Unit)
        if ang>0.85 and spd>100 then TargetUs=true else TargetUs=false end
    end
    LastV=v LastP=p LastSpeed=spd
end

local function SimulateEntry(b,sv,pg)
    if not HR or not HR.Parent then return nil end
    local rp=b.Position-HR.Position
    local rv=sv-HR.AssemblyLinearVelocity
    local sp=rv.Magnitude
    if Frozen then
        if rp.Magnitude<=PAR.HB+8 then return 0,PAR.HB+8,0 end
        return nil,PAR.HB,0
    end
    if sp<10 then return nil end
    local hb=PAR.HB+math.min(sp/140,PAR.SB)
    if RBAct then hb=hb+PAR.RHB end
    if SpeedJump then hb=hb+4 end
    if PositionJump then hb=hb+3 end
    if TargetUs then hb=hb+2 end
    local dt=1/60
    for i=1,30 do
        local t=i*dt
        local fp=rp+rv*t
        local dist=fp.Magnitude
        if dist<=hb then
            if dist<1 then return 0,hb,sp end
            return t,hb,sp
        end
        if i>3 then
            local prevt=(i-1)*dt
            local prevfp=rp+rv*prevt
            if fp.Magnitude>prevfp.Magnitude and prevfp.Magnitude>hb*2 then
                return nil,hb,sp
            end
        end
    end
    return nil,hb,sp
end

local function ShouldFire(te,sp,pg,ds)
    if Frozen and ds<=PAR.HB+8 then return true,"FROZEN" end
    if SpeedJump then
        local td=pg*0.4+ATD*0.6+0.03
        if te and te<=td+0.05 then return true,"SPEED" end
    end
    if TargetUs then
        local td=pg*0.45+ATD*0.7+0.04
        if te and te<=td+0.05 then return true,"TARGET" end
    end
    if RBAct then
        local td=pg*PAR.RS+ATD*0.5+0.03
        if te<=td+0.05 then return true,"REBOUND" end
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
    local mi=RBAct and 0.06 or PAR.MI
    if n-LastFire<mi then return end
    if b==LastBall and LastGen==Gen then return end
    if not b or not b.Parent or not HR or not HR.Parent then return end
    LastFire=n LastGen=Gen
    task.spawn(function()
        pcall(function()
            VIM:SendKeyEvent(true,Enum.KeyCode.F,false,game)
            task.wait(0.01)
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
        AnalyzeBall(b)
        local sv=SmoothV(b)
        local te,hb,sp=SimulateEntry(b,sv,pg)
        local ds=(b.Position-HR.Position).Magnitude
        if Dbg and tick()-(Dbg:GetAttribute("u")or 0)>0.15 then
            local ts=te and string.format("%.3fs",te)or "miss"
            local ai
            if TuneSt=="sampling" then ai="AI Scanning: "..math.floor(tick()-TuneStart).."/3s"
            elseif TuneSt=="done" then ai=string.format("AI Score: %d/100",TuneScore)
            else ai="AI: Ready" end
            local state="-"
            if Frozen then state="FROZEN"
            elseif SpeedJump then state="SPEED"
            elseif PositionJump then state="WARP"
            elseif RBAct then state="REBOUND"
            elseif TargetUs then state="TARGET"
            end
            Dbg.Text=string.format("%s\nParries: %d | FPS: %d | Ping: %.0fms\ntEntry: %s | HB: %.0f\nGen: %d | State: %s\nReason: %s",ai,PC,fps,pg*1000,ts,hb or 0,Gen,state,RZ)
            Dbg:SetAttribute("u",tick())
        end
        if F.Parry and (te or (Frozen and ds<=PAR.HB+8)) then
            local fire,reason=ShouldFire(te,sp,pg,ds)
            if fire then
                RZ=reason
                PC=PC+1
                Fire(b)
            end
        end
    else
        VelH={}
        AnalyzeBall(nil)
    end
end)

BuildLoader()
print("PHURI V34.2 CYBER OK")
