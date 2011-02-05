FreeAllRegions()
current_sound=''

if reset then reset() end

ucPushA1 = FlowBox("object","PushA1", _G["FBPush"])

-- Assigning a user and his IP address with an instrument - to be updated before concert

ksingri = "192.168.1.200" -- trickle
cdat = "192.168.1.201"     -- wave
bgaya = "192.168.1.202"   -- ripple
alej = "192.168.1.203"    -- stream
essl = "192.168.1.204"     -- splash

-- Images

wave_image='wave.png'
stream_image='stream.png'
trickle_image='trickle.png'
ripple_image='ripple.png'
splash_image='splash.png'
button_up_image='button2up.png'
button_down_image='button2down.png'

-- Sounds

ucSample = FlowBox("object","Sample", _G["FBSample"])
ucSample:AddFile("Rocks.wav")
ucSample:AddFile("Rocks3.wav")

ucSample0 = FlowBox("object","Sample0", _G["FBSample"])
ucSample0:AddFile("Beach.wav")
ucSample0:AddFile("Beach3.wav")

ucSample1 = FlowBox("object","Sample1", _G["FBSample"])
ucSample1:AddFile("stream.wav")
ucSample1:AddFile("stream3.wav")

ucSample2 = FlowBox("object","Sample2", _G["FBSample"])
ucSample2:AddFile("trickle.wav")
ucSample2:AddFile("trickle3.wav")

ucSample20 = FlowBox("object","Sample20", _G["FBSample"])
ucSample20:AddFile("metal.wav")
ucSample20:AddFile("metal3.wav")

ucSample3 = FlowBox("object","Sample3", _G["FBSample"])
ucSample3:AddFile("ripple.wav")
ucSample3:AddFile("ripple3.wav")

ucSample4 = FlowBox("object","Sample4", _G["FBSample"])
ucSample4:AddFile("splash.wav")
ucSample4:AddFile("splash3.wav")

-- Reset sound initially

dac = _G["FBDac"]

function reset()
dac:RemovePullLink(0, ucSample, 0)
dac:RemovePullLink(0, ucSample0, 0)
dac:RemovePullLink(0, ucSample1, 0)
dac:RemovePullLink(0, ucSample2, 0)
dac:RemovePullLink(0, ucSample20, 0)
dac:RemovePullLink(0, ucSample3, 0)
dac:RemovePullLink(0, ucSample4, 0)
end

-- Creating initial interface to select the instrument

r1 = Region()
r1.t = r1:Texture()
r1:SetWidth(ScreenWidth()/4)
r1:SetHeight(ScreenHeight()/8)
r1:SetAnchor("BOTTOMLEFT",0,ScreenHeight()/2)  
--r1.t:SetTexture(button_up_image)
r1.t:SetTexture(255,0,0,255)
r1.t:SetTexCoord(0, 0.996, 0, 0.520)
r1.state='up'
r1.tl = r1:TextLabel()
r1.tl:SetLabel("OFF")  
r1.tl:SetFont("Arial")
r1.tl:SetColor(255,255,255,255)
r1.tl:SetFontHeight(12)    

r2 = Region()
r2.t = r2:Texture()
r2:SetWidth(ScreenWidth()/4)
r2:SetHeight(ScreenHeight()/8)
r2:SetAnchor("BOTTOMRIGHT",ScreenWidth(),0)  
--r2.t:SetTexture(button_up_image)
r2.t:SetTexture(255,0,0,255)
r2.t:SetTexCoord(0, 0.996, 0, 0.520)
r2.state='up'
r2.tl = r2:TextLabel()
r2.tl:SetLabel("Wave")  
r2.tl:SetFont("Arial")
r2.tl:SetColor(255,255,255,255)
r2.tl:SetFontHeight(12)    

