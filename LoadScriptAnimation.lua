local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- CONFIG         
--------------------------------------------------

local ANIMATION_GUI_NAME = "CustomHub_LoadAnimation"

local BALL_COUNT = 7

local BALL_SIZE = 22
local BIG_BALL_SIZE = 58

local MOVE_TIME = 0.9
local ROTATE_TIME = 2.2

local FLASH_COUNT = 7
local FLASH_ON_TIME = 0.2
local FLASH_OFF_TIME = 0.3

local MERGE_TIME = 0.75

local EXPLOSION_PARTS = 14
local EXPLOSION_DISTANCE = 75
local EXPLOSION_TIME = 0.8

local HUB_MOVE_TIME = 1.4

local PURPLE = Color3.fromRGB(
    155,
    55,
    255
)

local PURPLE_DARK = Color3.fromRGB(
    90,
    20,
    160
)

local GOLD = Color3.fromRGB(
    255,
    215,
    60
)

local GOLD_BRIGHT = Color3.fromRGB(
    255,
    235,
    100
)

--------------------------------------------------
-- REMOVE OLD ANIMATION
--------------------------------------------------

local oldAnimation =
    CoreGui:FindFirstChild(
        ANIMATION_GUI_NAME
    )

if oldAnimation then
    pcall(function()
        oldAnimation:Destroy()
    end)
end

--------------------------------------------------
-- FIND HUB
--------------------------------------------------

local HubUi =
    CoreGui:FindFirstChild(
        "HubUi"
    )

if not HubUi then
    warn(
        "[CustomHub] LoadScriptAnimation: HubUi not found"
    )
    return
end

local HubButton =
    HubUi:FindFirstChild(
        "HubButton",
        true
    )

if not HubButton then
    warn(
        "[CustomHub] LoadScriptAnimation: HubButton not found"
    )
    return
end

--------------------------------------------------
-- WAIT FOR SIZE
--------------------------------------------------

local timeout =
    0

while HubButton.AbsoluteSize.X <= 0
    or HubButton.AbsoluteSize.Y <= 0 do

    task.wait()

    timeout =
        timeout + 1

    if timeout > 100 then
        break
    end
end

--------------------------------------------------
-- SAVE ORIGINAL HUB STATE
--------------------------------------------------

local OriginalPosition =
    HubButton.Position

local OriginalAnchorPoint =
    HubButton.AnchorPoint

local OriginalSize =
    HubButton.Size

local OriginalRotation =
    HubButton.Rotation

local OriginalVisible =
    HubButton.Visible

local OriginalZIndex =
    HubButton.ZIndex

--------------------------------------------------
-- HIDE REAL HUB BUTTON
--------------------------------------------------

HubButton.Visible =
    false

--------------------------------------------------
-- ANIMATION GUI
--------------------------------------------------

local AnimationGui =
    Instance.new("ScreenGui")

AnimationGui.Name =
    ANIMATION_GUI_NAME

AnimationGui.ResetOnSpawn =
    false

AnimationGui.IgnoreGuiInset =
    true

AnimationGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

AnimationGui.DisplayOrder =
    999999

AnimationGui.Parent =
    CoreGui

--------------------------------------------------
-- GET VIEWPORT
--------------------------------------------------

local function GetViewport()

    local Camera =
        workspace.CurrentCamera

    if not Camera then
        return Vector2.new(
            1920,
            1080
        )
    end

    return Camera.ViewportSize
end

--------------------------------------------------
-- CENTER
--------------------------------------------------

local function GetCenter()

    local viewport =
        GetViewport()

    return Vector2.new(
        viewport.X / 2,
        viewport.Y / 2
    )
end

--------------------------------------------------
-- CREATE BALL
--------------------------------------------------

