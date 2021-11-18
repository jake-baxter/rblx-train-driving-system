--[[
	// **READ-ONLY**
	// FileName: LocalRun.lua
	// Written by: Jake Baxter
	// Version v0.0.0-alpha
	// Description: Local Script for Train Control (UI)

	// Contributors:
		
	

	// Required by:
		Local Players

	// Note: LOCAL SCRIPTS ONLY.
--]]


--//Variables
local VehicleSeat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
local RemoteClientEvent = VehicleSeat["PlayerRemoteEvent"] --//At the top to cause an error if not.
local Velocity = 0
local RawSelf = {}
local finishedInit = false

--//Init function
VehicleSeat.AncestryChanged:connect(function()
    script.Parent:Destroy()
end)

VehicleSeat.ChildRemoved:connect(function(child)
    if not (child.Name == "SeatWeld") then
        return false
    end
    script.Parent:Destroy()
end)

local tempFunction = function() end
tempFunction = RemoteClientEvent.OnClientEvent:connect(function(modName, classSelf)
    if not (modName == "Register") then
        return
    end

    RawSelf = classSelf
    finishedInit = true
    tempFunction:Disconnect()
end)
RemoteClientEvent:FireServer("Register", {})

repeat task.wait(1) until finishedInit --// We don't want to continue.


local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local basePart = RawSelf["basePart"]
local revBasePart = RawSelf["revBasePart"]
local throttle = RawSelf["throttle"]
local brake = RawSelf["brake"]
local throttlePower = RawSelf["throttlePower"]
local brakePower = RawSelf["brakePower"]
local throttleFullTime = RawSelf["throttleFullTime"]
local throttleIdleTime = RawSelf["throttleIdleTime"]
local brakeFullTime = RawSelf["brakeFullTime"]
local brakeIdleTime = RawSelf["brakeIdleTime"]
local isReversed = RawSelf["reversed"]
local generalPower = RawSelf["MaxPower"]
local maxSpeed = RawSelf["MaxPower"]
local baseStud = RawSelf["baseStud"]
local developerMode = RawSelf["rawData"]["debugMode"]


local targettedThrottle = 0
local targettedBrake = 0
local currentThrottle = 0
local currentBrake = 0

local debounce = {}
debounce.up = false
debounce.down = false
debounce.keyboardsliderup = false
debounce.keyboardsliderdown = false
debounce.touchsliderup = false
debounce.touchsliderdown = false


--//TO EDIT IF NECESARRY
local setVelocity = function()
    if isReversed == false then
        --//This uses hhwheats simple driving calculations. Change if you wish.
        local vectorpower = generalPower*basePart.CFrame.lookVector
        basePart["BodyVelocity"].MaxForce = Vector3.new(vectorpower.X>0 and vectorpower.X or -vectorpower.X,
            vectorpower.Y>0 and vectorpower.Y or -vectorpower.Y,
            vectorpower.Z>0 and vectorpower.Z or -vectorpower.Z
        )
        basePart["BodyVelocity"].Velocity = (Velocity)*basePart.CFrame.lookVector
    end
end

local function UpdateStatistics(delta)
	if currentThrottle > targettedThrottle then
		currentThrottle = math.clamp(currentThrottle - ((delta) / throttleIdleTime), 0, 1) -- down
		if currentThrottle < targettedThrottle then
			currentThrottle = targettedThrottle
		end
	end
	if currentThrottle < targettedThrottle then
		currentThrottle = math.clamp(currentThrottle + ((delta) / throttleFullTime), 0, 1) -- up
		if currentThrottle > targettedThrottle then
			currentThrottle = targettedThrottle
		end
	end
	if currentBrake > targettedBrake then
		currentBrake = math.clamp(currentBrake - ((delta) /brakeIdleTime), 0, 1) --down
		if currentBrake < targettedBrake then
			currentBrake = targettedBrake
		end
	end
	if currentBrake < targettedBrake then
		currentBrake = math.clamp(currentBrake + ((delta) /brakeFullTime), 0, 1)--up
		if currentBrake > targettedBrake then
			currentBrake = targettedBrake
		end
	end
end


local function PerformVelocityChanges(delta)
	Velocity = math.clamp((Velocity + (delta*currentThrottle*throttlePower) - (delta*currentBrake*brakePower)), 0, maxSpeed)
    if basePart.Anchored == true then
        Velocity = 0
    end
end


RunService.Heartbeat:connect(function(delta)
    UpdateStatistics(delta)
    PerformVelocityChanges(delta)
    setVelocity()
end)

UserInputService.InputBegan:connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        if debounce.up then
            return
        end
        targettedThrottle = math.clamp(targettedThrottle + (1/throttle), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.S then
        if debounce.up then
            return
        end
        targettedThrottle = math.clamp(targettedThrottle - (1/throttle), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.A then
        if debounce.down then
            return
        end
        targettedBrake = math.clamp(targettedBrake + (1/brake), 0, 1)
    end
    if input.KeyCode == Enum.KeyCode.D then
        if debounce.down then
            return
        end
        targettedBrake = math.clamp(targettedBrake - (1/brake), 0, 1)
    end
end)

if (developerMode) then
	local devModeFrame = Instance.new("Frame", script.Parent)
	devModeFrame.AnchorPoint = Vector2.new(0,1)
	devModeFrame.Position = UDim2.new(0,0,1,0)
	devModeFrame.Size = UDim2.new(0.2,0,0,100)
	local devModeThrottle = Instance.new("TextLabel", devModeFrame)
	devModeThrottle.Size = UDim2.new(1,0,0,33)
	local devModeBrake = Instance.new("TextLabel", devModeFrame)
	devModeBrake.Size = UDim2.new(1,0,0,33)
	devModeBrake.Position = UDim2.new(0,0,0,33)
	local devModeSpeed = Instance.new("TextLabel", devModeFrame)
	devModeSpeed.Size = UDim2.new(1,0,0,33)
	devModeSpeed.Position = UDim2.new(0,0,0,66)
	coroutine.wrap(function()
		while true do
			devModeThrottle.Text = "Throttle: "..tostring(currentThrottle).." - "..tostring(targettedThrottle)
			devModeBrake.Text = "Brake: "..tostring(currentBrake).." - "..tostring(targettedBrake)
			devModeSpeed.Text = "Speed: "..tostring(Velocity)
			wait(.1)
		end
	end) ()
end