r3 = Region()
r3.t = r3:Texture()
r3:SetWidth(ScreenWidth()/4)
r3:SetHeight(ScreenHeight()/8)
r3:SetAnchor("BOTTOMRIGHT",ScreenWidth(),ScreenHeight()/8)  
--r3.t:SetTexture(button_up_image)
r3.t:SetTexture(255,0,0,255)
r3.t:SetTexCoord(0, 0.996, 0, 0.520)
r3.state='up'
r3.tl = r3:TextLabel()
r3.tl:SetLabel("Stream")      
r3.tl:SetFont("Arial")
r3.tl:SetColor(255,255,255,255)
r3.tl:SetFontHeight(12)

r4 = Region()
r4.t = r4:Texture()
r4:SetWidth(ScreenWidth()/4)
r4:SetHeight(ScreenHeight()/8)
r4:SetAnchor("BOTTOMRIGHT",ScreenWidth(),2*ScreenHeight()/8)  
--r4.t:SetTexture(button_up_image)
r4.t:SetTexture(255,0,0,255)
r4.t:SetTexCoord(0, 0.996, 0, 0.520)
r4.state='up'
r4.tl = r4:TextLabel()
r4.tl:SetLabel("Trickle")     
r4.tl:SetFont("Arial")
r4.tl:SetColor(255,255,255,255)
r4.tl:SetFontHeight(12)

r5 = Region()
r5.t = r5:Texture()
r5:SetWidth(ScreenWidth()/4)
r5:SetHeight(ScreenHeight()/8)
r5:SetAnchor("BOTTOMRIGHT",ScreenWidth(),3*ScreenHeight()/8)  
--r5.t:SetTexture(button_up_image)
r5.t:SetTexture(255,0,0,255)
r5.t:SetTexCoord(0, 0.996, 0, 0.520)
r5.state='up'
r5.tl = r5:TextLabel()
r5.tl:SetLabel("Ripple")
r5.tl:SetFont("Arial")
r5.tl:SetColor(255,255,255,255)
r5.tl:SetFontHeight(12)

r6 = Region()
r6.t = r6:Texture()
r6:SetWidth(ScreenWidth()/4)
r6:SetHeight(ScreenHeight()/8)
r6:SetAnchor("BOTTOMRIGHT",ScreenWidth(),4*ScreenHeight()/8)  
--r6.t:SetTexture(button_up_image)
r6.t:SetTexture(255,0,0,255)
r6.t:SetTexCoord(0, 0.996, 0, 0.520)
r6.state='up'
r6.tl = r6:TextLabel()
r6.tl:SetLabel("Splash")
r6.tl:SetFont("Arial")
r6.tl:SetColor(255,255,255,255)
r6.tl:SetFontHeight(12)

r7 = Region()
r7.t = r7:Texture()
r7:SetWidth(ScreenWidth()/4)
r7:SetHeight(ScreenHeight()/8)
r7:SetAnchor("BOTTOMLEFT",0,0)  
r7.t:SetSolidColor(255,0,0,255)  --default colour red
r7.tl = r7:TextLabel()
r7.tl:SetLabel("Rocks")
r7.tl:SetFont("Arial")
r7.tl:SetColor(255,255,255,255)
r7.tl:SetFontHeight(12)

r8 = Region()
r8.t = r8:Texture()
r8:SetWidth(ScreenWidth()/4)
r8:SetHeight(ScreenHeight()/8)
r8:SetAnchor("BOTTOMLEFT",r7:Width(),0)  
r8.t:SetSolidColor(255,0,0,255)  --default colour red
r8.tl = r8:TextLabel()
r8.tl:SetLabel("Beach")
r8.tl:SetFont("Arial")
r8.tl:SetColor(255,255,255,255)
r8.tl:SetFontHeight(12)

r9 = Region()
r9.t = r9:Texture()
r9:SetWidth(ScreenWidth()/4)
r9:SetHeight(ScreenHeight()/8)
r9:SetAnchor("TOPLEFT",0,ScreenHeight())  
r9.t:SetSolidColor(255,0,0,255)  --default colour red
r9.tl = r9:TextLabel()
r9.tl:SetLabel("Wood")
r9.tl:SetFont("Arial")
r9.tl:SetColor(255,255,255,255)
r9.tl:SetFontHeight(12)