local function CreateBall()

    local holder =
        Instance.new("Frame")

    holder.Size =
        UDim2.fromOffset(
            BALL_SIZE,
            BALL_SIZE
        )

    holder.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    holder.BackgroundTransparency =
        1

    holder.BorderSizePixel =
        0

    holder.ZIndex =
        10

    holder.Parent =
        AnimationGui

    --------------------------------------------------
    -- PURPLE CORE
    --------------------------------------------------

    local core =
        Instance.new("Frame")

    core.Name =
        "PurpleCore"

    core.Size =
        UDim2.fromScale(
            0.72,
            0.72
        )

    core.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    core.Position =
        UDim2.fromScale(
            0.5,
            0.5
        )

    core.BackgroundColor3 =
        PURPLE

    core.BorderSizePixel =
        0

    core.ZIndex =
        11

    core.Parent =
        holder

    local coreCorner =
        Instance.new("UICorner")

    coreCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    coreCorner.Parent =
        core

    --------------------------------------------------
    -- GOLD GLOW
    --------------------------------------------------

    local glow =
        Instance.new("UIStroke")

    glow.Name =
        "GoldenGlow"

    glow.Color =
        GOLD

    glow.Thickness =
        2.2

    glow.Transparency =
        0.05

    glow.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    glow.Parent =
        core

    --------------------------------------------------
    -- OUTER PURPLE RING
    --------------------------------------------------

    local outer =
        Instance.new("UIStroke")

    outer.Name =
        "PurpleOuter"

    outer.Color =
        PURPLE_DARK

    outer.Thickness =
        1

    outer.Transparency =
        0.15

    outer.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    outer.Parent =
        holder

    --------------------------------------------------
    -- GOLD STAR
    --------------------------------------------------

    local star =
        Instance.new("TextLabel")

    star.Name =
        "GoldenStar"

    star.Size =
        UDim2.fromScale(
            1,
            1
        )

    star.Position =
        UDim2.fromScale(
            0,
            0
        )

    star.BackgroundTransparency =
        1

    star.Text =
        "★"

    star.TextColor3 =
        GOLD_BRIGHT

    star.TextSize =
        14

    star.Font =
        Enum.Font.GothamBold

    star.TextXAlignment =
        Enum.TextXAlignment.Center

    star.TextYAlignment =
        Enum.TextYAlignment.Center

    star.ZIndex =
        12

    star.Parent =
        holder

    --------------------------------------------------
    -- STAR OUTLINE
    --------------------------------------------------

    local starStroke =
        Instance.new("UIStroke")

    starStroke.Color =
        GOLD

    starStroke.Thickness =
        0.8

    starStroke.Transparency =
        0.15

    starStroke.Parent =
        star

    return {
        Holder = holder,
        Core = core,
        Glow = glow,
        Outer = outer,
        Star = star
    }
end

--------------------------------------------------
-- CREATE 7 BALLS
--------------------------------------------------

local Balls = {}

for i = 1, BALL_COUNT do

    local ball =
        CreateBall()

    table.insert(
        Balls,
        ball
    )
end

--------------------------------------------------
-- RANDOM START POSITIONS
--------------------------------------------------

local viewport =
    GetViewport()

local function RandomPosition()

    local margin =
        70

    local x =
        math.random(
            margin,
            math.max(
                margin + 1,
                math.floor(
                    viewport.X - margin
                )
            )
        )

    local y =
        math.random(
            margin,
            math.max(
                margin + 1,
                math.floor(
                    viewport.Y - margin
                )
            )
        )

    return UDim2.fromOffset(
        x,
        y
    )
end

for _, ball in ipairs(Balls) do

    ball.Holder.Position =
        RandomPosition()

    ball.Holder.Rotation =
        math.random(
            -180,
            180
        )
end

--------------------------------------------------
-- GET CENTER POSITION
--------------------------------------------------

local Center =
    GetCenter()

--------------------------------------------------
-- MOVE 7 BALLS TO CENTER
--------------------------------------------------

