------------- Simple menu --------------

-- geometry constants:
MENUITEMHEIGHT = 44
MENUFONTSIZE = 26
MENUWIDTH = 200
-- make a simple menu

-- example usage: m = loadSimpleMenu(cmdlist), m:present(x,y), m:dismiss()

function loadSimpleMenu(cmdlist)
	-- recycling constructor
	local menu
	if # recycledMenus > 0 then
		menu = table.remove(recycledMenus, 1)
	else
		menu = SimpleMenu:new(nil,cmdlist)
	end
	
	return menu
end

-- ======================

SimpleMenu = {}	-- class
menus = {}		-- ? maybe not need this one TODO
recycledMenus = {}

function SimpleMenu:new(o, cmdlist)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	 
	o.r = Region('region', 'backdrop', UIParent)
	o.r.t = o.r:Texture()
	o.r.t:Clear(0,0,0,100)
	o.r.t:SetBlendMode("BLEND")
	o.r:SetWidth(MENUWIDTH)
	
	o.r:EnableInput(true)
	o.r:EnableMoving(false)
	o.r:Hide()
	
	o:setCommandList(cmdlist)
	
	table.insert(menus, o)
	return o
end

function SimpleMenu:setCommandList(cmdlist)
	self.cmdlist = cmdlist
	self.cmdLabels = {}
	
	self.r:SetHeight(#self.cmdlist * MENUITEMHEIGHT)
	-- create a list now, use labels and 
	for i = 1, #self.cmdlist do
		local text = cmdlist[i][1]
		
		local label = Region('region', 'menutext', UIParent)
				
		-- label.t:SetBlendMode("BLEND")
		label:SetWidth(200)
		label:SetHeight(MENUITEMHEIGHT)
		label:SetAnchor("TOP",self.r,"TOP",0,-MENUITEMHEIGHT*(i-1))
		label:SetLayer("TOOLTIP")
		label:Show()
		label:EnableInput(true)
		label:EnableMoving(false)
		
		label.tl = label:TextLabel()
		label.tl:SetLabel(text)
  	  	label.tl:SetFontHeight(MENUFONTSIZE)
  		label.tl:SetFont("Avenir Next")
		label.tl:SetColor(255,255,255,255)
		
		-- hook up function call
		label:Handle("OnTouchUp",CallFunc)
		label.func = cmdlist[i][2]
		label.arg = cmdlist[i][3]
		
		table.insert(self.cmdLabels, label)
	end
end

function SimpleMenu:present(x, y)
	self.r:SetAnchor('CENTER',x,y)
	self.r:Show()
	self.r:MoveToTop()
	
	for i = 1, #self.cmdLabels do
		self.cmdLabels[i]:MoveToTop()
	end
end

function SimpleMenu:dismiss()
	self.r:Hide()
	self.r:EnableInput(false)
	for i = 1, #self.cmdLabels do
		self.cmdLabels[i]:Hide()
		self.cmdLabels[i]:EnableInput(false)
	end
	-- table.insert(recycledMenus, self)
end

-- this actually calls all the menu function on the right region(s)
function CallFunc(self)
	self.func(self.arg)
end
