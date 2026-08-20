--// LoadScriptAnimation.lua

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

local ORB_COLOR =
    Color3.fromRGB(
        145,
        65,
        220
    )

local ORB_BORDER_COLOR =
    Color3.fromRGB(
        255,
        215,
        70
    )

local CENTER_RADIUS = 58

local GATHER_TIME = 1.2
local ORBIT_TIME = 2.2
local ORBIT_SPEED = 0.9

local BLINK_COUNT = 7
local BLINK_ON_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local MERGE_TIME = 0.45

local EXPLOSION_COUNT = 16
local EXPLOSION_DISTANCE_MIN = 45
local EXPLOSION_DISTANCE_MAX = 85
local EXPLOSION_TIME = 1.15

local FAKE_BUTTON_FLY_TIME = 2

--------------------------------------------------
-- FIND HUB
--------------------------------------------------

local function GetHub()

    local startTime =
        tick()

    while tick() - startTime
        < WAIT_TIMEOUT do

        local hubUi =
            CoreGui:FindFirstChild(
                HUB_UI_NAME
            )

        if hubUi then

            local hubButton =
                hubUi:FindFirstChild(
                    HUB_BUTTON_NAME
                )

            if hubButton then

                return hubUi,hubButton

            end
        end

        task.wait(0.1)
    end

    warn(
        "[CustomHub] LoadScriptAnimation: HubUi/HubButton chưa tồn tại."
    )

    return nil,nil
end

local HubUi,HubButton =
    GetHub()

if not HubUi
    or not HubButton then

    return
end

--------------------------------------------------
-- REMOVE OLD ANIMATION GUI
--------------------------------------------------

local OldAnimation =
    CoreGui:FindFirstChild(
        "CustomHub_LoadAnimation"
    )

if OldAnimation then

    pcall(function()
        OldAnimation:Destroy()
    end)

end

--------------------------------------------------
-- SAVE HUB BUTTON STATE
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

local OriginalBackgroundColor =
    HubButton.BackgroundColor3

local OriginalBackgroundTransparency =
    HubButton.BackgroundTransparency

local OriginalText =
    HubButton.Text

local OriginalTextColor =
    HubButton.TextColor3

local OriginalTextSize =
    HubButton.TextSize

local OriginalFont =
    HubButton.Font

--------------------------------------------------
-- ANIMATION GUI
--------------------------------------------------

local AnimationGui =
    Instance.new(
        "ScreenGui"
    )

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

HubButton.Visible =
    false

--------------------------------------------------
-- CAMERA
--------------------------------------------------

local Camera =
    workspace.CurrentCamera

if not Camera then

    HubButton.Visible =
        OriginalVisible

    AnimationGui:Destroy()

    return
end

local Viewport =
    Camera.ViewportSize

local CenterX =
    Viewport.X / 2

local CenterY =
    Viewport.Y / 2

--------------------------------------------------
-- CREATE ORB
--------------------------------------------------

