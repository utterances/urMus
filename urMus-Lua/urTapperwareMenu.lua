------------- menu functions --------------
-- called by menu option, named starting with Menu-
-- arguments (opt,vv): opt is menu option region, vv is the region that functions should be implemented on

-- ============================
-- = Menus, contextual mostly =
-- ============================
-- we need region specific menu for hooking up signals(sender and receiver), and then creation menu

BUTTONSIZE = 56	-- on screen size in points/pixels
BUTTONOFFSET = 3
BUTTONIMAGESIZE = 80		-- size of the square icon image

function testMenu(self)
	DPrint("touched menu on"..self:Name())
end

function CloseRegion(self)
	DPrint("touched close")
	RemoveV(self)
end

function StartLinkRegionAction(r)
	DPrint("initiating linking")
	StartLinkRegion(r)
end

function SwitchRegionTypeAction(r)
	DPrint("switch type")
	SwitchRegionType(r)
end

-- radial menu layout:
-- 1 2 3
-- 4 9 5
-- 6 7 8

local buttonLocation = {
	[1]={"TOPLEFT", BUTTONOFFSET, -BUTTONOFFSET},
	[3]={"TOPRIGHT", -BUTTONOFFSET, -BUTTONOFFSET},
	[4]={"LEFT", BUTTONOFFSET, 0},
	[6]={"BOTTOMLEFT", BUTTONOFFSET, BUTTONOFFSET},
	[7]={"BOTTOM", 0, BUTTONOFFSET},	
	[8]={"BOTTOMRIGHT", -BUTTONOFFSET, BUTTONOFFSET},
	[9]={"CENTER", 0, 0}
}

local regionMenu = {}
-- label, func, anchor relative to region, image file
regionMenu.cmdList = {
	{"", CloseRegion, 1, "tw_closebox.png"},
	{"TAP", StartLinkRegionAction, 3, "tw_socket1.png"},
	{"", SwitchRegionTypeAction, 4, "tw_varswitcher.png"},
	{"", testMenu, 6, "tw_timer.png"},
	{"", testMenu, 7, "tw_paint.png"},
	{"", testMenu, 8, "tw_run.png"},
}

local regionConMenu = {}
-- label, func, anchor relative to region, image file
regionConMenu.cmdList = {
	{"Close", CloseRegion, 1, "tw_closebox.png"},
	{"ReceiveLink", ReceiveLinkRegion, 4, "tw_socket2.png"}
}

-- initialize regionMenu graphics
regionMenu.items = {}

for k,item in pairs(regionMenu.cmdList) do
	label = item[1]
	func = item[2]
	anchor = item[3]
	image = item[4]
	
  local r = Region('region','menu',UIParent)
  r.tl = r:TextLabel()
  r.tl:SetLabel(label)
  r.tl:SetFontHeight(12)
  r.tl:SetColor(0,0,0,255) 	
	r.t = r:Texture(image)
	r.t:SetTexCoord(0,BUTTONIMAGESIZE/128,BUTTONIMAGESIZE/128,0)
	r.t:SetBlendMode("BLEND")
	-- r:SetAnchor(anchor, UIParent)
	r:SetLayer("TOOLTIP")
	r:SetHeight(BUTTONSIZE)
	r:SetWidth(BUTTONSIZE)
	r:MoveToTop()
	-- r:Show()
	r:Hide()
	-- r:Handle("OnTouchDown",OptEventFunc)
	
	r.func = func
	r.anchorpos = anchor
	r.parent = regionMenu
	table.insert(regionMenu.items, r)
end
regionMenu.show = 0
regionMenu.v = nil


-- initialize connection receiver menu graphics
regionConMenu.items = {}

for k,item in pairs(regionConMenu.cmdList) do
	label = item[1]
	func = item[2]
	anchor = item[3]
	image = item[4]
	
  local r = Region('region','menu',UIParent)
  r.tl = r:TextLabel()
  -- r.tl:SetLabel(label)
  r.tl:SetFontHeight(13)
  r.tl:SetColor(0,0,0,255) 	
	r.t = r:Texture(image)
	r.t:SetTexCoord(0,BUTTONIMAGESIZE/128,BUTTONIMAGESIZE/128,0)
	r.t:SetBlendMode("BLEND")
	-- r:SetAnchor(anchor, UIParent)
	r:SetLayer("TOOLTIP")
	r:SetHeight(BUTTONSIZE)
	r:SetWidth(BUTTONSIZE)
	r:MoveToTop()
	-- r:Show()
	r:Hide()
	r:Handle("OnTouchDown",OptEventFunc)
	
	r.func = func
	r.anchorpos = anchor
	table.insert(regionConMenu.items, r)
