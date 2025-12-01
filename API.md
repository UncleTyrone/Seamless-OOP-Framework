# Seamless OOP Framework API Documentation
Complete API reference for the Seamless OOP Framework framework.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Library API](#library-api)
3. [Component System](#component-system)
4. [ModuleHandler](#modulehandler)
5. [Examples](#examples)

---

## Getting Started

### Installation
Place the Seamless OOP Framework in your Roblox project structure:

```
ReplicatedStorage/
└── Seamless OOP Framework/
    ├── Library.lua
    ├── ModuleHandler.lua
    └── Components/
        └── Component.lua (template)
```

### Basic Setup
The ModuleHandler automatically initializes the framework. You can utilize each component through its "Init()" method that runs at runtime!

---

## Library API
The Seamless OOP Framework Library provides utility functions for animations, connections, threads, and more.

### Properties

#### `Library.Version`
- **Type:** `string`
- **Description:** Current version of Seamless OOP Framework
- **Example:** `"1.0.0"`

#### `Library.Authors`
- **Type:** `string`
- **Description:** Framework authors
- **Example:** `"Vanguard, UncleTyrone"`

#### `Library.Debug`
- **Type:** `boolean`
- **Description:** Enable/disable debug warnings
- **Default:** `true`

#### `Library.Connections`
- **Type:** `{ [string]: RBXScriptConnection }`
- **Description:** Storage for tracked connections

#### `Library.Threads`
- **Type:** `{ [string]: thread }`
- **Description:** Storage for tracked threads

#### `Library.OriginalProperties`
- **Type:** `{ [GuiObject]: { [GuiObject]: { [string]: any } } }`
- **Description:** Stores original properties for fade animations

### Service References
The Library exposes Roblox services for convenience:

- `Library.Players`
- `Library.GroupService`
- `Library.ReplicatedStorage`
- `Library.ServerScriptService`
- `Library.ServerStorage`
- `Library.StarterGui`
- `Library.TweenService`
- `Library.UserInputService`
- `Library.SoundService`
- `Library.HttpService`
- `Library.MarketplaceService`

---

## Library Methods

### `Library:GetVersion()`
Returns the current version of Seamless OOP Framework.

**Returns:**
- `string` - Version string

**Example:**
```lua
local version = Library:GetVersion()
print(version) -- "1.0.0"
```

---

### `Library:UniqueID()`
Generates a unique GUID identifier.

**Returns:**
- `string` - Unique ID

**Example:**
```lua
local id = Library:UniqueID()
print(id) -- "abc-123-def-456"
```

---

### `Library:Connection(Connection)`
Registers a connection for automatic cleanup.

**Parameters:**
- `Connection` (`RBXScriptConnection`) - The connection to track

**Returns:**
- `string` - Unique ID of the connection

**Example:**
```lua
local connection = SomeEvent:Connect(function()
    print("Event fired!")
end)

local connectionId = Library:Connection(connection)
-- Connection will be automatically cleaned up on game close
```

---

### `Library:Thread(Thread)`
Registers a thread for automatic cleanup.

**Parameters:**
- `Thread` (`thread`) - The thread to track

**Returns:**
- `string` - Unique ID of the thread

**Example:**
```lua
local thread = task.spawn(function()
    while true do
        print("Running...")
        task.wait(1)
    end
end)

local threadId = Library:Thread(thread)
-- Thread will be automatically cancelled on game close
```

---

### `Library:CancelThread(ThreadId)`
Cancels a registered thread.

**Parameters:**
- `ThreadId` (`string`) - The unique ID of the thread

**Example:**
```lua
local threadId = Library:Thread(someThread)
-- Later...
Library:CancelThread(threadId)
```

---

### `Library:GetPlayerAttribute(Player, AttributeName)`
Gets a player attribute value.

**Parameters:**
- `Player` (`Player`) - The player instance
- `AttributeName` (`string`) - Name of the attribute

**Returns:**
- `any` - Attribute value, or `false` if not found

**Example:**
```lua
local value = Library:GetPlayerAttribute(player, "Level")
if value then
    print("Player level:", value)
end
```

---

### `Library:AttributeSignal(Player, AttributeName)`
Gets the attribute changed signal for a player.

**Parameters:**
- `Player` (`Player`) - The player instance
- `AttributeName` (`string`) - Name of the attribute

**Returns:**
- `RBXScriptSignal` - The attribute changed signal

**Example:**
```lua
local signal = Library:AttributeSignal(player, "Level")
Library:Connection(signal:Connect(function()
    print("Level changed!")
end))
```

---

### `Library:Animate(Object, Duration, PropertyString, GoalValue, Boolean, EasingStyle, EasingDirection)`
Animates a GUI object property.

**Parameters:**
- `Object` (`GuiObject`) - The GUI object to animate
- `Duration` (`number`) - Animation duration in seconds
- `PropertyString` (`string`) - Property to animate (e.g., "BackgroundTransparency")
- `GoalValue` (`any`) - Target value for the property
- `Boolean` (`boolean?`) - Whether to autoplay (optional, defaults to `true`)
- `EasingStyle` (`Enum.EasingStyle?`) - Easing style (optional, defaults to `Sine`)
- `EasingDirection` (`Enum.EasingDirection?`) - Easing direction (optional, defaults to `In`)

**Returns:**
- `Tween?` - The created tween (if autoplay is false)

**Example:**
```lua
-- Fade out a frame
Library:Animate(frame, 0.5, "BackgroundTransparency", 1, true)

-- Animate size
Library:Animate(
    button,
    1.0,
    "Size",
    UDim2.new(0, 200, 0, 50),
    true,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Get tween without autoplay
local tween = Library:Animate(frame, 0.5, "BackgroundTransparency", 0, false)
-- Play manually later
tween:Play()
```

**Supported Properties:**
- `BackgroundColor3`, `Color`, `Size`, `Position`, `Visible`, `ZIndex`
- `AnchorPoint`, `BackgroundTransparency`, `ImageTransparency`
- `TextTransparency`, `TextStrokeTransparency`, `GroupTransparency`
- `Thickness`, `Transparency`, `ImageColor3`, `Rotation`

---

### `Library:Fade(Object, Path, Duration)`
Fades a GUI object and all its descendants in or out.
Make sure you run :InitializeFade() on a frame object to store its properties PRIOR to attempting to :Fade() the object!

**Parameters:**
- `Object` (`GuiObject`) - The root GUI object
- `Path` (`string`) - Fade direction: `"Init"`, `"In"`, or `"Out"`
- `Duration` (`number`) - Animation duration in seconds

**Path Options:**
- `"Out"` - Fades out the object
- `"In"` - Fades in the object (restores original properties)

**Example:**
```lua
-- Initialize fade (store properties and fade out)
Library:InitializeFade(myFrame)

-- Fade out
Library:Fade(myFrame, "Out", 0.5)

-- Fade in (restores original transparency)
Library:Fade(myFrame, "In", 0.5)
```

---

### `Library:InitializeFade(Object)`
Initializes fade properties for an object (stores originals and fades out).

**Parameters:**
- `Object` (`GuiObject`) - The GUI object to initialize

**Example:**
```lua
Library:InitializeFade(menuFrame)
-- Object is now invisible with properties stored
-- Use Fade("In", duration) to restore
```

---

### `Library:Warn(Source, Text)`
Outputs a warning message if debug mode is enabled.

**Parameters:**
- `Source` (`Script`) - The script instance
- `Text` (`string`) - Warning message

**Example:**
```lua
Library:Warn(script, "Invalid configuration detected!")
-- Output: [Seamless OOP Framework] MyScript | Invalid configuration detected!
```

---

### `Library:GetPfp(Player, Size)`
Gets a player's profile picture thumbnail.

**Parameters:**
- `Player` (`Player | number`) - Player instance or UserId
- `Size` (`Enum.ThumbnailSize`) - Thumbnail size

**Returns:**
- `string` - Thumbnail URL

**Example:**
```lua
-- Using Player instance
local thumbnail = Library:GetPfp(player, Enum.ThumbnailSize.Size150x150)

-- Using UserId
local thumbnail = Library:GetPfp(123456789, Enum.ThumbnailSize.Size150x150)

-- Apply to ImageLabel
imageLabel.Image = thumbnail
```

---

### `Library:ConvertToTime(Minutes)`
Converts minutes into days, hours, and minutes.

**Parameters:**
- `Minutes` (`number`) - Total minutes

**Returns:**
- `{ Days: number, Hours: number, Minutes: number }` - Time breakdown

**Example:**
```lua
local time = Library:ConvertToTime(1500) -- 25 hours
print(time.Days)    -- 1
print(time.Hours)   -- 1
print(time.Minutes) -- 0
```

---

## Component System
The Seamless OOP Framework uses a modular component system that automatically loads and initializes components.

### Component Communication
Components can access each other through the `Components` table:

```lua
function MyComponent:Init() -- Run your code on the runtime thread.
    if Components.OtherComponent then -- Access another component from the table.
        Components.OtherComponent:DoSomething() -- Access a method of that component.
    end
end
```

### Importing Component Types
To type-check component interactions, use type imports, an example can be found at the top of the provided component or below:

```lua
------------------ IMPORT COMPONENTS : ------------------

type OtherComponent = typeof(require(Parent:WaitForChild('OtherComponent')))

type ComponentTypes = {
    OtherComponent: OtherComponent,
}

------------------ END IMPORT ! ------------------

local Components = ({} :: any) :: ComponentTypes
```

---

## ModuleHandler
The ModuleHandler automatically loads and initializes all components in the `Components` folder.

### How It Works

1. **Library Setup** - Loads and initializes the Library
2. **Component Discovery** - Finds all ModuleScripts in the Components folder
3. **Component Registration** - Calls `Register()` on each component
4. **Component Setup** - Calls `Setup()` on each component
5. **Component Init** - Spawns threads to call `Init()` on each component
6. **Cleanup** - Automatically cancels all threads on game close

### Automatic Loading
Simply place ModuleScripts in the Components folder:

```
Seamless OOP Framework/
├── Library.lua
├── ModuleHandler.lua
└── Components/
    ├── Component.lua
    ├── MyComponent.lua      -- Automatically loaded
    └── AnotherComponent.lua -- Automatically loaded
```

### Error Handling
ModuleHandler uses `pcall` to handle errors gracefully. Failed components will output warnings but won't crash the system.

---

## Examples

### Example 1: Basic Animation

```lua
local Library = require(Parent.Library)

-- Fade out a frame
Library:Animate(myFrame, 0.5, "BackgroundTransparency", 1, true)

-- Animate position
Library:Animate(
    button,
    1.0,
    "Position",
    UDim2.new(0.5, 0, 0.5, 0),
    true,
    Enum.EasingStyle.Elastic,
    Enum.EasingDirection.Out
)
```

### Example 2: Fade System

```lua
local Library = require(Parent.Library)

-- Initialize (store properties and hide)
Library:InitializeFade(menuFrame)

-- Later, fade in
Library:Fade(menuFrame, "In", 0.5)

-- Fade out
Library:Fade(menuFrame, "Out", 0.3)
```

### Example 3: Connection Management

```lua
local Library = require(Parent.Parent:WaitForChild('Library'))

-- Track a connection (auto-cleanup on game close)
local connection = button.MouseButton1Click:Connect(function()
    print("Button clicked!")
end)

Library:Connection(connection)
```

### Example 4: Thread Management

```lua
local Library = require(Parent.Parent:WaitForChild('Library'))

-- Track a thread (auto-cancel on game close)
local thread = task.spawn(function()
    while true do
        -- Do work
        task.wait(1)
    end
end)

local threadId = Library:Thread(thread)

-- Cancel manually if needed
Library:CancelThread(threadId)
```

### Example 5: Player Attribute Monitoring

```lua
local Library = require(Parent.Parent:WaitForChild('Library'))

local player = game.Players.LocalPlayer

-- Monitor level changes
local signal = Library:AttributeSignal(player, "Level")
Library:Connection(signal:Connect(function()
    local level = Library:GetPlayerAttribute(player, "Level")
    print("Player level changed to:", level)
end))
```

### Example 6: Profile Picture Display

```lua
local Library = require(Parent.Parent:WaitForChild('Library'))

local player = game.Players.LocalPlayer
local imageLabel = script.Parent

-- Load profile picture
local thumbnail = Library:GetPfp(player, Enum.ThumbnailSize.Size150x150)
imageLabel.Image = thumbnail
```

### Example 7: Time Conversion

```lua
local Library = require(Parent.Parent:WaitForChild('Library'))

local totalMinutes = 1500 -- 25 hours
local time = Library:ConvertToTime(totalMinutes)

print(string.format("%d days, %d hours, %d minutes", 
    time.Days, 
    time.Hours, 
    time.Minutes
))
-- Output: "1 days, 1 hours, 0 minutes"
```

---

## Best Practices

1. **Always use `Library:Connection()`** for event connections to ensure cleanup
2. **Use `Library:Thread()`** for long-running tasks
3. **Initialize fades before showing UI** to enable smooth transitions
4. **Return `true` from `Setup()`** only when initialization succeeds
5. **Access other components in `Init()`** after all components are loaded
6. **Use type definitions** for better code completion and error detection

---

## Troubleshooting

### Component not loading?
- Check that it's a ModuleScript in the Components folder
- Ensure `Setup()` returns `true` on success
- Check for errors in the Output window

### Animations not working?
- Verify the GUI object exists and is a valid GuiObject
- Check that properties are spelled correctly
- Ensure the object is visible before animating

### Connections not cleaning up?
- Use `Library:Connection()` to track connections
- Check that `Library:Init()` was called (automatic via ModuleHandler)

---

## Version
Current Version: **1.1.0**

---

**Made with ❤️ by Vanguard & UncleTyrone**