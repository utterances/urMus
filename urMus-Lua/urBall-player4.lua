
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
piano:Layer("LOW")
piano:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",80,0)
piano:Show()

direction = Region()
direction.t = direction:Texture("Right.png")
direction.t:SetRotation(3*math.pi/4)
direction:SetWidth(.55*backG:Width())
direction:SetHeight(.5*backG:Height())
direction:SetLayer("MEDIUM")
direction:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",25,330)
direction:Show()

play = Region()
play.t = play:Texture("Play.png")
play.t:SetRotation(3*math.pi/4)
play:SetWidth(.62*backG:Width())
play:SetHeight(.5*backG:Height())
play:SetLayer("LOW")
play:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",-120,330)
play:Show()

virtual_space = Region()
virtual_space.t = virtual_space:Texture("virtual_space.png")
virtual_space.t:SetRotation(3*math.pi/4)
virtual_space:SetWidth(1.5*backG:Width())
virtual_space:SetHeight(.74*backG:Height())
virtual_space:SetLayer("BACKGROUND")
virtual_space:SetAnchor("BOTTOMRIGHT",backG,"BOTTOMRIGHT",115,0)

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
acclX=1
velXMax =7.8
fps = 60

choose = 0

timer = 0
control = 0.000000001

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

    if timer > control then
        if   (choose~=4000) then
            PushVol:Push(0)
          end            

        --acount for the ball hitting boundary walls
        --the 0.9 factor is to account for some energy loss when the ball hits the walls                           
        if ((posX>=220) and (acclX==0)) then
           velX=-0.9*math.abs(velX)
        else if ( (posX<=0) and (acclX==0)) then
                velX=0.9*math.abs(velX)
            end
        end

        --define physics of ball's movement
        velX = velX + acclX*(100/fps)
        --posX= posX + velX*(100/fps)

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

function gotOSC(self, num1)

    if(num1>=1000) then
    choose =num1
    else
    posX=num1
    end
end


function swing4(self, x, y, z)    --sends 3 values at once on a hit
    --for player 4
    --a hit is enabled when the ball is within the column, the play button is held down, and the accelerometer's y-value is above a certain threshold

    if( (posX+10)>215 and (posX+10)<230 and math.abs(y)>=0.2 and (playing==1)) then
        PushIt:Push(pitch[4])
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
            end

    vx=math.modf((velX+7)*100)
    newvelX=vx*10000
    ax=math.modf(acclX*100)
            newacclX=ax*10
            msg=newvelX+newacclX+4
            DPrint(msg)


    SendOSCMessage("192.168.1.210",8888,"/urMus/numbers",msg)
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
        self.t:SetTexture("PlayButton_Down.png")
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
virtual_space:Handle("OnAccelerate", swing4)
virtual_space:Handle("OnOSCMessage",gotOSC)
direction:Handle("OnTouchDown", dir_change)
play:Handle("OnTouchDown", start_play)
play:Handle("OnTouchUp", stop_play)

direction:EnableInput(true)
play:EnableInput(true)



SetOSCPort(8888)
StartOSCListener()

