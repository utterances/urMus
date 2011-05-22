
FreeAllRegions()

local scalex = ScreenWidth()/320.0
local scaley = ScreenHeight()/480.0

-- Handler functions
local dacconnected = nil

function SetSliderPos(self,x,y)
--    local x,y = InputPosition()
--    if x > 160*scalex then return end
    local left = r2:Left()
    local RateScale = 0.25 + 0.5*y/ScreenHeight()
    --local AmpScale = y/ScreenHeight()
    r2:SetAnchor("BOTTOMLEFT",left,y-r2:Height()/2)
    ratePush:Push(RateScale)
    --AmpPush:Push(AmpScale)
    if not dacconnected then
        AmpPush:Push(1)
        dac:SetPullLink(0,WindSample,0)
        dacconnected = true
        DPrint("SetSlider")
    elseif dacfade then
        self:Handle("OnUpdate",nil)
        dacfade = nil
        AmpPush:Push(1)
        dacconnected = true
    end
end

function FadeDac(self, elapsed)
    self.waittime = self.waittime - elapsed
    if self.waittime < 0 then
        dac:RemovePullLink(0,WindSample,0)
        dacconnected = nil
        DPrint("Stop")
        self:Handle("OnUpdate",nil)
        dacfade = nil
    else
        AmpPush:Push(self.waittime)
    end
end

function DisablePullLink(self)
if dacconnected and not dacfade then
    dacfade = true
    self.waittime = 1
    self:Handle("OnUpdate", FadeDac)
end
end

function stop1(self)
    self.t:SetTexture(0,0,255,255)
end

function DrumSound1(self)
    ucPushA1:Push(0.0)
    self.t:SetTexture(0,0,0,255)
end
function StopDrum1(self)
    ucPushA1:Push(1.0)
    self.t:SetTexture(0,0,255,255)
end

function DrumSound2(self)
    ucPushA2:Push(0.0)
    self.t:SetTexture(0,0,0,255)
end
function StopDrum2(self)
    ucPushA2:Push(1.0)
    self.t:SetTexture(0,0,255,255)
end

dac = _G["FBDac"]
WindSample = FlowBox("object","Sample", _G["FBSample"])
WindSample:AddFile("didgeridoo_mod1.wav")

Drum1 = FlowBox("object","Sample", _G["FBSample"])
Drum1:AddFile("Rain.wav")
ucPushA1 = FlowBox("object","PushA1", _G["FBPush"])
ucAmplitude1 = FlowBox("object","PushA1", _G["FBPush"])
ucPushA1:SetPushLink(0,Drum1, 2) -- Reset pos
ucAmplitude1:SetPushLink(0,Drum1, 0) -- Amplitude pos
ucPushA1:Push(1.0)
ucAmplitude1:Push(0.3)
dac:SetPullLink(0, Drum1, 0)

Drum2 = FlowBox("object","Sample", _G["FBSample"])
Drum2:AddFile("Thnder.wav")
ucPushA2 = FlowBox("object","PushA2", _G["FBPush"])
ucAmplitude2 = FlowBox("object","PushA1", _G["FBPush"])
ucPushA2:SetPushLink(0,Drum2, 2) -- Reset pos
ucAmplitude2:SetPushLink(0,Drum2, 0) -- Amplitude pos
ucPushA2:Push(1.0)
ucAmplitude2:Push(1.0)
dac:SetPullLink(0, Drum2, 0)

ratePush = FlowBox(_G["FBPush"]) -- Sample rate modulator
AmpPush = FlowBox(_G["FBPush"]) -- Sample amplitude modulator
ratePush:SetPushLink(0,WindSample,1)
AmpPush:SetPushLink(0,WindSample,0)

-- Background region
r0 = Region()
r0.t = r0:Texture()
r0:Show()
r0:SetWidth(ScreenWidth())
r0:SetHeight(ScreenHeight())
r0.t:SetTexture(255,255,255,255)