r10 = Region()
r10.t = r10:Texture()
r10:SetWidth(ScreenWidth()/4)
r10:SetHeight(ScreenHeight()/8)
r10:SetAnchor("TOPLEFT",r9:Width(),ScreenHeight())  
r10.t:SetSolidColor(255,0,0,255)  --default colour red
r10.tl = r10:TextLabel()
r10.tl:SetLabel("Metal")
r10.tl:SetFont("Arial")
r10.tl:SetColor(255,255,255,255)
r10.tl:SetFontHeight(12)

rmusic = Region()
rmusic:SetWidth(100)
rmusic:SetHeight(100)
rmusic:SetAnchor("CENTER",ScreenWidth()/2,ScreenHeight()/2)

--Waves
r = Region()
r.t = r:Texture()
r.t:SetTexture(255,0,0,255)
r.tl = r:TextLabel()
r.tl:SetLabel("Waves")  -- To select instrument
r.tl:SetFont("Arial")
r.tl:SetColor(255,255,255,255)
r.tl:SetFontHeight(12)

r:SetAnchor("BOTTOMLEFT",0,0)
r:SetWidth(ScreenWidth())
r:SetHeight(ScreenHeight()/5)
r:Show()

--Stream
ra = Region()
ra.t = ra:Texture()
ra.t:SetTexture(255,0,255,0)
ra.tl = ra:TextLabel()
ra.tl:SetLabel("Stream")  -- To select instrument
ra.tl:SetFont("Arial")
ra.tl:SetColor(255,255,255,255)
ra.tl:SetFontHeight(12)

ra:SetAnchor("BOTTOMLEFT",0,ScreenHeight()/5)
ra:SetWidth(ScreenWidth())
ra:SetHeight(ScreenHeight()/5)
ra:Show()

--Trickle
rb = Region()
rb.t = rb:Texture()
rb.t:SetTexture(0,255,0,255)
rb.tl = rb:TextLabel()
rb.tl:SetLabel("Trickle")  -- To select instrument
rb.tl:SetFont("Arial")
rb.tl:SetColor(255,255,255,255)
rb.tl:SetFontHeight(12)

rb:SetAnchor("BOTTOMLEFT",0,2*ScreenHeight()/5)
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight()/5)
rb:Show()

--Ripple
rc = Region()
rc.t = rc:Texture()
rc.t:SetTexture(0,0,255,255)
rc.tl = rc:TextLabel()
rc.tl:SetLabel("Ripple")  -- To select instrument
rc.tl:SetFont("Arial")
rc.tl:SetColor(255,255,255,255)
rc.tl:SetFontHeight(12)

rc:SetAnchor("BOTTOMLEFT",0,3*ScreenHeight()/5)
rc:SetWidth(ScreenWidth())
rc:SetHeight(ScreenHeight()/5)
rc:Show()

--Splash
rd = Region()
rd.t = rd:Texture()
rd.t:SetTexture(0,255,255,0)
rd.tl = rd:TextLabel()
rd.tl:SetLabel("Splash")  -- To select instrument
rd.tl:SetFont("Arial")
rd.tl:SetColor(255,255,255,255)
rd.tl:SetFontHeight(12)

rd:SetAnchor("BOTTOMLEFT",0,4*ScreenHeight()/5)
rd:SetWidth(ScreenWidth())
rd:SetHeight(ScreenHeight()/5)
rd:Show()


-- functions definition

-- Background Images set for each water sound

function SetBackGroundImage(self)
    re = Region()
    re.t = re:Texture()
    --re = UIParent()      
    if current_sound=='wave' then
        re.t:SetTexture(wave_image)
           
   end
   if current_sound=='splash' then
       
        re.t:SetTexture(splash_image)
       
   end
   if current_sound=='trickle' then
       
        re.t:SetTexture(trickle_image)
       
   end
   if current_sound=='ripple' then
       
        re.t:SetTexture(ripple_image)
       
   end
   if current_sound=='stream' then
       
        re.t:SetTexture(stream_image)
       
   end
    re:SetLayer("BACKGROUND")
    re.t:SetTexCoord(0,531/1024,531/1024,0)
    re:SetWidth(ScreenWidth())
    re:SetHeight(ScreenHeight())
    re:SetAnchor("CENTER",ScreenWidth()/2,ScreenHeight()/2)
    re:Show()
