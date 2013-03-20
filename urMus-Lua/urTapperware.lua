-- urVen2.lua
-- Version 1
-- By Aaven Jin, July-August 2011
-- Version 2 
-- By Taylor Cronk, July-August 2012
-- University of Michigan Ann Arbor

-- A multipurpose non-programming environment aimed towards giving the user the ability
-- To create a increasingly more complex application without any coding on the users side.
-- The basis of the script is contained in this file while most of the features are contained
-- the accompianing scripts, listed below.


FreeAllRegions()
-- SetPage(38)
regions = {}
recycledregions = {}

function TouchDown(self)    
    local region = CreateorRecycleregion('region', 'backdrop', UIParent)
    local x,y = InputPosition()
    region:Show()
    region:SetAnchor("CENTER",x,y)
    DPrint(region:Name().." created, centered at "..x..", "..y)
end

function TouchUp(self)
    --    DPrint("MU")
	  -- CloseSharedStuff(nil)
	  --   
	  -- local region = CreateorRecycleregion('region', 'backdrop', UIParent)
	  -- local x,y = InputPosition()
	  -- region:Show()
	  -- region:SetAnchor("CENTER",x,y)
	  -- DPrint(region:Name().." created, centered at "..x..", "..y)
end

function CreateorRecycleregion(ftype, name, parent)
    local region
    if #recycledregions > 0 then
        region = regions[recycledregions[#recycledregions]]
        table.remove(recycledregions)
        region:EnableMoving(true)
        region:EnableResizing(true)
        region:EnableInput(true)
        region.usable = 1
    else
        region = VRegion(ftype, name, parent, #regions+1)
        table.insert(regions,region)
    end
    
    region:MoveToTop()
    return region
end

function VRegion(ttype,name,parent,id) -- customized initialization of region
    local r = Region(ttype,"R#"..id,parent)
    r.tl = r:TextLabel()
    r.t = r:Texture()
    
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
    
    return r
end

function PlainVRegion(r) -- customized parameter initialization of region, events are initialized in VRegion()
    r.selected = 0 -- for multiple selection of menubar
    r.kbopen = 0 -- for keyboard isopen
    
    -- initialize for events and signals
    r.eventlist = {}
    r.eventlist["OnTouchDown"] = {HoldTrigger,CloseSharedStuff,SelectObj,AddAnchorIcon}
    r.eventlist["OnTouchUp"] = {AutoCheckStick,DeTrigger} 
    r.eventlist["OnDoubleTap"] = {CloseSharedStuff,OpenOrCloseKeyboard} 
    r.eventlist["OnUpdate"] = {} 
    r.eventlist["OnUpdate"]["selfshowhide"] = 0
    r.eventlist["OnUpdate"]["selfcolor"] = 0
    r.eventlist["OnUpdate"]["move"] = 0
    r.eventlist["OnUpdate"]["animate"] = 0
    r.eventlist["OnUpdate"]["generate"] = 0
    r.eventlist["OnUpdate"]["collision"] = 0
    r.eventlist["OnUpdate"]["background"] = 0
    r.eventlist["OnUpdate"]["projectile"] = 0
    r.eventlist["OnUpdate"]["fps"] = 0
    r.eventlist["OnUpdate"].currentevent = nil
    r.reventlist = {} -- eventlist for release mode
    r.reventlist["OnTouchDown"] = {}
    r.reventlist["OnTouchUp"] = {AutoCheckStick} 
    r.reventlist["OnDoubleTap"] = {OpenOrCloseKeyboard}
    
    -- auto stick
    r.group = r.id
    r.sticker = -1
    r.stickee = {}
    r.large = Region()
    r.large:SetAnchor("CENTER",r,"CENTER")
    
    -- Initialize for generation
    r.gencontrollerL = nil
    r.gencontrollerR = nil
    r.gencontrolle = nil
    r.gencontrollerD = nil
    r[1] = nil
    
    -- initialize for moving
    r.random = 0
    r.speed = tonumber(moving_default_speed)
    r.dir = tonumber(moving_default_dir)
    r.moving = 0
    r.dx = 0
    r.dy = 0
    r.bounceobjects = {}
    r.bounceremoveobjects = {}
    r.bound = boundary
    
    -- Initialize for Collisions
    r.regionregion = {}
    r.regionproj = {}
    r.projregion = {}
    r.projproj = {}
    
    -- Initialize for Background
    r.bgspeed = 0
    r.bgdir = 0
    
    -- initialize texture, label and size
    r.r = 255
    r.g = 255
    r.b = 255
    r.a = 255
    r.bkg = ""
    --initialize gradient
    r.r1 = nil
    r.r2 = nil
    r.r3 = nil
    r.r4 = nil
    r.g1 = nil
    r.g2 = nil
    r.g3 = nil
    r.g4 = nil
    r.b1 = nil
    r.b2 = nil
    r.b3 = nil
    r.b4 = nil
    r.a1 = nil
    r.a2 = nil
    r.a3 = nil
    r.a4 = nil
    r.t:SetTexture(r.r,r.g,r.b,r.a)
    r.tl:SetLabel(r:Name())
    r.tl:SetFontHeight(18)
    r.tl:SetColor(0,0,0,255) 
    r.tl:SetHorizontalAlign("JUSTIFY")
    r.tl:SetVerticalAlign("MIDDLE")
    r.tl:SetShadowColor(255,255,255,255)
    r.tl:SetShadowOffset(1,1)
    r.tl:SetShadowBlur(1)
    r:SetWidth(200)
    r:SetHeight(200)
    
    -- anchor
    r.fixed = 0
    -- AddAnchorIcon(r)
    
    -- move controller
    r.left_controller = nil
    r.right_controller = nil
    r.up_controller = nil
    r.down_controller = nil
    
    -- global text exchange
    r.is_text_sender = 0
    r.is_text_receiver = 0
    r.text_sharee = -1
    
    -- stickboundary
    r.stickboundary = "none"
end


-- DPrint("okok")
backdrop = Region('region', 'backdrop', UIParent)
backdrop:SetWidth(ScreenWidth())
backdrop:SetHeight(ScreenHeight())
--backdrop:SetBlendMode("MOD")
backdrop:SetLayer("BACKGROUND")
backdrop:SetAnchor('BOTTOMLEFT',0,0)
backdrop:Handle("OnTouchDown", TouchDown)
backdrop:Handle("OnTouchUp", TouchUp)
backdrop:Handle("OnDoubleTap", DoubleTap)
backdrop:Handle("OnEnter", Enter)
backdrop:Handle("OnLeave", Leave)
backdrop:Handle("OnMove",nil)
backdrop:EnableInput(true)
backdrop:SetClipRegion(0,0,ScreenWidth(),ScreenHeight())
backdrop:EnableClipping(true)
backdrop.player = {} 

