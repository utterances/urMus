FreeAllRegions()
DPrint("");

local homepage = Page()

slider_interface    = false
home_interface      = false
sampler_interface   = false
performer_interface = false
touch_interface     = false

local scalex = ScreenWidth()/320.0
local scaley = ScreenHeight()/480.0

-------------------------------- SOUND ONBJECTS   ---------------------------------------

selected_sample = nil;

ucSample = FlowBox("object","Sample", _G["FBSample"])

--samples = {"pipe_sound1.wav","FunkyLoop.wav","MidManR5.wav","Red-Mono.wav","FunkyLoop.wav","MidManR5.wav","Red-Mono.wav","FunkyLoop.wav"};
for i=1,8 do
ucSample:AddFile("pipe_sound"..i..".wav");
--ucSample:AddFile(samples[i]);
end

dac            = _G["FBDac"]
sampleSwitcher = FlowBox("object","PushA1", _G["FBPush"])
samplePosition = FlowBox("object","PushA2", _G["FBPush"])
sampleVolume   = FlowBox("object","PosSqr", _G["FBPosSqr"])
sampleRate     = FlowBox("object","PushA3", _G["FBPush"])
delay          = FlowBox("object","Delay",  _G["FBDelay"])
ucPosSqr       = FlowBox("object","PosSqr", _G["FBPosSqr"])

fx1            = FlowBox("object","PitShift", _G["FBPitShift"])
fx1Ctrl        = FlowBox("object","PushA4", _G["FBPush"])

fx2            = FlowBox("object","PitShift", _G["FBPRCRev"])
fx2Ctrl        = FlowBox("object","PushA5", _G["FBPush"])

fx3            = FlowBox("object","PitShift", _G["FBJCRev"])
fx3Ctrl        = FlowBox("object","PushA5", _G["FBPush"])



sampleVolume:SetPushLink(0,ucSample, 0)        
sampleRate:SetPushLink(0,ucSample, 1)          
samplePosition:SetPushLink(0,ucSample, 2)      
sampleSwitcher:SetPushLink(0,ucSample, 3)  
samplePosition:Push(1.0)
sampleSwitcher:Push(0)


fx1:SetPullLink(0, ucSample, 0);               
fx1Ctrl:SetPushLink(0, fx1, 1);            
fx1Ctrl:Push(-1)

fx2:SetPullLink(0, fx1, 0);               
fx2Ctrl:SetPushLink(0, fx2, 1);            
fx2Ctrl:Push(-1)

--fx3:SetPullLink(0, fx2, 0);               
--fx3Ctrl:SetPushLink(0, fx3, 1);            
--fx3Ctrl:Push(-1)


dac:SetPullLink(0, fx2, 0)   




-------------------------------- BEGIN MAIN INTERFACE     --------------------------------
--Author: Ricardo

function RenderHome()

if(home_interface == true) then
SetPage(homepage)
else
SetPage(homepage)
home_interface   = true
-- Create interface selection buttons
button_labels = {"Sampler","Slider","TouchPad","Performer"};
buttons       = {};
button_width  = 80*scalex;
button_height = 80*scaley;
red           = 100;
green         = 100;
blue          = 100;

for i=1,4 do
local b = Region()
b = Region()
b.t = b:Texture()
b:SetWidth(button_width)
b:SetHeight(button_height)
b:SetAnchor("CENTER",ScreenWidth()/2,i*ScreenHeight()/4 - ScreenHeight()/8)
b.t:SetTexture(red,green,blue,255)
b:Show() 
b:EnableInput(true)
b.tl = b:TextLabel()
b.tl:SetLabel(button_labels[i])
b.tl:SetColor(255,255,255,255)

b:Handle("OnTouchDown", ChangePage)  
b.page = i+1
buttons[i] = b
end

end

end

function ChangePage(self)
if(self.page == 1) then
RenderHome()
end
if(self.page == 2) then
RenderSampler()
end
if(self.page == 3) then
RenderSliders() 
end
if(self.page == 4) then
RenderTouch() 
end
if(self.page == 5) then
RenderPerformer() 
end

end




-----------------------  BEGIN SLIDER INTERFACE ------------------------------
-- Author: Paul
-- Refactoring: Ricardo

function RenderSliders() 

if(slider_interface == true) then
SetPage(homepage+1)
else
SetPage(homepage+1)
slider_interface   = true

-- Create Background
r0 = Region()
r0.t = r0:Texture()
r0:Show()
r0:SetWidth(ScreenWidth())
r0:SetHeight(ScreenHeight())
r0.t:SetTexture(80,80,80,255)    

