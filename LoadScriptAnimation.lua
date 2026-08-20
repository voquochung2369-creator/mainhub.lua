local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local GUI_NAME = "CustomHub_LoadScriptAnimation"

local BALL_COUNT = 7

local BALL_SIZE = 15

local BALL_COLOR = Color3.fromRGB(
    255,
    205,
    45
)

local BALL_INNER_COLOR = Color3.fromRGB(
    255,
    220,
    80
)

local STROKE_COLOR = Color3.fromRGB(
    255,
    235,
    100
)

local FORMATION_RADIUS = 23

local RANDOM_DISTANCE_MIN = 120
local RANDOM_DISTANCE_MAX = 300

local MOVE_TIME_MIN = 0.65
local MOVE_TIME_MAX = 1.05

local BLINK_COUNT = 7
local BLINK_TIME = 0.2
local AFTER_BLINK_DELAY = 0.3

local EXPLOSION_PARTS = 55
local EXPLOSION_DISTANCE_MIN = 25
local EXPLOSION_DISTANCE_MAX = 90

local EXPLOSION_TIME_MIN = 0.8
local EXPLOSION_TIME_MAX = 1.35

--------------------------------------------------
-- REMOVE OLD ANIMATION
--------------------------------------------------

local oldGui = CoreGui:FindFirstChild(GUI_NAME)

if oldGui then
    pcall(function()
        oldGui:Destroy()
    end)

    task.wait()
end

--------------------------------------------------
-- FIND HUB UI
--------------------------------------------------

local HubUi = CoreGui:FindFirstChild("HubUi")

if not HubUi then
    warn("[CustomHub] Không tìm thấy HubUi")
    return
end

local HubButton = HubUi:FindFirstChild("HubButton")

if not HubButton then
    warn("[CustomHub] Không tìm thấy HubButton")
    return
end

--------------------------------------------------
-- GET HUB BUTTON POSITION
--------------------------------------------------

local HubPosition = HubButton.AbsolutePosition

local HubSize = HubButton.AbsoluteSize

local HubCenter = HubPosition + (
    HubSize / 2
)

--------------------------------------------------
-- CREATE ANIMATION GUI
--------------------------------------------------

local AnimationGui =
    Instance.new("ScreenGui")

AnimationGui.Name =
    GUI_NAME

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
-- HIDE HUB BUTTON
--------------------------------------------------

local OldHubTransparency = {}

OldHubTransparency.BackgroundTransparency =
    HubButton.BackgroundTransparency

OldHubTransparency.TextTransparency =
    HubButton.TextTransparency

OldHubTransparency.TextStrokeTransparency =
    HubButton.TextStrokeTransparency

HubButton.BackgroundTransparency = 1
HubButton.TextTransparency = 1
HubButton.TextStrokeTransparency = 1

for _, child in ipairs(
    HubButton:GetChildren()
) do

    if child:IsA("UIStroke") then
        child.Transparency = 1
    elseif child:IsA("GuiObject") then
        child.Visible = false
    end
end

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function RandomScreenPosition()

    local Camera =
        workspace.CurrentCamera

    local ViewportSize =
        Camera
        and Camera.ViewportSize
        or Vector2.new(
            1920,
            1080
        )

    local margin = 80

    local x =
        math.random(
            margin,
            math.max(
                margin,
                math.floor(
                    ViewportSize.X - margin
                )
            )
        )

    local y =
        math.random(
            margin,
            math.max(
                margin,
                math.floor(
                    ViewportSize.Y - margin
                )
            )
        )

    return Vector2.new(
        x,
        y
    )
end

