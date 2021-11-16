--[[
	// **READ-ONLY**
	// FileName: TrainModule.lua
	// Written by: Jake Baxter
	// Version 1.0
	// Description: An API for train control in roblox.

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

local tempFunction = function() end
local tempFunction = RemoteClientEvent.OnClientEvent:connect(function(modName, classSelf)
    if not (modName == "Register") then
        return
    end

    RawSelf = classSelf
    finishedInit = true
    tempFunction:Disconnect()
end)
RemoteClientEvent:FireServer("Register", {})

repeat task.wait(1) until finishedInit --// We don't want to continue.

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


--//TO EDIT IF NECESARRY
local setVelocity = function()
    if isReversed == false then
        --//This uses hhwheats simple driving calculations. Change if you wish.
        local vectorpower = 1*basePart.CFrame.lookVector
        basePart["BodyVelocity"].MaxForce = Vector3.new(vectorpower.X>0 and vectorpower.X or -vectorpower.X,
            vectorpower.Y>0 and vectorpower.Y or -vectorpower.Y,
            vectorpower.Z>0 and vectorpower.Z or -vectorpower.Z
        )
        basePart["BodyVelocity"].Velocity = Velocity*basePart.CFrame.lookVector
    end
end