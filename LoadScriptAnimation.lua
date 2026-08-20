local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ANIMATION_NAME = "CustomHubLoadAnimation"

local CIRCLE_COUNT = 7
local CIRCLE_SIZE = 18

local MOVE_TIME = 0.65

local BLINK_COUNT = 7
local BLINK_ON_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local EXPLOSION_PARTICLES = 45
local PARTICLE_MIN_SIZE = 2
local PARTICLE_MAX_SIZE = 5

local PARTICLE_DISTANCE_MIN = 35
local PARTICLE_DISTANCE_MAX = 110

local PARTICLE_TIME = 0.55

local YELLOW = Color3.fromRGB(
    255,
    210,
    0
)

local BRIGHT_YELLOW = Color3.fromRGB(
    255,
    235,
    80
)

--------------------------------------------------
-- PREVENT DUPLICATE
--------------------------------------------------

if _G.CustomHubLoadAnimationPlayed then
    return
end

_G.CustomHubLoadAnimationPlayed = true

--------------------------------------------------
-- FIND HUB UI
--------------------------------------------------

local HubUi = CoreGui:FindFirstChild("HubUi")

if not HubUi then
    warn("CustomHub Animation: Không tìm thấy HubUi")
    return
end

local HubButton = HubUi:FindFirstChild("HubButton")

if not HubButton then
    warn("CustomHub Animation: Không tìm thấy HubButton")
    return
end

--------------------------------------------------
-- SCREEN SIZE
--------------------------------------------------

local Camera = workspace.CurrentCamera

if not Camera then
    warn("CustomHub Animation: Không tìm thấy CurrentCamera")
    return
end

local Viewport = Camera.ViewportSize

--------------------------------------------------
-- ANIMATION GUI
--------------------------------------------------

local AnimationGui = Instance.new("ScreenGui")

AnimationGui.Name = ANIMATION_NAME
AnimationGui.ResetOnSpawn = false
AnimationGui.IgnoreGuiInset = true
AnimationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
AnimationGui.DisplayOrder = 999999
AnimationGui.Parent = CoreGui

--------------------------------------------------
-- HIDE HUB BUTTON
--------------------------------------------------

HubButton.Visible = false

--------------------------------------------------
-- RANDOM TARGET
--------------------------------------------------

local marginX = 100
local marginY = 100

local targetX = math.random(
    marginX,
    math.max(
        marginX,
        Viewport.X - marginX
    )
)

local targetY = math.random(
    marginY,
    math.max(
        marginY,
        Viewport.Y - marginY
    )
)

local targetPosition = Vector2.new(
    targetX,
    targetY
)

--------------------------------------------------
-- CREATE CIRCLE
--------------------------------------------------

local function CreateCircle()

    local circle = Instance.new("Frame")

    circle.Name = "AnimationCircle"

    circle.Size = UDim2.fromOffset(
        CIRCLE_SIZE,
        CIRCLE_SIZE
    )

    circle.AnchorPoint = Vector2.new(
        0.5,
        0.5
    )

    circle.BackgroundColor3 = YELLOW

    circle.BackgroundTransparency = 0

    circle.BorderSizePixel = 0

    circle.Position = UDim2.fromOffset(
        math.random(
            40,
            math.max(
                40,
                Viewport.X - 40
            )
        ),
        math.random(
            40,
            math.max(
                40,
                Viewport.Y - 40
            )
        )
    )

    circle.ZIndex = 100

    circle.Parent = AnimationGui

    --------------------------------------------------
    -- ROUND
    --------------------------------------------------

    local corner = Instance.new("UICorner")

    corner.CornerRadius = UDim.new(
        1,
        0
    )

    corner.Parent = circle

    --------------------------------------------------
    -- YELLOW BORDER
    --------------------------------------------------

    local stroke = Instance.new("UIStroke")

    stroke.Name = "CircleStroke"

    stroke.Color = YELLOW

    stroke.Thickness = 1

    stroke.Transparency = 0.15

    stroke.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    stroke.Parent = circle

    return circle
end

--------------------------------------------------
-- CREATE 7 CIRCLES
--------------------------------------------------

local Circles = {}

for i = 1, CIRCLE_COUNT do

    local circle = CreateCircle()

    table.insert(
        Circles,
        circle
    )
end

--------------------------------------------------
-- MOVE CIRCLES TO CENTER
--------------------------------------------------

