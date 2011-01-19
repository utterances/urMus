--[[
EECS 498
Gayathri Balasubramanian
Lubin Tan
--]]


--[[
The following PNG files that are attached along with this  code, have to be uploaded to the system, for the application to function correctly-
Left.png
Right.png
Play.png
PlayButton_Down.png
virtual_space.png
--]]

--[[
Master:
Sends the position of the ball to all Servant devices on update.
When a different player hits the ball, the variable "choose" changes, and the Master sends this "choose" variable on the next update to tell which Servant devices should play and which ones should turn off.

Servant:
Sends accelX and velX to the Master device on a hit. The Master device calculates the position of the ball based on the updated accelX and velX and sends the new position of the ball to all devices.
Also sends the "choose" value on a hit. The Master updates the "choose" value and sends this to the Servant devices.

--]]

local scalex = ScreenWidth()/320.0
local scaley = ScreenHeight()/480.0

FreeAllRegions()
--Define Regions
backG = Region()
backG:SetWidth(ScreenWidth())
backG:SetHeight(ScreenHeight())
backG:SetLayer("PARENT")
backG:SetAnchor("BOTTOMLEFT",0,0)
backG:Show()


piano = Region()
piano.t = piano:Texture("ball_piano.png")
piano.t:SetRotation(3*math.pi/4)
piano:SetWidth(.58*backG:Width())
piano:SetHeight(.78*backG:Height())
piano:SetLayer("LOW")
piano:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",80*scalex,0)
piano:Show()

direction = Region()
direction.t = direction:Texture("Right.png")
direction.t:SetRotation(3*math.pi/4)
direction:SetWidth(.55*backG:Width())
direction:SetHeight(.5*backG:Height())
direction:SetLayer("MEDIUM")
direction:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",25*scalex,330*scaley)
direction:Show()

play = Region()
play.t = play:Texture("Play.png")
play.t:SetRotation(3*math.pi/4)
play:SetWidth(.62*backG:Width())
play:SetHeight(.5*backG:Height())
play:SetLayer("LOW")
play:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",-120*scalex,330*scaley)
play:Show()

virtual_space = Region()
virtual_space.t = virtual_space:Texture("virtual_space.png")
virtual_space.t:SetRotation(3*math.pi/4)
virtual_space:SetWidth(1.5*backG:Width())
virtual_space:SetHeight(.74*backG:Height())
virtual_space:SetLayer("BACKGROUND")
virtual_space:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",115*scalex,0)

--Create the Ball
virtual_space.t:SetFill(true)
virtual_space.t:SetBrushColor(255,255,0,255)
virtual_space.t:SetBrushSize(3)
virtual_space.t:Ellipse(10, 175, 7, 7)

virtual_space:Show()


--[[for reference:
virtual space corners are:
bottom left: 10,33
top left: 10,118
bottom right: 230, 33
top right: 230, 118

Region 1 x: 10->25
Region 2 x: 70 -> 95
Region 3 x: 145 -> 170
Region 4 x:  215 -> 230
--]]

--Define variables
posX=0
velX=0
newX = 0
dir = 1 --Right: 1, Left: -1
playing= 0
acclX=0.5
velXMax =7
fps = 60

timer = 0
control = 0.00000001

flip=1
choose = 0
newchoose = 0

floor = math.floor
modf= math.modf
log = math.log

pitch = {}
pitch[1] = 2*12.0/96.0*log(262.0/55)/log(2) -- C
pitch[2] = 2*12.0/96.0*log(294/55)/log(2) -- D
pitch[3] = 2*12.0/96.0*log(330/55)/log(2)--E
pitch[4] = 2*12.0/96.0*log(349/55)/log(2) -- F

if not sound then
    sound = FlowBox("object","sound", _G["FBSinOsc"])
end

if not Asymp then
    Asymp = FlowBox("object","sound", _G["FBAsymp"])
end

if not PushIt then
    PushIt = FlowBox("object","PushIt", _G["FBPush"])
end

if not PushVol then
    PushVol = FlowBox("object","PushVol", _G["FBPush"])
end

if not dac then
    dac = _G["FBDac"]
end

dac:SetPullLink(0, sound, 0)
PushIt:SetPushLink(0, sound, 0)

PushVol:SetPushLink(0, Asymp, 0)
Asymp:SetPushLink(0, sound, 1)

PushIt:Push(0)
PushVol:Push(0)





