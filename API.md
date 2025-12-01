# Seamless OOP Framework API Documentation
Complete API reference for the Seamless OOP Framework framework.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Architecture Overview](#architecture-overview)
3. [Library API](#library-api)
4. [Component System](#component-system)
5. [ModuleHandler](#modulehandler)
6. [Examples](#examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Getting Started

### Installation
The Seamless OOP Framework is structured for both Server and Client environments:

**Server Structure:**
```
ServerScriptService/
└── SeamlessOOPFramework_Server/
    ├── Library.luau
    ├── ModuleHandler.server.luau
    └── Components/
        └── Component.luau (template)
```

**Client Structure:**
```
StarterPlayer/StarterPlayerScripts/
└── SeamlessOOPFramework_Client/
    ├── Library.luau
    ├── ModuleHandler.client.luau
    └── Components/
        └── Component.luau (template)
```

### Basic Setup
The ModuleHandler automatically initializes the framework. Simply place your component ModuleScripts in the `Components` folder, and they will be automatically loaded, registered, and initialized. Each component's `Init()` method runs on a separate thread at runtime.

---

## Architecture Overview

The Seamless OOP Framework operates on both the **Server** and **Client** with separate instances:

- **Server Library**: Core utilities for server-side operations (connections, threads, player attributes, etc.)
- **Client Library**: All server features plus GUI animation methods (`Animate`, `Fade`, `InitializeFade`)

Both environments share the same component system architecture, allowing seamless code reuse across server and client.

---

## Library API
The Seamless OOP Framework Library provides utility functions for connections, threads, player management, and more. The Client Library includes additional GUI animation capabilities.

### Properties

#### `Library.Version`
- **Type:** `string`
- **Description:** Current version of Seamless OOP Framework
- **Example:** `"1.2.0"`

#### `Library.Authors`
- **Type:** `string`
- **Description:** Framework authors
- **Example:** `"UncleTyrone, Vanguard"`

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

### `Library:Animate(Object, Duration, PropertyString, GoalValue, Boolean?, EasingStyle?, EasingDirection?)`
Animates a GUI object property. **Client-only method.**

**Parameters:**
- `Object` (`GuiObject`) - The GUI object to animate
- `Duration` (`number`) - Animation duration in seconds
- `PropertyString` (`string`) - Property to animate (e.g., "BackgroundTransparency")
- `GoalValue` (`Color3 | UDim2 | number | string`) - Target value for the property
- `Boolean` (`boolean?`) - Whether to autoplay (optional, defaults to `true`)
- `EasingStyle` (`Enum.EasingStyle?`) - Easing style (optional, defaults to `Enum.EasingStyle.Sine`)
- `EasingDirection` (`Enum.EasingDirection?`) - Easing direction (optional, defaults to `Enum.EasingDirection.In`)

**Returns:**
- `Tween?` - The created tween (if autoplay is `false`), otherwise `nil`

**Note:** This method is only available in the Client Library. The Server Library does not include animation methods.

**Example:**
```lua
-- Fade out a frame (autoplay defaults to true)
Library:Animate(frame, 0.5, "BackgroundTransparency", 1)

-- Animate size with custom easing
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
Fades a GUI object and all its descendants in or out. **Client-only method.**

**Parameters:**
- `Object` (`GuiObject`) - The root GUI object
- `Path` (`string`) - Fade direction: `"Init"`, `"In"`, or `"Out"`
- `Duration` (`number`) - Animation duration in seconds

**Path Options:**
- `"Init"` - Initializes fade by storing original properties and fading out (used internally by `InitializeFade`)
- `"Out"` - Fades out the object and all descendants
- `"In"` - Fades in the object (restores original properties stored during initialization)

**Note:** This method is only available in the Client Library. It automatically handles different GUI object types:
- **Frames/ScrollingFrames**: Animates `BackgroundTransparency`
- **Text objects** (TextBox, TextButton, TextLabel): Animates `TextTransparency` and `BackgroundTransparency`
- **Image objects** (ImageLabel, ImageButton, ViewportFrame): Animates `ImageTransparency` and `BackgroundTransparency`
- **UIStrokes**: Animates `Transparency`

**Important:** You must call `Library:InitializeFade()` on a frame object to store its properties **before** attempting to fade it in or out.

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
Initializes fade properties for an object by storing original transparency values and immediately fading out. **Client-only method.**

**Parameters:**
- `Object` (`GuiObject`) - The GUI object to initialize

**Returns:**
- `nil`

**Note:** This method is only available in the Client Library. It internally calls `Library:Fade(Object, "Init", 0)` to store original properties and hide the object instantly.

**Example:**
```lua
-- Initialize (store properties and hide immediately)
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
The Seamless OOP Framework uses a modular component system that automatically loads and initializes components. Components work identically on both Server and Client.

### Component Lifecycle

Components go through three phases in order:

1. **Register** - Component is registered in the global registry
2. **Setup** - Component initializes and validates dependencies
3. **Init** - Component starts its runtime behavior (runs on separate thread)

### Component Structure

Every component must be a ModuleScript that returns a table with these methods:

```lua
local Component = {}

-- Required: Called automatically by ModuleHandler
function Component:Register(Registry)
    self.Registry = Registry
end

-- Required: Called automatically by ModuleHandler
-- Must return true on success, false on failure
function Component:Setup()
    -- Initialize library (injected by ModuleHandler)
    if self.Library then
        Library = self.Library
    else
        return false
    end
    
    -- Initialize registry
    if self.Registry then
        for Name, Component in pairs(self.Registry) do
            Components[Name] = Component
        end
    else
        return false
    end
    
    return true
end

-- Optional: Called automatically by ModuleHandler on separate thread
function Component:Init()
    -- Your runtime code here
end

return Component
```

### Component Communication
Components can access each other through the `Components` table after `Setup()` completes:

```lua
function MyComponent:Init() -- Run your code on the runtime thread.
    if Components.OtherComponent then -- Access another component from the table.
        Components.OtherComponent:DoSomething() -- Access a method of that component.
    end
end
```

### Importing Component Types
To enable type-checking and autocomplete for component interactions, use type imports:

```lua
------------------ IMPORT COMPONENTS : ------------------

type OtherComponent = typeof(require(Parent:WaitForChild('OtherComponent')))

type ComponentTypes = {
    OtherComponent: OtherComponent,
}

------------------ END IMPORT ! ------------------

local Components = ({} :: any) :: ComponentTypes
```

### Component Properties

After `Setup()` is called, components have access to:

- `self.Library` - The Library instance (injected by ModuleHandler)
- `self.Registry` - The global component registry (injected by ModuleHandler)
- `Component.Library` - Library exposed on component for external access (set during Setup)

---

## ModuleHandler
The ModuleHandler automatically loads and initializes all components in the `Components` folder. There are separate handlers for Server (`ModuleHandler.server.luau`) and Client (`ModuleHandler.client.luau`), but they function identically.

### How It Works

The ModuleHandler follows this sequence:

1. **Library Loading** - Requires and validates the Library module
2. **Library Setup** - Calls `Library:Setup()` to initialize the framework
3. **Library Init** - Calls `Library:Init()` to set up cleanup handlers
4. **Component Discovery** - Finds all ModuleScripts in the Components folder
5. **Component Loading** - Requires each component with error handling
6. **Component Registration** - Injects Library into each component and calls `Register(Registry)` on each
7. **Component Setup** - Calls `Setup()` on each component sequentially
8. **Component Init** - Spawns separate threads to call `Init()` on each component
9. **Cleanup** - Automatically cancels all Init threads on game close

### Automatic Loading
Simply place ModuleScripts in the Components folder:

```
SeamlessOOPFramework_Server/ (or _Client)
├── Library.luau
├── ModuleHandler.server.luau (or .client.luau)
└── Components/
    ├── Component.luau (template)
    ├── MyComponent.luau      -- Automatically loaded
    └── AnotherComponent.luau -- Automatically loaded
```

### Error Handling
ModuleHandler uses `pcall` to handle errors gracefully:

- **Component loading errors**: Warns but continues with other components
- **Component setup failures**: Warns and skips initialization if `Setup()` returns `false`
- **Component init errors**: Errors are caught per-thread, won't crash other components

### Debug Output

When `Library.Debug` is `true` (default), the ModuleHandler will:
- Print success messages for each component that loads: `"Module [Name] has successfully loaded!"`
- Warn about components that fail to load or initialize

### Thread Management

- Each component's `Init()` method runs on its own separate thread
- All Init threads are tracked and automatically cancelled when the game closes
- This allows components to run concurrently without blocking each other

---

## Examples

### Example 1: Basic Animation (Client Only)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

-- Fade out a frame (autoplay defaults to true)
Library:Animate(myFrame, 0.5, "BackgroundTransparency", 1)

-- Animate position with custom easing
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

### Example 2: Fade System (Client Only)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

-- Initialize (store properties and hide immediately)
Library:InitializeFade(menuFrame)

-- Later, fade in (restores original properties)
Library:Fade(menuFrame, "In", 0.5)

-- Fade out again
Library:Fade(menuFrame, "Out", 0.3)
```

### Example 3: Connection Management (Server & Client)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

-- Track a connection (auto-cleanup on game close)
local connection = button.MouseButton1Click:Connect(function()
    print("Button clicked!")
end)

local connectionId = Library:Connection(connection)
-- Connection will be automatically disconnected when game closes
```

### Example 4: Thread Management (Server & Client)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

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

### Example 5: Player Attribute Monitoring (Server & Client)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

local player = game.Players.LocalPlayer -- or game.Players:GetPlayerByUserId()

-- Monitor level changes
local signal = Library:AttributeSignal(player, "Level")
Library:Connection(signal:Connect(function()
    local level = Library:GetPlayerAttribute(player, "Level")
    print("Player level changed to:", level)
end))
```

### Example 6: Profile Picture Display (Server & Client)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

local player = game.Players.LocalPlayer
local imageLabel = script.Parent

-- Load profile picture using Player instance
local thumbnail = Library:GetPfp(player, Enum.ThumbnailSize.Size150x150)
if thumbnail then
    imageLabel.Image = thumbnail
end

-- Or using UserId
local thumbnail2 = Library:GetPfp(123456789, Enum.ThumbnailSize.Size150x150)
```

### Example 7: Time Conversion (Server & Client)

```lua
local Library = require(Parent.Parent:WaitForChild("Library"))

local totalMinutes = 1500 -- 25 hours
local time = Library:ConvertToTime(totalMinutes)

print(string.format("%d days, %d hours, %d minutes", 
    time.Days, 
    time.Hours, 
    time.Minutes
))
-- Output: "1 days, 1 hours, 0 minutes"
```

### Example 8: Creating a Component

```lua
-- MyComponent.luau in Components folder
local Component = {}

-- Import other components for type checking
type OtherComponent = typeof(require(script.Parent:WaitForChild("OtherComponent")))

type ComponentTypes = {
    OtherComponent: OtherComponent,
}

local Components = ({} :: any) :: ComponentTypes
local Library = ({} :: any)

function Component:Register(Registry)
    self.Registry = Registry
end

function Component:Setup()
    -- Library is injected by ModuleHandler
    if self.Library then
        Library = self.Library
    else
        return false
    end
    
    -- Registry is injected by ModuleHandler
    if self.Registry then
        for Name, Component in pairs(self.Registry) do
            Components[Name] = Component
        end
    else
        return false
    end
    
    return true
end

function Component:Init()
    -- Access other components
    if Components.OtherComponent then
        Components.OtherComponent:SomeMethod()
    end
    
    -- Use library services
    local player = Library.Players.LocalPlayer
    print("Component initialized for", player.Name)
end

return Component
```

---

## Best Practices

1. **Always use `Library:Connection()`** for event connections to ensure automatic cleanup on game close
2. **Use `Library:Thread()`** for long-running tasks that need to be cancelled on cleanup
3. **Initialize fades before showing UI** - Call `InitializeFade()` during setup, then use `Fade("In", duration)` when showing
4. **Return `true` from `Setup()`** only when initialization succeeds - Return `false` to prevent the component from initializing
5. **Access other components in `Init()`** - All components are guaranteed to be registered and set up before `Init()` is called
6. **Use type definitions** for component imports to enable autocomplete and type checking
7. **Handle Library injection** - Always check if `self.Library` exists in `Setup()` before using it
8. **Client vs Server** - Remember that animation methods (`Animate`, `Fade`, `InitializeFade`) are only available on the Client
9. **Error handling** - Use `pcall` for risky operations in `Init()` since it runs on a separate thread
10. **Component communication** - Access other components through the `Components` table, not through direct requires

---

## Troubleshooting

### Component not loading?
- **Check file type**: Ensure it's a ModuleScript (not a regular Script) in the Components folder
- **Check Setup()**: Ensure `Setup()` returns `true` on success, `false` on failure
- **Check Output**: Look for warnings in the Output window - ModuleHandler will warn about failed components
- **Check Library injection**: Verify `self.Library` exists in `Setup()` - it's injected automatically by ModuleHandler
- **Check Registry**: Verify `self.Registry` exists in `Setup()` - it's injected automatically

### Animations not working? (Client Only)
- **Verify environment**: Animation methods are only available in the Client Library
- **Check object type**: Verify the GUI object exists and is a valid GuiObject
- **Check property names**: Ensure properties are spelled correctly (case-sensitive)
- **Check InitializeFade**: For fade operations, ensure `InitializeFade()` was called first
- **Check visibility**: Some animations may not work if the object is not visible

### Connections not cleaning up?
- **Use Library:Connection()**: Always track connections with `Library:Connection()` for automatic cleanup
- **Check Library:Init()**: Verify `Library:Init()` was called (automatic via ModuleHandler)
- **Check game.Close**: Cleanup happens on `game.Close` event - ensure this fires properly

### Threads not cancelling?
- **Use Library:Thread()**: Track threads with `Library:Thread()` for automatic cancellation
- **Manual cancellation**: Use `Library:CancelThread(threadId)` if you need to cancel before game close
- **Check thread ID**: Ensure you're using the correct thread ID returned by `Library:Thread()`

### Components can't access each other?
- **Check Setup()**: Ensure all components return `true` from `Setup()` - failed components won't be in the registry
- **Check Init() timing**: Access other components in `Init()`, not in `Setup()` - all components are set up before any `Init()` runs
- **Check component names**: Component names in the registry match the ModuleScript name
- **Check type imports**: Use proper type imports for autocomplete and type checking

---

## Version
Current Version: **1.2.0**

---

**Made with ❤️ by UncleTyrone & Vanguard**