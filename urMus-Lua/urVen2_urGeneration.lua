-----------------------------------------------------------
--                     Generation                        --
-----------------------------------------------------------
-- Allows users to set up Generation events for regions

function MenuGeneration(opt,vv)
    OpenGenDialog(vv)
    UnHighlight(opt)
    CloseMenuBar()
end

function createProjectiles(self)
    r = Region()
    if self.projpicture == nil then
        r.t = r:Texture(255,255,255,255)
    else
        r.t = r:Texture(pics[self.projpicture])
        r.t:SetBlendMode("ALPHAKEY")
    end
    r:SetHeight(50)
    r:SetWidth(50)
    
    r.speedy = 0
    r.speedx = 0
    r.live = false
    if self.direction == "U" then
        r.speedy = self.projectileSpeed
    elseif self.direction == "D" then
        r.speedy = -self.projectileSpeed
    elseif self.direction == "R" then
        r.speedx = self.projectileSpeed
    elseif self.direction == "L" then
        r.speedx = -self.projectileSpeed
    end   
    r.x = 0
    r.y = 0
    
    return r    
end

function startProjectiles(self)
    for i = 1, self.numProjectiles do
        
        if not self[i].live then
            
            if math.random(0,self.genSpeed) == 0 then
                
                self[i].live = true
                if self.direction == "U" then                    
                    self[i].y = self.bottomY
                    if self.randomise == "Y" then
                        self[i].x = math.random(self.leftX, self.rightX-50)
                    else
                        self[i].x = self.centerX-25
                    end
                elseif self.direction == "D" then
                    self[i].y = self.topY-50
                    if self.randomise == "Y" then
                        self[i].x = math.random(self.leftX, self.rightX-50)
                    else
                        self[i].x = self.centerX-25
                    end
                elseif self.direction == "L" then                    
                    self[i].x = self.rightX-50
                    if self.randomise == "Y" then
                        self[i].y = math.random(self.bottomY,self.topY-50)
                    else
                        self[i].y = self.centerY-25
                    end
                elseif self.direction == "R" then                    
                    self[i].x = self.leftX
                    if self.randomise == "Y" then
                        self[i].y = math.random(self.bottomY,self.topY-50)
                    else
                        self[i].y = self.centerY-25
                    end
                end
                break
            end
        end
    end
end

function drawProjectiles(self)
    for i = 1, self.numProjectiles do
        if self[i].live then
            self[i]:Show()
        end
    end
end

function updateProjectiles(self)
    for i = 1, self.numProjectiles do        
        if self[i].live then
            self[i].x = self[i].x + self[i].speedx
            self[i].y = self[i].y + self[i].speedy
            self[i]:SetAnchor("BOTTOMLEFT",self[i].x,self[i].y)
        end
        if self[i].live and self[i].y > ScreenHeight() or self[i].y < 0 or self[i].x > ScreenWidth() or self[i].x < 0 then
            self[i].live = false 
            self[i]:Hide()
        end
    end
end
function GenerationEvent(self,elapsed)
    self.topY = self:Top()
    self.bottomY = self:Bottom()
    self.rightX = self:Right()
    self.leftX = self:Left()
    self.centerX,self.centerY = self:Center()    
    self.width = self:Width()
    
    startProjectiles(self)
    drawProjectiles(self)
    updateProjectiles(self)
end

function StartGenerating(vv,numProjectiles,genSpeed,projectileSpeed,direction,randomise)
    vv.numProjectiles = numProjectiles
    vv.genSpeed = genSpeed
    vv.direction = direction
    vv.projectileSpeed = projectileSpeed
    vv.randomise = randomise
    
    for i = 1,numProjectiles do
        vv[i] = createProjectiles(vv)
    end
    if vv.eventlist["OnUpdate"]["generate"] == 0 then
        table.insert(vv.eventlist["OnUpdate"],GenerationEvent)
        vv.eventlist["OnUpdate"]["generate"] = 1
    end
end

function OKGenclicked(self)
    local dd = self.parent 
    local region = dd.caller
    
    numProjectiles = tonumber(dd[1][2].tl:Label())
    genSpeed = tonumber(dd[2][2].tl:Label())
    projectileSpeed = tonumber(dd[3][2].tl:Label())
    direction = tostring(dd[4][2].tl:Label())  
    randomise = tostring(dd[5][2].tl:Label())
    image = tostring(dd[6][2].tl:Label())      
    
    StartGenerating(region,numProjectiles,genSpeed,projectileSpeed,direction,randomise)
    
    CloseGenDialog(self.parent)
