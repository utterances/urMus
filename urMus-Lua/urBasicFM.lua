-- urBasicFM.lua
-- Georg Essl 10/24/12
-- Tests a basic FM patch in urMus
-- Modulator freq/amp is controlled by touch X/Y
-- Base frequency is X tilt

FreeAllFlowboxes()
dac= FBDac
sinosc = FlowBox(FBSinOsc)
sinosc2 = FlowBox(FBSinOsc)
add = FlowBox(FBAdd)
touch = FBTouch
accel = FBAccel

touch.X1:SetPush(sinosc.Freq)
touch.Y1:SetPush(sinosc.Amp)
accel.X:SetPush(add.In1)
add.In2:SetPull(sinosc.Out)
sinosc2.Freq:SetPull(add.Out)
dac.In:SetPull(sinosc2.Out)

local pagebutton=Region('region', 'pagebutton', UIParent)
pagebutton:SetWidth(pagersize)
pagebutton:SetHeight(pagersize)
pagebutton:SetLayer("TOOLTIP")
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4)
pagebutton:EnableClamping(true)
pagebutton:Handle("OnTouchDown", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png")
pagebutton.texture:SetGradientColor("TOP",255,255,255,255,255,255,255,255)
pagebutton.texture:SetGradientColor("BOTTOM",255,255,255,255,255,255,255,255)
pagebutton.texture:SetBlendMode("BLEND")
pagebutton.texture:SetTexCoord(0,1.0,0,1.0)
pagebutton:EnableInput(true)
pagebutton:Show()