end
regionConMenu.show = 0

function OpenMenu(self)

  -- if regionMenu.show == 0 then
		DPrint("opens menu!")
		
    regionMenu.v = self
		
    for i = 1,#regionMenu.items do
        regionMenu.items[i]:Show()
        regionMenu.items[i]:EnableInput(true)
				-- regionMenu.items[i]:Handle("OnTouchDown", testMenu)
        regionMenu.items[i]:Handle("OnTouchUp", OptEventFunc)
        regionMenu.items[i]:MoveToTop()
				pos = regionMenu.items[i].anchorpos
				regionMenu.items[i]:SetAnchor("CENTER", self,
																			buttonLocation[pos][1],
																			buttonLocation[pos][2],
																			buttonLocation[pos][3])
    end
      
		self.menu = regionMenu
    -- regionMenu.show = 1
  -- end
end

function OpenRegionMenu(self)
	OpenMenu(self, regionMenu)
end

-- keep menu on top of pesky things, like regions
function RaiseMenu(self)
  -- if regionMenu.show == 1 then
    for i = 1,#regionMenu.items do
        regionMenu.items[i]:MoveToTop()
    end
	-- end
end

function CloseMenu(self)
  -- if regionMenu.show == 1 then
    for i = 1,#regionMenu.items do
        regionMenu.items[i]:Hide()
        regionMenu.items[i]:EnableInput(false)
        -- regionMenu.items[i]:MoveToTop()
				-- regionMenu.items[i]:SetAnchor(regionMenu.items[i].anchorpos, self, "CENTER")
    end
		regionMenu.show = 0
		regionMenu.v = nil
		self.menu = nil
	-- end
end



-- this actually calls all the menu function on the right region(s)
function OptEventFunc(self)
	-- DPrint("optevent func")
	
	local target = self.parent.v
	CloseMenu(target)
	self.func(target)
    -- Highlight(self)
    -- first close other opened menu options
    -- if self.parent.openopt ~= self.k and self.parent.openopt ~= -1 and #self.parent[self.parent.openopt].menu > 0 then
    --     self.parent[self.parent.openopt].menu:CloseMenu()
    -- end
    
    -- self.parent.openopt = self.k
    -- if self.func == OpenOrCloseMenu then -- when there is sub-menu
    --     OpenOrCloseMenu(self)
    -- else
    --     for k,i in pairs (self.boss.selectedregions) do
    --         self.func(self,regions[i])
    --     end
    -- end
end

-- ==========================
-- = Menu command functions =
-- ==========================



function MenuAbout(opt,vv)
    output = vv:Name()..", sticker #"..vv.sticker..", stickees"
    if #vv.stickee == 0 then
        output = output.." #-1"
    else
        for i = 1,#vv.stickee do
            output = output.." #"..vv.stickee[i]
        end
    end
    DPrint(output)
end

function MenuUnstick(opt,vv)
    Unstick(vv)
    UnHighlight(opt)
    CloseMenuBar()
end

function RemoveV(vv)
    Unstick(vv)
    
    if vv.text_sharee ~= -1 then
        for k,i in pairs(global_text_senders) do
            if i == vv.id then
                table.remove(global_text_senders,k)
            end
        end
        regions[vv.text_sharee].text_sharee = -1
    end
    
    PlainVRegion(vv)
    vv:EnableInput(false)
    vv:EnableMoving(false)
    vv:EnableResizing(false)
    vv:Hide()
    vv.usable = 0
    
    table.insert(recycledregions, vv.id)
    DPrint(vv:Name().." removed")
end

function MenuRecycleSelf(opt,vv)
    RemoveV(vv)
    UnHighlight(opt)
    CloseMenuBar()
end

function MenuStickControl(opt,vv)
    if auto_stick_enabled == 1 then
        DPrint("AutoStick disabled")
        auto_stick_enabled = 0
    else
        DPrint("AutoStick enabled")
        auto_stick_enabled = 1
    end
end

