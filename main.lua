local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local HOTBAR_URL =
    "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/Hotbar.lua"

--------------------------------------------------
-- SAVE SYSTEM
--------------------------------------------------

local SAVE_FILE = "CustomHubUI_Settings.json"
local SavedData = {}

local function CanUseFileSystem()
    return type(isfile) == "function"
        and type(readfile) == "function"
        and type(writefile) == "function"
end

local function LoadSavedData()

    SavedData = {}

    if not CanUseFileSystem() then
        return
    end

    if not isfile(SAVE_FILE) then
        return
    end

    local success, result = pcall(function()
        return readfile(SAVE_FILE)
    end)

    if not success
        or not result
        or result == "" then

        return
    end

    local decodeSuccess, decoded =
        pcall(function()
            return HttpService:JSONDecode(result)
        end)

    if decodeSuccess
        and type(decoded) == "table" then

        SavedData = decoded
    end
end

local function SaveAllData()

    if not CanUseFileSystem() then
        return
    end

    local success, encoded =
        pcall(function()
            return HttpService:JSONEncode(
                SavedData
            )
        end)

    if success then

        pcall(function()
            writefile(
                SAVE_FILE,
                encoded
            )
        end)
    end
end

local function GetSavedValue(key)
    return SavedData[key]
end

local function SetSavedValue(
    key,
    value
)

    SavedData[key] = value

    SaveAllData()
end

LoadSavedData()

--------------------------------------------------
-- REMOVE OLD GUI
--------------------------------------------------

for _, name in ipairs({
    "HubUi",
    "MenuUi",
    "CloseGui"
}) do

    local old =
        CoreGui:FindFirstChild(name)

    if old then

        pcall(function()
            old:Destroy()
        end)
    end
end

--------------------------------------------------
-- REMOTE LOADER
--------------------------------------------------

local function LoadRemoteScript(url)

    if type(url) ~= "string"
        or url == ""
        or url:find("YOUR_RAW") then

        warn(
            "CustomHub: URL chưa được cấu hình:",
            url
        )

        return false
    end

    local success, result =
        pcall(function()

            local source =
                game:HttpGet(url)

            local fn =
                loadstring(source)

            if type(fn) ~= "function" then

                error(
                    "loadstring returned nil"
                )
            end

            return fn()

        end)

    if not success then

        warn(
            "CustomHub Load Error:",
            result
        )
    end

    return success, result
end

--------------------------------------------------
-- GLOBAL API
--------------------------------------------------

_G.CustomHub = {
    LoadRemoteScript =
        LoadRemoteScript
}

--------------------------------------------------
-- DRAG
--------------------------------------------------

local function MakeDraggable(
    frame,
    dragObject
)

    local dragging = false
    local dragStart
    local startPosition

    dragObject.InputBegan:Connect(
        function(input)

            if input.UserInputType
                == Enum.UserInputType.MouseButton1

                or input.UserInputType
                == Enum.UserInputType.Touch then

                dragging = true

                dragStart =
                    input.Position

                startPosition =
                    frame.Position

                input.Changed:Connect(
                    function()

                        if input.UserInputState
                            == Enum.UserInputState.End then

                            dragging = false
                        end
                    end
                )
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not dragging then
                return
            end

            if input.UserInputType
                == Enum.UserInputType.MouseMovement

                or input.UserInputType
                == Enum.UserInputType.Touch then

                local delta =
                    input.Position
                    - dragStart

                frame.Position =
                    UDim2.new(
                        startPosition.X.Scale,
                        startPosition.X.Offset
                            + delta.X,

                        startPosition.Y.Scale,
                        startPosition.Y.Offset
                            + delta.Y
                    )
            end
        end
    )
end

--------------------------------------------------
-- HUB UI
--------------------------------------------------

local HubUi =
    Instance.new("ScreenGui")

HubUi.Name =
    "HubUi"

HubUi.ResetOnSpawn =
    false

HubUi.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

HubUi.Parent =
    CoreGui

local HubButton =
    Instance.new("TextButton")

HubButton.Name =
    "HubButton"

HubButton.Parent =
    HubUi

HubButton.Size =
    UDim2.new(
        0,
        45,
        0,
        45
    )

HubButton.Position =
    UDim2.new(
        0,
        25,
        0.5,
        -22
    )

HubButton.BackgroundColor3 =
    Color3.fromRGB(
        25,
        25,
        25
    )

HubButton.BackgroundTransparency =
    0.18

HubButton.BorderSizePixel =
    0

HubButton.Text =
    "H"

HubButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

HubButton.TextStrokeTransparency =
    1

HubButton.TextSize =
    20

HubButton.Font =
    Enum.Font.GothamBold

HubButton.AutoButtonColor =
    false

local HubCorner =
    Instance.new("UICorner")

HubCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

HubCorner.Parent =
    HubButton

--------------------------------------------------
-- HUB STROKE
--------------------------------------------------

local HubStroke =
    Instance.new("UIStroke")

HubStroke.Name =
    "HubCircleStroke"

HubStroke.Color =
    Color3.fromRGB(
        255,
        255,
        255
    )

HubStroke.ApplyStrokeMode =
    Enum.ApplyStrokeMode.Border

HubStroke.Parent =
    HubButton

HubStroke.Thickness =
    1

HubStroke.Transparency =
    0.45

--------------------------------------------------
-- MENU UI
--------------------------------------------------

local MenuUi =
    Instance.new("ScreenGui")

MenuUi.Name =
    "MenuUi"

MenuUi.ResetOnSpawn =
    false

MenuUi.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

MenuUi.Enabled =
    false

MenuUi.Parent =
    CoreGui

local MenuContainer =
    Instance.new("Frame")

MenuContainer.Name =
    "MenuContainer"

MenuContainer.Parent =
    MenuUi

MenuContainer.Size =
    UDim2.new(
        0,
        700,
        0,
        430
    )

MenuContainer.Position =
    UDim2.new(
        0.5,
        -325,
        0.5,
        -200
    )

MenuContainer.BackgroundColor3 =
    Color3.fromRGB(
        60,
        60,
        60
    )

MenuContainer.BorderSizePixel =
    0

--------------------------------------------------
-- FULLSCREEN
--------------------------------------------------

local IsFullscreen =
    false

local NormalSize =
    UDim2.new(
        0,
        650,
        0,
        400
    )

local NormalPosition =
    UDim2.new(
        0.5,
        -325,
        0.5,
        -200
    )

local FullscreenSize =
    UDim2.new(
        1,
        -20,
        1,
        -20
    )

local FullscreenPosition =
    UDim2.new(
        0,
        10,
        0,
        10
    )

--------------------------------------------------
-- MENU SCALE
--------------------------------------------------

local MenuScale =
    Instance.new("UIScale")

MenuScale.Parent =
    MenuContainer

local function UpdateMenuScale()

    local Camera =
        workspace.CurrentCamera

    if not Camera then
        return
    end

    if IsFullscreen then

        MenuScale.Scale =
            1

        return
    end

    local Viewport =
        Camera.ViewportSize

    local Scale =
        math.min(
            Viewport.X / 1600,
            Viewport.Y / 900
        )

    Scale =
        Scale * 1.45

    if Scale < 0.75 then
        Scale = 0.75
    end

    if Scale > 1.45 then
        Scale = 1.35
    end

    MenuScale.Scale =
        Scale