end


-- Creating the common space in each instrument

function ConfigureInstr(self)
    r:Hide()
    r:EnableInput(false)
    ra:Hide()
    ra:EnableInput(false)
    rb:Hide()
    rb:EnableInput(false)
    rc:Hide()
    rc:EnableInput(false)
    rd:Hide()
    rd:EnableInput(false)
   
r1:SetLayer("LOW")
r1:Show()
           
r2:SetLayer("LOW")
r2:Show()

r3:SetLayer("LOW")   
r3:Show()

r4:SetLayer("LOW")
r4:Show()

r5:SetLayer("LOW")
r5:Show()

r6:SetLayer("LOW")
r6:Show()
 
end

-- Flip from red to green and back on doubletapping sub-sounds in wave and trickle

function ChangeColour(self)
        a,b,c,d = self.t:SolidColor()
        if self.state == 'up' then
           self.t:SetSolidColor(0,255,0,255)
            self.state = 'down'        
         else
         self.t:SetSolidColor(255,0,0,255)
            self.state = 'up'
        end        
        --self.t:SetSolidColor(255-a,255-b,0,255)
        end

-- Change button images from pressed to released alternately

function ChangeImage(self)
        if self.state == 'up' then
            
            self.t:SetTexture(button_down_image)
            self.state = 'down'        
            
    else
            self.t:SetTexture(button_up_image)
            self.state = 'up'       
    end    
end

-- Used to activate / deactivate other water sounds in the concert

function Configure (self)

-- only a currently-playing-state can pass the baton/message further

if current_sound == 'wave' then
index = r2.state
others = {essl,bgaya,ksingri,alej}
end

if current_sound == 'stream' then
index = r3.state
others = {essl,bgaya,ksingri,cdat}
end

if current_sound == 'trickle' then
index = r4.state
others = {essl,bgaya,alej,cdat}
end

if current_sound == 'ripple' then
index = r5.state
others = {essl,ksingri,alej,cdat}
end
   
if current_sound == 'splash' then
index = r6.state
others = {ksingri,bgaya,alej,cdat}
end     

--DPrint(index)

-- Pass message to activate/deactivate the concerned instrument and update this status in all others

