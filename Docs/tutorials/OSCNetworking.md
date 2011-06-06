OSC Networking and ZeroConf
=======

* * * * *
In this tutorial we see how we can create network communication in urMus. The main means is through the OSC standard protocol.
Sending OSC messages is very easy. All we need to do is use the SendOSCMessage() command.
Receiving is just slightly more complicated. We create a region which handles 
OnOSCMessage event. This event triggers when an OSC message is incoming, with the arguments being the OSC content that was sent.
When we start the OSC listener it will become possible for the event to occur. StartOSCListener also returns our own host IP address, which in this example
we use to send a message to ourselves.
When you run this you should see a debug message saying OSC: 0.45 or close enough.

	r = Region()
	
	-- We register this function to be called when a network traffic is incoming
	function gotOSC(self, num)
		DPrint("OSC: ".. num)
	end
	
	r:Handle("OnOSCMessage",gotOSC)
	
	SetOSCPort(8888)
	host,port = StartOSCListener()
	SendOSCMessage(host,8888,"/urMus/numbers",0.45)

Next let's do some real networking. In this example we are going to control the color of a rectangle on the display of another device.
Change the ip number of the host2 variable to the IP of another urMus running (and vice versa)
Run the below example on both devices. If you touch the rectangle and release, the rectangle on the other device should turn green and red respectively.

	local host2 = "192.168.1.1"
	
	function SendUp(self)
		SendOSCMessage(host2,8888,"/urMus/numbers",0.0)
	end
	
	function SendDown(self)
		SendOSCMessage(host2,8888,"/urMus/numbers",1.0)
	end
	
	r = Region()
	r:SetWidth(ScreenWidth()/2)
	r:SetHeight(ScreenHeight()/2)
	r.t = r:Texture()
	r.t:SetTexture(255,0,0,255)
	r:SetAnchor("CENTER",UIParent,"CENTER", 0,0)
	r:Show()
	r:Handle("OnTouchUp",SendUp)
	r:Handle("OnTouchDown",SendDown)
	r:EnableInput(true)
	
	function gotOSC(self, num)
		DPrint("OSC: ".. num)
		r.t:SetSolidColor(255*num,255*(1-num),0,255)
	end
	
	r:Handle("OnOSCMessage",gotOSC)
	
	SetOSCPort(8888)
	host, port = StartOSCListener()

Next a slightly more complicated example showing continuous streaming of accelerometer data which comes from an urMus patch. The patch of course could be much more complicated.

	FreeAllRegions()
	
	local freeze
	
	function SendUp(self)
		freeze = nil
		SendOSCMessage(host,8888,"/urMus/numbers",0.0)
	end
	
	function SendDown(self)
		freeze = true
		SendOSCMessage(host,8888,"/urMus/numbers",1.0)
	end
	
	r = Region()
	r:SetWidth(ScreenWidth()/2)
	r:SetHeight(ScreenHeight()/2)
	r.t = r:Texture()
	r.t:SetTexture(255,0,0,255)
	r:SetAnchor("CENTER",UIParent,"CENTER", 0,0)
	r:Show()
	r:Handle("OnTouchUp",SendUp)
	r:Handle("OnTouchDown",SendDown)
	r:EnableInput(true)
	
	function gotOSC(self, num)
		DPrint("OSC: ".. num)
		r.t:SetSolidColor(255*num,255*(1-num),0,255)
	end
	
	function getInput(self, elapsed)
		data = FBVis:Get()
		if not freeze then
			SendOSCMessage(host,8888,"/urMus/numbers",data)
		end
	end
	
	FBAccel:SetPushLink(0,FBVis,0)
	
	r:Handle("OnOSCMessage",gotOSC)
	r:Handle("OnUpdate", getInput)
	
	SetOSCPort(8888)
	host, port = StartOSCListener()

The next example shows how to send more complex OSC messages. UrMus currently does not support the full vocabulary of complex OSC message, but two of the most frequent types. You can either send a string, or you can send a chain of number. UrMus understands two OSC patterns /urMus/numbers, and /urMus/text. The will expect one or more numbers, the second expect one text string.

	FreeAllRegions()
	
	function SendUp(self)
		SendOSCMessage(host,port,"/urMus/numbers",0.0,0.25,0.5,0.75,1.0)
	end
	
	function SendDown(self)
		SendOSCMessage(host,port,"/urMus/numbers",1.0,0.75,0.5,0.25,0.0)
	end
	
	function SendID(self)
		SendOSCMessage(host,port,"/urMus/text","test")
	end
	
	r = Region()
	r:SetWidth(ScreenWidth()/2)
	r:SetHeight(ScreenHeight()/2)
	r.t = r:Texture()
	r.t:SetTexture(255,0,0,255)
	r:SetAnchor("CENTER",UIParent,"CENTER", 0,0)
	r:Show()
	r:Handle("OnTouchUp",SendUp)
	r:Handle("OnTouchDown",SendDown)
	r:Handle("OnLeave",SendID)
	r:EnableInput(true)
	
	function gotOSC(self, num, num2, num3, num4, num5)
		if type(num) == "string" then
			DPrint("OSC String: "..num)
		else
			DPrint("OSC: ".. num.." "..(num2 or "nil").." "..(num3 or "nil").." "..(num4 or "nil").." "..(num5 or "nil"))
			r.t:SetSolidColor(255*num,255*(1-num),0,255)
		end
	end
	
	r:Handle("OnOSCMessage",gotOSC)
	
	SetOSCPort(8888)
	host,port = StartOSCListener()
	DPrint("OSC: "..host..":"..port)

As you may have already noticed, it can be very tedious to connect to a specific device because one has to know its address.
urMus supports zeroconf networking which helps solve this problem elegently
ZeroConf allows one to advertise itself on the network and be discovered conveying the ip address in the process.
With StartNetAdvertise() we can advertise an ID on the network, which can be discovered using StartNetDiscovery(ID). This service is incidentally discoverable by any service that complies to the BonJour standard.
When a discoverable service appears the OnNetConnect event will trigger. If the same service disappears, OnNetDisconnect triggers.

If you test this with another person, make sure that you advertise what they discover and vice versa. So for example you may advertise myid and discover myid2 and they advertise myid2 and discover myid.

	FreeAllRegions()
	
	local function NewConnection(self, name)
		DPrint("Connect: "..name)
	end
	
	local function LostConnection(self, name)
		DPrint("Disconnect: "..name)
	end
	
	r = Region()
	
	r:Handle("OnNetConnect", NewConnection)
	r:Handle("OnNetDisconnect", LostConnection)
	
	StartNetAdvertise("myid",8889)
	StartNetDiscovery("myid2")

Now we have covered all the basics of networking in urMus, we have learned how to discover devices and then exchange information between them using OSC.