end

UpdateMenuScale()

workspace:GetPropertyChangedSignal(
    "CurrentCamera"
):Connect(function()

    task.wait()

    UpdateMenuScale()

    local Camera =
        workspace.CurrentCamera

    if Camera then

        Camera:GetPropertyChangedSignal(
            "ViewportSize"
        ):Connect(function()

            UpdateMenuScale()
        end)
    end
end)

if workspace.CurrentCamera then

    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(function()

        UpdateMenuScale()
    end)
end

local MenuCorner =
    Instance.new("UICorner")

MenuCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

MenuCorner.Parent =
    MenuContainer

local MenuStroke =
    Instance.new("UIStroke")

MenuStroke.Color =
    Color3.fromRGB(
        120,
        120,
        120
    )

MenuStroke.Thickness =
    1

MenuStroke.Parent =
    MenuContainer

--------------------------------------------------
-- TOP BAR
--------------------------------------------------

local MenuTopBar =
    Instance.new("Frame")

MenuTopBar.Parent =
    MenuContainer

MenuTopBar.Size =
    UDim2.new(
        1,
        0,
        0,
        50
    )

MenuTopBar.BackgroundColor3 =
    Color3.fromRGB(
        50,
        50,
        50
    )

MenuTopBar.BorderSizePixel =
    0

local TopCorner =
    Instance.new("UICorner")

TopCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

TopCorner.Parent =
    MenuTopBar

--------------------------------------------------
-- TITLE
--------------------------------------------------

local MenuTitle =
    Instance.new("TextLabel")

MenuTitle.Parent =
    MenuTopBar

MenuTitle.Size =
    UDim2.new(
        1,
        -165,
        1,
        0
    )

MenuTitle.Position =
    UDim2.new(
        0,
        15,
        0,
        0
    )

MenuTitle.BackgroundTransparency =
    1

MenuTitle.Text =
    "Hub Menu"

MenuTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

MenuTitle.TextStrokeTransparency =
    1

MenuTitle.TextSize =
    18

MenuTitle.Font =
    Enum.Font.GothamBold

MenuTitle.TextXAlignment =
    Enum.TextXAlignment.Left

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local MinimizeButton =
    Instance.new("TextButton")

MinimizeButton.Parent =
    MenuTopBar

MinimizeButton.Size =
    UDim2.new(
        0,
        35,
        0,
        35
    )

MinimizeButton.Position =
    UDim2.new(
        1,
        -125,
        0,
        7
    )

MinimizeButton.BackgroundColor3 =
    Color3.fromRGB(
        100,
        100,
        100
    )

MinimizeButton.BorderSizePixel =
    0

MinimizeButton.Text =
    "-"

MinimizeButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

MinimizeButton.TextStrokeTransparency =
    1

MinimizeButton.TextSize =
    20

MinimizeButton.Font =
    Enum.Font.GothamBold

MinimizeButton.AutoButtonColor =
    false

local MinimizeCorner =
    Instance.new("UICorner")

MinimizeCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

MinimizeCorner.Parent =
    MinimizeButton

local MinimizeStroke =
    Instance.new("UIStroke")

MinimizeStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

MinimizeStroke.Thickness =
    1

MinimizeStroke.Parent =
    MinimizeButton

--------------------------------------------------
-- FULLSCREEN
--------------------------------------------------

local FullscreenButton =
    Instance.new("TextButton")

FullscreenButton.Parent =
    MenuTopBar

FullscreenButton.Size =
    UDim2.new(
        0,
        35,
        0,
        35
    )

FullscreenButton.Position =
    UDim2.new(
        1,
        -85,
        0,
        7
    )

FullscreenButton.BackgroundColor3 =
    Color3.fromRGB(
        100,
        100,
        100
    )

FullscreenButton.BorderSizePixel =
    0

FullscreenButton.Text =
    "□"

FullscreenButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

FullscreenButton.TextStrokeTransparency =
    1

FullscreenButton.TextSize =
    16

FullscreenButton.Font =
    Enum.Font.GothamBold

FullscreenButton.AutoButtonColor =
    false

local FullscreenCorner =
    Instance.new("UICorner")

FullscreenCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

FullscreenCorner.Parent =
    FullscreenButton

local FullscreenStroke =
    Instance.new("UIStroke")

FullscreenStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

FullscreenStroke.Thickness =
    1

FullscreenStroke.Parent =
    FullscreenButton

--------------------------------------------------
-- X
--------------------------------------------------

local XButton =
    Instance.new("TextButton")

XButton.Parent =
    MenuTopBar

XButton.Size =
    UDim2.new(
        0,
        35,
        0,
        35
    )

XButton.Position =
    UDim2.new(
        1,
        -45,
        0,
        7
    )

XButton.BackgroundColor3 =
    Color3.fromRGB(
        100,
        100,
        100
    )

XButton.BorderSizePixel =
    0

XButton.Text =
    "X"

XButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

XButton.TextStrokeTransparency =
    1

XButton.TextSize =
    16

XButton.Font =
    Enum.Font.GothamBold

XButton.AutoButtonColor =
    false

local XCorner =
    Instance.new("UICorner")

XCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

XCorner.Parent =
    XButton

local XStroke =
    Instance.new("UIStroke")

XStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

XStroke.Thickness =
    1

XStroke.Parent =
    XButton

--------------------------------------------------
-- HOTBAR GUI
--------------------------------------------------

local HotbarGui =
    Instance.new("Frame")

HotbarGui.Name =
    "HotbarGui"

HotbarGui.Parent =
    MenuContainer

HotbarGui.Size =
    UDim2.new(
        0,
        150,
        1,
        -65
    )

HotbarGui.Position =
    UDim2.new(
        0,
        10,
        0,
        60
    )

HotbarGui.BackgroundColor3 =
    Color3.fromRGB(
        55,
        55,
        55
    )

HotbarGui.BorderSizePixel =
    0

local HotbarCorner =
    Instance.new("UICorner")

HotbarCorner.CornerRadius =
    UDim.new(
        0,
        10
    )

HotbarCorner.Parent =
    HotbarGui

local HotbarStroke =
    Instance.new("UIStroke")

HotbarStroke.Color =
    Color3.fromRGB(
        110,
        110,
        110
    )

HotbarStroke.Thickness =
    1

HotbarStroke.Parent =
    HotbarGui

local HotbarTitle =
    Instance.new("TextLabel")

HotbarTitle.Parent =
    HotbarGui

HotbarTitle.Size =
    UDim2.new(
        1,
        -20,
        0,
        35
    )

HotbarTitle.Position =
    UDim2.new(
        0,
        10,
        0,
        5
    )

HotbarTitle.BackgroundTransparency =
    1

HotbarTitle.Text =
    "MENU"

HotbarTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

HotbarTitle.TextStrokeTransparency =
    1

HotbarTitle.TextSize =
    16

HotbarTitle.Font =
    Enum.Font.GothamBold

HotbarTitle.TextXAlignment =
    Enum.TextXAlignment.Left

local HotbarContent =
    Instance.new("ScrollingFrame")

HotbarContent.Parent =
    HotbarGui

HotbarContent.Size =
    UDim2.new(
        1,
        -10,
        1,
        -50
    )