local moveInfo =
    TweenInfo.new(
        MOVE_TIME,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

local moveTweens = {}

for _, ball in ipairs(Balls) do

    local tween =
        TweenService:Create(
            ball.Holder,
            moveInfo,
            {
                Position =
                    UDim2.fromOffset(
                        Center.X,
                        Center.Y
                    )
            }
        )

    table.insert(
        moveTweens,
        tween
    )

    tween:Play()
end

task.wait(
    MOVE_TIME
)

--------------------------------------------------
-- 7 BALLS ROTATE AROUND CENTER
--------------------------------------------------

local orbitRadius =
    55

local rotateStart =
    os.clock()

local rotateConnection

rotateConnection =
    RunService.RenderStepped:Connect(
        function()

            local elapsed =
                os.clock()
                - rotateStart

            local progress =
                math.clamp(
                    elapsed / ROTATE_TIME,
                    0,
                    1
                )

            local angleOffset =
                elapsed
                * math.rad(
                    85
                )

            for index, ball in ipairs(Balls) do

                local angle =
                    angleOffset
                    + (
                        (index - 1)
                        * (
                            math.pi * 2
                            / BALL_COUNT
                        )
                    )

                local x =
                    Center.X
                    + math.cos(angle)
                    * orbitRadius

                local y =
                    Center.Y
                    + math.sin(angle)
                    * orbitRadius

                ball.Holder.Position =
                    UDim2.fromOffset(
                        x,
                        y
                    )

                ball.Holder.Rotation =
                    math.deg(angle)
                    + 90

                local scale =
                    0.95
                    + (
                        math.sin(
                            elapsed * 3
                        ) * 0.05
                    )

                ball.Holder.Size =
                    UDim2.fromOffset(
                        BALL_SIZE * scale,
                        BALL_SIZE * scale
                    )
            end
        end
    )

task.wait(
    ROTATE_TIME
)

if rotateConnection then
    rotateConnection:Disconnect()
    rotateConnection = nil
end

--------------------------------------------------
-- FLASH GOLD BORDER 7 TIMES
--------------------------------------------------

for flash = 1, FLASH_COUNT do

    for _, ball in ipairs(Balls) do

        TweenService:Create(
            ball.Glow,
            TweenInfo.new(
                FLASH_ON_TIME,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                Thickness = 5,
                Transparency = 0
            }
        ):Play()

        TweenService:Create(
            ball.Star,
            TweenInfo.new(
                FLASH_ON_TIME,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                TextColor3 =
                    Color3.fromRGB(
                        255,
                        245,
                        150
                    )
            }
        ):Play()
    end

    task.wait(
        FLASH_ON_TIME
    )

    for _, ball in ipairs(Balls) do

        TweenService:Create(
            ball.Glow,
            TweenInfo.new(
                FLASH_OFF_TIME,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                Thickness = 2.2,
                Transparency = 0.05
            }
        ):Play()

        TweenService:Create(
            ball.Star,
            TweenInfo.new(
                FLASH_OFF_TIME,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                TextColor3 =
                    GOLD_BRIGHT
            }
        ):Play()
    end

    task.wait(
        FLASH_OFF_TIME
    )
end

--------------------------------------------------
-- MERGE INTO ONE BIG BALL
--------------------------------------------------

local mergeInfo =
    TweenInfo.new(
        MERGE_TIME,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.InOut
    )

for _, ball in ipairs(Balls) do

    TweenService:Create(
        ball.Holder,
        mergeInfo,
        {
            Position =
                UDim2.fromOffset(
                    Center.X,
                    Center.Y
                ),

            Size =
                UDim2.fromOffset(
                    BIG_BALL_SIZE,
                    BIG_BALL_SIZE
                )
        }
    ):Play()
end

task.wait(
    MERGE_TIME
)

--------------------------------------------------
-- REMOVE 6 BALLS
--------------------------------------------------

for index, ball in ipairs(Balls) do

    if index > 1 then

        pcall(function()
            ball.Holder:Destroy()
        end)
    end
end

local BigBall =
    Balls[1]

if not BigBall then
    pcall(function()
        AnimationGui:Destroy()
    end)

    HubButton.Visible = true
    return
end

--------------------------------------------------
-- BIG BALL EFFECT
--------------------------------------------------

BigBall.Holder.Size =
    UDim2.fromOffset(
        BIG_BALL_SIZE,
        BIG_BALL_SIZE
    )

BigBall.Core.BackgroundColor3 =
    PURPLE

BigBall.Glow.Thickness =
    4

BigBall.Glow.Transparency =
    0

BigBall.Star.TextSize =
    30

--------------------------------------------------
-- CREATE EXPLOSION PART
--------------------------------------------------

local function CreateExplosionPart()

    local part =
        Instance.new("Frame")

    local size =
        math.random(
            9,
            17
        )

    part.Size =
        UDim2.fromOffset(
            size,
            size
        )

    part.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    part.Position =
        UDim2.fromOffset(
            Center.X,
            Center.Y
        )

    part.BackgroundColor3 =
        PURPLE

    part.BorderSizePixel =
        0

    part.ZIndex =
        20

    part.Rotation =
        math.random(
            0,
            360
        )

    part.Parent =
        AnimationGui

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            0.35,
            0
        )

    corner.Parent =
        part

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        GOLD

    stroke.Thickness =
        1.5

    stroke.Transparency =
        0.1

    stroke.Parent =
        part

    return part
end

--------------------------------------------------
-- EXPLOSION
--------------------------------------------------

local ExplosionParts = {}

for i = 1, EXPLOSION_PARTS do

    local part =
        CreateExplosionPart()

    local angle =
        (
            math.pi * 2
            / EXPLOSION_PARTS
        )
        * i

    angle =
        angle
        + math.rad(
            math.random(
                -20,
                20
            )
        )

    local distance =
        math.random(
            math.floor(
                EXPLOSION_DISTANCE * 0.55
            ),
            EXPLOSION_DISTANCE
        )

    local targetX =
        Center.X
        + math.cos(angle)
        * distance

    local targetY =
        Center.Y
        + math.sin(angle)
        * distance

    local targetRotation =
        math.random(
            -180,
            180
        )

    table.insert(
        ExplosionParts,
        part
    )

    TweenService:Create(
        part,
        TweenInfo.new(
            EXPLOSION_TIME,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                UDim2.fromOffset(
                    targetX,
                    targetY
                ),

            Rotation =
                targetRotation,

            BackgroundTransparency =
                0.15
        }
    ):Play()

    task.spawn(
        function()

            task.wait(
                EXPLOSION_TIME * 0.55
            )

            TweenService:Create(
                part,
                TweenInfo.new(
                    EXPLOSION_TIME * 0.45,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundTransparency =
                        1
                }
            ):Play()

            local stroke =
                part:FindFirstChildOfClass(
                    "UIStroke"
                )

            if stroke then

                TweenService:Create(
                    stroke,
                    TweenInfo.new(
                        EXPLOSION_TIME * 0.45,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Transparency = 1
                    }
                ):Play()
            end

            task.wait(
                EXPLOSION_TIME * 0.45
                + 0.05
            )

            pcall(function()
                part:Destroy()
            end)
        end
    )
