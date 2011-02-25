-- urWater.lua
-- by Georg Essl 9/15/10

FreeAllRegions()

local pi = math.pi
local random = math.random
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local atan = math.atan

local cfade = 0
local fadespeed = 25
local dir = 1
function Fade(self,elapsed)
	self.t:SetSolidColor(0,0,0,cfade)

	cfade = cfade + dir * fadespeed
	if cfade > 255 then
		cfade = 255
		self.t:SetSolidColor(0,0,0,255)
		self:Handle("OnUpdate",nil)
	end
	if cfade < 0 then
		cfade = 0
		self.t:SetSolidColor(0,0,0,0)
		self:Hide()
		self:Handle("OnUpdate",nil)
	end
end

function FadeZ(self,x,y,z)
	if z > 0.9 and cfade < 255 then
		dir = 1
		sh:Show()
		sh:Handle("OnUpdate",Fade)
	elseif z <0.8 and cfade > 0 then
		dir = -1
		sh:Handle("OnUpdate",Fade)
	end
end

sh = Region()
sh.t = sh:Texture()
sh:SetWidth(ScreenWidth())
sh:SetHeight(ScreenHeight())
--sh.t:SetTexture(DocumentPath("smoke0.png"))
sh.t:SetSolidColor(0,0,0,255)
sh.t:SetBlendMode("BLEND")
sh:SetLayer("TOOLTIP")
sh:Handle("OnAccelerate",FadeZ)


local rotfilterx = {}
local rotfiltery = {}
local maxfilt
local downsampamount = 7

if ScreenWidth() > 641 then
	maxfilt = 50
else
	maxfilt = 12
end

for i=1,maxfilt do
	rotfilterx[i]=0
	rotfiltery[i]=0
end

local angle = 0
local ax = 0
local ay = 0

local amp = 1.0
local wateramp = 1.0

local function SetGain(x)
		amp = x/ScreenWidth()
		if x < 48 then amp = 0.0 StopSamples() end

--		uaPushA5:Push(amp)
--		uaPushB5:Push(amp)
--		uaPushC5:Push(amp)
--		uaPushD5:Push(amp)
end

local function SetWaterGain(wamp)
		uaPushC5:Push(amp*wamp)
		uaPushD5:Push(amp*wamp)
		wateramp = wamp
end

local downsample = 0

local pendt = 0
local scripted = true

if scripted then
	downsampamount = 0
	maxfilt = 1
end

function scriptedrotate(self, elapsed)
	rotate(self,1,0)
end

function rotate(self,x,y,z)

	x = -x
	y = -y
	
	if scripted then
--		if self == r[1] then
			y = 0.4*sin(2*pi*1/60.0*pendt/4.0)
			pendt = pendt+1
			x = math.sqrt(1-y*y)
--		else
--			return
--		end
	end
	
	if downsample < 0 then
	downsample = downsampamount
	local sumx = 0
	local sumy = 0

	for i=1,maxfilt-1 do
		rotfilterx[i+1]=rotfilterx[i]
		rotfiltery[i+1]=rotfiltery[i]
		sumx = sumx + rotfilterx[i+1]
		sumy = sumy + rotfiltery[i+1]
	end
	sumx = sumx + rotfilterx[1]
	sumx = sumx/maxfilt
	sumy = sumy + rotfiltery[1]
	sumy = sumy/maxfilt
	rotfilterx[1]=x
	rotfiltery[1]=y
	
	angle = 
	atan(sumy,sumx)
	

--	angle = sum
	ax = x
	ay = y

--    self.t:SetRotation(2*pi-pi*sum)--/2.5)
--	DPrint(sum)
--    self.t:SetSolidColor(255,255,255,255*(x+1.0)/2.0)
--    self.t:SetGradientColor("HORIZONTAL", 255,255,255,255*(x+1.0)/2.0,255,255,255,255*(x+1.0)/2.0)
	else
		downsample = downsample - 1
	end
	SetWaterGain(((1.0-x)*0.7+0.3))
end    

local currframe = 1

function flow(self, elapsed)

--	DPrint(elapsed)
--	local s = sqrt(2.0)/2.0*ax 
--	local c = -sqrt(2.0)/2.0*ay 
	local s = sqrt(2.0)/2.0*sin(angle+pi/4+pi/2);
	local c = sqrt(2.0)/2.0*cos(angle+pi/4+pi/2);
--	DPrint(s.." "..c.." "..angle.." "..self.pos)
	
	local tc0 = 0.5-s+self.pos
	local tc1 = 0.5+c
	local tc2 = 0.5+c+self.pos
	local tc3 = 0.5+s
	local tc4 = 0.5-c+self.pos
	local tc5 = 0.5-s
	local tc6 = 0.5+s+self.pos
	local tc7 = 0.5-c

    self.t:SetTexCoord(tc0,tc1,tc2,tc3,tc4,tc5,tc6,tc7)