HotbarContent.Position =
    UDim2.new(
        0,
        5,
        0,
        45
    )

HotbarContent.BackgroundTransparency =
    1

HotbarContent.BorderSizePixel =
    0

HotbarContent.ScrollBarThickness =
    3

HotbarContent.ScrollingEnabled =
    false

HotbarContent.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )

local HotbarLayout =
    Instance.new("UIListLayout")

HotbarLayout.Parent =
    HotbarContent

HotbarLayout.Padding =
    UDim.new(
        0,
        7
    )

HotbarLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

--------------------------------------------------
-- MAIN GUI
--------------------------------------------------

local MainGui =
    Instance.new("Frame")

MainGui.Name =
    "MainGui"

MainGui.Parent =
    MenuContainer

MainGui.Size =
    UDim2.new(
        1,
        -175,
        1,
        -65
    )

MainGui.Position =
    UDim2.new(
        0,
        165,
        0,
        60
    )

MainGui.BackgroundColor3 =
    Color3.fromRGB(
        70,
        70,
        70
    )

MainGui.BorderSizePixel =
    0

local MainCorner =
    Instance.new("UICorner")

MainCorner.CornerRadius =
    UDim.new(
        0,
        10
    )

MainCorner.Parent =
    MainGui

local MainStroke =
    Instance.new("UIStroke")

MainStroke.Color =
    Color3.fromRGB(
        120,
        120,
        120
    )

MainStroke.Thickness =
    1

MainStroke.Parent =
    MainGui

local MainTitle =
    Instance.new("TextLabel")

MainTitle.Parent =
    MainGui

MainTitle.Size =
    UDim2.new(
        1,
        -20,
        0,
        40
    )

MainTitle.Position =
    UDim2.new(
        0,
        10,
        0,
        5
    )

MainTitle.BackgroundTransparency =
    1

MainTitle.Text =
    "Select a Tab"

MainTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

MainTitle.TextStrokeTransparency =
    1

MainTitle.TextSize =
    18

MainTitle.Font =
    Enum.Font.GothamBold

MainTitle.TextXAlignment =
    Enum.TextXAlignment.Left

local MainContent =
    Instance.new("ScrollingFrame")

MainContent.Parent =
    MainGui

MainContent.Size =
    UDim2.new(
        1,
        -20,
        1,
        -55
    )

MainContent.Position =
    UDim2.new(
        0,
        10,
        0,
        48
    )

MainContent.BackgroundTransparency =
    1

MainContent.BorderSizePixel =
    0

MainContent.ScrollBarThickness =
    4

MainContent.ScrollingEnabled =
    false

MainContent.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        0
    )

local MainLayout =
    Instance.new("UIListLayout")

MainLayout.Parent =
    MainContent

MainLayout.Padding =
    UDim.new(
        0,
        8
    )

MainLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

--------------------------------------------------
-- CLOSE GUI
--------------------------------------------------

local CloseGui =
    Instance.new("ScreenGui")

CloseGui.Name =
    "CloseGui"

CloseGui.ResetOnSpawn =
    false

CloseGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

CloseGui.Enabled =
    false

CloseGui.Parent =
    CoreGui

local CloseFrame =
    Instance.new("Frame")

CloseFrame.Parent =
    CloseGui

CloseFrame.Size =
    UDim2.new(
        0,
        350,
        0,
        140
    )

CloseFrame.Position =
    UDim2.new(
        0.5,
        -175,
        0.5,
        -70
    )

CloseFrame.BackgroundColor3 =
    Color3.fromRGB(
        65,
        65,
        65
    )

CloseFrame.BorderSizePixel =
    0

local CloseCorner =
    Instance.new("UICorner")

CloseCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

CloseCorner.Parent =
    CloseFrame

local CloseFrameStroke =
    Instance.new("UIStroke")

CloseFrameStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

CloseFrameStroke.Thickness =
    2

CloseFrameStroke.Parent =
    CloseFrame

local ConfirmText =
    Instance.new("TextLabel")

ConfirmText.Parent =
    CloseFrame

ConfirmText.Size =
    UDim2.new(
        1,
        -20,
        0,
        55
    )

ConfirmText.Position =
    UDim2.new(
        0,
        10,
        0,
        5
    )

ConfirmText.BackgroundTransparency =
    1

ConfirmText.Text =
    "You want close Menu?"

ConfirmText.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

ConfirmText.TextStrokeTransparency =
    1

ConfirmText.TextSize =
    17

ConfirmText.Font =
    Enum.Font.GothamBold

ConfirmText.TextXAlignment =
    Enum.TextXAlignment.Center

ConfirmText.TextYAlignment =
    Enum.TextYAlignment.Center

local Cannel =
    Instance.new("TextButton")

Cannel.Parent =
    CloseFrame

Cannel.Size =
    UDim2.new(
        0,
        134,
        0,
        44
    )

Cannel.Position =
    UDim2.new(
        0,
        18,
        1,
        -57
    )

Cannel.BackgroundColor3 =
    Color3.fromRGB(
        0,
        170,
        0
    )

Cannel.BorderSizePixel =
    0

Cannel.Text =
    "Cancel"

Cannel.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

Cannel.TextStrokeTransparency =
    1

Cannel.TextSize =
    16

Cannel.Font =
    Enum.Font.GothamBold

local CannelCorner =
    Instance.new("UICorner")

CannelCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

CannelCorner.Parent =
    Cannel

local CannelStroke =
    Instance.new("UIStroke")

CannelStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

CannelStroke.Thickness =
    2

CannelStroke.Parent =
    Cannel

local CloseButton =
    Instance.new("TextButton")

CloseButton.Parent =
    CloseFrame

CloseButton.Size =
    UDim2.new(
        0,
        134,
        0,
        44
    )

CloseButton.Position =
    UDim2.new(
        1,
        -152,
        1,
        -57
    )

CloseButton.BackgroundColor3 =
    Color3.fromRGB(
        200,
        0,
        0
    )

CloseButton.BorderSizePixel =
    0

CloseButton.Text =
    "Close"

CloseButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

CloseButton.TextStrokeTransparency =
    1

CloseButton.TextSize =
    16

CloseButton.Font =
    Enum.Font.GothamBold

local CloseButtonCorner =
    Instance.new("UICorner")

CloseButtonCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

CloseButtonCorner.Parent =
    CloseButton

local CloseButtonStroke =
    Instance.new("UIStroke")

CloseButtonStroke.Color =
    Color3.fromRGB(
        0,
        0,
        0
    )

CloseButtonStroke.Thickness =
    2

CloseButtonStroke.Parent =
    CloseButton

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = {
    Tabs = {},
    CurrentTab = nil
}

_G.CustomHub.Window =
    Window

--------------------------------------------------
-- SCROLL UPDATE
--------------------------------------------------

local function UpdateMainScroll()

    task.defer(function()

        local contentHeight =
            MainLayout.AbsoluteContentSize.Y

        local viewportHeight =
            MainContent.AbsoluteSize.Y

        local needsScroll =
            contentHeight
            > viewportHeight + 1

        MainContent.ScrollingEnabled =
            needsScroll

        if needsScroll then

            MainContent.ScrollBarThickness =
                4

            MainContent.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    contentHeight + 10
                )

        else

            MainContent.ScrollBarThickness =
                0

            MainContent.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    viewportHeight
                )

            MainContent.CanvasPosition =
                Vector2.new(
                    0,
                    0
                )
        end
    end)
