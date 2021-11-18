--[[
	// FileName: ExamplePlugin.lua
	// Written by: Jake Baxter
	// Version: v0.0.0-alpha.2
	// Description: This is an example plugin

	// Contributors:
        No one

	// Note: This is an example so you know what to do.
--]]

local Plugin = {}
Plugin.Name = "Example"
Plugin.Version = {0, 0, 1} --//Change the first two numbers to the appropiate driving, the last one is optional for plugin identification
Plugin.__index = Plugin

function Plugin.init(superiorSelf, EventListener)
	local classSelf = {}
	setmetatable(classSelf, Plugin)

	classSelf.Funny = "Funny Moment"

    classSelf.FunnyListener = EventListener:connect(function(modName, modData)
        if modName == "ExamplePlugin" then
            if type(modData) == "table" then
                print(modData["data"])
            end
        end
    end)

	return classSelf
end


function Plugin:OnDisable()
    if not self then
        return false
    end

    self.FunnyListener:Disconnect()

	return true
end


return Plugin