-- urEmpty
--feedback instrument

--This instrument will take the sound played into it and truns the bottom portion of the screen red depending on the level at the mic input.  Their will be a reverb option to create smoother sounding distrotions and a filter option to enable a significant high frequency cut when wanting the choral like instrument to come through.  The harsh design is intended to represent the harsh nature of feedback and the digital distrotion that will be created by exploring these sounds.  I kept the color as red for full volume because it best represents the aggresion that will be felt by playing this piece.  (Or more specifically this instrument in, under, around and over the beautiful lines)


FreeAllRegions()
w = ScreenWidth()
h = ScreenHeight()

--Background Region
r = Region()
r:SetWidth(w)
r:SetHeight(h-(1/5)*h)
r.t = r:Texture()
r:Show()

--MicGain effects amount of visual region color
function MicGain(self)
    micGain = _G["FBVis"]:Get()
    r.t:Clear(255,255,255,255)
    r.t:SetTexture(micGain*255, 0, 0, 255)
end


mic = _G["FBMic"]
mic:SetPushLink(0,_G["FBVis"],0)


r:Handle("OnUpdate", MicGain)
r:EnableInput(true)


--Buttons
r1 = Region()
r1:SetWidth(w/4)
r1:SetHeight(h/8)
r1:SetAnchor("TOP", w/4, h-10)
r1.t = r1:Texture()
r1.t:SetTexture(0,255,255,255)
r1:Show()
r1:EnableInput(true)
r1.tl = r1:TextLabel()
r1.tl:SetLabel("Filter")
r1.tl:SetFont("Arial")
r1.tl:SetLabelHeight(18)

r2 = Region()
r2:SetWidth(w/4)
r2:SetHeight(h/8)
r2:SetAnchor("TOP", (w/4)*3, h-10)
r2.t = r2:Texture()
r2.t:SetTexture(0,255,255,255)
r2:Show()
r2:EnableInput(true)
r2.tl = r2:TextLabel()
r2.tl:SetLabel("PShift")
r2.tl:SetFont("Arial")
r2.tl:SetLabelHeight(18)


--Sound Shtuff Section

filter1 = FlowBox("object", "filter1", _G["FBBiQuad"])
shift1 = FlowBox("object", "shift1", _G["FBPitShift"])
upPushAcc = FlowBox("object","utPushAcc", _G["FBAccel"])
gainInv = FlowBox("object", "gainInv", _G["FBInv"])
gain = FlowBox("object", "gain", _G["FBGain"])
dac = _G["FBDac"]

--y axis effects gain of feedback patch
upPushAcc:SetPushLink(1, gainInv, 0)
gainInv:SetPushLink(0, gain, 1)
gain:SetPushLink(0, dac, 0)

--Nothing plays until one of the buttons is initially activated
--Filter runs the mic through the BiQuad filter.  
--The X axis effects Reson (knee freq)

    upPushAcc:SetPushLink(0, filter1, 1)

local toggle = 0

function On(self)
    if toggle == 0 then
        r1.tl:SetLabel("Filter On")
        r1.t:SetTexture(0,255,255,255)
    
        mic:RemovePushLink(0, gain, 0)
        mic:SetPushLink(0, filter1, 0)
        filter1:SetPushLink(0, gain, 0)
    else
        r1.tl:SetLabel("Filter Off")
        r1.t:SetTexture(0, 0, 255, 255)
        
        mic:RemovePushLink(0, filter1, 0)
        filter1:RemovePushLink(0, gain, 0)
        mic:SetPushLink(0, gain, 0)  
    end
    toggle = 1 - toggle                   
end


upPushAcc:SetPushLink(0, shift1, 1)

local toggle2 = 0
    
function On2(self)
    if toggle2 == 0 then          
        r2.tl:SetLabel("Shift On")
        r2.t:SetTexture(0,255,255,255)
        mic:RemovePushLink(0, gain, 0)
        mic:SetPushLink(0, shift1, 0)
        shift1:SetPushLink(0, gain, 0)
                   
    else
        r2.tl:SetLabel("Shift Off")
        r2.t:SetTexture(0, 0, 255, 255)
        mic:RemovePushLink(0, shift1, 0)
        shift1:RemovePushLink(0, gain, 0)
        mic:SetPushLink(0, gain, 0)
    end
    toggle2 = 1 - toggle2
end



--r1:Handle("OnDoubleTap",Off)
r1:Handle("OnTouchDown", On)

--r2:Handle("OnDoubleTap",Off2)
r2:Handle("OnTouchUp", On2)

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

DPrint(" ")

-- Below creates a pager button.
-- This helps us get back to the default UI.

--[[local pagebutton=Region('region', 'pagebutton', UIParent);
pagebutton:SetWidth(pagersize);
pagebutton:SetHeight(pagersize);
pagebutton:SetLayer("TOOLTIP");
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4);
pagebutton:EnableClamping(true)
pagebutton:Handle("OnTouchDown", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png");
pagebutton.texture:SetGradientColor("TOP",255,255,255,255,255,255,255,255);
pagebutton.texture:SetGradientColor("BOTTOM",255,255,255,255,255,255,255,255);
pagebutton.texture:SetBlendMode("BLEND")
pagebutton.texture:SetTexCoord(0,1.0,0,1.0);
pagebutton:EnableInput(true);
pagebutton:Show();--]]