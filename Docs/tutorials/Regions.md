Regions and Events
=======

* * * * *

A Region is the visual and multi-touch interaction unit of urMus. It serves as the basic unit for mapping graphic objects onto the display as well as the recipient of multi-touch and other interaction events. It can serve as a parent object for other regions, or as a container for a Texture or a TextLabels. The vast majority of writing lua scripts for urMus will involve working with regions.

Many of these scripts you are about to run start with

    FreeAllRegions()
    
which will basically "reset" the environment on the device. 


Basic Region Creation
----------

To create your very first region, run the following code.

    FreeAllRegions()
    
    -- Creating a visible region
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
          
          
Anchoring a Region
----------

One can position a region on the screen by setting an anchor point of the region (can be for example the bottom left corner) at a specific coordinate.

    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)

    -- This moves the region relative to the screen   
    r:SetAnchor("BOTTOMLEFT",100,100)
    
But the anchor system is actually much more powerful. We can choose from a range of possible anchor points such as TOP, BOTTOM, LEFT RIGHT, TOPRIGHT, CENTER and so forth to choose the anchor point.
    
<img width=24% src="Images/RegionStep1.PNG">
<img width=24% src="Images/RegionStep2.PNG">
    
    
Relative Anchoring
----------

Moreover we can anchor a region relative to another region that has already been created. This means we pick a point of an original region at which we would like to anchor a "child" region.


    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
     
    r:SetAnchor("BOTTOMLEFT",100,100)
     
    r2 = Region()
    r2.t = r2:Texture()
    r2:SetWidth(r:Width()/2)
    r2:SetHeight(r:Height()/2)
     
    -- Notice the first region is an argument and there are two anchoring positions specified.
    r2:SetAnchor("CENTER",r,"CENTER",0,0)
    r2.t:SetTexture(0,255,0,255)
    r2:Show()


An important aspect of this relative anchoring is that moves inherit from "parent" regions.

    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
     
    r:SetAnchor("BOTTOMLEFT",100,100)
     
    r2 = Region()
    r2.t = r2:Texture()
    r2:SetWidth(r:Width()/2)
    r2:SetHeight(r:Height()/2)
     
    
    r2:SetAnchor("CENTER",r,"CENTER",0,0)
    r2.t:SetTexture(0,255,0,255)
    r2:Show()
    
    -- Here is the inherited move
    r:SetAnchor("BOTTOMLEFT", 200,200)
    
<img width=24% src="Images/RelativeAnchor1.PNG">
<img width=24% src="Images/RelativeAnchor2.PNG">
    
Moving and Resizing Regions
----------

This simple example really demonstrates the power of urMus. In very few lines of code, we create a white region that can be resized and moved. Take our word for it...it's not this simple in Objective-C.

    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture(255,255,255,255)
    r:EnableInput(true)
    r:EnableMoving(true)
    r:EnableResizing(true)
    r:Show()



Events
----------

Events are incidents that a region can be programmed to respond to. Usually they relate to user input, but they can also be triggered by other events such as a screen refresh. This is a first example how to get a region to respond to touch input. The first argument of a function used for events is always the region for which the event is triggered. 

This might be your first introduction to a function in lua. Event functions will always have a first argument that refers to the region that generated the event. Usually self is a rather descriptive label for the region in question. Later, you will see that more parameters can be added for more complicated events.

In order for a region to be aware of a particular event, we need to register a handler for the event. This works by telling the region what function to call for a given event name. Here the event is "OnTouchUp", which is called when a finger is lifted off the screen while inside the region. The moment that happens, the function ColorRandomly will be called.

    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
     
    r:SetAnchor("BOTTOMLEFT",100,100)
     
    r2 = Region()
    r2.t = r2:Texture()
    r2:SetWidth(r:Width()/2)
    r2:SetHeight(r:Height()/2)
     
    
    r2:SetAnchor("CENTER",r,"CENTER",0,0)
    r2.t:SetTexture(0,255,0,255)
    r2:Show()
    
    -- Here is the inherited move
    r:SetAnchor("BOTTOMLEFT", 200,200)
     
    function ColorRandomly(self)
        self.t:SetSolidColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
    end
     
    -- We add the "OnTouchUp" event to region r. The function ColorRandomly will be called when this occurs
    r:Handle("OnTouchUp",ColorRandomly)

    r:EnableInput(true)

The last line of code enables input on the region. Don't forget to do this! This is useful to allow to enable and disable complex events all at once.

