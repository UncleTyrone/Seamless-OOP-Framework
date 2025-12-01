-- Please note that this library has been heavily modified from the original in order to protect the source of the project for re-distribution.

-- Establish library and core variables
local Library = {
	Version = "1.2.0",
	Authors = "UncleTyrone, Vanguard",
	Connections = {},
	Threads = {},
	OriginalProperties = {},
	Debug = true,
}

-- Types
type AnimationOptions = {
	["Property"]: "BackgroundColor3"
		| "Color"
		| "Size"
		| "Position"
		| "Visible"
		| "ZIndex"
		| "AnchorPoint"
		| "BackgroundTransparency"
		| "ImageTransparency"
		| "TextTransparency"
		| "TextStrokeTransparency"
		| "GroupTransparency"
		| "Thickness"
		| "Transparency"
		| "ImageColor3"
		| "Rotation",
	["Goal"]: Color3 | UDim2 | number | string,
}
type GuiObjectList = { [number]: GuiObject }
type Monetization = { [number]: string }
type Table = { [any]: any }
type Script = LuaSourceContainer

-- Services
Library.Players = game:GetService("Players")
Library.GroupService = game:GetService("GroupService")
Library.ReplicatedStorage = game:GetService("ReplicatedStorage")
Library.ServerScriptService = game:GetService("ServerScriptService")
Library.ServerStorage = game:GetService("ServerStorage")
Library.StarterGui = game:GetService("StarterGui")
Library.TweenService = game:GetService("TweenService")
Library.UserInputService = game:GetService("UserInputService")
Library.SoundService = game:GetService("SoundService")
Library.HttpService = game:GetService("HttpService")
Library.MarketplaceService = game:GetService("MarketplaceService")

-- Establish library functions
function Library:GetVersion()
	return Library.Version
end

function Library:UniqueID()
	return self.HttpService:GenerateGUID(false)
end

function Library:Connection(Connection: RBXScriptConnection)
	local UniqueID = self:UniqueID()

	Library.Connections[UniqueID] = Connection

	return UniqueID
end

function Library:Thread(Thread: thread)
	local UniqueID = self:UniqueID()

	Library.Threads[UniqueID] = Thread

	return UniqueID
end

function Library:CancelThread(ThreadId: string)
	local Thread = Library.Threads[ThreadId]

	if Thread then
		task.cancel(Thread)
	else
		Library:Warn(script, "No thread found for ID: [" .. ThreadId .. "]")
	end
end

function Library:GetPlayerAttribute(Player: Player, AttributeName: string)
	if AttributeName then
		local Attribute = Player:GetAttribute(AttributeName)

		if Attribute then
			return Attribute
		else
			return false
		end
	else
		Library:Warn(script, "Attribute name not found!")
	end

	return false
end

function Library:AttributeSignal(Player: Player, AttributeName: string)
	local AttributeSignal = Player:GetAttributeChangedSignal(AttributeName)

	return AttributeSignal
end

function Library:AnimateInternal(
	Object: GuiObject,
	Duration: number,
	Options: AnimationOptions,
	EasingStyle: Enum.EasingStyle,
	EasingDirection: Enum.EasingDirection,
	Autoplay: boolean
)
	local Info = TweenInfo.new(Duration, EasingStyle, EasingDirection)

	local Props = { [Options.Property] = Options.Goal }
	local Animation = self.TweenService:Create(Object, Info, Props)

	if Autoplay then
		Animation:Play()
		return
	else
		return Animation
	end
end

function Library:Animate(
	Object: GuiObject,
	Duration: number,
	PropertyString,
	GoalValue,
	Boolean: boolean,
	EasingStyle: Enum.EasingStyle,
	EasingDirection: Enum.EasingDirection
)
	if EasingStyle == nil or EasingDirection == nil then
		EasingStyle = Enum.EasingStyle.Sine
		EasingDirection = Enum.EasingDirection.In
	end

	if Object and Duration and PropertyString and GoalValue then
		if Boolean then
			self:AnimateInternal(
				Object,
				Duration,
				{ Property = PropertyString, Goal = GoalValue },
				EasingStyle,
				EasingDirection,
				Boolean
			)
		else
			self:AnimateInternal(
				Object,
				Duration,
				{ Property = PropertyString, Goal = GoalValue },
				EasingStyle,
				EasingDirection,
				true
			)
		end
	end
end

