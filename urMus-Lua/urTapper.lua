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
INITSIZE = 140	-- initial size for regions
MENUHOLDWAIT = 0.5 -- seconds to wait for hold to menu

FADEINTIME = .2 -- seconds for things to fade in, TESTING for now
EPSILON = 0.001	--small number for rounding

FreeAllRegions()
showMenu = false

dofile(SystemPath("urTapperMenu.lua"))
-- ============
-- = Backdrop =
-- ============

function TouchDown(self)
end
	
function TouchUp(self)
	local x,y = InputPosition()	

	if showMenu == true then
		menu:dismiss()
		showMenu = false
		return
	end
	
	if x>CREATION_MARGIN and x<ScreenWidth()-CREATION_MARGIN and 
		y>CREATION_MARGIN and y<ScreenHeight()-CREATION_MARGIN then
		
		cmdlist = {{'ok',test,'hello this is ok'},
					{'yes',test,'yes very good'},
					{'no',test,'not in the least'},
					{'cancel',dismissMenu,nil}}
		menu = loadSimpleMenu(cmdlist, 'Choose something like a star')
		menu:present(x,y)
		showMenu = true
	end
end

function test(message) 
	DPrint(message)
end

function dismissMenu()
	menu:dismiss()
	showMenu = false
end

function Move(self)
	-- menu:dismiss()
end

function Leave(self)
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
-- backdrop.t = backdrop:Texture("tw_gridback.jpg")
backdrop.t = backdrop:Texture("tw_paperback.jpg")
backdrop.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
backdrop.t:SetBlendMode("BLEND")
backdrop:Show()



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

