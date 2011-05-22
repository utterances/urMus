--Yefei Wang, Paul Sokolik and Shaagnik Mukherji

-- Below is Performance Harp
-- The white region on the left will change color on sliding "vertically"(horizontally, but since we flip the harp to play)
-- The five strings will change color upon touching and leaving, enabling fingering techniques proposed later.

FreeAllRegions()

function Play(self)
    currentsample = self.choice
    ucPushSampleSelect:Push((currentsample-1)/(maxsamples-1))
    ucPushSamplePos:Push(0.0)
    ucPushLoop:Push(0)
    DPrint(currentsample)
end

function Tremble(self)
    currentsample = self.tremble
    ucPushSampleSelect:Push((currentsample-1)/(maxsamples-1))
    ucPushSamplePos:Push(0.0)
    ucPushLoop:Push(1)
    DPrint(currentsample)
end




function Release(self)
    ucPushSamplePos:Push(1.0)
end

maxsamples = 26
currentsample = 1


ucSample = FlowBox("object","Sample", _G["FBSample"])

-- Audio files should be mono 48000Hz to have the proper rate mapping.
-- Different sample rates will work but samples will play slightly faster than
-- intended.
-- Stereo samples may sound bad or fail.

ucSample:AddFile("harp-g-low.wav")
ucSample:AddFile("harp-a-low.wav")
ucSample:AddFile("harp-b-low.wav")
ucSample:AddFile("harp-c.wav")
ucSample:AddFile("harp-d.wav")
ucSample:AddFile("harp-e.wav")
ucSample:AddFile("harp-f.wav")
ucSample:AddFile("harp-g.wav")
ucSample:AddFile("harp-a.wav")
ucSample:AddFile("harp-b.wav")
ucSample:AddFile("harp-high-c.wav")
ucSample:AddFile("harp-high-d.wav")
ucSample:AddFile("harp-high-e.wav")
ucSample:AddFile("G-low-shaking.wav")
ucSample:AddFile("A-low-shaking.wav")
ucSample:AddFile("B-low-shaking.wav")
ucSample:AddFile("C-shaking.wav")
ucSample:AddFile("D-shaking.wav")
ucSample:AddFile("E-shaking.wav")
ucSample:AddFile("F-shaking.wav")
ucSample:AddFile("G-shaking.wav")
ucSample:AddFile("A-shaking.wav")
ucSample:AddFile("B-shaking.wav")
ucSample:AddFile("C-high-shaking.wav")
ucSample:AddFile("D-high-shaking.wav")
ucSample:AddFile("E-high-shaking.wav")


ucPushSampleSelect = FlowBox("object","PushA1", _G["FBPush"])
ucPushSamplePos = FlowBox("object","PushA2", _G["FBPush"])
ucPushVolume = FlowBox("object","PushA3", _G["FBPush"])
ucPushLoop = FlowBox("object","PushA4", _G["FBPush"])

-- This helps flatten the responsiveness close to zero (i.e. make it easier to stay slient)
ucPosSqr = FlowBox("object", "PosSqr", _G["FBPosSqr"])

dac = _G["FBDac"]

dac:SetPullLink(0, ucSample, 0)
ucPushSampleSelect:SetPushLink(0,ucSample, 3)  -- Sample switcher
ucPushSampleSelect:Push(0)
ucPushSamplePos:SetPushLink(0,ucSample, 2) -- Reset pos
ucPushSamplePos:Push(1.0)
ucPushLoop:SetPushLink(0,ucSample,4) --Loop?
ucPushLoop:Push(0)
ucPosSqr:SetPushLink(0,ucSample, 0)
ucPushVolume:SetPushLink(1,ucPosSqr, 0) -- Y axis into square control volume
ucPushVolume:Push(0.25)

-- Creating a region:

FreeAllRegions()
-- Events
function ColorRandomly(self)
    self.t:SetSolidColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
end

function SetGrad(self,x,y,z)
    r.t:SetGradientColor("CENTER",100,100,0,50,math.abs(x)*255,math.abs(y)*255,math.abs(z)*128,200)
    r.t:SetGradientColor("TOP",100,100,100,50,math.abs(x)*255,math.abs(y)*255,math.abs(z)*128,200)
    r.t:SetGradientColor("BOTTOM",100,100,100,0,math.abs(x)*255,math.abs(y)*255,math.abs(z)*128,200)
end

function ColorOnX(self, x,y,dx,dy)
    self.t:SetSolidColor(255-x/ScreenWidth()*255, 128, 128, 255)
end

r = Region()
r:SetHeight(ScreenHeight());
r:SetWidth(ScreenWidth());
r:Show()

-- Add a texture, it can be either solid color or an image file
r.t = r:Texture(255,255,255,255)


regions = {}
for i=1,13 do
    local newregion = Region()
    newregion.tl = newregion:TextLabel();
    newregion.t = newregion:Texture(i*8,i*7,i*12,math.random(60,255))
    newregion.choice = i
    newregion:Handle("OnTouchDown",Play)
    newregion:Handle("OnEnter",Play)
    newregion:SetHeight(3*ScreenHeight()/4)
    newregion:SetAnchor("BOTTOMLEFT",25/320*ScreenWidth()*i-25/320*ScreenWidth(),ScreenHeight()/4);
    newregion:SetWidth(20/320*ScreenWidth())
    newregion:EnableInput(true)
    newregion:Show()
    regions[i] = newregion
end
for i = 14,26 do
local newregion = Region()
    newregion.tl = newregion:TextLabel();
    newregion.t = newregion:Texture(i*8,i*2,i*3,math.random(60,255))
    newregion.tremble = i
    newregion:Handle("OnTouchDown", ColorRandomly)
    newregion:Handle("OnTouchDown",Tremble)
    newregion:Handle("OnEnter",Tremble)
    newregion:SetHeight(ScreenHeight()/4)
    newregion:SetAnchor("BOTTOMLEFT",25/320*ScreenWidth()*(i-13)-25/320*ScreenWidth(),0);
    newregion:SetWidth(20/320*ScreenWidth())
    newregion:EnableInput(true)
    newregion:Show()
    regions[i] = newregion
end






