-- Using the camera as a brush example. Adapted from urPaint and urCameraDemo.
-- A preview of the video is locked in the bottom left of the screen while
--    dragging elsewhere uses the camera texture as a brush.

-- Pat O'Keefe - 3/23/11

FreeAllRegions()

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
region.t = region:Texture("Ornament1.png")
region.t:SetBlendMode("BLEND")
region.t:SetTiling()
end
return region
end

local pi = math.pi

function TextureCol(t,r,g,b,a)
t:SetGradientColor("TOP",r,g,b,a,r,g,b,a)
t:SetGradientColor("BOTTOM",r,g,b,a,r,g,b,a)
end

local random = math.random

function CreateRegionAt(x,y)
local region = CreateorRecycleregion('region', 'backdrop', UIParent)
TextureCol(region.t,255,255,255,255)
region.t:UseCamera()
region.t:SetRotation(-pi/2)
region:Show()
--region:EnableMoving(true)
--region:EnableResizing(true)
region:EnableInput(true)
region:Handle("OnDoubleTap", RecycleSelf)
region:Handle("OnUpdate", GatherVis)
region.t:SetTiling()

--region.t:SetRotation(random()*2.0*pi)
region:SetAnchor("CENTER",x,y)
table.insert(regions, region)
end



function Paint(self,x,y,dx,dy,n)
brush1.t:SetBrushSize(64)
-- The rotation of -pi/2 is necessary to get a righ-side-up camera texture
brush1.t:SetRotation(-pi/2)
self.texture:SetBrushColor(255,255,255,255)
self.texture:Line(x, y, x+dx, y+dy)
fingerposx, fingerposy = fingerposx+dx,fingerposy+dy
end

function BrushDown(self,x,y)
fingerposx, fingerposy = x, y
self:Handle("OnMove", Paint)
end

function BrushUp(self)
self:Handle("OnMove", nil)
end

function Clear(self)
smudgebackdropregion.texture:Clear(255,255,255,0)
end

smudgebackdropregion=Region('region', 'smudgebackdropregion', UIParent)
smudgebackdropregion:SetWidth(ScreenWidth())
smudgebackdropregion:SetHeight(ScreenHeight())
smudgebackdropregion:SetLayer("BACKGROUND")
smudgebackdropregion:SetAnchor('BOTTOMLEFT',0,0)
smudgebackdropregion.texture = smudgebackdropregion:Texture()
smudgebackdropregion.texture:SetTexture(255,255,255,255)
if ScreenWidth() == 320.0 then
smudgebackdropregion.texture:SetTexCoord(0,320.0/512.0,480.0/512.0,0.0)
else
smudgebackdropregion.texture:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
end

smudgebackdropregion:Handle("OnDoubleTap", Clear)
smudgebackdropregion:Handle("OnTouchDown", BrushDown)
smudgebackdropregion:Handle("OnTouchUp", BrushUp)
smudgebackdropregion:EnableInput(true)
smudgebackdropregion:Show()

dummp = Region()
dummp.t = dummp:Texture()
dummp.t:UseCamera()
dummp:Show()
dummp:SetAnchor("BOTTOMLEFT",-dummp:Width(),0)

CreateRegionAt(ScreenWidth()/4,ScreenWidth()/4)
CreateRegionAt(ScreenWidth()/2,ScreenWidth()/4)
CreateRegionAt(ScreenWidth(),ScreenWidth()/4)

brush1=Region('region','brush',UIParent)
brush1.t=brush1:Texture()
brush1.t:SetTiling()
brush1.t:UseCamera()
brush1:UseAsBrush()


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
