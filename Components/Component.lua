-- Big thanks to UncleTyrone for creating the original framework and library.

-- Establish types
type Script = LuaSourceContainer
local Parent = script.Parent :: Instance
type LibraryModule = typeof(require(Parent.Parent:WaitForChild('Library')))

-- Establish local component
local Component = {}


------------------ IMPORT COMPONENTS : ------------------

-- Example for importing a component:
type TestComponent = typeof(require(Parent:WaitForChild('Component')))

type ComponentTypes = {
	-- Example for importing a component:
	Test: TestComponent,
}

------------------ END IMPORT ! ------------------


-- Initialize library and components
local Components = ({} :: any) :: ComponentTypes
local Library =	({} :: any) :: LibraryModule

-- Component:Register() is ran automatically for all loaded components
function Component:Register(Registry)
	self.Registry = Registry
end

function Component:Setup()
	-- Initialize library (injected by ModuleHandler)
	if self.Library then
		Library = self.Library
		Component.Library = Library -- Expose Library on component for external access
	else
		warn('Failed to load Seamless OOP Frameork!')

		-- Inform core handler of initialization failure
		return false
	end

	-- Initialize registry
	if self.Registry then
		for Name, Component in pairs(self.Registry) do
			Components[Name] = Component
		end
	else
		warn("Failed to register component", script.Name.. "!")

		-- Inform core handler of initialization failure
		return false
	end
	
	-- Inform core handler of successful initialization
	return true
end

function Component:TestMethod()
	print("Inter-component communication working!")
end

-- Component:Init() is ran automatically for all loaded components
function Component:Init()
	-- Example: inter-component communication
	Components.Test:TestMethod()
	
	-- Example: access library services
	print(Library.Players)
end

return Component