local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local HUB_UI_NAME = "HubUi"
local HUB_BUTTON_NAME = "HubButton"

local WAIT_TIMEOUT = 10

local ORB_COUNT = 7
local ORB_SIZE = 22
local ORB_COLOR = Color3.fromRGB(145,70,220)
local ORB_GLOW_COLOR = Color3.fromRGB(255,220,70)

local GATHER_TIME = 0.9
local ORBIT_TIME = 2.2
local ORBIT_RADIUS = 55
local ORBIT_SPEED = 1.15

local BLINK_COUNT = 7
local BLINK_ON_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local CORE_GROW_TIME = 0.35
local EXPLOSION_COUNT = 18
local EXPLOSION_SPEED = 0.65
local EXPLOSION_DISTANCE = 90

local FAKE_BUTTON_TIME = 1.8

--------------------------------------------------
-- FIND ORIGINAL GUI
--------------------------------------------------

local function GetHub()

    local start = tick()

    while tick() - start < WAIT_TIMEOUT do

        local hubUi = CoreGui:FindFirstChild(HUB_UI_NAME)

        if hubUi then

            local hubButton =
                hubUi:FindFirstChild(HUB_BUTTON_NAME)

            if hubButton then
                return hubUi,hubButton
            end
        end

        task.wait(0.1)
    end

    warn(
        "[CustomHub] LoadScriptAnimation: Không tìm thấy HubUi/HubButton."
    )

    return nil,nil
end

local HubUi,HubButton = GetHub()

if not HubUi or not HubButton then
    return
end

--------------------------------------------------
-- CLEAN OLD ANIMATION
--------------------------------------------------

local OldAnimation =
    CoreGui:FindFirstChild("CustomHub_LoadAnimation")

if OldAnimation then

    pcall(function()
        OldAnimation:Destroy()
    end)

end

--------------------------------------------------
-- SAVE ORIGINAL BUTTON STATE
--------------------------------------------------

local OriginalPosition =
    HubButton.Position

local OriginalSize =
    HubButton.Size

local OriginalAnchorPoint =
    HubButton.AnchorPoint

local OriginalRotation =
    HubButton.Rotation

local OriginalVisible =
    HubButton.Visible

local OriginalZIndex =
    HubButton.ZIndex

--------------------------------------------------
-- ANIMATION GUI
--------------------------------------------------

local AnimationGui =
    Instance.new("ScreenGui")

AnimationGui.Name =
    "CustomHub_LoadAnimation"

AnimationGui.ResetOnSpawn =
    false

AnimationGui.IgnoreGuiInset =
    true

AnimationGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Global

AnimationGui.DisplayOrder =
    999999

AnimationGui.Parent =
    CoreGui

--------------------------------------------------
-- HIDE REAL HUB BUTTON
--------------------------------------------------

HubButton.Visible = false

--------------------------------------------------
-- CAMERA
--------------------------------------------------

local Camera =
    workspace.CurrentCamera

if not Camera then

    AnimationGui:Destroy()

    HubButton.Visible =
        OriginalVisible

    return
end

local Viewport =
    Camera.ViewportSize

local CenterX =
    Viewport.X / 2

local CenterY =
    Viewport.Y / 2

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function NewCorner(parent,radius)

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            radius or 1,
            0
        )

    corner.Parent =
        parent

    return corner
end

local function NewStroke(
    parent,
    color,
    thickness,
    transparency
)

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        color

    stroke.Thickness =
        thickness

    stroke.Transparency =
        transparency or 0

    stroke.Parent =
        parent

    return stroke
end

local function Tween(
    object,
    time,
    properties,
    style,
    direction
)

    local info =
        TweenInfo.new(
            time,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        )

    local tween =
        TweenService:Create(
            object,
            info,
            properties
        )

    tween:Play()

    return tween
end

--------------------------------------------------
-- CREATE ORB
--------------------------------------------------

local function CreateOrb()

    local orb =
        Instance.new("Frame")

    orb.Name =
        "PurpleOrb"

    orb.Size =
        UDim2.new(
            0,
            ORB_SIZE,
            0,
            ORB_SIZE
        )

    orb.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    orb.BackgroundColor3 =
        ORB_COLOR

    orb.BackgroundTransparency =
        0

    orb.BorderSizePixel =
        0

    orb.ZIndex =
        20

    NewCorner(
        orb,
        1
    )

    local stroke =
        NewStroke(
            orb,
            ORB_GLOW_COLOR,
            2,
            0
        )

    --------------------------------------------------
    -- SMALL YELLOW GLOW
    --------------------------------------------------

    local glow =
        Instance.new("Frame")

    glow.Name =
        "YellowGlow"

    glow.Size =
        UDim2.new(
            1,
            8,
            1,
            8
        )

    glow.Position =
        UDim2.new(
            0.5,
            -4,
            0.5,
            -4
        )

    glow.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    glow.BackgroundColor3 =
        ORB_GLOW_COLOR

    glow.BackgroundTransparency =
        0.82

    glow.BorderSizePixel =
        0

    glow.ZIndex =
        19

    NewCorner(
        glow,
        1
    )

    glow.Parent =
        orb

    orb.Parent =
        AnimationGui

    return orb,stroke,glow
