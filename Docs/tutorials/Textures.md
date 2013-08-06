Textures and Animations
=======

* * * * *

Textures are always associated with a region and they can be either a solid color, gradient, or an image file. You could consider it as a sort of "background" for a region.

Texture Basics
----------

Here is a solid color example where the four arguments to Texture are red, green, blue, and alpha. An alpha of 255 is opaque while an alpha of 0 is transparent. All values must be between 0 and 255 inclusive.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(255,255,128,255)

Textures can also be images.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture("Ornament1.png")

And they don't have to stay the same forever. The SetTexture() function can be called any time after a texture is first constructed like they are above.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture("Ornament1.png")
    r.t:SetTexture("alarm_clock.png")
    
    
And you can even use gradients. The following is the verbose way to set a gradient. This allows you to specify to colors for all four corners.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture("Ornament1.png")

    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)

<img width=24% src="Images/Texture1.PNG">
<img width=24% src="Images/Texture2.PNG">
<img width=24% src="Images/Texture3.PNG">
<img width=24% src="Images/Texture4.PNG">


    
    
#### Technical note ####

The image type of texture is handled differently from a solid color or gradient. If you set a color and and image, the image will be overlaid by that color. To not have a color effect the display of an image just set the color to opaque white (255,255,255,255). To remove an image from a region call SetTexture with empty quotes - i.e.  region.t:SetTexture("")

Warning, loading image files at time critical positions in a lua program can be a bad idea. It is better to load them in a table at the beginning of a script and use that for access later.

    
Tiling and Texture Coordinates
----------

Tiling means that textures are repeated after the texture coordinate space is exhausted. This allows for scrolling etc. 

Texture coordinates are a way to access any portion of a texture that is accessible via a linear transformation. For more information on texture coordinates, see [this site](http://www.opengl.org/resources/code/samples/sig99/advanced99/notes/node52.html) and the API documentation.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture("Ornament1.png")

    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)

    r.t:SetTiling(true)
    r.t:SetTexCoord(0.5,1.5,0.5,1.5)

#### Technical Note ####
The *SetRotation()* will override any *SetTexCoord()* calls. 

<img width=240 src="Images/TextureCoord1.PNG">

Uploading Images
----------

Image files can be added to a project by uploading them through the web interface. Let's upload a file via the editor's "Upload a file" feature. DocumentPath() makes sure we grab the texture from uploaded content and not the provided system defaults. Just for fun, we can rotate the image and also honor and transparency with blending. Please download the image you find [here](Images/longarrow-white.png) to maintain consistency with the rest of this tutorial.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(DocumentPath("longarrow-white.png"))

    -- The parameter for rotation is in radians
    r.t:SetRotation(22.5*2*math.pi/360)
    r.t:SetBlendMode("BLEND")


Animations
----------

Animations are implemented by using the "OnUpdate" event which is called every time the screen is redrawn. This event returns an argument, *elapsed*, which is how many seconds it has been since the last screen refresh.

Here, we will create a function that rotates a texture. The elapsed time is useful because you can never rely on the screen to refresh at a constant rate! Thanks to the flexibility of lua, we can just add table members 'angle' and 'speed' to our region. It allows easy access within event handlers.


    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(DocumentPath("longarrow-white.png"))

    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)


    function RotateTexture(self,elapsed)
        self.angle = self.angle + elapsed * self.speed
        self.t:SetRotation(self.angle)
    end
     
    r.angle = 0
    r.speed = 2*math.pi
    r:Handle("OnUpdate", RotateTexture)
    

