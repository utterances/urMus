Text Labels
=======

* * * * *

Text Labels are currently the only way to add text in urMus, and they are always associated with a region.

Here is an example of a region with a text label. The \n acts as a newline character.

    FreeAllRegions()
     
    r = Region()
    r.tl = r:TextLabel()
    -- Note that the space after \n will be rendered
    r.tl:SetLabel("Test\n Test2")
    r:Show()

In order to see where this text is being positioned in the region, let's add a background to it. Adding colors and backgrounds to regions will be covered in a later tutorial.


    FreeAllRegions()
     
    r = Region()
    r.tl = r:TextLabel()
    r.tl:SetLabel("Test\n Test2")
    r:Show()
    -- Giving the region a color allows to see where the labels are placed within it
    r.t = r:Texture(0,0,255,255)
    
    
There are several other ways to manipulate the text: font, size, alignment, color, and shadows. The following script demonstrates all of these. See the documentation for more information about the paramaters.

    FreeAllRegions()
     
    r = Region()
    r.tl = r:TextLabel()
    r.tl:SetLabel("Test\n Test2")
    r:Show()
    r.t = r:Texture(0,0,255,255)

    -- Font
    r.tl:SetFont("Arial")
    
    -- Font Height
    r.tl:SetFontHeight(24)
     
     
    -- Horizontal Alignment (Options: LEFT, RIGHT, CENTER [default])
    r.tl:SetHorizontalAlign("LEFT")
    -- Vertical Alignment (Options: TOP, BOTTOM, MIDDLE [default])
    r.tl:SetVerticalAlign("TOP")

    -- Color
    r.tl:SetColor(0,255,255,255)

    -- (We set the background to be white here to make the colors make more sense)
    r.t:SetTexture(255,255,255,255)
     
    -- Shadow
    r.tl:SetShadowColor(0,0,255,250)
    r.tl:SetShadowOffset(5,-5)
    r.tl:SetShadowBlur(2)
    
    -- This is a good line to debug text problems. Remember, .. is a string concatenation
    DPrint(r.tl:Label().." "..r.tl:Font().." "..r.tl:ShadowBlur())

### Technical Note ###

As a general rule in urMus in regards to reading versus writing settings. For a property, X, of interest:
- SetX() sets the property/value
- X() reads the property/value

