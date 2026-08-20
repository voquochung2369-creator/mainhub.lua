--// CustomHub LoadScriptAnimation.lua
--// 7 Purple Dragon Balls + Red Stars
--// Slow Center Formation + Slow Rotation + Gentle Explosion
--// HubButton appears at center and slowly returns to original position

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ANIMATION_GUI_NAME = "CustomHub_LoadAnimation"

local BALL_COUNT = 7
local BALL_SIZE = 30

local BALL_COLOR = Color3.fromRGB(145, 65, 220)
local BALL_STROKE_COLOR = Color3.fromRGB(210, 130, 255)
local STAR_COLOR = Color3.fromRGB(255, 45, 45)

local CENTER_RADIUS = 65
local MOVE_TIME = 1.6

local ROTATE_TIME = 2.8
local ROTATE_LOOPS = 2

local BLINK_COUNT = 7
local BLINK_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local EXPLOSION_TIME = 1.2
local EXPLOSION_DISTANCE = 45
local FRAGMENT_COUNT = 28

local HUB_MOVE_TIME = 1.5

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
-- FIND HUB UI
--------------------------------------------------

local HubUi =
    CoreGui:FindFirstChild(
        "HubUi"
    )

if not HubUi then
    warn(
        "[CustomHub] Không tìm thấy HubUi"
    )
    return
end

local HubButton =
    HubUi:FindFirstChild(
        "HubButton"
    )

if not HubButton then
    warn(
        "[CustomHub] Không tìm thấy HubButton"
    )
    return
end

--------------------------------------------------
-- SAVE ORIGINAL POSITION
--------------------------------------------------

local OriginalPosition =
    HubButton.Position

local OriginalSize =
    HubButton.Size

local OriginalVisible =
    HubButton.Visible

--------------------------------------------------
-- SCREEN
--------------------------------------------------

local AnimationGui =
    Instance.new(
        "ScreenGui"
    )

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
-- GET CENTER
--------------------------------------------------

local Camera =
    workspace.CurrentCamera

if not Camera then
    AnimationGui:Destroy()
    return
end

local function GetCenter()

    local viewport =
        Camera.ViewportSize

    return Vector2.new(
        viewport.X / 2,
        viewport.Y / 2
    )
end

--------------------------------------------------
-- CREATE BALL
--------------------------------------------------

local function CreateBall()

    local ball =
        Instance.new(
            "Frame"
        )

    ball.Size =
        UDim2.new(
            0,
            BALL_SIZE,
            0,
            BALL_SIZE
        )

    ball.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    ball.BackgroundColor3 =
        BALL_COLOR

    ball.BackgroundTransparency =
        0.05

    ball.BorderSizePixel =
        0

    ball.ZIndex =
        10

    ball.Parent =
        AnimationGui

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
        ball

    local stroke =
        Instance.new(
            "UIStroke"
        )

    stroke.Name =
        "GlowStroke"

    stroke.Color =
        BALL_STROKE_COLOR

    stroke.Thickness =
        2

    stroke.Transparency =
        0.15

    stroke.Parent =
        ball

    --------------------------------------------------
    -- RED STAR
    --------------------------------------------------

    local star =
        Instance.new(
            "TextLabel"
        )

    star.Name =
        "RedStar"

    star.Parent =
        ball

    star.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )

    star.Position =
        UDim2.new(
            0,
            0,
            0,
            0
        )

    star.BackgroundTransparency =
        1

    star.Text =
        "★"

    star.TextColor3 =
        STAR_COLOR

    star.TextStrokeColor3 =
        Color3.fromRGB(
            80,
            0,
            0
        )

    star.TextStrokeTransparency =
        0.15

    star.TextScaled =
        true

    star.Font =
        Enum.Font.GothamBold

    star.ZIndex =
        11

    return ball, stroke
end

--------------------------------------------------
-- RANDOM POSITION
--------------------------------------------------

local function RandomPosition()

    local viewport =
        Camera.ViewportSize

    local margin =
        80

    local x =
        math.random(
            margin,
            math.max(
                margin + 1,
                viewport.X - margin
            )
        )

    local y =
        math.random(
            margin,
            math.max(
                margin + 1,
                viewport.Y - margin
            )
        )

    return UDim2.fromOffset(
        x,
        y
    )
