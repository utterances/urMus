Global API functions
====================

This page documents functions and variables that can be found in the global name space.


Debug Printing API
==================

DPrint 
-------
### Synopsis
    DPrint("output")
### Description
Debug print a give string in the center of the screen. This will also be used
for system errors and should not be used for normal user interactions.
### Arguments
- output (String)
    The string to print to the debug console.

RunScript
---------
### Synopsis
    RunScript("script")
### Description
Execute a string as Lua code.
### Arguments
- script (String)
    The lua code which is to be executed.

Timing API
==========

Time
-------
### Synopsis
    seconds = Time()
### Description
Returns the system uptime of the host machine in seconds, with millisecond precision.
### Returns
- seconds (Number)
    The current system uptime in seconds. 



urSound FlowBox API
===================

StartAudio
----------
### Synopsis
    StartAudio()
### Description
Starts the audio engine. Audio-related events will start working.

PauseAudio
----------
### Synopsis
    PauseAudio()
### Description
Pauses the audio engine. Audio-related events will not work while paused.

FlowBox
-------------
### Synopsis
    flowbox = FlowBox("type", "name", inheritedFlowbox)
### Description
Creates a new instance of a specified flowbox. To seed cloning use global
instances of flowboxes via `_G["FB"..objectname]`.
### Arguments
- type (String) [unused]
    String identifying the opject type.
- name (String) [unused]
	  User-specified name of the object.
- inheritedFlowbox (Flowbox)
	  The parent flowbox to inherit from. If specified, this creates a deep-copy of the 
    parent.

### Returns
- flowbox (Flowbox)
  A new instance of the given flowbox.
  
SourceNames
----------------
### Synopsis
    source1, source2, ... = SourceNames()
### Description
Returns the names of all source objects offered by the urSound engine. Related
flowbox variables can be accessed via _G["FB"..object1].
### Returns
- source1, source2, ... (String list)
	  A list of the names describing all urSound sources.

ManipulatorNames
---------------------
### Synopsis
    manipName1, manipName2, ... = ManipulatorNames()
### Description
Returns the names of all manipulator objects offered by the urSound engine.
Related flowbox variables can be accessed via `_G["FB"..manipName]`.
### Returns
- manipName1, manipName2, ... (List<String>)
    A list of names describing all urSound manipulators.

SinkNames
--------------
### Synopsis
    sinkName1, sinkName2, ... = SinkNames()
### Description
Returns the names of all sink objects offered by the urSound engine. Related
flowbox variables can be accessed via `_G["FB"..sinkName]`.
### Returns
- sinkName1, sinkName2, ... (List<String>)
    Names describing all urSound sinks.

File system helper API
======================

DocumentPath
------------
### Synopsis
    documentPath = DocumentPath("filename")
### Description
If the file exists in the document path, returns the absolute path to the given file.
If the file doesn't exist, throws an error.
### Arguments
- filename (String)
    Name of the file in the system's Documents folder.

### Returns
- documentPath (String)
    Absolute path of the found file.

SystemPath
----------
### Synopsis
    systemfilename = SystemPath("filename")
### Description
Converts a relative filename to include an iPhone-project's resource path.
### Arguments
- filename (String)
    File linked with the urMus project.

### Returns
- systemfilename (String)
    Absolute path of the file in the resources folder.

2D Interface and Interaction API (aka urLook)
=============================================

SetFrameRate
------------
### Synopsis
    SetFrameRate(fps)
### Description
Sets the maximum frames per second. Effective FPS may be lower if load is high.
### Arguments
- fps (Number)
    Desired target frames per second.
    
Page
-------
### Synopsis
    page = Page()
### Description
Returns the number index of the currently active page.
### Returns
- page (Number)
    Index of currently active page.

SetPage
-------
### Synopsis
    SetPage(pageIndex)
### Description
Sets the currently active page. Only frames created within an active page will
be rendered. This allows for multiple mutually exclusive pages to be prepared
and selectively rendered. Mouse events and other interface actions and events
will only work for the currently active page.
### Arguments
- pageIndex (Number)
    Index of the page to be made active. Side-effects: Deactivates all other pages.

NumMaxPages
-----------
### Synopsis
    maxpages = NumMaxPages()
### Description
Maximum number of pages supported by the current urMus built.
### Returns
- maxpages (Number)
    Maximum number of pages supported.

Region
-----------
### Synopsis
    newRegion = Region(["regionType", "regionName", parentRegion])
### Description
Creates a rectangular region.
### Arguments
- frameType (String)
    Type of the region to be created. Currently unused. 
- frameName (String)
    Name of the newly created frame. If nil, no frame name is assigned. This helps to debug frames by being able to identify them by custom names.
- parentRegion (Region)
    The region object that will be used as the created Region's parent
    (cannot be a string!) Does not default to UIParent if given nil.

### Returns
  - newRegion (Region)
    A reference to the newly created region. 

NumRegions
------------
### Synopsis
    num = NumRegions()
### Description
Returns the current number of regions inside of the current page. 

InputFocus
-------------
### Synopsis
    region = InputFocus()
### Description
Returns the region that is currently receiving input events. The region must have EnableInput(true).

