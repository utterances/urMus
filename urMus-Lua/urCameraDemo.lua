-- A quick demo to show off what the camera as texture can do.
-- Hacked by Georg Essl
-- Created: 1/18/2011

local regions = {}

recycledregions = {}

function RecycleSelf(self)
	self:EnableInput(false)
	self:EnableMoving(false)
	self:EnableResizing(false)
	self:Hide()
	table.insert(recycledregions, self)
	for k,v in pairs(regions) do
		if v == self then
			table.remove(regions,k)
		end
	end
end

function CreateorRecycleregion(ftype, name, parent)
	local region
	if #recycledregions > 0 then
		region = recycledregions[#recycledregions]
		table.remove(recycledregions)
	else
		region = Region()
--		region = Region('region', 'backdrop', UIParent)
		region.t = region:Texture("Ornament1.png")
		region.t:SetBlendMode("BLEND")
		region.t:SetTiling()
	end
	return region
end

local pi = math.pi

function RotateTexture(self,x,y,z,north)
--	self.t:SetRotation(pi*north)
end

function TextureCol(t,r,g,b,a)
	t:SetGradientColor("TOP",r,g,b,a,r,g,b,a)
	t:SetGradientColor("BOTTOM",r,g,b,a,r,g,b,a)
end

local random = math.random

function TouchDown(self)
	local region = CreateorRecycleregion('region', 'backdrop', UIParent)
	TextureCol(region.t,255,255,255,255)
	region.t:UseCamera()
--    local r =  .7071
--	local angle = pi/2
--  local x = r*math.sin(angle+pi/4)
--    local y = r*math.cos(angle+pi/4)
--    region.t:SetTexCoord(.5-x,.5+y, .5+y,.5+x, .5-y,.5-x, .5+x,.5-y)
	region.t:SetRotation(-pi/2)
	region:Show()
	region:EnableMoving(true)
	region:EnableResizing(true)
	region:EnableInput(true)
	region:Handle("OnDoubleTap", RecycleSelf)
	region:Handle("OnUpdate", GatherVis)
	region.t:SetTiling()
	local x,y = InputPosition()
	region:SetAnchor("CENTER",x,y)
	table.insert(regions, region)
end

local backdrop = Region()
backdrop:SetWidth(ScreenWidth())
backdrop:SetHeight(ScreenHeight())
backdrop:SetLayer("BACKGROUND")
backdrop:SetAnchor('BOTTOMLEFT',0,0)
backdrop:Handle("OnTouchDown", TouchDown)
backdrop:EnableInput(true)

local pagebutton=Region()
--local pagebutton=Region('region', 'pagebutton', UIParent)
pagebutton:SetWidth(pagersize)
pagebutton:SetHeight(pagersize)
pagebutton:SetLayer("TOOLTIP")
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4) 
pagebutton:EnableClamping(true)
--pagebutton:Handle("OnDoubleTap", FlipPage)
pagebutton:Handle("OnTouchDown", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png")
pagebutton.texture:SetGradientColor("TOP",255,255,255,255,255,255,255,255)
pagebutton.texture:SetGradientColor("BOTTOM",255,255,255,255,255,255,255,255)
pagebutton.texture:SetBlendMode("BLEND")
pagebutton.texture:SetTexCoord(0,1.0,0,1.0)
pagebutton:EnableInput(true)
pagebutton:Show()
--pagebutton:Handle("OnPageEntered", nil)

