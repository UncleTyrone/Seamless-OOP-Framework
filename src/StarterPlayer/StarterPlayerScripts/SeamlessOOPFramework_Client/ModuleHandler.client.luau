-- Establish types
type Script = LuaSourceContainer
local Parent = script.Parent :: Instance

-- Establish component modules
local Components = Parent:WaitForChild('Components')
local Library = require(Parent:WaitForChild('Library'))
local Tasks = {}
local Registry = {}

local function RegisterModule(Module, RequiredModule)
	RequiredModule.Library = Library
	Registry[Module.Name] = RequiredModule
end

-- Handle every component module
local function HandleModule(Module : ModuleScript)

	local Success, ErrorMessage = pcall(function()
		-- Require component
		local RequiredModule = require(Module)

		if RequiredModule then
			-- Register module
			RegisterModule(Module, RequiredModule)
		else
			warn("Failed to require source for module", Module.Name.. "!")
		end
	end)

	if not Success and ErrorMessage then
		warn('Seamless OOP Framework | ' .. Module.Name .. ' failed: ' .. ErrorMessage)
	end
end

if Library then
	local LibraryLoaded = Library:Setup()

	if LibraryLoaded then
		if Library.Init then
			Library:Init()
		end

		-- Require all component modules and pass to function
		for Index, Component in pairs(Components:GetChildren()) do
			if Component:IsA('ModuleScript') then
				HandleModule(Component)
			end
		end

		-- For every component in the registry:
		for Name, Component in pairs(Registry) do
			-- If component has register function:
			if Component.Register then
				-- Register the component
				Component:Register(Registry)
			else
				-- Force override the registry if there's no registration function
				Component.Registry = Registry
			end
		end

		-- For every component in the registry:
		for Name, Component in pairs(Registry) do
			if Component.Setup then
				-- Initialize every component automatically
				local Loaded = Component:Setup()

				-- Check if module successfully initialized
				if Loaded and Library.Debug == true then
					print("Module", Name, "has successfully loaded!")
				elseif not Loaded then
					warn("Module", Name, "failed to load!")
				end
			else
				warn("Module", Name, "failed to initialize!")
			end
		end

		-- For every component in the registry:
		for Name, Component in pairs(Registry) do
			local Task = task.spawn(function()
				if Component.Init then
					-- Initialize every component automatically
					Component:Init()
				end
			end)

			table.insert(Tasks, Task)
		end
	else
		warn("VGLibrary failed to load!")
	end
else
	warn("VGLibrary failed to require source!")
end

game.Close:Connect(function()
	for _, Task in pairs(Tasks) do
		task.cancel(Task)
	end
end)