Flowbox API
===========
These functions are members of any created Flowbox.

Flowbox:Name
-------
### Synopsis
    flowboxName = flowbox:Name()
### Description
Returns the name of the `flowbox` given as input
### Returns
- flowboxName (String)
    The name of the flowbox
    
Flowbox:NumIns
--------------
### Synopsis
    numIns = flowbox:NumIns()
### Description
Returns the number of inlets for this given flowbox.
### Returns
- numIns (String)
    The number of inlets for this flowbox.

Flowbox:NumOuts
---------------
### Synopsis
    numOuts = flowbox:NumOuts()
### Description
Returns the number of outlets for this given flowbox.
### Returns
- numOuts (String)
    The number of outlets for this flowbox.

Flowbox:Ins
--------------
### Synopsis
    insName1, insName2, ... insNameN = flowbox:Ins()
### Description
Returns the names of N flowbox inputs.
### Returns
- `insName1 .. insNameN` (String)
    Name of the input flowboxes. 

Flowbox:Outs
---------------
### Synopsis
    outName1, outName2, ... = flowbox:Outs()
### Returns
- `outName1, outName2, ...` (String)
    Returns the anems of the flowbox outputs.

Flowbox:SetPushLink
-------------------
### Synopsis
    didLink = flowbox:SetPushLink(outIndex, targetObject, targetInIndex)
### Description
Adds a link between the this flowbox's outIndex to the targetObject's inIndex.
In other words, updates from this flowbox's output will be sent to the target 
object's input. 
### Arguments
- `outIndex` (Number)
    Index number with which we desire to connect our flowbox outwards.
- `targetObject` (Flowbox)
- `targetInIndex` (Number)
    The input index number of the target which we desire to link up to.

### Returns
- `didLink` (Boolean)
    True if a push link was successfully created between the two; false if an error
    occurred. This would happen if the outIndex for this flowbox was invalid or 
    the in index for the target was invalid. 

### Note
Equivalent functionality can be achieved by using outlet member function API flowbox.out:SetPush(flowbox.in). This version of the API is still active but is discouraged from use because it is a candidate for deprication.

Flowbox:SetPullLink
-------------------
### Synopsis
    didLink = flowbox:SetPullLink(inIndex, targetObject, targetOutIndex)
### Description
Adds a pull link between the this flowbox's input index to the targetObject's output
index.
### Arguments
- `inIndex` (Number)
    Index number for this flowbox to receive pull events from.
- `targetObject` (Flowbox)
- `targetOutIndex` (Number)
    The output index number of the target which will send out pull events.

### Returns
- `didLink` (Boolean)
    True if a pull link was successfully created between the two; false if an error
    occurred. This would happen if the inIndex for this flowbox was invalid or 
    the outIndex for the target was invalid. 

### Note
Equivalent functionality can be achieved by using inlet member function API flowbox.in:SetPull(flowbox.out). This version of the API is still active but is discouraged from use because it is a candidate for deprication.

Flowbox:RemovePushLink
----------------------
### Synopsis
    didRemoveLink = flowbox:RemovePushLink(outIndex, targetObject, targetInIndex)
### Description
Removes a link between the this flowbox's outIndex to the targetObject's inIndex.
### Arguments
- `outIndex` (Number)
    Output index of our connected link for this flowbox.
- `targetObject` (Flowbox)
- `targetInIndex` (Number)
    The input index number of the target which is linked up to.

### Returns
- `didRemoveLink` (Boolean)
    True if a push link was successfully removed; false if an error
    occurred. This would happen if the outIndex for this flowbox was invalid or 
    the in index for the target was invalid.

### Note
Equivalent functionality can be achieved by using outlet member function API flowbox.out:RemovePush(flowbox.in). This version of the API is still active but is discouraged from use because it is a candidate for deprication.

Flowbox:RemovePullLink
----------------------
### Synopsis
    didRemoveLink = flowbox:RemovePullLink(inIndex, targetObject, targetOutIndex)
### Description
Removes a pull link between the this flowbox's input index to the targetObject's output
index.
### Arguments
- `inIndex` (Number)
    Index number for this flowbox to receive pull events from.
- `targetObject` (Flowbox)
- `targetOutIndex` (Number)
    The output index number of the target which will send out pull events.

### Returns
- `didRemoveLink` (Boolean)
    True if a pull link was successfully removed; false if an error
    occurred. This would happen if the inIndex for this flowbox was invalid or 
    the outIndex for the target was invalid.

### Note
Equivalent functionality can be achieved by using inlet member function API flowbox.in:RemovePull(flowbox.out). This version of the API is still active but is discouraged from use because it is a candidate for deprication.

Flowbox:IsPushed
----------------
### Synopsis
    isPushed = flowbox:IsPushed(outIndex, targetObject, targetInIndex)
### Returns
- `isPushed` (Boolean)
    Returns whether the given tuple of (outIndex, target, and targetInIndex) is currently
    being pushed or not.

Flowbox:IsPulled
----------------
### Synopsis
    isPulled = flowbox:IsPulled(inIndex, targetObject, targetOutIndex)
### Returns
- `isPulled` (Boolean)
    Returns whether the given tuple of (inIndex, targetObject, targetOutIndex) is currently
    being pushed or not.

Flowbox:IsPushing
-----------------
### Synopsis
    isPushing = flowbox:IsPushing(index)
### Returns
- `isPushing` (Boolean)
    Whether the given flowbox is pushing out of the given index.

Flowbox:IsPulling
-----------------
### Synopsis
    isPulling = flowbox:IsPulling(index)
### Returns
- `isPulling` (Boolean)
    Whether the given flowbox is currently pulling into the given index.