--    self.t:SetTexCoord(0+self.pos,1+self.pos,0,1)
    self.pos = (self.pos +self.speed*((wateramp-0.2)*10)) % 1
	
	if self == r[2]  and currframe < 601 then
		local fstr = string.format("%04d", currframe)

		WriteScreenshot("Frame"..fstr..".png")
		currframe = currframe + 1
	end
	if currframe == 601 then
		DPrint("DONE")
		scripted = false
	end
end

r = {}
for i =1,4 do
    r[i] = Region()
    r[i]:SetWidth(ScreenHeight()*1.2) -- 1.35
    r[i]:SetHeight(ScreenHeight()*1.2)
--    r[i]:SetWidth(ScreenHeight()*1.35)
--    r[i]:SetHeight(ScreenHeight()*1.35)
    r[i]:SetAnchor("CENTER",UIParent,"CENTER",0,0)
    r[i].t = r[i]:Texture()
--    r[i].t:SetTexture(DocumentPath("wavel2"..i..".png"))
    r[i].t:SetTexture("wavel2"..i..".png")
    r[i].t:SetSolidColor(255,255,255,255)
	if not scripted then
    r[i]:Handle("OnAccelerate",rotate)
	end
    r[i]:Show()
    r[i].t:SetBlendMode("BLEND")
    r[i].t:SetTiling(true)
    r[i].speed = 0.01/(5-i)
    r[i].pos = 0
	if i > 1 then
		r[i]:Handle("OnUpdate", flow)
	end
end

local sqrt = math.sqrt
local floor = math.floor
local div = 10

local chord = {sqrt(3/2)-1,sqrt(6/5)-1,0,sqrt(9/5)-1, sqrt(6/5)-1, sqrt(9/5)-1, sqrt(9/5)-1,sqrt(9/5)-1, sqrt(9/5)-1,sqrt(5/4)-1}

local function SetChord(y)
	y = ScreenHeight()- y
--	DPrint(floor(y/ScreenHeight()*div+1).." "..chord[floor(y/ScreenHeight()*div)+1])
	uaPushA4:Push(chord[floor(y/ScreenHeight()*div)+1])
	uaPushC4:Push(chord[floor(y/ScreenHeight()*div)+1])
end

function Slide(self,x,y)
	if y< 64 or y > ScreenHeight()-64 then
		SetGain(x)
	end
end

local currentsample = 0
local maxsample = 5

function StopSamples(self)
	local x,y = InputPosition()
	
	if x < ScreenWidth()/3 then

		uaPushA2:Push(1)
		uaPushB2:Push(1)
		uaPushC2:Push(1)
		uaPushD2:Push(1)
	elseif x > ScreenWidth()/3*2 then
		if y< ScreenHeight()/2 then
			uaPushA1:Push(5.0/5)
			uaPushA2:Push(0) -- Start
		end
	end
end

function SlushWater(self)
	local x,y = InputPosition()
	
	if y< 64 or y > ScreenHeight()-65 then
		SetGain(x)
		if x < 48 then
			return 
		end
	end

	if x< ScreenWidth()/3 then
		if y< ScreenHeight()/2 then
			uaPushD1:Push(random())
			uaPushD2:Push(0) -- Start
		else
			uaPushC1:Push(random())
			uaPushC2:Push(0) -- Start
		end
	elseif x < ScreenWidth()/3*2 then
		if y< ScreenHeight()/2 then
			uaPushA1:Push(4.0/5)
			uaPushA2:Push(0) -- Start
		else
			uaPushA1:Push(0)
			uaPushA2:Push(0) -- Start
		end
	else
		if y< ScreenHeight()/2 then
			uaPushA1:Push(3.0/5)
			uaPushA2:Push(0) -- Start
		else
			uaPushA1:Push(2.0/5)
			uaPushA2:Push(0) -- Start
		end
	end

end


rb = Region()
rb.t = rb:Texture()
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight())
rb.t:SetTexture("smoke0.png")
rb.t:SetGradientColor("HORIZONTAL", 0,0,255,60,0,0,255,60)
rb.t:SetBlendMode("BLEND")
rb:Handle("OnTouchDown",SlushWater)
rb:Handle("OnDoubleTap",StopSamples)
rb:Handle("OnMove",Slide)
if scripted then
	rb:Handle("OnUpdate",scriptedrotate)
end
rb:EnableInput(true)
rb:Show()

if not uaSample then
uaSample = FlowBox("object","Sample", _G["FBSample"])

uaSample:AddFile("YoungGirl3.wav")
uaSample:AddFile("YoungGirl1.wav")
uaSample:AddFile("Haydn2-orig.wav")
uaSample:AddFile("YoungGirl2.wav")
uaSample:AddFile("Haydn2-C.wav")

uaSample2 = FlowBox("object","Sample", _G["FBSample"])

--uaSample2:AddFile("YoungGirl4.wav")
--uaSample2:AddFile("YoungGirl5.wav")
uaSample2:AddFile("YoungGirl6.wav")

uaSample3 = FlowBox("object","Sample", _G["FBSample"])
uaSample3:AddFile("river_bubbling.wav")

