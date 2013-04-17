-- ================
-- = Visual Links between regions=
-- ================

-- methods and appearances

-- assumes urTapperwareMenu.lua is already processed

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

function link:Init()
	self.r = Region('region', 'backdrop', UIParent)
	self.r:SetWidth(ScreenWidth())
	self.r:SetHeight(ScreenHeight())
	self.r:SetLayer("TOOLTIP")
	self.r:SetAnchor('BOTTOMLEFT',0,0)
	self.r.t = self.r:Texture()
	self.r.t:Clear(0,0,0,0)
	self.r.t:SetTexCoord(0,ScreenWidth()/1024.0,1.0,0.0)
	self.r.t:SetBlendMode("BLEND")
	self.r.t:SetBrushColor(255,100,100,255)
	self.r.t:SetBrushSize(2)
	-- REMOVE later:
	self.r.t:Ellipse(ScreenWidth()/3, ScreenHeight()/2, 200, 200)
	self.r:EnableInput(false)
	self.r:EnableMoving(false)
	
	self.r:MoveToTop()
	self.r:Show()
	-- DPrint("link init")
end

-- add links to our list
function link:Add(r1, r2)
	if self.list[r1] == nil then
		self.list[r1] = {r2}
	else
		table.insert(self.list[r1], r2)
	end
end

-- remove links
function link:Remove(r1, r2)
	if self.list[r1] ~= nil then
		
		for i = 1, #self.list[r1] do
			if self.list[r1][i] == r2 then
				table.remove(	self.list[r1], i)
			end
		end
	end
end

-- draw a line between linked regions, also draws menu
function link:Draw()	
	self.r.t:Clear(0,0,0,0)
	self.r.t:SetBrushColor(100,255,240,200)
	self.r.t:SetBrushSize(8)
	
	DPrint(# self.list)
	for sender, receivers in pairs(self.list) do
		X1, Y1 = sender:Center()		
		for _, r in ipairs(receivers) do
			
			X2, Y2 = r:Center()
			self.r.t:Line(X1,Y1,X2,Y2)
			
			-- draw the link menu (close button), it will compute centroid using
			-- region locations
			OpenNewLinkMenu(sender, r)
		end
	end
	-- self.r:MoveToTop() --TODO better way to handle this?
end

function link:SendMessageToReceivers(sender, message)
	for _, r in pairs(self.list[sender]) do
		-- sender:message
		
	end
end