if index == 'down' then

    if self.state == 'up' then

       -- self.t:SetTexture(button_down_image)    -- set button for the selected sound
        self.t:SetTexture(0,255,0,255)    -- set button for the selected sound
        self.state = 'down'

        
       if self == r6 then
        SendOSCMessage(essl,8888,"/urMus/numbers",1.0)        -- Intimate that player to start/stop
                for i,v in ipairs(others) do
    if v ~= essl then
    SendOSCMessage(v,8888,"/urMus/numbers",6)            -- Intimate other instruments about this change
        end
    end    
    end
        
        if self == r5 then
        SendOSCMessage(bgaya,8888,"/urMus/numbers",1.0)
           for i,v in ipairs(others) do
    if v ~= bgaya then
    SendOSCMessage(v,8888,"/urMus/numbers",5)
        end
    end
        end
        
        if self == r4 then
        SendOSCMessage(ksingri,8888,"/urMus/numbers",1.0)
           for i,v in ipairs(others) do
    if v ~= ksingri then
    SendOSCMessage(v,8888,"/urMus/numbers",4)
        end
    end
        end
        
        if self == r3 then
        SendOSCMessage(alej,8888,"/urMus/numbers",1.0)
           for i,v in ipairs(others) do
    if v ~= alej then
                        SendOSCMessage(v,8888,"/urMus/numbers",3)
        end
    end
        end
    
        if self == r2 then
        SendOSCMessage(cdat,8888,"/urMus/numbers",1.0)
    for i,v in ipairs(others) do
    if v ~= cdat then
     SendOSCMessage(v,8888,"/urMus/numbers",2)
        end
    end
    end

    else
       -- self.t:SetTexture(button_up_image)
        self.t:SetTexture(255,0,0,255)    -- set button for the selected sound
        self.state = 'up'
 
        if self == r6 then
        SendOSCMessage(essl,8888,"/urMus/numbers",0.0)
            for i,v in ipairs(others) do
    if v ~= essl then
    SendOSCMessage(v,8888,"/urMus/numbers",6)
        end
    end
        end
        
        if self == r5 then
        SendOSCMessage(bgaya,8888,"/urMus/numbers",0.0)
            for i,v in ipairs(others) do
    if v ~= bgaya then
    SendOSCMessage(v,8888,"/urMus/numbers",5)
        end
    end
        end
        
        if self == r4 then
        SendOSCMessage(ksingri,8888,"/urMus/numbers",0.0)
           for i,v in ipairs(others) do
    if v ~= ksingri then
    SendOSCMessage(v,8888,"/urMus/numbers",4)
        end
    end
        end
        
        if self == r3 then
        SendOSCMessage(alej,8888,"/urMus/numbers",0.0)
            for i,v in ipairs(others) do
    if v ~= alej then
    SendOSCMessage(v,8888,"/urMus/numbers",3)
        end
    end
        end
    
        if self == r2 then
        SendOSCMessage(cdat,8888,"/urMus/numbers",0.0)
            for i,v in ipairs(others) do
    if v ~= cdat then
    SendOSCMessage(v,8888,"/urMus/numbers",2)
        end
    end
        end

    end
    end
end

-- To shuffle within a selected instrument / sound / sub-sound

function Switch()
    ucPushA1:Push((sample)/3)
    sample = sample + 1
        if sample == 4 then
            sample = 1
        end
end

-- To turn off the current device

function turnoff(self)
	
	if current_sound == 'wave' then
	dac:RemovePullLink(0, ucSample, 0)
	dac:RemovePullLink(0, ucSample0, 0)
	end
	
	if current_sound == 'stream' then
	dac:RemovePullLink(0, ucSample1, 0)
	end

	if current_sound == 'trickle' then
	dac:RemovePullLink(0, ucSample2, 0)
	dac:RemovePullLink(0, ucSample20, 0)
	end

	if current_sound == 'ripple' then
	dac:RemovePullLink(0, ucSample3, 0)
	end

	if current_sound == 'splash' then
	dac:RemovePullLink(0, ucSample4, 0)
	end

end

-- Configuring the instrument based on selection in the first main interface

function ConfigureWave(self)
current_sound='wave'   
--FreeAllRegions()
SetBackGroundImage(self)
ConfigureInstr()
r9:Hide()
r9:EnableInput(false)
r10:Hide()
r10:EnableInput(false)
r7:SetLayer("LOW")
r7:Show()
r7:EnableInput(true)
r8:SetLayer("LOW")
r8:Show() 
r8:EnableInput(true)

sample = 1
count = 0

-- Loading respective sounds

function Load (self)
reset()
count = count + 1
dac:SetPullLink(0, ucSample, 0)
ucPushA1:SetPushLink(0,ucSample, 3)  -- Sample switcher
ucPushA1:Push(0)
if count == 1 and r2.state == 'up' then
ChangeColour(r2)
SendOSCMessage(essl,8888,"/urMus/numbers",2)
SendOSCMessage(alej,8888,"/urMus/numbers",2)
SendOSCMessage(bgaya,8888,"/urMus/numbers",2)
SendOSCMessage(ksingri,8888,"/urMus/numbers",2)
end
end

function Load0 (self)
reset()
count = count + 1
dac:SetPullLink(0, ucSample0, 0)
ucPushA1:SetPushLink(0,ucSample0, 3)  -- Sample switcher
ucPushA1:Push(0)
if count == 1 and r2.state == 'up' then
ChangeColour(r2)
SendOSCMessage(essl,8888,"/urMus/numbers",2)
SendOSCMessage(alej,8888,"/urMus/numbers",2)
SendOSCMessage(bgaya,8888,"/urMus/numbers",2)
SendOSCMessage(ksingri,8888,"/urMus/numbers",2)
end
end