-- Create Exit Button
r1 = Region()
r1.t = r1:Texture()
r1:Show()
r1.w = ScreenWidth()
r1.h = 70*scaley
r1:SetWidth(r1.w)
r1:SetHeight(r1.h)
r1:SetAnchor("CENTER",ScreenWidth()/2,ScreenHeight() - r1.h/2)
r1.t:SetTexture(200,0,0,255) 
r1:EnableInput(true)
r1.tl = r1:TextLabel()
r1.tl:SetLabel("EXIT")
r1.tl:SetColor(255,255,255,255)
r1.tl:SetRotation(90)
r1:Handle("OnTouchDown", ChangePage)  
r1.page = 1


-- Create horizontal lines
slider_lines  = {};
line_width    = ScreenWidth();
line_height   = 10*scaley;
red           = 30;
green         = 30;
blue          = 30;

for i=1,3 do
local b = Region()
b.t = b:Texture()
b:Show()
b:SetWidth(line_width)
b:SetHeight(line_height)
b.t:SetTexture(red,green,blue,255)
b:SetAnchor("CENTER",ScreenWidth()/2,i*ScreenHeight()/5 - ScreenHeight()/10)
slider_lines[i] = b
end

function ResetEffects()
    sliders[1]:SetAnchor("CENTER",ScreenWidth()/2,ScreenHeight()/5 - ScreenHeight()/10)
    local left = sliders[1]:Left();
    pos = (2*left / (ScreenWidth()-sliders[1]:Width()))-1;
    rate(pos); 


    for i=2,3 do
        sliders[i]:SetAnchor("CENTER",slider_width/2,i*ScreenHeight()/5 - ScreenHeight()/10)
        left = sliders[i]:Left();
        pos = (2*left / (ScreenWidth()-sliders[i]:Width()))-1;
        if i == 2 then
            fx1(pos);
        end

        if i == 3 then
            fx2(pos)
        end

    end
end

-- Create sliders
slider_labels = {"Rate","eFX1","eFX2"};
sliders       = {};
slider_width  = 80*scalex;
slider_height = 80*scaley;
red           = 30;
green         = 255;
blue          = 30;

for i=1,3 do
local b = Region()
b = Region()
b.t = b:Texture()
b:SetWidth(slider_width)
b:SetHeight(slider_height)
b:SetAnchor("CENTER",ScreenWidth()/2,i*ScreenHeight()/5 - ScreenHeight()/10)
if i > 1 then
b:SetAnchor("CENTER",slider_width/2,i*ScreenHeight()/5 - ScreenHeight()/10)
end
b.t:SetTexture(red,green,blue,255)
b:Show() 
b:EnableInput(true)
b.tl = b:TextLabel()
b.tl:SetLabel(slider_labels[i])
b.tl:SetColor(0,0,0,255)
b.tl:SetRotation(90)
b.index = i
b:EnableHorizontalScroll(true)
b:Handle("OnHorizontalScroll",scroll_slider)  
sliders[i] = b
end
end

end 

-- Slider Handler function
function scroll_slider(self,dx)
local bottom = self:Bottom();
local left = self:Left();
left = left + dx;
if left < 0 then left = 0 end
if left > ScreenWidth()-self:Width() then left = ScreenWidth()-self:Width() end
self:SetAnchor("BOTTOMLEFT",left,bottom);
pos = (2*left / (ScreenWidth()-self:Width()))-1;


if self.index == 1 then
rate(pos);
end

if self.index == 2 then
fx1(pos);
end

if self.index == 3 then
fx2(pos);
end


end


function rate(pos) 

value = pos*.2 + 0.25;
if value > 1.0 then value = 1.0 end
if value < 0.0 then value = 0 end
--DPrint(value);
sampleRate:Push(value);

end

function fx1(pos) 

value = pos
if value > 1.0 then value = 1.0 end
if value < -1.0 then value = -1.0 end
--DPrint(value);
fx1Ctrl:Push(value);

end

function fx2(pos) 

value = pos;
if value > 1.0 then value = 1.0 end
if value < -1.0 then value = -1.0 end
--DPrint(value);
fx2Ctrl:Push(value);

end

function fx3(pos) 

value = pos;
if value > 1.0 then value = 1.0 end
if value < -1.0 then value = -1.0 end
--DPrint(value);
fx3Ctrl:Push(value);

end

-------------------------- BEGIN SAMPLER INTERFACE -----------------------------
--Author: Ricardo 


function RenderSampler() 

if(sampler_interface == true) then
SetPage(homepage+2)
else
SetPage(homepage+2)
sampler_interface   = true