end

local function UpdateHotbarScroll()

    task.defer(function()

        local contentHeight =
            HotbarLayout.AbsoluteContentSize.Y

        local viewportHeight =
            HotbarContent.AbsoluteSize.Y

        local needsScroll =
            contentHeight
            > viewportHeight + 1

        HotbarContent.ScrollingEnabled =
            needsScroll

        if needsScroll then

            HotbarContent.ScrollBarThickness =
                3

            HotbarContent.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    contentHeight + 10
                )

        else

            HotbarContent.ScrollBarThickness =
                0

            HotbarContent.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    viewportHeight
                )

            HotbarContent.CanvasPosition =
                Vector2.new(
                    0,
                    0
                )
        end
    end)
end

local function UpdateMainCanvas()
    UpdateMainScroll()
end

local function UpdateHotbarCanvas()
    UpdateHotbarScroll()
end

--------------------------------------------------
-- LISTEN SIZE
--------------------------------------------------

MainLayout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    UpdateMainScroll()
end)

MainContent:GetPropertyChangedSignal(
    "AbsoluteSize"
):Connect(function()

    UpdateMainScroll()
end)

HotbarLayout:GetPropertyChangedSignal(
    "AbsoluteContentSize"
):Connect(function()

    UpdateHotbarScroll()
end)

HotbarContent:GetPropertyChangedSignal(
    "AbsoluteSize"
):Connect(function()

    UpdateHotbarScroll()
end)

--------------------------------------------------
-- CLEAR MAIN
--------------------------------------------------

local function ClearMain()

    for _, child in ipairs(
        MainContent:GetChildren()
    ) do

        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    MainContent.CanvasPosition =
        Vector2.new(
            0,
            0
        )
end

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function IsNameSelected(
    list,
    name
)

    for _, value in ipairs(list) do

        if value == name then
            return true
        end
    end

    return false
end

local function RemoveSelectedName(
    list,
    name
)

    for i = #list, 1, -1 do

        if list[i] == name then

            table.remove(
                list,
                i
            )

            return true
        end
    end

    return false
end

local function FindOption(
    options,
    name
)

    for _, option in ipairs(
        options
    ) do

        if type(option) == "table"
            and option.Name == name then

            return option
        end
    end

    return nil
end

--------------------------------------------------
-- SELECT TAB
--------------------------------------------------

