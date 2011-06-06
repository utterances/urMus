Paging
=======

* * * * *

Paging is a mechanism to manage multiple independent screen renderings. When a region is created, it is always placed in the current page. When we switch to another page, only regions that have been placed into this page before will become visible and interacted with.

 With *SetPage()* we can set the currently active page. With *Page()* we can read which page we are currently on. Pages are numbered starting with 1 (which is usually occupied by the default urMus interface).

This example creates a second page, with a region, which when touched will lead to a switch back to page 1.

    FreeAllRegions()

    local currentpage = 2
    function SwitchPage(self)
        if currentpage == 2 then
            currentpage = 1
            if not r then
                r = Region()
                r.t = r:Texture(255,0,0,255)
                r:Handle("OnTouchDown", SwitchPage)
                r:Show()
                r:EnableInput(true)
            end
        else
            currentpage = 2
        end       
        SetPage(currentpage)
    end


    SetPage(2)
    r2 = Region()
    r2.t = r2:Texture(0,255,0,255)
    r2:Handle("OnTouchDown", SwitchPage)
    r2:Show()
    r2:EnableInput(true)
    r2:SetAnchor("BOTTOMLEFT",100,100)


There is a special function, *DisplayExternalPage()*, that allows you to render a page on an external display. We can also link (or mirror) the main display, which is the default setting.


    FreeAllRegions()

    SetPage(1)

    r = Region()
    r.t = r:Texture(255,0,0,255)
    r:Show()

    SetPage(2)

    r2 = Region()
    r2.t = r2:Texture(0,255,0,255)
    r2:Show()

    SetPage(1)

	-- This shows page 2 on the externally projected page
    DisplayExternalPage(2)

To switch back to mirroring, just call:

    LinkExternalDisplay(true)
