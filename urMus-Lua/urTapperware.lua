-- urTapperware.lua
-- scratch pad for new stuff to add to urVen2, borrowed heavily from urVen code
-- focus on using touch for programming, avoid menu or buttons

-- A multipurpose non-programming environment aimed towards giving the user the ability
-- To create a increasingly more complex application without any coding on the users side.
-- The basis of the script is contained in this file while most of the features are contained
-- the accompianing scripts, listed below.

-- ==================================
-- = setup Global var and constants =
-- ==================================

CREATION_MARGIN = 40	-- margin for creating via tapping
INITSIZE = 150	-- initial size for regions
MENUHOLDWAIT = 0.5 -- seconds to wait for hold to menu

regions = {}
recycledregions = {}
links = {}
initialLinkRegion = nil

FreeAllRegions()

modes = {"EDIT","RELEASE"}
current_mode = modes[1]

dofile(SystemPath("urTapperwareMenu.lua"))

-- ============
-- = Backdrop =
-- ============

function TouchDown(self)
	local x,y = InputPosition()
	
	shadow:Show()
	shadow:SetAnchor('CENTER',x,y)
  -- DPrint("release to create region")
		
end
	
function TouchUp(self)
	shadow:Hide()
	DPrint("")
 	-- DPrint("MU")
  -- CloseSharedStuff(nil)
    
	-- only create if we are not too close to the edge
  local x,y = InputPosition()

	-- if hold_region then
	-- 	DrawConnection(x,y,hold_x,hold_y)
	-- 	backdrop:Show()
	-- 	DPrint("line"..x..","..y.."-"..hold_x..","..hold_y)
	-- else
		-- backdrop:Hide()
		
		if x>CREATION_MARGIN and x<ScreenWidth()-CREATION_MARGIN and 
			y>CREATION_MARGIN and y<ScreenHeight()-CREATION_MARGIN then
			local region = CreateorRecycleregion('region', 'backdrop', UIParent)
			region:Show()
			region:SetAnchor("CENTER",x,y)
			-- DPrint(region:Name().." created, centered at "..x..", "..y)
		end
	-- end
end

function Move(self)
	local x,y = InputPosition()
	
	-- if hold_region then
	-- 	DrawConnection(x,y,hold_x,hold_y)
	-- 	backdrop:Show()
	-- 	DPrint("line"..x..","..y.."-"..hold_x..","..hold_y)
	-- else
		-- backdrop:Hide()
		if x>CREATION_MARGIN and x<ScreenWidth()-CREATION_MARGIN and 
			y>CREATION_MARGIN and y<ScreenHeight()-CREATION_MARGIN then
			shadow:SetAnchor('CENTER',x,y)
			shadow:Show()
		  -- DPrint("release to create region")
		else
			shadow:Hide()
			DPrint("")
		end
	-- end
end

function Leave(self)
	shadow:Hide()
	DPrint("")
end

backdrop = Region('region', 'backdrop', UIParent)
backdrop:SetWidth(ScreenWidth())
backdrop:SetHeight(ScreenHeight())
backdrop:SetLayer("BACKGROUND")
backdrop:SetAnchor('BOTTOMLEFT',0,0)
backdrop:Handle("OnTouchDown", TouchDown)
backdrop:Handle("OnTouchUp", TouchUp)
backdrop:Handle("OnDoubleTap", DoubleTap)
backdrop:Handle("OnEnter", Enter)
backdrop:Handle("OnLeave", Leave)
backdrop:Handle("OnMove", Move)
backdrop:EnableInput(true)
backdrop:SetClipRegion(0,0,ScreenWidth(),ScreenHeight())
backdrop:EnableClipping(true)
backdrop.player = {}
backdrop.t = backdrop:Texture("gridback.jpg")
backdrop.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
backdrop.t:SetBlendMode("BLEND")

-- backdrop.t:SetFill(true)
-- backdrop.t:SetBrushColor(150,150,150,255)
-- backdrop.t:Rect(0,0,ScreenWidth(),ScreenHeight())
-- backdrop.t:SetBrushColor(255,100,100,255)
-- backdrop.t:Ellipse(ScreenWidth()/2, ScreenHeight()/2, 200, 200)
backdrop:Show()

