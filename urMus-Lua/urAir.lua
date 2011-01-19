-- urAir.lua
-- by Georg Essl 9/15/10

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

local small
if ScreenWidth() < 641 then
	spread = 0.4
	small = 0.8
	launch = 1
	drag = 1500
--	small = 0.5
	orientation = -1
else
	spread = 1
	small = 1
	launch = 5
	drag = 16000
--	small = 1
	orientation = -1
end

local retrigger = 0
local maxbubbles = 32

local ascale = 3

local scripted = true

function UpdateBubble(self)
--	visout = math.random()*.8
    if self.active==false then
        if math.random()<threshold*visout and retrigger == 0 then
			retrigger = maxbubbles
            self.active=true    
            self.x=ScreenWidth()/2 + (math.random()-1)*2
            if orientation == -1 then
                self.y=ScreenHeight()+64
            else                                         
                self.y=0
            end
            self.vx=(math.random()-0.5)*16*spread
            self.vy=visout*20*orientation*launch
			self.ax= 1 - (.001+math.random()/100)*small
			self.m= 1 + (math.random()-.5)/200
            self.size = 256*small*visout
            self:SetWidth(self.size)
            self:SetHeight(self.size)
            self:Show()        
        end
    else
--		self.rot = self.rot + self.rotspeed
--		self.t:SetRotation(self.rot)
        self.x = self.x + self.vx
        self.vx = self.vx * self.ax
        self.y = self.y + self.vy
		if scripted then
			self.vy = self.vy - 2
		end
        self.vy = self.vy * (1 - self.vy*self.vy/drag*self.m)
		-- DPrint(self.vy)
        if math.random()<threshold*2.5 then
            self.size = self.size+1
            self:SetWidth(self.size)
            self:SetHeight(self.size)
            self.t:SetGradientColor("HORIZONTAL", 255,255,255,self.size/ascale/small,255,255,255,self.size/ascale/small)
        end
        if self.y >= ScreenHeight()+64 or self.y < 0-64 then
            self.active=false
            self:Hide()
        end
    end

	if retrigger > 0 then
		retrigger = retrigger - 1
    end
	
    self:SetAnchor('CENTER', self.x , self.y)
end

--[[
function UpdateBubble(self)
    if self.active==false then
        if math.random()<threshold*visout then
            self.active=true    
            self.x=ScreenWidth()/2
            if orientation == -1 then
                self.y=ScreenHeight()-64
            else                                         
                self.y=0
            end
            self.vx=0
            self.vy=visout*10*orientation
            self.size = 128*small
            self:SetWidth(self.size)
            self:SetHeight(self.size)
            self:Show()        
        end
    else
        self.x = self.x + self.vx
        self.vx = self.vx + (math.random()-0.5)
        self.y = self.y + self.vy*small
        self.vy = self.vy + 0.1*small
        if math.random()<threshold*2.5 then
            self.size = self.size-1
            self:SetWidth(self.size*2)
            self:SetHeight(self.size*2)
            self.t:SetGradientColor("HORIZONTAL", 255,255,255,self.size/3/small,255,255,255,self.size/3*small)
        end
        if self.y >= ScreenHeight() or self.y < 0-64 then
            self.active=false
            self:Hide()
        end
    end
    
    self:SetAnchor('BOTTOMLEFT', self.x , self.y)
end
--]]

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

local sx = 0
local sy = -1

function AccelerateBall(self,x,y,z)

	if scripted then
		DPrint("OK")
		y = sy
		x = sx
	else
		DPrint("NO")
		self.vx = self.vx + x
		self.vy = self.vy + y
	end
--	FadeZ(z)
end

local waited = 5

function UpdateMic(self,elapsed)
	if scripted then
		waited = waited - elapsed
		if waited < -2 then
			waited = 5
		end
		if waited > 0 then
			visout = math.random(0.2,1.0)
			sx = math.random(-0.2,0.2)
		else
			visout = 0.0
		end
	else
		visout=_G["FBVis"]:Get()
	end
end

local curr_samp = 0
local random = math.random
local conn = true

local function SetGain(y)
	local amp = y/ScreenHeight()
	if y < 48 then amp = 0.0 StopSamples() end
	uaPushA5:Push(amp)
--	uaPushB5:Push(amp)
	uaPushC5:Push(amp)
	if amp < 0.05 and conn then
--		dac:RemovePullLink(0, uaSample, 0)
		conn = false
	elseif not conn then
--		dac:SetPullLink(0, uaSample, 0)
	end
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