end

--------------------------------------------------
-- CREATE 7 ORBS
--------------------------------------------------

local Orbs = {}

for i = 1,ORB_COUNT do

    local orb,stroke,glow =
        CreateOrb()

    local randomX =
        math.random(
            80,
            math.max(
                81,
                math.floor(Viewport.X - 80)
            )
        )

    local randomY =
        math.random(
            80,
            math.max(
                81,
                math.floor(Viewport.Y - 80)
            )
        )

    orb.Position =
        UDim2.new(
            0,
            randomX,
            0,
            randomY
        )

    table.insert(
        Orbs,
        {
            Object = orb,
            Stroke = stroke,
            Glow = glow,
            Index = i
        }
    )
end

--------------------------------------------------
-- GATHER TO CIRCLE
--------------------------------------------------

local CirclePositions = {}

for i = 1,ORB_COUNT do

    local angle =
        ((i - 1) / ORB_COUNT)
        * math.pi
        * 2

    local x =
        CenterX
        + math.cos(angle)
        * ORBIT_RADIUS

    local y =
        CenterY
        + math.sin(angle)
        * ORBIT_RADIUS

    CirclePositions[i] =
        Vector2.new(
            x,
            y
        )
end

for _,data in ipairs(Orbs) do

    local target =
        CirclePositions[
            data.Index
        ]

    Tween(
        data.Object,
        GATHER_TIME,
        {
            Position =
                UDim2.new(
                    0,
                    target.X,
                    0,
                    target.Y
                )
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
end

task.wait(GATHER_TIME)

--------------------------------------------------
-- SLOW CIRCLE ROTATION
--------------------------------------------------

local OrbitStart =
    tick()

while tick() - OrbitStart < ORBIT_TIME do

    local elapsed =
        tick() - OrbitStart

    local rotation =
        elapsed
        * ORBIT_SPEED

    for _,data in ipairs(Orbs) do

        if data.Object.Parent then

            local baseAngle =
                ((data.Index - 1) / ORB_COUNT)
                * math.pi
                * 2

            local angle =
                baseAngle
                + rotation

            local x =
                CenterX
                + math.cos(angle)
                * ORBIT_RADIUS

            local y =
                CenterY
                + math.sin(angle)
                * ORBIT_RADIUS

            data.Object.Position =
                UDim2.new(
                    0,
                    x,
                    0,
                    y
                )
        end
    end

    RunService.RenderStepped:Wait()
end

--------------------------------------------------
-- BLINK 7 TIMES
--------------------------------------------------

for blink = 1,BLINK_COUNT do

    for _,data in ipairs(Orbs) do

        if data.Stroke then
            data.Stroke.Transparency = 0
            data.Stroke.Thickness = 4
        end

        if data.Glow then
            data.Glow.BackgroundTransparency = 0.55
        end
    end

    task.wait(BLINK_ON_TIME)

    for _,data in ipairs(Orbs) do

        if data.Stroke then
            data.Stroke.Transparency = 0.8
            data.Stroke.Thickness = 2
        end

        if data.Glow then
            data.Glow.BackgroundTransparency = 0.9
        end
    end

    task.wait(BLINK_OFF_TIME)
end

--------------------------------------------------
-- MERGE INTO LARGE CORE
--------------------------------------------------

for _,data in ipairs(Orbs) do

    Tween(
        data.Object,
        CORE_GROW_TIME,
        {
            Position =
                UDim2.new(
                    0,
                    CenterX,
                    0,
                    CenterY
                ),
            Size =
                UDim2.new(
                    0,
                    42,
                    0,
                    42
                )
        },
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
end

task.wait(CORE_GROW_TIME)

--------------------------------------------------
-- REMOVE ORBS
--------------------------------------------------

for _,data in ipairs(Orbs) do

    pcall(function()
        data.Object:Destroy()
    end)

end

--------------------------------------------------
-- EXPLOSION
--------------------------------------------------

local ExplosionParts = {}

for i = 1,EXPLOSION_COUNT do

    local part =
        Instance.new("Frame")

    part.Name =
        "ExplosionPart"

    local size =
        math.random(
            8,
            15
        )

    part.Size =
        UDim2.new(
            0,
            size,
            0,
            size
        )

    part.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    part.Position =
        UDim2.new(
            0,
            CenterX,
            0,
            CenterY
        )

    part.BackgroundColor3 =
        ORB_COLOR

    part.BorderSizePixel =
        0

    part.ZIndex =
        25

    NewCorner(
        part,
        1
    )

    NewStroke(
        part,
        ORB_GLOW_COLOR,
        2,
        0.15
    )

    part.Parent =
        AnimationGui

    local angle =
        math.random()
        * math.pi
        * 2

    local distance =
        math.random(
            math.floor(
                EXPLOSION_DISTANCE * 0.55
            ),
            EXPLOSION_DISTANCE
        )

    local targetX =
        CenterX
        + math.cos(angle)
        * distance

    local targetY =
        CenterY
        + math.sin(angle)
        * distance

    table.insert(
        ExplosionParts,
        part
    )

    Tween(
        part,
        EXPLOSION_SPEED
            + math.random() * 0.25,
        {
            Position =
                UDim2.new(
                    0,
                    targetX,
                    0,
                    targetY
                ),
            BackgroundTransparency =
                1
        },
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

end

--------------------------------------------------
-- CREATE FAKE HUB BUTTON
--------------------------------------------------

local FakeHubButton =
    Instance.new("TextButton")

FakeHubButton.Name =
    "HubButtonFake"

FakeHubButton.Size =
    OriginalSize

FakeHubButton.AnchorPoint =
    OriginalAnchorPoint

FakeHubButton.Position =
    UDim2.new(
        0,
        CenterX,
        0,
        CenterY
    )

FakeHubButton.Rotation =
    OriginalRotation

FakeHubButton.BackgroundColor3 =
    HubButton.BackgroundColor3

FakeHubButton.BackgroundTransparency =
    HubButton.BackgroundTransparency

FakeHubButton.BorderSizePixel =
    HubButton.BorderSizePixel

FakeHubButton.Text =
    HubButton.Text

FakeHubButton.TextColor3 =
    HubButton.TextColor3

FakeHubButton.TextStrokeTransparency =
    HubButton.TextStrokeTransparency

FakeHubButton.TextSize =
    HubButton.TextSize

FakeHubButton.Font =
    HubButton.Font

FakeHubButton.AutoButtonColor =
    false

FakeHubButton.ZIndex =
    50

NewCorner(
    FakeHubButton,
    1
)

local FakeStroke =
    NewStroke(
        FakeHubButton,
        Color3.fromRGB(
            255,
            255,
            255
        ),
        2.5,
        0.05
    )

FakeHubButton.Parent =
    AnimationGui

--------------------------------------------------
-- FAKE BUTTON APPEAR
--------------------------------------------------

FakeHubButton.Size =
    UDim2.new(
        0,
        0,
        0,
        0
    )

Tween(
    FakeHubButton,
    0.35,
    {
        Size =
            OriginalSize
    },
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

task.wait(0.4)

--------------------------------------------------
-- FAKE BUTTON FLIGHT TO ORIGINAL POSITION
--------------------------------------------------

local FlyTween =
    Tween(
        FakeHubButton,
        FAKE_BUTTON_TIME,
        {
            Position =
                OriginalPosition,
            Rotation =
                OriginalRotation
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.InOut
    )

FlyTween.Completed:Wait()

--------------------------------------------------
-- REMOVE FAKE BUTTON
--------------------------------------------------

pcall(function()
    FakeHubButton:Destroy()
end)

--------------------------------------------------
-- RESTORE REAL HUB BUTTON
--------------------------------------------------

HubButton.Position =
    OriginalPosition

HubButton.Size =
    OriginalSize

HubButton.AnchorPoint =
    OriginalAnchorPoint

HubButton.Rotation =
    OriginalRotation

HubButton.ZIndex =
    OriginalZIndex

HubButton.Visible =
    OriginalVisible

--------------------------------------------------
-- CLEAN EXPLOSION
--------------------------------------------------

for _,part in ipairs(
    ExplosionParts
) do

    pcall(function()
        if part.Parent then
            part:Destroy()
        end
    end)

end

--------------------------------------------------
-- CLEAN ANIMATION GUI
--------------------------------------------------

pcall(function()
    AnimationGui:Destroy()
end)
