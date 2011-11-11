-- Load utility and library functions here
dofile(SystemPath("urKeyboard.lua"))
dofile(SystemPath("urTopBar.lua"))
dofile(SystemPath("urStringEditBox.lua"))

local codefilename
local edited

local function ClearCode(self)
    EditRegion.tl:SetLabel("")
    ShowNotification("Cleared")
end

local function NewCode(self)
--    EnterName()
    if codefilename and edited then
-- WarnSave
    end
    local function Done(str)
        codefilename = str..".lua"
    end
    OpenStringEditBox("ur","New Filename:",Done)
    EditRegion.tl:SetLabel("")
    ShowNotification("New")
end

local function LoadLuaFile(file,path)

	local filename
	if not path then
		filename = 	SystemPath(file)
	else
		filename = path.."/"..file
	end
    local f = assert(io.open(filename, "r"))
    local t = f:read("*all")
    f:close()
	EditRegion.tl:SetLabel(t)
	codefilename = file
    ShowNotification(file.." Loaded")
end


local function LoadCode(self)
    if codefilename and edited then
    -- WarnSave
    end
   	local scrollentries = {}

	for k,v in pairs(pagefile) do
		local entry = { v, nil, nil, LoadLuaFile, {84,84,84,255}}
		table.insert(scrollentries, entry)
	end
	for v in lfs.dir(DocumentPath("")) do
		if v ~= "." and v ~= ".." and string.find(v,"%.lua$") then
			local entry = { v, nil, nil, LoadLuaFile, {84,84,84,255}, DocumentPath("")}
			table.insert(scrollentries, entry)			
		end
	end
	
	urScrollList:OpenScrollListPage(scrollpage, "Load Lua File", nil, nil, scrollentries)
end

local function WriteCodeToFile(filename)
    local f = assert(io.open(DocumentPath(filename), "w"))
    local t = f:write(EditRegion.tl:Label())
    f:close()
end

local function SaveCode(self)
    if not codefilename then
	    local function Done(str)
            local filename = str..".lua"
            WriteCodeToFile(filename)
            ShowNotification(filename.." Saved")
		end
	    OpenStringEditBox("ur","Filename:",Done)
    else
        WriteCodeToFile(codefilename)
    end
end

local function RunCode(self)
    local code = EditRegion.tl:Label()
    RunScript(code)
    ShowNotification("Ran Code")
end

CreateTopBar(6,"Clear",ClearCode,"New",NewCode,"Load",LoadCode,"Save",SaveCode,"Run",RunCode,"Face",FlipPage)

local mykb = Keyboard.Create()

EditRegion = Region()
EditRegion:SetWidth(ScreenWidth())
EditRegion:SetHeight(ScreenHeight()-mykb:Height()-28)
EditRegion:SetAnchor("BOTTOMLEFT",0,mykb:Height())
EditRegion.tl = EditRegion:TextLabel()
EditRegion.tl:SetVerticalAlign("TOP")
EditRegion.tl:SetHorizontalAlign("LEFT")
EditRegion.tl:SetFontHeight(ScreenHeight()/20)
EditRegion:Show()

mykb.typingarea = EditRegion
mykb:Show(1)