end

--------------------------------------------------
-- BIG BALL DISAPPEARS
--------------------------------------------------

TweenService:Create(
    BigBall.Holder,
    TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ),
    {
        Size =
            UDim2.fromOffset(
                5,
                5
            ),

        BackgroundTransparency =
            1
    }
):Play()

TweenService:Create(
    BigBall.Glow,
    TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ),
    {
        Transparency = 1
    }
):Play()

TweenService:Create(
    BigBall.Star,
    TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ),
    {
        TextTransparency = 1
    }
):Play()

task.wait(
    0.28
)

pcall(function()
    BigBall.Holder:Destroy()
end)

--------------------------------------------------
-- HUB BUTTON APPEARS AT CENTER
--------------------------------------------------

local hubSize =
    HubButton.AbsoluteSize

if hubSize.X <= 0
    or hubSize.Y <= 0 then

    hubSize =
        Vector2.new(
            45,
            45
        )
end

--------------------------------------------------
-- CALCULATE CENTER POSITION
-- WITHOUT CHANGING ANCHORPOINT
--------------------------------------------------

local centerHubX =
    Center.X
    - (
        hubSize.X
        * OriginalAnchorPoint.X
    )

local centerHubY =
    Center.Y
    - (
        hubSize.Y
        * OriginalAnchorPoint.Y
    )

--------------------------------------------------
-- SHOW REAL HUB BUTTON
--------------------------------------------------

HubButton.Visible =
    true

HubButton.Size =
    OriginalSize

HubButton.AnchorPoint =
    OriginalAnchorPoint

HubButton.Rotation =
    OriginalRotation

HubButton.ZIndex =
    OriginalZIndex

HubButton.Position =
    UDim2.fromOffset(
        centerHubX,
        centerHubY
    )

--------------------------------------------------
-- HUB APPEAR SCALE EFFECT
--------------------------------------------------

local HubScale =
    HubButton:FindFirstChild(
        "LoadAnimationScale"
    )

if HubScale then
    pcall(function()
        HubScale:Destroy()
    end)
end

HubScale =
    Instance.new("UIScale")

HubScale.Name =
    "LoadAnimationScale"

HubScale.Scale =
    0.35

HubScale.Parent =
    HubButton

TweenService:Create(
    HubScale,
    TweenInfo.new(
        0.35,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        Scale = 1
    }
):Play()

task.wait(
    0.3
)

--------------------------------------------------
-- SAVE CENTER POSITION
--------------------------------------------------

local CenterHubPosition =
    HubButton.Position

--------------------------------------------------
-- FLY TO ORIGINAL POSITION
--------------------------------------------------

local hubMove =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            HUB_MOVE_TIME,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                OriginalPosition
        }
    )

hubMove:Play()

hubMove.Completed:Wait()

--------------------------------------------------
-- RESTORE EXACT ORIGINAL STATE
--------------------------------------------------

HubButton.Position =
    OriginalPosition

HubButton.AnchorPoint =
    OriginalAnchorPoint

HubButton.Size =
    OriginalSize

HubButton.Rotation =
    OriginalRotation

HubButton.ZIndex =
    OriginalZIndex

HubButton.Visible =
    true

--------------------------------------------------
-- REMOVE TEMP SCALE
--------------------------------------------------

if HubScale then

    TweenService:Create(
        HubScale,
        TweenInfo.new(
            0.12,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ),
        {
            Scale = 1
        }
    ):Play()

    task.wait(
        0.12
    )

    pcall(function()
        HubScale:Destroy()
    end)
end

--------------------------------------------------
-- CLEAN ANIMATION GUI
--------------------------------------------------

pcall(function()
    AnimationGui:Destroy()
end)

--------------------------------------------------
-- FINAL SAFETY
--------------------------------------------------

if HubButton
    and HubButton.Parent then

    HubButton.Visible =
        true

    HubButton.Position =
        OriginalPosition

    HubButton.AnchorPoint =
        OriginalAnchorPoint

    HubButton.Size =
        OriginalSize

    HubButton.Rotation =
        OriginalRotation

    HubButton.ZIndex =
        OriginalZIndex
end