local moveInfo = TweenInfo.new(
    MOVE_TIME,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

for _, circle in ipairs(Circles) do

    local tween = TweenService:Create(
        circle,
        moveInfo,
        {
            Position =
                UDim2.fromOffset(
                    targetPosition.X,
                    targetPosition.Y
                )
        }
    )

    tween:Play()
end

task.wait(MOVE_TIME)

--------------------------------------------------
-- MAKE CIRCLES OVERLAP
--------------------------------------------------

for _, circle in ipairs(Circles) do

    circle.Position =
        UDim2.fromOffset(
            targetPosition.X,
            targetPosition.Y
        )
end

--------------------------------------------------
-- BLINK BORDER
--------------------------------------------------

for i = 1, BLINK_COUNT do

    --------------------------------------------------
    -- BORDER ON
    --------------------------------------------------

    for _, circle in ipairs(Circles) do

        local stroke =
            circle:FindFirstChild("CircleStroke")

        if stroke then

            stroke.Color =
                BRIGHT_YELLOW

            stroke.Thickness =
                3

            stroke.Transparency =
                0
        end
    end

    task.wait(
        BLINK_ON_TIME
    )

    --------------------------------------------------
    -- BORDER OFF
    --------------------------------------------------

    for _, circle in ipairs(Circles) do

        local stroke =
            circle:FindFirstChild("CircleStroke")

        if stroke then

            stroke.Color =
                YELLOW

            stroke.Thickness =
                1

            stroke.Transparency =
                0.15
        end
    end

    task.wait(
        BLINK_OFF_TIME
    )
end

--------------------------------------------------
-- EXPLOSION PARTICLES
--------------------------------------------------

local function CreateParticle()

    local particle = Instance.new("Frame")

    particle.Name =
        "ExplosionParticle"

    local size =
        math.random(
            PARTICLE_MIN_SIZE,
            PARTICLE_MAX_SIZE
        )

    particle.Size =
        UDim2.fromOffset(
            size,
            size
        )

    particle.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    particle.Position =
        UDim2.fromOffset(
            targetPosition.X,
            targetPosition.Y
        )

    particle.BackgroundColor3 =
        YELLOW

    particle.BackgroundTransparency =
        0

    particle.BorderSizePixel =
        0

    particle.ZIndex =
        150

    particle.Parent =
        AnimationGui

    --------------------------------------------------
    -- ROUND PARTICLE
    --------------------------------------------------

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    corner.Parent =
        particle

    --------------------------------------------------
    -- RANDOM DIRECTION
    --------------------------------------------------

    local angle =
        math.random(
            0,
            359
        )

    local radians =
        math.rad(angle)

    local distance =
        math.random(
            PARTICLE_DISTANCE_MIN,
            PARTICLE_DISTANCE_MAX
        )

    local endX =
        targetPosition.X
        + math.cos(radians)
        * distance

    local endY =
        targetPosition.Y
        + math.sin(radians)
        * distance

    --------------------------------------------------
    -- RANDOM PARTICLE TIME
    --------------------------------------------------

    local duration =
        PARTICLE_TIME
        * (
            0.7
            + math.random() * 0.6
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
                        endX,
                        endY
                    ),

                BackgroundTransparency =
                    1,

                Size =
                    UDim2.fromOffset(
                        0,
                        0
                    )
            }
        )

    tween:Play()

    tween.Completed:Connect(
        function()

            if particle then

                particle:Destroy()

            end
        end
    )
end

--------------------------------------------------
-- HIDE ORIGINAL CIRCLES
--------------------------------------------------

for _, circle in ipairs(Circles) do

    circle.Visible = false

end

--------------------------------------------------
-- CREATE EXPLOSION
--------------------------------------------------

for i = 1, EXPLOSION_PARTICLES do

    CreateParticle()

    if i % 5 == 0 then

        task.wait()

    end
end

--------------------------------------------------
-- SHOW HUB BUTTON AT EXPLOSION
--------------------------------------------------

HubButton.AnchorPoint =
    Vector2.new(
        0.5,
        0.5
    )

HubButton.Position =
    UDim2.fromOffset(
        targetPosition.X,
        targetPosition.Y
    )

--------------------------------------------------
-- HUB BUTTON START STATE
--------------------------------------------------

HubButton.BackgroundTransparency =
    1

HubButton.TextTransparency =
    1

HubButton.Visible =
    true

--------------------------------------------------
-- HUB STROKE
--------------------------------------------------

local HubStroke =
    HubButton:FindFirstChild(
        "HubCircleStroke"
    )

if HubStroke then

    HubStroke.Transparency =
        1

end

--------------------------------------------------
-- HUB BUTTON APPEAR
--------------------------------------------------

local hubTween =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            BackgroundTransparency =
                0.18,

            TextTransparency =
                0
        }
    )

hubTween:Play()

--------------------------------------------------
-- STROKE APPEAR
--------------------------------------------------

if HubStroke then

    local strokeTween =
        TweenService:Create(
            HubStroke,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Transparency =
                    0.45
            }
        )

    strokeTween:Play()
end

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

task.delay(
    PARTICLE_TIME + 0.2,
    function()

        for _, circle in ipairs(Circles) do

            if circle then

                pcall(function()
                    circle:Destroy()
                end)

            end
        end

        if AnimationGui then

            pcall(function()
                AnimationGui:Destroy()
            end)

        end
    end
)

--------------------------------------------------
-- FINISHED
--------------------------------------------------

_G.CustomHubLoadAnimationFinished =
    true