Now, let's create a canvas to draw into that is the size of the screen.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(DocumentPath("longarrow-white.png"))

    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)
	r.t:SetBlendMode("BLEND")

    function RotateTexture(self,elapsed)
        self.angle = self.angle + elapsed * self.speed
        self.t:SetRotation(self.angle)
    end
     
    r.angle = 0
    r.speed = 2*math.pi
    r:Handle("OnUpdate", RotateTexture)

    r2 = Region()
    r2:SetWidth(ScreenWidth())
    r2:SetHeight(ScreenHeight())
    r2:SetLayer("BACKGROUND")
    r2:SetAnchor("BOTTOMLEFT",0,0)
    r2.t = r2:Texture(255,255,255,255)
    r2:Show()


 Where is the image? It's in same layer, but created earlier, hence it's behind the newest one. So let's lift it to a slightly higher layer.

    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(DocumentPath("longarrow-white.png"))
    
    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)
	r.t:SetBlendMode("BLEND")

    function RotateTexture(self,elapsed)
        self.angle = self.angle + elapsed * self.speed
        self.t:SetRotation(self.angle)
    end
     
    r.angle = 0
    r.speed = 2*math.pi
    r:Handle("OnUpdate", RotateTexture)
 
    r2 = Region()
    r2:SetWidth(ScreenWidth())
    r2:SetHeight(ScreenHeight())
    r2:SetLayer("BACKGROUND")
    r2:SetAnchor("BOTTOMLEFT",0,0)
    r2.t = r2:Texture(255,255,255,255)
    r2:Show()
    
    -- bring the arrow to the front
    r:SetLayer("LOW")
    
<img width=240 src="Images/Animation1.PNG">
   
Let's extend this a little more and introduce some very basic shape rendering into a texture. Remeber that r2 is a region over the entirety of the screen. The following example draws 8 lines, a rectangle, a four line polygon, and an ellipse. The details of the parameters can be found in the documentation. Notice that the texture *SetBrushColor()* and *SetBrushSize()* methods directly effect the rendering. The *SetFill()* method determines whether or not shapes are filled (makes sense).

This looks like a lot of code, but compared to what it would take to accomplish this in Objective-C, it is nothing!


    FreeAllRegions()
     
    r = Region()
    r:Show()
    r.t = r:Texture(DocumentPath("longarrow-white.png"))
    
    r.t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
    r.t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)
	r.t:SetBlendMode("BLEND")

    function RotateTexture(self,elapsed)
        self.angle = self.angle + elapsed * self.speed
        self.t:SetRotation(self.angle)
    end
     
    r.angle = 0
    r.speed = 2*math.pi
    r:Handle("OnUpdate", RotateTexture)
 
    r2 = Region()
    r2:SetWidth(ScreenWidth())
    r2:SetHeight(ScreenHeight())
    r2:SetLayer("BACKGROUND")
    r2:SetAnchor("BOTTOMLEFT",0,0)
    r2.t = r2:Texture(255,255,255,255)
    r2:Show()
    
    r:SetLayer("LOW")

    -- Set up line color and thickness
    r2.t:SetBrushColor(255,0,0,255)
    r2.t:SetBrushSize(3)
     
    -- Draw 8 random lines
    for i=1,8 do
        r2.t:Line(math.random(0,ScreenWidth()), math.random(0,ScreenHeight()), math.random(0,ScreenWidth()), math.random(0,ScreenHeight()))
    end
   
    -- Draw a rect
    r2.t:SetFill(true)
    r2.t:SetBrushColor(0,0,255,255)
    r2.t:Rect(100,80,80 ,40)
   
    -- Draw an arbitrary four line polygon
    r2.t:SetBrushColor(0,255,0,255)
    r2.t:SetFill(false)
    r2.t:Quad(math.random(0,ScreenWidth()), math.random(0,ScreenHeight()),math.random(0,ScreenWidth()), math.random(0,ScreenHeight()),math.random(0,ScreenWidth()), math.random(0,ScreenHeight()),math.random(0,ScreenWidth()), math.random(0,ScreenHeight()))
     
    -- Draw an ellipse
    r2.t:SetBrushColor(255,255,0,255)
    r2.t:SetBrushSize(7)
    r2.t:Ellipse(ScreenWidth()/2, ScreenHeight()/2, ScreenWidth()/2-15, ScreenWidth()/2-15)



To clear all of this rendering that just took place in r2, you could simply run the command *r2.t:Clear(0,0,0,255)* to clear it with a specified color.

<img width=24% src="Images/Draw1.PNG">
<img width=24% src="Images/Draw2.PNG">


Advanced Texture Examples
----------