local function CreateOrb()

    local orb =
        Instance.new(
            "Frame"
        )

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

    local corner =
        Instance.new(
            "UICorner"
        )

    corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    corner.Parent =
        orb

    --------------------------------------------------
    -- YELLOW EDGE
    --------------------------------------------------

    local stroke =
        Instance.new(
            "UIStroke"
        )

    stroke.Name =
        "YellowEdge"

    stroke.Color =
        ORB_BORDER_COLOR

    stroke.Thickness =
        2

    stroke.Transparency =
        0.2

    stroke.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    stroke.Parent =
        orb

    --------------------------------------------------
    -- SMALL GLOW AROUND EDGE
    --------------------------------------------------

    local glow =
        Instance.new(
            "Frame"
        )

    glow.Name =
        "EdgeGlow"

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
            0,
            0.5,
            0
        )

    glow.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    glow.BackgroundColor3 =
        ORB_BORDER_COLOR

    glow.BackgroundTransparency =
        0.9

    glow.BorderSizePixel =
        0

    glow.ZIndex =
        19

    local glowCorner =
        Instance.new(
            "UICorner"
        )

    glowCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    glowCorner.Parent =
        glow

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
            70,
            math.max(
                71,
                math.floor(
                    Viewport.X - 70
                )
            )
        )

    local randomY =
        math.random(
            70,
            math.max(
                71,
                math.floor(
                    Viewport.Y - 70
                )
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
-- TARGET CIRCLE
--------------------------------------------------

local CirclePositions = {}

for i = 1,ORB_COUNT do

    local angle =
        (
            (i - 1)
            / ORB_COUNT
        )
        * math.pi
        * 2

    local x =
        CenterX
        + math.cos(angle)
        * CENTER_RADIUS

    local y =
        CenterY
        + math.sin(angle)
        * CENTER_RADIUS

    CirclePositions[i] =
        Vector2.new(
            x,
            y
        )
end

--------------------------------------------------
-- MOVE TO CIRCLE
--------------------------------------------------

for _,data in ipairs(
    Orbs
) do

    local target =
        CirclePositions[
            data.Index
        ]

    TweenService:Create(
        data.Object,
        TweenInfo.new(
            GATHER_TIME,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                UDim2.new(
                    0,
                    target.X,
                    0,
                    target.Y
                )
        }
    ):Play()
end

task.wait(
    GATHER_TIME
)

--------------------------------------------------
-- SLOW ORBIT
--------------------------------------------------

local OrbitStart =
    tick()

while tick() - OrbitStart
    < ORBIT_TIME do

    local elapsed =
        tick() - OrbitStart

    local rotation =
        elapsed
        * ORBIT_SPEED

    for _,data in ipairs(
        Orbs
    ) do

        if data.Object.Parent then

            local baseAngle =
                (
                    (data.Index - 1)
                    / ORB_COUNT
                )
                * math.pi
                * 2

            local angle =
                baseAngle
                + rotation

            local x =
                CenterX
                + math.cos(angle)
                * CENTER_RADIUS

            local y =
                CenterY
                + math.sin(angle)
                * CENTER_RADIUS

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
-- BORDER BLINK 7 TIMES
--------------------------------------------------

for blink = 1,BLINK_COUNT do

    --------------------------------------------------
    -- ON
    --------------------------------------------------

    for _,data in ipairs(
        Orbs
    ) do

        if data.Stroke then

            data.Stroke.Transparency =
                0

            data.Stroke.Thickness =
                3

        end

        if data.Glow then

            data.Glow.BackgroundTransparency =
                0.75

        end
    end

    task.wait(
        BLINK_ON_TIME
    )

    --------------------------------------------------
    -- OFF
    --------------------------------------------------

    for _,data in ipairs(
        Orbs
    ) do

        if data.Stroke then

            data.Stroke.Transparency =
                0.65

            data.Stroke.Thickness =
                2

        end

        if data.Glow then

            data.Glow.BackgroundTransparency =
                0.95

        end
    end

    task.wait(
        BLINK_OFF_TIME
    )
end

--------------------------------------------------
-- MERGE INTO ONE LARGE PURPLE BALL
--------------------------------------------------

for _,data in ipairs(
    Orbs
) do

    TweenService:Create(
        data.Object,
        TweenInfo.new(
            MERGE_TIME,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ),
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
        }
    ):Play()

end

task.wait(
    MERGE_TIME
)

--------------------------------------------------
-- DESTROY ORIGINAL 7 ORBS
--------------------------------------------------

for _,data in ipairs(
    Orbs
) do

    pcall(function()

        if data.Object then
            data.Object:Destroy()
        end

    end)
end

--------------------------------------------------
-- EXPLOSION PARTICLES
--------------------------------------------------

local ExplosionParts = {}

for i = 1,EXPLOSION_COUNT do

    local part =
        Instance.new(
            "Frame"
        )

    part.Name =
        "PurpleExplosion"

    local size =
        math.random(
            10,
            17
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

    part.BackgroundTransparency =
        0

    part.BorderSizePixel =
        0

    part.ZIndex =
        30

    local corner =
        Instance.new(
            "UICorner"
        )

    corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    corner.Parent =
        part

    local stroke =
        Instance.new(
            "UIStroke"
        )

    stroke.Color =
        ORB_BORDER_COLOR

    stroke.Thickness =
        2

    stroke.Transparency =
        0.2

    stroke.Parent =
        part

    part.Parent =
        AnimationGui

    local angle =
        math.random()
        * math.pi
        * 2

    local distance =
        math.random(
            EXPLOSION_DISTANCE_MIN,
            EXPLOSION_DISTANCE_MAX
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

    TweenService:Create(
        part,
        TweenInfo.new(
            EXPLOSION_TIME
            + math.random()
            * 0.35,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
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
        }
    ):Play()

    TweenService:Create(
        stroke,
        TweenInfo.new(
            EXPLOSION_TIME
        ),
        {
            Transparency =
                1
        }
    ):Play()
end

--------------------------------------------------
-- WAIT A LITTLE AFTER EXPLOSION
--------------------------------------------------

task.wait(
    0.25
)

--------------------------------------------------
-- CREATE FAKE HUB BUTTON
--------------------------------------------------

local FakeHubButton =
    Instance.new(
        "TextButton"
    )

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
    OriginalBackgroundColor

FakeHubButton.BackgroundTransparency =
    OriginalBackgroundTransparency

FakeHubButton.BorderSizePixel =
    0

FakeHubButton.Text =
    OriginalText

FakeHubButton.TextColor3 =
    OriginalTextColor

FakeHubButton.TextStrokeTransparency =
    HubButton.TextStrokeTransparency

FakeHubButton.TextSize =
    OriginalTextSize

FakeHubButton.Font =
    OriginalFont

FakeHubButton.AutoButtonColor =
    false

FakeHubButton.ZIndex =
    100

local FakeCorner =
    Instance.new(
        "UICorner"
    )

FakeCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

FakeCorner.Parent =
    FakeHubButton

local FakeStroke =
    Instance.new(
        "UIStroke"
    )

FakeStroke.Color =
    Color3.fromRGB(
        255,
        255,
        255
    )

FakeStroke.ApplyStrokeMode =
    Enum.ApplyStrokeMode.Border

FakeStroke.Thickness =
    2.5

FakeStroke.Transparency =
    0.05

FakeStroke.Parent =
    FakeHubButton

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

local AppearTween =
    TweenService:Create(
        FakeHubButton,
        TweenInfo.new(
            0.3,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size =
                OriginalSize
        }
    )

AppearTween:Play()
AppearTween.Completed:Wait()

--------------------------------------------------
-- FAKE BUTTON FLY TO ORIGINAL POSITION
--------------------------------------------------

local FlyTween =
    TweenService:Create(
        FakeHubButton,
        TweenInfo.new(
            FAKE_BUTTON_FLY_TIME,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.InOut
        ),
        {
            Position =
                OriginalPosition
        }
    )

FlyTween:Play()

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

        if part
            and part.Parent then

            part:Destroy()

        end

    end)
end

--------------------------------------------------
-- CLEAN ANIMATION GUI
--------------------------------------------------

pcall(function()

    if AnimationGui
        and AnimationGui.Parent then

        AnimationGui:Destroy()

    end

end)