--Background slide bar region
r1 = Region()
r1.t = r1:Texture()
r1:Show()
r1:SetWidth(r1:Width()/12*scalex)
r1:SetHeight(ScreenHeight())
r1.t:SetTexture(100,100,100,255)
r1:SetAnchor("CENTER",ScreenWidth()/4-20*scalex,ScreenHeight()/2)

r1b = Region()
r1b:SetWidth(ScreenWidth()/3)
r1b:SetHeight(ScreenHeight())
r1b:SetAnchor("CENTER",ScreenWidth()/4-20*scalex,ScreenHeight()/2)
--r1b:SetAnchor("CENTER", r1, "CENTER",0,0)
r1b:SetLayer("TOOLTIP")

-- Slide bar box region
r2 = Region()
r2.t = r2:Texture()
r2:SetWidth(ScreenWidth()/3.5)
r2:SetHeight(r0:Height()/11)
r2:SetAnchor("CENTER",r1,"CENTER",0,-220)
r2.t:SetTexture(0,0,0,255)
r2:Show()


r2_1 = Region()
r2_1.t = r2_1:Texture()
r2_1:SetWidth(r2:Width()/1.1)
r2_1:SetHeight(r2:Height()/1.2)
r2_1:SetAnchor("CENTER",r2,"CENTER")
r2_1.t:SetTexture(0,0,255,255)
r2_1:Show()

--Drum2 region
r3 = Region()
r3.t = r3:Texture()
r3:SetWidth(r3:Width()/2*scalex)
r3:SetHeight(r3:Height()/2*scaley)
r3:SetAnchor("CENTER",ScreenWidth()*2/3+30*scalex,ScreenHeight()*2/3)
r3.t:SetTexture(0,0,0,255)
r3:Show()

r3_1 = Region()
r3_1.t = r3_1:Texture()
r3_1:SetWidth(r3:Width()/1.1)
r3_1:SetHeight(r3:Height()/1.1)
r3_1:SetAnchor("CENTER",r3,"CENTER")
r3_1.t:SetTexture(0,0,255,255)
r3_1:Show()
r3_1.tl = r3_1:TextLabel()
r3_1.tl:SetLabel("Thunder")

--Drum1 region
r4 = Region()
r4.t = r4:Texture()
r4:SetWidth(r4:Width()/2*scalex)
r4:SetHeight(r4:Height()/2*scaley)
r4:SetAnchor("CENTER",ScreenWidth()*2/3+30*scalex,ScreenHeight()/3)
r4.t:SetTexture(0,0,0,255)
r4:Show()

r4_1 = Region()
r4_1.t = r4_1:Texture()
r4_1:SetWidth(r4:Width()/1.1)
r4_1:SetHeight(r4:Height()/1.1)
r4_1:SetAnchor("CENTER",r4,"CENTER")
r4_1.t:SetTexture(0,0,255,255)
r4_1:Show()
r4_1.tl = r4_1:TextLabel()
r4_1.tl:SetLabel("Rain")

--Region Handlers
--r2:EnableInput(true)
--r2:Handle("OnTouchUp", DisablePullLink) -- Stop sound when finger is removed

r1b:EnableInput(true)
r1b:Handle("OnTouchDown", SetSliderPos)
r1b:Handle("OnMove", SetSliderPos)
r1b:Handle("OnTouchUp", DisablePullLink) -- Stop sound when finger is removed

r3_1:EnableInput(true)
r3_1:Handle("OnTouchDown", DrumSound2) -- Thunder sound, button turns black when pushed
r3_1:Handle("OnTouchUp", StopDrum2) -- Release sound, button returns to blue

r4_1:EnableInput(true)
r4_1:Handle("OnTouchDown", DrumSound1)
r4_1:Handle("OnTouchUp", StopDrum1)

local pagebutton=Region()
pagebutton:SetWidth(pagersize)
pagebutton:SetHeight(pagersize)
pagebutton:SetLayer("TOOLTIP")
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4); 
pagebutton:EnableClamping(true)
pagebutton:Handle("OnDoubleTap", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png")
pagebutton.texture:SetBlendMode("BLEND")
pagebutton:EnableInput(true)
pagebutton:Show()
