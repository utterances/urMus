
FreeAllRegions()
--Define Regions
backG = Region()
backG:SetWidth(ScreenWidth())
backG:SetHeight(ScreenHeight())
backG:SetLayer("PARENT")
backG:SetAnchor("BOTTOMLEFT",0,0)
backG:Show()

--[[piano = Region()
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
play:Show()--]]	

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

function updateBall(self,elapsed)
 timer = timer + elapsed

    if timer > control then

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


virtual_space:Handle("OnUpdate", updateBall)
virtual_space:Handle("OnOSCMessage",gotOSC)

SetOSCPort(8888)
StartOSCListener()

