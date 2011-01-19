FreeAllRegions()


--functions that process all regions(buttons) on the main menu. The arguments inside the functions are simply to test that
--the code is working. in the final version, touching a region(button) will take you to the page with the corresponding
--graphic/sound combination.


start=0 --used for sounds

local scalex = ScreenWidth()/768
local scaley = ScreenHeight()/1024

--set paths for sound samples
sneezing_sound = "sneeze.wav"
snoring_sound = "snoring.wav"
elephant_sound = "elephants.wav"
clock_sound = "alarm_clock.wav"
fire_sound = "fireengine.wav"
crowd_sound = "crowd.wav"
door_sound = "door_open.wav"
door_slam_loud_sound = "door_slam.wav"
house_sound = "house.wav"
bird_sound = "bird.wav"
foot_sound = "walking_heavy.wav"
foot2_sound = "walking_soft.wav"
tiptoe_sound = "tiptoe.wav"
whisper_sound = "whispers.wav"
door_open_quiet = "door_open_quiet.wav"
door_close_quiet = "door_close_quiet.wav"

--Sneezing Sounds
sample= FlowBox("object","sample", _G["FBSample"])
sample:AddFile(sneezing_sound)
sample:AddFile(snoring_sound)
sample:AddFile(elephant_sound)
sample:AddFile(clock_sound)
sample:AddFile(fire_sound)
sample:AddFile(crowd_sound)
sample:AddFile(door_sound)
sample:AddFile(door_slam_loud_sound)
sample:AddFile(house_sound)
sample:AddFile(bird_sound)
sample:AddFile(foot_sound)
sample:AddFile(foot2_sound)
sample:AddFile(tiptoe_sound)
sample:AddFile(door_open_quiet)
sample:AddFile(door_close_quiet)
sample:AddFile(whisper_sound)


push_reset= FlowBox("object","push_reset", _G["FBPush"])
push_play = FlowBox("object","push_play", _G["FBPush"])
push_loop = FlowBox("object","push_play", _G["FBPush"])
push_sample = FlowBox("object","push_sample", _G["FBPush"])
dac = _G["FBDac"]
dac:SetPullLink(0, sample, 0)
push_reset:SetPushLink(0,sample, 2) 
push_sample:SetPushLink(0,sample,3)
push_play:SetPushLink(0,sample, 0)
push_loop:SetPushLink(0,sample,4)
push_loop:Push(0)
push_play:Push(0)
push_reset:Push(0)

function shake(self,x,y,z)
	if ((math.abs(z)<.3) and start==0) then
		start = 1
		push_sample:Push((self.index-1)/15.0)
		push_reset:Push(0)
		push_play:Push(1)
	elseif (math.abs(z)>.5) then
		push_play:Push(0)
		start=0
	end
end

-- these are the fullscreen version of each graphic. this will be visible during performance
-- and will also contain the sound. when a button is pressed on the main menu, the fullscreen
-- version will be displayed and sound will play.
function menu(self)
	SetPage(19)
	push_play:Push(0)
end

fs = {}
image_files = { 
"sneezing",
"snoring",
"elephant",
"alarm_clock",
"fire_engine",
"crowd",
"door_open",
"door_slam_loud",
"house_wobble",
"wobbling_bird",
"wht_footprints",
"blk_footprints",
"tiptoe",
"door_open_quiet",
"door_close_quiet",
"whisper"
}

function fullscreen(self)
	SetPage(self.page)
	if not fs[self.index] then
        fs[self.index] = Region()
        fs[self.index].t = fs[self.index]:Texture()
        fs[self.index]:Show()
        fs[self.index].t:SetTexture(image_files[self.index]..".png")
        fs[self.index]:SetAnchor("BOTTOMLEFT",0,0)
        fs[self.index]:SetWidth(1024)
        fs[self.index]:SetHeight(1024)
        fs[self.index]:Handle("OnTouchDown", menu)
        fs[self.index]:EnableInput(true)
		fs[self.index].index = self.index
		fs[self.index]:Handle("OnAccelerate", shake)
	end
end

-- touching a region(button) will take you to the page with the corresponding graphic/sound combination.

-- setup page 1 with 12 regions(buttons) and 2 regions(text)

menu_r = {}

SetPage(19)

for y=1,4 do
	for x=1,4 do
		i=x+4*(y-1)
		menu_r[i] = Region()
		menu_r[i].index = i
		menu_r[i].page = i+1
        menu_r[i].t = menu_r[i]:Texture()
        menu_r[i]:Show()
        menu_r[i].t:SetTexture(image_files[i].."_i.png")
        menu_r[i]:SetAnchor("BOTTOMLEFT",25+200*(x-1),50+250*(4-y))
        menu_r[i]:SetWidth(175)
        menu_r[i]:SetHeight(150)
        menu_r[i]:Handle("OnTouchDown", fullscreen)
        menu_r[i]:EnableInput(true)
	end
end

pagebutton=Region('region', 'pagebutton', UIParent)
pagebutton:SetWidth(pagersize)
pagebutton:SetHeight(pagersize)
pagebutton:SetLayer("TOOLTIP")
pagebutton:SetAnchor('BOTTOMLEFT',ScreenWidth()-pagersize-4,ScreenHeight()-pagersize-4)
pagebutton:EnableClamping(true)
--pagebutton:Handle("OnDoubleTap", FlipPage)
pagebutton:Handle("OnTouchDown", FlipPage)
pagebutton.texture = pagebutton:Texture("circlebutton-16.png")
pagebutton.texture:SetGradientColor("TOP",255,255,255,255,255,255,255,255)
pagebutton.texture:SetGradientColor("BOTTOM",255,255,255,255,255,255,255,255)
pagebutton.texture:SetBlendMode("BLEND")
pagebutton.texture:SetTexCoord(0,1.0,0,1.0)
pagebutton:EnableInput(true)
pagebutton:Show()

--[[
SetPage(20)
welcome = Region()
welcome.t = welcome:Texture()
welcome:Show()
welcome.t:SetTexture("title.png")
welcome:SetAnchor("BOTTOMLEFT",0,0)
welcome:SetWidth(1024*scaley)
welcome:SetHeight(1024*scaley)
welcome:Handle("OnTouchDown", menu)
welcome:EnableInput(true)
--]]
