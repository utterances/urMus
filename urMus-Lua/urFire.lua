-- urFire.lua
-- by Georg Essl 9/28/10

FreeAllRegions()

--damping = 0.9
--size = 48
--amount = 50
--active = 20
--mode = 0
--speed = 0.8
local threshold = 0.02*10
local visout = 0.0
local orientation

local small
if ScreenWidth() < 400 then
	small = 0.5
	orientation = 1
else
	small = 1
	orientation = -1
end

function UpdateFire1(self)
	if self.alpha > 1 then
		self.angle = self.angle + self.rotspeed
		self.t:SetRotation(self.angle)
		self:SetWidth(self:Width()*self.growspeed)
		self:SetHeight(self:Height()*self.growspeed)
		self.alpha = self.alpha + self.alphaspeed
		self.t:SetGradientColor("HORIZONTAL", 255,255,255,self.alpha,255,255,255,self.alpha)
	else
		self:Handle("OnUpdate",nil)
		self:Hide()
	end
end

r={}
local maxfire = 10

function AddFire(i)
	local f1
	f1 = Region()
	f1.t = f1:Texture()
	f1.t:SetTexture("fire1.png")
    f1:SetWidth(64*small)
    f1:SetHeight(64*small)
    f1.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f1.t:SetBlendMode("BLEND")
	f1.angle = 0
	f1.growspeed = 1.25
	f1.rotspeed = 0.25
	f1.alpha = 128
	f1.alphaspeed = -2.5
	f1.type = 1

	local f2
	f2 = Region()
	f2.t = f2:Texture()
	f2.t:SetTexture("fire2.png")
    f2:SetWidth(64*small)
    f2:SetHeight(64*small)
    f2.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f2.t:SetBlendMode("BLEND")
	f2.angle = 0
	f2.growspeed = 1.15
	f2.rotspeed = 0.025
	f2.alpha = 128
	f2.alphaspeed = -2.5
	f2.type = 2
	
--	local i = #r
	f1.i = i
	f2.i = i
	r[i] = {}
    r[i].f1 = f1
	r[i].f2 = f2
end



for i=1,maxfire do
	AddFire(i)
end

currfire = 1

function SpawnFire(self)
	local x,y = InputPosition()
	
	local f1 = r[currfire].f1
	
    f1:SetWidth(64*small)
    f1:SetHeight(64*small)
    f1:SetAnchor("CENTER",UIParent,"BOTTOMLEFT",x,y)
    f1.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f1:Show()
	f1.angle = 0
	f1.alpha = 128
    f1:Handle("OnUpdate",UpdateFire1)

	local f2 = r[currfire].f2

    f2:SetWidth(64*small)
    f2:SetHeight(64*small)
    f2:SetAnchor("CENTER",UIParent,"BOTTOMLEFT",x,y)
    f2.t:SetGradientColor("HORIZONTAL", 255,255,255,128,255,255,255,128)
    f2:Show()
	f2.angle = 0
	f2.alpha = 128
    f2:Handle("OnUpdate",UpdateFire1)
	
	currfire = currfire + 1
	if currfire > maxfire then
		currfire = 1
	end
end

rb = Region()
rb.t = rb:Texture()
rb:SetWidth(ScreenWidth())
rb:SetHeight(ScreenHeight())
--rb.t:SetTexture(DocumentPath("smoke0.png"))
rb.t:SetTexture("smoke0.png")
rb.t:SetGradientColor("HORIZONTAL", 255,0,0,60,255,0,0,60)
rb.t:SetBlendMode("BLEND")
rb:Handle("OnTouchDown",SpawnFire)
rb:EnableInput(true)
rb:Show()

DPrint(" ")