-- Enabling manual control to activate / deactivate all other instruments and play self

r7:Handle("OnEnter",Load)
r7:Handle("OnDoubleTap",Switch)
r7:EnableInput(true)

r8:Handle("OnEnter",Load0)
r8:Handle("OnDoubleTap",Switch)
r8:EnableInput(true)

r1:Handle("OnTouchDown",turnoff)
r1:EnableInput(true)

r3:Handle("OnTouchDown",Configure)
r3:EnableInput(true)

r4:Handle("OnTouchDown",Configure)
r4:EnableInput(true)

r5:Handle("OnTouchDown",Configure)
r5:EnableInput(true)

r6:Handle("OnTouchDown",Configure)
r6:EnableInput(true)
end

function ConfigureStream(self)
current_sound='stream'   
--FreeAllRegions()
SetBackGroundImage(self) 
ConfigureInstr()
r9:Hide()
r9:EnableInput(false)
r10:Hide()
r10:EnableInput(false)
r7:Hide()
r7:EnableInput(false)
r8:Hide()
r8:EnableInput(false)   

sample = 1
count1 = 0


-- Loading respective sounds

function Load1 ()
reset()
count1 = count1 + 1
dac:SetPullLink(0, ucSample1, 0)
ucPushA1:SetPushLink(0,ucSample1, 3)  -- Sample switcher
ucPushA1:Push(0)
if count1 == 1 and r3.state == 'up' then
ChangeColour(r3)
SendOSCMessage(essl,8888,"/urMus/numbers",3)
SendOSCMessage(cdat,8888,"/urMus/numbers",3)
SendOSCMessage(bgaya,8888,"/urMus/numbers",3)
SendOSCMessage(ksingri,8888,"/urMus/numbers",3)
end
end

-- Enabling manual control to activate / deactivate all other instruments and play self
    
rmusic:Show()
rmusic:Handle("OnEnter",Load1)
rmusic:Handle("OnDoubleTap",Switch)
rmusic:EnableInput(true)

r1:Handle("OnTouchDown",turnoff)
r1:EnableInput(true)
 
r2:Handle("OnTouchDown",Configure)
r2:EnableInput(true)

r4:Handle("OnTouchDown",Configure)
r4:EnableInput(true)

r5:Handle("OnTouchDown",Configure)
r5:EnableInput(true)

r6:Handle("OnTouchDown",Configure)
r6:EnableInput(true)
end

function ConfigureTrickle(self)
current_sound='trickle'   
--FreeAllRegions()
SetBackGroundImage(self) 
ConfigureInstr()
r7:Hide()
r7:EnableInput(false)
r8:Hide()
r8:EnableInput(false)
r9:SetLayer("LOW")
r9:Show()
r9:EnableInput(true)
r10:SetLayer("LOW")
r10:Show()
r10:EnableInput(true)

sample = 1
count2 = 0


-- Loading respective sounds

function Load2 (self)
reset()
count2 = count2 + 1
dac:SetPullLink(0, ucSample2, 0)
ucPushA1:SetPushLink(0,ucSample2, 3)  -- Sample switcher
ucPushA1:Push(0)
if count2 == 1 and r4.state == 'up' then
ChangeColour(r4)
SendOSCMessage(essl,8888,"/urMus/numbers",4)
SendOSCMessage(cdat,8888,"/urMus/numbers",4)
SendOSCMessage(bgaya,8888,"/urMus/numbers",4)
SendOSCMessage(alej,8888,"/urMus/numbers",4)
end
end

