FreeAllRegions()
DPrint("")
dofile(SystemPath("urHelpers.lua"))

local instrument = 1

local maxnotes = {11,11}

function Play(self)
	DPrint(instrument)
	if instrument == 1 then
     ucPushA2:Push(self.note/maxnotes[instrument])
     ucPushA1:Push(0.0)
	else
	 ucPushA4:Push(self.note/maxnotes[instrument])
	 ucPushA3:Push(0.0)
	end
	ColorWhite(self)
end

function Release(self)
 	if instrument == 1 then
     ucPushA2:Push(self.note/maxnotes[instrument])
     ucPushA1:Push(1.0)
	else
	 ucPushA4:Push(self.note/maxnotes[instrument])
	 ucPushA3:Push(1.0)
	end
	colorback(self)
end

ucSample = FlowBox("object","Sample1", _G["FBSample"])
ucSample2 = FlowBox("object","Sample2", _G["FBSample"])
ucSample3 = FlowBox("object","Sample3", _G["FBSample"])

ucSample2:AddFile("12DbWah2.wav")
ucSample2:AddFile("13EbWah2.wav")
ucSample2:AddFile("14FWah2.wav")
ucSample2:AddFile("15GbWah2.wav")
ucSample2:AddFile("16AbWah2.wav")
ucSample2:AddFile("17BbWah2.wav")
ucSample2:AddFile("18CbWah2.wav")
ucSample2:AddFile("19DbWah2.wav")
ucSample2:AddFile("20DWah2.wav")
ucSample2:AddFile("21EbWah2.wav")
ucSample2:AddFile("22FWah2.wav")
ucSample2:AddFile("23GbWah2.wav")

ucSample:AddFile("0DbBass1.wav")
ucSample:AddFile("1EbBass1.wav")
ucSample:AddFile("2FBass1.wav")
ucSample:AddFile("3GbBass1.wav")
ucSample:AddFile("4AbBass1.wav")
ucSample:AddFile("5BbBass1.wav")
ucSample:AddFile("6CbBass1.wav")
ucSample:AddFile("7DbBass2.wav")
ucSample:AddFile("8EbBass2.wav")
ucSample:AddFile("9FBass2.wav")
ucSample:AddFile("10GbBass2.wav")
ucSample:AddFile("11AbBass2.wav")


ucSample3:AddFile("FunkyLoop.wav")

dac = _G["FBDac"]

ucPushA1 = FlowBox("object","PushA1", _G["FBPush"])
ucPushA2 = FlowBox("object","PushA2", _G["FBPush"])

dac:SetPullLink(0, ucSample, 0)
ucPushA2:SetPushLink(0,ucSample, 3)  -- Sample switcher
ucPushA2:Push(0)
ucPushA1:SetPushLink(0,ucSample, 2) -- Reset pos

ucPushA1:Push(1.0)

ucPushA3 = FlowBox("object","PushA3", _G["FBPush"])
ucPushA4 = FlowBox("object","PushA4", _G["FBPush"])

dac:SetPullLink(0, ucSample2, 0)
ucPushA4:SetPushLink(0,ucSample2, 3)  -- Sample switcher
ucPushA4:Push(0)
ucPushA3:SetPushLink(0,ucSample2, 2) -- Reset pos

ucPushA3:Push(1.0)

ucPushA5 = FlowBox("object","PushA1", _G["FBPush"])

dac:SetPullLink(0, ucSample3, 0)
ucPushA5:SetPushLink(0,ucSample3, 2) -- Reset pos

ucPushA5:Push(1.0)

function bassSynth(self)
	ColorWhite(self)
	colorback(box[15])
	instrument = 1
end

function highPitch(self)
	ColorWhite(self)
	colorback(box[13])
	instrument = 2
end

local looptoggle = 0
function funkyLoop(self)
	DPrint(looptoggle)
	if looptoggle == 0 then
	ucPushA5:Push(0.0)
	ColorWhite(self)
	else
	ucPushA5:Push(1.0)
	colorback(self)
	end		
	looptoggle = 1 -looptoggle
end

function ColorWhite(self)
     self.texture:SetSolidColor(255,255,255)
end

function colorback(self)

     self.texture:SetSolidColor(self.r,self.g,self.b,self.a)
end

box = {}

local scalex = ScreenWidth()/320
local scaley = ScreenHeight()/480

ww = 90*scalex
hh = 75*scaley
yy = 0
xx = 0
bs = 110*scalex

for i=1,15 do
     if(i==7)then
         xx = xx + ww + 1
         yy = 0
     end
     if(i==13)then
         xx = xx + ww + 35
         yy = 0
     end

     box[i] = MakeRegion({w=ww, h=hh, layer='TOOLTIP', x=xx, y=yy, color=
'blue', input=true})
     if(i>=13)then
          yy = yy + hh + 10
     box[i].texture = box[i]:Texture("small-ball.png")
         box[i].texture:SetBlendMode("BLEND")
         box[i]:SetWidth(bs)
     box[i]:SetHeight(bs)
     else
     box[i].texture = box[i]:Texture()
     end
     yy = yy + hh + 5*scaley

     if(i % 2 == 0)then
         box[i].texture:SetSolidColor(65, 105, 255, 255)
         box[i].r = 65
         box[i].g = 105
         box[i].b = 255
         box[i].a = 255
     else
         box[i].texture:SetSolidColor(255,255,0, 255)
         box[i].r = 255
         box[i].g = 255
         box[i].b = 0
         box[i].a = 255
     end

     box[i].note = i-1

	if i < 13 then
     box[i]:Handle("OnTouchDown", Play)
     box[i]:Handle("OnTouchUp",Release)
     box[i]:Handle("OnEnter", Play)
     box[i]:Handle("OnLeave",Release)
	end
end
for x=7,12 do
      if(x % 2 == 0)then
         box[x].texture:SetSolidColor(255,255,0, 255)
         box[x].r = 255
         box[x].g = 255
         box[x].b = 0
         box[x].a = 255
     else
         box[x].texture:SetSolidColor(65, 105, 255, 255)
         box[x].r = 65
         box[x].g = 105
         box[x].b = 255
         box[x].a = 255
     end
end

bassSynth(box[13])
box[13]:Handle("OnTouchDown", bassSynth)
box[14]:Handle("OnTouchDown", funkyLoop)
box[15]:Handle("OnTouchDown", highPitch)

local pagebutton=Region('region', 'pagebutton', UIParent)
pagebutton:SetWidth(pagersize)
pagebutton:SetHeight(pagersize)
pagebutton:SetLayer("TOOLTIP")
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4)
pagebutton:EnableClamping(true)
--pagebutton:Handle("OnDoubleTap", FlipPage)
pagebutton:Handle("OnTouchDown", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png")
pagebutton.texture:SetGradientColor("TOP",255,255,255,255,255,255,255,255)
pagebutton.texture:SetGradientColor("BOTTOM",255,255,255,255,255,255,255,255)
pagebutton.texture:SetBlendMode("BLEND")
pagebutton.texture:SetTexCoord(0,1.0,0,1.0)
pagebutton:EnableInput(true)
pagebutton:Show()