local function SelectTab(tab)

    Window.CurrentTab =
        tab

    ClearMain()

    MainTitle.Text =
        tab.Name

    for _, data in ipairs(
        tab.Buttons
    ) do

        --------------------------------------------------
        -- BUTTON
        --------------------------------------------------

        if data.Click == "Button" then

            local button =
                Instance.new(
                    "TextButton"
                )

            button.Parent =
                MainContent

            button.Name =
                data.Name

            button.LayoutOrder =
                data.Slot

            button.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    45
                )

            button.BackgroundColor3 =
                Color3.fromRGB(
                    90,
                    90,
                    90
                )

            button.BackgroundTransparency =
                0.05

            button.BorderSizePixel =
                0

            button.Text =
                "   "
                .. data.Name

            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            button.TextStrokeTransparency =
                1

            button.TextSize =
                16

            button.Font =
                Enum.Font.GothamBold

            button.TextXAlignment =
                Enum.TextXAlignment.Left

            local corner =
                Instance.new(
                    "UICorner"
                )

            corner.CornerRadius =
                UDim.new(
                    0,
                    8
                )

            corner.Parent =
                button

            local stroke =
                Instance.new(
                    "UIStroke"
                )

            stroke.Color =
                Color3.fromRGB(
                    120,
                    120,
                    120
                )

            stroke.Thickness =
                1

            stroke.Transparency =
                0.25

            stroke.Parent =
                button

            local clickLabel =
                Instance.new(
                    "TextLabel"
                )

            clickLabel.Parent =
                button

            clickLabel.Size =
                UDim2.new(
                    0,
                    65,
                    1,
                    0
                )

            clickLabel.Position =
                UDim2.new(
                    1,
                    -70,
                    0,
                    0
                )

            clickLabel.BackgroundTransparency =
                1

            clickLabel.Text =
                "Click"

            clickLabel.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            clickLabel.TextStrokeTransparency =
                1

            clickLabel.TextSize =
                12

            clickLabel.Font =
                Enum.Font.GothamBold

            clickLabel.TextXAlignment =
                Enum.TextXAlignment.Center

            button.MouseButton1Click:Connect(
                function()

                    if typeof(
                        data.Callback
                    ) == "function" then

                        task.spawn(
                            function()

                                pcall(
                                    function()
                                        data.Callback()
                                    end
                                )

                            end
                        )
                    end
                end
            )

        --------------------------------------------------
        -- LEVER
        --------------------------------------------------

        elseif data.Click == "Lever" then

            local button =
                Instance.new(
                    "TextButton"
                )

            button.Parent =
                MainContent

            button.Name =
                data.Name

            button.LayoutOrder =
                data.Slot

            button.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    45
                )

            button.BackgroundColor3 =
                Color3.fromRGB(
                    90,
                    90,
                    90
                )

            button.BackgroundTransparency =
                0.05

            button.BorderSizePixel =
                0

            button.Text =
                "   "
                .. data.Name

            button.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            button.TextStrokeTransparency =
                1

            button.TextSize =
                16

            button.Font =
                Enum.Font.GothamBold

            button.TextXAlignment =
                Enum.TextXAlignment.Left

            local corner =
                Instance.new(
                    "UICorner"
                )

            corner.CornerRadius =
                UDim.new(
                    0,
                    8
                )

            corner.Parent =
                button

            local stroke =
                Instance.new(
                    "UIStroke"
                )

            stroke.Color =
                Color3.fromRGB(
                    120,
                    120,
                    120
                )

            stroke.Thickness =
                1

            stroke.Transparency =
                0.25

            stroke.Parent =
                button

            local leverBackground =
                Instance.new(
                    "Frame"
                )

            leverBackground.Parent =
                button

            leverBackground.Size =
                UDim2.new(
                    0,
                    65,
                    0,
                    28
                )

            leverBackground.Position =
                UDim2.new(
                    1,
                    -75,
                    0.5,
                    -14
                )

            leverBackground.BorderSizePixel =
                0

            local leverCorner =
                Instance.new(
                    "UICorner"
                )

            leverCorner.CornerRadius =
                UDim.new(
                    1,
                    0
                )

            leverCorner.Parent =
                leverBackground

            local leverStroke =
                Instance.new(
                    "UIStroke"
                )

            leverStroke.Color =
                Color3.fromRGB(
                    160,
                    160,
                    160
                )

            leverStroke.Thickness =
                1

            leverStroke.Parent =
                leverBackground

            local leverText =
                Instance.new(
                    "TextLabel"
                )

            leverText.Parent =
                leverBackground

            leverText.Size =
                UDim2.new(
                    1,
                    0,
                    1,
                    0
                )

            leverText.BackgroundTransparency =
                1

            leverText.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            leverText.TextStrokeTransparency =
                1

            leverText.TextSize =
                12

            leverText.Font =
                Enum.Font.GothamBold

            leverText.TextXAlignment =
                Enum.TextXAlignment.Center

            local circle =
                Instance.new(
                    "Frame"
                )

            circle.Parent =
                leverBackground

            circle.Size =
                UDim2.new(
                    0,
                    22,
                    0,
                    22
                )

            circle.BorderSizePixel =
                0

            circle.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            local circleCorner =
                Instance.new(
                    "UICorner"
                )

            circleCorner.CornerRadius =
                UDim.new(
                    1,
                    0
                )

            circleCorner.Parent =
                circle

            local function UpdateLever()

                if data.Enabled then

                    leverBackground.BackgroundColor3 =
                        Color3.fromRGB(
                            0,
                            150,
                            0
                        )

                    leverText.Text =
                        "ON"

                    circle.Position =
                        UDim2.new(
                            1,
                            -25,
                            0.5,
                            -11
                        )

                else

                    leverBackground.BackgroundColor3 =
                        Color3.fromRGB(
                            70,
                            70,
                            70
                        )

                    leverText.Text =
                        "OFF"

                    circle.Position =
                        UDim2.new(
                            0,
                            3,
                            0.5,
                            -11
                        )
                end
            end

            button.MouseButton1Click:Connect(
                function()

                    data.Enabled =
                        not data.Enabled

                    UpdateLever()

                    if data.Save then

                        SetSavedValue(
                            data.SaveKey,
                            data.Enabled
                        )
                    end

                    if typeof(
                        data.Callback
                    ) == "function" then

                        task.spawn(
                            function()

                                pcall(
                                    function()

                                        data.Callback(
                                            data.Enabled
                                        )

                                    end
                                )

                            end
                        )
                    end
                end
            )

            UpdateLever()

        --------------------------------------------------
        -- SCROLL
        --------------------------------------------------

        elseif data.Click == "Scroll" then

            local expanded =
                data.Expanded == true

            local root =
                Instance.new(
                    "Frame"
                )

            root.Name =
                data.Name

            root.Parent =
                MainContent

            root.LayoutOrder =
                data.Slot

            root.BackgroundTransparency =
                1

            root.BorderSizePixel =
                0

            root.ClipsDescendants =
                true

            local function GetExpandedHeight()

                local height =
                    45 + 150 + 10

                if data.ChildClick
                    == "Button"

                    or data.ChildClick
                    == "Lever" then

                    height =
    height + 35
                end

                return height
            end

            if expanded then

                root.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        GetExpandedHeight()
                    )

            else

                root.Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        45
                    )
            end

            --------------------------------------------------
            -- HEADER
            --------------------------------------------------

            local header =
                Instance.new(
                    "TextButton"
                )

            header.Parent =
                root

            header.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    45
                )

            header.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )

            header.BackgroundColor3 =
                Color3.fromRGB(
                    90,
                    90,
                    90
                )

            header.BackgroundTransparency =
                0.05

            header.BorderSizePixel =
                0

            header.Text =
                "   "
                .. data.Name

            header.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            header.TextStrokeTransparency =
                1

            header.TextSize =
                16

            header.Font =
                Enum.Font.GothamBold

            header.TextXAlignment =
                Enum.TextXAlignment.Left

            local headerCorner =
                Instance.new(
                    "UICorner"
                )

            headerCorner.CornerRadius =
                UDim.new(
                    0,
                    8
                )

            headerCorner.Parent =
                header

            local headerStroke =
                Instance.new(
                    "UIStroke"
                )

            headerStroke.Color =
                Color3.fromRGB(
                    120,
                    120,
                    120
                )

            headerStroke.Thickness =
                1

            headerStroke.Transparency =
                0.25

            headerStroke.Parent =
                header

            --------------------------------------------------
            -- COUNT
            --------------------------------------------------

            local countLabel =
                Instance.new(
                    "TextLabel"
                )

            countLabel.Parent =
                header

            countLabel.Size =
                UDim2.new(
                    0,
                    90,
                    1,
                    0
                )

            countLabel.Position =
                UDim2.new(
                    1,
                    -125,
                    0,
                    0
                )

            countLabel.BackgroundTransparency =
                1

            countLabel.TextColor3 =
                Color3.fromRGB(
                    230,
                    230,
                    230
                )

            countLabel.TextStrokeTransparency =
                1

            countLabel.TextSize =
                12

            countLabel.Font =
                Enum.Font.GothamBold

            countLabel.TextXAlignment =
                Enum.TextXAlignment.Center

            --------------------------------------------------
            -- ARROW
            --------------------------------------------------

            local arrow =
                Instance.new(
                    "TextLabel"
                )

            arrow.Parent =
                header

            arrow.Size =
                UDim2.new(
                    0,
                    30,
                    1,
                    0
                )

            arrow.Position =
                UDim2.new(
                    1,
                    -35,
                    0,
                    0
                )

            arrow.BackgroundTransparency =
                1

            arrow.TextColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )

            arrow.TextStrokeTransparency =
                1

            arrow.TextSize =
                18

            arrow.Font =
                Enum.Font.GothamBold

            arrow.TextXAlignment =
                Enum.TextXAlignment.Center

            --------------------------------------------------
            -- INNER SCROLL
            --------------------------------------------------

            local scrollFrame =
                Instance.new(
                    "ScrollingFrame"
                )

            scrollFrame.Parent =
                root

            scrollFrame.Size =
                UDim2.new(
                    1,
                    0,
                    0,
                    150
                )

            scrollFrame.Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    50
                )

            scrollFrame.BackgroundColor3 =
                Color3.fromRGB(
                    75,
                    75,
                    75
                )

            scrollFrame.BorderSizePixel =
                0

            scrollFrame.ScrollBarThickness =
                4

            scrollFrame.ScrollingEnabled =
                true

            scrollFrame.Visible =
                expanded

            scrollFrame.CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )

            local scrollCorner =
                Instance.new(
                    "UICorner"
                )

            scrollCorner.CornerRadius =
                UDim.new(
                    0,
                    8
                )

            scrollCorner.Parent =
                scrollFrame

            local scrollStroke =
                Instance.new(
                    "UIStroke"
                )

            scrollStroke.Color =
                Color3.fromRGB(
                    120,
                    120,
                    120
                )

            scrollStroke.Thickness =
                1

            scrollStroke.Parent =
                scrollFrame

            local optionLayout =
                Instance.new(
                    "UIListLayout"
                )

            optionLayout.Parent =
                scrollFrame

            optionLayout.Padding =
                UDim.new(
                    0,
                    5
                )

            optionLayout.SortOrder =
                Enum.SortOrder.LayoutOrder

            --------------------------------------------------
            -- COUNT
            --------------------------------------------------

            local function UpdateCount()

                if data.Max then

                    countLabel.Text =
                        tostring(
                            #data.Selected
                        )
                        .. "/"
                        .. tostring(
                            data.Max
                        )

                else

                    countLabel.Text =
                        tostring(
                            #data.Selected
                        )
                        .. " selected"
                end
            end

            --------------------------------------------------
            -- SAVE
            --------------------------------------------------

            local function SaveScroll()

                if data.Save then

                    SetSavedValue(
                        data.SaveKey,
                        data.Selected
                    )
                end
            end

            --------------------------------------------------
            -- OPTIONS
            --------------------------------------------------

            for index, optionData
                in ipairs(
                    data.Options
                ) do

                if type(optionData)
                    == "string" then

                    optionData = {
                        Name =
                            optionData
                    }
                end

                if type(optionData)
                    == "table" then

                    local optionName =
                        tostring(
                            optionData.Name
                            or (
                                "Option "
                                .. index
                            )
                        )

                    local option =
                        Instance.new(
                            "TextButton"
                        )

                    option.Parent =
                        scrollFrame

                    option.Name =
                        optionName

                    option.LayoutOrder =
                        index

                    option.Size =
                        UDim2.new(
                            1,
                            -8,
                            0,
                            38
                        )

                    option.BackgroundColor3 =
                        Color3.fromRGB(
                            85,
                            85,
                            85
                        )

                    option.BorderSizePixel =
                        0

                    option.Text =
                        "   "
                        .. optionName

                    option.TextColor3 =
                        Color3.fromRGB(
                            255,
                            255,
                            255
                        )

                    option.TextStrokeTransparency =
                        1

                    option.TextSize =
                        14

                    option.Font =
                        Enum.Font.GothamBold

                    option.TextXAlignment =
                        Enum.TextXAlignment.Left

                    local optionCorner =
                        Instance.new(
                            "UICorner"
                        )

                    optionCorner.CornerRadius =
                        UDim.new(
                            0,
                            7
                        )

                    optionCorner.Parent =
                        option

                    local selectedMark =
                        Instance.new(
                            "TextLabel"
                        )

                    selectedMark.Parent =
                        option

                    selectedMark.Size =
                        UDim2.new(
                            0,
                            35,
                            1,
                            0
                        )

                    selectedMark.Position =
                        UDim2.new(
                            1,
                            -40,
                            0,
                            0
                        )

                    selectedMark.BackgroundTransparency =
                        1

                    selectedMark.TextColor3 =
                        Color3.fromRGB(
                            255,
                            255,
                            255
                        )

                    selectedMark.TextStrokeTransparency =
                        1

                    selectedMark.TextSize =
                        18

                    selectedMark.Font =
                        Enum.Font.GothamBold

                    selectedMark.TextXAlignment =
                        Enum.TextXAlignment.Center

                    local function UpdateOption()

                        if IsNameSelected(
                            data.Selected,
                            optionName
                        ) then

                            option.BackgroundColor3 =
                                Color3.fromRGB(
                                    0,
                                    120,
                                    0
                                )

                            selectedMark.Text =
                                "✓"

                        else

                            option.BackgroundColor3 =
                                Color3.fromRGB(
                                    85,
                                    85,
                                    85
                                )

                            selectedMark.Text =
                                ""
                        end
                    end

                    option.MouseButton1Click:Connect(
                        function()

                            local selected =
                                IsNameSelected(
                                    data.Selected,
                                    optionName
                                )

                            if selected then

                                if data.Min
                                    and #data.Selected
                                        <= data.Min then

                                    return
                                end

                                RemoveSelectedName(
                                    data.Selected,
                                    optionName
                                )

                            else

                                if data.Max
                                    and #data.Selected
                                        >= data.Max then

                                    return
                                end

                                table.insert(
                                    data.Selected,
                                    optionName
                                )
                            end

                            UpdateOption()
                            UpdateCount()
                            SaveScroll()
                        end
                    )

                    UpdateOption()
                end
            end

            --------------------------------------------------
            -- INNER SCROLL UPDATE
            --------------------------------------------------

            local function UpdateInnerScroll()

                local contentHeight =
                    optionLayout.AbsoluteContentSize.Y

                local viewportHeight =
                    scrollFrame.AbsoluteSize.Y

                local needsScroll =
                    contentHeight
                    > viewportHeight + 1

                scrollFrame.ScrollingEnabled =
                    needsScroll

                if needsScroll then

                    scrollFrame.ScrollBarThickness =
                        4

                    scrollFrame.CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            contentHeight + 10
                        )

                else

                    scrollFrame.ScrollBarThickness =
                        0

                    scrollFrame.CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            viewportHeight
                        )

                    scrollFrame.CanvasPosition =
                        Vector2.new(
                            0,
                            0
                        )
                end
            end

            optionLayout:GetPropertyChangedSignal(
                "AbsoluteContentSize"
            ):Connect(
                UpdateInnerScroll
            )

            scrollFrame:GetPropertyChangedSignal(
                "AbsoluteSize"
            ):Connect(
                UpdateInnerScroll
            )

            UpdateInnerScroll()

            --------------------------------------------------
            -- CHILD CONTROL
            --------------------------------------------------

            local childControl =
                nil

            if data.ChildClick
                == "Button" then

                childControl =
                    Instance.new(
                        "TextButton"
                    )

                childControl.Parent =
                    root

                childControl.Size =
    UDim2.new(
        0,
        100,
        0,
        32
    )

                childControl.Position =
    UDim2.new(
        1,
        -100,
        0,
        210
    )

                childControl.BackgroundColor3 =
                    Color3.fromRGB(
                        100,
                        100,
                        100
                    )

                childControl.BorderSizePixel =
                    0

                childControl.Text =
                    data.ChildName
                    or "Execute Selected"

                childControl.TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    )

                childControl.TextStrokeTransparency =
                    1

                childControl.TextSize =
                    14

                childControl.Font =
                    Enum.Font.GothamBold

                childControl.Visible =
                    expanded

                local childCorner =
                    Instance.new(
                        "UICorner"
                    )

                childCorner.CornerRadius =
                    UDim.new(
                        0,
                        8
                    )

                childCorner.Parent =
                    childControl

                local childStroke =
                    Instance.new(
                        "UIStroke"
                    )

                childStroke.Color =
                    Color3.fromRGB(
                        120,
                        120,
                        120
                    )

                childStroke.Thickness =
                    1

                childStroke.Parent =
                    childControl

                childControl.MouseButton1Click:Connect(
                    function()

                        if data.Min
                            and #data.Selected
                                < data.Min then

                            return
                        end

                        if typeof(
                            data.Callback
                        ) == "function" then

                            task.spawn(
                                function()

                                    pcall(
                                        function()

                                            data.Callback(
                                                data.Selected
                                            )

                                        end
                                    )
                                end
                            )
                        end

                        for _, selectedName
                            in ipairs(
                                data.Selected
                            ) do

                            local option =
                                FindOption(
                                    data.Options,
                                    selectedName
                                )

                            if option
                                and typeof(
                                    option.Callback
                                ) == "function" then

                                task.spawn(
                                    function()

                                        pcall(
                                            function()

                                                option.Callback(
                                                    selectedName,
                                                    data.Selected
                                                )

                                            end
                                        )
                                    end
                                )
                            end
                        end
                    end
                )

            elseif data.ChildClick
                == "Lever" then

                childControl =
                    Instance.new(
                        "TextButton"
                    )

                childControl.Parent =
                    root

                childControl.Size =
    UDim2.new(
        0,
        100,
        0,
        32
    )

                childControl.Position =
    UDim2.new(
        1,
        -100,
        0,
        210
    )

                childControl.BackgroundColor3 =
                    Color3.fromRGB(
                        100,
                        100,
                        100
                    )

                childControl.BorderSizePixel =
                    0

                childControl.Text =
                    "   "
                    .. (
                        data.ChildName
                        or "Auto Execute"
                    )

                childControl.TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    )

                childControl.TextStrokeTransparency =
                    1

                childControl.TextSize =
                    14

                childControl.Font =
                    Enum.Font.GothamBold

                childControl.TextXAlignment =
                    Enum.TextXAlignment.Left

                childControl.Visible =
                    expanded

                local childCorner =
                    Instance.new(
                        "UICorner"
                    )

                childCorner.CornerRadius =
                    UDim.new(
                        0,
                        8
                    )

                childCorner.Parent =
                    childControl

                local childLever =
                    Instance.new(
                        "Frame"
                    )

                childLever.Parent =
                    childControl

                childLever.Size =
                    UDim2.new(
                        0,
                        65,
                        0,
                        28
                    )

                childLever.Position =
                    UDim2.new(
                        1,
                        -75,
                        0.5,
                        -14
                    )

                childLever.BorderSizePixel =
                    0

                local childLeverCorner =
                    Instance.new(
                        "UICorner"
                    )

                childLeverCorner.CornerRadius =
                    UDim.new(
                        1,
                        0
                    )

                childLeverCorner.Parent =
                    childLever

                local childLeverText =
                    Instance.new(
                        "TextLabel"
                    )

                childLeverText.Parent =
                    childLever

                childLeverText.Size =
                    UDim2.new(
                        1,
                        0,
                        1,
                        0
                    )

                childLeverText.BackgroundTransparency =
                    1

                childLeverText.TextSize =
                    12

                childLeverText.Font =
                    Enum.Font.GothamBold

                childLeverText.TextColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    )

                childLeverText.TextXAlignment =
                    Enum.TextXAlignment.Center

                local childCircle =
                    Instance.new(
                        "Frame"
                    )

                childCircle.Parent =
                    childLever

                childCircle.Size =
                    UDim2.new(
                        0,
                        22,
                        0,
                        22
                    )

                childCircle.BorderSizePixel =
                    0

                childCircle.BackgroundColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    )

                local childCircleCorner =
                    Instance.new(
                        "UICorner"
                    )

                childCircleCorner.CornerRadius =
                    UDim.new(
                        1,
                        0
                    )

                childCircleCorner.Parent =
                    childCircle

                local function UpdateChildLever()

                    if data.ChildEnabled then

                        childLever.BackgroundColor3 =
                            Color3.fromRGB(
                                0,
                                150,
                                0
                            )

                        childLeverText.Text =
                            "ON"

                        childCircle.Position =
                            UDim2.new(
                                1,
                                -25,
                                0.5,
                                -11
                            )

                    else

                        childLever.BackgroundColor3 =
                            Color3.fromRGB(
                                70,
                                70,
                                70
                            )

                        childLeverText.Text =
                            "OFF"

                        childCircle.Position =
                            UDim2.new(
                                0,
                                3,
                                0.5,
                                -11
                            )
                    end
                end

                UpdateChildLever()

                childControl.MouseButton1Click:Connect(
                    function()

                        if data.Min
                            and #data.Selected
                                < data.Min then

                            return
                        end

                        data.ChildEnabled =
                            not data.ChildEnabled

                        if data.ChildSave then

                            SetSavedValue(
                                data.ChildSaveKey,
                                data.ChildEnabled
                            )
                        end

                        UpdateChildLever()

                        if typeof(
                            data.ChildCallback
                        ) == "function" then

                            task.spawn(
                                function()

                                    pcall(
                                        function()

                                            data.ChildCallback(
                                                data.ChildEnabled,
                                                data.Selected
                                            )

                                        end
                                    )
                                end
                            )
                        end
                    end
                )

                if data.ChildEnabled
                    and #data.Selected > 0
                    and typeof(
                        data.ChildCallback
                    ) == "function" then

                    task.spawn(
                        function()

                            pcall(
                                function()

                                    data.ChildCallback(
                                        true,
                                        data.Selected
                                    )
                                end
                            )
                        end
                    )
                end
            end

            --------------------------------------------------
            -- HEADER
            --------------------------------------------------

            UpdateCount()

            arrow.Text =
                expanded
                and "▲"
                or "▼"

            header.MouseButton1Click:Connect(
                function()

                    data.Expanded =
                        not data.Expanded

                    if data.Expanded then

                        root.Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                GetExpandedHeight()
                            )

                        scrollFrame.Visible =
                            true

                        if childControl then
                            childControl.Visible =
                                true
                        end

                        arrow.Text =
                            "▲"

                    else

                        root.Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                45
                            )

                        scrollFrame.Visible =
                            false

                        if childControl then
                            childControl.Visible =
                                false
                        end

                        arrow.Text =
                            "▼"
                    end

                    UpdateMainScroll()
                end
            )
        end
    end

    UpdateMainScroll()