HasInput
-----------
### Synopsis
    isOver = HasInput(region, [topOffset, bottomOffset, leftOffset, rightOffset])
### Description
Determines whether or not the input is over the specified region. 
### Arguments
- region (Region)
    The region (or region-derived object such as Buttons, etc) to test with 
- topOffset (Number, optional)
    The distance from the top to include in calculations 
- bottomOffset (Number, optional) 
    The distance from the bottom to include in calculations 
- leftOffset (Number, optional) 
    The distance from the left to include in calculations 
- rightOffset (Number, optional) 
    The distance from the right to include in calculations.

### Returns
- isOver (Boolean) 
    True if mouse is over the region (with optional offsets), false otherwise. 

InputPosition
-----------------
### Synopsis
    x, y = InputPosition()
### Description
Returns the input device's position on the screen.
### Returns
- x (Number)
    The input device's x-position on the screen. 
- y (Number)
    The input device's y-position on the screen. 

ScreenHeight
---------------
### Synopsis
    screenHeight = ScreenHeight()
### Description
Returns the height of the window in pixels. For an iPhone this is 480.
### Returns
- screenHeight (Number)
    Height of window in pixels. 

ScreenWidth
--------------
### Synopsis
    screenWidth = ScreenWidth()
### Description
Returns the width of the window in pixels. For an iPhone this is 320.
### Returns
- screenWidth (Number)
    Width of window in pixels

Camera API (aka urLook more)
=============================================

SetActiveCamera
-----------------
### Synopsis
	SetActiveCamera(camera)
### Description
Sets the active camera. Allows to pick between multiple cameras if they are present (front-facing, back-facing)
### Arguments
- camera (Number)
	1 is the default camera (usually backfacing)
	2 and higher are an unspecified second camera (2 is usually front-facing)

ActiveCamera
--------------
### Synopsis
	camera = ActiveCamera()
### Description
Returns which camera is currently active.
### Returns
- camera (Number)
	1 is the default camera (usually backfacing)
	2 and higher are an unspecified second camera (2 is usually front-facing)

SetTorchFlashFrequency
------------------------
### Synopsis
	SetTorchFlashFrequency(frequency)
### Description
Sets the flashing frequency of the camera flash-light if present.
### Arguments
- frequency (Number)
	Frequency at which the light is turned on and off

Networking API
======================

IPAddress
----------
### Synopsis
	host = IPAddress()
### Description
Returns the IP-address of the device.

StartHTTPServer
-----------------
### Synopsis
	host, port = StartHTTPServer()
### Description
Starts the HTTP Server which provides the web-based urMus programming environment. Returns the hostname and port of the service.
### Returns
- host (String)
	Hostname of the device which is running the web server
- port (Number)
	port number to access the web server

StopHTTPServer
----------------
### Synopsis
	StopHTTPServer()
### Description
Stops the HTTP Server which provides the web-based urMus programming environment.

HTTPServer
------------
### Synopsis
	name, port = HTTPServer()
### Description
Returns the name and port of the HTTPServer run on the device.
### Returns
- host (String)
	Hostname of the device which is running the web server
- port (Number)
	port number to access the web server

StartOSCListener
------------------
### Synopsis
	host, port = StartOSCListener()
### Description
Starts the OSC Listening service, which allows for incoming OSC message to be received. The event OnOSCMessage will be triggered when a message is received.
### Returns
- host (String)
	Hostname of the device which is running the web server
- port (Number)
	port number to access the web server

StopOSCListener
-----------------
### Synopsis
	StopOSCListener()
### Description
Stops the OSC Listening service.

SetOSCPort
------------
### Synopsis
	SetOSCPort(port)
### Description
Sets the OSC port of the OSCListening service, if it is running.
### Arguments
- port (Number)
	port number for the OSCListening service

OSCPort
---------
### Synopsis
	port = OSCPort()
### Description
Returns the current port of the OSCListener.
### Returns
- port (Number)
	port number to access the web server

SendOSCMessage
----------------
### Synopsis
	SendOSCMessage(host, port, oscpattern, arg1, [arg2, ...])
### Description
Sends an OSC message constiting of an arbitrary number of arguments which can be numbers or strings.
### Arguments
- host (String)
	Hostname of the device which is running the OSC service
- port (Number)
	port number of the OSC service
- oscpattern (String)
	OSC pattern identifying the OSC functionality to address
- arg1, arg2, ... (Number, String)
	Number and string data to be sent

StartNetAdvertise
-------------------
### Synopsis
	StartNetAdvertise(id, port)
### Description
Starts the ZeroConf service allowing a named id to be discovered by other devices on the local network.
### Arguments
- id (String)
	id by which other devices can discover this service
- port (Number)
	port number to advertise

StartNetDiscovery
-------------------
### Synopsis
	StartNetDiscovery(id)
### Description
Starts the ZeroConf service discovery, allowing to find if the service with a specific ID is present or not. Will trigger OnNetConnect when the service appears and OnNetDisconnect when the service disappears.
### Arguments
- id (String)
	id by which other devices can discover this service

[urMus API Overview](overview.html)

 