function Library:Fade(Object: GuiObject, Path: string, Duration: number)
	local Frames = {}
	local TextFrames = {}
	local ImageFrames = {}
	local Strokes = {}

	local function CheckAndInsert(PotentialFrame)
		if PotentialFrame:IsA("Frame") or PotentialFrame:IsA("ScrollingFrame") then
			table.insert(Frames, PotentialFrame)
		elseif PotentialFrame:IsA("TextBox") or PotentialFrame:IsA("TextButton") or PotentialFrame:IsA("TextLabel") then
			table.insert(TextFrames, PotentialFrame)
		elseif
			PotentialFrame:IsA("ImageLabel")
			or PotentialFrame:IsA("ImageButton")
			or PotentialFrame:IsA("ViewportFrame")
		then
			table.insert(ImageFrames, PotentialFrame)
		elseif PotentialFrame:IsA("UIStroke") then
			table.insert(Strokes, PotentialFrame)
		end
	end

	CheckAndInsert(Object)
	for _, Descendant in pairs(Object:GetDescendants()) do
		CheckAndInsert(Descendant)
	end

	local function FrameHandler(Frame, Path, Mode)
		if Path == "Out" then
			if not Library.OriginalProperties[Object] then
				Library.OriginalProperties[Object] = {}
			end
			if not Library.OriginalProperties[Object][Frame] then
				Library.OriginalProperties[Object][Frame] = {}
			end

			if Mode == "Frames" then
				Library.OriginalProperties[Object][Frame]["BackgroundTransparency"] = Frame.BackgroundTransparency
				self:Animate(Frame, Duration, "BackgroundTransparency", 1, true)
			elseif Mode == "TextFrames" then
				Library.OriginalProperties[Object][Frame]["TextTransparency"] = Frame.TextTransparency
				Library.OriginalProperties[Object][Frame]["BackgroundTransparency"] = Frame.BackgroundTransparency
				self:Animate(Frame, Duration, "TextTransparency", 1, true)
				self:Animate(Frame, Duration, "BackgroundTransparency", 1, true)
			elseif Mode == "ImageFrames" then
				Library.OriginalProperties[Object][Frame]["ImageTransparency"] = Frame.ImageTransparency
				Library.OriginalProperties[Object][Frame]["BackgroundTransparency"] = Frame.BackgroundTransparency
				self:Animate(Frame, Duration, "ImageTransparency", 1, true)
				self:Animate(Frame, Duration, "BackgroundTransparency", 1, true)
			elseif Mode == "UIStrokes" then
				Library.OriginalProperties[Object][Frame]["Transparency"] = Frame.Transparency
				self:Animate(Frame, Duration, "Transparency", 1, true)
			end
		elseif Path == "In" then
			if Library.OriginalProperties[Object] and Library.OriginalProperties[Object][Frame] then
				if not Object.Visible then
					Object.Visible = true
				end
				for GivenProperty, Value in pairs(Library.OriginalProperties[Object][Frame]) do
					self:Animate(Frame, Duration, GivenProperty, Value, true)
				end
			end
		end
	end

	local function ForEveryFrame(FrameTable, Mode)
		for _, Frame in pairs(FrameTable) do
			if Path == "Init" then
				FrameHandler(Frame, "Out", Mode)
			elseif Path == "Out" then
				FrameHandler(Frame, Path, Mode)
			elseif Path == "In" then
				FrameHandler(Frame, Path, Mode)
			end
		end
	end

	ForEveryFrame(Frames, "Frames")
	ForEveryFrame(TextFrames, "TextFrames")
	ForEveryFrame(ImageFrames, "ImageFrames")
	ForEveryFrame(Strokes, "UIStrokes")
end

function Library:InitializeFade(Object: GuiObject)
	if Object then
		Library:Fade(Object, "Init", 0)
	else
		Library:Warn(
			script,
			"InitializeFade() not provided an Object, or an invalid Object of type "
				.. typeof(Object)
				.. " when expecting type GuiObject."
		)
	end
end

function Library:Warn(Source: Script, Text: string)
	if Library.Debug == true then
		warn("[Seamless OOP Framework] " .. Source.Name .. " | " .. Text)
	end
end

function Library:GetPfp(Player: Player | number, Size: Enum.ThumbnailSize)
	if typeof(Player) == "Instance" then
		return Library.Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Size)
	elseif typeof(Player) == "number" then
		return Library.Players:GetUserThumbnailAsync(Player, Enum.ThumbnailType.HeadShot, Size)
	end

	return false
end

function Library:ConvertToTime(Minutes: number)
	local Days = math.floor(Minutes / 1440)
	local Remainder = Minutes % 1440

	local Hours = math.floor(Remainder / 60)
	local ActualMinutes = Remainder % 60

	return {
		["Days"] = Days,
		["Hours"] = Hours,
		["Minutes"] = ActualMinutes,
	}
end

function Library:Setup()
	print("Loaded Seamless OOP Framework / v" .. self:GetVersion() .. "\n Enjoy! Made with love by " .. Library.Authors)

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