end

--------------------------------------------------
-- MAKE TAB
--------------------------------------------------

function Window:MakeTab(data)

    data =
        data or {}

    local tab = {

        Name =
            data.Name
            or "Tab",

        Icon =
            data.Icon
            or "",

        PremiumOnly =
            data.PremiumOnly
            or false,

        Slot =
            tonumber(
                data.Slot
            )
            or (
                #Window.Tabs + 1
            ),

        Link =
            data.Link,

        Loaded =
            false,

        Buttons =
            {},

        Sequence =
            0
    }

    table.insert(
        Window.Tabs,
        tab
    )

    --------------------------------------------------
    -- TAB BUTTON
    --------------------------------------------------

    local tabButton =
        Instance.new(
            "TextButton"
        )

    tabButton.Name =
        tab.Name

    tabButton.Parent =
        HotbarContent

    tabButton.LayoutOrder =
        tab.Slot

    tabButton.Size =
        UDim2.new(
            1,
            -5,
            0,
            42
        )

    tabButton.BackgroundColor3 =
        Color3.fromRGB(
            75,
            75,
            75
        )

    tabButton.BackgroundTransparency =
        0.05

    tabButton.BorderSizePixel =
        0

    tabButton.Text =
        "   "
        .. tab.Name

    tabButton.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    tabButton.TextStrokeTransparency =
        1

    tabButton.TextSize =
        14

    tabButton.Font =
        Enum.Font.GothamBold

    tabButton.TextXAlignment =
        Enum.TextXAlignment.Left

    local tabCorner =
        Instance.new(
            "UICorner"
        )

    tabCorner.CornerRadius =
        UDim.new(
            0,
            7
        )

    tabCorner.Parent =
        tabButton

    local tabStroke =
        Instance.new(
            "UIStroke"
        )

    tabStroke.Color =
        Color3.fromRGB(
            120,
            120,
            120
        )

    tabStroke.Thickness =
        1

    tabStroke.Transparency =
        0.3

    tabStroke.Parent =
        tabButton

    tabButton.MouseButton1Click:Connect(
        function()

            SelectTab(tab)

            if tab.Link
                and not tab.Loaded then

                tab.Loaded =
                    true

                task.spawn(
                    function()

                        LoadRemoteScript(
                            tab.Link
                        )

                        task.defer(
                            function()

                                UpdateMainScroll()
                            end
                        )
                    end
                )
            end
        end
    )

    --------------------------------------------------
    -- ADD BUTTON
    --------------------------------------------------

    function tab:AddButton(
        buttonData
    )

        buttonData =
            buttonData
            or {}

        tab.Sequence =
            tab.Sequence + 1

        local info = {

            Name =
                buttonData.Name
                or "Button",

            Click =
                buttonData.Click
                or "Button",

            Callback =
                buttonData.Callback,

            Default =
                buttonData.Default
                == true,

            Save =
                buttonData.Save
                == true,

            Slot =
                tonumber(
                    buttonData.Slot
                )
                or tab.Sequence,

            Sequence =
                tab.Sequence
        }

        if info.Click ~= "Button"
            and info.Click ~= "Lever"
            and info.Click ~= "Scroll" then

            info.Click =
                "Button"
        end

        --------------------------------------------------
        -- BUTTON
        --------------------------------------------------

        if info.Click == "Button" then

            info.SaveKey =
                tab.Name
                .. "_"
                .. tostring(
                    info.Slot
                )
                .. "_"
                .. tostring(
                    info.Name
                )

        --------------------------------------------------
        -- LEVER
        --------------------------------------------------

        elseif info.Click == "Lever" then

            info.SaveKey =
                tab.Name
                .. "_"
                .. tostring(
                    info.Slot
                )
                .. "_"
                .. tostring(
                    info.Name
                )

            local saved =
                GetSavedValue(
                    info.SaveKey
                )

            if info.Save
                and saved ~= nil then

                info.Enabled =
                    saved

            else

                info.Enabled =
                    info.Default
            end

            if info.Enabled
                and typeof(
                    info.Callback
                ) == "function" then

                task.spawn(
                    function()

                        pcall(
                            function()

                                info.Callback(
                                    true
                                )
                            end
                        )
                    end
                )
            end

        --------------------------------------------------
        -- SCROLL
        --------------------------------------------------

        elseif info.Click == "Scroll" then

            info.Min =
                tonumber(
                    buttonData.Min
                )

            info.Max =
                tonumber(
                    buttonData.Max
                )

            info.Classic =
                {}

            if type(
                buttonData.Classic
            ) == "table" then

                for _, value in ipairs(
                    buttonData.Classic
                ) do

                    if type(value)
                        == "string" then

                        table.insert(
                            info.Classic,
                            value
                        )
                    end
                end
            end

            info.Options =
                type(
                    buttonData.Options
                ) == "table"
                and buttonData.Options
                or {}

            info.SaveKey =
                tab.Name
                .. "_"
                .. tostring(
                    info.Slot
                )
                .. "_"
                .. tostring(
                    info.Name
                )
                .. "_Scroll"

            info.Selected =
                {}

            local saved =
                GetSavedValue(
                    info.SaveKey
                )

            if info.Save
                and type(saved)
                    == "table" then

                for _, savedName
                    in ipairs(saved) do

                    if FindOption(
                        info.Options,
                        savedName
                    ) then

                        table.insert(
                            info.Selected,
                            savedName
                        )
                    end
                end

            else

                for _, classicName
                    in ipairs(
                        info.Classic
                    ) do

                    if FindOption(
                        info.Options,
                        classicName
                    ) then

                        table.insert(
                            info.Selected,
                            classicName
                        )
                    end
                end
            end

            if info.Max
                and #info.Selected
                    > info.Max then

                while #info.Selected
                    > info.Max do

                    table.remove(
                        info.Selected
                    )
                end
            end

            info.ChildClick =
                buttonData.ChildClick

            info.ChildName =
                buttonData.ChildName

            info.ChildDefault =
                buttonData.ChildDefault
                == true

            info.ChildSave =
                buttonData.ChildSave
                == true
                or info.Save

            info.ChildCallback =
                buttonData.ChildCallback

            info.ChildSaveKey =
                tab.Name
                .. "_"
                .. tostring(
                    info.Slot
                )
                .. "_"
                .. tostring(
                    info.Name
                )
                .. "_Child"

            info.ChildEnabled =
                info.ChildDefault

            local childSaved =
                GetSavedValue(
                    info.ChildSaveKey
                )

            if info.ChildSave
                and childSaved ~= nil then

                info.ChildEnabled =
                    childSaved
            end

            info.Expanded =
                false
        end

        table.insert(
            tab.Buttons,
            info
        )

        if Window.CurrentTab
            == tab then

            SelectTab(tab)
        end

        return info
    end

    UpdateHotbarScroll()

    return tab