Flowbox:Push
------------
### Synopsis
    flowbox:Push(data)
### Description
Pushes out a given value to all the flowbox's outs. Currently only well defined for the Push flowbox.
### Arguments
- `data` (Number)
    The data to be output to the given flowbox.

Flowbox:Get
-----------
### Synopsis
	data = flowbox:Get()
### Description
Gets the latest data received from a self-clocking sink. Currenly only well defined for the Vis flowbox.
### Returns
- `data` (Number)
	The last data entry pulled by the flowbox.

Flowbox:Pull
------------
### Synopsis
	data = flowbox:Pull()
### Description
Pulls the dataflow and returns the data received. Currenly only well defined for the Pull flowbox.
### Returns
- `data` (Number)
	The data entry pulled by the flowbox.

Flowbox:AddFile
---------------
### Synopsis
	flowbox:AddFile(filename)
### Description
Adds a sound file to the file stack of a flowbox. Currently only well defined for the Sample flowbox.
### Arguments
- `filename` (String)
	The filename of the sound file to be loaded.

Flowbox:IsInstantiable
----------------------
### Synopsis
    isInstantiable = flowbox:IsInstantiable()
### Returns
- `isInstantiable` (Boolean)
    Whether this flowbox type can be instantiated or not.

Flowbox:InstanceNumber
-------------------------
### Synopsis
    number = flowbox:InstanceNumber()
### Description
Returns the instance number of the flowbox. This is a monotonically increasing 
number assigned to each instantiated flowbox, and can be used to uniquely 
identify itself.
### Returns
- `number` (Number) 
    This flowbox's unique identifier.

Flowbox:NumberInstances
-----------------------
### Synopsis
    numInstances = flowbox:NumberInstances()
### Description
### Returns
- `numInstances` (Number)
    The total number of instances instantiated for this flowbox. 
  
Flowbox:Couple
-----------------
### Synopsis
	in, out = flowbox:Couple()
### Description
Returns which in and out index are coupled (that is will propagate frame rates.) Returns nil if no couple exists.
### Return
- `in` (Number)
	The index of the inlet which is coupled to the outlet.
- `out` (Number)
	The index of the outlet which is coupled to the inlet.

Flowbox:IsCoupled
-----------------
#Synopsis
	iscoupled = flowbox:Couple()
### Description
Returns if the flowbox has a coupled pair (i.e. an inlet/outlet pair which will propagate frame rates).
### Return
- `iscoupled` (Boolean)
	Returns true if there exists an inlet/outlet pair which is coupled.

Flowbox Inlet API
===========
These functions are members of any inlet of a Flowbox. The names of the inlets are specified by the flowbox itself and can be found as part of the [specification of flowboxes](FlowboxList.html).

Flowbox.in:SetPull
-------------------
### Synopsis
    didLink = flowbox.in:SetPull(flowbox2.out)
### Description
Adds a pull link between the this flowbox's input in to the flowbox2's output
out.
### Arguments
- `in` (inlet)
   The name of the inlet of flowbox
- `flowbox2` (Flowbox)
- `out` (outlet)
   The name of the outlet of flowbox2

### Returns
- `didLink` (Boolean)
    True if a pull link was successfully created between the two; false if an error
    occurred. 

### Note
Requires V1.0 or later. Equivalent functionality can be achieved by using function API flowbox.SetPullLink(). This version of the API is recommended as the other alternative is a candidate for deprication.

Flowbox.in:RemovePull
----------------------
### Synopsis
    didRemoveLink = flowbox.in:RemovePull(flowbox2.out)
### Description
Removes a pull link between the this flowbox's input in to flowbox2's output
out.
### Arguments
- `in` (inlet)
   The name of the inlet of flowbox
- `flowbox2` (Flowbox)
- `out` (outlet)
   The name of the outlet of flowbox2

### Returns
- `didRemoveLink` (Boolean)
    True if a pull link was successfully removed; false if an error
    occurred.

### Note
Requires V1.0 or later. Equivalent functionality can be achieved by using function API flowbox.RemovePullLink(). This version of the API is recommended as the other alternative is a candidate for deprication.

Flowbox Outlet API
===========
These functions are members of any outlet of a Flowbox. The names of the outlets are specified by the flowbox itself and can be found as part of the [specification of flowboxes](FlowboxList.html).

Flowbox.out:SetPush
-------------------
### Synopsis
    didLink = flowbox.out:SetPush(flowbox2.in)
### Description
Adds a push link between the this flowbox's output out to the flowbox2's input
in.
### Arguments
- `out` (outlet)
   The name of the outlet of flowbox
- `flowbox2` (Flowbox)
- `in` (inlet)
   The name of the inlet of flowbox2

### Returns
- `didLink` (Boolean)
    True if a push link was successfully created between the two; false if an error
    occurred.

### Note
Requires V1.0 or later. Equivalent functionality can be achieved by using function API flowbox.SetPushLink(). This version of the API is recommended as the other alternative is a candidate for deprication.

Flowbox.out:RemovePush
----------------------
### Synopsis
    didRemoveLink = flowbox.out:RemovePush(flowbox2.in)
### Description
Removes a push link between this flowbox's input in to flowbox2's output
out.
### Arguments
- `out` (outlet)
   The name of the outlet of flowbox
- `flowbox2` (Flowbox)
- `in` (inlet)
   The name of the inlet of flowbox2

### Returns
- `didRemoveLink` (Boolean)
    True if a push link was successfully removed; false if an error
    occurred.
    
### Note
Requires V1.0 or later. Equivalent functionality can be achieved by using function API flowbox.RemovePushLink(). This version of the API is recommended as the other alternative is a candidate for deprication.

[urMus API Overview](overview.html)