-- Create Exit Button
button_width  = ScreenWidth();
button_height = ScreenHeight()/6;
exitb = Region()
exitb.t = exitb:Texture()
exitb:Show()
exitb:SetWidth(button_width)
exitb:SetHeight(button_height)
exitb:SetAnchor("BOTTOMLEFT",0,5*button_height)
exitb.t:SetTexture(200,0,0,255) 
exitb:EnableInput(true)
exitb.tl = exitb:TextLabel()
exitb.tl:SetLabel("EXIT")
exitb.tl:SetColor(255,255,255,255)
exitb:Handle("OnTouchDown", ChangePage)  
exitb.page = 1


-- Player control buttons
button_width  = ScreenWidth();
button_height = ScreenHeight()/6;
playerlabel = Region()
playerlabel.t = playerlabel:Texture()
playerlabel:SetWidth(button_width)
playerlabel:SetHeight(button_height)
playerlabel:SetAnchor("BOTTOMLEFT",0,4*button_height)
playerlabel.t:SetTexture(100,100,180,255)
playerlabel:Show() 
playerlabel:EnableInput(true)
playerlabel.tl = playerlabel:TextLabel()
playerlabel.tl:SetLabel("Sampler Control")
playerlabel.tl:SetColor(255,255,255,255)

recorder_b    = {};
recorder_c    = {"Play","Stop","Clear"};
button_width  = ScreenWidth()/3;
button_height = ScreenHeight()/6;
red           = 100;
green         = 100;
blue          = 100;
count         = 1;


for i=0,2 do
local b = Region()
b.t = b:Texture()
b:SetWidth(button_width)
b:SetHeight(button_height)
b:SetAnchor("BOTTOMLEFT",i*button_width,3*button_height)
b.t:SetTexture(red,green,blue,255)
b:Show() 
b:EnableInput(true)
b.tl = b:TextLabel()
b.tl:SetLabel(recorder_c[i+1])
b.tl:SetColor(255,255,255,255)

if( i == 0 ) then
b:Handle("OnTouchDown", PlaySample)  
end
if( i == 1 ) then
b:Handle("OnTouchDown", StopSample)  
end
if( i == 2 ) then
b:Handle("OnTouchDown", ClearSample)  
end


b.index = count
recorder_b[i] = b
count = count + 1;
end


--Sample selection buttons
button_width  = ScreenWidth();
button_height = ScreenHeight()/6;
choosesample = Region()
choosesample.t = choosesample:Texture()
choosesample:SetWidth(button_width)
choosesample:SetHeight(button_height)
choosesample:SetAnchor("BOTTOMLEFT",0,2*button_height)
choosesample.t:SetTexture(100,100,180,255)
choosesample:Show() 
choosesample:EnableInput(true)
choosesample.tl = choosesample:TextLabel()
choosesample.tl:SetLabel("Select Sample")
choosesample.tl:SetColor(255,255,255,255)

samples_b     = {};
button_width  = ScreenWidth()/4;
button_height = ScreenHeight()/6;
red           = 100;
green         = 100;
blue          = 100;
count         = 1;
prev          = 0;

for j=1,0,-1 do

for i=0,3 do
local b = Region()
b.t = b:Texture()
b:SetWidth(button_width)
b:SetHeight(button_height)
b:SetAnchor("CENTER",i*button_width+button_width/2,j*button_height+button_height/2)
b.t:SetTexture(red,green,blue,255)
b:Show() 
b:EnableInput(true)
b.tl = b:TextLabel()
b.tl:SetLabel(count)
b.tl:SetColor(255,255,255,255)
b:Handle("OnTouchDown", ChooseSample)  
b.index = count
samples_b[count] = b
count = count + 1
end

end

end
end

function ChooseSample(self)
if(prev > 0) then
samples_b[prev].t:SetTexture(100,100,100,255)
end
prev = self.index;
self.t:SetTexture(200,200,200,255);
selected_sample = self.index;
sampleSwitcher:Push((self.index-1)/(8-1));
ResetEffects()
end

function ClearSample(self)
if(prev > 0) then
samples_b[prev].t:SetTexture(100,100,100,255)
end
prev = 0
samplePosition:Push(1.0)
ResetEffects()
selected_sample = nil;
end

function PlaySample(self)
if(selected_sample ~= nil) then
ResetEffects()
samplePosition:Push(0.0)
end
end

function StopSample(self)
samplePosition:Push(1.0)
ResetEffects()
end




--------------------------------- BEGIN TOUCH INTERFACE ---------------------------------------
-- Author: Shaagnik

function RenderTouch() 

if(touch_interface == true) then
SetPage(homepage+3)
else
SetPage(homepage+3)
touch_interface   = true