function StopSamples(self)
	local x,y = InputPosition()
	
	if y < ScreenHeight()/2 then
		uaPushA2:Push(1)
		uaPushC3:Push(-1)
		uaPushC2:Push(1)
	end
end

local maxsampl = 11
local sampletoggle1 = 0
local sampletoggle2 = 2.0/maxsampl

function SwitchSample(self,x,y)
--	curr_samp = 1 - curr_samp
--	uaPushA2:Push(0)
--	uaPushA1:Push(curr_samp/6.95)
	if x< 64 then
		SetGain(y)
	elseif x > ScreenWidth()-65 then
		SetGain(y)
--		SetChord(y)
	elseif y > ScreenHeight()/2 then
		if x < ScreenWidth()/2 then
			sampletoggle1 = 1.0/maxsampl - sampletoggle1 
			uaPushA1:Push(sampletoggle1)
			uaPushA2:Push(0) -- Start
		else
			sampletoggle2 = sampletoggle2+ 1.0/maxsampl
			if sampletoggle2 > 8/12.0 then
				sampletoggle2 = 2.0/maxsampl
			end
--			DPrint(sampletoggle2*maxsampl)
			uaPushA1:Push(sampletoggle2)
			uaPushA2:Push(0) -- Start
		end
--			uaPushA4:Push(y/ScreenHeight()/2)
	else
--			uaPushA1:Push(1.0)
--			uaPushA2:Push(0) -- Start
			uaPushC3:Push(1)
			uaPushC1:Push(0)
			uaPushC2:Push(0) -- Start
--			uaPushB1:Push(random())
--			uaPushB2:Push(0) -- Start
	end
end

_G["FBMic"]:SetPushLink(0,_G["FBVis"],0)

rb = Region()
rb.t = rb:Texture()
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight())
--rb.t:SetTexture(DocumentPath("smoke0.png"))
rb.t:SetTexture("smoke0.png")
rb.t:SetGradientColor("HORIZONTAL", 255,255,255,200,255,255,255,200)
rb.t:SetBlendMode("BLEND")
rb:Handle("OnUpdate",UpdateMic)
rb:EnableInput(true)
rb:Handle("OnTouchDown",SwitchSample)
rb:Handle("OnDoubleTap", StopSamples)
rb:Handle("OnMove",Slide)
--rb:SetLayer("LOW")
rb:Show()

r = {}
local maxr = maxbubbles
if ScreenWidth() < 641 then
	maxr = maxbubbles
end

for i =1,maxr do
    r[i] = Region()
    r[i].size = 128*small
    r[i]:SetWidth(128*small)
    r[i]:SetHeight(128*small)
    r[i].x = ScreenWidth()/2.0
    r[i].y = ScreenHeight()/(1.0+i)
    r[i].active = true
    r[i]:SetAnchor("BOTTOMLEFT",r[i].x,r[i].y)
    r[i].t = r[i]:Texture()
--    r[i].t:SetTexture(DocumentPath("smoke1.png"))
--    r[i].t:SetTexture("smoke1.png")
    r[i].t:SetTexture("smoke1 copy.png")
	r[i].t:SetTiling(false)
    r[i].t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    r[i]:Show()
    r[i].t:SetBlendMode("BLEND")
    r[i].t:SetTiling(true)
    r[i].vx=0
    r[i].vy=0
	r[i].ax=0
	r[i].m=0
--	r[i].rot=math.random()*2*math.pi
--	r[i].rotspeed = (math.random()-0.5)*2*math.pi/10.0
    r[i]:Handle("OnUpdate",UpdateBubble)
    r[i]:Handle("OnAccelerate",AccelerateBall)
end

if not uaSample then
uaSample = FlowBox("object","Sample", _G["FBSample"])

uaSample:AddFile("OldMan1.wav")
uaSample:AddFile("OldMan1-low.wav")
uaSample:AddFile("OldMan1-girlinfluence.wav")
uaSample:AddFile("OldMan2.wav")
uaSample:AddFile("OldMan3.wav")
uaSample:AddFile("OldMan4.wav")
uaSample:AddFile("OldMan5.wav")
uaSample:AddFile("OldMan6.wav")
uaSample:AddFile("OldMan7.wav")
uaSample:AddFile("OldMan8.wav")
uaSample:AddFile("OldMan9.wav")
uaSample:AddFile("OldMan10.wav")

--uaSample2 = FlowBox("object","Sample", _G["FBSample"])

--uaSample2:AddFile("OldMan1-low.wav")
--uaSample2:AddFile("OldMan1-girlinfluence.wav")


