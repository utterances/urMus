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

FADEINTIME = .2 -- seconds for things to fade in, TESTING for now
EPSILON = 0.001	--small number for rounding

-- selection param
LASSOSEPDISTANCE = 30 -- pixels between each point when drawing seleciton lasso

regions = {}
recycledregions = {}
initialLinkRegion = nil
startedSelection = false
-- touch event state machine:
-- isHoldingRegion = false
heldRegions = {}
-- selection data structs
selectionPoly = {}

FreeAllRegions()

modes = {"EDIT","RELEASE"}
current_mode = modes[1]
dofile(SystemPath("urTapperwareTools.lua"))
dofile(SystemPath("urTapperwareMenu.lua"))	-- first!
dofile(SystemPath("urTapperwareLink.lua"))	-- needs menu

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
	-- DPrint("")
 	-- DPrint("MU")
  -- CloseSharedStuff(nil)
  if startedSelection then
		startedSelection = false
		selectionPoly = {}
		return
	end
	
	-- only create if we are not too close to the edge
  local x,y = InputPosition()
	
	-- if isHoldingRegion then
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
	
	startedSelection = false
end

function Move(self)
	startedSelection = true
	shadow:Hide()
	-- change creation behavior to selection box/lasso
	local x,y = InputPosition()
	if #selectionPoly > 0 then
		last = selectionPoly[#selectionPoly]
		if math.sqrt((x - last[1])^2 + (y - last[2])^2) > LASSOSEPDISTANCE then
			--more than the lasso point distance, add a new point to selection poly
			table.insert(selectionPoly, {x,y})
			selectionLayer:DrawSelectionPoly()
		end
	else
		table.insert(selectionPoly, {x,y})
		selectionLayer:DrawSelectionPoly()
	end
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
backdrop.t = backdrop:Texture("tw_gridback.jpg")
backdrop.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
backdrop.t:SetBlendMode("BLEND")
backdrop:Show()

-- set up shadow for when tap down and hold, show future region creation location
shadow = Region('region', 'shadow', UIParent)
shadow:SetLayer("BACKGROUND")
shadow.t = shadow:Texture("tw_roundrec_create.png")
shadow.t:SetBlendMode("BLEND")

-- set up layer for drawing selection boxes or lasso:
selectionLayer = Region('region', 'selection', UIParent)
selectionLayer:SetLayer("BACKGROUND")
selectionLayer:SetWidth(ScreenWidth())
selectionLayer:SetWidth(ScreenWidth())
selectionLayer:SetHeight(ScreenHeight())
selectionLayer:SetAnchor('BOTTOMLEFT',0,0)
selectionLayer:EnableInput(false)
selectionLayer.t = selectionLayer:Texture()
selectionLayer.t:Clear(0,0,0,0)
selectionLayer.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
selectionLayer.t:SetBlendMode("BLEND")
selectionLayer:Show()

function selectionLayer:DrawSelectionPoly()
	if #selectionPoly < 2 then	-- need at least two points to draw
		return
	end
	
	self.t:Clear(0,0,0,0)
	self.t:SetBrushColor(255,255,255,200)
	self.t:SetBrushSize(3)

	local lastPoint = selectionPoly[#selectionPoly]
	for i = 2,#selectionPoly do
		self.t:Line(lastPoint[1], lastPoint[2],
													selectionPoly[i][1], selectionPoly[i][2])
		lastPoint = selectionPoly[i]
	end
	
	-- also draw boxes around *selected* regions
	
	for i = 1, #regions do
		x,y = regions[i]:Center()
		if pointInSelectionPolygon(x,y) then
			self.t:SetBrushColor(255,100,100,200)
			self.t:Rect(x,y,200,200)
		end
	end
end

function pointInSelectionPolygon(x, y)
	-- find if a point is in our selection
	-- adapted from C code: http://alienryderflex.com/polygon/
	-- simple ray casting algo
	oddNodes = false
	j=#selectionPoly

  for i=1, #selectionPoly do		
		if ((selectionPoly[i][2] < y and selectionPoly[j][2] >=y
		    or   selectionPoly[j][2]< y and selectionPoly[i][2]>=y)
		    and  (selectionPoly[i][1]<=x or selectionPoly[j][1]<=x)) then
			
      if (selectionPoly[i][1]+(y-selectionPoly[i][2])
					/(selectionPoly[j][2]-selectionPoly[i][2])
					*(selectionPoly[j][1]-selectionPoly[i][1])<x) then
      	oddNodes = not oddNodes
			end
		end
    j=i
	end
	return oddNodes
end

-- link action icon, shows briefly when a link is made
linkIcon = Region('region', 'linkicon', UIParent)
linkIcon:SetLayer("TOOLTIP")
linkIcon.t = linkIcon:Texture("tw_link.png")
linkIcon.t:SetBlendMode("BLEND")
linkIcon.t:SetTexCoord(0,160/256,160/256,0)
linkIcon:SetWidth(100)
linkIcon:SetHeight(100)
linkIcon:SetAnchor('CENTER',ScreenWidth()/2,ScreenHeight()/2)
-- linkIcon:Handle(OnUpdate, IconUpdate)


function linkIcon:ShowLinked(x,y)
	self:Show()
	self:SetAlpha(1)
	self:MoveToTop()
	self:Handle("OnUpdate", IconUpdate)
end

function IconUpdate(self, e)
	if self:Alpha() > 0 then
		self:SetAlpha(self:Alpha() - self:Alpha() * e/.7)
	else
		self:Hide()
		self:Handle("OnUpdate", nil)
	end
end

linkLayer:Init()

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
        region.usable = true
				region.t:SetTexture("tw_roundrec.png")	-- reset texture
    else
        region = VRegion(ftype, name, parent, #regions+1)
        table.insert(regions,region)
    end
    region:SetAlpha(0)
		region.shadow:SetAlpha(0)
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
  r.usable = true
  r.id = id
  PlainVRegion(r)
  
  r:EnableMoving(true)
  r:EnableResizing(true)
  r:EnableInput(true)
  
  r:Handle("OnDoubleTap",VDoubleTap)
  r:Handle("OnTouchDown",VTouchDown)
  r:Handle("OnTouchUp",VTouchUp)
  r:Handle("OnDragStop",VDrag)
	r:Handle("OnUpdate",VUpdate)
  -- r:Handle("OnMove",VDrag)
	
  return r
end

function PlainVRegion(r) -- customized parameter initialization of region, events are initialized in VRegion()
    -- r.selected = 0 -- for multiple selection of menubar
		r.alpha = 1	--target alpha for animation
		r.menu = nil	--contextual menu
		r.counter = 0	--if this is a counter
		r.isHeld = false -- if the r is held by tap currently

		r.dx = 0	-- compute storing current movement speed, for gesture detection
		r.dy = 0
		x,y = r:Center()
		r.oldx = x
		r.oldy = y
		
		-- event handling
		r.links = {}
    r.links["OnTouchDown"] = {}
		r.links["OnTouchUp"] = {}
    r.links["OnDoubleTap"] = {} --{CloseSharedStuff,OpenOrCloseKeyboard} 
		
    -- -- initialize for events and signals
    r.eventlist = {}
    r.eventlist["OnTouchDown"] = {HoldTrigger}
    r.eventlist["OnTouchUp"] = {DeTrigger} 
    r.eventlist["OnDoubleTap"] = {} --{CloseSharedStuff,OpenOrCloseKeyboard} 
    r.eventlist["OnUpdate"] = {} 
    r.eventlist["OnUpdate"].currentevent = nil

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
	self.alpha = .4
	-- isHoldingRegion = true
	table.insert(heldRegions, self)
	
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
	self.alpha = 1
	if initialLinkRegion == nil then
		DPrint("")
		-- see if we can make links here, check how many regions are held
		if #heldRegions >= 2 then
			-- by default let's just link self and the first one that's different
			for i = 1, #heldRegions do
				if heldRegions[i] ~= self and RegionOverLap(self, heldRegions[i]) then
					initialLinkRegion = self
					EndLinkRegion(heldRegions[i])
					initialLinkRegion = nil
					break
				end
			end
			
		end
		
		tableRemoveObj(heldRegions, self)
		
		-- isHoldingRegion = false
	else
		EndLinkRegion(self)
		initialLinkRegion = nil
	end
  CallEvents("OnTouchUp",self)
end

function VLeave(self)
	DPrint("left")
	
end

function VDrag(self)
	-- DPrint("moved")
	-- if self.menu ~= nil then
	-- 	CloseMenu(self)
	-- end
	-- linkLayer:Draw()
end
	
function VUpdate(self,elapsed)
	-- DPrint(elapsed)
	if self:Alpha() ~= self.alpha then
		if math.abs(self:Alpha() - self.alpha) < EPSILON then	-- just set if it's close enough
			self:SetAlpha(self.alpha)
		else
			self:SetAlpha(self:Alpha() + (self.alpha-self:Alpha()) * elapsed/FADEINTIME)
		end
		self.shadow:SetAlpha(self:Alpha())
	end
	
	-- TODO save cycle by checking if we moved or not, redraw only if it's moved
	linkLayer:Draw()
end

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
	
function StartLinkRegion(self, draglet)
	initialLinkRegion = self
	
	if draglet ~= nil then
		-- if we have drag target, try creating a link right away
		tx, ty = draglet:Center()
		for i = 1, #regions do
			if regions[i] ~= self and regions[i].usable == true then
				rx, ry = regions[i]:Center()
				if math.abs(tx-rx) < INITSIZE and math.abs(ty-ry) < INITSIZE then
					-- found a match, create a link here
					EndLinkRegion(regions[i])
					initialLinkRegion = nil
					return
				end
			end
		end
		CloseMenu(self)
		OpenRegionMenu(self)
	else
		-- otherwise ask for a target
		DPrint("Tap another region to link")
	end
end

function EndLinkRegion(self)
	if initialLinkRegion ~= nil then
		-- DPrint("linked from "..initialLinkRegion:Name().." to "..self:Name())
		-- TODO create the link here!

		table.insert(initialLinkRegion.links["OnTouchUp"], {VTouchUp, self})
		
		-- add visual link too:
		linkLayer:Add(initialLinkRegion, self)
		linkLayer:ResetPotentialLink()
		linkLayer:Draw()
		-- add notification
		linkIcon:ShowLinked()		
		
		CloseMenu(initialLinkRegion)
		initialLinkRegion = nil
		
	end
end

function RemoveLinkBetween(r1, r2)
	linkLayer:Remove(r1, r2)
	linkLayer:Draw()
	
	for i,v in ipairs(r1.links["OnTouchUp"]) do
		if v[2] == r2 then
			table.remove(r1.links["OnTouchUp"], i)
		end
	end
end
	

function RemoveV(vv)
		CloseMenu(vv)
		
    PlainVRegion(vv)
    vv:EnableInput(false)
    vv:EnableMoving(false)
    vv:EnableResizing(false)
    vv:Hide()
    vv.usable = false
    
    table.insert(recycledregions, vv.id)
    DPrint(vv:Name().." removed")
end

function DuplicateRegion(vv, cx, cy)
	x,y = vv:Center()
	local copyRegion = CreateorRecycleregion('region', 'backdrop', UIParent)
	copyRegion:Show()
	if cx ~= nil then
		copyRegion:SetAnchor("CENTER", cx, cy)
	else
		copyRegion:SetAnchor("CENTER",x+INITSIZE+20,y)
	end		
	copyRegion.counter = vv.counter
	copyRegion.links = vv.links
		
	list = copyRegion.links["OnTouchUp"]
	if list ~= nil then
		for k = 1,#list do
			linkLayer:Add(copyRegion, list[k][2])
		end
	end
	
	-- TODO: optimize this part: right now it's a messy search for every inbound links
	for i = 1, #regions do
		if regions[i] ~= vv or regions[i] ~= copyRegion then
			
			linkList = regions[i].links["OnTouchUp"]
			if linkList ~= nil then
				
				for k = 1,#linkList do
					if linkList[k][2] == vv then
						table.insert(linkList, {VTouchUp, copyRegion})
						linkLayer:Add(regions[i], copyRegion)
					end
				end
			end			
		end
	end
	
	if copyRegion.counter == 1 then
		SwitchRegionType(copyRegion)
		copyRegion.value = vv.value
	  copyRegion.tl:SetLabel(copyRegion.value)
	end
	
	linkLayer:Draw()
	
-- 	TODO: make this a common function to raise region to top
	copyRegion.shadow:MoveToTop()
	copyRegion.shadow:SetLayer("LOW")
	copyRegion:MoveToTop()
	copyRegion:SetLayer("LOW")
	
	CloseMenu(vv)
	OpenRegionMenu(vv)
end

function ShowPotentialLink(region, draglet)
	linkLayer:DrawPotentialLink(region, draglet)
end

function RegionOverLap(r1, r2)
	x1,y1 = r1:Center()
	x2,y2 = r2:Center()
	return (r1:Width() + r2:Width())/1.8 > math.abs(x1-x2) and 
				(r1:Height() + r2:Height())/1.8 > math.abs(y1-y2)
end

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

