-- ================
-- = Visual Links between regions=
-- ================

-- methods and appearances

-- link.r = Region('region', 'backdrop', UIParent)
-- link.r:SetWidth(ScreenWidth())
-- link.r:SetHeight(ScreenHeight())
-- link.r:SetLayer("TOOLTIP")
-- link.r:SetAnchor('BOTTOMLEFT',0,0)
-- link.r.t = link.r:Texture()
-- link.r.t:Clear(0,0,0,0)
-- link.r.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
-- link.r.t:SetBlendMode("BLEND")
-- 
-- link.r.t:SetBrushColor(255,100,100,255)
-- link.r.t:SetBrushSize(2)
-- 
-- link.r.t:Ellipse(ScreenWidth()/3, ScreenHeight()/2, 200, 200)
-- 
-- link.r:MoveToTop()
-- link.r:Show()

link = {}
link.list = {}

function link.init()
	link.r = Region('region', 'backdrop', UIParent)
	link.r:SetWidth(ScreenWidth())
	link.r:SetHeight(ScreenHeight())
	link.r:SetLayer("TOOLTIP")
	link.r:SetAnchor('BOTTOMLEFT',0,0)
	link.r.t = link.r:Texture()
	link.r.t:Clear(0,0,0,0)
	link.r.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
	link.r.t:SetBlendMode("BLEND")
	
	link.r.t:SetBrushColor(255,100,100,255)
	link.r.t:SetBrushSize(2)
	
	link.r.t:Ellipse(ScreenWidth()/3, ScreenHeight()/2, 200, 200)
	
	link.r:MoveToTop()
	link.r:Show()
end

function link.add(r1, r2)
	table.insert(link.list, {r1, r2})
end

function link.draw()
end