function Load20 (self)
reset()
count2 = count2 + 1
dac:SetPullLink(0, ucSample20, 0)
ucPushA1:SetPushLink(0,ucSample20, 3)  -- Sample switcher
ucPushA1:Push(0)
if count2 == 1 and r4.state == 'up' then
ChangeColour(r4)
SendOSCMessage(essl,8888,"/urMus/numbers",4)
SendOSCMessage(cdat,8888,"/urMus/numbers",4)
SendOSCMessage(bgaya,8888,"/urMus/numbers",4)
SendOSCMessage(alej,8888,"/urMus/numbers",4)
end
end

-- Enabling manual control to activate / deactivate all other instruments and play self

r9:Handle("OnEnter",Load2)
r9:Handle("OnDoubleTap",Switch)
r9:EnableInput(true)

r10:Handle("OnEnter",Load20)
r10:Handle("OnDoubleTap",Switch)
r10:EnableInput(true)

r1:Handle("OnTouchDown",turnoff)
r1:EnableInput(true)

r2:Handle("OnTouchDown",Configure)
r2:EnableInput(true)

r3:Handle("OnTouchDown",Configure)
r3:EnableInput(true)

r5:Handle("OnTouchDown",Configure)
r5:EnableInput(true)

r6:Handle("OnTouchDown",Configure)
r6:EnableInput(true)
end

function ConfigureRipple(self)
current_sound='ripple'   
--FreeAllRegions()
SetBackGroundImage(self) 
ConfigureInstr()
r9:Hide()
r9:EnableInput(false)
r10:Hide()
r10:EnableInput(false)
r7:Hide()
r7:EnableInput(false)
r8:Hide()
r8:EnableInput(false)

sample = 1
count3 = 0

-- Loading respective sounds

function Load3 ()
reset()
count3 = count3 + 1
dac:SetPullLink(0, ucSample3, 0)
ucPushA1:SetPushLink(0,ucSample3, 3)  -- Sample switcher
ucPushA1:Push(0)
if count3 == 1 and r5.state == 'up' then
ChangeColour(r5)
SendOSCMessage(essl,8888,"/urMus/numbers",5)
SendOSCMessage(cdat,8888,"/urMus/numbers",5)
SendOSCMessage(ksingri,8888,"/urMus/numbers",5)
SendOSCMessage(alej,8888,"/urMus/numbers",5)
end
end

-- Enabling manual control to activate / deactivate all other instruments and play self
    
rmusic:Show()
rmusic:Handle("OnEnter",Load3)
rmusic:Handle("OnDoubleTap",Switch)
rmusic:EnableInput(true)

r1:Handle("OnTouchDown",turnoff)
r1:EnableInput(true)

r2:Handle("OnTouchDown",Configure)
r2:EnableInput(true)

r3:Handle("OnTouchDown",Configure)
r3:EnableInput(true)

r4:Handle("OnTouchDown",Configure)
r4:EnableInput(true)

r6:Handle("OnTouchDown",Configure)
r6:EnableInput(true)
end

function ConfigureSplash(self)
current_sound='splash'   
--FreeAllRegions()
SetBackGroundImage(self) 
ConfigureInstr()
r9:Hide()
r9:EnableInput(false)
r10:Hide()
r10:EnableInput(false)
r7:Hide()
r7:EnableInput(false)
r8:Hide()
r8:EnableInput(false)

sample = 1
count4 = 0 

-- Loading respective sounds

function Load4 ()
reset()
count4 = count4 + 1
dac:SetPullLink(0, ucSample4, 0)
ucPushA1:SetPushLink(0,ucSample4, 3)  -- Sample switcher
ucPushA1:Push(0)
if count4 == 1 and r6.state == 'up' then
ChangeColour(r6)
SendOSCMessage(bgaya,8888,"/urMus/numbers",6)
SendOSCMessage(cdat,8888,"/urMus/numbers",6)
SendOSCMessage(ksingri,8888,"/urMus/numbers",6)
SendOSCMessage(alej,8888,"/urMus/numbers",6)
end
end

-- Enabling manual control to activate / deactivate all other instruments and play self

rmusic:Show()
rmusic:Handle("OnEnter",Load4)
rmusic:Handle("OnDoubleTap",Switch)
rmusic:EnableInput(true)    