local function CreateBall(
    position
)

    local ball =
        Instance.new("Frame")

    ball.Name =
        "DragonBall"

    ball.Size =
        UDim2.new(
            0,
            BALL_SIZE,
            0,
            BALL_SIZE
        )

    ball.Position =
        UDim2.fromOffset(
            position.X - BALL_SIZE / 2,
            position.Y - BALL_SIZE / 2
        )

    ball.AnchorPoint =
        Vector2.new(
            0,
            0
        )

    ball.BackgroundColor3 =
        BALL_COLOR

    ball.BackgroundTransparency =
        0.02

    ball.BorderSizePixel =
        0

    ball.ZIndex =
        20

    ball.Parent =
        AnimationGui

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    corner.Parent =
        ball

    local stroke =
        Instance.new("UIStroke")

    stroke.Name =
        "BallStroke"

    stroke.Color =
        STROKE_COLOR

    stroke.Thickness =
        1.5

    stroke.Transparency =
        0.35

    stroke.Parent =
        ball

    local inner =
        Instance.new("Frame")

    inner.Name =
        "Inner"

    inner.Size =
        UDim2.new(
            0,
            5,
            0,
            5
        )

    inner.Position =
        UDim2.new(
            0.5,
            -2.5,
            0.5,
            -2.5
        )

    inner.BackgroundColor3 =
        BALL_INNER_COLOR

    inner.BackgroundTransparency =
        0.2

    inner.BorderSizePixel =
        0

    inner.ZIndex =
        21

    inner.Parent =
        ball

    local innerCorner =
        Instance.new("UICorner")

    innerCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    innerCorner.Parent =
        inner

    return ball
end

--------------------------------------------------
-- CREATE 7 BALLS
--------------------------------------------------

local Balls = {}

for i = 1, BALL_COUNT do

    local startPosition =
        RandomScreenPosition()

    local ball =
        CreateBall(
            startPosition
        )

    table.insert(
        Balls,
        ball
    )
end

--------------------------------------------------
-- DRAGON BALL FORMATION
--------------------------------------------------

local FormationPositions = {}

for i = 1, BALL_COUNT do

    local angle =
        math.rad(
            -90
            + (
                (i - 1)
                * (360 / BALL_COUNT)
            )
        )

    local x =
        HubCenter.X
        + math.cos(angle)
        * FORMATION_RADIUS

    local y =
        HubCenter.Y
        + math.sin(angle)
        * FORMATION_RADIUS

    FormationPositions[i] =
        Vector2.new(
            x,
            y
        )
end

--------------------------------------------------
-- MOVE BALLS
--------------------------------------------------

local MoveTweens = {}

