-- urAlignTest
-- Created by: Georg Essl 10/30/12

function CreateTextOnlyRegion(x,y,w,h,text)
    local r = Region()
    r:SetWidth(w)
    r:SetHeight(h)
    r.tl = r:TextLabel()
    r.tl:SetLabel(text)
    r:SetAnchor("BOTTOMLEFT",x,y)
    r:Show()
    return r
end

function CreateTextRegion(x,y,w,h,text)
    r = CreateTextOnlyRegion(x,y,w,h,text)
	r.t = r:Texture(63,80,63,63)
    r.t:SetBrushColor(255,0,0,255)
    r.t:Line(0,h/2,w,h/2)
    r.t:SetBrushColor(0,0,255,255)
    r.t:Line(w/2,0,w/2,h)
    return r
end



function rotate(self,elapsed)
	self.angle = self.angle + self.speed*elapsed
	self.tl:SetRotation(self.angle)
end

r1 = CreateTextRegion(0,0,256,256,"Testo1 pgj")
r1.tl:SetFontHeight(16)
r1a = CreateTextOnlyRegion(0,0,256,256,"BL")
r1a.tl:SetVerticalAlign("BOTTOM")
r1a.tl:SetHorizontalAlign("LEFT")
r1b = CreateTextOnlyRegion(0,0,256,256,"BC")
r1b.tl:SetVerticalAlign("BOTTOM")
r1b.tl:SetHorizontalAlign("CENTER")
r1c = CreateTextOnlyRegion(0,0,256,256,"BR")
r1c.tl:SetVerticalAlign("BOTTOM")
r1c.tl:SetHorizontalAlign("RIGHT")
r1d = CreateTextOnlyRegion(0,0,256,256,"ML")
r1d.tl:SetVerticalAlign("MIDDLE")
r1d.tl:SetHorizontalAlign("LEFT")
r1e = CreateTextOnlyRegion(0,0,256,256,"MR")
r1e.tl:SetVerticalAlign("MIDDLE")
r1e.tl:SetHorizontalAlign("RIGHT")
r1f = CreateTextOnlyRegion(0,0,256,256,"TL")
r1f.tl:SetVerticalAlign("TOP")
r1f.tl:SetHorizontalAlign("LEFT")
r1g = CreateTextOnlyRegion(0,0,256,256,"TC")
r1g.tl:SetVerticalAlign("TOP")
r1g.tl:SetHorizontalAlign("CENTER")
r1h = CreateTextOnlyRegion(0,0,256,256,"TR")
r1h.tl:SetVerticalAlign("TOP")
r1h.tl:SetHorizontalAlign("RIGHT")
r2 = CreateTextRegion(257,0,256,256,"Testo2 pgj\nLine2 pgj")
r2.tl:SetFontHeight(18)
r3 = CreateTextRegion(0,257,256,256,"Testo3 pgj\nLine2 pgj\nLine3 pgj")
r3.tl:SetFontHeight(22)
r4 = CreateTextRegion(257,257,256,256,"Testo4 pgj")
r4.tl:SetFontHeight(26)
r4.angle = 0
r4.speed = 15
r4:Handle("OnUpdate",rotate)
r5 = CreateTextRegion(0,514,256,256,"Testo5 pgj")
r5.tl:SetVerticalAlign("TOP")
r5.tl:SetFontHeight(20)
r5.angle = 0
r5.speed = 15
r5:Handle("OnUpdate",rotate)
r6 = CreateTextRegion(257,514,256,256,"Testo6 pgj")
r6.tl:SetHorizontalAlign("LEFT")
r6.tl:SetFontHeight(24)
r6.angle = 0
r6.speed = 15
r6:Handle("OnUpdate",rotate)



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