end

--------------------------------------------------
-- DRAG
--------------------------------------------------

MakeDraggable(
    MenuContainer,
    MenuTopBar
)

MakeDraggable(
    HubButton,
    HubButton
)

--------------------------------------------------
-- HUB BUTTON
--------------------------------------------------

HubButton.MouseButton1Click:Connect(
    function()

        MenuUi.Enabled =
            not MenuUi.Enabled

        if MenuUi.Enabled then

            HubStroke.Thickness =
                2.5

            HubStroke.Transparency =
                0.05

        else

            HubStroke.Thickness =
                1

            HubStroke.Transparency =
                0.45
        end
    end
)

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

MinimizeButton.MouseButton1Click:Connect(
    function()

        MenuUi.Enabled =
            false

        HubStroke.Thickness =
            1

        HubStroke.Transparency =
            0.45
    end
)

--------------------------------------------------
-- FULLSCREEN
--------------------------------------------------

FullscreenButton.MouseButton1Click:Connect(
    function()

        IsFullscreen =
            not IsFullscreen

        if IsFullscreen then

            MenuContainer.Size =
                FullscreenSize

            MenuContainer.Position =
                FullscreenPosition

            FullscreenButton.Text =
                "❐"

        else

            MenuContainer.Size =
                NormalSize

            MenuContainer.Position =
                NormalPosition

            FullscreenButton.Text =
                "□"
        end

        UpdateMenuScale()

        task.defer(
            function()

                UpdateMainScroll()
                UpdateHotbarScroll()
            end
        )
    end
)