-- set up shadow for when tap down and hold, show future region creation location
shadow = Region('region', 'shadow', UIParent)
shadow:SetLayer("BACKGROUND")
shadow.t = shadow:Texture("tw_roundrec_create.png")
-- shadow.t:SetTexture(195,210,220,100)
shadow.t:SetBlendMode("BLEND")

-- ==========================
-- = Global event functions =
-- ==========================



-- ===================
-- = Region Creation =
-- ===================

function CreateorRecycleregion(ftype, name, parent)
    local region
    if #recycledregions > 0 then
        region = regions[recycledregions[#recycledregions]]
        table.remove(recycledregions)
        region:EnableMoving(true)
        region:EnableResizing(true)
        region:EnableInput(true)
        region.usable = 1
				region.t:SetTexture("tw_roundrec.png")	-- reset texture
    else
        region = VRegion(ftype, name, parent, #regions+1)
        table.insert(regions,region)
    end
    
    region:MoveToTop()
    return region
end

function VRegion(ttype,name,parent,id) -- customized initialization of region

	-- add a visual shadow as a second layer	
	local r_s = Region(ttype,"drops"..id,parent)
	r_s.t = r_s:Texture("tw_shadow.png")
	r_s.t:SetBlendMode("BLEND")
  r_s:SetWidth(INITSIZE+70)
  r_s:SetHeight(INITSIZE+70)
	-- r_s:EnableMoving(true)
	r_s:SetLayer("LOW")
	r_s:Show()
	
  local r = Region(ttype,"Region "..id,parent)
  r.tl = r:TextLabel()
  r.t = r:Texture("tw_roundrec.png")
	r:SetLayer("LOW")
	r.shadow = r_s
	r.shadow:SetAnchor("CENTER",r,"CENTER",0,0) 
  -- initialize for regions{} and recycledregions{}
  r.usable = 1
  r.id = id
  PlainVRegion(r)
  
  r:EnableMoving(true)
  r:EnableResizing(true)
  r:EnableInput(true)
  
  r:Handle("OnDoubleTap",VDoubleTap)
  r:Handle("OnTouchDown",VTouchDown)
  r:Handle("OnTouchUp",VTouchUp)
  r:Handle("OnMove",VMove)
		
  return r
end

function PlainVRegion(r) -- customized parameter initialization of region, events are initialized in VRegion()
    -- r.selected = 0 -- for multiple selection of menubar
		r.menu = nil
		r.counter = 0
		r.links = {}
    r.links["OnTouchDown"] = {}
		r.links["OnTouchUp"] = {}
    r.links["OnDoubleTap"] = {} --{CloseSharedStuff,OpenOrCloseKeyboard} 
		
    -- r.kbopen = 0 -- for keyboard isopen
    -- 
    -- -- initialize for events and signals
    r.eventlist = {}
    -- r.eventlist["OnTouchDown"] = {HoldTrigger,CloseSharedStuff,SelectObj,AddAnchorIcon}
    r.eventlist["OnTouchDown"] = {HoldTrigger}
    r.eventlist["OnTouchUp"] = {DeTrigger} 
    r.eventlist["OnDoubleTap"] = {} --{CloseSharedStuff,OpenOrCloseKeyboard} 
    r.eventlist["OnUpdate"] = {} 
    -- r.eventlist["OnUpdate"]["selfshowhide"] = 0
    -- r.eventlist["OnUpdate"]["selfcolor"] = 0
    -- r.eventlist["OnUpdate"]["move"] = 0
    -- r.eventlist["OnUpdate"]["animate"] = 0
    -- r.eventlist["OnUpdate"]["generate"] = 0
    -- r.eventlist["OnUpdate"]["collision"] = 0
    -- r.eventlist["OnUpdate"]["background"] = 0
    -- r.eventlist["OnUpdate"]["projectile"] = 0
    -- r.eventlist["OnUpdate"]["fps"] = 0
    r.eventlist["OnUpdate"].currentevent = nil
    -- r.reventlist = {} -- eventlist for release mode
    -- r.reventlist["OnTouchDown"] = {}
    -- r.reventlist["OnTouchUp"] = {AutoCheckStick} 
    -- r.reventlist["OnDoubleTap"] = {OpenOrCloseKeyboard}
    -- 
    -- -- auto stick
    -- r.group = r.id
    -- r.sticker = -1
    -- r.stickee = {}
    -- r.large = Region()
    -- r.large:SetAnchor("CENTER",r,"CENTER")
    
    -- -- Initialize for generation
    -- r.gencontrollerL = nil
    -- r.gencontrollerR = nil
    -- r.gencontrolle = nil
    -- r.gencontrollerD = nil
    -- r[1] = nil
    -- 
    -- -- initialize for moving
    -- r.random = 0
    -- r.speed = tonumber(moving_default_speed)
    -- r.dir = tonumber(moving_default_dir)
    -- r.moving = 0
    -- r.dx = 0
    -- r.dy = 0
    -- r.bounceobjects = {}
    -- r.bounceremoveobjects = {}
    -- r.bound = boundary
    
    -- -- Initialize for Collisions
    -- r.regionregion = {}
    -- r.regionproj = {}
    -- r.projregion = {}
    -- r.projproj = {}
    -- 
    -- -- Initialize for Background
    -- r.bgspeed = 0
    -- r.bgdir = 0
    -- 
    -- -- initialize texture, label and size
    -- r.r = 255
    -- r.g = 255
    -- r.b = 255
    -- r.a = 255
    -- r.bkg = ""
    -- --initialize gradient
    -- r.r1 = nil
    -- r.r2 = nil
    -- r.r3 = nil
    -- r.r4 = nil
    -- r.g1 = nil
    -- r.g2 = nil
    -- r.g3 = nil
    -- r.g4 = nil
    -- r.b1 = nil
    -- r.b2 = nil
    -- r.b3 = nil
    -- r.b4 = nil
    -- r.a1 = nil
    -- r.a2 = nil
    -- r.a3 = nil
    -- r.a4 = nil
    -- r.t:SetTexture(r.r,r.g,r.b,r.a)
		r.t:SetBlendMode("BLEND")
    r.tl:SetLabel(r:Name())
    r.tl:SetFontHeight(16)
		r.tl:SetFont("AvenirNext-Medium.ttf")
    r.tl:SetColor(0,0,0,255) 
    r.tl:SetHorizontalAlign("JUSTIFY")
    r.tl:SetVerticalAlign("MIDDLE")
    r.tl:SetShadowColor(100,100,100,255)
    r.tl:SetShadowOffset(1,1)
    r.tl:SetShadowBlur(1)
    r:SetWidth(INITSIZE)
    r:SetHeight(INITSIZE)
    
    -- -- anchor
    -- r.fixed = 0
    -- -- AddAnchorIcon(r)
    -- 
    -- -- move controller
    -- r.left_controller = nil
    -- r.right_controller = nil
    -- r.up_controller = nil
    -- r.down_controller = nil
    -- 
    -- -- global text exchange
    -- r.is_text_sender = 0
    -- r.is_text_receiver = 0
    -- r.text_sharee = -1
    -- 
    -- -- stickboundary
    -- r.stickboundary = "none"
end

function HoldToTrigger(self, elapsed) -- for long tap
    x,y = self:Center()
    
    if self.holdtime <= 0 then
        self.x = x 
        self.y = y

				if self.menu == nil then
					OpenRegionMenu(self)
				else
					CloseMenu(self)
				end
        self:Handle("OnUpdate",nil)
    else 
        if math.abs(self.x - x) > 10 or math.abs(self.y - y) > 10 then
            self:Handle("OnUpdate",nil)
            self:Handle("OnUpdate",VUpdate)
        end
				if self.holdtime < MENUHOLDWAIT/2 then
					DPrint("hold for menu")
				end
        self.holdtime = self.holdtime - elapsed
    end
end

function HoldTrigger(self) -- for long tap
    self.holdtime = MENUHOLDWAIT
    self.x,self.y = self:Center()
    self:Handle("OnUpdate",nil)
    self:Handle("OnUpdate",HoldToTrigger)
    self:Handle("OnLeave",DeTrigger)
end

function DeTrigger(self) -- for long tap
    self.eventlist["OnUpdate"].currentevent = nil
    self:Handle("OnUpdate",nil)
    self:Handle("OnUpdate",VUpdate)
end


function VMove(self)
	DPrint("moved")
	-- if self.menu ~= nil then
	-- 	CloseMenu(self)
	-- end
end

function CallEvents(signal,vv)
    local list = {}
    if current_mode == modes[1] then
        list = vv.eventlist[signal]
    else
        list = vv.reventlist[signal]
    end
    for k = 1,#list do
        list[k](vv)
    end
		
		-- fire off messages to linked regions
		list = vv.links[signal]
		if list ~= nil then
			for k = 1,#list do
				list[k][1](list[k][2])
			end
		end
end

function VTouchDown(self)
  CallEvents("OnTouchDown",self)
	-- DPrint("hold for menu")
	self.shadow:MoveToTop()
	self.shadow:SetLayer("LOW")
	self:MoveToTop()
	self:SetLayer("LOW")
	hold_region = true
	local x,y = InputPosition()
	hold_x = x
	hold_y = y
	
	-- bring menu up if they are already open
	if self.menu ~= nil then
		RaiseMenu(self)
	end
end

function VDoubleTap(self)
	DPrint("double tapped")
    CallEvents("OnDoubleTap",self)
end

function VTouchUp(self)
	
	if initialLinkRegion == nil then
		DPrint("")
		hold_region = false
	else
		EndLinkRegion(self)
		initialLinkRegion = nil
	end
  CallEvents("OnTouchUp",self)
end

-- function DrawConnection(x1,y1,x2,y2)
-- 	backdrop.t = backdrop:Texture('gridback.jpg')
-- 	backdrop.t:SetBrushColor(100,255,190,255)
-- 	backdrop.t:SetBrushSize(3)
-- 	backdrop.t:Line(x1, y1, x2, y2)
-- end
	
function AddOneToCounter(self)
	-- DPrint("adding one")
	if self.counter == 1 then
		self.value = self.value + 1
		self.tl:SetLabel(self.value)
	end
end

function SwitchRegionType(self) -- TODO: change method name to reflect
	-- switch from normal region to a counter
	self.t:SetTexture("tw_roundrec_slate.png")
	self.value = 0
	self.counter = 1
  self.tl:SetLabel(self.value)
  self.tl:SetFontHeight(42)
  self.tl:SetColor(255,255,255,255) 
  self.tl:SetHorizontalAlign("JUSTIFY")
  self.tl:SetVerticalAlign("MIDDLE")
  self.tl:SetShadowColor(10,10,10,255)
  self.tl:SetShadowOffset(1,1)
  self.tl:SetShadowBlur(1)
	
	-- TESTING: just for testing counter:
  table.insert(self.eventlist["OnTouchUp"], AddOneToCounter)
	
	CloseMenu(self)
end
	
function StartLinkRegion(self)
	DPrint("Tap another region to link")
	initialLinkRegion = self
end

function EndLinkRegion(self)
	if initialLinkRegion ~= nil then
		DPrint("linked from "..initialLinkRegion:Name().." to "..self:Name())
		-- TODO create the link here!
		table.insert(initialLinkRegion.links["OnTouchUp"], {VTouchUp, self})
		CloseMenu(initialLinkRegion)
		
		initialLinkRegion = nil
	end
end
	
function RemoveV(vv)
    -- Unstick(vv)
    -- 
    -- if vv.text_sharee ~= -1 then
    --     for k,i in pairs(global_text_senders) do
    --         if i == vv.id then
    --             table.remove(global_text_senders,k)
    --         end
    --     end
    --     regions[vv.text_sharee].text_sharee = -1
    -- end
		CloseMenu(vv)
		
    PlainVRegion(vv)
    vv:EnableInput(false)
    vv:EnableMoving(false)
    vv:EnableResizing(false)
    vv:Hide()
    vv.usable = 0
    
    table.insert(recycledregions, vv.id)
    DPrint(vv:Name().." removed")
end

-- function CloseRegion(self)
-- 	DPrint("touched close")
-- end
-- 
-- function LinkRegion(r)
-- 	DPrint("initiating linking")
-- end
-- 
-- function SwitchRegionType(r)
-- 	DPrint("switch type")
-- end

----------------- v11.pagebutton -------------------
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