r1:Handle("OnTouchDown",turnoff)
r1:EnableInput(true)

r2:Handle("OnTouchDown",Configure)
r2:EnableInput(true)

r3:Handle("OnTouchDown",Configure)
r3:EnableInput(true)

r4:Handle("OnTouchDown",Configure)
r4:EnableInput(true)

r5:Handle("OnTouchDown",Configure)
r5:EnableInput(true)
end

-- Updating status of other instruments upon receiving network message

function SetOtherImages(dev)   
   
    if dev == 2 then
    ChangeColour(r2)
    end 
   
    if dev == 3 then
    ChangeColour(r3)
    end
    
    if dev == 4 then
    ChangeColour(r4)
    end
    if dev == 5 then
    ChangeColour(r5)
    end
        if dev == 6 then
    ChangeColour(r6)
     end    
end

-- Implementation of activate /deactivate / update status on receving network message

function gotOSC(self, num)
            
    if num == 1 and current_sound == 'stream' then
       ChangeColour(r3)
    end

    if num == 0 and current_sound == 'stream' then    
    dac:RemovePullLink(0, ucSample1, 0)
        ChangeColour(r3)
    end

    if num == 1 and current_sound == 'ripple' then    
       ChangeColour(r5)
    end

    if num == 0 and current_sound == 'ripple' then    
    dac:RemovePullLink(0, ucSample3, 0)
        ChangeColour(r5)
    end

    if num == 1 and current_sound == 'splash' then    
        ChangeColour(r6)
    end
    
    if num == 0 and current_sound == 'splash' then    
    dac:RemovePullLink(0, ucSample4, 0)
        ChangeColour(r6)
    end

    if num == 1 and current_sound == 'wave' then    
              ChangeColour(r2)
    end

    if num == 0 and current_sound == 'wave' then    
    dac:RemovePullLink(0, ucSample, 0)
    dac:RemovePullLink(0, ucSample0, 0)
        ChangeColour(r2)
    end
    
    if num == 1 and current_sound == 'trickle' then    
       ChangeColour(r4)
    end

    if num == 0 and current_sound == 'trickle' then    
    dac:RemovePullLink(0, ucSample2, 0)
    dac:RemovePullLink(0, ucSample20, 0)
        ChangeColour(r4)
    end
    
    if num ~= 0 and num ~= 1 then
    SetOtherImages(num)
    end
end


r2:Handle("OnOSCMessage",gotOSC)
r3:Handle("OnOSCMessage",gotOSC)
r4:Handle("OnOSCMessage",gotOSC)
r5:Handle("OnOSCMessage",gotOSC)
r6:Handle("OnOSCMessage",gotOSC)

SetOSCPort(8888)
host,post = StartOSCListener()

-- Help highlight buttons for easy selection

if host == ksingri then -- trickle
	rb.t:SetSolidColor(0,0,0,0)
elseif host == cdat then -- wave
	r.t:SetSolidColor(0,0,0,0)
elseif host == bgaya then -- ripple
	rc.t:SetSolidColor(0,0,0,0)
elseif host == alej then -- stream
	ra.t:SetSolidColor(0,0,0,0)
elseif host == essl then -- splash
	rd.t:SetSolidColor(0,0,0,0)
end

--Activate regions

r:Handle("OnTouchDown",ConfigureWave)
r:EnableInput(true)

ra:Handle("OnTouchDown",ConfigureStream)
ra:EnableInput(true)

rb:Handle("OnTouchDown",ConfigureTrickle)
rb:EnableInput(true)

rc:Handle("OnTouchDown",ConfigureRipple)
rc:EnableInput(true)

rd:Handle("OnTouchDown",ConfigureSplash)
rd:EnableInput(true)

r7:Handle("OnTouchDown",ChangeColour)
r7:EnableInput(true)

r8:Handle("OnTouchDown",ChangeColour)
r8:EnableInput(true)

r9:Handle("OnTouchDown",ChangeColour)
r9:EnableInput(true)

r10:Handle("OnTouchDown",ChangeColour)
r10:EnableInput(true)