--uaSample3:AddFile("Bubbly.wav")
--uaSample3:AddFile("CrunchySlush.wav")
--uaSample3:AddFile("Running.wav")

uaSample4 = FlowBox("object","Sample", _G["FBSample"])
uaSample4:AddFile("water_stream_small03.wav")
--uaSample4:AddFile("waves1.wav")

uaPushA1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushA2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushA3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushA4 = FlowBox("object","PushA4", _G["FBPush"])
uaPushA5 = FlowBox("object","PushA4", _G["FBPush"])

uaPushB1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushB2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushB3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushB5 = FlowBox("object","PushA4", _G["FBPush"])

uaPushC1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushC2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushC3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushC4 = FlowBox("object","PushA3", _G["FBPush"])
uaPushC5 = FlowBox("object","PushA4", _G["FBPush"])

uaPushD1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushD2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushD3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushD5 = FlowBox("object","PushA4", _G["FBPush"])

--uaPitShift = FlowBox("object","PitShift", _G["FBPitShift"])
--uaPitShift3 = FlowBox("object","PitShift", _G["FBPitShift"])

dac = _G["FBDac"]

--dac:SetPullLink(0, uaSample, 0)
--dac:SetPullLink(0, uaSample2, 0)
--dac:SetPullLink(0, uaSample3, 0)
--dac:SetPullLink(0, uaSample4, 0)

--dac:SetPullLink(0,uaPitShift, 0)
--uaPitShift:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample2, 0)
--dac:SetPullLink(0,uaPitShift3, 0)
--uaPitShift:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample4, 0)

uaPushA1:SetPushLink(0,uaSample, 3)  -- Sample switcher
uaPushA1:Push(0) -- AM wobble
uaPushA2:SetPushLink(0,uaSample, 2) -- Reset pos
uaPushA2:Push(1) -- End
uaPushA3:SetPushLink(0,uaSample, 4) -- Set loop
uaPushA3:Push(-1)
--uaPushA4:SetPushLink(0,uaPitShift,1)
uaPushA5:SetPushLink(0,uaSample, 0) -- Set Amp

uaPushB1:SetPushLink(0,uaSample2, 3)  -- Sample switcher
uaPushB1:Push(0) -- AM wobble
uaPushB2:SetPushLink(0,uaSample2, 2) -- Reset pos
uaPushB2:Push(1) -- End
uaPushB3:SetPushLink(0,uaSample2, 4) -- Set loop
uaPushB3:Push(-1)
uaPushB5:SetPushLink(0,uaSample2, 0) -- Set Amp

uaPushC1:SetPushLink(0,uaSample3, 3)  -- Sample switcher
uaPushC1:Push(0) -- AM wobble
uaPushC2:SetPushLink(0,uaSample3, 2) -- Reset pos
uaPushC2:Push(1) -- End
uaPushC3:SetPushLink(0,uaSample3, 4) -- Set loop
uaPushC3:Push(-1)
--uaPushC4:SetPushLink(0,uaPitShift3,1)
uaPushC5:SetPushLink(0,uaSample3, 0) -- Set Amp

uaPushD1:SetPushLink(0,uaSample4, 3)  -- Sample switcher
uaPushD1:Push(0) -- AM wobble
uaPushD2:SetPushLink(0,uaSample4, 2) -- Reset pos
uaPushD2:Push(1) -- End
uaPushD3:SetPushLink(0,uaSample4, 4) -- Set loop
uaPushD3:Push(-1)
uaPushD5:SetPushLink(0,uaSample4, 0) -- Set Amp

else
dac:SetPullLink(0, uaSample, 0)
end

local function Shutdown()
--dac:RemovePullLink(0,uaPitShift, 0)
--uaPitShift:RemovePullLink(0, uaSample, 0)
dac:RemovePullLink(0, uaSample, 0)
dac:RemovePullLink(0, uaSample2, 0)
--dac:RemovePullLink(0,uaPitShift3, 0)
--uaPitShift:RemovePullLink(0, uaSample3, 0)
dac:RemovePullLink(0, uaSample3, 0)
dac:RemovePullLink(0, uaSample4, 0)
end

local function ReInit(self)
--dac:SetPullLink(0,uaPitShift, 0)
--uaPitShift:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample2, 0)
--dac:SetPullLink(0,uaPitShift3, 0)
--uaPitShift:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample4, 0)
end


function ShutdownAndFlip(self)
	Shutdown()
	FlipPage(self)
end

rb:Handle("OnPageEntered", ReInit)
rb:Handle("OnPageLeft", Shutdown)


--pagebutton=Region('region', 'pagebutton', UIParent);
--pagebutton:SetWidth(pagersize);
--pagebutton:SetHeight(pagersize);
--pagebutton:SetLayer("TOOLTIP");
--pagebutton:SetAnchor('BOTTOMLEFT',pagersize+4,ScreenHeight()-pagersize-4); 
--pagebutton:Handle("OnDoubleTap", ShutdownAndFlip)
--pagebutton:EnableInput(true);

DPrint(" ")
