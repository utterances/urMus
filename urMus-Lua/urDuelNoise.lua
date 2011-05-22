FreeAllRegions()

local scalex = ScreenWidth()/320.0
local scaley = ScreenHeight()/480.0

ucPushSampleSelect = FlowBox("object","PushA1", _G["FBPush"])
ucPushSamplePos = FlowBox("object","PushA2", _G["FBPush"])
ucSampleRate = FlowBox("object","PushA3",_G["FBPush"])

ucSample=FlowBox("object","Sample", _G["FBSample"])
ucSample:AddFile("sword1.wav")
ucSample:AddFile("sword2.wav")
ucSample:AddFile("sword3.wav")
ucSample:AddFile("boom.wav")

dac = _G["FBDac"]

dac:SetPullLink(0, ucSample, 0)
ucPushSampleSelect:SetPushLink(0,ucSample, 3)  -- Sample switcher
ucPushSamplePos:SetPushLink(0,ucSample, 2) -- Reset pos
ucSampleRate:SetPushLink(0,ucSample,1)
ucPushSamplePos:Push(1.0)
ucPushSampleSelect:Push(0)

snare = Region()
snare.t = snare:Texture()
snare:Show()
snare:SetWidth(145*scalex)
snare:SetHeight(145*scaley)
snare.t:SetTexture(100,100,100,255)
snare:SetAnchor("TOPLEFT",10*scalex,470*scaley)
snare.tl = snare:TextLabel()
snare.tl:SetLabel("Sword!")
snare.tl:SetFontHeight(24*scaley)
snare.tl:SetColor(0,255,255,255)
kick = Region()
kick.t = kick:Texture()
kick.t:SetTexture(100,100,100,255)
kick:Show()
kick:SetWidth(145*scalex)
kick:SetHeight(145*scaley)
kick:SetAnchor("TOPLEFT",165*scalex,470*scaley)
kick.tl = kick:TextLabel()
kick.tl:SetLabel("Clang!")
kick.tl:SetFontHeight(24*scaley)
kick.tl:SetColor(0,255,255,255)
crash = Region()
crash.t = crash:Texture()
crash:Show()
crash.t:SetTexture(100,100,100,255)
crash:SetAnchor("TOPLEFT",10*scalex,315*scaley)
crash:SetWidth(145*scalex)
crash:SetHeight(145*scaley)
crash.tl = crash:TextLabel()
crash.tl:SetLabel("Crash")
crash.tl:SetFontHeight(24*scaley)
crash.tl:SetColor(0,255,255,255)
click = Region()
click.t = click:Texture()
click:Show()
click.t:SetTexture(100,100,100,255)
click:SetAnchor("TOPLEFT",165*scalex,315*scaley)
click.tl = click:TextLabel()
click.tl:SetLabel("Big Ol' Drum")
click.tl:SetFontHeight(24*scaley)
click.tl:SetColor(0,255,255,255)
click:SetWidth(145*scalex)
click:SetHeight(145*scaley)

echo = Region()
echo.t=echo:Texture()
echo:Show()
echo.t:SetTexture(100,100,100,255)
echo:SetAnchor("BOTTOMLEFT",10*scalex,10*scaley)
echo.tl=echo:TextLabel()
echo.tl:SetLabel("Faster!")
echo.tl:SetFontHeight(24*scaley)
echo.tl:SetColor(0,0,0,255)
echo:SetWidth(300*scalex)
echo:SetHeight(150*scaley)

local toggle = false

function ColorDown(self)
ucPushSamplePos:Push(0.0)
end
function ColorUp(self)
self.t:SetSolidColor(100,100,100)
ucPushSamplePos:Push(1.0)
end
function snareHit(self)

self.t:SetSolidColor(255,255,255)   
ucSampleRate:Push(0.25+math.random()*0.05)
ucPushSampleSelect:Push(0)
ucPushSamplePos:Push(0.0)
end
function kickHit(self)

self.t:SetSolidColor(255,255,255)
ucSampleRate:Push(0.25+math.random()*0.05)
ucPushSampleSelect:Push(1/3)
ucPushSamplePos:Push(0.0)
end
function crashHit(self)

self.t:SetSolidColor(255,255,255)
ucSampleRate:Push(0.25+math.random()*0.05)
ucPushSampleSelect:Push(2/3)
ucPushSamplePos:Push(0.0)
end
function clickHit(self)

self.t:SetSolidColor(255,255,255)
ucSampleRate:Push(0.25+math.random()*0.05)
ucPushSampleSelect:Push(3/3)
ucPushSamplePos:Push(0.0)
end



function echoButton(self)
if(toggle) then
self.t:SetSolidColor(255,255,255)
ucSampleRate:Push(0.25+math.random()*0.20)
toggle = false
else self.t:SetSolidColor(100,100,100)
ucSampleRate:Push(0.25)
toggle= true
end
end

snare:Handle("OnTouchUp",ColorUp)
snare:Handle("OnTouchDown",snareHit)
--snare:Handle("OnTouchDown",ColorDown)
snare:EnableInput(true)
kick:Handle("OnTouchUp",ColorUp)
kick:Handle("OnTouchDown",kickHit)
--kick:Handle("OnTouchDown",ColorDown)
kick:EnableInput(true)
crash:Handle("OnTouchUp",ColorUp)
crash:Handle("OnTouchDown",crashHit)
--crash:Handle("OnTouchDown",ColorDown)
crash:EnableInput(true)
click:Handle("OnTouchUp",ColorUp)
click:Handle("OnTouchDown",clickHit)
--click:Handle("OnTouchDown",ColorDown)
click:EnableInput(true)
echo:Handle("OnDoubleTap",echoButton)
echo:EnableInput(true)

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