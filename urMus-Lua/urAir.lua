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
if ScreenWidth() < 400 then
	small = 0.5
	orientation = 1
else
	small = 1
	orientation = -1
end

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

function AccelerateBall(self,x,y,z)
    self.vx = self.vx + x
    self.vy = self.vy + y
end

function UpdateMic(self)
    visout=_G["FBVis"]:Get()
end

local curr_samp = 0

function SwitchSample(self)
	curr_samp = 1 - curr_samp
--	uaPushA2:Push(0)
	uaPushA1:Push(curr_samp/6.95)
end

_G["FBMic"]:SetPushLink(0,_G["FBVis"],0)

rb = Region()
rb.t = rb:Texture()
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight())
--rb.t:SetTexture(DocumentPath("smoke0.png"))
rb.t:SetTexture("smoke0.png")
rb.t:SetGradientColor("HORIZONTAL", 255,255,255,255,255,255,255,255)
rb.t:SetBlendMode("BLEND")
rb:Handle("OnUpdate",UpdateMic)
rb:EnableInput(true)
rb:Handle("OnTouchDown",SwitchSample)
rb:Show()

r = {}
local maxr = 16

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
    r[i].t:SetTexture("smoke1.png")
    r[i].t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    r[i]:Show()
    r[i].t:SetBlendMode("BLEND")
    r[i].t:SetTiling(true)
    r[i].vx=0
    r[i].vy=0
    r[i]:Handle("OnUpdate",UpdateBubble)
    r[i]:Handle("OnAccelerate",AccelerateBall)
end

if not uaSample then
uaSample = FlowBox("object","Sample", _G["FBSample"])

uaSample:AddFile("OldMan1.wav")
uaSample:AddFile("OldMan2.wav")

uaSample2 = FlowBox("object","Sample", _G["FBSample"])

uaSample2:AddFile("OldMan3.wav")
uaSample2:AddFile("OldMan4.wav")


uaSample3 = FlowBox("object","Sample", _G["FBSample"])
uaSample3:AddFile("WindLoop1.wav")

uaPushA1 = FlowBox("object","PushA1", _G["FBPush"])
uaPushA2 = FlowBox("object","PushA2", _G["FBPush"])
--ucAsymp = FlowBox("object", "Asmpy", _G["FBAsymp"])
uaAvg = FlowBox("object", "Amp", _G["FBAvg"])
uaSqr = FlowBox("object", "Sqr", _G["FBPGate"])

dac = _G["FBDac"]
--mic = _G["FBMic"]

dac:SetPullLink(0, uaSample, 0)
dac:SetPullLink(0, uaSample2, 0)
dac:SetPullLink(0, uaSample3, 0)
uaPushA1:SetPushLink(0,uaSample, 3)  -- Sample switcher
uaPushA1:Push(0) -- AM wobble
uaPushA2:SetPushLink(0,uaSample, 2) -- Reset pos
--uaAvg:SetPushLink(0, uaSqr, 0)
--uaSqr:SetPushLink(0, uaSample, 0)
--mic:SetPushLink(0, uaAvg, 0)
else
dac:SetPullLink(0, uaSample, 0)
end


