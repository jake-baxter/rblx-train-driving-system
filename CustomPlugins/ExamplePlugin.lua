--[[
	// FileName: ExamplePlugin.lua
    // An Example for makign plugins. I know its not the best.
--]]

local Plugin = {}
Plugin.GloballyAccessible = {}
Plugin.Name = "Example"
Plugin.Version = {0, 0, 1} --//Change the first two numbers to the appropiate driving, the last one is optional for plugin identification
Plugin.__index = Plugin

function Plugin.GloballyAccessible.init(superiorSelf, EventListener)
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

	return classSelf.GloballyAccessible
end


function Plugin.GloballyAccessible:OnDisable()
    if not self then
        return false
    end

    self.FunnyListener:Disconnect()

	return true
end
Plugin.init = Plugin.GloballyAccessible.init

return Plugin