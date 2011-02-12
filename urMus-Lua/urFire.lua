-- urFire.lua
-- by Georg Essl 9/28/10

FreeAllRegions()

--damping = 0.9
--size = 48
--amount = 50
--active = 20
--mode = 0
--speed = 0.8
local threshold = 0.02*10
local visout = 0.0
local orientation

local random = math.random

local small
if ScreenWidth() < 400 then
	small = 0.5
	orientation = 1
else
	small = 1
	orientation = -1
end


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

function UpdateFire1(self)
	if self.alpha > 1 then
		self.angle = self.angle + self.rotspeed
		self.t:SetRotation(self.angle)
		self:SetWidth(self:Width()*self.growspeed)
		self:SetHeight(self:Height()*self.growspeed)
		self.alpha = self.alpha + self.alphaspeed
		self.t:SetGradientColor("HORIZONTAL", 255,255,255,self.alpha,255,255,255,self.alpha)
	else
		self:Handle("OnUpdate",nil)
		self:Hide()
	end
end

r={}
local maxfire = 10

function AddFire(i)
	local f1
	f1 = Region()
	f1.t = f1:Texture()
	f1.t:SetTexture("fire1.png")
    f1:SetWidth(64*small)
    f1:SetHeight(64*small)
    f1.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f1.t:SetBlendMode("BLEND")
	f1.angle = 0
	f1.growspeed = 1.25
	f1.rotspeed = 0.25
	f1.alpha = 128
	f1.alphaspeed = -2.5
	f1.type = 1

	local f2
	f2 = Region()
	f2.t = f2:Texture()
	f2.t:SetTexture("fire2.png")
    f2:SetWidth(64*small)
    f2:SetHeight(64*small)
    f2.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f2.t:SetBlendMode("BLEND")
	f2.angle = 0
	f2.growspeed = 1.15
	f2.rotspeed = 0.025
	f2.alpha = 128
	f2.alphaspeed = -2.5
	f2.type = 2
	
--	local i = #r
	f1.i = i
	f2.i = i
	r[i] = {}
    r[i].f1 = f1
	r[i].f2 = f2
end



for i=1,maxfire do
	AddFire(i)
end

currfire = 1

local function SetGain(y)
		local amp = y/ScreenHeight()
		if y < 48 then
			amp = 0.0
			uaPushA2:Push(1) -- End
			uaPushB2:Push(1) -- End
			uaPushC2:Push(1) -- End
			uaPushD2:Push(1) -- End
		end
--		uaPushA5:Push(amp)
--		uaPushB5:Push(amp)
--		uaPushC5:Push(amp)
--		uaPushD5:Push(amp)
end

local sqrt = math.sqrt
local floor = math.floor
local div = 10

local chord = {sqrt(3/2)-1,sqrt(6/5)-1,0,sqrt(9/5)-1, sqrt(6/5)-1, sqrt(9/5)-1, sqrt(9/5)-1,sqrt(9/5)-1, sqrt(9/5)-1,sqrt(5/4)-1}

local function SetChord(y)
--	DPrint(floor(y/ScreenHeight()*div+1).." "..chord[floor(y/ScreenHeight()*div)+1])
	uaPushA4:Push(chord[floor(y/ScreenHeight()*div)+1])
	uaPushC4:Push(chord[floor(y/ScreenHeight()*div)+1])
end

function Slide(self,x,y)
	if x< 64 or x > ScreenWidth()-64 then
		SetGain(y)
	end
end

local scripted = true
local scriptx = 0
local scripty = 0

function SpawnFire(self)
	local x,y = InputPosition()

	if scripted then
		x,y = scriptx, scripty
	end
	
	local f1 = r[currfire].f1
	
    f1:SetWidth(64*small)
    f1:SetHeight(64*small)
    f1:SetAnchor("CENTER",UIParent,"BOTTOMLEFT",x,y)
    f1.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f1:Show()
	f1.angle = 0
	f1.alpha = 128
    f1:Handle("OnUpdate",UpdateFire1)

 	local f2 = r[currfire].f2

    f2:SetWidth(64*small)
    f2:SetHeight(64*small)
    f2:SetAnchor("CENTER",UIParent,"BOTTOMLEFT",x,y)
    f2.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f2:Show()
	f2.angle = 0
	f2.alpha = 128
    f2:Handle("OnUpdate",UpdateFire1)
	
	currfire = currfire + 1
	if currfire > maxfire then
		currfire = 1
	end
	
	if x< 64 or x > ScreenWidth()-65 then
		SetGain(y)
		if y < 48 then
			return
		end
	end
		
	if x< ScreenWidth()/2 then
		if y < ScreenHeight()/2 then
			uaPushA1:Push(random())
			uaPushA2:Push(0) -- Start
			uaPushA4:Push(y/ScreenHeight()/2)
		else
			uaPushB1:Push(random())
			uaPushB2:Push(0) -- Start
		end
	else
		if y < ScreenHeight()/2 then
			uaPushC1:Push(random())
			uaPushC2:Push(0) -- Start
			uaPushC4:Push(y/ScreenHeight()/2)
		else
			rb:Handle("OnUpdate",Flicker)

			uaPushD1:Push(random())
			uaPushD2:Push(0) -- Start
		end
	end