--------------------------------------------------
-- X
--------------------------------------------------

XButton.MouseButton1Click:Connect(
    function()

        MenuUi.Enabled =
            false

        CloseGui.Enabled =
            true

        HubStroke.Thickness =
            1

        HubStroke.Transparency =
            0.45
    end
)

--------------------------------------------------
-- CANCEL
--------------------------------------------------

Cannel.MouseButton1Click:Connect(
    function()

        CloseGui.Enabled =
            false

        MenuUi.Enabled =
            true

        HubStroke.Thickness =
            2.5

        HubStroke.Transparency =
            0.05
    end
)

--------------------------------------------------
-- CLOSE
--------------------------------------------------

CloseButton.MouseButton1Click:Connect(
    function()

        pcall(function()
            HubUi:Destroy()
        end)

        pcall(function()
            MenuUi:Destroy()
        end)

        pcall(function()
            CloseGui:Destroy()
        end)
    end
)

--------------------------------------------------
-- LOAD HOTBAR
--------------------------------------------------

task.spawn(function()

    LoadRemoteScript(
        HOTBAR_URL
    )

    task.defer(function()

        UpdateMainScroll()
        UpdateHotbarScroll()
    end)
end)

--------------------------------------------------
-- FINAL UPDATE
--------------------------------------------------

task.defer(function()

    UpdateMainScroll()
    UpdateHotbarScroll()
end)

--------------------------------------------------
-- DEFAULT
--------------------------------------------------

HubStroke.Thickness =
    1

HubStroke.Transparency =
    0.45
