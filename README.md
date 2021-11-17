# A Roblox Train Driving System - A Simple Driving System for anyone

This repository is based around a Roblox Train Driving system for anyone, no matter scripting knowledge, to use and play with.
If you'd like to get straight on with it, a .rbxm is provided in the releases, but its best you read the below.

If you are a programmer wishing to help contribute to this repository, please read down at the bottom of this.

# YouTube Video

To be updated

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
```

You can then used the returned table by .new()  to call other functions or register RBXScriptConnections

A full example:
```
local TrainModule = require(game:GetService("ServerStorage"):WaitForChild("TrainModule"))
local newTrain = TrainModule.new(
    script.Parent,
    {
        "vehicleSeat": script.Parent.Front.VehicleSeat, --Vehicle Seat Reference
        "basePart": script.Parent.Front.BasePart, --Base Part Reference
        "throttle": 5, -- 5 Throttle notches
        "brake": 3, -- 3 brake notches
        "throttlePower": 3, -- 3 studs per second accel at max throttle
        "brakePower": 5, -- 5 studs per second deccel at max brake
        "throttleFullTime": 5, -- 5 seconds to get to full throttle from idle
        "throttleIdleTime": 2, -- 2 seconds to get to idle from full
        "brakeFullTime": 3, -- 3 seconds to get to full from released
        "brakeIdleTime": 3, -- 3 seconds to get to released (idle) to full
        "maxSpeed": 60, -- 60 studs is maximum speed
        "GUI": game:GetService("ServerStorage"):WaitForChild("TrainUI1"), -- ScreenGUI object for train
        "customModules": {
            game:GetService("ServerStorage"):WaitForChild("TrainModule"):WaitForChild("SoundSystem")  --Custom modules for customisation for driving system
        },
        "SoundSystemModType": "Loco" -- This is custom and will probably not be sound system setup
    }
)
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

### ```:SendMessage(moduleName, Table)``` - Sends a message server side.

`moduleName`  String Value of module name to send a message to or on behalf.

`Table`  Table of what you want to send

returns `bool` - Always true if no errors

### ```:SendPlayerMessage(moduleName, Table)``` - Sends a message to the driver player.

`moduleName`  String Value of module name to send a message to or on behalf.

`Table`  Table of what you want to send

returns `bool` - True if sent, false if not.

# Train Input Data
This systems .new() function relies on a table being inputted as a second argument. These values can be put into the train input data table argument.

Value will be followed by value type. * means required, " is recommended

`basestud`(float - 1)" - Edit how a stud is measured in the system (e.g. convert to mph)

`basePart`(object)* - Object value that controls train movement (BodyVelocity will be made by system automatically)

`revBasePart`(object - nil) - Object value that controls train movement when reversed (BodyVelocity will be made by system automatically)

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

`customModules`(table)* - A table of module script references of modules to use, e.g. `{script.SoundSystem, game.ServerStorage.Modules.CustomGUI}`

