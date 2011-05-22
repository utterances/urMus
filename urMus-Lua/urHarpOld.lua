--Yefei Wang, Paul Sokolik and Shaagnik Mukherji

-- Below is Performance Harp
-- The white region on the left will change color on sliding "vertically"(horizontally, but since we flip the harp to play)
-- The five strings will change color upon touching and leaving, enabling fingering techniques proposed later.

FreeAllRegions()

function Play(self)
    currentsample = self.choice
    ucPushSampleSelect:Push((currentsample-1)/(maxsamples-1))
    ucPushSamplePos:Push(0.0)
    DPrint(currentsample)
end

function Tremble(self)
    ucPushSamplePos:Push(self.tremble)
    self.tremble = 1.0 - self.tremble
    
    
end




function Release(self)
    ucPushSamplePos:Push(1.0)
end

maxsamples = 13
currentsample = 1

function Switch(self)
    currentsample = currentsample + 1
    if currentsample  > maxsamples then currentsample = 1 end
    ucPushSampleSelect:Push((currentsample-1)/(maxsamples-1)) -- This formula converts sample number into normed range
end       

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








ucPushSampleSelect = FlowBox("object","PushA1", _G["FBPush"])
ucPushSamplePos = FlowBox("object","PushA2", _G["FBPush"])
ucPushVolume = FlowBox("object","PushA3", _G["FBPush"])

-- This helps flatten the responsiveness close to zero (i.e. make it easier to stay slient)
ucPosSqr = FlowBox("object", "PosSqr", _G["FBPosSqr"])

dac = _G["FBDac"]

dac:SetPullLink(0, ucSample, 0)
ucPushSampleSelect:SetPushLink(0,ucSample, 3)  -- Sample switcher
ucPushSampleSelect:Push(0)
ucPushSamplePos:SetPushLink(0,ucSample, 2) -- Reset pos
ucPushSamplePos:Push(1.0)
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
    newregion.t = newregion:Texture(math.random(0,255),math.random(0,255),math.random(0,255),math.random(60,255))
    newregion.choice = i;
    newregion:Handle("OnTouchDown", ColorRandomly)
    newregion:Handle("OnTouchDown",Play)
    newregion:Handle("OnEnter",Play)
    newregion:Handle("OnTouchUp", Release)
    newregion:Handle("OnLeave",Release)
    newregion:SetHeight(ScreenHeight())
    newregion:SetAnchor("BOTTOMLEFT",25/320*ScreenWidth()*i-15/320*ScreenWidth(),0);
    newregion:SetWidth(15/320*ScreenWidth())
    newregion:EnableInput(true)
    newregion:Show()
    regions[i] = newregion
end


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