for i, ball in ipairs(Balls) do

    local target =
        FormationPositions[i]

    local targetPosition =
        UDim2.fromOffset(
            target.X - BALL_SIZE / 2,
            target.Y - BALL_SIZE / 2
        )

    local moveTime =
        MOVE_TIME_MIN
        + math.random()
        * (
            MOVE_TIME_MAX
            - MOVE_TIME_MIN
        )

    local tween =
        TweenService:Create(
            ball,
            TweenInfo.new(
                moveTime,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            {
                Position =
                    targetPosition
            }
        )

    table.insert(
        MoveTweens,
        tween
    )

    tween:Play()
end

--------------------------------------------------
-- WAIT FOR FORMATION
--------------------------------------------------

local longestMove =
    MOVE_TIME_MAX

task.wait(
    longestMove + 0.05
)

--------------------------------------------------
-- BLINK BORDER
--------------------------------------------------

local function SetBallStroke(
    transparency,
    thickness
)

    for _, ball in ipairs(Balls) do

        if ball
            and ball.Parent then

            local stroke =
                ball:FindFirstChild(
                    "BallStroke"
                )

            if stroke then

                stroke.Transparency =
                    transparency

                stroke.Thickness =
                    thickness
            end
        end
    end
end

--------------------------------------------------
-- BLINK 7 TIMES
--------------------------------------------------

for i = 1, BLINK_COUNT do

    SetBallStroke(
        0,
        3
    )

    task.wait(
        BLINK_TIME
    )

    SetBallStroke(
        1,
        1.5
    )

    task.wait(
        BLINK_TIME
    )
end

--------------------------------------------------
-- OFF 0.3 SECOND
--------------------------------------------------

SetBallStroke(
    1,
    1
)

task.wait(
    AFTER_BLINK_DELAY
)

--------------------------------------------------
-- SHOW HUB BUTTON
--------------------------------------------------

HubButton.BackgroundTransparency =
    OldHubTransparency.BackgroundTransparency

HubButton.TextTransparency =
    OldHubTransparency.TextTransparency

HubButton.TextStrokeTransparency =
    OldHubTransparency.TextStrokeTransparency

for _, child in ipairs(
    HubButton:GetChildren()
) do

    if child:IsA("UIStroke") then

        if child.Name ==
            "HubCircleStroke" then

            child.Transparency =
                0.45

        end

    elseif child:IsA("GuiObject") then

        child.Visible =
            true

    end
end

--------------------------------------------------
-- EXPLOSION
--------------------------------------------------

local ExplosionContainer =
    Instance.new("Frame")

ExplosionContainer.Name =
    "ExplosionContainer"

ExplosionContainer.Size =
    UDim2.new(
        1,
        0,
        1,
        0
    )

ExplosionContainer.Position =
    UDim2.new(
        0,
        0,
        0,
        0
    )

ExplosionContainer.BackgroundTransparency =
    1

ExplosionContainer.BorderSizePixel =
    0

ExplosionContainer.ZIndex =
    30

ExplosionContainer.Parent =
    AnimationGui

--------------------------------------------------
-- DESTROY ORIGINAL BALLS
--------------------------------------------------

for _, ball in ipairs(Balls) do

    if ball
        and ball.Parent then

        ball:Destroy()

    end
end

--------------------------------------------------
-- CREATE SLOW EXPLOSION
--------------------------------------------------

local ExplosionParts = {}

for i = 1, EXPLOSION_PARTS do

    local particle =
        Instance.new("Frame")

    particle.Name =
        "ExplosionParticle"

    local size =
        math.random(
            2,
            5
        )

    particle.Size =
        UDim2.new(
            0,
            size,
            0,
            size
        )

    particle.Position =
        UDim2.fromOffset(
            HubCenter.X - size / 2,
            HubCenter.Y - size / 2
        )

    particle.BackgroundColor3 =
        BALL_COLOR

    particle.BackgroundTransparency =
        math.random(
            0,
            15
        ) / 100

    particle.BorderSizePixel =
        0

    particle.ZIndex =
        31

    particle.Parent =
        ExplosionContainer

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    corner.Parent =
        particle

    local angle =
        math.random()
        * math.pi
        * 2

    local distance =
        EXPLOSION_DISTANCE_MIN
        + math.random()
        * (
            EXPLOSION_DISTANCE_MAX
            - EXPLOSION_DISTANCE_MIN
        )

    local targetX =
        HubCenter.X
        + math.cos(angle)
        * distance

    local targetY =
        HubCenter.Y
        + math.sin(angle)
        * distance

    local targetSize =
        math.random(
            1,
            3
        )

    local duration =
        EXPLOSION_TIME_MIN
        + math.random()
        * (
            EXPLOSION_TIME_MAX
            - EXPLOSION_TIME_MIN
        )

    local tween =
        TweenService:Create(
            particle,
            TweenInfo.new(
                duration,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Position =
                    UDim2.fromOffset(
                        targetX
                        - targetSize / 2,
                        targetY
                        - targetSize / 2
                    ),

                Size =
                    UDim2.new(
                        0,
                        targetSize,
                        0,
                        targetSize
                    ),

                BackgroundTransparency =
                    1
            }
        )

    table.insert(
        ExplosionParts,
        tween
    )

    tween:Play()
end

--------------------------------------------------
-- SOFT HUB BUTTON APPEAR
--------------------------------------------------

HubButton.BackgroundTransparency =
    1

HubButton.TextTransparency =
    1

for _, child in ipairs(
    HubButton:GetChildren()
) do

    if child:IsA("GuiObject") then
        child.Visible = true
    end

    if child:IsA("UIStroke")
        and child.Name ==
            "HubCircleStroke" then

        child.Transparency =
            1
    end
end

local HubFade =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            BackgroundTransparency =
                OldHubTransparency.BackgroundTransparency,

            TextTransparency =
                OldHubTransparency.TextTransparency
        }
    )

HubFade:Play()

local HubStroke =
    HubButton:FindFirstChild(
        "HubCircleStroke"
    )

if HubStroke then

    TweenService:Create(
        HubStroke,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Transparency =
                OldHubTransparency.TextStrokeTransparency
                or 0.45
        }
    ):Play()

end

--------------------------------------------------
-- WAIT EXPLOSION
--------------------------------------------------

task.wait(
    EXPLOSION_TIME_MAX
    + 0.15
)

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

pcall(function()
    AnimationGui:Destroy()
end)
