-- ================
-- = Visual Links between regions=
-- ================

-- methods and appearances and menus for deleting / editing
-- assumes urTapperwareMenu.lua is already processed

linkLayer = {}

function linkLayer:Init()
	self.list = {}
	self.menus = {}
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
function linkLayer:Add(r1, r2)
	if self.list[r1] == nil then
		self.list[r1] = {r2}
	else
		table.insert(self.list[r1], r2)
	end
	local	menu = newLinkMenu(r1, r2)
	table.insert(self.menus, menu)
end

-- remove links
function linkLayer:Remove(r1, r2)	
	if self.list[r1] ~= nil then
		
		for i = 1, #self.list[r1] do
			if self.list[r1][i] == r2 then
				table.remove(	self.list[r1], i)
			end
		end
	end
	
	for i,menu in ipairs(self.menus) do
		if menu.sender == r1 and menu.receiver == r2 then
			table.remove(self.menus, i)
			deleteLinkMenu(menu)
		end
	end
end

-- draw a line between linked regions, also draws menu
function linkLayer:Draw()	
	self.r.t:Clear(0,0,0,0)
	self.r.t:SetBrushColor(100,255,240,200)
	self.r.t:SetBrushSize(8)
	
	for sender, receivers in pairs(self.list) do
		X1, Y1 = sender:Center()		
		for _, r in ipairs(receivers) do
			
			X2, Y2 = r:Center()
			self.r.t:Line(X1,Y1,X2,Y2)			
		end
	end
	
	for _,menu in ipairs(self.menus) do
		OpenLinkMenu(menu)
	end
	-- draw the link menu (close button), it will compute centroid using
	-- region locations
	
	-- self.r:MoveToTop() --TODO better way to handle this?
end

function linkLayer:SendMessageToReceivers(sender, message)
	for _, r in pairs(self.list[sender]) do
		-- sender:message
		
	end
end
