# A Roblox Train Driving System - A Simple Driving System for anyone

**Join the discord for updates and to properly get involved in the community: [https://discord.gg/M5cK54vKWK](https://discord.gg/M5cK54vKWK)**

This repository is based around a Roblox Train Driving system for anyone, no matter scripting knowledge, to use and play with.
If you'd like to get straight on with it, a .rbxm is provided in the releases, but its best you read the below.

If you are a programmer wishing to help contribute to this repository, please read down at the bottom of this.

For a place example please see the releases.

# Keyboard Controls in base driving system

`w` Throttle up

`s` Throttle down

`a` Brake up

`d` Brake down

# YouTube Video

[![A Tutorial](http://img.youtube.com/vi/wZHNsduTllg/0.jpg)](http://www.youtube.com/watch?v=wZHNsduTllg)

# Installation
To get a stable release, head to [this page](https://github.com/jake-baxter/rblx-train-driving-system/releases) this page and download a version with a stable tag.

Other versions ending with -alpha or -beta are unstable and better for simple users not to play with.

Instructions for downloading/updating will be provided with this release.

Unextract the zip file and open the readme.txt file, which will provide installation instructions.

Then import all the required .rbxms in the "required" folder, and then optional ones in the "modules" folder.

If you need a tutorial on how to do this, go up to the youtube header above.

# Setting up the train
Create a new script within the train.

You then call ```require()``` to the location of the script. Then respectively call the new function on it, see the new function area below for it.

Example:
```
local TrainModule = require(game:GetService("ServerStorage"):WaitForChild("TrainModule"))
local newTrain = TrainModule.new(
    ...
)
newTrain:UnanchorTrain()
```

You can then used the returned table by .new()  to call other functions or register RBXScriptConnections

A full example:
```
local TrainModule = require(game:GetService("ServerStorage"):WaitForChild("TrainModule"))
local newTrain = TrainModule.new(script.Parent,
	{
		vehicleSeat = script.Parent.Front.VehicleSeat, --Vehicle Seat Reference
		basePart = script.Parent.Front.BasePart, --Base Part Reference
		throttle = 5, -- 5 Throttle notches
		brake = 3, -- 3 brake notches
		throttlePower = 3, -- 3 studs per second accel at max throttle
		brakePower = 5, -- 5 studs per second deccel at max brake
		throttleFullTime = 5, -- 5 seconds to get to full throttle from idle
		throttleIdleTime = 2, -- 2 seconds to get to idle from full
		brakeFullTime = 3, -- 3 seconds to get to full from released
		brakeIdleTime = 3, -- 3 seconds to get to released (idle) to full
		maxSpeed = 60, -- 60 studs is maximum speed
		GUI= game:GetService("ServerStorage"):WaitForChild("TrainUI1"), -- ScreenGUI object for train
		customModules = {
			game:GetService("ServerStorage"):WaitForChild("TrainModule"):WaitForChild("SoundSystem")  --Custom modules for customisation for driving system
		},
		SoundSystemModType = "Loco" -- This is custom and will probably not be sound system setup
	}
)
newTrain:UnanchorTrain()

```

# Functions

## Direct Require
### ```.new(trainModel, inputTrainData)``` - Makes a new train using API

`trainModel`  Object Value of Train Model

`inputTrainData`  Table of Train Input Data (see section below)

returns `classSelf` - Dictionary of train Functions and values


## Train Functions
### ```:GetDriver()``` - Gets the current driver

returns `player` - Player object of driver

### ```:EnableModule(moduleReference)``` - Enables a Module

`moduleReference`  Object Value of appropiate module script

returns `bool` - True/False if enabled or not

### ```:DisableModule(moduleName)``` - Disables a Module

`moduleName`  String Value of model name

returns `bool` - True/False if enabled or not

### ```:GetModule(moduleName)``` - Disables a Module

`moduleName`  String Value of model name

returns `table` - Functions and variables the developer of the plugin gives you

### ```:SendMessage(moduleName, Table)``` - Sends a message server side.

`moduleName`  String Value of module name to send a message to or on behalf.

`Table`  Table of what you want to send

returns `bool` - Always true if no errors

### ```:SendPlayerMessage(moduleName, Table)``` - Sends a message to the driver player.

`moduleName`  String Value of module name to send a message to or on behalf.

`Table`  Table of what you want to send

returns `bool` - True if sent, false if not.

### ```:GetClientEventConnection()``` - Gets the connection Remote Event for players.

returns `RBXScriptConnection` - Connection that you can connect to for events

### ```:GetServerEventConnection()``` - Gets the connection Server Event.

returns `RBXScriptConnection` - Connection that you can connect to for events

### ```:UnanchorTrain()``` - Unanchors the train

returns `bool` - Always true

### ```:AnchorTrain()``` - Anchors the train

returns `bool` - Always true

### ```:IsAnchored()``` - Returns if anchored

returns `bool` - Returns if anchored or not.

### ```:DisableDefaultUI()``` - Disables the default UI

returns `bool` - Returns true

### ```:EnableDefaultUI()``` - Enables the default UI

returns `bool` - Returns true

### ```:IterateBodyVelocity(function(BodyVelocity))``` - Fires a function for each body velocity. Add a function in params and in the params for the function inside has BodyVelocityParams.

returns `nil` - Returns  nil 



### ```:IterateBaseParts(function(BasePart))``` - Fires a function for each Base Part. Add a function in params and the function will be called with one parameter which is the base part..

returns `nil` - Returns  nil 



### ```:GetProperty(PropertyName)``` - Returns property value

returns `any` - Returns  property val. Can be Nil!!

# Train Input Data
This systems .new() function relies on a table being inputted as a second argument. These values can be put into the train input data table argument.

Value will be followed by value type. * means required, " is recommended

`basestud`(float - 1)" - Edit how a stud is measured in the system (e.g. convert to mph)

`baseParts`(object or table)* - Object value or table of lots of base parts that controls train movement (BodyVelocity will be made by system automatically)

`vehicleSeat`(object)* - Object value to seat or vehicle seat to sit in

`revVehicleSeat`(object - nil) - Object value to reversible seat or vehicle seat to sit in 

`throttle`(int)* - Throttle Notches

`brake`(int)* - Brake Notches

`throttlePower`(float)* - Amount of acceleration at top throttle

`brakePower`(float)* - Amount of decceleration at top brake

`throttleFullTime`(float)* - Seconds from idle to full throttle

`throttleIdleTime`(float)* - Seconds from full to idle throttle

`brakeFullTime`(float)* - Seconds from idle to full brake

`brakeIdleTime`(float)* - Seconds from full to idle brake

`maxSpeed`(float)* - Maximum speed of train

`bodyVelocityP`(float - 1250) - Body Velocity P value (lower if having issues where train flies or goes through rails)

`MaxPower`(float - 50000) - Power in the system to help get velocity up (lower if having issues where train flies or goes through rails)

`GUI`(object)* - ScreenGUI object to work the train.

`customModules`(table)" - A table of module script references of modules to use, e.g. `{script.SoundSystem, game.ServerStorage.Modules.CustomGUI}`

`debugMode` (bool) - Creates a frame inside the GUI with live train information. @bobsterjsdev

# Server Events
There isn't many server events to currently listen to, but you can use the :GetServerEventConnection() if you really need to.

Events are issued in module name then table. ```ModuleName, SentData```

These events currently work (module name, table):

`base` - `{{class = self, action = "DriverIn", player = player, UI = tempPlayerGui}}` - Listen Only - Fires when player enters

`base` - `{class = classSelf, action = "DriverOut"}` - Listen Only - Fires when player leaves

Feel free to use this for your own plugins and chose new module names for them.

# Reporting issues
If there is an issue please use the issues heading to report and give error traces and make sure your scripts are written correctly. If it is a custom plugin that comes with the download please also mention this.

# Want to contribute?
You want to contribute? Cool. Make a pull request to dev branch with your contributions and give details of what you have included in the new update. At the top you must also include the following header and fill in the appropiate if you are making a plugin:

```
--[[
	// FileName: [SCRIPT NAME].lua
	// Written by: [AUTHORS]
	// Version: [This will be changed by Jake]
	// Description: [Include description of script]

	// Contributors:
        [Insert appropiate contributors.]

	// Note: [Any appropiate notes]
--]]
```

Use the appropiate API functions to perform actions, you can also add your own train input.

When making your own functions using events make sure to assign it a new ModuleName relevant to the plugin.

A ModuleScript plugin layout:
```
local Plugin = {}
Plugin.GloballyAccessible = {}
Plugin.Name = "Your very cool plugin"
Plugin.Version = {0, 0, 0} --//Change the first two numbers to the appropiate driving, the last one is optional for plugin identification
Plugin.__index = Plugin

function Plugin.GloballyAccessible.init(superiorSelf, EventListener)
	local classSelf = {}
	setmetatable(classSelf, Plugin)

	--// do work

	return classSelf.GloballyAccessible
end


function Plugin.GloballyAccessible:OnDisable()
    if not self then
        return false
    end

	--// do work

	return true
end
Plugin.init = Plugin.GloballyAccessible.init
return Plugin
```