end

function CloseGenDialog(self)
    self.title:Hide()
    for i = 1,#self.tooltips do
        self[i][1]:Hide()
        self[i][2]:Hide()
        self[i][2]:EnableInput(false)
    end
    
    self[#self.tooltips][1]:EnableInput(false)
    mykb:Hide()
    self.ready = 0
    backdrop:EnableInput(true)
end

function CANCELGenclicked(self)
    CloseGenDialog(self.parent)
end

function pictureLoading(self)
    picture = CreateorRecycleregion('region', 'backdrop', UIParent)
    OpenPictureDialog(picture) 
    self.parent.caller.projpicture = globalPic    
end

gendialog = {}
gendialog.title = Region('region','dialog',UIParent)
gendialog.title.t = gendialog.title:Texture(240,240,240,255)
gendialog.title.tl = gendialog.title:TextLabel()
gendialog.title.tl:SetLabel("Generation")
gendialog.title.tl:SetFontHeight(16)
gendialog.title.tl:SetColor(0,0,0,255) 
gendialog.title.tl:SetHorizontalAlign("JUSTIFY")
gendialog.title.tl:SetShadowColor(255,255,255,255)
gendialog.title.tl:SetShadowOffset(1,1)
gendialog.title.tl:SetShadowBlur(1)
gendialog.title:SetWidth(550)
gendialog.title:SetHeight(50)
gendialog.title:SetAnchor("BOTTOM",UIParent,"CENTER",0,300)
gendialog.tooltips = {{"How Many?","10"},{"How Often to Generate?","500"},{"How Fast should they move?","10"},{"Which Direction? (First letter of direction)","U"},{"Randomize Start Position?","Y"},{"Image for Projectile?",nil},{"OK","CANCEL"}}

gendialog.caller = nil
gendialog.picture = nil

for i = 1,#gendialog.tooltips do
    gendialog[i] = {}
    gendialog[i][1] = CreateAnimOptions(tostring(gendialog.tooltips[i][1]),400)
    gendialog[i][2] = CreateAnimOptions(gendialog.tooltips[i][2],150)
    gendialog[i][2]:SetAnchor("LEFT",gendialog[i][1],"RIGHT",0,0)
    gendialog[i][1].parent = gendialog
    gendialog[i][2].parent = gendialog
end

gendialog[1][2]:Handle("OnTouchDown",OpenOrCloseNumericKeyboard)
gendialog[2][2]:Handle("OnTouchDown",OpenOrCloseNumericKeyboard)
gendialog[3][2]:Handle("OnTouchDown",OpenOrCloseNumericKeyboard)
gendialog[4][2]:Handle("OnTouchDown",OpenOrCloseKeyboard)
gendialog[5][2]:Handle("OnTouchDown",OpenOrCloseKeyboard)
gendialog[6][2]:Handle("OnTouchDown",pictureLoading)
gendialog[7][1]:Handle("OnTouchDown",OKGenclicked)
gendialog[7][2]:Handle("OnTouchDown",CANCELGenclicked)

gendialog[1][1]:SetAnchor("TOPLEFT",gendialog.title,"BOTTOMLEFT",0,0)

for i = 2,#gendialog.tooltips do
    gendialog[i][1]:SetAnchor("TOPLEFT",gendialog[i-1][1],"BOTTOMLEFT",0,0)
end

function OpenGenDialog(v)
    gendialog.title:Show()
    gendialog.title:MoveToTop()
    gendialog.caller = v
    DPrint("Generation configuration for "..v:Name())
    for i = 1,#gendialog.tooltips do
        gendialog[i][1]:Show()
        gendialog[i][2]:Show()
        gendialog[i][1]:MoveToTop()
        gendialog[i][2]:MoveToTop()
        gendialog[i][2].tl:SetLabel(tostring(gendialog.tooltips[i][2]))
        gendialog[i][2]:EnableInput(true)
    end
    gendialog[#gendialog.tooltips][1]:EnableInput(true)
    gendialog.picture = nil
    backdrop:EnableInput(false)
end