function updateBall(self,elapsed)
 timer = timer + elapsed
    DPrint(choose)
    if timer > control then
        
--        if  (choose==1000) or (choose==3000) or (choose==4000) then
        if (choose~=2000) then  
        PushVol:Push(0)

        end
    
        --acount for the ball hitting boundary walls
        --the 0.9 factor is to account for some energy loss when the ball hits the walls                           
        if ((posX>=220) and (acclX==0)) then
           velX=-0.9*math.abs(velX)
            posX=220
        else if ( (posX<=0) and (acclX==0)) then
                velX=0.9*math.abs(velX)
                posX=0
            end
        end

        --define physics of ball's movement
        velX = velX + acclX*(100/fps)
        posX= posX + velX*(100/fps)
        
  
        if not (newchoose==choose) then
            SendOSCMessage("192.168.1.211",8888,"/urMus/numbers",newchoose)
            SendOSCMessage("192.168.1.212",8888,"/urMus/numbers",newchoose)
            SendOSCMessage("192.168.1.213",8888,"/urMus/numbers",newchoose)
            SendOSCMessage("192.168.1.214",8888,"/urMus/numbers",newchoose)
            choose = newchoose
        else
            SendOSCMessage("192.168.1.211",8888,"/urMus/numbers",posX)
            SendOSCMessage("192.168.1.212",8888,"/urMus/numbers",posX)
            SendOSCMessage("192.168.1.213",8888,"/urMus/numbers",posX)
            SendOSCMessage("192.168.1.214",8888,"/urMus/numbers",posX)
        end  
        
        if velX > velXMax then
            velX = velXMax
        elseif velX < -velXMax then
            velX = -velXMax
        end  
        
        --reset acceleration after a hit
        acclX = 0

        self.t:Clear();
        self.t:SetTexture("virtual_space.png");    
        self.t:Ellipse(10+ posX, 175, 7, 7)  

        timer = 0
    end    
end


--[[
This is where the multiple values are required.
--]]
function gotOSC(self, num)
    
    newchoose = (num%10)*1000

    floor_num = floor(num/10)
    
    acclX = (floor_num%1000)/100
    velX = ((floor(floor_num/1000))/100) -10
    --DPrint(num)
    --DPrint("acclX: "..acclX.."velX: "..velX.."newchoose: "..newchoose)                        
    
--[[    if flip==1 then
        acclX = num
        flip =2
    elseif flip==2 then
        velX = num      
        flip = 3
    elseif flip==3 then
        newchoose = num
        flip = 1
    end
--]]    
end



function swing2(self, x, y, z)
    --for player 2
    --a hit is enabled when the ball is within the column, the play button is held down, and the accelerometer's y-value is above a certain threshold
    if( (posX+10)>70 and (posX+10)<95 and math.abs(y)>=0.2 and (playing==1)) then
        PushIt:Push(pitch[2])
        PushVol:Push(1)
    
        if (math.abs(y) < newX) then --we only update the ball's acceleration using the largest y magnitude during the swing

            if(dir < 0) then
                acclX = -newX
                if (velX > 0) then
                    velX = -0.9*velX
                end
            else
                acclX = newX
                if (velX < 0) then
                    velX = -0.9*velX
                end
                newchoose = 2000                    
            end

        else
            newX = math.abs(y)
        end
    end
end

function dir_change(self)
    dir = -dir
    if (dir>0) then
        self.t:SetTexture("Right.png")
    else
        self.t:SetTexture("Left.png")
    end
end

function start_play(self)
    if playing == 1 then
        self.t:SetTexture("pause_touch_down.png")
    elseif playing == 0 then
        self.t:SetTexture("PlayButton_down.png")
    end        
end

function stop_play(self)
    if(playing ==1) then
        playing = 0
        self.t:SetTexture("Play.png")
    elseif(playing==0) then
        playing=1
        self.t:SetTexture("pause.png")
    end
end
 
virtual_space:Handle("OnUpdate", updateBall)
virtual_space:Handle("OnAccelerate", swing2)
direction:Handle("OnTouchDown", dir_change)
play:Handle("OnTouchDown", start_play)
play:Handle("OnTouchUp", stop_play)
virtual_space:Handle("OnOSCMessage",gotOSC)

direction:EnableInput(true)
play:EnableInput(true)

SetOSCPort(8888)
StartOSCListener()

