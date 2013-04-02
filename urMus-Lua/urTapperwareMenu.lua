------------- menu functions --------------
-- called by menu option, named starting with Menu-
-- arguments (opt,vv): opt is menu option region, vv is the region that functions should be implemented on

-- ============================
-- = Menus, contextual mostly =
-- ============================
-- we need region specific menu for hooking up signals(sender and receiver), and then creation menu

function_list = {}

function_list = {{"Close",CloseRegion,{}},
        {"Link",LinkRegion,{}},
        {"SwitchType",SwitchRegionType,{}}
}

local regionMenu = {}
regionMenu.parentRegion = {}
deleteButton = Region('region','menu',UIParent)
deleteButton.t = deleteButton:Texture("tw_closebox.png")
deleteButton:SetHeight(40)
deleteButton:SetWidth(40)
deleteButton.t:SetBlendMode("BLEND")
regionMenu.deleteButton = deleteButton
-- regionMenu.menus = function_list -- TODO: add the list here
-- regionMenu.v = nil -- caller v
-- regionMenu.openmenu = -1
-- regionMenu.show = 0
-- regionMenu.selectedregions = {}
-- 
-- for k,name in pairs (regionMenu.menus) do
--     local r = Region('region','menu',UIParent)
--     r.tl = r:TextLabel()
--     r.tl:SetLabel(regionMenu.menus[k][1])
--     r.tl:SetFontHeight(18)
-- 		-- r.tl:SetFont("Avenir")
--     r.tl:SetColor(0,0,0,255) 
--     r.tl:SetHorizontalAlign("JUSTIFY")
--     r.tl:SetShadowColor(255,255,255,255)
--     r.tl:SetShadowOffset(1,1)
--     r.tl:SetShadowBlur(1)
--     r.t = r:Texture(250,250,250,255)
--     r.k = k
--     r.boss = regionMenu
--     r.menu = Menu.Create(r,"",regionMenu.menus[k][2],"BOTTOMLEFT","TOPLEFT")
--     r:SetWidth((ScreenWidth()-2*HEIGHT_LINE)/#regionMenu.menus)
--     r:SetHeight(HEIGHT_LINE)
--     r:EnableInput(false)
--     r:EnableMoving(false)
--     r:EnableResizing(false)
--     r:Handle("OnTouchDown",OpenOrCloseMenubarItemEvent)
--     regionMenu[k] = r
-- end

-- regionMenu:SetAnchor("BOTTOMLEFT",UIParent,"BOTTOMLEFT")
-- for i=2,#regionMenu do
--     regionMenu[i]:SetAnchor("LEFT",regionMenu[i-1],"RIGHT")
--     regionMenu[i]:Hide()
-- end
regionMenu.deleteButton:SetAnchor("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
-- regionMenu.deleteButton:Hide()
-- regionMenu:Hide()



function OpenMenu(self)
    if regionMenu.show == 0 then
        for i = 1,#regionMenu do
            regionMenu[i]:Show()
            regionMenu[i]:EnableInput(true)
            regionMenu[i]:MoveToTop()
        end
        regionMenu.v = self
        
        while #regionMenu.selectedregions > 0 do
            regions[regionMenu.selectedregions[1]].selected = 0
            table.remove(regionMenu.selectedregions,1)
        end
        table.insert(regionMenu.selectedregions,self.id)
        self.selected = 1
        regionMenu.show = 1
        CloseColorWheel(color_wheel)
        mykb:Hide()
        backdrop:SetClipRegion(0,HEIGHT_LINE,ScreenWidth(),ScreenHeight())
        hold_button:Show()
        hold_button:MoveToTop()
        hold_button:EnableInput(true)
    end
end

function CloseMenuBar(self)
    if regionMenu.openmenu ~= -1 then
        regionMenu[regionMenu.openmenu].menu:CloseMenu()
        regionMenu.openmenu = -1 
    end
    CloseMenubarHelper()
    regionMenu.v = nil
    hold_button:Hide()
    hold_button:EnableInput(false)
end



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
    CloseMenuBar()
end

function menuGradient(opt,vv)
    OpenGradDialog(vv,pics)
    UnHighlight(opt)
    CloseMenuBar()
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
    CloseMenuBar()
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
    CloseMenuBar()
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
    CloseMenuBar()
end