Here we will apply concepts learned earlier to have interactive drawing into a texture.

Work through this example and figure out how it works!

<img width=240 src="Images/textureExampleOne.png">

    FreeAllRegions()

    local w = ScreenWidth()/10
    local random = math.random

    function Spark(self,x,y,i)

        local sx,sy = random(x-w,x+1),random(y-w,y+1)
        local ex,ey = random(x-1,x+w),random(y-1,y+w)
        r2.t:SetBrushColor(random(128,255),0,0,random(30,128))

        r2.t:Line(sx,sy,ex,ey)

    end

    function Clear(self)
        r2.t:Clear(255,255,255,255)
    end

    -- Let's create a canvas to draw into
    r2 = Region()
    r2:SetWidth(ScreenWidth())
    r2:SetHeight(ScreenHeight())
    r2:SetLayer("BACKGROUND")
    r2:SetAnchor("BOTTOMLEFT",0,0)
    r2.t = r2:Texture(255,255,255,255)
    -- Texture internally have to be powers of 2. So we need to rescale our texture to fit the internals.
    -- This little snippet also works for the iPad.
    if ScreenWidth() > 320 then
        r2.t:SetTexCoord(0,ScreenWidth()/1024.0,ScreenHeight()/1024.0,0.0)
    else
        r2.t:SetTexCoord(0,320.0/512.0,480.0/512.0,0.0)
    end

    r2:Show()
    r2:Handle("OnTouchDown",Spark)
    r2:Handle("OnMove",Spark)
    r2:Handle("OnTouchUp",Despark)
    r2:Handle("OnDoubleTap",Clear)
    r2:EnableInput(true)
    r2.t:SetBlendMode("BLEND")

    r2.t:ClearBrush()
    r2.t:SetBrushColor(255,0,0,128)
    r2.t:SetBrushSize(3)

    -- Using a texture as a brush.
    r = Region()
    r.t = r:Texture(255,255,255,255)
    r.t:SetTexture("Ornament1.png")
    r:UseAsBrush()
    r2.t:SetBrushSize(64)

You should have a white canvas where you can paint with touch events. The brush is actually the ornament texture that you have seen before! A double tap will clear the canvas.



Here is a second example. Work through this one as well. This creates *maxr* number of textures that are tiled, but they move at different speeds across the screen creating a cool visual aliasing effect.


<img width=240 src="Images/textureExampleTwo.png">

    FreeAllRegions()
    DPrint("")

    r2 = {}
    local maxr = 3

    function MoveIt(self,elapsed)
        local pos = self.pos
    if ScreenWidth() > 320 then
            self.t:SetTexCoord(0.0+pos,32*126/1024.0+pos,0.0+pos,32*128/1024.0+pos)
    else
            self.t:SetTexCoord(0.0+pos,32*128/512.0+pos,0.0+pos,32*128/512.0+pos)
    end
        self.pos = pos + self.i*0.01
    end   

    for i=1,maxr do
		r2[i] = Region()
		r2[i]:SetWidth(ScreenWidth())
		r2[i]:SetHeight(ScreenHeight())
		r2[i]:SetLayer("BACKGROUND")
		r2[i]:SetAnchor("BOTTOMLEFT",0,0)
		r2[i].t = r2[i]:Texture(255,255,255,255)
		r2[i].t:SetTexture("Ornament1.png")
		r2[i].i = i
		r2[i].pos = 0
		-- Texture internally have to be powers of 2. So we need to rescale our texture to fit the internals.
		if ScreenWidth() > 320 then
			r2[i].t:SetTexCoord(0,64/1024.0,64/1024.0,0.0)
		else
			r2[i].t:SetTexCoord(0,64/512.0,64/512.0,0.0)
		end
		r2[i]:Handle("OnUpdate",MoveIt)
		r2[i].t:SetBlendMode("BLEND")
		r2[i]:Show()
		r2[i].t:SetGradientColor("TOP", 255, 0, 0, 128, 0, 255, 0, 255)
		r2[i].t:SetGradientColor("BOTTOM", 0,0,255, 50, 255, 255, 0, 128)
	end