-- Create Exit Button
button_width  = ScreenWidth();
button_height = 80*scaley;
exittouch = Region()
exittouch.t = exittouch:Texture()
exittouch:Show()
exittouch:SetWidth(button_width)
exittouch:SetHeight(button_height)
exittouch:SetAnchor("BOTTOMLEFT",0,ScreenHeight()-button_height)
exittouch.t:SetTexture(200,0,0,255) 
exittouch:EnableInput(true)
exittouch.tl = exittouch:TextLabel()
exittouch.tl:SetLabel("EXIT")
exittouch.tl:SetColor(255,255,255,255)
exittouch:Handle("OnTouchDown", ChangePage)  
exittouch.page = 1



fing1=Region()
fing1.t=fing1:Texture()
fing1:Show()
fing1:SetWidth(75*scalex)
fing1:SetHeight(75*scaley)
fing1.t:SetTexture(255,0,0,150)
fing1:EnableMoving(true)
fing1:EnableInput(true)
fing1:SetAnchor("BOTTOMLEFT", 10*scalex,10*scaley)
fing1:Handle("OnTouchDown",red_move)
fing1curL=fing1:Left()
fing1curB=fing1:Bottom()
fing2=Region()
fing2.t=fing2:Texture()
fing2:Show()
fing2:SetWidth(75*scalex)
fing2:SetHeight(75*scaley)
fing2.t:SetTexture(0,0,255,150)
fing2:EnableMoving(true)
fing2:EnableInput(true)
fing2:SetAnchor("TOPRIGHT", 310*scalex,390*scaley)
fing2:Handle("OnTouchDown",blue_move)
fing2curL=fing2:Left()
fing2curB=fing2:Bottom() 

end
end

function red_move(self)
local left= self:Left()
local bottom = self:Bottom()
local dx = 2*left/(ScreenWidth()-self:Width())
local dy = 2*bottom/(ScreenHeight()-self:Height())
--DPrint(dx)
--DPrint(dy)
sampleRate:Push(dx*dy)
end
function blue_move(self)
local left= self:Left()
local bottom = self:Bottom()
local dx = 2*left/(ScreenWidth()-self:Width())
local dy = 2*bottom/(ScreenHeight()-self:Height())
--DPrint(dx)
--DPrint(dy)
sampleRate:Push(dy/dx)
end



--------------------------------- BEGIN PERFORMER INTERFACE -----------------------------------
-- Author: Michael
-- Fixes : Ricardo

function RenderPerformer() 

if(performer_interface == true) then
SetPage(homepage+4)
else
SetPage(homepage+4)
performer_interface   = true

-- Create Exit Button
button_width  = ScreenWidth();
button_height = 80*scaley;
exitperf = Region()
exitperf.t = exitperf:Texture()
exitperf:Show()
exitperf:SetWidth(button_width)
exitperf:SetHeight(button_height)
exitperf:SetAnchor("BOTTOMLEFT",0,ScreenHeight()-button_height)
exitperf.t:SetTexture(200,0,0,255) 
exitperf:EnableInput(true)
exitperf.tl = exitperf:TextLabel()
exitperf.tl:SetLabel("EXIT")
exitperf.tl:SetColor(255,255,255,255)
exitperf:Handle("OnTouchDown", ChangePage)  
exitperf.page = 1


--Creating background with gradient 

r3 = Region()
r3:SetWidth(ScreenWidth())
r3:SetHeight(ScreenHeight()-button_height)
r3:SetLayer("BACKGROUND")
r3:SetAnchor("BOTTOMLEFT",0,0)
r3.t = r3:Texture(200,255,255,255)
r3.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
r3.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)

r3.t:SetTexCoord(0,320.0/512.0,480.0/512,0.0)
r3:Show()

--Blending the regions with background
--r3:SetLayer("LOW")
r3.t:SetBlendMode("BLEND")


--Enabling regions and background to change colors by pressing/releasing the regions and based on acceleration. 
r3:Handle("OnAccelerate",GetAcceleration)   
r3:EnableInput(true)
end
end



--Creating acceleration function in order to change background color based on acceleration

function GetAcceleration(self,x,y,z)
x = x+1
y = y+1
z = z+1
Red = x*120
Blue = x*120
Green = x+30 
self.t:SetSolidColor(Red,Blue,Green,255)
--DPrint(Red.."\n"..Blue.."\n"..Green.."\n")
sampleVolume:Push(x/2);
end




----------------------------- RENDER HOME  ------------------------------
RenderHome()
RenderSliders()  -- Render Sliders so we can reset them
RenderHome()

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