end

--------------------------------------------------
-- CREATE 7 BALLS
--------------------------------------------------

local Balls = {}
local Strokes = {}

for i = 1, BALL_COUNT do

    local ball, stroke =
        CreateBall()

    ball.Position =
        RandomPosition()

    table.insert(
        Balls,
        ball
    )

    table.insert(
        Strokes,
        stroke
    )
end

--------------------------------------------------
-- HIDE HUB BUTTON
--------------------------------------------------

HubButton.Visible =
    false

--------------------------------------------------
-- MOVE TO CENTER
--------------------------------------------------

local center =
    GetCenter()

local moveTweenInfo =
    TweenInfo.new(
        MOVE_TIME,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

for i, ball in ipairs(Balls) do

    local angle =
        ((i - 1) / BALL_COUNT)
        * math.pi
        * 2

    local targetX =
        center.X
        + math.cos(angle)
        * CENTER_RADIUS

    local targetY =
        center.Y
        + math.sin(angle)
        * CENTER_RADIUS

    local tween =
        TweenService:Create(
            ball,
            moveTweenInfo,
            {
                Position =
                    UDim2.fromOffset(
                        targetX,
                        targetY
                    )
            }
        )

    tween:Play()
end

task.wait(
    MOVE_TIME
)

--------------------------------------------------
-- DRAGON BALL CIRCLE
--------------------------------------------------

local currentRotation =
    0

local rotateConnection

local rotateStart =
    os.clock()

local rotateDuration =
    ROTATE_TIME
    * ROTATE_LOOPS

rotateConnection =
    RunService.RenderStepped:Connect(
        function()

            if not AnimationGui.Parent then
                return
            end

            local elapsed =
                os.clock()
                - rotateStart

            local progress =
                math.clamp(
                    elapsed
                    / rotateDuration,
                    0,
                    1
                )

            currentRotation =
                progress
                * math.pi
                * 2
                * ROTATE_LOOPS

            local currentCenter =
                GetCenter()

            for i, ball in ipairs(Balls) do

                if ball.Parent then

                    local angle =
                        ((i - 1)
                        / BALL_COUNT)
                        * math.pi
                        * 2
                        + currentRotation

                    local x =
                        currentCenter.X
                        + math.cos(angle)
                        * CENTER_RADIUS

                    local y =
                        currentCenter.Y
                        + math.sin(angle)
                        * CENTER_RADIUS

                    ball.Position =
                        UDim2.fromOffset(
                            x,
                            y
                        )

                    ball.Rotation =
                        math.deg(
                            currentRotation
                        )
                end
            end
        end
    )

task.wait(
    rotateDuration
)

if rotateConnection then
    rotateConnection:Disconnect()
end

--------------------------------------------------
-- RESET PERFECT CIRCLE
--------------------------------------------------

center =
    GetCenter()

for i, ball in ipairs(Balls) do

    local angle =
        ((i - 1) / BALL_COUNT)
        * math.pi
        * 2

    ball.Position =
        UDim2.fromOffset(
            center.X
            + math.cos(angle)
            * CENTER_RADIUS,

            center.Y
            + math.sin(angle)
            * CENTER_RADIUS
        )

    ball.Rotation =
        0
end

--------------------------------------------------
-- BORDER BLINK
--------------------------------------------------

for blink = 1, BLINK_COUNT do

    for _, stroke in ipairs(
        Strokes
    ) do

        if stroke.Parent then

            local tween =
                TweenService:Create(
                    stroke,
                    TweenInfo.new(
                        BLINK_TIME,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Transparency = 0
                    }
                )

            tween:Play()
        end
    end

    task.wait(
        BLINK_TIME
    )

    for _, stroke in ipairs(
        Strokes
    ) do

        if stroke.Parent then

            local tween =
                TweenService:Create(
                    stroke,
                    TweenInfo.new(
                        BLINK_TIME,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.In
                    ),
                    {
                        Transparency = 0.85
                    }
                )

            tween:Play()
        end
    end

    task.wait(
        BLINK_OFF_TIME
    )
end

--------------------------------------------------
-- GENTLE EXPLOSION
--------------------------------------------------

local explosionCenter =
    GetCenter()

local fragments = {}

for i = 1, FRAGMENT_COUNT do

    local fragment =
        Instance.new(
            "Frame"
        )

    local size =
        math.random(
            2,
            5
        )

    fragment.Size =
        UDim2.fromOffset(
            size,
            size
        )

    fragment.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    fragment.Position =
        UDim2.fromOffset(
            explosionCenter.X,
            explosionCenter.Y
        )

    fragment.BackgroundColor3 =
        if i % 2 == 0
        then BALL_COLOR
        else BALL_STROKE_COLOR

    fragment.BackgroundTransparency =
        0.05

    fragment.BorderSizePixel =
        0

    fragment.ZIndex =
        20

    fragment.Parent =
        AnimationGui

    local fragmentCorner =
        Instance.new(
            "UICorner"
        )

    fragmentCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    fragmentCorner.Parent =
        fragment

    local angle =
        math.random()
        * math.pi
        * 2

    local distance =
        math.random(
            20,
            EXPLOSION_DISTANCE
        )

    local targetX =
        explosionCenter.X
        + math.cos(angle)
        * distance

    local targetY =
        explosionCenter.Y
        + math.sin(angle)
        * distance

    local targetSize =
        math.max(
            1,
            size * 0.45
        )

    local tween =
        TweenService:Create(
            fragment,
            TweenInfo.new(
                EXPLOSION_TIME,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Position =
                    UDim2.fromOffset(
                        targetX,
                        targetY
                    ),

                Size =
                    UDim2.fromOffset(
                        targetSize,
                        targetSize
                    ),

                BackgroundTransparency =
                    1
            }
        )

    table.insert(
        fragments,
        {
            Object = fragment,
            Tween = tween
        }
    )
end

--------------------------------------------------
-- HIDE BALLS
--------------------------------------------------

for _, ball in ipairs(Balls) do

    local tween =
        TweenService:Create(
            ball,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
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
        )

    tween:Play()
end

--------------------------------------------------
-- START FRAGMENTS
--------------------------------------------------

for _, data in ipairs(
    fragments
) do

    data.Tween:Play()
end

--------------------------------------------------
-- HUB BUTTON AT CENTER
--------------------------------------------------

HubButton.AnchorPoint =
    Vector2.new(
        0.5,
        0.5
    )

HubButton.Position =
    UDim2.fromOffset(
        explosionCenter.X,
        explosionCenter.Y
    )

HubButton.Size =
    OriginalSize

HubButton.Visible =
    true

--------------------------------------------------
-- HUB BUTTON APPEAR
--------------------------------------------------

HubButton.BackgroundTransparency =
    1

local hubStroke =
    HubButton:FindFirstChild(
        "HubCircleStroke"
    )

if hubStroke then
    hubStroke.Transparency =
        1
end

local hubAppear =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            BackgroundTransparency =
                0.18
        }
    )

hubAppear:Play()

if hubStroke then

    local strokeAppear =
        TweenService:Create(
            hubStroke,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            ),
            {
                Transparency =
                    0.45
            }
        )

    strokeAppear:Play()
end

task.wait(
    0.35
)

--------------------------------------------------
-- MOVE HUB BUTTON TO ORIGINAL POSITION
--------------------------------------------------

local hubMove =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            HUB_MOVE_TIME,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                OriginalPosition
        }
    )

hubMove:Play()

task.wait(
    HUB_MOVE_TIME
)

--------------------------------------------------
-- RESTORE HUB BUTTON
--------------------------------------------------

HubButton.AnchorPoint =
    Vector2.new(
        0,
        0
    )

HubButton.Position =
    OriginalPosition

HubButton.Size =
    OriginalSize

HubButton.Visible =
    OriginalVisible

HubButton.BackgroundTransparency =
    0.18

if hubStroke then
    hubStroke.Transparency =
        0.45
end

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

for _, ball in ipairs(Balls) do

    pcall(function()
        ball:Destroy()
    end)
end

for _, data in ipairs(
    fragments
) do

    pcall(function()
        data.Object:Destroy()
    end)
end

pcall(function()
    AnimationGui:Destroy()
end)
