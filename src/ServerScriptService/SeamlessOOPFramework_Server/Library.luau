-- Please note that this library has been heavily modified from the original in order to protect the source of the project for re-distribution.

-- Establish library and core variables
local Library = {
	Version = '1.1.0',
	Authors = 'Vanguard, UncleTyrone',
	Connections = {},
	Threads = {},
	OriginalProperties = {},
	Debug = true,
}

-- Types
type AnimationOptions = { 
	['Property']: 'BackgroundColor3' | 'Color' | 'Size' | 'Position' | 'Visible' | 'ZIndex' | 'AnchorPoint' | 'BackgroundTransparency' | 'ImageTransparency' | 'TextTransparency' | 'TextStrokeTransparency' | 'GroupTransparency' | 'Thickness' | 'Transparency' | 'ImageColor3' | 'Rotation',
	['Goal']: Color3 | UDim2 | number | string
}
type GuiObjectList = { [number]: GuiObject }
type Monetization = { [number]: string }
type Table = { [any]: any }
type Script = LuaSourceContainer

-- Services
Library.Players = game:GetService('Players')
Library.GroupService = game:GetService('GroupService')
Library.ReplicatedStorage = game:GetService('ReplicatedStorage')
Library.ServerScriptService = game:GetService('ServerScriptService')
Library.ServerStorage = game:GetService('ServerStorage')
Library.StarterGui = game:GetService('StarterGui')
Library.TweenService = game:GetService('TweenService')
Library.UserInputService = game:GetService('UserInputService')
Library.SoundService = game:GetService('SoundService')
Library.HttpService = game:GetService('HttpService')
Library.MarketplaceService = game:GetService('MarketplaceService')

-- Establish library functions
function Library:GetVersion()
	return Library.Version
end

function Library:UniqueID()
	return self.HttpService:GenerateGUID(false)
end

function Library:Connection(Connection : RBXScriptConnection)
	local UniqueID = self:UniqueID()

	Library.Connections[UniqueID] = Connection

	return UniqueID
end

function Library:Thread(Thread : thread)
	local UniqueID = self:UniqueID()

	Library.Threads[UniqueID] = Thread

	return UniqueID
end

function Library:CancelThread(ThreadId : string)
	local Thread = Library.Threads[ThreadId]

	if Thread then
		task.cancel(Thread)
	else
		Library:Warn(script, 'No thread found for ID: [' .. ThreadId .. ']')
	end
end

function Library:GetPlayerAttribute(Player : Player, AttributeName : string)
	if AttributeName then
		local Attribute = Player:GetAttribute(AttributeName)

		if Attribute then
			return Attribute
		else
			return false
		end
	else 
		Library:Warn(script, 'Attribute name not found!')
	end

	return false
end

function Library:AttributeSignal(Player: Player, AttributeName : string)
	local AttributeSignal = Player:GetAttributeChangedSignal(AttributeName)

	return AttributeSignal
end

function Library:Warn(Source : Script, Text : string)
	if Library.Debug == true then
		warn('[Seamless OOP Framework] ' .. Source.Name .. ' | ' .. Text)
	end
end

function Library:GetPfp(Player : Player | number, Size : Enum.ThumbnailSize)
	if typeof(Player) == 'Instance' then
		return Library.Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Size)
	elseif typeof(Player) == 'number' then
		return Library.Players:GetUserThumbnailAsync(Player, Enum.ThumbnailType.HeadShot, Size)
	end

	return false
end

function Library:ConvertToTime(Minutes : number)
	local Days = math.floor(Minutes / 1440)
	local Remainder = Minutes % 1440

	local Hours = math.floor(Remainder / 60)
	local ActualMinutes = Remainder % 60

	return {
		['Days'] = Days,
		['Hours'] = Hours,
		['Minutes'] = ActualMinutes,
	}

end

function Library:Setup()
	print('Loaded Seamless OOP Framework / v'.. self:GetVersion() .. '\n Enjoy! Made with love by ' .. Library.Authors)

	return true
end

function Library:Init()
	game.Close:Connect(function()
		for _, Thread in pairs(self.Threads) do
			task.cancel(Thread)
		end

		for _, Connection in pairs(self.Connections) do
			Connection:Disconnect()
		end
	end)
end

return Library