end

local currwait = 0
local scriptpos = 0
local sscript = {{4,0,1,0,0},{4,1,1,0,0},{4,0,1,0,0},{4,1,1,0,0},{4,0,1,1,1},{4,1,1,1,1},{4,0,1,1,1},{4,1,1,1,1},{4,0,1,0,0},{4,1,1,0,0},{4,0,1,0,0},{4,1,1,0,0},{4,0,1,1,1},{4,1,1,1,1},{4,0,1,1,1},{4,1,1,1,1}}

local currframe = 1

function Flicker(self,elapsed)
	self.t:SetGradientColor("TOP", random(200,255),0,0,random(40,80),random(200,255),0,0,random(40,80))
	self.t:SetGradientColor("BOTTOM", random(200,255),0,0,random(40,80),random(200,255),0,0,random(40,80))
	if scripted then
		if currwait <= 0 then
			if scriptpos > #sscript then
				scripted = false
			else
				scriptpos = scriptpos + 1
				DPrint(scriptpos)
				currwait = sscript[scriptpos][1]
				if sscript[scriptpos][2] > 0 then
					scriptx = random(ScreenWidth()/8.0,3*ScreenWidth()/8.0)
					scripty = random(ScreenHeight()/8.0,3*ScreenHeight()/8.0)
					SpawnFire(rb)
				end
				if sscript[scriptpos][3] > 0 then
					scriptx = random(ScreenWidth()/8.0,3*ScreenWidth()/8.0)
					scripty = random(5*ScreenHeight()/8.0,7*ScreenHeight()/8.0)
					SpawnFire(rb)
				end
				if sscript[scriptpos][4] > 0 then
					scriptx = random(5*ScreenWidth()/8.0,7*ScreenWidth()/8.0)
					scripty = random(ScreenHeight()/8.0,3*ScreenHeight()/8.0)
					SpawnFire(rb)
				end
				if sscript[scriptpos][5] > 0 then
					scriptx = random(5*ScreenWidth()/8.0,7*ScreenWidth()/8.0)
					scripty = random(5*ScreenHeight()/8.0,7*ScreenHeight()/8.0)
					SpawnFire(rb)
				end
			end
		else
			currwait = currwait - elapsed
		end
	end
	WriteScreenshot("Frame"..currframe)
	currframe = currframe + 1
end

rb = Region()
rb.t = rb:Texture()
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight())
--rb.t:SetTexture(DocumentPath("smoke0.png"))
rb.t:SetTexture("smoke0.png")
rb.t:SetGradientColor("HORIZONTAL", 255,0,0,60,255,0,0,60)
rb.t:SetBlendMode("BLEND")
rb:Handle("OnTouchDown",SpawnFire)
rb:Handle("OnMove",Slide)
rb:SetLayer("LOW")
rb:EnableInput(true)
rb:Show()

if not uaSample then
uaSample = FlowBox("object","Sample", _G["FBSample"])

uaSample:AddFile("MidManB1.wav")
uaSample:AddFile("MidManB2.wav")

uaSample2 = FlowBox("object","Sample", _G["FBSample"])

--uaSample2:AddFile("MidManR1.wav")
uaSample2:AddFile("MidManR2.wav")
uaSample2:AddFile("MidManR3.wav")
uaSample2:AddFile("MidManR4.wav")
uaSample2:AddFile("MidManR5.wav")
uaSample2:AddFile("MidManR6.wav")
uaSample2:AddFile("MidManR7.wav")
uaSample2:AddFile("MidManR8.wav")
--uaSample2:AddFile("MidManR9.wav")
--uaSample2:AddFile("MidManR10.wav")
--uaSample2:AddFile("MidManR11.wav")
--uaSample2:AddFile("MidManR12.wav")
--uaSample2:AddFile("MidManR13.wav")
--uaSample2:AddFile("MidManR14.wav")
--uaSample2:AddFile("MidManR15.wav")

uaSample3 = FlowBox("object","Sample", _G["FBSample"])
uaSample3:AddFile("MidManS1.wav")
uaSample3:AddFile("MidManS2.wav")
uaSample3:AddFile("MidManS3.wav")
uaSample3:AddFile("MidManS4.wav")

uaSample4 = FlowBox("object","Sample", _G["FBSample"])
uaSample4:AddFile("FireCrackle.wav")
uaSample4:AddFile("FireCrackle2.wav")

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


if scripted then
	rb:Handle("OnUpdate",Flicker)

	uaPushD1:Push(random())
	uaPushD2:Push(0) -- Start
end

--pagebutton=Region('region', 'pagebutton', UIParent);
--pagebutton:SetWidth(pagersize);
--pagebutton:SetHeight(pagersize);
--pagebutton:SetLayer("TOOLTIP");
--pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4); 
--pagebutton:Handle("OnDoubleTap", ShutdownAndFlip)
--pagebutton:EnableInput(true);

DPrint(" ")