uaSample3 = FlowBox("object","Sample", _G["FBSample"])
uaSample3:AddFile("WindLoop1.wav")

uaPushA1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushA2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushA3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushA4 = FlowBox("object","PushA4", _G["FBPush"])
uaPushA5 = FlowBox("object","PushA4", _G["FBPush"])

--uaPushB1 = FlowBox("object","PushA1", _G["FBPush"])
--uaPushB2 = FlowBox("object","PushA2", _G["FBPush"])
--uaPushB3 = FlowBox("object","PushA3", _G["FBPush"])
--uaPushB5 = FlowBox("object","PushA4", _G["FBPush"])

uaPushC1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushC2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushC3 = FlowBox("object","PushA3", _G["FBPush"])
uaPushC4 = FlowBox("object","PushA3", _G["FBPush"])
uaPushC5 = FlowBox("object","PushA4", _G["FBPush"])

--ucAsymp = FlowBox("object", "Asmpy", _G["FBAsymp"])
uaAvg = FlowBox("object", "Amp", _G["FBAvg"])
uaSqr = FlowBox("object", "Sqr", _G["FBPGate"])

dac = _G["FBDac"]
mic = _G["FBMic"]

--uaPitShift = FlowBox("object","PitShift", _G["FBPitShift"])
--uaPitShift3 = FlowBox("object","PitShift", _G["FBPitShift"])


--dac:SetPullLink(0,uaPitShift, 0)
--uaPitShift:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample, 0)
--dac:SetPullLink(0, uaSample2, 0)
--dac:SetPullLink(0,uaPitShift3, 0)
--uaPitShift:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample3, 0)

uaPushA1:SetPushLink(0,uaSample, 3)  -- Sample switcher
uaPushA1:Push(0) -- AM wobble
uaPushA2:SetPushLink(0,uaSample, 2) -- Reset pos
uaPushA3:SetPushLink(0,uaSample, 4) -- Set loop
uaPushA3:Push(-1)
--uaPushA4:SetPushLink(0,uaPitShift,1)
uaPushA5:SetPushLink(0,uaSample, 0) -- Set Amp

--uaPushB1:SetPushLink(0,uaSample2, 3)  -- Sample switcher
--uaPushB1:Push(0) -- AM wobble
--uaPushB2:SetPushLink(0,uaSample2, 2) -- Reset pos
--uaPushB2:Push(1) -- End
--uaPushB3:SetPushLink(0,uaSample2, 4) -- Set loop
--uaPushB3:Push(-1)
--uaPushB5:SetPushLink(0,uaSample2, 0) -- Set Amp

uaPushC1:SetPushLink(0,uaSample3, 3)  -- Sample switcher
uaPushC1:Push(0) -- AM wobble
uaPushC2:SetPushLink(0,uaSample3, 2) -- Reset pos
uaPushC2:Push(1) -- End
uaPushC3:SetPushLink(0,uaSample3, 4) -- Set loop
--uaPushC3:Push(-1)
--uaPushC4:SetPushLink(0,uaPitShift3,1)
uaPushC5:SetPushLink(0,uaSample3, 0) -- Set Amp


uaAvg:SetPushLink(0, uaSqr, 0)
uaSqr:SetPushLink(0, uaSample, 0)
mic:SetPushLink(0, uaAvg, 0)
else
dac:SetPullLink(0, uaSample, 0)
end

local function Shutdown()
--	dac:RemovePullLink(0,uaPitShift, 0)
--	uaPitShift:RemovePullLink(0, uaSample, 0)
	dac:RemovePullLink(0, uaSample, 0)
--	dac:RemovePullLink(0, uaSample2, 0)
--	dac:RemovePullLink(0,uaPitShift3, 0)
--	uaPitShift:RemovePullLink(0, uaSample3, 0)
	dac:RemovePullLink(0, uaSample3, 0)
end

local function ReInit(self)
--	dac:SetPullLink(0,uaPitShift, 0)
--	uaPitShift:SetPullLink(0, uaSample, 0)
	dac:SetPullLink(0, uaSample, 0)
--	dac:SetPullLink(0, uaSample2, 0)
--	dac:SetPullLink(0,uaPitShift3, 0)
--	uaPitShift:SetPullLink(0, uaSample3, 0)
	dac:SetPullLink(0, uaSample3, 0)
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
--pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4); 
--pagebutton:Handle("OnDoubleTap", ShutdownAndFlip)
--pagebutton:EnableInput(true);

DPrint(" ")

