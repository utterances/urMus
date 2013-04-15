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
	link.r:EnableInput(false)
	link.r:EnableMoving(false)
	
	link.r:MoveToTop()
	link.r:Show()
	DPrint("link init")
end

function link.add(r1, r2)
	table.insert(link.list, {r1, r2})
	DPrint("linked from "..r1:Name().." to "..r2:Name())
	
end

function link.draw()
	link.r.t:Clear(0,0,0,0)
	link.r.t:SetBrushColor(100,255,240,255)
	link.r.t:SetBrushSize(4)
	
	for _, linkPair in ipair(link.list) do
		-- X1, Y1 = linkPair[1]:Center()
		-- X2, Y2 = linkPair[2]:Center()
		-- link.r.t:Line(X1,Y1,X2,Y2)
	end

end