function MenuKeyboardControl(opt,vv)
    if mykb.enabled == 1 then
        DPrint("Keyboard will be disabled in release mode")
        mykb.enabled = 0
    else
        DPrint("Keyboard will be re-enabled in release mode")
        mykb.enabled = 1
    end
end

function MenuDuplicate(opt,oldv)
    local newv = CreateorRecycleregion('region', 'backdrop', UIParent)
    -- size
    newv:SetWidth(oldv:Width())
    newv:SetHeight(oldv:Height())
    -- color
    VVSetTexture(newv,oldv)
    -- text 
    newv.tl:SetFontHeight(oldv.tl:FontHeight())
    newv.tl:SetHorizontalAlign(oldv.tl:HorizontalAlign())
    newv.tl:SetVerticalAlign(oldv.tl:VerticalAlign())
    newv.tl:SetLabel(newv.tl:Label())
    -- position
    local x,y = oldv:Center()
    local h = 10 + oldv:Height()
    newv:Show()
    if y-h < 100 then
        newv:SetAnchor("CENTER",x,y+h)
    else
        newv:SetAnchor("CENTER",x,y-h)
    end
    DPrint(newv.tl:Label().." Color: ("..newv.r..", "..newv.g..", "..newv.b..", "..newv.a.."). Background pic: "..newv.bkg..". Blend mode: "..newv.t:BlendMode())
    
    return newv
end

function MenuText(opt,vv)
    DPrint("Current text size: " .. vv.tl:FontHeight()/2 .. ", position: " .. vv.tl:VerticalAlign() .. " & " .. vv.tl:HorizontalAlign()) -- TODO wrong output
end

function MenuMoving(opt,vv)
    OpenMyDialog(vv)
    UnHighlight(opt)
    CloseMenu()
end

function menuGradient(opt,vv)
    OpenGradDialog(vv,pics)
    UnHighlight(opt)
    CloseMenu()
end

function MenuSelfFly(opt,vv) 
    -- if don't want to let it bounce from other regions, delete the following two while loops
    while #vv.bounceobjects > 0 do
        table.remove(vv.bounceobjects)
    end
    while #vv.bounceremoveobjects > 0 do
        table.remove(vv.bounceremoveobjects)
    end
    
    StartMoving(vv,1)
    DPrint(vv:Name().." randomly flies. Click it to stop.")
    UnHighlight(opt)
    CloseMenu()
end

function SelfShowHideEvent(self,e) -- event called with OnUpdate
    self.showtime = self.showtime - e
    if self.showtime <= 0 then
        if self:IsShown() then
            self:Hide()
        else
            self:Show()
        end
        self.showtime = math.random(1,4)/4
    end
end

function MenuSelfShowHide(opt,vv) 
    vv.showtime = math.random(1,4)/4
    if vv.eventlist["OnUpdate"]["selfshowhide"] == 0 then
        table.insert(vv.eventlist["OnUpdate"],SelfShowHideEvent)
        vv.eventlist["OnUpdate"]["selfshowhide"] = 1
    end
    vv.eventlist["OnUpdate"].currentevent = SelfShowHideEvent
    vv:Handle("OnUpdate",nil)
    vv:Handle("OnUpdate",VUpdate)
    DPrint(vv:Name().." randomly shows and hides. Click it to stop.")
    UnHighlight(opt)
    CloseMenu()
end

function MenuStickBoundary(opt,vv)
    DPrint("Only takes effect in release mode.")
end

function MenuMoveController(opt,vv)
    DPrint("Use a controller to control the move direction of "..vv:Name())
end

function MenuProjectileController(opt,vv)
    DPrint("Use a controller to control the projectiles from "..vv:Name())
end

function FPSEvent(self, elapsed)
    self.fps = self.fps + 1/elapsed
    self.count = self.count +1
    self.sec = elapsed + self.sec
    if (self.sec > .0001) then
        
        self.tl:SetLabel( math.floor(self.fps/self.count))
        self.sec = 0
    end 
end

function MenuFPS(opt, vv)
    if vv.eventlist["OnUpdate"]["fps"] == 0 then
        table.insert(vv.eventlist["OnUpdate"],FPSEvent)
        vv.eventlist["OnUpdate"]["fps"] = 1
    end
    
    vv.count = 0
    vv.fps = 0
    vv.sec = 0
    UnHighlight(opt)
    CloseMenu()
end