Furthermore, notice that even though r2 is there, it does not currently intercept touch events. This is the case because by default, EnableInput() is false for a region, hence it does not intercept touch events. We can make r2 intercept touches by enabling touch input for it.


    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
     
    r:SetAnchor("BOTTOMLEFT",100,100)
     
    r2 = Region()
    r2.t = r2:Texture()
    r2:SetWidth(r:Width()/2)
    r2:SetHeight(r:Height()/2)
     
    
    r2:SetAnchor("CENTER",r,"CENTER",0,0)
    r2.t:SetTexture(0,255,0,255)
    r2:Show()
    
    -- Here is the inherited move
    r:SetAnchor("BOTTOMLEFT", 200,200)
     
    function ColorRandomly(self)
        self.t:SetSolidColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
    end
     
    -- We add the "OnTouchUp" event to region r. The function ColorRandomly will be called when this occurs
    r:Handle("OnTouchUp",ColorRandomly)

    r:EnableInput(true)
    r2:EnableInput(true)


Notice how now region r only gets touch-events for it unoccluded parts. r2 is successfully intercepting the touch events. It doesn't perform any action because we didn't specify a handler or event for r2.

A region can take multiple events as well. The following script has again disabled input for r2, but now r will move randomly whne double tapped. 


    FreeAllRegions()
     
    r = Region()
    r.t = r:Texture()
    r:Show()
    r.t:SetTexture(255,0,0,255)
     
    r:SetAnchor("BOTTOMLEFT",100,100)
     
    r2 = Region()
    r2.t = r2:Texture()
    r2:SetWidth(r:Width()/2)
    r2:SetHeight(r:Height()/2)
     
    
    r2:SetAnchor("CENTER",r,"CENTER",0,0)
    r2.t:SetTexture(0,255,0,255)
    r2:Show()
    
    r:SetAnchor("BOTTOMLEFT", 200,200)
     
    function ColorRandomly(self)
        self.t:SetSolidColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
    end
     
    r:Handle("OnTouchUp",ColorRandomly)

    r:EnableInput(true)
     
    function MoveRandomly(self)
        self:SetAnchor("BOTTOMLEFT",math.random(0,ScreenWidth()),math.random(0,ScreenHeight()))
    end
     
    r:Handle("OnDoubleTap", MoveRandomly)


<img width=24% src="Images/Interaction1.PNG">
<img width=24% src="Images/Interaction2.PNG">

If you want, try to experiment with other events. Some other user input events are:

- OnTouchDown
- OnEnter
- OnLeave
- OnDoubleTap


Misc Lua Data Types
----------

Now we have seen how to create visual content and interactions with regions. Next, let's see some of the language power of lua. 
The only data structure in lua is a table. It allows us to flexible store and organize data.


### Arrays ###

The simplest use of a table is as an array. Here we create an array of regions.

    FreeAllRegions()
     
    regions = {}
    for i=1,10 do
        local newregion = Region()
        newregion.t = newregion:Texture(math.random(0,255),math.random(0,255),math.random(0,255),math.random(60,255))
        newregion:Show()
        regions[i] = newregion
    end

We just see one region. What happened? They are all on top of each other, so we only see the top-most one.

This next loop will randomly spread them out! Notice how the for loop uses a function called pairs(). This is what is called an iterator. It goes through all the non-nil entries in the table.

    FreeAllRegions()
     
    regions = {}
    for i=1,10 do
        local newregion = Region()
        newregion.t = newregion:Texture(math.random(0,255),math.random(0,255),math.random(0,255),math.random(60,255))
        newregion:Show()
        regions[i] = newregion
    end

    for i,v in pairs(regions) do
     	v:SetAnchor("BOTTOMLEFT",math.random(0,ScreenWidth()),math.random(0,ScreenHeight()))
    end

<img width=24% src="Images/RegionArray1.PNG">
<img width=24% src="Images/RegionArray2.PNG">


### Associative Arrays ###

But tables are much more powerful than just arrays. They are actually associative arrays where any number, but also any string can be used to index it.

To see how this works, execute this code and read the comments.

    local test = {}
     
    -- We store "b" at index location "a"
    test["a"]="b"
     
    -- Lua has two ways to notate string idices, one can also use a period notation.
    -- Hence the following is accessing the test table at position a.
    test[test.a]="c"
     
    -- So this is the same as saying test[test["a"]] or test["b"] or in fact test.b
     
    -- We can get string index entries just the same way from an interator as number indicies
     
    local str = ""
     
    -- In lua, the .. operator concatenates strings     
    for k,v in pairs(test) do
        str = str .. k ..":"..v.."  "
    end
     
    -- Let's look at this string with a debug print
    DPrint(str)

    -- To free an table we simply assign it nil
    test = nil
    
### More Advanced Lua Concepts ###

[Lua Refernce](http://www.lua.org/manual/5.1/)
