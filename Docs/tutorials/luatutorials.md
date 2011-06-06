urMus Tutorials Overview
============
This document provides step-by-step tutorials to learn the urMus lua API. They address each core part of the urMus API in simple working example code that can by copy-pasted into the urMus web-editing environment.

### Authors
This documentation was written by Patrick O'Keefe and Georg Essl. Thanks to [many many contributors](../urAPI/Credits.html)!

To get started, launch urMus. Then launch a web browser on a computer that is on the same wireless network as your mobile device. Enter the URL displayed in the top center of the urMus default screen to launch the urMus on-device editing environment.

Tutorials
===========


[Region](Regions.html)
------------
This tutorial introduces [Regions](Regions.html). They play a central role in organizing visual content, as well as receiving input-related events. This tutorial goes through the main aspects of regions, focusing on anchoring and events.

[Texture](Textures.html)
---------------
Textures provide visual detail to regions. They can be plain color, or populated from image files. They can also be drawn into or linked to a live camera feed. All these are covered in this tutorial.

[TextLabel](TextLabels.html)
---------------
TextLabel provides text display to a region. Fonts, alignments and shadows can be modified as is shown in this tutorial.

[Paging](Paging.html)
-----------
Paging allows the management of multiple independent screen spaces as well as the direction of different screen material to external projection. Here is were we learn about that!

[Flowbox](Flowboxaccess.html)
------
The [Flowbox](Flowbox.html) is the fundamental building block of urMus's dataflow engine. In this tutorial we see how we can interface to existing patches via the Push and Vis flowboxes.

[OSC and ZeroConf Networking](OSCNetworking.html)
------
UrMus offers OSC integration as well as support for discovery of network participants through the ZeroConf Bonjour standard. In this tutorial we show how these can be used.

[urMus documentation](../documentation.html)

