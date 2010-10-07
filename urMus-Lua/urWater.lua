-- urWater.lua
-- by Georg Essl 9/15/10

FreeAllRegions()

local pi = math.pi
local random = math.random
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local atan = math.atan

local rotfilter = {}
rotfilter[1]=0
rotfilter[2]=0
rotfilter[3]=0
rotfilter[4]=0

local angle = 0
local ax = 0
local ay = 0

function rotate(self,x,y,z)
	local sum = 0

	for i=1,3 do
		rotfilter[i+1]=rotfilter[i]
		sum = sum + rotfilter[i+1]
	end
	sum = sum + rotfilter[1]
	sum = sum/4
	rotfilter[1]=x
	
	angle = atan(y,x)

--	angle = sum
	ax = x
	ay = y

--    self.t:SetRotation(2*pi-pi*sum)--/2.5)
--	DPrint(sum)
--    self.t:SetSolidColor(255,255,255,255*(x+1.0)/2.0)
--    self.t:SetGradientColor("HORIZONTAL", 255,255,255,255*(x+1.0)/2.0,255,255,255,255*(x+1.0)/2.0)
end    

function flow(self, elapsed)

--	local s = sqrt(2.0)/2.0*ax 
--	local c = -sqrt(2.0)/2.0*ay 
	local s = sqrt(2.0)/2.0*sin(angle+pi/4+pi/2);
	local c = sqrt(2.0)/2.0*cos(angle+pi/4+pi/2);
--	DPrint(s.." "..c.." "..angle)
	
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
    self.pos = self.pos +self.speed % 1
end

r = {}
for i =1,4 do
    r[i] = Region()
    r[i]:SetWidth(ScreenHeight()*1.35)
    r[i]:SetHeight(ScreenHeight()*1.35)
--    r[i]:SetWidth(ScreenHeight()*1.35)
--    r[i]:SetHeight(ScreenHeight()*1.35)
    r[i]:SetAnchor("CENTER",UIParent,"CENTER",0,0)
    r[i].t = r[i]:Texture()
--    r[i].t:SetTexture(DocumentPath("wavel2"..i..".png"))
    r[i].t:SetTexture(DocumentPath("wavel2"..i..".png"))
    r[i].t:SetSolidColor(255,255,255,255)
    r[i]:Handle("OnAccelerate",rotate)
    r[i]:Show()
    r[i].t:SetBlendMode("BLEND")
    r[i].t:SetTiling(true)
    r[i].speed = 0.01/i
    r[i].pos = 0
    r[i]:Handle("OnUpdate", flow)
end

function SlushWater(self)
	local x,y = InputPosition()
	
	if x< ScreenWidth()/2 then
		if y < ScreenHeight()/2 then
			uaPushA1:Push(random())
			uaPushA2:Push(0) -- Start
		else
			uaPushB1:Push(random())
			uaPushB2:Push(0) -- Start
		end
	else
		if y < ScreenHeight()/2 then
			uaPushC1:Push(random())
			uaPushC2:Push(0) -- Start
		else
			rb:Handle("OnUpdate",Flicker)

			uaPushD1:Push(random())
			uaPushD2:Push(0) -- Start
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
rb:EnableInput(true)
rb:Show()

if not uaSample then
uaSample = FlowBox("object","Sample", _G["FBSample"])

uaSample:AddFile("YoungGirl1.wav")
uaSample:AddFile("YoungGirl2.wav")
uaSample:AddFile("YoungGirl3.wav")

uaSample2 = FlowBox("object","Sample", _G["FBSample"])

uaSample2:AddFile("YoungGirl4.wav")
uaSample2:AddFile("YoungGirl5.wav")
uaSample2:AddFile("YoungGirl6.wav")

uaSample3 = FlowBox("object","Sample", _G["FBSample"])
uaSample3:AddFile("Bubbly.wav")
uaSample3:AddFile("CrunchySlush.wav")
uaSample3:AddFile("Running.wav")

uaSample4 = FlowBox("object","Sample", _G["FBSample"])
uaSample4:AddFile("waves1.wav")

uaPushA1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushA2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushA3 = FlowBox("object","PushA3", _G["FBPush"])

uaPushB1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushB2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushB3 = FlowBox("object","PushA3", _G["FBPush"])

uaPushC1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushC2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushC3 = FlowBox("object","PushA3", _G["FBPush"])

uaPushD1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushD2 = FlowBox("object","PushA2", _G["FBPush"])
uaPushD3 = FlowBox("object","PushA3", _G["FBPush"])

dac = _G["FBDac"]

dac:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample2, 0)
dac:SetPullLink(0, uaSample3, 0)
dac:SetPullLink(0, uaSample4, 0)

uaPushA1:SetPushLink(0,uaSample, 3)  -- Sample switcher
uaPushA1:Push(0) -- AM wobble
uaPushA2:SetPushLink(0,uaSample, 2) -- Reset pos
uaPushA2:Push(1) -- End
uaPushA3:SetPushLink(0,uaSample, 4) -- Set loop
uaPushA3:Push(-1)

uaPushB1:SetPushLink(0,uaSample2, 3)  -- Sample switcher
uaPushB1:Push(0) -- AM wobble
uaPushB2:SetPushLink(0,uaSample2, 2) -- Reset pos
uaPushB2:Push(1) -- End
uaPushB3:SetPushLink(0,uaSample2, 4) -- Set loop
uaPushB3:Push(-1)

uaPushC1:SetPushLink(0,uaSample3, 3)  -- Sample switcher
uaPushC1:Push(0) -- AM wobble
uaPushC2:SetPushLink(0,uaSample3, 2) -- Reset pos
uaPushC2:Push(1) -- End
uaPushC3:SetPushLink(0,uaSample3, 4) -- Set loop
uaPushC3:Push(-1)

uaPushD1:SetPushLink(0,uaSample4, 3)  -- Sample switcher
uaPushD1:Push(0) -- AM wobble
uaPushD2:SetPushLink(0,uaSample4, 2) -- Reset pos
uaPushD2:Push(1) -- End
uaPushD3:SetPushLink(0,uaSample4, 4) -- Set loop
uaPushD3:Push(-1)

else
dac:SetPullLink(0, uaSample, 0)
end

DPrint(" ")
