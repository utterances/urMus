
function LaunchAir(self)
    FreeAllRegions()    
    DPrint("Lauching Air")       
    dofile(SystemPath("urAir.lua"))
end

function LaunchFire(self)
    FreeAllRegions()                   
    DPrint("Lauching Fire")       
    dofile(SystemPath("urFire.lua"))
end

function LaunchWater(self)
    FreeAllRegions()                   
    DPrint("Lauching Water")       
    dofile(SystemPath("urWater.lua"))
end

r1 = Region()
r1:SetWidth(ScreenWidth())
r1:SetHeight(ScreenHeight()/3)
r1:SetAnchor("BOTTOMLEFT",0,ScreenHeight()/3*2)
r1.tl = r1:TextLabel()
r1.tl:SetLabel("Old Man (AIR)")
r1:Show()
r1:Handle("OnTouchDown", LaunchAir)
r1:EnableInput(true)

r2 = Region()
r2:SetWidth(ScreenWidth())
r2:SetHeight(ScreenHeight()/3)
r2:SetAnchor("BOTTOMLEFT",0,ScreenHeight()/3*1)
r2.tl = r2:TextLabel()
r2.tl:SetLabel("Frantic Man (FIRE)")
r2:Show()
r2:Handle("OnTouchDown", LaunchFire)
r2:EnableInput(true)

r3 = Region()
r3:SetWidth(ScreenWidth())
r3:SetHeight(ScreenHeight()/3)
r3:SetAnchor("BOTTOMLEFT",0,0)
r3.tl = r3:TextLabel()
r3.tl:SetLabel("Young Woman (WATER)")
r3:Show()
r3:Handle("OnTouchDown", LaunchWater)
r3:EnableInput(true)

DPrint(" ")

StartAudio()
