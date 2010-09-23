-- urWater.lua
-- by Georg Essl 9/15/10

FreeAllRegions()

local pi = math.pi

function rotate(self,x,y,z)
    self.t:SetRotation(-pi*y/2.5)
--    self.t:SetSolidColor(255,255,255,255*(x+1.0)/2.0)
--    self.t:SetGradientColor("HORIZONTAL", 255,255,255,255*(x+1.0)/2.0,255,255,255,255*(x+1.0)/2.0)
end    

function flow(self, elapsed)
    self.t:SetTexCoord(0+self.pos,1+self.pos,0,1)
    self.pos = self.pos +self.speed % 1
end

r = {}
for i =1,4 do
    r[i] = Region()
    r[i]:SetWidth(ScreenHeight()*1.35)
    r[i]:SetHeight(ScreenHeight()*1.35)
--    r[i]:SetWidth(ScreenHeight()*1.35)
--    r[i]:SetHeight(ScreenHeight()*1.35)
    r[i]:SetAnchor("CENTER",UIParent,"CENTER",0,0)
    r[i].t = r[i]:Texture()
--    r[i].t:SetTexture(DocumentPath("wavel2"..i..".png"))
    r[i].t:SetTexture(DocumentPath("wavel2"..i..".png"))
    r[i].t:SetSolidColor(255,255,255,255)
    r[i]:Handle("OnAccelerate",rotate)
    r[i]:Show()
    r[i].t:SetBlendMode("BLEND")
    r[i].t:SetTiling(true)
    r[i].speed = 0.01/i
    r[i].pos = 0
    r[i]:Handle("OnUpdate", flow)
end
